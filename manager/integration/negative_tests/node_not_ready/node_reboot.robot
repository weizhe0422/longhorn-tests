*** Settings ***
Documentation     Test the resillence if cluster node happend exception
...
...               Keywords are imported from the resource file
Resource          keywords.resource
Test setup    set_test_environment    ${TEST NAME}
Test Teardown    cleanup_resources

*** Variable ***
${volume_size_gb}=    1
${retry_time_out}=    600
${retry_interval}=    5

*** Test Cases ***
1-RWO 3 replicas abnormal attached and replica node 
    [Tags]    PassFirstTest RWO 3Replicas AttachReplicaSameNode AbnormalAttachedNode AbnormalReplicaNode
    # Recover: After restart the node, volume should be detached and replica is failed. Need manual to do reattached.
    Given Create ${volume_size_gb} GB RWO volume with 3 replicas
    And Attach volume to the node 0
    And Write data into mount point
    When Reboot the node 0
    Then Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Node 0 state should be Ready
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Volume state should be healthy
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds     ${retry_interval} seconds    Engine state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node 0 state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node 1 state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node 2 state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Check data is intact
    [Teardown]    cleanup_resources

2-RWO 3 replicas abnormal replica but non attached node
    [Tags]    PassFirstTest RWO 3Replicas AttachReplicaDiffNode AbnormalNonAttachedNode AbnormalReplicaNode
    # Recover: After restart the node, delete the stopped replica, and re-update the replica count to do rebuilding
    Given Create ${volume_size_gb} GB RWO volume with 3 replicas
    And Attach volume to the node 0
    And Write data into mount point
    When Reboot the node 1
    Then Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Node 1 state should be Ready
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Volume state should be healthy
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds     ${retry_interval} seconds    Engine state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node 0 state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node 1 state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node 2 state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Check data is intact
    [Teardown]    cleanup_resources

3-RWO 2 replicas abnormal non attached and no replica node   
    [Tags]    PassFirstTest RWO 3Replicas AttachReplicaSameNode AbnormalNonAttachedNode AbnormalNonReplicaNode
    Given Create ${volume_size_gb} GB RWO volume with 2 replicas
    And Get node index without replica
    And Attach volume to the node ${node_number_without_replica}[0]
    And Write data into mount point
    When Reboot the node ${node_number_without_replica}[0]
    Then Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Node ${node_number_without_replica}[0] state should be Ready
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Volume state should be healthy
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds     ${retry_interval} seconds    Engine state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node 0 state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node 1 state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node 2 state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Check data is intact
    [Teardown]    cleanup_resources

4-RWO 2 replicas abnormal replica but non attached node
    [Tags]    PassFirstTest RWO 2Replicas AttachReplicaDiffNode AbnormalNonAttachedNode AbnormalReplicaNode
    Given Create ${volume_size_gb} GB RWO volume with 2 replicas
    And Get node index with replica
    And Get node index without replica
    And Attach volume to the node ${node_number_without_replica}[0]
    And Write data into mount point
    When Reboot the node ${node_number_with_replica}[0]
    Then Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Node ${node_number_with_replica}[0] state should be Ready
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Volume state should be healthy
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds     ${retry_interval} seconds    Engine state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node 0 state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node 1 state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node 2 state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Check data is intact
    [Teardown]    cleanup_resources
    
5-RWO 2 replicas abnormal attached and replica node
    [Tags]    PassFirstTest RWO 2Replicas AttachReplicaSameNode AbnormalAttachedNode AbnormalReplicaNode
    Given Create ${volume_size_gb} GB RWO volume with 2 replicas
    And Get node index with replica
    And Attach volume to the node ${node_number_with_replica}[0]
    And Write data into mount point
    When Reboot the node ${node_number_with_replica}[0]
    Then Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Node ${node_number_with_replica}[0] state should be Ready
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Volume state should be healthy
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds     ${retry_interval} seconds    Engine state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node 0 state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node 1 state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node 2 state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Check data is intact
    [Teardown]    cleanup_resources
    
6-RWO 2 replicas abnormal on non attached and no replica node
    [Tags]    PassFirstTest RWO 2Replicas AttachReplicaDiffNode AbnormalNonAttachedNode AbnormalNonReplicaNode
    Given Create ${volume_size_gb} GB RWO volume with 2 replicas
    And Get node index with replica
    And Get node index without replica
    And Attach volume to the node ${node_number_with_replica}[0]
    And Write data into mount point
    When Reboot the node ${node_number_without_replica}[0]
    Then Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Node ${node_number_without_replica}[0] state should be Ready
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Volume state should be healthy
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds     ${retry_interval} seconds    Engine state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node 0 state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node 1 state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node 2 state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Check data is intact
    [Teardown]    cleanup_resources
    
7-RWO 2 replicas abnormal attached and replica but diff node
    [Tags]    PassFirstTest RWO 2Replicas AttachReplicaDiffNode AbnormalNonAttachedNode AbnormalReplicaNode
    Given Create ${volume_size_gb} GB RWO volume with 2 replicas
    And Get node index with replica
    And Attach volume to the node ${node_number_with_replica}[0]
    And Write data into mount point
    When Reboot the node ${node_number_with_replica}[1]
    Then Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Node ${node_number_with_replica}[1] state should be Ready
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Volume state should be healthy
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds     ${retry_interval} seconds    Engine state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node 0 state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node 1 state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node 2 state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Check data is intact
    [Teardown]    cleanup_resources
