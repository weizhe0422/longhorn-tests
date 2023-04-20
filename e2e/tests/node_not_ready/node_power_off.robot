*** Settings ***
Documentation     Test the resillence if cluster node happend exception
...              Keywords are imported from the resource file
Resource          ../../keywords/node.resource
Resource          ../../keywords/common.resource
Test setup    set_test_environment    ${TEST NAME}
Test Teardown    cleanup_resources

*** Variable ***
${volume_size_gb}=    1
${retry_time_out}=    600
${retry_interval}=    5
${POD_EVICTION_TIME_OUT}=    300

*** Test Cases ***
1-Power off RWO volume attached node with replica
    [Documentation]    RWO volume with replica on attached node and powering off the volume attached node  
    [Tags]    RWO PowerOffAttachedNode ReplicaOnAttachedNode DuringDataWriting
    # Recover: After restart the node, volume should be detached and replica is failed-Need manual to do reattached.
    Given Create ${volume_size_gb} GB RWO volume with 3 replicas
    And Get node index with replica
    And Attach volume to the node ${node_number_with_replica}[0]
    And Write data into mount point
    When Power off the node ${node_number_with_replica}[0]
    Then Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Node ${node_number_with_replica}[0] state should be NotReady
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Volume state should be unknown
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Engine state should be unknown
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node ${node_number_with_replica}[0] state should be unknown
    When Power on the node ${node_number_with_replica}[0]
    Then Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Node ${node_number_with_replica}[0] state should be Ready
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Volume state should be unknown
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds     ${retry_interval} seconds    Engine state should be unknown
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node ${node_number_with_replica}[0] state should be stopped
    [Teardown]    cleanup_resources

2-Power off RWO volume not-attached node with replica
    [Tags]    RWO PowerOffNonAttachedNode ReplicaOnAttachedNode DuringDataWriting
    # Recover: After restart the node, delete the stopped replica, and re-update the replica count to do rebuilding
    Given Create ${volume_size_gb} GB RWO volume with 3 replicas
    And Get node index with replica
    And Attach volume to the node ${node_number_with_replica}[0]
    And Write data into mount point
    When Power off the node ${node_number_with_replica}[1]
    Then Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Node ${node_number_with_replica}[1] state should be NotReady
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Volume state should be degraded
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Engine state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node ${node_number_with_replica}[1] state should be stopped
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Check data is intact
    When Power on the node ${node_number_with_replica}[1]
    Then Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Node ${node_number_with_replica}[1] state should be Ready
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Volume state should be degraded
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds     ${retry_interval} seconds    Engine state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node ${node_number_with_replica}[1] state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Check data is intact
    [Teardown]    cleanup_resources

3-Power off RWO volume attached node without replica
    [Documentation]    
    [Tags]    RWO PowerOffAttachedNode ReplicaOnAttachedNode DuringDataWriting
    Given Create ${volume_size_gb} GB RWO volume with 2 replicas
    And Get node index with replica
    And Get node index without replica
    And Attach volume to the node ${node_number_without_replica}[0]
    And Write data into mount point
    When Power off the node ${node_number_without_replica}[0]
    Then Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Node ${node_number_without_replica}[0] state should be NotReady
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Volume state should be unknown
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Engine state should be unknown
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node ${node_number_with_replica}[0] state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node ${node_number_with_replica}[1] state should be running
    When Power on the node ${node_number_without_replica}[0]
    Then Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Node ${node_number_without_replica}[0] state should be Ready
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Volume state should be unknown
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds     ${retry_interval} seconds    Engine state should be unknown
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node ${node_number_with_replica}[0] state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node ${node_number_with_replica}[1] state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Check data is intact
    [Teardown]    cleanup_resources

4-Power off RWO volume not-attached node without replica
    [Documentation]
    [Tags]    RWO PowerOffNonAttachedNode ReplicaOnAttachedNode DuringDataWriting
    Given Create ${volume_size_gb} GB RWO volume with 2 replicas
    And Get node index with replica
    And Get node index without replica
    And Attach volume to the node ${node_number_without_replica}[0]
    And Write data into mount point
    When Power off the node ${node_number_with_replica}[0]
    Then Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Node ${node_number_with_replica}[0] state should be NotReady
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Volume state should be degraded
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Engine state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node ${node_number_with_replica}[0] state should be stopped
    When Power on the node ${node_number_with_replica}[0]
    Then Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Node ${node_number_with_replica}[0] state should be Ready
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Volume state should be healthy
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds     ${retry_interval} seconds    Engine state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node ${node_number_with_replica}[0] state should be running
    [Teardown]    cleanup_resources

5-Power off 2 replica RWO volume attached node with replica
    [Documentation]
    [Tags]    RWO PowerOffNonAttachedNode ReplicaOnAttachedNode DuringDataWriting
    Given Create ${volume_size_gb} GB RWO volume with 2 replicas
    And Get node index with replica
    And Attach volume to the node ${node_number_with_replica}[0]
    And Write data into mount point
    When Power off the node ${node_number_with_replica}[0]
    Then Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Node ${node_number_with_replica}[0] state should be NotReady
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Volume state should be unknown
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Engine state should be unknown
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node ${node_number_with_replica}[0] state should be unknown
    When Power on the node ${node_number_with_replica}[0]
    Then Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Node ${node_number_with_replica}[0] state should be Ready
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Volume state should be unknown
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds     ${retry_interval} seconds    Engine state should be unknown
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node ${node_number_with_replica}[0] state should be running
    [Teardown]    cleanup_resources

