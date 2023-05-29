from node.operations.abstract_cloud_provider import AbstractCloudProvider

from node import Nodes
import boto3

class EC2(AbstractCloudProvider):

    _ec2_instance = boto3.resource('ec2')

    def __init__(self) -> None:
        super().__init__()

    def get_all_node_instances(self):
        result = []
        for node in Nodes.all_nodes:
            instances = self.get_node_instance(node['name'])
            result.append(instances)
        return result

    def get_node_instance(self, node_name):
        print(f"Get node: {node_name}'s instance")

        for node in Nodes.all_nodes:
            if node['name'] == node_name:
                ip_address = node['ip_address']
        if ip_address == "":
            raise Exception(f"{node_name}'s ip address is empty")

        filter = [{'Name': 'ip-address','Values': [ip_address]}]
        instances = self._ec2_instance.instances.filter(Filters=filter)
        if len(list(instances)) > 0:
            return instances

        filter = [{'Name': 'private-ip-address','Values': [ip_address]}]
        instances = self._ec2_instance.instances.filter(Filters=filter)
        return instances


    def reboot_node_instance(self, node_name):
        node_instances = self.get_node_instance(node_name)
        for instance in node_instances:
            instance.reboot()
            print(f'EC2 instance has beend rebooted:', {node_name})
            instance.wait_until_running()
            print(f'EC2 instance "{node_name}" has been running')

    def terminate_node_instance(self, node_name):
        node_instances = self.get_node_instance(node_name)
        for instance in node_instances:
            instance.terminate()
            print(f'Terminate EC2 instance:', {node_name})
            instance.wait_until_terminated()
            print(f'EC2 instance "{node_name}" has been terminated')


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
            instancesCollect = self.get_all_node_instances()
            for instances in instancesCollect:
                for instance in instances:
                    print(f'node_instances: {instance.id}')
                    if instance.state["Name"] != "running":
                        instance.start()
                        print(f'Starting EC2 instance:', {node_name})
                        instance.wait_until_running()
                        print(f'EC2 instance "{node_name}" has been running')
        else:
            print(f"Power on node instances: {node_name}")
            instances = self.get_node_instance(node_name)
            for instance in instances:
                print(f'node_instances: {instance}')
                if instance.state["Name"] != "running":
                    instance.start()
                    print(f'Starting EC2 instance:', {node_name})
                    instance.wait_until_running()
                    print(f'EC2 instance "{node_name}" has been running')
