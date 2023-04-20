*** Settings ***
Documentation     Test the resillence if cluster node happend exception
...
...               Keywords are imported from the resource file
Resource          keywords.resource
Test setup    set_test_environment    ${TEST NAME}
Test Teardown    cleanup_resources

*** Variable ***
${volume_size_gb}=    1
${retry_time_out}=    60
${retry_interval}=    0.1

*** Test Cases ***
1. Reboot RWO volume attached node with replica
    [Documentation]    RWO volume with replica on attached node and powering off the volume attached node  
    [Tags]    RWO PowerOffAttachedNode ReplicaOnAttachedNode DuringDataWriting
    # Recover: After restart the node, volume should be detached and replica is failed. Need manual to do reattached.
    Given Create ${volume_size_gb} GB RWO volume with 3 replicas
    And Attach volume to the node 0
    And Write data into mount point
    When Reboot the node 0
    Then Node 0 state should be NotReady
    And Volume state should be unknown
    And Engine state should be unknown
    And Replica on the node 0 state should be unknown
 
2. Reboot RWO volume not-attached node with replica
    [Tags]    RWO PowerOffNonAttachedNode ReplicaOnAttachedNode DuringDataWriting
    # Recover: After restart the node, delete the stopped replica, and re-update the replica count to do rebuilding
    Given Create ${volume_size_gb} GB RWO volume with 3 replicas
    And Attach volume to the node 0
    And Write data into mount point
    When Reboot the node 1
    Then Node 1 state should be NotReady
    And Volume state should be degraded
    And Engine state should be running
    And Replica on the node 1 state should be stopped
    And Check data is intact

3. Reboot RWO volume attached node without replica
    [Documentation]    
    [Tags]    RWO PowerOffAttachedNode ReplicaOnAttachedNode DuringDataWriting
    Given Create ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 2
    And Write data into mount point
    When Reboot the node 2
    Then Node 2 state should be NotReady
    And Volume state should be degraded
    And Engine state should be running
    And Replica on the node 0 state should be stopped
    And Replica on the node 1 state should be stopped
    And Check data is intact

4. Reboot RWO volume not-attached node without replica
    [Documentation]
    [Tags]    RWO PowerOffNonAttachedNode ReplicaOnAttachedNode DuringDataWriting
    Given Create ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 2
    And Write data into mount point
    When Reboot the node 0
    Then Node 0 state should be NotReady
    And Volume state should be degraded
    And Engine state should be running
    And Replica on the node 0 state should be stopped
    And Check data is intact

5. Reboot 2 replica RWO volume attached node with replica
    [Documentation]
    [Tags]    RWO PowerOffNonAttachedNode ReplicaOnAttachedNode DuringDataWriting
    Given Create ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 0
    And Write data into mount point
    When Reboot the node 0
    Then Node 0 state should be NotReady
    And Volume state should be degraded
    And Engine state should be running
    And Replica on the node 0 state should be stopped
    And Check data is intact

6. Reboot 2 replica RWO volume non-attached node without replica
    [Documentation]
    [Tags]    RWO PowerOffNonAttachedNode ReplicaOnAttachedNode DuringDataWriting
    Given Create ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 0
    And Write data into mount point
    When Reboot the node 2
    Then Node 2 state should be NotReady
    And Volume state should be degraded
    And Engine state should be running
    And Replica on the node 0 state should be stopped
    And Replica on the node 1 state should be stopped
    And Check data is intact

7. Reboot 2 replica RWO volume non-attached node with replica
    [Documentation]
    [Tags]    RWO PowerOffNonAttachedNode ReplicaOnAttachedNode DuringDataWriting
    Given Create ${volume_size_gb} GB RWO volume with 2 replicas
    And Attach volume to the node 0
    And Write data into mount point
    When Reboot the node 1
    Then Node 1 state should be NotReady
    And Volume state should be degraded
    And Engine state should be running
    And Replica on the node 0 state should be stopped
    And Replica on the node 1 state should be stopped
    And Check data is intact
