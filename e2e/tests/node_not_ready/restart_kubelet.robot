*** Settings ***
Documentation     Test the Longhorn resillence if cluster node kubelet restart

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
    [Tags]    RestartKubelet    RWO    3Replicas    AttachHasReplica    AttachReplicaSameNode    AbnormalAttachedNode    AbnormalReplicaNode
    # Recover: After restart the node, volume should be detached and replica is failed. Need manual to do reattached.
    Given A ${volume_size_gb} GB RWO volume with 3 replicas
    And Attach volume to the node 1
    And Write data into mount point

    When Restart Kubelet the node 1

    Then The node 1 state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data should be intact
    [Teardown]    Teardown

2-RWO 3 replicas abnormal replica but non attached node
    [Tags]    RestartKubelet    RWO    3Replicas    AttachHasReplica    AttachReplicaDiffNode    AbnormalNonAttachedNode    AbnormalReplicaNode
    # Recover: After restart the node, delete the stopped replica, and re-update the replica count to do rebuilding
    Given A ${volume_size_gb} GB RWO volume with 3 replicas
    And Attach volume to the node 1
    And Write data into mount point

    When Restart Kubelet the node 2

    Then The node 2 state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data should be intact
    [Teardown]    Teardown

3-RWO 2 replicas abnormal non attached and no replica node
    [Tags]    RestartKubelet    RWO    3Replicas    AttachHasReplica    AttachReplicaSameNode    AbnormalNonAttachedNode    AbnormalNonReplicaNode
    Given A ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 3
    And Write data into mount point

    When Restart Kubelet the node 3

    Then The node 3 state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data should be intact
    [Teardown]    Teardown

4-RWO 2 replicas abnormal replica but non attached node
    [Tags]    RestartKubelet    RWO    2Replicas    AttachNoReplica    AttachReplicaDiffNode    AbnormalNonAttachedNode    AbnormalReplicaNode
    Given A ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 3
    And Write data into mount point

    When Restart Kubelet the node 1

    Then The node 1 state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data should be intact
    [Teardown]    Teardown

5-RWO 2 replicas abnormal attached and replica node
    [Tags]    RestartKubelet    RWO    2Replicas    AttachHasReplica    AttachReplicaSameNode    AbnormalAttachedNode    AbnormalReplicaNode
    Given A ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 1
    And Write data into mount point

    When Restart Kubelet the node 1

    Then The node 1 state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data should be intact
    [Teardown]    Teardown

6-RWO 2 replicas abnormal on non attached and no replica node
    [Tags]    RestartKubelet    RWO    2Replicas    AttachHasReplica    AttachReplicaDiffNode    AbnormalNonAttachedNode    AbnormalNonReplicaNode
    Given A ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 1
    And Write data into mount point

    When Restart Kubelet the node 3

    Then The node 3 state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data should be intact
    [Teardown]    Teardown

7-RWO 2 replicas abnormal attached and replica but diff node
    [Tags]    RestartKubelet    RWO    2Replicas    AttachHasReplica    AttachReplicaDiffNode    AbnormalNonAttachedNode    AbnormalReplicaNode
    Given A ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 1
    And Write data into mount point

    When Restart Kubelet the node 2

    Then The node 2 state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data should be intact
    [Teardown]    Teardown

8-RWX 3 replicas abnormal attached and replica node
    [Tags]    RestartKubelet    RWX    3Replicas    AttachHasReplica    AttachReplicaSameNode    AbnormalAttachedNode    AbnormalReplicaNode
    # Recover: After restart the node, volume should be detached and replica is failed. Need manual to do reattached.
    Given A ${volume_size_gb} GB RWX volume with 3 replicas
    And Attach volume to the node 1
    And Write data into mount point

    When Restart Kubelet the node 1

    Then The node 1 state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data should be intact
    [Teardown]    Teardown

9-RWX 3 replicas abnormal replica but non attached node
    [Tags]    RestartKubelet    RWX    3Replicas    AttachHasReplica    AttachReplicaDiffNode    AbnormalNonAttachedNode    AbnormalReplicaNode
    # Recover: After restart the node, delete the stopped replica, and re-update the replica count to do rebuilding
    Given A ${volume_size_gb} GB RWX volume with 3 replicas
    And Attach volume to the node 1
    And Write data into mount point

    When Restart Kubelet the node 2

    Then The node 2 state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data should be intact
    [Teardown]    Teardown

10-RWX 2 replicas abnormal on non attached and no replica node
    [Tags]    RestartKubelet    RWX    2Replicas    AttachNoReplica    AttachReplicaSameNode    AbnormalNonAttachedNode    AbnormalNonReplicaNode
    Given A ${volume_size_gb} GB RWX volume with 2 replicas
    And Attach volume to the node 3
    And Write data into mount point

    When Restart Kubelet the node 1

    Then The node 3 state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data should be intact
    [Teardown]    Teardown

