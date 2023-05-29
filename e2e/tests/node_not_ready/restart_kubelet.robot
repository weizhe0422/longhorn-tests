*** Settings ***
Documentation     Test the resillence if cluster node happend exception
...
...               Keywords are imported from the resource file
Resource          ../../keywords/node.resource
Resource          ../../keywords/common.resource
Test setup    set_test_environment    ${TEST NAME}
Test Teardown    cleanup_resources

*** Variable ***
${volume_size_gb}=    1

*** Test Cases ***    
1-RWO 3 replicas abnormal attached and replica node 
    [Tags]    RestartKubelet    RWO    3Replicas    AttachHasReplica    AttachReplicaSameNode    AbnormalAttachedNode    AbnormalReplicaNode
    # Recover: After restart the node, volume should be detached and replica is failed. Need manual to do reattached.
    Given The ${volume_size_gb} GB RWO volume with 3 replicas
    And Attach volume to the node 1 with replica node
    And Write data into mount point

    When Restart Kubelet the node 1 with replica node

    Then Node 1 with replica node state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data is intact
    [Teardown]    cleanup_resources

2-RWO 3 replicas abnormal replica but non attached node
    [Tags]    RestartKubelet    RWO    3Replicas    AttachHasReplica    AttachReplicaDiffNode    AbnormalNonAttachedNode    AbnormalReplicaNode
    # Recover: After restart the node, delete the stopped replica, and re-update the replica count to do rebuilding
    Given The ${volume_size_gb} GB RWO volume with 3 replicas
    And Attach volume to the node 1 with replica node
    And Write data into mount point

    When Restart Kubelet the node 2 with replica node

    Then Node 2 with replica node state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data is intact
    [Teardown]    cleanup_resources

3-RWO 2 replicas abnormal non attached and no replica node   
    [Tags]    RestartKubelet    RWO    3Replicas    AttachHasReplica    AttachReplicaSameNode    AbnormalNonAttachedNode    AbnormalNonReplicaNode
    Given The ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 1 without replica node
    And Write data into mount point

    When Restart Kubelet the node 1 without replica node

    Then Node 1 without replica node state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data is intact
    [Teardown]    cleanup_resources

4-RWO 2 replicas abnormal replica but non attached node
    [Tags]    RestartKubelet    RWO    2Replicas    AttachNoReplica    AttachReplicaDiffNode    AbnormalNonAttachedNode    AbnormalReplicaNode
    Given The ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 1 without replica node
    And Write data into mount point

    When Restart Kubelet the node 1 with replica node

    Then Node 1 with replica node state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data is intact
    [Teardown]    cleanup_resources
    
5-RWO 2 replicas abnormal attached and replica node
    [Tags]    RestartKubelet    RWO    2Replicas    AttachHasReplica    AttachReplicaSameNode    AbnormalAttachedNode    AbnormalReplicaNode
    Given The ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 1 with replica node
    And Write data into mount point

    When Restart Kubelet the node 1 with replica node

    Then Node 1 with replica node state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data is intact
    [Teardown]    cleanup_resources
    
6-RWO 2 replicas abnormal on non attached and no replica node
    [Tags]    RestartKubelet    RWO    2Replicas    AttachHasReplica    AttachReplicaDiffNode    AbnormalNonAttachedNode    AbnormalNonReplicaNode
    Given The ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 1 with replica node
    And Write data into mount point

    When Restart Kubelet the node 1 without replica node

    Then Node 1 without replica node state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data is intact
    [Teardown]    cleanup_resources
    
7-RWO 2 replicas abnormal attached and replica but diff node
    [Tags]    RestartKubelet    RWO    2Replicas    AttachHasReplica    AttachReplicaDiffNode    AbnormalNonAttachedNode    AbnormalReplicaNode
    Given The ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 1 with replica node
    And Write data into mount point

    When Restart Kubelet the node 2 with replica node

    Then Node 2 with replica node state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data is intact
    [Teardown]    cleanup_resources

