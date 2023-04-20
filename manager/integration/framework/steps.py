import time

from volume import Volume
from utility import Utility, globals
from nodes import Nodes, Operations
from node_exec import NodeExec

class steps:

    ROBOT_LIBRARY_SCOPE = 'TEST'

    def __init__(self):
        return

    def set_test_environment(self, test_name):
        Utility.init_k8s_api_client()
        globals.initialize_variables()
        Utility.refresh_node_list()
        
        print(f"cloud_provider:{globals.CLOUD_PROVIDER}")
        self.namespace = test_name.lower().replace(' ', '-')
        self.node_exec = NodeExec(self.namespace)
        self.volume = Volume(self.node_exec)
        self.node_operation = Operations(globals.CLOUD_PROVIDER)


    def create_volume(self, size, replica_count, volume_type='RWO'):
        print('create_volume')
        volume_name = Utility.generate_volume_name()
        self.volume.create(volume_name, size, replica_count, volume_type)
        return volume_name


    def attach_volume(self, volume_name, node_index=0):
        print('attach_volume')
        node_name = Nodes.get_name_by_index(int(node_index))
        print(f'target node name:{node_name}')
        self.volume.attach(volume_name, node_name)
        return node_name

    def attach_volume_without_replica(self, volume_name):
        print('attach_volume_without_replica')
        node_index = self.get_no_replica_node(volume_name)
        
        if node_index != None:
            self.attach_volume(volume_name, node_index)
        else:
            raise Exception("can not find node without replica")
    
    def get_non_volunme_attached_node(self, attached_node_name):
        print('get_non_volunme_attached_node')
        nodes = Nodes.all_nodes
        for node in nodes:
            if node['name'] != attached_node_name:
                print(f'Non volunme attached nod:{node}')
                return node['name']

    def write_volume_random_data(self, volume_name, size_in_mb):
        print('write_volume_random_data')
        return self.volume.write_random_data(volume_name, size_in_mb)


    def check_data(self, volume_name, checksum):
        print(f"check volume {volume_name} data with checksum {checksum}")
        self.volume.check_data(volume_name, checksum)


    def delete_replica(self, volume_name, replica_index):
        replica_node_name = Nodes.get_name_by_index(int(replica_index))
        print(f"delete volume {volume_name}'s replica\
                {replica_index} {replica_node_name}")
        self.volume.delete_replica(volume_name, replica_node_name)


    def wait_for_replica_rebuilding_start(self, volume_name, replica_index):
        replica_node_name = Nodes.get_name_by_index(int(replica_index))
        print(f"wait for  volume {volume_name}'s replica\
                {replica_index} {replica_node_name} rebuilding started")
        self.volume.wait_for_replica_rebuilding_start(
            volume_name,
            replica_node_name
        )


    def wait_for_replica_rebuilding_complete(self, volume_name, replica_index):
        replica_node_name = Nodes.get_name_by_index(int(replica_index))
        print(f"wait for  volume {volume_name}'s replica\
                {replica_index} {replica_node_name} rebuilding completed")
        self.volume.wait_for_replica_rebuilding_complete(
            volume_name,
            replica_node_name
        )

    def cleanup_resources(self):
        print('cleanup_resources')
        self.node_exec.cleanup()
        self.node_operation.cleanup()
        self.volume.clean_up()
    
    def power_off_node(self, node_index=0):
        print(f"powering off node instance: {node_index}")
        node_name = Nodes.get_by_get_name_by_indexindex(int(node_index))
        if node_name == "":
            return print(f"failed: node_name: {node_name} is empty")
        self.node_operation.power_off_node(node_name=node_name)

    def power_on_node(self, node_index=0):
        print(f"powering on node instance: {node_index}")
        node_name = Nodes.get_name_by_index(int(node_index))
        if node_name == "":
            return print(f"failed: node_name: {node_name} is empty")
        self.node_operation.power_on_node(node_name=node_name)

    def get_node_state(self, node_index=0):
        print(f"get node {node_index} state")
        node_name = Nodes.get_name_by_index(int(node_index))
        if node_name == "":
            return print(f"failed: node_name: {node_name} is empty")
        
        return Nodes.get_node_state(node_name)
        
    def get_volume_state(self, volume_name):
        print(f"get volume: {volume_name}'s state")
        if volume_name == "":
            return print(f"failed: volume_name: {volume_name} is empty")        
        return self.volume.get_volume_state(volume_name)
    
    def get_engine_state(self, volume_name, node_name):
        print(f"get volume: {volume_name}'s engine state")
        if volume_name == "" or node_name == "":
            return print(f"failed: volume_name: {volume_name} or node_name: {node_name} is empty")
        engines = self.volume.get_engine(volume_name, node_name)
        print(f"engines:{engines}")
        engines_states = {}
        for engine in engines["items"]:
            engines_states[engine["metadata"]["name"]]=engine['status']['currentState']
        return engines_states
           
    def get_replica_state(self, volume_name, node_index):
        print(f"get volume: {volume_name} on Node {node_index} replica state")
        node_name = Nodes.get_name_by_index(int(node_index))
        if volume_name == "" or node_name == "":
            return Exception(f"failed: volume_name: {volume_name} or node_name: {node_name} is empty")
        replicas = self.volume.get_replica(volume_name, node_name)
        replicas_states = {}
        for replica in replicas["items"]:
            replicas_states[replica["metadata"]["name"]]=replica['status']['currentState']
        return replicas_states
        
    def check_workload_state(self, current_states, expect_state):        
        print(f"current state: {current_states}, expect state: {expect_state}")
        if current_states == None or expect_state == "":
            raise Exception(f'input parameters are empty: current_states={current_states}, expect_state={expect_state}')
        for state in current_states:
            if current_states[state] != expect_state:
                raise Exception(f'name: {state}: {current_states[state]} != {expect_state}')
    
    def reboot_node(self, node_index):
        print("reboot_node")
        node_name = Nodes.get_name_by_index(node_index)
        print(f'target node name: {node_name}')
        self.node_operation.reboot_node(node_name)
        
    def restart_kubelet(self, node_index, interval_time):
        node_name = Nodes.get_name_by_index(node_index)
        print(f'target node name: {node_name}')
        self.node_operation.restart_kubelet(node_name, interval_time)

    def disconnect_network(self, node_name, interval_time):
        self.node_operation.disconnect_network(node_name, interval_time)

    def wait_with_time_interval(self, time_interval):
        time.sleep(int(time_interval))

    def get_no_replica_node(self, volume_name, expected_replica_count):
        nodes = Nodes.all_nodes
        
        current_replica_count = 0
        count = 1
        while expected_replica_count != current_replica_count and count <= 180:
            replicas = self.volume.get_replica(volume_name,"")
            print(f'replicas: {replicas}')
            current_replica_count = len(replicas)
            count += 1
            
        # get the node without replica on it
        no_replica_nodes = []
        for node in nodes:
            node_name = node['name']
            print(f'volume_name:{volume_name}, node:{node_name}')
            replica = self.volume.get_replica(volume_name, node_name)
            print(f'replica:{replica["items"]}, type: {type(replica["items"])}')       
            if len(replica["items"]) == 0:
                print(f'node without replica: {node_name}')
                no_replica_nodes.append(Nodes.get_index_by_name(node_name))
        
        if len(no_replica_nodes) == 0:
            raise Exception(f"can not find node without replica: {node_name}")
        
        return no_replica_nodes
        
    
    def get_with_replica_node(self, volume_name, expected_replica_count):
        nodes = Nodes.all_nodes
        # get the node with replica on it
        
        current_replica_count = 0
        count = 1
        while expected_replica_count != current_replica_count and count <= 180:
            replicas = self.volume.get_replica(volume_name,"")
            print(f'replicas: {replicas}')
            current_replica_count = len(replicas)
            count += 1
        
        
        with_replica_nodes = []
        for node in nodes:
            node_name = node['name']
            print(f'volume_name:{volume_name}, node:{node_name}')
            replica = self.volume.get_replica(volume_name, node_name)
            print(f'full replica:{replica}')
            print(f'replica:{replica["items"]}, type: {type(replica["items"])}')       
            if len(replica["items"]) != 0:
                print(f'node with replica: {node_name}')
                with_replica_nodes.append(Nodes.get_index_by_name(node_name))
                
        if len(with_replica_nodes) == 0:
            raise Exception(f"can not find node with replica: {node_name}")
        
        print(f'with_replica_nodes: {with_replica_nodes}')
        return with_replica_nodes