*** Settings ***
Documentation     Test the resillence if cluster node happend exception
...
...               Keywords are imported from the resource file
Resource          keywords.resource
Test setup    set_test_environment    ${TEST NAME}
Test Teardown    cleanup_resources

*** Variable ***
${volume_size_gb}=    5

*** Test Cases ***
Scenario 1
    [Documentation]    RWO volume with replica on attached node, and power off the volume attached node
    [Tags]    RWO PowerOffNode
    # Recover: After restart the node, volume should be detached and replica is failed. Need manual to do reattached.
    Given Create ${volume_size_gb} GB RWO volume with 3 replicas
    And Attach volume to the node
    And Write data into mount point
    When Power off the node ${volunme_attached_node}
    Then Node ${volunme_attached_node} state should be NotReady
    And Volume state should be unknown
    And Engine state should be unknown
    And Replica on the node ${volunme_attached_node} state should be unknown

Scenario 2
    [Documentation]    RWO volume with replica on attached node, and power off the non volume attached node
    [Tags]    RWO PowerOffNode
    # Recover: After restart the node, delete the stopped replica, and re-update the replica count to do rebuilding
    Given Create ${volume_size_gb} GB RWO volume with 3 replicas
    And Attach volume to the node
    And Write data into mount point
    When Power off the node ${non_volunme_attached_node}
    Then Node ${non_volunme_attached_node} state should be NotReady
    And Volume state should be degraded
    And Engine state should be running
    And Replica on the node ${non_volunme_attached_node} state should be stopped
    And Check data is intact

RWO volume with no replica on attached node and power off on the volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 0
    When Write data into mount point
    And Power off the node ${volunme_attached_node}
    Then Volume state should be
    And Engine state should be
    And Replica state should be
    
RWO volume with no replica on attached node and power off on the non volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 0
    When Write data into mount point
    And Power off the node ${non_volunme_attached_node}
    Then Volume state should be
    And Engine state should be
    And Replica state should be

RWO volume with no replica on attached node and power off on the volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 2
    When Write data into mount point
    And Power off the node ${volunme_attached_node}
    Then Volume state should be
    And Engine state should be
    And Replica state should be
    
RWO volume with no replica on attached node and power off on the non volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 2
    When Write data into mount point
    And Power off the node ${non_volunme_attached_node}
    Then Volume state should be
    And Engine state should be
    And Replica state should be

RWO volume with replica on attached node and power off on the volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWO volume with 3 replicas
    And Attach volume to the node
    When Write data into mount point
    And Power off the node ${volunme_attached_node}
    And Sleep ${POD_EVICTION_TIME_OUT} seconds
    Then Volume state should be
    And Engine state should be
    And Replica state should be
    
RWO volume with replica on attached nod and power off on the non volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWO volume with 3 replicas
    And Attach volume to the node
    When Write data into mount point
    And Power off the node ${non_volunme_attached_node}
    And Sleep ${POD_EVICTION_TIME_OUT} seconds
    Then Volume state should be
    And Engine state should be
    And Replica state should be

RWO volume with no replica on attached node and power off on the volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 0
    When Write data into mount point
    And Power off the node ${volunme_attached_node}
    And Sleep ${POD_EVICTION_TIME_OUT} seconds
    Then Volume state should be
    And Engine state should be
    And Replica state should be
    
RWO volume with no replica on attached node and power off on the non volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 9
    When Write data into mount point
    And Power off the node ${non_volunme_attached_node}
    And Sleep ${POD_EVICTION_TIME_OUT} seconds
    Then Volume state should be
    And Engine state should be
    And Replica state should be

RWO volume with no replica on attached node and power off on the volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 2
    When Write data into mount point
    And Power off the node ${volunme_attached_node}
    And Sleep ${POD_EVICTION_TIME_OUT} seconds
    Then Volume state should be
    And Engine state should be
    And Replica state should be
    
RWO volume with no replica on attached node and power off on the non volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 2
    When Write data into mount point
    And Power off the node ${non_volunme_attached_node}
    And Sleep ${POD_EVICTION_TIME_OUT} seconds
    Then Volume state should be
    And Engine state should be
    And Replica state should be

RWX volume with replica on attached node and power off on the volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWX volume with 3 replicas
    And Attach volume to the node
    When Write data into mount point
    And Power off the node ${volunme_attached_node}
    Then Volume state should be
    And Engine state should be
    And Replica state should be
    
RWX volume with replica on attached nod and power off on the non volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWX volume with 3 replicas
    And Attach volume to the node
    When Write data into mount point
    And Power off the node ${non_volunme_attached_node}
    Then Volume state should be
    And Engine state should be
    And Replica state should be

RWX volume with no replica on attached node and power off on the volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWX volume with 2 replicas
    And Attach volume to the node 0
    When Write data into mount point
    And Power off the node ${volunme_attached_node}
    Then Volume state should be
    And Engine state should be
    And Replica state should be
    