8-RWX 3 replicas abnormal attached and replica node 
    [Tags]    RestartKubelet    RWX    3Replicas    AttachHasReplica    AttachReplicaSameNode    AbnormalAttachedNode    AbnormalReplicaNode
    # Recover: After restart the node, volume should be detached and replica is failed. Need manual to do reattached.
    Given The ${volume_size_gb} GB RWX volume with 3 replicas
    And Attach volume to the node 1 with replica node
    And Write data into mount point

    When Restart Kubelet the node 1 with replica node

    Then Node 1 with replica node state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data is intact
    [Teardown]    cleanup_resources

9-RWX 3 replicas abnormal replica but non attached node
    [Tags]    RestartKubelet    RWX    3Replicas    AttachHasReplica    AttachReplicaDiffNode    AbnormalNonAttachedNode    AbnormalReplicaNode
    # Recover: After restart the node, delete the stopped replica, and re-update the replica count to do rebuilding
    Given The ${volume_size_gb} GB RWX volume with 3 replicas
    And Attach volume to the node 1 with replica node
    And Write data into mount point

    When Restart Kubelet the node 2 with replica node

    Then Node 2 with replica node state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data is intact
    [Teardown]    cleanup_resources

10-RWX 2 replicas abnormal on non attached and no replica node   
    [Tags]    RestartKubelet    RWX    2Replicas    AttachNoReplica    AttachReplicaSameNode    AbnormalNonAttachedNode    AbnormalNonReplicaNode
    Given The ${volume_size_gb} GB RWX volume with 2 replicas
    And Attach volume to the node 1 without replica node
    And Write data into mount point

    When Restart Kubelet the node 1 with replica node

    Then Node 1 without replica node state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data is intact
    [Teardown]    cleanup_resources

11-RWX 2 replicas abnormal replica but non attached node
    [Tags]    RestartKubelet    RWX    2Replicas    AttachNoReplica    AttachReplicaDiffNode    AbnormalNonAttachedNode    AbnormalReplicaNode
    Given The ${volume_size_gb} GB RWX volume with 2 replicas
    And Attach volume to the node 1 without replica node
    And Write data into mount point

    When Restart Kubelet the node 1 with replica node

    Then Node 1 with replica node state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data is intact
    [Teardown]    cleanup_resources
    
12-RWX 2 replicas abnormal on attached and replica node
    [Tags]    RestartKubelet    RWX    2Replicas    AttachHasReplica    AttachReplicaSameNode    AbnormalAttachedNode    AbnormalReplicaNode
    Given The ${volume_size_gb} GB RWX volume with 2 replicas
    And Attach volume to the node 1 with replica node
    And Write data into mount point

    When Restart Kubelet the node 1 with replica node

    Then Node 1 with replica node state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data is intact
    [Teardown]    cleanup_resources
    
13-RWX 2 replicas abnormal non attached and no replica node
    [Tags]    RestartKubelet    RWX    2Replicas    AttachHasReplica    AttachReplicaDiffNode    AbnormalNonAttachedNode    AbnormalNonReplicaNode
    Given The ${volume_size_gb} GB RWX volume with 2 replicas
    And Attach volume to the node 1 with replica node
    And Write data into mount point

    When Restart Kubelet the node 1 without replica node

    Then Node 1 without replica node state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data is intact
    [Teardown]    cleanup_resources
    
14-RWX 2 replicas abnormal attached and replica but diff node
    [Tags]    RestartKubelet    RWX    2Replicas    AttachHasReplica    AttachReplicaDiffNode    AbnormalNonAttachedNode    AbnormalReplicaNode
    Given The ${volume_size_gb} GB RWX volume with 2 replicas
    And Attach volume to the node 1 with replica node
    And Write data into mount point

    When Restart Kubelet the node 2 with replica node

    Then Node 2 with replica node state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data is intact
    [Teardown]    cleanup_resources

