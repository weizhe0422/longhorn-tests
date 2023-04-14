*** Settings ***
Documentation     Test the resillence if cluster node happend exception
...
...               Keywords are imported from the resource file
Resource          keywords.resource
Test setup    set_test_environment    ${TEST NAME}
Test Teardown    cleanup_resources

*** Variable ***
${volume_size_gb}=    5
${POD_EVICTION_TIME_OUT}=    300

*** Test Cases ***    
RWO volume with replica on attached node and restart Kubelet on the volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWO volume with 3 replicas
    And Attach volume to the node
    When Write data into mount point
    And Restart Kubelet on the node ${volunme_attached_node}
    Then Volume state should be
    And Engine state should be
    And Replica state should be
    
RWO volume with replica on attached nod and restart Kubelet on the non volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWO volume with 3 replicas
    And Attach volume to the node
    When Write data into mount point
    And Restart Kubelet on the node ${non_volunme_attached_node}
    Then Volume state should be
    And Engine state should be
    And Replica state should be

RWO volume with no replica on attached node and Restart Kubelet on the volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 0
    When Write data into mount point
    And Restart Kubelet on the node ${volunme_attached_node}
    Then Volume state should be
    And Engine state should be
    And Replica state should be
    
RWO volume with no replica on attached node and restart Kubelet on the non volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 0
    When Write data into mount point
    And Restart Kubelet on the node ${non_volunme_attached_node}
    Then Volume state should be
    And Engine state should be
    And Replica state should be

RWO volume with no replica on attached node and Restart Kubelet on the volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 2
    When Write data into mount point
    And Restart Kubelet on the node ${volunme_attached_node}
    Then Volume state should be
    And Engine state should be
    And Replica state should be
    
RWO volume with no replica on attached node and restart Kubelet on the non volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 2
    When Write data into mount point
    And Restart Kubelet on the node ${non_volunme_attached_node}
    Then Volume state should be
    And Engine state should be
    And Replica state should be

RWO volume with replica on attached node and restart Kubelet on the volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWO volume with 3 replicas
    And Attach volume to the node
    When Write data into mount point
    And Restart Kubelet on the node ${volunme_attached_node}
    And Sleep ${POD_EVICTION_TIME_OUT} seconds
    Then Volume state should be
    And Engine state should be
    And Replica state should be
    
RWO volume with replica on attached nod and restart Kubelet on the non volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWO volume with 3 replicas
    And Attach volume to the node
    When Write data into mount point
    And Restart Kubelet on the node ${non_volunme_attached_node}
    And Sleep ${POD_EVICTION_TIME_OUT} seconds
    Then Volume state should be
    And Engine state should be
    And Replica state should be

RWO volume with no replica on attached node and Restart Kubelet on the volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 0
    When Write data into mount point
    And Restart Kubelet on the node ${volunme_attached_node}
    And Sleep ${POD_EVICTION_TIME_OUT} seconds
    Then Volume state should be
    And Engine state should be
    And Replica state should be
    
RWO volume with no replica on attached node and restart Kubelet on the non volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 9
    When Write data into mount point
    And Restart Kubelet on the node ${non_volunme_attached_node}
    And Sleep ${POD_EVICTION_TIME_OUT} seconds
    Then Volume state should be
    And Engine state should be
    And Replica state should be

RWO volume with no replica on attached node and Restart Kubelet on the volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 2
    When Write data into mount point
    And Restart Kubelet on the node ${volunme_attached_node}
    And Sleep ${POD_EVICTION_TIME_OUT} seconds
    Then Volume state should be
    And Engine state should be
    And Replica state should be
    
RWO volume with no replica on attached node and restart Kubelet on the non volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 2
    When Write data into mount point
    And Restart Kubelet on the node ${non_volunme_attached_node}
    And Sleep ${POD_EVICTION_TIME_OUT} seconds
    Then Volume state should be
    And Engine state should be
    And Replica state should be