11-RWX 2 replicas abnormal replica but non attached node
    [Tags]    RestartKubelet    RWX    2Replicas    AttachNoReplica    AttachReplicaDiffNode    AbnormalNonAttachedNode    AbnormalReplicaNode
    Given A ${volume_size_gb} GB RWX volume with 2 replicas
    And Attach volume to the node 3
    And Write data into mount point

    When Restart Kubelet the node 1

    Then The node 1 state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data should be intact
    [Teardown]    Teardown

12-RWX 2 replicas abnormal on attached and replica node
    [Tags]    RestartKubelet    RWX    2Replicas    AttachHasReplica    AttachReplicaSameNode    AbnormalAttachedNode    AbnormalReplicaNode
    Given A ${volume_size_gb} GB RWX volume with 2 replicas
    And Attach volume to the node 1
    And Write data into mount point

    When Restart Kubelet the node 1

    Then The node 1 state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data should be intact
    [Teardown]    Teardown

13-RWX 2 replicas abnormal non attached and no replica node
    [Tags]    RestartKubelet    RWX    2Replicas    AttachHasReplica    AttachReplicaDiffNode    AbnormalNonAttachedNode    AbnormalNonReplicaNode
    Given A ${volume_size_gb} GB RWX volume with 2 replicas
    And Attach volume to the node 1
    And Write data into mount point

    When Restart Kubelet the node 3

    Then The node 3 state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data should be intact
    [Teardown]    Teardown

14-RWX 2 replicas abnormal attached and replica but diff node
    [Tags]    RestartKubelet    RWX    2Replicas    AttachHasReplica    AttachReplicaDiffNode    AbnormalNonAttachedNode    AbnormalReplicaNode
    Given A ${volume_size_gb} GB RWX volume with 2 replicas
    And Attach volume to the node 1
    And Write data into mount point

    When Restart Kubelet the node 2

    Then The node 2 state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data should be intact
    [Teardown]    Teardown

15-RWO 3 replicas abnormal attached and replica node timeout
    [Tags]    RestartKubelet    RWO    3Replicas    AttachHasReplica    AttachReplicaSameNode    AbnormalAttachedNode    AbnormalReplicaNode    Timeout
    # Recover: After restart the node, volume should be detached and replica is failed. Need manual to do reattached.
    Given A ${volume_size_gb} GB RWO volume with 3 replicas
    And Attach volume to the node 1
    And Write data into mount point

    When Restart Kubelet timeout on the node 1

    Then The node 1 state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data should be intact
    [Teardown]    Teardown

16-RWO 3 replicas abnormal replica but no attached node timeout
    [Tags]    RestartKubelet    RWO    3Replicas    AttachHasReplica    AttachReplicaDiffNode    AbnormalNonAttachedNode    AbnormalReplicaNode    Timeout
    # Recover: After restart the node, delete the stopped replica, and re-update the replica count to do rebuilding
    Given A ${volume_size_gb} GB RWO volume with 3 replicas
    And Attach volume to the node 1
    And Write data into mount point

    When Restart Kubelet timeout on the node 2

    Then The node 2 state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data should be intact
    [Teardown]    Teardown

17-RWO 2 replicas abnormal no attached no replica node timeout
    [Tags]    RestartKubelet    RWO    3Replicas    AttachHasReplica    AttachReplicaSameNode    AbnormalNonAttachedNode    AbnormalNonReplicaNode    Timeout
    Given A ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 3
    And Write data into mount point

    When Restart Kubelet timeout on the node 3

    Then The node 3 state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data should be intact
    [Teardown]    Teardown

18-RWO 2 replicas abnormal replica but no attached node timeout
    [Tags]    RestartKubelet    RWO    2Replicas    AttachNoReplica    AttachReplicaDiffNode    AbnormalNonAttachedNode    AbnormalReplicaNode    Timeout
    Given A ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 3
    And Write data into mount point

    When Restart Kubelet timeout on the node 1

    Then The node 1 state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data should be intact
    [Teardown]    Teardown

19-RWO 2 replicas abnormal attached replica node timeout
    [Tags]    RestartKubelet    RWO    2Replicas    AttachHasReplica    AttachReplicaSameNode    AbnormalAttachedNode    AbnormalReplicaNode    Timeout
    Given A ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 1
    And Write data into mount point

    When Restart Kubelet timeout on the node 1

    Then The node 1 state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data should be intact
    [Teardown]    Teardown

