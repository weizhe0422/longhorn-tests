*** Settings ***
Documentation     https://longhorn.github.io/longhorn-tests/manual/pre-release/node-not-ready/node-disconnection/node-disconnection/
...
...               Keywords are imported from the resource file
Resource          ../../keywords/node.resource
Resource          ../../keywords/common.resource
Test setup    set_test_environment    ${TEST NAME}
Test Teardown    cleanup_resources

*** Variable ***
${volume_size_gb}=    1
${retry_time_out}=    600
${retry_interval}=    5

*** Test Cases ***
1-RWO 2 replicas abnormal attached and replica node
    [Documentation]    Case 1-1
    [Tags]    RWO 
    Given Create ${volume_size_gb} GB RWO volume with 2 replicas
    And Settings auto-salvage is false
    And Get node index with replica
    And Get node index without replica
    And Attach volume to the node ${node_number_without_replica}[0]
    When During writing data into mount point interrupt network the node ${node_number_without_replica}[0] for 100 seconds
    Then Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Node ${node_number_without_replica}[0] state should be Ready
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Volume state should be faulted
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds     ${retry_interval} seconds    Engine state should be stopped
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node ${node_number_with_replica}[0] state should be stopped
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node ${node_number_with_replica}[1] state should be stopped
    [Teardown]    Run Keywords   Settings auto-salvage is false
    ...           AND            cleanup_resources

2-RWX 2 replicas abnormal attached and replica node
    [Documentation]    Case 1-1
    [Tags]    RWX 
    Given Create ${volume_size_gb} GB RWX volume with 2 replicas
    And Settings auto-salvage is false
    And Get node index with replica
    And Get node index without replica
    And Attach volume to the node ${node_number_without_replica}[0]
    When During writing data into mount point interrupt network the node ${node_number_without_replica}[0] for 100 seconds
    Then Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Node ${node_number_without_replica}[0] state should be Ready
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Volume state should be faulted
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds     ${retry_interval} seconds    Engine state should be stopped
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node ${node_number_with_replica}[0] state should be stopped
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node ${node_number_with_replica}[1] state should be stopped
    [Teardown]    Run Keywords   Settings auto-salvage is false
    ...           AND            cleanup_resources
  
3-RWO 3 replicas abnormal attached and replica node
    [Documentation]    Case 1-2
    [Tags]    
    Given Create ${volume_size_gb} GB RWO volume with 3 replicas
    And Settings auto-salvage is false
    And Get node index with replica  
    And Attach volume to the node ${node_number_with_replica}[0]
    When During writing data into mount point interrupt network the node ${node_number_with_replica}[0] for 100 seconds
    Then Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Node ${node_number_with_replica}[0] state should be Ready
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Volume state should be healthy
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds     ${retry_interval} seconds    Engine state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node ${node_number_with_replica}[0] state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node ${node_number_with_replica}[1] state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node ${node_number_with_replica}[2] state should be running
    [Teardown]    Run Keywords   Settings auto-salvage is false
    ...           AND            cleanup_resources

4-RWX 3 replicas abnormal attached and replica node
    [Documentation]    Case 1-2
    [Tags]    
    Given Create ${volume_size_gb} GB RWX volume with 3 replicas
    And Settings auto-salvage is false
    And Get node index with replica
    And Attach volume to the node ${node_number_with_replica}[0]
    When During writing data into mount point interrupt network the node ${node_number_with_replica}[0] for 100 seconds
    Then Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Node ${node_number_with_replica}[0] state should be Ready
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Volume state should be healthy
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds     ${retry_interval} seconds    Engine state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node ${node_number_with_replica}[0] state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node ${node_number_with_replica}[1] state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node ${node_number_with_replica}[2] state should be running
    [Teardown]    Run Keywords   Settings auto-salvage is false
    ...           AND            cleanup_resources
    
5-RWO 2 replicas abnormal attached and replica node
    [Documentation]    Case 2-1
    [Tags]    RWO 
    Given Create ${volume_size_gb} GB RWO volume with 2 replicas
    And Settings auto-salvage is false
    And Get node index with replica
    And Get node index without replica
    And Attach volume to the node ${node_number_without_replica}[0]
    When Interrupt network the node ${node_number_without_replica}[0] for 100 seconds
    Then Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Node ${node_number_without_replica}[0] state should be Ready
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Volume state should be healthy
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds     ${retry_interval} seconds    Engine state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node ${node_number_with_replica}[0] state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node ${node_number_with_replica}[1] state should be running
    [Teardown]    Run Keywords   Settings auto-salvage is false
    ...           AND            cleanup_resources