6-Power off 2 replica RWO volume non-attached node wo replica
    [Documentation]
    [Tags]    RWO PowerOffNonAttachedNode ReplicaOnAttachedNode DuringDataWriting
    Given Create ${volume_size_gb} GB RWO volume with 2 replicas
    And Get node index with replica
    And Get node index without replica
    And Attach volume to the node ${node_number_with_replica}[0]
    And Write data into mount point
    When Power off the node ${node_number_without_replica}[0]
    Then Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Node ${node_number_without_replica}[0] state should be NotReady
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Volume state should be healthy
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Engine state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node ${node_number_with_replica}[0] state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node ${node_number_with_replica}[1] state should be running
    When Power on the node ${node_number_without_replica}[0]
    Then Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Node ${node_number_without_replica}[0] state should be Ready
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Volume state should be healthy
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds     ${retry_interval} seconds    Engine state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node ${node_number_with_replica}[0] state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node ${node_number_with_replica}[1] state should be running
    [Teardown]    cleanup_resources

7-Power off 2 replica RWO volume non-attached node with replica
    [Documentation]
    [Tags]    RWO PowerOffNonAttachedNode ReplicaOnAttachedNode DuringDataWriting
    Given Create ${volume_size_gb} GB RWO volume with 2 replicas
    And Get node index with replica
    And Attach volume to the node ${node_number_with_replica}[0]
    And Write data into mount point
    When Power off the node ${node_number_with_replica}[1]
    Then Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Node ${node_number_with_replica}[1] state should be NotReady
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Volume state should be healthy
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Engine state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node ${node_number_with_replica}[0] state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node ${node_number_with_replica}[1] state should be stopped
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Check data is intact
    When Power on the node ${node_number_with_replica}[1]
    Then Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Node ${node_number_with_replica}[1] state should be Ready
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Volume state should be healthy
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds     ${retry_interval} seconds    Engine state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node ${node_number_with_replica}[0] state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node ${node_number_with_replica}[1] state should be stopped
    [Teardown]    cleanup_resources

8-Power off RWO volume attached node with replica time out
    [Documentation]    RWO volume with replica on attached node and powering off the volume attached node  
    [Tags]    RWO PowerOffAttachedNode ReplicaOnAttachedNode DuringDataWriting
    # Recover: After restart the node, volume should be detached and replica is failed-Need manual to do reattached.
    Given Create ${volume_size_gb} GB RWO volume with 3 replicas
    And Get node index with replica
    And Attach volume to the node ${node_number_with_replica}[0]
    And Write data into mount point
    When Power off the node ${node_number_with_replica}[0]
    And Sleep ${POD_EVICTION_TIME_OUT} seconds    
    Then Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Node ${node_number_with_replica}[0] state should be NotReady
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Volume state should be unknown
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Engine state should be unknown
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node ${node_number_with_replica}[0] state should be unknown
    When Power on the node ${node_number_with_replica}[0]
    Then Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Node ${node_number_with_replica}[0] state should be Ready
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Volume state should be unknown
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds     ${retry_interval} seconds    Engine state should be unknown
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node ${node_number_with_replica}[0] state should be running
    [Teardown]    cleanup_resources

9-Power off RWO volume not-attached node with replica time out
    [Tags]    RWO PowerOffNonAttachedNode ReplicaOnAttachedNode DuringDataWriting
    # Recover: After restart the node, delete the stopped replica, and re-update the replica count to do rebuilding
    Given Create ${volume_size_gb} GB RWO volume with 3 replicas
    And Get node index with replica
    And Attach volume to the node ${node_number_with_replica}[0]
    And Write data into mount point
    When Power off the node ${node_number_with_replica}[1]
    And Sleep ${POD_EVICTION_TIME_OUT} seconds 
    Then Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Node ${node_number_with_replica}[1] state should be NotReady
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Volume state should be degraded
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Engine state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node ${node_number_with_replica}[0] state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node ${node_number_with_replica}[1] state should be stopped
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node ${node_number_with_replica}[2] state should be running
    When Power on the node ${node_number_with_replica}[1]
    Then Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Node ${node_number_with_replica}[1] state should be Ready
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Volume state should be healthy
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds     ${retry_interval} seconds    Engine state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node ${node_number_with_replica}[0] state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node ${node_number_with_replica}[1] state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node ${node_number_with_replica}[2] state should be running
    [Teardown]    cleanup_resources

