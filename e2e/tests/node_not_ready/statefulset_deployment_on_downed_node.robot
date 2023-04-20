*** Settings ***
Documentation     https://longhorn.github.io/longhorn-tests/manual/pre-release/node/improve-node-failure-handling/
...
...               Keywords are imported from the resource file
Resource          ../../keywords/node.resource
Resource          ../../keywords/common.resource
Test setup    set_test_environment    ${TEST NAME}
Test Teardown    cleanup_resources

*** Variable ***
${volume_size_gb}=    1
${replica_count}=    2
${wait_interval}=    5

*** Test Cases ***
Scenario 1
    [Documentation]    RWO volume with replica on attached node, and power off the volume attached node
    [Tags]    RWO 
    Given Create ${volume_size_gb} GB RWO volume with ${replica_count} replicas
    And Create 2 pod with StatefulSet deployed
    And Settings node-down-pod-deletion-policy is do-nothing
    When Power off the node ${volunme_attached_node}
    Then Pod field deletionTimestamp should not be empty
    And Pod state should be terminating
    And Pod count should be 2

Scenario 2
    [Documentation]    RWO volume with replica on attached node, and power off the volume attached node
    [Tags]    
    Given Create ${volume_size_gb} GB RWO volume with ${replica_count} replicas
    And Create 1 pod with Deployment deployed
    And Settings node-down-pod-deletion-policy is do-nothing
    When Power off the node ${volunme_attached_node}
    Then Pod field deletionTimestamp should not be empty
    And Pod state should be pending
    When Delete state pending pod
    Then Wait 2 pod state should be running
    And Can access mount point 

Scenario 3
    [Documentation]    RWO volume with replica on attached node, and power off the volume attached node
    [Tags]    
    Given Create ${volume_size_gb} GB RWO volume with ${replica_count} replicas
    And Create 2 pod with StatefulSet deployed
    And Settings node-down-pod-deletion-policy is delete-deployment-pod
    When Power off the node ${volunme_attached_node}
    Then Pod field deletionTimestamp should not be empty
    And Pod state should be terminating
    And Pod count should be 2

Scenario 4
    [Documentation]    RWO volume with replica on attached node, and power off the volume attached node
    [Tags]    
    Given Create ${volume_size_gb} GB RWO volume with ${replica_count} replicas
    And Create 1 pod with Deployment deployed
    And Settings node-down-pod-deletion-policy is delete-deployment-pod
    When Power off the node ${volunme_attached_node}
    Then Pod field deletionTimestamp should not be empty
    And Pod state should be pending
    When Delete state pending pod
    Then Wait 2 pod state should be running
    And Can access mount point 

Scenario 5
    [Documentation]    RWO volume with replica on attached node, and power off the volume attached node
    [Tags]    
    Given Create ${volume_size_gb} GB RWO volume with ${replica_count} replicas
    And Create 2 pod with StatefulSet deployed
    And Settings node-down-pod-deletion-policy is delete-statefulset-pod
    When Power off the node ${volunme_attached_node}
    Then Pod field deletionTimestamp should not be empty
    And Pod state should be terminating
    When Sleep ${wait_interval} minutes
    Then Pod count should be 2
    And Can access mount point

Scenario 6
    [Documentation]    RWO volume with replica on attached node, and power off the volume attached node
    [Tags]    
    Given Create ${volume_size_gb} GB RWO volume with ${replica_count} replicas
    And Create 2 pod with StatefulSet deployed
    And Settings node-down-pod-deletion-policy is delete-both-statefulset-and-deployment-pod
    When Power off the node ${volunme_attached_node}    
    Then Pod field deletionTimestamp should not be empty
    And Pod state should be terminating
    When Sleep ${wait_interval} minutes
    Then Pod count should be 2
    And Can access mount point

Scenario 7
    [Documentation]    RWO volume with replica on attached node, and power off the volume attached node
    [Tags]    
    Given Create ${volume_size_gb} GB RWO volume with ${replica_count} replicas
    And Create 1 pod with Deployment deployed
    And Settings node-down-pod-deletion-policy is delete-statefulset-pod
    When Power off the node ${volunme_attached_node}    
    Then Pod field deletionTimestamp should not be empty
    And Pod state should be terminating
    When Sleep ${wait_interval} minutes
    Then Pod count should be 1
    And Can access mount point

Scenario 8
    [Documentation]    RWO volume with replica on attached node, and power off the volume attached node
    [Tags]    
    Given Create ${volume_size_gb} GB RWO volume with ${replica_count} replicas
    And Create 1 pod with Deployment deployed
    And Settings node-down-pod-deletion-policy is delete-both-statefulset-and-deployment-pod
    When Power off the node ${volunme_attached_node}    
    Then Pod field deletionTimestamp should not be empty
    And Pod state should be terminating
    When Sleep ${wait_interval} minutes
    Then Pod count should be 1
    And Can access mount point