15-RWO 3 replicas abnormal attached and replica node timeout 
    [Tags]    RestartKubelet    RWO    3Replicas    AttachHasReplica    AttachReplicaSameNode    AbnormalAttachedNode    AbnormalReplicaNode    Timeout
    # Recover: After restart the node, volume should be detached and replica is failed. Need manual to do reattached.
    Given The ${volume_size_gb} GB RWO volume with 3 replicas
    And Attach volume to the node 1 with replica node
    And Write data into mount point

    When Restart Kubelet timeout on the node 1 with replica node

    Then Node 1 with replica node state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data is intact
    [Teardown]    cleanup_resources

16-RWO 3 replicas abnormal replica but no attached node timeout
    [Tags]    RestartKubelet    RWO    3Replicas    AttachHasReplica    AttachReplicaDiffNode    AbnormalNonAttachedNode    AbnormalReplicaNode    Timeout
    # Recover: After restart the node, delete the stopped replica, and re-update the replica count to do rebuilding
    Given The ${volume_size_gb} GB RWO volume with 3 replicas
    And Attach volume to the node 1 with replica node
    And Write data into mount point

    When Restart Kubelet timeout on the node 2 with replica node

    Then Node 2 with replica node state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data is intact
    [Teardown]    cleanup_resources

17-RWO 2 replicas abnormal no attached no replica node timeout 
    [Tags]    RestartKubelet    RWO    3Replicas    AttachHasReplica    AttachReplicaSameNode    AbnormalNonAttachedNode    AbnormalNonReplicaNode    Timeout
    Given The ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 1 without replica node
    And Write data into mount point

    When Restart Kubelet timeout on the node 1 without replica node

    Then Node 1 without replica node state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data is intact
    [Teardown]    cleanup_resources

18-RWO 2 replicas abnormal replica but no attached node timeout
    [Tags]    RestartKubelet    RWO    2Replicas    AttachNoReplica    AttachReplicaDiffNode    AbnormalNonAttachedNode    AbnormalReplicaNode    Timeout
    Given The ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 1 without replica node
    And Write data into mount point

    When Restart Kubelet timeout on the node 1 with replica node

    Then Node 1 with replica node state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data is intact
    [Teardown]    cleanup_resources
    
19-RWO 2 replicas abnormal attached replica node timeout
    [Tags]    RestartKubelet    RWO    2Replicas    AttachHasReplica    AttachReplicaSameNode    AbnormalAttachedNode    AbnormalReplicaNode    Timeout
    Given The ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 1 with replica node
    And Write data into mount point

    When Restart Kubelet timeout on the node 1 with replica node

    Then Node 1 with replica node state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data is intact
    [Teardown]    cleanup_resources
    
20-RWO 2 replicas abnormal no attached no replica node timeout
    [Tags]    RestartKubelet    RWO    2Replicas    AttachHasReplica    AttachReplicaDiffNode    AbnormalNonAttachedNode    AbnormalNonReplicaNode    Timeout
    Given The ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 1 with replica node
    And Write data into mount point

    When Restart Kubelet timeout on the node 1 without replica node

    Then Node 1 without replica node state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data is intact
    [Teardown]    cleanup_resources
    
21-RWO 2 replicas abnormal attached replica diff node timeout
    [Tags]    RestartKubelet    RWO    2Replicas    AttachHasReplica    AttachReplicaDiffNode    AbnormalNonAttachedNode    AbnormalReplicaNode    Timeout
    Given The ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 1 with replica node
    And Write data into mount point

    When Restart Kubelet timeout on the node 2 with replica node

    Then Node 2 with replica node state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data is intact
    [Teardown]    cleanup_resources