10-Power off RWO volume attached node wo replica time out
    [Documentation]    
    [Tags]    RWO PowerOffAttachedNode ReplicaOnAttachedNode DuringDataWriting
    Given Create ${volume_size_gb} GB RWO volume with 2 replicas
    And Get node index with replica
    And Get node index without replica
    And Attach volume to the node ${node_number_without_replica}[0]
    And Write data into mount point
    When Power off the node ${node_number_without_replica}[0]
    And Sleep ${POD_EVICTION_TIME_OUT} seconds 
    Then Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Node ${node_number_without_replica}[0] state should be NotReady
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Volume state should be unknown
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Engine state should be unknown
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node ${node_number_with_replica}[0] state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node ${node_number_with_replica}[1] state should be running
    When Power on the node ${node_number_without_replica}[0]
    Then Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Node ${node_number_without_replica}[0] state should be Ready
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Volume state should be healthy
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds     ${retry_interval} seconds    Engine state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node ${node_number_with_replica}[0] state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node ${node_number_with_replica}[1] state should be running
    [Teardown]    cleanup_resources

11-Power off RWO volume not-attached node wo replica time out
    [Documentation]
    [Tags]    PassFirstTest RWO PowerOffNonAttachedNode ReplicaOnAttachedNode DuringDataWriting
    Given Create ${volume_size_gb} GB RWO volume with 2 replicas
    And Get node index with replica
    And Get node index without replica
    And Attach volume to the node ${node_number_without_replica}[0]
    And Write data into mount point
    When Power off the node ${node_number_with_replica}[0]
    And Sleep ${POD_EVICTION_TIME_OUT} seconds 
    Then Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Node ${node_number_with_replica}[0] state should be NotReady
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Volume state should be degraded
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Engine state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node ${node_number_with_replica}[0] state should be stopped
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node ${node_number_with_replica}[1] state should be running
    When Power on the node ${node_number_with_replica}[0]
    Then Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Node ${node_number_with_replica}[0] state should be Ready
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Volume state should be healthy
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds     ${retry_interval} seconds    Engine state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node ${node_number_with_replica}[0] state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node ${node_number_with_replica}[1] state should be running
    [Teardown]    cleanup_resources

12-Power off 2 replica RWO attach node with replica time out
    [Documentation]
    [Tags]    PassFirstTest RWO PowerOffNonAttachedNode ReplicaOnAttachedNode DuringDataWriting
    Given Create ${volume_size_gb} GB RWO volume with 2 replicas
    And Get node index with replica
    And Attach volume to the node ${node_number_with_replica}[0]
    And Write data into mount point
    When Power off the node ${node_number_with_replica}[0]
    And Sleep ${POD_EVICTION_TIME_OUT} seconds 
    Then Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Node ${node_number_with_replica}[0] state should be NotReady
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Volume state should be unknown
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Engine state should be unknown
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node ${node_number_with_replica}[0] state should be unknown
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node ${node_number_with_replica}[1] state should be running
    When Power on the node ${node_number_with_replica}[0]
    Then Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Node ${node_number_with_replica}[0] state should be Ready
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Volume state should be healthy
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds     ${retry_interval} seconds    Engine state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node ${node_number_with_replica}[0] state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node ${node_number_with_replica}[1] state should be running
    [Teardown]    cleanup_resources

13-Power off 2 replica RWO no attach node no replica time out
    [Documentation]
    [Tags]    PassFirstTest RWO PowerOffNonAttachedNode ReplicaOnAttachedNode DuringDataWriting
    Given Create ${volume_size_gb} GB RWO volume with 2 replicas
    And Get node index with replica
    And Get node index without replica
    And Attach volume to the node ${node_number_with_replica}[0]
    And Write data into mount point
    When Power off the node ${node_number_without_replica}[0]
    And Sleep ${POD_EVICTION_TIME_OUT} seconds 
    Then Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Node ${node_number_without_replica}[0] state should be NotReady
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Volume state should be healthy
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Engine state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node ${node_number_with_replica}[0] state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node ${node_number_with_replica}[1] state should be running
    When Power on the node ${node_number_without_replica}[0]
    Then Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Node ${node_number_without_replica}[0] state should be Ready
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Volume state should be healthy
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds     ${retry_interval} seconds    Engine state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node ${node_number_with_replica}[0] state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node ${node_number_with_replica}[1] state should be running
    [Teardown]    cleanup_resources

14-Power off 2 replica RWO no attach node with replica time out
    [Documentation]
    [Tags]    
    Given Create ${volume_size_gb} GB RWO volume with 2 replicas
    And Get node index with replica
    And Attach volume to the node ${node_number_with_replica}[0]
    And Write data into mount point
    When Power off the node ${node_number_with_replica}[1]
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Sleep ${POD_EVICTION_TIME_OUT} seconds
    Then Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Node ${node_number_with_replica}[1] state should be NotReady
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Volume state should be healthy
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Engine state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node ${node_number_with_replica}[0] state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node ${node_number_with_replica}[1] state should be stopped
    When Power on the node ${node_number_with_replica}[1]
    Then Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Node ${node_number_with_replica}[1] state should be Ready
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Volume state should be healthy
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds     ${retry_interval} seconds    Engine state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node ${node_number_with_replica}[0] state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node ${node_number_with_replica}[1] state should be stopped
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Check data is intact
    [Teardown]    cleanup_resources
