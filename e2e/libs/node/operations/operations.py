import time
import datetime

from strategy import CloudProvider
from node.operations.aws import EC2
from node.operations.local_cluster import LocalCluster
from utility import globals, Utility

class Operations:
    
    _instance = None

    def __init__(self, cloud_provider):
        if cloud_provider == CloudProvider.AWS.value:
            print("Cloud Provider: AWS")
            self.__class__._instance  = EC2()
        elif cloud_provider == CloudProvider.LOCAL_CLUSTER.value:
            print("Cloud Provider: LOCAL_CLUSTER")
            self.__class__._instance = LocalCluster()

    @classmethod
    def cleanup(cls):
        # Turn the power off node back
        cls._instance.power_on_node_instance()
    
    @classmethod
    def power_off_node(cls, node_name):
        cls._instance.power_off_node_instance(node_name)
    
    @classmethod
    def power_on_node(cls, node_name):
        cls._instance.power_on_node_instance(node_name)

    @classmethod
    def reboot_node(cls, node_name):
        cls._instance.reboot_node_instance(node_name)
    
    @classmethod
    def restart_kubelet(cls, node_name, interval_time):
        if node_name == "":
            raise Exception("failed with empty parameter value: node_name")
        else:
            print(f"Restart kubelet on node instances: {node_name}")
            node_instances = cls._instance.get_node_instance(node_name)
            
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
            Utility.ssh_and_exec_cmd(ip_address, stopCmd)
            
        time.sleep(int(interval_time))

        for instance in node_instances: 
            ip_address = instance.public_ip_address
            print(f'ip_address:{ip_address}, cmd:{startCmd}')
            Utility.ssh_and_exec_cmd(ip_address, startCmd)  
    
    @classmethod 
    def network_operate_commands(cls, action):
        iptable_commands = ['sudo iptables -P INPUT {ACTION}',
                            'sudo iptables -P FORWARD {ACTION}',
                            'sudo iptables -P OUTPUT {ACTION}']
        return list(map(lambda x:x.format(ACTION=action), iptable_commands))       
    
    @classmethod        
    def disconnect_network(cls, node_name):
        print(f'disconnect_network: {node_name}')
        if node_name == "":
            raise Exception("failed with empty parameter value: node_name")
        else:
            print(f"Drop network on node instances: {node_name}")
            node_instances = cls._instance.get_node_instance(node_name)

        execute_commands = cls.network_operate_commands('DROP')

        # Drop network traffic 
        ip_address = node_instances['ip_address']
        print(f'drop {ip_address} network')
        Utility.ssh_and_exec_cmd(ip_address, '\n'.join(execute_commands))

    @classmethod
    def connect_network(cls, node_name):
        print(f'connect_network: {node_name}')
        if node_name == "":
            raise Exception("failed with empty parameter value: node_name")
        else:
            print(f"Accept network on node instances: {node_name}")
            node_instances = cls._instance.get_node_instance(node_name)

        execute_commands = cls.network_operate_commands('ACCEPT')
                
        # Accept network traffic
        ip_address = node_instances['ip_address']
        print(f'accept {ip_address} network')
        Utility.ssh_and_exec_cmd(ip_address, '\n'.join(execute_commands))
        
    @classmethod
    def interrupt_network(cls, node_name, time_interval):
        print(f'[{datetime.datetime.now()}] interrupt_network: {node_name} for {time_interval} seconds')
        if node_name == "":
            raise Exception("failed with empty parameter value: node_name")
        else:
            print(f"[{datetime.datetime.now()}] Interrupt network on node instances: {node_name}")
            node_instances = cls._instance.get_node_instance(node_name)
        
        execute_commands = cls.network_operate_commands('DROP')
        execute_commands.extend(['sudo sleep 100'])
        execute_commands.extend(cls.network_operate_commands('ACCEPT'))
        
        ip_address = node_instances['ip_address']
        print(f'[{datetime.datetime.now()}] interrupt {ip_address} network')
        Utility.ssh_and_exec_cmd(ip_address, '\n'.join(execute_commands))        
