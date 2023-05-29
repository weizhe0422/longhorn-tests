*** Settings ***
Documentation     Test the resillence if cluster node happend exception
...
...               Keywords are imported from the resource file
Resource          ../../keywords/node.resource
Resource          ../../keywords/common.resource

Suite Setup    set_test_suite_environment

Test setup    set_test_environment    ${TEST NAME}

Test Teardown    cleanup_resources

*** Variable ***
${volume_size_gb}=    1

*** Test Cases ***
1-RWO 3 replicas abnormal attached and replica node
    [Tags]    NodeReboot    RWO    3Replicas    AttachReplicaSameNode    AbnormalAttachedNode    AbnormalReplicaNode
    # Recover: After restart the node, volume should be detached and replica is failed. Need manual to do reattached.
    Given The ${volume_size_gb} GB RWX volume with 3 replicas
    And Attach volume to the node 1 with replica node
    And Write data into mount point

    When Reboot the node 1 with replica node

    Then Node 1 with replica node state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data is intact
    [Teardown]    cleanup_resources

2-RWO 3 replicas abnormal replica but non attached node
    [Tags]    NodeReboot    RWO    3Replicas    AttachReplicaDiffNode    AbnormalNonAttachedNode    AbnormalReplicaNode
    # Recover: After restart the node, delete the stopped replica, and re-update the replica count to do rebuilding
    Given The ${volume_size_gb} GB RWX volume with 3 replicas
    And Attach volume to the node 1 with replica node
    And Write data into mount point

    When Reboot the node 2 with replica node

    Then Node 2 with replica node state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data is intact
    [Teardown]    cleanup_resources

3-RWO 2 replicas abnormal non attached and no replica node
    [Tags]    NodeReboot    RWO    2Replicas    AttachReplicaSameNode    AbnormalNonAttachedNode    AbnormalNonReplicaNode
    Given The ${volume_size_gb} GB RWX volume with 2 replicas
    And Attach volume to the node 1 without replica node
    And Write data into mount point

    When Reboot the node 1 without replica node

    Then Node 1 without replica node state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data is intact
    [Teardown]    cleanup_resources

4-RWO 2 replicas abnormal replica but non attached node
    [Tags]    NodeReboot    RWO    2Replicas    AttachReplicaDiffNode    AbnormalNonAttachedNode    AbnormalReplicaNode
    Given The ${volume_size_gb} GB RWX volume with 2 replicas
    And Attach volume to the node 1 without replica node
    And Write data into mount point

    When Reboot the node 1 with replica node

    Then Node 1 with replica node state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data is intact
    [Teardown]    cleanup_resources

5-RWO 2 replicas abnormal attached and replica node
    [Tags]    NodeReboot    RWO    2Replicas    AttachReplicaSameNode    AbnormalAttachedNode    AbnormalReplicaNode
    Given The ${volume_size_gb} GB RWX volume with 2 replicas
    And Attach volume to the node 1 with replica node
    And Write data into mount point

    When Reboot the node 1 with replica node

    Then Node 1 with replica node state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data is intact
    [Teardown]    cleanup_resources
    
6-RWO 2 replicas abnormal on non attached and no replica node
    [Tags]    NodeReboot    RWO    2Replicas    AttachReplicaDiffNode    AbnormalNonAttachedNode    AbnormalNonReplicaNode
    Given The ${volume_size_gb} GB RWX volume with 2 replicas
    And Attach volume to the node 1 with replica node
    And Write data into mount point

    When Reboot the node 1 without replica node

    Then Node 1 without replica node state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data is intact
    [Teardown]    cleanup_resources
    
7-RWO 2 replicas abnormal attached and replica but diff node
    [Tags]    NodeReboot    RWO    2Replicas    AttachReplicaDiffNode    AbnormalNonAttachedNode    AbnormalReplicaNode
    Given The ${volume_size_gb} GB RWX volume with 2 replicas
    And Attach volume to the node 1 with replica node
    And Write data into mount point

    When Reboot the node 2 with replica node

    Then Node 2 with replica node state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data is intact
    [Teardown]    cleanup_resources
