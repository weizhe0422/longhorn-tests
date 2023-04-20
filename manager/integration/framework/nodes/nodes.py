from utility import globals
class Nodes:

    _core_api = None
    _instance = None
    all_nodes = []
    
    def __new__(cls, *args, **kwargs):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
        return cls._instance

    def __init__(self, name, public_ip = ""):
        self._name = name
        self._public_ip = public_ip
        self.__class__.all_nodes.append({'name': name,
                                         'ip_address': public_ip})

    @property    
    def name(self):
        return self.name
            
    @property    
    def public_ip(self):
        return self._public_ip
    
    @public_ip.setter
    def public_ip(self, value):
        self._public_ip = value
        
    @classmethod
    def get_name_by_index(cls, index):
        print(f'get_by_index: {index}')
        
        if int(index) < 0 or int(index) > len(cls.all_nodes):
             raise Exception(f"invalid parameter: index={index}")
        
        print(f'cls.all_nodes: {cls.all_nodes}')
        return cls.all_nodes[int(index)]['name']
    
    @classmethod
    def get_index_by_name(cls, node_name):
        index = 0
        for node in cls.all_nodes:
            if node["name"] == node_name:
                return index
            index += 1
            
        raise Exception(f"failed to get index by node name {node_name}")

    @classmethod
    def get_node_state(cls, node_name):
        client = globals.K8S_API_CLIENT
        node_status = client.read_node_status(node_name)
        for node_cond in node_status.status.conditions:
            print(f"node_cond.type:{node_cond.type}, node_cond.status:{node_cond.status}")
            if node_cond.type == "Ready" and \
                node_cond.status == "True":
                 return node_cond.type
        return "NotReady"