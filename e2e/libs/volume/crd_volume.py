import os
import time
import warnings
import datetime

from volume.abstract_volume import AbstractVolume
from volume.rest_volume import RestVolume
from kubernetes import client
from kubernetes.client.rest import ApiException

Ki = 2**10
Mi = 2**20
Gi = 2**30

retry_count = 200
retry_interval = 1


class CRDVolume(AbstractVolume):

    def __init__(self, node_exec):
        self.obj_api = client.CustomObjectsApi()
        self.node_exec = node_exec

    def get(self, volume_name=""):
        volume = self.obj_api.get_namespaced_custom_object(
            group="longhorn.io",
            version="v1beta2",
            namespace="longhorn-system",
            plural="volumes",
            name=volume_name
        )
        return volume

    def delete(self, volume_name=""):
        volume_list = self.get(volume_name)
        print(f"volume_list:{volume_list}")
        for volume in volume_list['items']:
            print(f"delete volume {volume['metadata']['name']}")
            self.obj_api.delete_namespaced_custom_object(
                group="longhorn.io",
                version="v1beta2",
                namespace="longhorn-system",
                plural="volumes",
                name=volume['metadata']['name']
            )

    def create(self, volume_name, size, replica_count, volume_type):
        volume_body = {
            "apiVersion": "longhorn.io/v1beta2",
            "kind": "Volume",
            "metadata": {"name": volume_name},
            "spec": {
                "frontend": "blockdev",
                "replicaAutoBalance": "ignored",
                "size": str(int(size) * Gi),
                "numberOfReplicas": int(replica_count),
                "accessMode": volume_type.lower()
            }
        }
        self.obj_api.create_namespaced_custom_object(
            group="longhorn.io",
            version="v1beta2",
            namespace="longhorn-system",
            plural="volumes",
            body=volume_body
        )


    def attach(self, volume_name, node_name):
        self.obj_api.patch_namespaced_custom_object(
            group="longhorn.io",
            version="v1beta2",
            namespace="longhorn-system",
            plural="volumes",
            name=volume_name,
            body={
                    "spec": {
                        "nodeID": node_name
                    }
                }
        )
        
        try:
            self.obj_api.patch_namespaced_custom_object(
                group="longhorn.io",
                version="v1beta2",
                namespace="longhorn-system",
                plural="volumeattachments",
                name=volume_name,
                body={
                        "spec": {
                            "attachmentTickets": {
                                "": {
                                    "generation": 0,
                                    "id": "",
                                    "nodeID": node_name,
                                    "parameters": {
                                        "disableFrontend": "false",
                                        "lastAttachedBy": ""
                                    },
                                    "type": "longhorn-api"
                                }
                            }
                        }
                    }
            )
        except ApiException as e:
            if e.reason == "Not Found":
                print(f'not support volumeattachments:', e)
            else:
                Exception(f'exception for creating volumeattachments:', e)
               
        self.wait_for_volume_state(volume_name, "attached")

    def get_node_without_replica(self, volume_name):
        replicas = self.get_replica(volume_name)
        

    def wait_for_volume_state(self, volume_name, desired_state):
        print(self.get(volume_name)["status"]["state"])
        for i in range(retry_count):
            if self.get(volume_name)["status"]["state"] == desired_state:
                break
            time.sleep(retry_interval)
        assert self.get(volume_name)["status"]["state"] == desired_state

    def get_volume_state(self, volume_name):
        print(f"Get volume{volume_name}'s state")
        return self.get(volume_name)["status"]["robustness"]
    
    def get_endpoint(self, volume_name):
        warnings.warn("no endpoint in volume cr, get it from rest api")
        return RestVolume(self.node_exec).get_endpoint(volume_name)

    def write_random_data(self, volume_name, size):
        node_name = self.get(volume_name)["spec"]["nodeID"]
        endpoint = self.get_endpoint(volume_name)
        
        print(f'[{datetime.datetime.now()}] start to write data')
        checksum = self.node_exec.issue_cmd(
            node_name,
            f"dd if=/dev/urandom of={endpoint} bs=1M count={size} status=none;\
              md5sum {endpoint} | awk \'{{print $1}}\'")
        print(f'[{datetime.datetime.now()}] finishing write data')
        return checksum

    def get_replica(self, volume_name, node_name):
        label_selector=[]
        if volume_name!="":
            label_selector.append(f"longhornvolume={volume_name}")
        if node_name!="":
            label_selector.append(f"longhornnode={node_name}")

        str_label_selector=",".join(label_selector)
        print(f"label_selector={str_label_selector}")
        return self.obj_api.list_namespaced_custom_object(
            group="longhorn.io",
            version="v1beta2",
            namespace="longhorn-system",
            plural="replicas",
            label_selector=",".join(label_selector)
        )

    def delete_replica(self, volume_name, node_name):
        replica_list = self.get_replica(volume_name, node_name)
        print(f"replica_list:{replica_list}")
        for replica in replica_list['items']:
            print(f"delete replica {replica['metadata']['name']}")
            self.obj_api.delete_namespaced_custom_object(
                group="longhorn.io",
                version="v1beta2",
                namespace="longhorn-system",
                plural="replicas",
                name=replica['metadata']['name']
            )
        
    def get_engine(self, volume_name, node_name):
        label_selector=[]
        if volume_name!="":
            label_selector.append(f"longhornvolume={volume_name}")
        if node_name!="":
            label_selector.append(f"longhornnode={node_name}")

        print(f"label_selector={label_selector}")
        return self.obj_api.list_namespaced_custom_object(
            group="longhorn.io",
            version="v1beta2",
            namespace="longhorn-system",
            plural="engines",
            label_selector=",".join(label_selector)
        )
    
    def delete_engine(self, volume_name, node_name):
        engine_list = self.get_engine(volume_name, node_name)
        print(f"engine_list:{engine_list}")
        for engine in engine_list['items']:
            print(f"delete engine {engine['metadata']['name']}")
            self.obj_api.delete_namespaced_custom_object(
                group="longhorn.io",
                version="v1beta2",
                namespace="longhorn-system",
                plural="engines",
                name=engine['metadata']['name']
            )
    
    def wait_for_replica_rebuilding_start(self, volume_name, node_name):
        warnings.warn("no rebuild status in volume cr, get it from rest api")
        RestVolume(self.node_exec).wait_for_replica_rebuilding_start(volume_name, node_name)

    def wait_for_replica_rebuilding_complete(self, volume_name, node_name):
        warnings.warn("no rebuild status in volume cr, get it from rest api")
        RestVolume(self.node_exec).wait_for_replica_rebuilding_complete(
            volume_name,
            node_name
        )

    def check_data(self, volume_name, checksum):
        node_name = self.get(volume_name)["spec"]["nodeID"]
        endpoint = self.get_endpoint(volume_name)
        _checksum = self.node_exec.issue_cmd(
            node_name,
            f"md5sum {endpoint} | awk \'{{print $1}}\'")
        print(f"get {endpoint} checksum = {_checksum},\
                expected checksum = {checksum}")
        if _checksum != checksum:
            Exception(f"data was changed: {_checksum}/{checksum}")
