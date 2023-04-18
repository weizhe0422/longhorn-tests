from kubernetes import client
from kubernetes.stream import stream

from utility import Utility, globals
from strategy import CloudProvider
from node_exec.aws import EC2

import time

DEFAULT_POD_TIMEOUT = 180
DEFAULT_POD_INTERVAL = 1

class NodeExec:

    _instance = None

    def __init__(self, namespace, cloud_provider):
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
        if cloud_provider == CloudProvider.AWS.value:
            print("NodeExec: Cloud Provider: AWS")
            self._instance = EC2()

    def cleanup(self):
        print("Clean node related resources")
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
        # Turn the power off node back
        self._instance.power_on_node_instance()

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
    
    def power_off_node(self, node_name):
        self._instance.power_off_node_instance(node_name)
    
    def power_on_node(self, node_name):
        self._instance.power_on_node_instance(node_name)

    def restart_kubelet(self, node_name, interval_time):
        if node_name == "":
            print("Restart kubelet on all of node instances")
            node_instances = self.get_all_node_instances()
        else:
            print(f"Restart kubelet on node instances: {node_name}")
            node_instances = self.get_node_instance(node_name)

        if globals.K8S_DISTRO == 'RKE2':
            stopCmd = 'sudo systemctl stop rke2-server.service'
            startCmd = 'sudo systemctl start rke2-server.service'
        elif globals.K8S_DISTRO == 'RKE1':
            stopCmd = 'sudo docker stop kubelet'
            startCmd = 'sudo docker run kubelet'
        else:
            raise Exception(f'Unsupported K8S distros: {globals.K8S_DISTRO}')
            

        for instance in node_instances: 
            ip_address = instance.public_ip_address
            print(f'ip_address:{ip_address}, cmd:{stopCmd}')
            Utility().ssh_and_exec_cmd(ip_address, stopCmd)
            
        time.sleep(int(interval_time))

        for instance in node_instances: 
            ip_address = instance.public_ip_address
            print(f'ip_address:{ip_address}, cmd:{startCmd}')
            Utility().ssh_and_exec_cmd(ip_address, startCmd)  

    def disconnect_network(self, node_name, interval_time):
        if node_name == "":
            print("Restart kubelet on all of node instances")
            node_instances = self.get_all_node_instances()
        else:
            print(f"Restart kubelet on node instances: {node_name}")
            node_instances = self.get_node_instance(node_name)

        iptable_commands = ['sudo iptables -P INPUT {ACTION}',
                            'sudo iptables -P FORWARD {ACTION}',
                            'sudo iptables -P OUTPUT {ACTION}']
        execute_commands = []
        execute_commands.extend(list(map(lambda x:x.format(ACTION='DROP'), iptable_commands)))
        execute_commands.append(f'sudo sleep {interval_time}')
        execute_commands.extend(list(map(lambda x:x.format(ACTION='ACCEPT'), iptable_commands)))
        
        # Drop network traffic
        for instance in node_instances: 
            ip_address = instance.public_ip_address
            print(f'drop {ip_address} network')
            Utility().ssh_and_exec_cmd(ip_address, '\n'.join(execute_commands))  