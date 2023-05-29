*** Settings ***
Documentation     Test the Longhorn resillence if cluster node powering off

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
${POD_EVICTION_TIME_OUT}=    300

*** Test Cases ***
999-Test
    Given A ${volume_size_gb} GB RWO volume with 3 replicas
    [Teardown]    Teardown

1-Power off RWO volume attached node with replica
    [Documentation]    RWO volume with replica on attached node and powering off the volume attached node
    [Tags]    NodePoweringOff    RWO    3Replicas    AttachReplicaSameNode    AbnormalReplicaNode    AbnormalAttachedNode
    # Recover: After restart the node, volume should be detached and replica is failed-Need manual to do reattached.
    Given A ${volume_size_gb} GB RWO volume with 3 replicas
    And Attach volume to the node 1
    And Write data into mount point

    When Power off the node 1

    Then The Node 1 state should be NotReady
    And Volume state should be unknown
    And Engine state should be unknown
    And Replica state on node 1 should be unknown

    When Power on the node 1

    Then The node 1 state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data should be intact
    [Teardown]    Teardown

2-Power off RWO volume not-attached node with replica
    [Tags]    NodePoweringOff    RWO    3Replicas    AttachReplicaDiffNode    AbnormalReplicaNode    AbnormalNoAttachedNode
    # Recover: After restart the node, delete the stopped replica, and re-update the replica count to do rebuilding
    Given A ${volume_size_gb} GB RWO volume with 3 replicas
    And Attach volume to the node 1
    And Write data into mount point

    When Power off the node 2

    Then The node 2 state should be NotReady
    And Volume state should be degraded
    And Engine state should be running
    And Replica state on node 2 should be stopped
    And Data should be intact

    When Power on the node 2

    Then The node 2 state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data should be intact
    [Teardown]    Teardown

3-Power off RWO volume attached node without replica
    [Documentation]
    [Tags]    NodePoweringOff    RWO    2Replicas    AttachReplicaSameNode    AbnormalNoReplicaNode    AbnormalAttachedNode
    Given A ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 3
    And Write data into mount point

    When Power off the node 3

    Then The node 3 state should be NotReady
    And Volume state should be unknown
    And Engine state should be unknown
    And All replicas state should be running

    When Power on the node 3

    Then The node 3 state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data should be intact
    [Teardown]    Teardown

4-Power off RWO volume not-attached node without replica
    [Documentation]
    [Tags]    NodePoweringOff    RWO    2Replicas    AttachReplicaDiffNode    AbnormalReplicaNode    AbnormalNoAttachedNode
    Given A ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 3
    And Write data into mount point

    When Power off the node 1

    Then The node 1 state should be NotReady
    And Volume state should be degraded
    And Engine state should be running
    And Replica state on node 1 should be stopped

    When Power on the node 1

    Then The node 1 state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data should be intact
    [Teardown]    Teardown

5-Power off 2 replica RWO volume attached node with replica
    [Documentation]
    [Tags]    NodePoweringOff    RWO    2Replicas    AttachReplicaSameNode    AbnormalReplicaNode    AbnormalAttachedNode
    Given A ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 1
    And Write data into mount point

    When Power off the node 1

    Then The node 1 state should be NotReady
    And Volume state should be unknown
    And Engine state should be unknown
    And Replica state on node 1 should be unknown

    When Power on the node 1

    Then The node 1 state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data should be intact
    [Teardown]    Teardown

6-Power off 2 replica RWO volume non-attached node wo replica
    [Documentation]
    [Tags]    NodePoweringOff    RWO    2Replicas    AttachReplicaDiffNode    AbnormalNoReplicaNode    AbnormalNoAttachedNode
    Given A ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 1
    And Write data into mount point

    When Power off the node 3

    Then The node 3 state should be NotReady
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running

    When Power on the node 3

    Then The node 3 state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data should be intact
    [Teardown]    Teardown

7-Power off 2 replica RWO volume non-attached node with replica
    [Documentation]
    [Tags]    NodePoweringOff    RWO    2Replicas    AttachReplicaDiffNode    AbnormalReplicaNode    AbnormalNoAttachedNode
    Given A ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 1
    And Write data into mount point

    When Power off the node 2

    Then The node 2 state should be NotReady
    And Volume state should be healthy
    And Engine state should be running
    And Replica state on node 1 should be running
    And Replica state on node 2 should be stopped
    And Data should be intact

    When Power on the node 2

    Then The node 2 state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And Replica state on node 1 should be running
    And Replica state on node 2 should be stopped
    And Data should be intact
    [Teardown]    Teardown

