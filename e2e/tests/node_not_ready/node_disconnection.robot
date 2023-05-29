*** Settings ***
Documentation     Test the Longhorn resillence if cluster node network disconnection
...               Manual test case: https://longhorn.github.io/longhorn-tests/manual/pre-release/node-not-ready/node-disconnection/node-disconnection/
Resource          ../../keywords/common.resource
Resource          ../../keywords/engine.resource
Resource          ../../keywords/replica.resource
Resource          ../../keywords/node.resource
Resource          ../../keywords/volume.resource

Suite Setup    set_test_suite_environment

Test setup    set_test_environment    ${TEST NAME}

Test Teardown    cleanup_resources

*** Variable ***
${volume_size_gb}=    1

*** Test Cases ***
1-RWO 2 replica abnormal no attach no replica node data writing
    [Documentation]    Case 1-1
    [Tags]    NodeNetworkPartition    RWO    2Replicas    AttachReplicaSameNode    AbnormalNoReplicaNode    AbnormalNoAttachedNode    DataWriting
    Given A ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 3
    And Update the auto-salvage setting to false

    When During writing data into mount point interrupt the node 3 network for 100 seconds

    Then The Node 3 state should be Ready
    And Volume state should be faulted
    And Engine state should be stopped
    And All replicas state should be stopped
    [Teardown]    Run Keywords   Update the auto-salvage setting to true
    ...           AND            Teardown

2-RWX 2 replica abnormal no attach no replica node data writing
    [Documentation]    Case 1-1
    [Tags]    NodeNetworkPartition    RWX    2Replicas    AttachReplicaSameNode    AbnormalNoReplicaNode    AbnormalNoAttachedNode    DataWriting
    Given A ${volume_size_gb} GB RWX volume with 2 replicas
    And Attach volume to the node 3
    And Update the auto-salvage setting to false

    When During writing data into mount point interrupt the node 3 network for 100 seconds

    Then The node 3 state should be Ready
    And Volume state should be faulted
    And Engine state should be stopped
    And All replicas state should be stopped
    [Teardown]    Run Keywords   Update the auto-salvage setting to true
    ...           AND            Teardown

3-RWO 3 replicas abnormal attached replica node data writing
    [Documentation]    Case 1-2
    [Tags]    NodeNetworkPartition    RWO    3Replicas    AttachReplicaSameNode    AbnormalReplicaNode    AbnormalAttachedNode    DataWriting
    Given A ${volume_size_gb} GB RWO volume with 3 replicas
    And Attach volume to the node 1
    And Update the auto-salvage setting to false

    When During writing data into mount point interrupt the node 1 network for 100 seconds

    Then The node 1 state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    [Teardown]    Run Keywords   Update the auto-salvage setting to true
    ...           AND            Teardown

4-RWX 3 replicas abnormal attached replica node data writing
    [Documentation]    Case 1-2
    [Tags]    NodeNetworkPartition    RWX    3Replicas    AttachReplicaSameNode    AbnormalReplicaNode    AbnormalAttachedNode    DataWriting
    Given A ${volume_size_gb} GB RWX volume with 3 replicas
    And Attach volume to the node 1
    And Update the auto-salvage setting to false

    When During writing data into mount point interrupt the node 1 network for 100 seconds

    Then The node 1 state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    [Teardown]    Run Keywords   Update the auto-salvage setting to true
    ...           AND            Teardown

5-RWO 2 replicas abnormal non attached no replica node
    [Documentation]    Case 2-1
    [Tags]    NodeNetworkPartition    RWO    2Replicas    AttachReplicaSameNode    AbnormalNoReplicaNode    AbnormalNoAttachedNode
    Given A ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 3
    And Update the auto-salvage setting to false

    When Interrupt the node 3 network for 100 seconds

    Then The node 3 state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    [Teardown]    Run Keywords   Update the auto-salvage setting to true
    ...           AND            Teardown

6-RWX 2 replicas abnormal non attached no replica node
    [Documentation]    Case 2-1
    [Tags]    NodeNetworkPartition    RWX    2Replicas    AttachReplicaSameNode    AbnormalNoReplicaNode    AbnormalNoAttachedNode
    Given A ${volume_size_gb} GB RWX volume with 2 replicas
    And Attach volume to the node 3
    And Update the auto-salvage setting to false

    When Interrupt the node 3 network for 100 seconds

    Then The node 3 state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    [Teardown]    Run Keywords   Update the auto-salvage setting to true
    ...           AND            Teardown

7-RWO 3 replicas abnormal non attached no replica node
    [Documentation]    Case 2-2
    [Tags]    NodeNetworkPartition    RWO    3Replicas    AttachReplicaSameNode    AbnormalReplicaNode    AbnormalAttachedNode
    Given A ${volume_size_gb} GB RWO volume with 3 replicas
    And Attach volume to the node 1
    And Update the auto-salvage setting to false

    When Interrupt the node 1 network for 100 seconds

    Then The node 1 state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    [Teardown]    Run Keywords   Update the auto-salvage setting to true
    ...           AND            Teardown

8-RWX 3 replicas abnormal non attached no replica node
    [Documentation]    Case 2-2
    [Tags]    NodeNetworkPartition    RWX    3Replicas    AttachReplicaSameNode    AbnormalReplicaNode    AbnormalAttachedNode
    Given A ${volume_size_gb} GB RWX volume with 3 replicas

    And Update the auto-salvage setting to false

    When Interrupt the node 1 network for 100 seconds

    Then The node 1 state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    [Teardown]    Run Keywords   Update the auto-salvage setting to true
    ...           AND            Teardown
