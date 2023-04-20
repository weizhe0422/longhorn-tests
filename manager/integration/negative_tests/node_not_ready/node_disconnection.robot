*** Settings ***
Documentation     https://longhorn.github.io/longhorn-tests/manual/pre-release/node/node-disconnection/
...
...               Keywords are imported from the resource file
Resource          keywords.resource
Test setup    set_test_environment    ${TEST NAME}
Test Teardown    cleanup_resources

*** Variable ***
${volume_size_gb}=    1
${wait_interval}=    5

*** Test Cases ***
Scenario 1
    [Documentation]    Case 1-1
    [Tags]    RWO 
    Given Create ${volume_size_gb} GB RWO volume with 2 replicas
    And Settings auto-salvage is false
    And Attach volume to the node has no replica
    When Write data into mount point
    And Disconnect node ${volunme_attached_node} network 100 seconds
    Then Volume attach state should be detached
    And All replicas state should be ERROR

Scenario 2
    [Documentation]    Case 1-2
    [Tags]    
    Given Create ${volume_size_gb} GB RWO volume with 3 replicas
    And Settings auto-salvage is false
    And Attach volume to the node
    When Write data into mount point
    And Disconnect node ${volunme_attached_node} network 100 seconds
    Then Volume attach state should be attached
    And All replicas state should be running

Scenario 3
    [Documentation]    Case 2-1
    [Tags]    
    Given Create ${volume_size_gb} GB RWO volume with 2 replicas
    And Settings auto-salvage is false
    And Attach volume to the node has no replica
    When Disconnect node ${volunme_attached_node} network 100 seconds
    Then Volume attach state should be attached
    And All replicas state should be running

Scenario 4
    [Documentation]    Case 2-2
    [Tags]    
    Given Create ${volume_size_gb} GB RWO volume with 3 replicas
    And Settings auto-salvage is false
    And Attach volume to the node
    When Disconnect node ${volunme_attached_node} network 100 seconds
    Then Volume attach state should be attached
    And All replicas state should be running

Scenario 5
    [Documentation]    Case 3
    [Tags]    
    Given Create ${volume_size_gb} GB RWO volume with 2 replicas
    And Settings auto-salvage is true
    And Attach volume to the node
    And Create 2 pod with StatefulSet deployed
    FOR    ${i}    IN RANGE    3
        When Disconnect node ${volunme_attached_node} network 100 seconds
        Then Volume attach state is attached
        And Pod state is running
        And Check data is intact
    END
    Given Create ${volume_size_gb} GB RWX volume with 2 replicas
    And Attach volume to the node
    When Detach volume
    Then Volume attach state should be attached
    And Volume state should be healthy
    And All replicas state should be running

scenario-6
    [Documentation]    RWO volume with replica on attached node and disconnect network 100 seconds the volume-attached node
    [Tags]
    Given Create ${volume_size_gb} GB RWO volume with 3 replicas
    And Attach volume to the node
    And Write data into mount point
    When Disconnect node ${volunme_attached_node} network 100 seconds
    Then Volume state should be unknown
    And Engine state should be unknown
    And Replica on the node ${volunme_attached_node} state should be unknown 
    
RWO volume with replica on attached nod And Disconnect network 100 seconds the non volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWO volume with 3 replicas
    And Attach volume to the node
    When Write data into mount point
    And Disconnect network 100 seconds the node ${non_volunme_attached_node}
    Then Volume state should be
    And Engine state should be
    And Replica state should be

RWO volume with no replica on attached node and disconnect network 100 seconds the volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 0
    When Write data into mount point
    And Disconnect network 100 seconds the node ${volunme_attached_node}
    Then Volume state should be
    And Engine state should be
    And Replica state should be
    
RWO volume with no replica on attached node and disconnect network 100 seconds the non volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 0
    When Write data into mount point
    And Disconnect network 100 seconds the node ${non_volunme_attached_node}
    Then Volume state should be
    And Engine state should be
    And Replica state should be

RWO volume with no replica on attached node and disconnect network 100 seconds the volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 2
    When Write data into mount point
    And Disconnect network 100 seconds the node ${volunme_attached_node}
    Then Volume state should be
    And Engine state should be
    And Replica state should be
    
RWO volume with no replica on attached node and disconnect network 100 seconds the non volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 2
    When Write data into mount point
    And Disconnect network 100 seconds the node ${non_volunme_attached_node}
    Then Volume state should be
    And Engine state should be
    And Replica state should be

RWO volume with replica on attached node and disconnect network 100 seconds the volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWO volume with 3 replicas
    And Attach volume to the node
    When Write data into mount point
    And Disconnect network 100 seconds the node ${volunme_attached_node}
    And Sleep ${POD_EVICTION_TIME_OUT} seconds
    Then Volume state should be
    And Engine state should be
    And Replica state should be
    
RWO volume with replica on attached nod And Disconnect network 100 seconds the non volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWO volume with 3 replicas
    And Attach volume to the node
    When Write data into mount point
    And Disconnect network 100 seconds the node ${non_volunme_attached_node}
    And Sleep ${POD_EVICTION_TIME_OUT} seconds
    Then Volume state should be
    And Engine state should be
    And Replica state should be

