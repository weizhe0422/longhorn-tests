*** Settings ***
Documentation     Test the resillence if cluster node happend exception
...              Keywords are imported from the resource file
Resource          ../../keywords/node.resource
Resource          ../../keywords/common.resource

Suite Setup    set_test_suite_environment

Test setup    set_test_environment    ${TEST NAME}

Test Teardown    cleanup_resources

*** Variable ***
${volume_size_gb}=    1
${POD_EVICTION_TIME_OUT}=    300

*** Test Cases ***
1-Power off RWO volume attached node with replica
    [Documentation]    RWO volume with replica on attached node and powering off the volume attached node  
    [Tags]    NodePoweringOff    RWO    3Replicas    AttachReplicaSameNode    AbnormalReplicaNode    AbnormalAttachedNode
    # Recover: After restart the node, volume should be detached and replica is failed-Need manual to do reattached.
    Given The ${volume_size_gb} GB RWO volume with 3 replicas
    And Attach volume to the node 1 with replica node
    And Write data into mount point

    When Power off the node 1 with replica node

    Then Node 1 with replica node state should be NotReady
    And Volume state should be unknown
    And Engine state should be unknown
    And Replica state on node 1 with replica should be unknown

    When Power on the node 1 with replica node

    Then Node 1 with replica node state should be Ready
    And Volume state should be unknown
    And Engine state should be unknown
    And Replica state on node 1 with replica should be stopped
    [Teardown]    cleanup_resources

2-Power off RWO volume not-attached node with replica
    [Tags]    NodePoweringOff    RWO    3Replicas    AttachReplicaDiffNode    AbnormalReplicaNode    AbnormalNoAttachedNode
    # Recover: After restart the node, delete the stopped replica, and re-update the replica count to do rebuilding
    Given The ${volume_size_gb} GB RWO volume with 3 replicas
    And Attach volume to the node 1 with replica node
    And Write data into mount point

    When Power off the node 2 with replica node

    Then Node 2 with replica node state should be NotReady
    And Volume state should be degraded
    And Engine state should be running
    And Replica state on node 2 with replica should be stopped
    And Data is intact

    When Power on the node 2 with replica node

    Then Node 2 with replica node state should be Ready
    And Volume state should be degraded
    And Engine state should be running
    And All replicas state should be running
    And Data is intact
    [Teardown]    cleanup_resources

3-Power off RWO volume attached node without replica
    [Documentation]    
    [Tags]    NodePoweringOff    RWO    2Replicas    AttachReplicaSameNode    AbnormalNoReplicaNode    AbnormalAttachedNode
    Given The ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 1 without replica node
    And Write data into mount point

    When Power off the node 1 without replica node

    Then Node 1 without replica node state should be NotReady
    And Volume state should be unknown
    And Engine state should be unknown
    And All replicas state should be running

    When Power on the node 1 without replica node

    Then Node 1 without replica node state should be Ready
    And Volume state should be unknown
    And Engine state should be unknown
    And All replicas state should be running
    And Data is intact
    [Teardown]    cleanup_resources

4-Power off RWO volume not-attached node without replica
    [Documentation]
    [Tags]    NodePoweringOff    RWO    2Replicas    AttachReplicaDiffNode    AbnormalReplicaNode    AbnormalNoAttachedNode
    Given The ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 1 without replica node
    And Write data into mount point

    When Power off the node 1 with replica node

    Then Node 1 with replica node state should be NotReady
    And Volume state should be degraded
    And Engine state should be running
    And Replica state on node 1 with replica should be stopped

    When Power on the node 1 with replica node

    Then Node 1 with replica node state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    [Teardown]    cleanup_resources

5-Power off 2 replica RWO volume attached node with replica
    [Documentation]
    [Tags]    NodePoweringOff    RWO    2Replicas    AttachReplicaSameNode    AbnormalReplicaNode    AbnormalAttachedNode
    Given The ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 1 with replica node
    And Write data into mount point

    When Power off the node 1 with replica node

    Then Node 1 with replica node state should be NotReady
    And Volume state should be unknown
    And Engine state should be unknown
    And Replica state on node 1 with replica should be unknown

    When Power on the node 1 with replica node

    Then Node 1 with replica node state should be Ready
    And Volume state should be unknown
    And Engine state should be unknown
    And All replicas state should be running
    [Teardown]    cleanup_resources

6-Power off 2 replica RWO volume non-attached node wo replica
    [Documentation]
    [Tags]    NodePoweringOff    RWO    2Replicas    AttachReplicaDiffNode    AbnormalNoReplicaNode    AbnormalNoAttachedNode
    Given The ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 1 with replica node
    And Write data into mount point

    When Power off the node 1 without replica node

    Then Node 1 without replica node state should be NotReady
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running

    When Power on the node 1 without replica node

    Then Node 1 without replica node state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    [Teardown]    cleanup_resources

7-Power off 2 replica RWO volume non-attached node with replica
    [Documentation]
    [Tags]    NodePoweringOff    RWO    2Replicas    AttachReplicaDiffNode    AbnormalReplicaNode    AbnormalNoAttachedNode
    Given The ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 1 with replica node
    And Write data into mount point

    When Power off the node 2 with replica node

    Then Node 2 with replica node state should be NotReady
    And Volume state should be healthy
    And Engine state should be running
    And Replica state on node 1 with replica should be running
    And Replica state on node 2 with replica should be stopped
    And Data is intact

    When Power on the node 2 with replica node

    Then Node 2 with replica node state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And Replica state on node 1 with replica should be running
    And Replica state on node 2 with replica should be stopped
    [Teardown]    cleanup_resources