6-RWX 2 replicas abnormal attached and replica node
    [Documentation]    Case 2-1
    [Tags]    RWX 
    Given Create ${volume_size_gb} GB RWX volume with 2 replicas
    And Settings auto-salvage is false
    And Get node index with replica
    And Get node index without replica
    And Attach volume to the node ${node_number_without_replica}[0]
    When Interrupt network the node ${node_number_without_replica}[0] for 100 seconds
    Then Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Node ${node_number_without_replica}[0] state should be Ready
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Volume state should be healthy
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds     ${retry_interval} seconds    Engine state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node ${node_number_with_replica}[0] state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node ${node_number_with_replica}[1] state should be running
    [Teardown]    Run Keywords   Settings auto-salvage is false
    ...           AND            cleanup_resources

7-RWO 3 replicas abnormal attached and replica node
    [Documentation]    Case 2-1
    [Tags]    RWO 
    Given Create ${volume_size_gb} GB RWO volume with 3 replicas
    And Settings auto-salvage is false
    And Get node index with replica
    And Attach volume to the node ${node_number_with_replica}[0]
    When Interrupt network the node ${node_number_with_replica}[0] for 100 seconds
    Then Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Node ${node_number_with_replica}[0] state should be Ready
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Volume state should be healthy
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds     ${retry_interval} seconds    Engine state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node ${node_number_with_replica}[0] state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node ${node_number_with_replica}[1] state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node ${node_number_with_replica}[2] state should be running
    [Teardown]    Run Keywords   Settings auto-salvage is false
#    ...           AND            cleanup_resources

8-RWX 3 replicas abnormal attached and replica node
    [Documentation]    Case 2-1
    [Tags]    RWX 
    Given Create ${volume_size_gb} GB RWX volume with 3 replicas
    And Settings auto-salvage is false
    And Get node index with replica
    And Get node index without replica
    And Attach volume to the node ${node_number_with_replica}[0]
    When Interrupt network the node ${node_number_with_replica}[0] for 100 seconds
    Then Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Node ${node_number_with_replica}[0] state should be Ready
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Volume state should be healthy
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds     ${retry_interval} seconds    Engine state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node ${node_number_with_replica}[0] state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node ${node_number_with_replica}[1] state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node ${node_number_with_replica}[2] state should be running
    [Teardown]    Run Keywords   Settings auto-salvage is false
    ...           AND            cleanup_resources

9-RWO 3 replicas abnormal non attached and replica node
    [Documentation]    Case 1-2
    [Tags]    
    Given Create ${volume_size_gb} GB RWO volume with 3 replicas
    And Settings auto-salvage is false
    And Get node index with replica
    And Attach volume to the node ${node_number_with_replica}[0]
    When During writing data into mount point interrupt network the node ${node_number_with_replica}[1] for 100 seconds
    Then Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Node ${node_number_with_replica}[1] state should be Ready
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Volume state should be healthy
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds     ${retry_interval} seconds    Engine state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node ${node_number_with_replica}[0] state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node ${node_number_with_replica}[1] state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node ${node_number_with_replica}[2] state should be running
    [Teardown]    Run Keywords   Settings auto-salvage is false
    ...           AND            cleanup_resources

10-RWX 3 replicas abnormal non attached and replica node
    [Documentation]    Case 1-2
    [Tags]    
    Given Create ${volume_size_gb} GB RWX volume with 3 replicas
    And Settings auto-salvage is false
    And Get node index with replica
    And Attach volume to the node ${node_number_with_replica}[0]
    When During writing data into mount point interrupt network the node ${node_number_with_replica}[1] for 100 seconds
    Then Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Node ${node_number_with_replica}[1] state should be Ready
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Volume state should be healthy
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds     ${retry_interval} seconds    Engine state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node ${node_number_with_replica}[0] state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node ${node_number_with_replica}[1] state should be running
    And Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Replica on the node ${node_number_with_replica}[2] state should be running
    [Teardown]    Run Keywords   Settings auto-salvage is false
    ...           AND            cleanup_resources
