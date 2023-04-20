from kubernetes import client
from utility import Utility 
class Nodes:

    _instance = None

    def __new__(cls, *args, **kwargs):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
        return cls._instance

    def __init__(self):
        self.core_api = client.CoreV1Api()

    def get(self):
        obj = self.core_api.list_node()
        nodes = []
        for item in obj.items:
            if 'node-role.kubernetes.io/control-plane' not in item.metadata.labels and \
                    'node-role.kubernetes.io/master' not in item.metadata.labels:
                nodes.append(item.metadata.name)
            if 'node-role.kubernetes.io/worker' in item.metadata.labels and \
                item.metadata.labels['node-role.kubernetes.io/worker'] == 'true':
                nodes.append(item.metadata.name)
        return sorted(nodes)

    def get_by_index(self, index):
        nodes = self.get()
        return nodes[index]

    def get_index_by_name(self, node_name):
        nodes = self.get()
        
        idx = 0
        for node in nodes:
            if node == node_name:
                return idx
            else:
                idx += 1 

    def get_node_state(self, node_name):
        client = Utility().get_k8s_core_api_client()
        node_status = client.read_node_status(node_name)
        for node_cond in node_status.status.conditions:
            print(f"node_cond.type:{node_cond.type}, node_cond.status:{node_cond.status}")
            if node_cond.type == "Ready" and \
                node_cond.status == "True":
                 return node_cond.type
        return "NotReady"