20-RWO 2 replicas abnormal no attached no replica node timeout
    [Tags]    RestartKubelet    RWO    2Replicas    AttachHasReplica    AttachReplicaDiffNode    AbnormalNonAttachedNode    AbnormalNonReplicaNode    Timeout
    Given A ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 1
    And Write data into mount point

    When Restart Kubelet timeout on the node 3

    Then The node 3 state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data should be intact
    [Teardown]    Teardown

21-RWO 2 replicas abnormal attached replica diff node timeout
    [Tags]    RestartKubelet    RWO    2Replicas    AttachHasReplica    AttachReplicaDiffNode    AbnormalNonAttachedNode    AbnormalReplicaNode    Timeout
    Given A ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 1
    And Write data into mount point

    When Restart Kubelet timeout on the node 2

    Then The node 2 state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data should be intact
    [Teardown]    Teardown

22-RWX 3 replicas abnormal attached replica node timeout
    [Tags]    RestartKubelet    RWX    3Replicas    AttachHasReplica    AttachReplicaSameNode    AbnormalAttachedNode    AbnormalReplicaNode    Timeout
    # Recover: After restart the node, volume should be detached and replica is failed. Need manual to do reattached.
    Given A ${volume_size_gb} GB RWX volume with 3 replicas
    And Attach volume to the node 1
    And Write data into mount point

    When Restart Kubelet timeout on the node 1

    Then The node 1 state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data should be intact
    [Teardown]    Teardown

23-RWX 3 replicas abnormal replica non attached node timout
    [Tags]    RestartKubelet    RWX    3Replicas    AttachHasReplica    AttachReplicaDiffNode    AbnormalNonAttachedNode    AbnormalReplicaNode    Timeout
    # Recover: After restart the node, delete the stopped replica, and re-update the replica count to do rebuilding
    Given A ${volume_size_gb} GB RWX volume with 3 replicas
    And Attach volume to the node 1
    And Write data into mount point

    When Restart Kubelet timeout on the node 2

    Then The node 2 state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data should be intact
    [Teardown]    Teardown

24-RWX 2 replicas abnormal non attached no replica node timout
    [Tags]    RestartKubelet    RWX    3Replicas    AttachHasReplica    AttachReplicaSameNode    AbnormalNonAttachedNode    AbnormalNonReplicaNode    Timeout
    Given A ${volume_size_gb} GB RWX volume with 2 replicas
    And Attach volume to the node 3
    And Write data into mount point

    When Restart Kubelet timeout on the node 3

    Then The node 3 state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data should be intact
    [Teardown]    Teardown

25-RWX 2 replicas abnormal replica non attached node timeout
    [Tags]    RestartKubelet    RWX    2Replicas    AttachNoReplica    AttachNoReplica    AttachReplicaDiffNode    AbnormalNonAttachedNode    AbnormalReplicaNode    Timeout
    Given A ${volume_size_gb} GB RWX volume with 2 replicas
    And Attach volume to the node 3
    And Write data into mount point

    When Restart Kubelet timeout on the node 1

    Then The node 1 state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data should be intact
    [Teardown]    Teardown

26-RWX 2 replicas abnormal on attached replica node timeout
    [Tags]    RestartKubelet    RWX    2Replicas    AttachHasReplica    AttachReplicaSameNode    AbnormalAttachedNode    AbnormalReplicaNode    Timeout
    Given A ${volume_size_gb} GB RWX volume with 2 replicas
    And Attach volume to the node 1
    And Write data into mount point

    When Restart Kubelet timeout on the node 1

    Then The node 1 state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data should be intact
    [Teardown]    Teardown

27-RWX 2 replicas abnormal non attached no replica node timeout
    [Tags]    RestartKubelet    RWX    2Replicas    AttachHasReplica    AttachReplicaDiffNode    AbnormalNonAttachedNode    AbnormalNonReplicaNode    Timeout
    Given A ${volume_size_gb} GB RWX volume with 2 replicas
    And Attach volume to the node 1
    And Write data into mount point

    When Restart Kubelet timeout on the node 3

    Then The node 3 state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data should be intact
    [Teardown]    Teardown

28-RWX 2 replicas abnormal attached replica diff node timeout
    [Tags]    RestartKubelet    RWX    2Replicas    AttachHasReplica    AttachReplicaDiffNode    AbnormalNonAttachedNode    AbnormalReplicaNode    Timeout
    Given A ${volume_size_gb} GB RWX volume with 2 replicas
    And Attach volume to the node 1
    And Write data into mount point

    When Restart Kubelet timeout on the node 2

    Then The node 2 state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data should be intact
    [Teardown]    Teardown