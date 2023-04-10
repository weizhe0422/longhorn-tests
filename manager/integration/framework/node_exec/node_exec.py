from kubernetes import client
from kubernetes.stream import stream
from utility import Utility

import time
import boto3

DEFAULT_POD_TIMEOUT = 180
DEFAULT_POD_INTERVAL = 1

EC2_RESOURCE = boto3.resource('ec2')

class NodeExec:

    def __init__(self, namespace):
        self.namespace = namespace
        self.core_api = client.CoreV1Api()
        self.node_exec_pod = {}
        namespace_manifest = {
            'apiVersion': 'v1',
            'kind': 'Namespace',
            'metadata': {
                'name': self.namespace
            }
        }
        self.core_api.create_namespace(
            body=namespace_manifest
        )

    def cleanup(self):
        for pod in self.node_exec_pod.values():
            res = self.core_api.delete_namespaced_pod(
                name=pod.metadata.name,
                namespace=self.namespace,
                body=client.V1DeleteOptions()
            )
            print(res)
        self.core_api.delete_namespace(
            name=self.namespace
        )

    def issue_cmd(self, node_name, cmd):
        pod = self.launch_pod(node_name)
        exec_command = [
            'nsenter',
            '--mount=/rootfs/proc/1/ns/mnt',
            '--',
            'sh',
            '-c',
            cmd
        ]
        res = stream(
            self.core_api.connect_get_namespaced_pod_exec,
            pod.metadata.name,
            self.namespace,
            command=exec_command,
            stderr=True,
            stdin=False,
            stdout=True,
            tty=False
        )
        return res

    def launch_pod(self, node_name):
        if node_name in self.node_exec_pod:
            return self.node_exec_pod[node_name]
        else:
            pod_manifest = {
                'apiVersion': 'v1',
                'kind': 'Pod',
                'metadata': {
                    'name': node_name
                },
                'spec': {
                    'affinity': {
                        'nodeAffinity': {
                            'requiredDuringSchedulingIgnoredDuringExecution': {
                                'nodeSelectorTerms': [{
                                    'matchExpressions': [{
                                        'key': 'kubernetes.io/hostname',
                                        'operator': 'In',
                                        'values': [
                                            node_name
                                        ]
                                    }]
                                }]
                            }
                        }
                    },
                    'containers': [{
                        'image': 'busybox:1.34.0',
                        'imagePullPolicy': 'IfNotPresent',
                        'securityContext': {
                            'privileged': True
                        },
                        'name': 'node-exec',
                        "args": [
                            "tail", "-f", "/dev/null"
                        ],
                        "volumeMounts": [{
                            'name': 'rootfs',
                            'mountPath': '/rootfs',
                            'readOnly': True
                        }],
                    }],
                    'volumes': [{
                        'name': 'rootfs',
                        'hostPath': {
                            'path': '/'
                        }
                    }]
                }
            }
            pod = self.core_api.create_namespaced_pod(
                body=pod_manifest,
                namespace=self.namespace
            )
            for i in range(DEFAULT_POD_TIMEOUT):
                pod = self.core_api.read_namespaced_pod(
                        name=node_name,
                        namespace=self.namespace
                      )
                if pod is not None and pod.status.phase == 'Running':
                    break
                time.sleep(DEFAULT_POD_INTERVAL)
            self.node_exec_pod[node_name] = pod
            return pod

    def get_node_instance(self, node_name):
        print(f"Get node: {node_name}'s instance")
        return EC2_RESOURCE.instances.filter(
                        Filters=[
                            {
                                'Name': 'tag:Name',
                                'Values': [
                                    node_name
                                ]
                            }
                        ]
                    )
        
    def power_off_node_instance(self, node_name):
        # Utility().ssh(node_name, 'shutdown -h now')
        node_instances = self.get_node_instance(node_name)
        for instance in node_instances:
            instance.stop()
            print(f'Stopping EC2 instance:', {node_name})
            instance.wait_until_stopped()
            print(f'EC2 instance "{node_name}" has been stopped')


    def get_node_state(self, node_name):
        client = Utility().get_k8s_core_api_client()
        node_status = client.read_node_status(node_name)
        for node_cond in node_status.status.conditions:
            print(f"node_cond.type:{node_cond.type}, node_cond.status:{node_cond.status}")
            if node_cond.type == "Ready" and \
                node_cond.status == "True":
                 return node_cond.type
        return "NotReady"