22-RWX 3 replicas abnormal attached replica node timeout 
    [Tags]    RestartKubelet    RWX    3Replicas    AttachHasReplica    AttachReplicaSameNode    AbnormalAttachedNode    AbnormalReplicaNode    Timeout
    # Recover: After restart the node, volume should be detached and replica is failed. Need manual to do reattached.
    Given The ${volume_size_gb} GB RWX volume with 3 replicas
    And Attach volume to the node 1 with replica node
    And Write data into mount point

    When Restart Kubelet timeout on the node 1 with replica node

    Then Node 1 with replica node state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data is intact
    [Teardown]    cleanup_resources

23-RWX 3 replicas abnormal replica non attached node timout
    [Tags]    RestartKubelet    RWX    3Replicas    AttachHasReplica    AttachReplicaDiffNode    AbnormalNonAttachedNode    AbnormalReplicaNode    Timeout
    # Recover: After restart the node, delete the stopped replica, and re-update the replica count to do rebuilding
    Given The ${volume_size_gb} GB RWX volume with 3 replicas
    And Attach volume to the node 1 with replica node
    And Write data into mount point

    When Restart Kubelet timeout on the node 2 with replica node

    Then Node 2 with replica node state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data is intact
    [Teardown]    cleanup_resources

24-RWX 2 replicas abnormal non attached no replica node timout
    [Tags]    RestartKubelet    RWX    3Replicas    AttachHasReplica    AttachReplicaSameNode    AbnormalNonAttachedNode    AbnormalNonReplicaNode    Timeout
    Given The ${volume_size_gb} GB RWX volume with 2 replicas
    And Attach volume to the node 1 without replica node
    And Write data into mount point

    When Restart Kubelet timeout on the node 1 without replica node

    Then Node 1 without replica node state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data is intact
    [Teardown]    cleanup_resources

25-RWX 2 replicas abnormal replica non attached node timeout
    [Tags]    RestartKubelet    RWX    2Replicas    AttachNoReplica    AttachNoReplica    AttachReplicaDiffNode    AbnormalNonAttachedNode    AbnormalReplicaNode    Timeout
    Given The ${volume_size_gb} GB RWX volume with 2 replicas
    And Attach volume to the node 1 without replica node
    And Write data into mount point

    When Restart Kubelet timeout on the node 1 with replica node

    Then Node 1 with replica node state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data is intact
    [Teardown]    cleanup_resources
    
26-RWX 2 replicas abnormal on attached replica node timeout
    [Tags]    RestartKubelet    RWX    2Replicas    AttachHasReplica    AttachReplicaSameNode    AbnormalAttachedNode    AbnormalReplicaNode    Timeout
    Given The ${volume_size_gb} GB RWX volume with 2 replicas
    And Attach volume to the node 1 with replica node
    And Write data into mount point

    When Restart Kubelet timeout on the node 1 with replica node

    Then Node 1 with replica node state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data is intact
    [Teardown]    cleanup_resources
    
27-RWX 2 replicas abnormal non attached no replica node timeout
    [Tags]    RestartKubelet    RWX    2Replicas    AttachHasReplica    AttachReplicaDiffNode    AbnormalNonAttachedNode    AbnormalNonReplicaNode    Timeout
    Given The ${volume_size_gb} GB RWX volume with 2 replicas
    And Attach volume to the node 1 with replica node
    And Write data into mount point

    When Restart Kubelet timeout on the node 1 without replica node

    Then Node 1 without replica node state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data is intact
    [Teardown]    cleanup_resources
    
28-RWX 2 replicas abnormal attached replica diff node timeout
    [Tags]    RestartKubelet    RWX    2Replicas    AttachHasReplica    AttachReplicaDiffNode    AbnormalNonAttachedNode    AbnormalReplicaNode    Timeout
    Given The ${volume_size_gb} GB RWX volume with 2 replicas
    And Attach volume to the node 1 with replica node
    And Write data into mount point

    When Restart Kubelet timeout on the node 2 with replica node

    Then Node 2 with replica node state should be Ready
    And Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Data is intact
    [Teardown]    cleanup_resources