import time

from strategy import CloudProvider
from nodes.operations.aws import EC2
from nodes.operations.local_cluster import LocalCluster
from utility import Utility, globals

class Operations:
    
    _instance = None

    def __init__(self, cloud_provider):
        if cloud_provider == CloudProvider.AWS.value:
            print("Cloud Provider: AWS")
            self._instance = EC2()
        elif cloud_provider == CloudProvider.LOCAL_CLUSTER.value:
            print("Cloud Provider: LOCAL_CLUSTER")
            self._instance = LocalCluster()

    def cleanup(self):
        # Turn the power off node back
        self._instance.power_on_node_instance()

    def power_off_node(self, node_name):
        self._instance.power_off_node_instance(node_name)
    
    def power_on_node(self, node_name):
        self._instance.power_on_node_instance(node_name)

    def reboot_node(self, node_name):
        self._instance.reboot_node_instance(node_name)
        
    def restart_kubelet(self, node_name, interval_time):
        if node_name == "":
            raise Exception("failed with empty parameter value: node_name")
        else:
            print(f"Restart kubelet on node instances: {node_name}")
            node_instances = self._instance.get_node_instance(node_name)
            
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
            raise Exception("failed with empty parameter value: node_name")
        else:
            print(f"Restart kubelet on node instances: {node_name}")
            node_instances = self._instance.get_node_instance(node_name)

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