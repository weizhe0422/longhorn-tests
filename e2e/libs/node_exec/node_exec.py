import time

from kubernetes import client
from kubernetes.stream import stream
from kubernetes.client.rest import ApiException

DEFAULT_POD_TIMEOUT = 180
DEFAULT_POD_INTERVAL = 1

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
        print("Clean node related resources")
        
        api_client = client.CoreV1Api()
        
        for pod in self.node_exec_pod.values():
            try:
                res_del_ns_pod = api_client.delete_namespaced_pod(
                                        name=pod.metadata.name,
                                        namespace=self.namespace,
                                        body=client.V1DeleteOptions()
                                    )
                print(f'delete pod {pod.metadata.name} result: {res_del_ns_pod}')
                
            except ApiException as e:
                print("delete pod {pod.metadata.name} exception: %s\n" % e)
        
        try:    
            res_del_ns = api_client.delete_namespace(
                                name=self.namespace
                            )
            print(f'delete namespace {self.namespace} result: {res_del_ns}')
        except ApiException as e:
            print("delete namespace exception: %s\n" % e)     

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
    