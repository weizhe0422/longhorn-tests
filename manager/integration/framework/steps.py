from volume import Volume
from utility import Utility
from nodes import Nodes
from node_exec import NodeExec

class steps:

    ROBOT_LIBRARY_SCOPE = 'TEST'

    def __init__(self):
        Utility().init_k8s_api_client()


    def set_test_name(self, test_name):
        self.namespace = test_name.lower().replace(' ', '-')
        self.node_exec = NodeExec(self.namespace)
        self.volume = Volume(self.node_exec)


    def create_volume(self, size, replica_count, volume_type='RWO'):
        print('create_volume')
        volume_name = Utility().generate_volume_name()
        self.volume.create(volume_name, size, replica_count, volume_type)
        return volume_name


    def attach_volume(self, volume_name, attached_node_index=0):
        print('attach_volume')
        node_name = Nodes().get_by_index(attached_node_index)
        self.volume.attach(volume_name, node_name)
        return node_name


    def write_volume_random_data(self, volume_name, size_in_mb):
        print('write_volume_random_data')
        return self.volume.write_random_data(volume_name, size_in_mb)


    def check_data(self, volume_name, checksum):
        print(f"check volume {volume_name} data with checksum {checksum}")
        self.volume.check_data(volume_name, checksum)


    def delete_replica(self, volume_name, replica_index):
        replica_node_name = Nodes().get_by_index(int(replica_index))
        print(f"delete volume {volume_name}'s replica\
                {replica_index} {replica_node_name}")
        self.volume.delete_replica(volume_name, replica_node_name)


    def wait_for_replica_rebuilding_start(self, volume_name, replica_index):
        replica_node_name = Nodes().get_by_index(int(replica_index))
        print(f"wait for  volume {volume_name}'s replica\
                {replica_index} {replica_node_name} rebuilding started")
        self.volume.wait_for_replica_rebuilding_start(
            volume_name,
            replica_node_name
        )


    def wait_for_replica_rebuilding_complete(self, volume_name, replica_index):
        replica_node_name = Nodes().get_by_index(int(replica_index))
        print(f"wait for  volume {volume_name}'s replica\
                {replica_index} {replica_node_name} rebuilding completed")
        self.volume.wait_for_replica_rebuilding_complete(
            volume_name,
            replica_node_name
        )


    def cleanup_resources(self):
        print('cleanup_resources')
        self.node_exec.cleanup()
    
    def power_off_node_instance(self, node_name):
        print(f"power off node instance: {node_name}")
        if node_name == "":
            return print(f"failed: node_name: {node_name} is empty")
        
        self.node_exec.power_off_node_instance(node_name=node_name)
        
    def get_node_state(self, node_name):
        print(f"get node: {node_name}'s state")
        if node_name == "":
            return print(f"failed: node_name: {node_name} is empty")
        
        return self.node_exec.get_node_state(node_name)
        
    def get_volume_state(self, volume_name):
        print(f"get volume: {volume_name}'s state")
        if volume_name == "":
            return print(f"failed: volume_name: {volume_name} is empty")        
        return self.volume.get(volume_name)
    
    def get_engine_state(self, volume_name, node_name):
        print(f"get volume: {volume_name}'s engine state")
        if volume_name == "" or node_name == "":
            return print(f"failed: volume_name: {volume_name} or node_name: {node_name} is empty")
        return self.volume.get_engine(volume_name, node_name)
           
    def get_replica_state(self, volume_name, node_name):
        print(f"get volume: {volume_name} on {node_name}'s replica state")
        if volume_name == "" or node_name == "":
            return print(f"failed: volume_name: {volume_name} or node_name: {node_name} is empty")
        return self.volume.get_replica(volume_name, node_name)
        
    def check_workload_state(self, work_type, current_state, expect_state):
        if len(current_state) <= 0 or expect_state == "":
            return False
        
        for idx in len(current_state):
            if work_type == "replica" or work_type == "engine":
               if current_state[idx].status.currentState != expect_state:
                   return False
        return True