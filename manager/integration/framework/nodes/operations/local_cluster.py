from nodes.operations.abstract_cloud_provider import AbstractCloudProvider

class LocalCluster(AbstractCloudProvider):
    def __init__(self) -> None:
        super().__init__()
    
    def get_all_node_instances(self):
        raise NotImplemented
    
    def get_node_instance(self, node_name):
        raise NotImplemented
        
    def reboot_node_instance(self, node_name):
        raise NotImplemented
    
    # Not supported
    def power_off_node_instance(self, node_name):
        raise NotImplemented
    
    def power_on_node_instance(self, node_name=""):
        raise NotImplemented
    
