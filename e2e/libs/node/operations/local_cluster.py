from node.operations.abstract_cloud_provider import AbstractCloudProvider
from node import Nodes
from utility import Utility

class LocalCluster(AbstractCloudProvider):
    def __init__(self) -> None:
        super().__init__()
    
    def get_all_node_instances(self):
        Nodes.refresh_node_list()
        return Nodes.all_nodes
    
    def get_node_instance(self, node_name):
        for instance in Nodes.all_nodes:
            if instance['name'] == node_name:
                return instance

        raise Exception(f"can not find {node_name} instance")
        
    def reboot_node_instance(self, node_name):
        node_instances = self.get_node_instance(node_name)

        reboot_cmd = 'sudo systemctl reboot'
        ip_address = node_instances["ip_address"]
        print(f'ip_address:{ip_address}, cmd:{reboot_cmd}')
        Utility.ssh_and_exec_cmd(ip_address, reboot_cmd) 

    
    # Not supported
    def power_off_node_instance(self, node_name):
        print('NotImplemented')

    # Not supported    
    def power_on_node_instance(self, node_name=""):
        print('NotImplemented')
    
    def terminate_node_instance(self, node_name=""):
        print('NotImplemented')
