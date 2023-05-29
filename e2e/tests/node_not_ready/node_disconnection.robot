*** Settings ***
Documentation     https://longhorn.github.io/longhorn-tests/manual/pre-release/node-not-ready/node-disconnection/node-disconnection/
...
...               Keywords are imported from the resource file
Resource          ../../keywords/node.resource
Resource          ../../keywords/common.resource
Test setup    set_test_environment    ${TEST NAME}
Test Teardown    cleanup_resources

*** Variable ***
${volume_size_gb}=    1
${retry_time_out}=    600
${retry_interval}=    5

*** Test Cases ***
1-RWO 2 replica abnormal no attach no replica node data writing
    [Documentation]    Case 1-1
    [Tags]    NodeNetworkPartition    RWO    2Replicas    AttachReplicaSameNode    AbnormalNoReplicaNode    AbnormalNoAttachedNode    DataWriting
    Given The ${volume_size_gb} GB RWO volume with 2 replicas
    And Update the auto-salvage setting to false
    And Attach volume to the node 1 without replica node

    When During writing data into mount point interrupt the node 1 of without replica nodes network for 100 seconds

    Then Node 1 without replica node state should be Ready
    And Volume state should be faulted
    And Engine state should be stopped
    And All replicas state should be running stopped
    [Teardown]    Run Keywords   Update the auto-salvage setting to true
    ...           AND            cleanup_resources

2-RWX 2 replica abnormal no attach no replica node data writing
    [Documentation]    Case 1-1
    [Tags]    NodeNetworkPartition    RWX    2Replicas    AttachReplicaSameNode    AbnormalNoReplicaNode    AbnormalNoAttachedNode    DataWriting
    Given The ${volume_size_gb} GB RWX volume with 2 replicas
    And Update the auto-salvage setting to false
    And Attach volume to the node 1 without replica node

    When During writing data into mount point interrupt the node 1 of without replica nodes network for 100 seconds

    Then Node 1 without replica node state should be Ready
    And Volume state should be faulted
    And Engine state should be stopped
    And All replicas state should be running stopped
    [Teardown]    Run Keywords   Update the auto-salvage setting to true
    ...           AND            cleanup_resources
  
3-RWO 3 replicas abnormal attached replica node data writing
    [Documentation]    Case 1-2
    [Tags]    NodeNetworkPartition    RWO    3Replicas    AttachReplicaSameNode    AbnormalReplicaNode    AbnormalAttachedNode    DataWriting
    Given The ${volume_size_gb} GB RWO volume with 3 replicas
    And Update the auto-salvage setting to false
    And Attach volume to the node 1 with replica node

    When During writing data into mount point interrupt the node 1 of with replica nodes network for 100 seconds

    Then Node 1 with replica node state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running running
    [Teardown]    Run Keywords   Update the auto-salvage setting to true
    ...           AND            cleanup_resources

4-RWX 3 replicas abnormal attached replica node data writing
    [Documentation]    Case 1-2
    [Tags]    NodeNetworkPartition    RWX    3Replicas    AttachReplicaSameNode    AbnormalReplicaNode    AbnormalAttachedNode    DataWriting
    Given The ${volume_size_gb} GB RWX volume with 3 replicas
    And Update the auto-salvage setting to false
    And Attach volume to the node 1 with replica node

    When During writing data into mount point interrupt the node 1 of with replica nodes network for 100 seconds

    Then Node 1 with replica node state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running running
    [Teardown]    Run Keywords   Update the auto-salvage setting to true
    ...           AND            cleanup_resources
    
5-RWO 2 replicas abnormal non attached no replica node
    [Documentation]    Case 2-1
    [Tags]    NodeNetworkPartition    RWO    2Replicas    AttachReplicaSameNode    AbnormalNoReplicaNode    AbnormalNoAttachedNode 
    Given The ${volume_size_gb} GB RWO volume with 2 replicas
    And Update the auto-salvage setting to false
    And Attach volume to the node 1 without replica node

    When Interrupt the node 1 of without replica nodes network for 100 seconds

    Then Node 1 without replica node state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running running
    [Teardown]    Run Keywords   Update the auto-salvage setting to true
    ...           AND            cleanup_resources

6-RWX 2 replicas abnormal non attached no replica node
    [Documentation]    Case 2-1
    [Tags]    NodeNetworkPartition    RWX    2Replicas    AttachReplicaSameNode    AbnormalNoReplicaNode    AbnormalNoAttachedNode  
    Given The ${volume_size_gb} GB RWX volume with 2 replicas
    And Update the auto-salvage setting to false
    And Attach volume to the node 1 without replica node

    When Interrupt the node 1 of without replica nodes network for 100 seconds

    Then Node 1 without replica node state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running running
    [Teardown]    Run Keywords   Update the auto-salvage setting to true
    ...           AND            cleanup_resources

7-RWO 3 replicas abnormal non attached no replica node
    [Documentation]    Case 2-2
    [Tags]    NodeNetworkPartition    RWO    3Replicas    AttachReplicaSameNode    AbnormalReplicaNode    AbnormalAttachedNode   
    Given The ${volume_size_gb} GB RWO volume with 3 replicas
    And Update the auto-salvage setting to false
    And Attach volume to the node 1 with replica node

    When Interrupt the node 1 of with replica nodes network for 100 seconds

    Then Node 1 with replica node state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running running
    [Teardown]    Run Keywords   Update the auto-salvage setting to true
    ...           AND            cleanup_resources

8-RWX 3 replicas abnormal non attached no replica node
    [Documentation]    Case 2-2
    [Tags]    NodeNetworkPartition    RWX    3Replicas    AttachReplicaSameNode    AbnormalReplicaNode    AbnormalAttachedNode
    Given The ${volume_size_gb} GB RWX volume with 3 replicas
    And Update the auto-salvage setting to false
    And Attach volume to the node 1 with replica node

    When Interrupt the node 1 of with replica nodes network for 100 seconds

    Then Node 1 with replica node state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running running
    [Teardown]    Run Keywords   Update the auto-salvage setting to true
    ...           AND            cleanup_resources