RWX volume with no replica on attached node and power off on the non volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWX volume with 2 replicas
    And Attach volume to the node 0
    When Write data into mount point
    And Power off the node ${non_volunme_attached_node}
    Then Volume state should be
    And Engine state should be
    And Replica state should be

RWX volume with no replica on attached node and power off on the volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWX volume with 2 replicas
    And Attach volume to the node 2
    When Write data into mount point
    And Power off the node ${volunme_attached_node}
    Then Volume state should be
    And Engine state should be
    And Replica state should be
    
RWX volume with no replica on attached node and power off on the non volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWX volume with 2 replicas
    And Attach volume to the node 2
    When Write data into mount point
    And Power off the node ${non_volunme_attached_node}
    Then Volume state should be
    And Engine state should be
    And Replica state should be

RWX volume with replica on attached node and power off on the volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWX volume with 3 replicas
    And Attach volume to the node
    When Write data into mount point
    And Power off the node ${volunme_attached_node}
    And Sleep ${POD_EVICTION_TIME_OUT} seconds
    Then Volume state should be
    And Engine state should be
    And Replica state should be
    
RWX volume with replica on attached nod and power off on the non volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWX volume with 3 replicas
    And Attach volume to the node
    When Write data into mount point
    And Power off the node ${non_volunme_attached_node}
    And Sleep ${POD_EVICTION_TIME_OUT} seconds
    Then Volume state should be
    And Engine state should be
    And Replica state should be

RWX volume with no replica on attached node and power off on the volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWX volume with 2 replicas
    And Attach volume to the node 0
    When Write data into mount point
    And Power off the node ${volunme_attached_node}
    And Sleep ${POD_EVICTION_TIME_OUT} seconds
    Then Volume state should be
    And Engine state should be
    And Replica state should be
    
RWX volume with no replica on attached node and power off on the non volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWX volume with 2 replicas
    And Attach volume to the node 9
    When Write data into mount point
    And Power off the node ${non_volunme_attached_node}
    And Sleep ${POD_EVICTION_TIME_OUT} seconds
    Then Volume state should be
    And Engine state should be
    And Replica state should be

RWX volume with no replica on attached node and power off on the volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWX volume with 2 replicas
    And Attach volume to the node 2
    When Write data into mount point
    And Power off the node ${volunme_attached_node}
    And Sleep ${POD_EVICTION_TIME_OUT} seconds
    Then Volume state should be
    And Engine state should be
    And Replica state should be
    
RWX volume with no replica on attached node and power off on the non volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWX volume with 2 replicas
    And Attach volume to the node 2
    When Write data into mount point
    And Power off the node ${non_volunme_attached_node}
    And Sleep ${POD_EVICTION_TIME_OUT} seconds
    Then Volume state should be
    And Engine state should be
    And Replica state should be

RWO volume with replica on attached node And Reboot the volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWO volume with 3 replicas
    And Attach volume to the node
    When Write data into mount point
    And Reboot the node ${volunme_attached_node}
    Then Volume state should be
    And Engine state should be
    And Replica state should be
    
RWO volume with replica on attached nod And Reboot the non volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWO volume with 3 replicas
    And Attach volume to the node
    When Write data into mount point
    And Reboot the node ${non_volunme_attached_node}
    Then Volume state should be
    And Engine state should be
    And Replica state should be

RWO volume with no replica on attached node And Reboot the volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 0
    When Write data into mount point
    And Reboot the node ${volunme_attached_node}
    Then Volume state should be
    And Engine state should be
    And Replica state should be
    
RWO volume with no replica on attached node And Reboot the non volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 0
    When Write data into mount point
    And Reboot the node ${non_volunme_attached_node}
    Then Volume state should be
    And Engine state should be
    And Replica state should be

RWO volume with no replica on attached node And Reboot the volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 2
    When Write data into mount point
    And Reboot the node ${volunme_attached_node}
    Then Volume state should be
    And Engine state should be
    And Replica state should be
    
RWO volume with no replica on attached node And Reboot the non volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 2
    When Write data into mount point
    And Reboot the node ${non_volunme_attached_node}
    Then Volume state should be
    And Engine state should be
    And Replica state should be

RWO volume with replica on attached node And Reboot the volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWO volume with 3 replicas
    And Attach volume to the node
    When Write data into mount point
    And Reboot the node ${volunme_attached_node}
    And Sleep ${POD_EVICTION_TIME_OUT} seconds
    Then Volume state should be
    And Engine state should be
    And Replica state should be
    
RWO volume with replica on attached nod And Reboot the non volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWO volume with 3 replicas
    And Attach volume to the node
    When Write data into mount point
    And Reboot the node ${non_volunme_attached_node}
    And Sleep ${POD_EVICTION_TIME_OUT} seconds
    Then Volume state should be
    And Engine state should be
    And Replica state should be

