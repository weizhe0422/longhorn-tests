*** Settings ***
Documentation     Test the resillence if cluster node happend exception
...
...               Keywords are imported from the resource file
Resource          keywords.resource
Test setup    set_test_environment    ${TEST NAME}
Test Teardown    cleanup_resources

*** Variable ***
${volume_size_gb}=    1
${POD_EVICTION_TIME_OUT}=    300

*** Test Cases ***    
scenario-1
    [Documentation]    RWO volume with replica on attached node and restart Kubelet on the volume-attached node
    [Tags]    RWO RestartKubeletAttachedNode ReplicaOnAttachedNode DuringDataWriting 
    Given Create ${volume_size_gb} GB RWO volume with 3 replicas
    And Attach volume to the node
    And Write data into mount point
    When Restart Kubelet on the node ${volunme_attached_node}
    Then Volume state should be healthy
    And Engine state should be running
    And Replica on the node ${volunme_attached_node} state should be running
    
RWO volume with replica on attached nod and restart Kubelet on the non volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWO volume with 3 replicas
    And Attach volume to the node
    And Write data into mount point
    When Restart Kubelet on the node ${non_volunme_attached_node}
    Then Volume state should be
    And Engine state should be
    And Replica state should be

RWO volume with no replica on attached node and Restart Kubelet on the volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 0
    And Write data into mount point
    When Restart Kubelet on the node ${volunme_attached_node}
    Then Volume state should be
    And Engine state should be
    And Replica state should be
    
RWO volume with no replica on attached node and restart Kubelet on the non volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 0
    And Write data into mount point
    When Restart Kubelet on the node ${non_volunme_attached_node}
    Then Volume state should be
    And Engine state should be
    And Replica state should be

RWO volume with no replica on attached node and Restart Kubelet on the volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 2
    And Write data into mount point
    When Restart Kubelet on the node ${volunme_attached_node}
    Then Volume state should be
    And Engine state should be
    And Replica state should be
    
RWO volume with no replica on attached node and restart Kubelet on the non volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 2
    And Write data into mount point
    When Restart Kubelet on the node ${non_volunme_attached_node}
    Then Volume state should be
    And Engine state should be
    And Replica state should be

RWO volume with replica on attached node and restart Kubelet on the volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWO volume with 3 replicas
    And Attach volume to the node
    And Write data into mount point
    When Restart Kubelet on the node ${volunme_attached_node} exceed ${POD_EVICTION_TIME_OUT} seconds
    Then Volume state should be
    And Engine state should be
    And Replica state should be
    
RWO volume with replica on attached nod and restart Kubelet on the non volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWO volume with 3 replicas
    And Attach volume to the node
    And Write data into mount point
    When Restart Kubelet on the node ${non_volunme_attached_node} exceed ${POD_EVICTION_TIME_OUT} seconds
    Then Volume state should be
    And Engine state should be
    And Replica state should be

RWO volume with no replica on attached node and Restart Kubelet on the volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 0
    And Write data into mount point
    When Restart Kubelet on the node ${volunme_attached_node} exceed ${POD_EVICTION_TIME_OUT} seconds
    Then Volume state should be
    And Engine state should be
    And Replica state should be
    
RWO volume with no replica on attached node and restart Kubelet on the non volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 0
    And Write data into mount point
    When Restart Kubelet on the node ${non_volunme_attached_node} exceed ${POD_EVICTION_TIME_OUT} seconds
    Then Volume state should be
    And Engine state should be
    And Replica state should be

RWO volume with no replica on attached node and Restart Kubelet on the volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 2
    And Write data into mount point
    When Restart Kubelet on the node ${volunme_attached_node} exceed ${POD_EVICTION_TIME_OUT} seconds
    Then Volume state should be
    And Engine state should be
    And Replica state should be
    
RWO volume with no replica on attached node and restart Kubelet on the non volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 2
    And Write data into mount point
    When Restart Kubelet on the node ${non_volunme_attached_node} exceed ${POD_EVICTION_TIME_OUT} seconds
    Then Volume state should be
    And Engine state should be
    And Replica state should be

