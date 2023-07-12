*** Settings ***
Documentation     Test the Longhorn resillence if cluster node reboot

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
1-RWO 3 replicas abnormal attached and replica node
    [Tags]    NodeReboot    RWO    3Replicas    AttachReplicaSameNode    AbnormalAttachedNode    AbnormalReplicaNode
    # Recover: After restart the node, volume should be detached and replica is failed. Need manual to do reattached.
    Given A ${volume_size_gb} GB RWX volume with 3 replicas
    And Attach volume to node 1
    And Write data into mount point

    When Reboot node 1

    Then Node 1 should have 1 volume replica
    And Node 1 state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data should be intact
    [Teardown]    Teardown

2-RWO 3 replicas abnormal replica but non attached node
    [Tags]    NodeReboot    RWO    3Replicas    AttachReplicaDiffNode    AbnormalNonAttachedNode    AbnormalReplicaNode
    # Recover: After restart the node, delete the stopped replica, and re-update the replica count to do rebuilding
    Given A ${volume_size_gb} GB RWX volume with 3 replicas
    And Attach volume to node 1
    And Write data into mount point

    When Reboot node 2

    Then Node 1 should have 1 volume replica
    And Node 2 should have 1 volume replica
    And Node 2 state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data should be intact
    [Teardown]    Teardown

3-RWO 2 replicas abnormal non attached and no replica node
    [Tags]    NodeReboot    RWO    2Replicas    AttachReplicaSameNode    AbnormalNonAttachedNode    AbnormalNonReplicaNode
    Given A ${volume_size_gb} GB RWX volume with 2 replicas
    And Attach volume to node 3
    And Write data into mount point

    When Reboot node 3

    Then Node 3 should have 0 volume replica
    And Node 3 state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data should be intact
    [Teardown]    Teardown

4-RWO 2 replicas abnormal replica but non attached node
    [Tags]    NodeReboot    RWO    2Replicas    AttachReplicaDiffNode    AbnormalNonAttachedNode    AbnormalReplicaNode
    Given A ${volume_size_gb} GB RWX volume with 2 replicas
    And Attach volume to node 3
    And Write data into mount point

    When Reboot node 1

    Then Node 1 should have 1 volume replica
    And Node 3 should have 0 volume replica
    And Node 1 state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data should be intact
    [Teardown]    Teardown

5-RWO 2 replicas abnormal attached and replica node
    [Tags]    NodeReboot    RWO    2Replicas    AttachReplicaSameNode    AbnormalAttachedNode    AbnormalReplicaNode
    Given A ${volume_size_gb} GB RWX volume with 2 replicas
    And Attach volume to node 1
    And Write data into mount point

    When Reboot node 1

    Then Node 1 should have 1 volume replica
    And Node 1 state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data should be intact
    [Teardown]    Teardown

6-RWO 2 replicas abnormal on non attached and no replica node
    [Tags]    NodeReboot    RWO    2Replicas    AttachReplicaDiffNode    AbnormalNonAttachedNode    AbnormalNonReplicaNode
    Given A ${volume_size_gb} GB RWX volume with 2 replicas
    And Attach volume to node 1
    And Write data into mount point

    When Reboot node 3

    Then Node 1 should have 1 volume replica
    And Node 3 should have 0 volume replica
    And Node 3 state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data should be intact
    [Teardown]    Teardown

7-RWO 2 replicas abnormal attached and replica but diff node
    [Tags]    NodeReboot    RWO    2Replicas    AttachReplicaDiffNode    AbnormalNonAttachedNode    AbnormalReplicaNode
    Given A ${volume_size_gb} GB RWX volume with 2 replicas
    And Attach volume to node 1
    And Write data into mount point

    When Reboot node 2

    Then Node 1 should have 1 volume replica
    And Node 2 should have 1 volume replica
    And Node 2 state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data should be intact
    [Teardown]    Teardown