RWO volume with no replica on attached node And Reboot the volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 0
    When Write data into mount point
    And Reboot the node ${volunme_attached_node}
    And Sleep ${POD_EVICTION_TIME_OUT} seconds
    Then Volume state should be
    And Engine state should be
    And Replica state should be
    
RWO volume with no replica on attached node And Reboot the non volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 9
    When Write data into mount point
    And Reboot the node ${non_volunme_attached_node}
    And Sleep ${POD_EVICTION_TIME_OUT} seconds
    Then Volume state should be
    And Engine state should be
    And Replica state should be

RWO volume with no replica on attached node And Reboot the volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 2
    When Write data into mount point
    And Reboot the node ${volunme_attached_node}
    And Sleep ${POD_EVICTION_TIME_OUT} seconds
    Then Volume state should be
    And Engine state should be
    And Replica state should be
    
RWO volume with no replica on attached node And Reboot the non volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 2
    When Write data into mount point
    And Reboot the node ${non_volunme_attached_node}
    And Sleep ${POD_EVICTION_TIME_OUT} seconds
    Then Volume state should be
    And Engine state should be
    And Replica state should be

RWX volume with replica on attached node And Reboot the volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWX volume with 3 replicas
    And Attach volume to the node
    When Write data into mount point
    And Reboot the node ${volunme_attached_node}
    Then Volume state should be
    And Engine state should be
    And Replica state should be
    
RWX volume with replica on attached nod And Reboot the non volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWX volume with 3 replicas
    And Attach volume to the node
    When Write data into mount point
    And Reboot the node ${non_volunme_attached_node}
    Then Volume state should be
    And Engine state should be
    And Replica state should be

RWX volume with no replica on attached node And Reboot the volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWX volume with 2 replicas
    And Attach volume to the node 0
    When Write data into mount point
    And Reboot the node ${volunme_attached_node}
    Then Volume state should be
    And Engine state should be
    And Replica state should be
    
RWX volume with no replica on attached node And Reboot the non volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWX volume with 2 replicas
    And Attach volume to the node 0
    When Write data into mount point
    And Reboot the node ${non_volunme_attached_node}
    Then Volume state should be
    And Engine state should be
    And Replica state should be

RWX volume with no replica on attached node And Reboot the volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWX volume with 2 replicas
    And Attach volume to the node 2
    When Write data into mount point
    And Reboot the node ${volunme_attached_node}
    Then Volume state should be
    And Engine state should be
    And Replica state should be
    
RWX volume with no replica on attached node And Reboot the non volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWX volume with 2 replicas
    And Attach volume to the node 2
    When Write data into mount point
    And Reboot the node ${non_volunme_attached_node}
    Then Volume state should be
    And Engine state should be
    And Replica state should be

RWX volume with replica on attached node And Reboot the volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWX volume with 3 replicas
    And Attach volume to the node
    When Write data into mount point
    And Reboot the node ${volunme_attached_node}
    And Sleep ${POD_EVICTION_TIME_OUT} seconds
    Then Volume state should be
    And Engine state should be
    And Replica state should be
    
RWX volume with replica on attached nod And Reboot the non volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWX volume with 3 replicas
    And Attach volume to the node
    When Write data into mount point
    And Reboot the node ${non_volunme_attached_node}
    And Sleep ${POD_EVICTION_TIME_OUT} seconds
    Then Volume state should be
    And Engine state should be
    And Replica state should be

RWX volume with no replica on attached node And Reboot the volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWX volume with 2 replicas
    And Attach volume to the node 0
    When Write data into mount point
    And Reboot the node ${volunme_attached_node}
    And Sleep ${POD_EVICTION_TIME_OUT} seconds
    Then Volume state should be
    And Engine state should be
    And Replica state should be
    
RWX volume with no replica on attached node And Reboot the non volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWX volume with 2 replicas
    And Attach volume to the node 9
    When Write data into mount point
    And Reboot the node ${non_volunme_attached_node}
    And Sleep ${POD_EVICTION_TIME_OUT} seconds
    Then Volume state should be
    And Engine state should be
    And Replica state should be

RWX volume with no replica on attached node And Reboot the volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWX volume with 2 replicas
    And Attach volume to the node 2
    When Write data into mount point
    And Reboot the node ${volunme_attached_node}
    And Sleep ${POD_EVICTION_TIME_OUT} seconds
    Then Volume state should be
    And Engine state should be
    And Replica state should be
    
RWX volume with no replica on attached node And Reboot the non volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWX volume with 2 replicas
    And Attach volume to the node 2
    When Write data into mount point
    And Reboot the node ${non_volunme_attached_node}
    And Sleep ${POD_EVICTION_TIME_OUT} seconds
    Then Volume state should be
    And Engine state should be
    And Replica state should be