8-Power off RWO volume attached node with replica time out
    [Documentation]    RWO volume with replica on attached node and powering off the volume attached node  
    [Tags]    NodePoweringOff    RWO    3Replicas    AttachReplicaSameNode    AbnormalReplicaNode    AbnormalAttachedNode
    # Recover: After restart the node, volume should be detached and replica is failed-Need manual to do reattached.
    Given The ${volume_size_gb} GB RWO volume with 3 replicas
    And Attach volume to the node 1 with replica node
    And Write data into mount point

    When Power off the node 1 with replica node
    And Sleep ${POD_EVICTION_TIME_OUT} seconds
   
    Then Node 1 with replica node state should be NotReady
    And Volume state should be unknown
    And Engine state should be unknown
    And Replica state on node 1 with replica should be unknown

    When Power on the node 1 with replica node

    Then Node 1 with replica node state should be Ready
    And Volume state should be unknown
    And Engine state should be unknown
    And All replicas state should be running
    [Teardown]    cleanup_resources

9-Power off RWO volume not-attached node with replica time out
    [Tags]    NodePoweringOff    RWO    3Replicas    AttachReplicaDiffNode    AbnormalReplicaNode    AbnormalNoAttachedNode
    # Recover: After restart the node, delete the stopped replica, and re-update the replica count to do rebuilding
    Given The ${volume_size_gb} GB RWO volume with 3 replicas
    And Attach volume to the node 1 with replica node
    And Write data into mount point

    When Power off the node 2 with replica node
    And Sleep ${POD_EVICTION_TIME_OUT} seconds

    Then Node 2 with replica node state should be NotReady
    And Volume state should be degraded
    And Engine state should be running
    And Replica state on node 1 with replica should be running
    And Replica state on node 2 with replica should be stopped
    And Replica state on node 3 with replica should be running

    When Power on the node 2 with replica node

    Then Node 2 with replica node state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    [Teardown]    cleanup_resources

10-Power off RWO volume attached node wo replica time out
    [Documentation]    
    [Tags]    NodePoweringOff    RWO    2Replicas    AttachReplicaSameNode    AbnormalNoReplicaNode    AbnormalAttachedNode
    Given The ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 1 without replica node
    And Write data into mount point

    When Power off the node 1 without replica node
    And Sleep ${POD_EVICTION_TIME_OUT} seconds

    Then Node 1 without replica node state should be NotReady
    And Volume state should be unknown
    And Engine state should be unknown
    And All replicas state should be running

    When Power on the node 1 without replica node

    Then Node 1 without replica node state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    [Teardown]    cleanup_resources

11-Power off RWO volume not-attached node wo replica time out
    [Documentation]
    [Tags]    NodePoweringOff    RWO    2Replicas    AttachReplicaDiffNode    AbnormalReplicaNode    AbnormalNoAttachedNode
    Given The ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 1 without replica node
    And Write data into mount point

    When Power off the node 1 with replica node
    And Sleep ${POD_EVICTION_TIME_OUT} seconds

    Then Node 1 with replica node state should be NotReady
    And Volume state should be degraded
    And Engine state should be running
    And Replica state on node 1 with replica should be stopped
    And Replica state on node 2 with replica should be running

    When Power on the node 1 with replica node

    Then Node 1 with replica node state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    [Teardown]    cleanup_resources

12-Power off 2 replica RWO attach node with replica time out
    [Documentation]
    [Tags]    NodePoweringOff    RWO    2Replicas    AttachReplicaSameNode    AbnormalReplicaNode    AbnormalAttachedNode
    Given The ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 1 with replica node
    And Write data into mount point

    When Power off the node 1 with replica node
    And Sleep ${POD_EVICTION_TIME_OUT} seconds

    Then Node 1 with replica node state should be NotReady
    And Volume state should be unknown
    And Engine state should be unknown
    And Replica state on node 1 with replica should be unknown
    And Replica state on node 2 with replica should be running

    When Power on the node 1 with replica node

    Then Node 1 with replica node state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    [Teardown]    cleanup_resources

13-Power off 2 replica RWO no attach node no replica time out
    [Documentation]
    [Tags]    NodePoweringOff    RWO    2Replicas    AttachReplicaDiffNode    AbnormalNoReplicaNode    AbnormalNoAttachedNode
    Given The ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 1 with replica node
    And Write data into mount point

    When Power off the node 1 without replica node
    And Sleep ${POD_EVICTION_TIME_OUT} seconds

    Then Node 1 without replica node state should be NotReady
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running

    When Power on the node 1 without replica node

    Then Node 1 without replica node state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    [Teardown]    cleanup_resources

14-Power off 2 replica RWO no attach node with replica time out
    [Documentation]
    [Tags]    NodePoweringOff    RWO    2Replicas    AttachReplicaDiffNode    AbnormalReplicaNode    AbnormalAttachedNode
    Given The ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 1 with replica node
    And Write data into mount point

    When Power off the node 2 with replica node
    And Sleep ${POD_EVICTION_TIME_OUT} seconds

    Then Node 2 with replica node state should be NotReady
    And Volume state should be healthy
    And Engine state should be running
    And Replica state on node 1 with replica should be running
    And Replica state on node 2 with replica should be stopped

    When Power on the node 2 with replica node

    Then Node 2 with replica node state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And Replica state on node 1 with replica should be running
    And Replica state on node 2 with replica should be stopped
    And Data is intact
    [Teardown]    cleanup_resources