RWX volume with replica on attached node and restart Kubelet on the volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWX volume with 3 replicas
    And Attach volume to the node
    When Write data into mount point
    And Restart Kubelet on the node ${volunme_attached_node}
    Then Volume state should be
    And Engine state should be
    And Replica state should be
    
RWX volume with replica on attached nod and restart Kubelet on the non volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWX volume with 3 replicas
    And Attach volume to the node
    When Write data into mount point
    And Restart Kubelet on the node ${non_volunme_attached_node}
    Then Volume state should be
    And Engine state should be
    And Replica state should be

RWX volume with no replica on attached node and Restart Kubelet on the volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWX volume with 2 replicas
    And Attach volume to the node 0
    When Write data into mount point
    And Restart Kubelet on the node ${volunme_attached_node}
    Then Volume state should be
    And Engine state should be
    And Replica state should be
    
RWX volume with no replica on attached node and restart Kubelet on the non volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWX volume with 2 replicas
    And Attach volume to the node 0
    When Write data into mount point
    And Restart Kubelet on the node ${non_volunme_attached_node}
    Then Volume state should be
    And Engine state should be
    And Replica state should be

RWX volume with no replica on attached node and Restart Kubelet on the volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWX volume with 2 replicas
    And Attach volume to the node 2
    When Write data into mount point
    And Restart Kubelet on the node ${volunme_attached_node}
    Then Volume state should be
    And Engine state should be
    And Replica state should be
    
RWX volume with no replica on attached node and restart Kubelet on the non volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWX volume with 2 replicas
    And Attach volume to the node 2
    When Write data into mount point
    And Restart Kubelet on the node ${non_volunme_attached_node}
    Then Volume state should be
    And Engine state should be
    And Replica state should be

RWX volume with replica on attached node and restart Kubelet on the volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWX volume with 3 replicas
    And Attach volume to the node
    When Write data into mount point
    And Restart Kubelet on the node ${volunme_attached_node}
    And Sleep ${POD_EVICTION_TIME_OUT} seconds
    Then Volume state should be
    And Engine state should be
    And Replica state should be
    
RWX volume with replica on attached nod and restart Kubelet on the non volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWX volume with 3 replicas
    And Attach volume to the node
    When Write data into mount point
    And Restart Kubelet on the node ${non_volunme_attached_node}
    And Sleep ${POD_EVICTION_TIME_OUT} seconds
    Then Volume state should be
    And Engine state should be
    And Replica state should be

RWX volume with no replica on attached node and Restart Kubelet on the volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWX volume with 2 replicas
    And Attach volume to the node 0
    When Write data into mount point
    And Restart Kubelet on the node ${volunme_attached_node}
    And Sleep ${POD_EVICTION_TIME_OUT} seconds
    Then Volume state should be
    And Engine state should be
    And Replica state should be
    
RWX volume with no replica on attached node and restart Kubelet on the non volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWX volume with 2 replicas
    And Attach volume to the node 9
    When Write data into mount point
    And Restart Kubelet on the node ${non_volunme_attached_node}
    And Sleep ${POD_EVICTION_TIME_OUT} seconds
    Then Volume state should be
    And Engine state should be
    And Replica state should be

RWX volume with no replica on attached node and Restart Kubelet on the volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWX volume with 2 replicas
    And Attach volume to the node 2
    When Write data into mount point
    And Restart Kubelet on the node ${volunme_attached_node}
    And Sleep ${POD_EVICTION_TIME_OUT} seconds
    Then Volume state should be
    And Engine state should be
    And Replica state should be
    
RWX volume with no replica on attached node and restart Kubelet on the non volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWX volume with 2 replicas
    And Attach volume to the node 2
    When Write data into mount point
    And Restart Kubelet on the node ${non_volunme_attached_node}
    And Sleep ${POD_EVICTION_TIME_OUT} seconds
    Then Volume state should be
    And Engine state should be
    And Replica state should be