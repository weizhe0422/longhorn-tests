*** Settings ***
Documentation     https://longhorn.github.io/longhorn-tests/manual/pre-release/node/node-deletion/
...
...               Keywords are imported from the resource file
Resource          keywords.resource
Test setup    set_test_environment    ${TEST NAME}
Test Teardown    cleanup_resources

*** Variable ***
${volume_size_gb}=    1
${wait_interval}=    5

*** Test Cases ***
Scenario 1
    [Documentation]    Case 1
    [Tags]     
    Given Cluster with 3 nodes 
    When Delete the node 0
    And Delete the node 1
    Then ${node_0} not in CRD nodes.longhorn.io
    And ${node_1} not in CRD nodes.longhorn.io
    When Add the node ${node_0}
    And Add the node ${node_1}
    Then ${node_0} in CRD nodes.longhorn.io
    And ${node_1} in CRD nodes.longhorn.io

Scenario 2
    [Documentation]    Case 2-1
    [Tags]    
    Given Create ${volume_size_gb} GB RWO volume with 1 replicas
    And Attach volume to the node
    And Write data into mount point
    When Delete the node ${volunme_attached_node}
    And Delete the node ${non_volunme_attached_node}
    Then Volume state should be Faulted

Scenario 3
    [Documentation]    Case 2-2
    [Tags]    
    Given Create ${volume_size_gb} GB RWO volume with 1 replicas
    And Attach volume to the node has no replica
    And Write data into mount point
    When Delete the node ${volunme_attached_node}
    And Delete the node ${non_volunme_attached_node}
    Then Volume state should be Unknown
    When Detach volume
    And Attach volume to the node
    Then Volume state should be healthy
    And Engine state should be running
    And All replicas state should be running
    And Check data is intact 

Scenario 4
    [Documentation]    Case 2-3
    [Tags]    
    Given Create ${volume_size_gb} GB RWO volume with 3 replicas
    And Attach volume to the node 0
    And Write data into mount point
    When Delete the node 1
    And Delete the node 2
    Then Volume state should be Degraded
    When Crash all replicas
    And Sleep 5 minutes
    Then Volume state should be healthy
    And Check data is intact
    When Settings auto-salvage is false
    And Crash all replicas
    And Sleep 5 minutes
    Then Volume state should be Faulted

Scenario 5
    [Documentation]    Case 2-4
    [Tags]    
    Given Create ${volume_size_gb} GB RWO volume with 3 replicas
    And Attach volume to the node 0
    And Write data into mount point
    When Delete the node 1
    And Delete the node 2
    Then Volume state should be Degraded
    When Delete the replica on the node 1
    Then ${replica_1} not in CRD replicas.longhorn.io
    