RWO volume with no replica on attached node and disconnect network 100 seconds the volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 0
    When Write data into mount point
    And Disconnect network 100 seconds the node ${volunme_attached_node}
    And Sleep ${POD_EVICTION_TIME_OUT} seconds
    Then Volume state should be
    And Engine state should be
    And Replica state should be
    
RWO volume with no replica on attached node and disconnect network 100 seconds the non volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 9
    When Write data into mount point
    And Disconnect network 100 seconds the node ${non_volunme_attached_node}
    And Sleep ${POD_EVICTION_TIME_OUT} seconds
    Then Volume state should be
    And Engine state should be
    And Replica state should be

RWO volume with no replica on attached node and disconnect network 100 seconds the volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 2
    When Write data into mount point
    And Disconnect network 100 seconds the node ${volunme_attached_node}
    And Sleep ${POD_EVICTION_TIME_OUT} seconds
    Then Volume state should be
    And Engine state should be
    And Replica state should be
    
RWO volume with no replica on attached node and disconnect network 100 seconds the non volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 2
    When Write data into mount point
    And Disconnect network 100 seconds the node ${non_volunme_attached_node}
    And Sleep ${POD_EVICTION_TIME_OUT} seconds
    Then Volume state should be
    And Engine state should be
    And Replica state should be

RWX volume with replica on attached node and disconnect network 100 seconds the volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWX volume with 3 replicas
    And Attach volume to the node
    When Write data into mount point
    And Disconnect network 100 seconds the node ${volunme_attached_node}
    Then Volume state should be
    And Engine state should be
    And Replica state should be
    
RWX volume with replica on attached nod And Disconnect network 100 seconds the non volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWX volume with 3 replicas
    And Attach volume to the node
    When Write data into mount point
    And Disconnect network 100 seconds the node ${non_volunme_attached_node}
    Then Volume state should be
    And Engine state should be
    And Replica state should be

RWX volume with no replica on attached node and disconnect network 100 seconds the volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWX volume with 2 replicas
    And Attach volume to the node 0
    When Write data into mount point
    And Disconnect network 100 seconds the node ${volunme_attached_node}
    Then Volume state should be
    And Engine state should be
    And Replica state should be
    
RWX volume with no replica on attached node and disconnect network 100 seconds the non volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWX volume with 2 replicas
    And Attach volume to the node 0
    When Write data into mount point
    And Disconnect network 100 seconds the node ${non_volunme_attached_node}
    Then Volume state should be
    And Engine state should be
    And Replica state should be

RWX volume with no replica on attached node and disconnect network 100 seconds the volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWX volume with 2 replicas
    And Attach volume to the node 2
    When Write data into mount point
    And Disconnect network 100 seconds the node ${volunme_attached_node}
    Then Volume state should be
    And Engine state should be
    And Replica state should be
    
RWX volume with no replica on attached node and disconnect network 100 seconds the non volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWX volume with 2 replicas
    And Attach volume to the node 2
    When Write data into mount point
    And Disconnect network 100 seconds the node ${non_volunme_attached_node}
    Then Volume state should be
    And Engine state should be
    And Replica state should be

RWX volume with replica on attached node and disconnect network 100 seconds the volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWX volume with 3 replicas
    And Attach volume to the node
    When Write data into mount point
    And Disconnect network 100 seconds the node ${volunme_attached_node}
    And Sleep ${POD_EVICTION_TIME_OUT} seconds
    Then Volume state should be
    And Engine state should be
    And Replica state should be
    
RWX volume with replica on attached nod And Disconnect network 100 seconds the non volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWX volume with 3 replicas
    And Attach volume to the node
    When Write data into mount point
    And Disconnect network 100 seconds the node ${non_volunme_attached_node}
    And Sleep ${POD_EVICTION_TIME_OUT} seconds
    Then Volume state should be
    And Engine state should be
    And Replica state should be

RWX volume with no replica on attached node and disconnect network 100 seconds the volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWX volume with 2 replicas
    And Attach volume to the node 0
    When Write data into mount point
    And Disconnect network 100 seconds the node ${volunme_attached_node}
    And Sleep ${POD_EVICTION_TIME_OUT} seconds
    Then Volume state should be
    And Engine state should be
    And Replica state should be
    
RWX volume with no replica on attached node and disconnect network 100 seconds the non volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWX volume with 2 replicas
    And Attach volume to the node 9
    When Write data into mount point
    And Disconnect network 100 seconds the node ${non_volunme_attached_node}
    And Sleep ${POD_EVICTION_TIME_OUT} seconds
    Then Volume state should be
    And Engine state should be
    And Replica state should be

RWX volume with no replica on attached node and disconnect network 100 seconds the volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWX volume with 2 replicas
    And Attach volume to the node 2
    When Write data into mount point
    And Disconnect network 100 seconds the node ${volunme_attached_node}
    And Sleep ${POD_EVICTION_TIME_OUT} seconds
    Then Volume state should be
    And Engine state should be
    And Replica state should be
    
RWX volume with no replica on attached node and disconnect network 100 seconds the non volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size_gb} GB RWX volume with 2 replicas
    And Attach volume to the node 2
    When Write data into mount point
    And Disconnect network 100 seconds the node ${non_volunme_attached_node}
    And Sleep ${POD_EVICTION_TIME_OUT} seconds
    Then Volume state should be
    And Engine state should be
    And Replica state should be