RWX volume with replica on attached node and restart Kubelet on the volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWX volume with 3 replicas
    And Attach volume to the node
    And Write data into mount point
    When Restart Kubelet on the node ${volunme_attached_node}
    Then Volume state should be
    And Engine state should be
    And Replica state should be
    
RWX volume with replica on attached nod and restart Kubelet on the non volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWX volume with 3 replicas
    And Attach volume to the node
    And Write data into mount point
    When Restart Kubelet on the node ${non_volunme_attached_node}
    Then Volume state should be
    And Engine state should be
    And Replica state should be

RWX volume with no replica on attached node and Restart Kubelet on the volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWX volume with 2 replicas
    And Attach volume to the node 0
    And Write data into mount point
    When Restart Kubelet on the node ${volunme_attached_node}
    Then Volume state should be
    And Engine state should be
    And Replica state should be
    
RWX volume with no replica on attached node and restart Kubelet on the non volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWX volume with 2 replicas
    And Attach volume to the node 0
    And Write data into mount point
    When Restart Kubelet on the node ${non_volunme_attached_node}
    Then Volume state should be
    And Engine state should be
    And Replica state should be

RWX volume with no replica on attached node and Restart Kubelet on the volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWX volume with 2 replicas
    And Attach volume to the node 2
    And Write data into mount point
    When Restart Kubelet on the node ${volunme_attached_node}
    Then Volume state should be
    And Engine state should be
    And Replica state should be
    
RWX volume with no replica on attached node and restart Kubelet on the non volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWX volume with 2 replicas
    And Attach volume to the node 2
    And Write data into mount point
    When Restart Kubelet on the node ${non_volunme_attached_node}
    Then Volume state should be
    And Engine state should be
    And Replica state should be

RWX volume with replica on attached node and restart Kubelet on the volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWX volume with 3 replicas
    And Attach volume to the node
    And Write data into mount point
    When Restart Kubelet on the node ${volunme_attached_node} exceed ${POD_EVICTION_TIME_OUT} seconds
    Then Volume state should be
    And Engine state should be
    And Replica state should be
    
RWX volume with replica on attached nod and restart Kubelet on the non volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWX volume with 3 replicas
    And Attach volume to the node
    And Write data into mount point
    When Restart Kubelet on the node ${non_volunme_attached_node} exceed ${POD_EVICTION_TIME_OUT} seconds
    Then Volume state should be
    And Engine state should be
    And Replica state should be

RWX volume with no replica on attached node and Restart Kubelet on the volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWX volume with 2 replicas
    And Attach volume to the node 0
    And Write data into mount point
    When Restart Kubelet on the node ${volunme_attached_node} exceed ${POD_EVICTION_TIME_OUT} seconds
    Then Volume state should be
    And Engine state should be
    And Replica state should be
    
RWX volume with no replica on attached node and restart Kubelet on the non volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWX volume with 2 replicas
    And Attach volume to the node 9
    And Write data into mount point
    When Restart Kubelet on the node ${non_volunme_attached_node} exceed ${POD_EVICTION_TIME_OUT} seconds
    Then Volume state should be
    And Engine state should be
    And Replica state should be

RWX volume with no replica on attached node and Restart Kubelet on the volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWX volume with 2 replicas
    And Attach volume to the node 2
    And Write data into mount point
    When Restart Kubelet on the node ${volunme_attached_node} exceed ${POD_EVICTION_TIME_OUT} seconds
    Then Volume state should be
    And Engine state should be
    And Replica state should be
    
RWX volume with no replica on attached node and restart Kubelet on the non volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWX volume with 2 replicas
    And Attach volume to the node 2
    And Write data into mount point
    When Restart Kubelet on the node ${non_volunme_attached_node} exceed ${POD_EVICTION_TIME_OUT} seconds
    Then Volume state should be
    And Engine state should be
    And Replica state should be