8-Power off RWO volume attached node with replica time out
    [Documentation]    RWO volume with replica on attached node and powering off the volume attached node
    [Tags]    NodePoweringOff    RWO    3Replicas    AttachReplicaSameNode    AbnormalReplicaNode    AbnormalAttachedNode
    # Recover: After restart the node, volume should be detached and replica is failed-Need manual to do reattached.
    Given A ${volume_size_gb} GB RWO volume with 3 replicas
    And Attach volume to the node 1
    And Write data into mount point

    When Power off the node 1
    And Sleep ${POD_EVICTION_TIME_OUT} seconds

    Then The node 1 state should be NotReady
    And Volume state should be unknown
    And Engine state should be unknown
    And Replica state on node 1 should be unknown

    When Power on the node 1

    Then The node 1 state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    [Teardown]    Teardown

9-Power off RWO volume not-attached node with replica time out
    [Tags]    NodePoweringOff    RWO    3Replicas    AttachReplicaDiffNode    AbnormalReplicaNode    AbnormalNoAttachedNode
    # Recover: After restart the node, delete the stopped replica, and re-update the replica count to do rebuilding
    Given A ${volume_size_gb} GB RWO volume with 3 replicas
    And Attach volume to the node 1
    And Write data into mount point

    When Power off the node 2
    And Sleep ${POD_EVICTION_TIME_OUT} seconds

    Then The node 2 state should be NotReady
    And Volume state should be degraded
    And Engine state should be running
    And Replica state on node 1 should be running
    And Replica state on node 2 should be stopped
    And Replica state on node 3 should be running

    When Power on the node 2

    Then The node 2 state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data should be intact
    [Teardown]    Teardown

10-Power off RWO volume attached node wo replica time out
    [Documentation]
    [Tags]    NodePoweringOff    RWO    2Replicas    AttachReplicaSameNode    AbnormalNoReplicaNode    AbnormalAttachedNode
    Given A ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 3
    And Write data into mount point

    When Power off the node 3
    And Sleep ${POD_EVICTION_TIME_OUT} seconds

    Then The node 3 state should be NotReady
    And Volume state should be unknown
    And Engine state should be unknown
    And All replicas state should be running

    When Power on the node 3

    Then The node 3 state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    [Teardown]    Teardown

11-Power off RWO volume not-attached node wo replica time out
    [Documentation]
    [Tags]    NodePoweringOff    RWO    2Replicas    AttachReplicaDiffNode    AbnormalReplicaNode    AbnormalNoAttachedNode
    Given A ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 3
    And Write data into mount point

    When Power off the node 1
    And Sleep ${POD_EVICTION_TIME_OUT} seconds

    Then The node 1 state should be NotReady
    And Volume state should be degraded
    And Engine state should be running
    And Replica state on node 1 should be stopped
    And Replica state on node 2 should be running

    When Power on the node 1

    Then The node 1 state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data should be intact
    [Teardown]    Teardown

12-Power off 2 replica RWO attach node with replica time out
    [Documentation]
    [Tags]    NodePoweringOff    RWO    2Replicas    AttachReplicaSameNode    AbnormalReplicaNode    AbnormalAttachedNode
    Given A ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 1
    And Write data into mount point

    When Power off the node 1
    And Sleep ${POD_EVICTION_TIME_OUT} seconds

    Then The node 1 state should be NotReady
    And Volume state should be unknown
    And Engine state should be unknown
    And Replica state on node 1 should be unknown
    And Replica state on node 2 should be running

    When Power on the node 1

    Then The node 1 state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    [Teardown]    Teardown

13-Power off 2 replica RWO no attach node no replica time out
    [Documentation]
    [Tags]    NodePoweringOff    RWO    2Replicas    AttachReplicaDiffNode    AbnormalNoReplicaNode    AbnormalNoAttachedNode
    Given A ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 1
    And Write data into mount point

    When Power off the node 3
    And Sleep ${POD_EVICTION_TIME_OUT} seconds

    Then The node 3 state should be NotReady
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running

    When Power on the node 3

    Then The node 3 state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data should be intact
    [Teardown]    Teardown

14-Power off 2 replica RWO no attach node with replica time out
    [Documentation]
    [Tags]    NodePoweringOff    RWO    2Replicas    AttachReplicaDiffNode    AbnormalReplicaNode    AbnormalAttachedNode
    Given A ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 1
    And Write data into mount point

    When Power off the node 2
    And Sleep ${POD_EVICTION_TIME_OUT} seconds

    Then The node 2 state should be NotReady
    And Volume state should be healthy
    And Engine state should be running
    And Replica state on node 1 should be running
    And Replica state on node 2 should be stopped

    When Power on the node 2

    Then The node 2 state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And Replica state on node 1 should be running
    And Replica state on node 2 should be stopped
    And Data should be intact
    [Teardown]    Teardown
