from node_exec.abstract_cloud_provider import AbstractCloudProvider

import boto3

class EC2(AbstractCloudProvider):

    _ec2_instance = boto3.resource('ec2')

    def __init__(self) -> None:
        super().__init__()
    
    def get_all_node_instances(self):
        return self._ec2_instance.instances.all()
    
    def get_node_instance(self, node_name):
        print(f"Get node: {node_name}'s instance")
        return self._ec2_instance.instances.filter(
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
        node_instances = self.get_node_instance(node_name)
        for instance in node_instances:
            instance.stop()
            print(f'Stopping EC2 instance:', {node_name})
            instance.wait_until_stopped()
            print(f'EC2 instance "{node_name}" has been stopped')
    
    def power_on_node_instance(self, node_name=""):
        if node_name == "":
            print("Power on all of node instances")
            node_instances = self.get_all_node_instances()
        else:
            print(f"Power on node instances: {node_name}")
            node_instances = self.get_node_instance(node_name)

        for instance in node_instances:
            if instance.state["Name"] != "running":
                instance.start()
                print(f'Starting EC2 instance:', {node_name})
                instance.wait_until_running()
                print(f'EC2 instance "{node_name}" has been running')
