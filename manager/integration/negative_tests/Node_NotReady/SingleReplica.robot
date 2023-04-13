*** Settings ***
Documentation     Test the resillence if cluster node happend exception
...
...               Keywords are imported from the resource file
Resource          Keywords.resource
Test setup    set_test_environment    ${TEST NAME}
Test Teardown    cleanup_resources

*** Variable ***
${volume_size_gb}=    5

*** Test Cases ***
Scenario 1
    [Documentation]    RWO volume with replica on attached node, and power off the volume attached node
    [Tags]    RWO 
    Given Create ${volume_size_gb} GB RWO volume with 1 replicas
    And Settings default-data-locality is enabled
    And Settings node-down-pod-deletion-policy is do-nothing
    And Create pod with Deployment deployed
    When Power off the node ${volunme_attached_node}
    Then Pod state should be terminating
    And Volume state should be unknown
    When Power on the node ${volunme_attached_node}
    Then Volume state should be healthy
    And Volume attach state should be attached
    And Pod state should be running
    And Check data is intact

Scenario 2
    [Documentation]    RWO volume with replica on attached node, and power off the volume attached node
    [Tags]    
    Given Create ${volume_size_gb} GB RWO volume with 1 replicas
    And Settings default-data-locality is disabled
    And Settings node-down-pod-deletion-policy is do-nothing
    And Create pod with Deployment deployed
    When Power off the node ${volunme_attached_node}
    Then Pod state should be terminating
    And Volume state should be unknown
    When Power on the node ${volunme_attached_node}
    Then Volume state should be healthy
    And Volume attach state should be attached
    And Pod state should be running
    And Check data is intact
    
Scenario 3
    [Documentation]    RWO volume with replica on attached node, and power off the volume attached node
    [Tags]    
    Given Create ${volume_size_gb} GB RWO volume with 1 replicas
    And Settings default-data-locality is strict-local
    And Settings node-down-pod-deletion-policy is do-nothing
    And Create pod with Deployment deployed
    When Power off the node ${volunme_attached_node}
    Then Pod state should be terminating
    And Volume state should be unknown
    When Power on the node ${volunme_attached_node}
    And Sleep 10 minutes 
    Then Volume state should be healthy
    And Volume attach state should be attached
    And Pod state should be running
    And Check data is intact

Scenario 4
    [Documentation]    RWO volume with replica on attached node, and power off the volume attached node
    [Tags]    
    Given Create ${volume_size_gb} GB RWX volume with 1 replicas
    And Settings default-data-locality is enabled
    And Settings node-down-pod-deletion-policy is do-nothing
    And Create pod with Deployment deployed
    When Power off the node ${volunme_attached_node}
    Then Pod state should be terminating
    And Volume state should be unknown
    When Power on the node ${volunme_attached_node}
    Then Volume state should be healthy
    And Volume attach state should be attached
    And Pod state should be running
    And Check data is intact

Scenario 5
    [Documentation]    RWO volume with replica on attached node, and power off the volume attached node
    [Tags]    
    Given Create ${volume_size_gb} GB RWX volume with 1 replicas
    And Settings default-data-locality is disabled
    And Settings node-down-pod-deletion-policy is do-nothing
    And Create pod with Deployment deployed
    When Power off the node ${volunme_attached_node}
    Then Pod state should be terminating
    And Volume state should be unknown
    When Power on the node ${volunme_attached_node}
    Then Volume state should be healthy
    And Volume attach state should be attached
    And Pod state should be running
    And Check data is intact
    
Scenario 6
    [Documentation]    RWO volume with replica on attached node, and power off the volume attached node
    [Tags]    
    Given Create ${volume_size_gb} GB RWX volume with 1 replicas
    And Settings default-data-locality is strict-local
    And Settings node-down-pod-deletion-policy is do-nothing
    And Create pod with Deployment deployed
    When Power off the node ${volunme_attached_node}
    Then Pod state should be terminating
    And Volume state should be unknown
    When Power on the node ${volunme_attached_node}
    And Sleep 10 minutes 
    Then Volume state should be healthy
    And Volume attach state should be attached
    And Pod state should be running
    And Check data is intact

Scenario 7
    [Documentation]    RWO volume with replica on attached node, and power off the volume attached node
    [Tags]    
    Given Create ${volume_size_gb} GB RWO volume with 1 replicas
    And Settings default-data-locality is enabled
    And Settings node-down-pod-deletion-policy is delete-both-statefulset-and-deployment-pod
    And Create pod with Deployment deployed
    When Power off the node ${volunme_attached_node}
    And Sleep 1 minutes
    Then Pod state should be ContainerCreating
    And Volume state should be faulty
    When Power on the node ${volunme_attached_node}
    Then Volume state should be healthy
    And Volume attach state should be attached
    And Pod state should be running
    And Check data is intact

Scenario 8
    [Documentation]    RWO volume with replica on attached node, and power off the volume attached node
    [Tags]    
    Given Create ${volume_size_gb} GB RWO volume with 1 replicas
    And Settings default-data-locality is disabled
    And Settings node-down-pod-deletion-policy is delete-both-statefulset-and-deployment-pod
    And Create pod with Deployment deployed
    When Power off the node ${volunme_attached_node}
    And Sleep 1 minutes
    Then Pod state should be ContainerCreating
    And Volume state should be faulty
    When Power on the node ${volunme_attached_node}
    Then Volume state should be healthy
    And Volume attach state should be attached
    And Pod state should be running
    And Check data is intact
    
Scenario 9
    [Documentation]    RWO volume with replica on attached node, and power off the volume attached node
    [Tags]    
    Given Create ${volume_size_gb} GB RWO volume with 1 replicas
    And Settings default-data-locality is strict-local
    And Settings node-down-pod-deletion-policy is delete-both-statefulset-and-deployment-pod
    And Create pod with Deployment deployed
    When Power off the node ${volunme_attached_node}
    And Sleep 1 minutes
    Then Pod state should be ContainerCreating
    And Volume state should be faulty
    When Power on the node ${volunme_attached_node}
    Then Volume state should be healthy
    And Volume attach state should be attached
    And Pod state should be running
    And Check data is intact

Scenario 10
    [Documentation]    RWO volume with replica on attached node, and power off the volume attached node
    [Tags]    
    Given Create ${volume_size_gb} GB RWX volume with 1 replicas
    And Settings default-data-locality is enabled
    And Settings node-down-pod-deletion-policy is delete-both-statefulset-and-deployment-pod
    And Create pod with Deployment deployed
    When Power off the node ${volunme_attached_node}
    And Sleep 1 minutes
    Then Pod state should be ContainerCreating
    And Volume state should be faulty
    When Power on the node ${volunme_attached_node}
    Then Volume state should be healthy
    And Volume attach state should be attached
    And Pod state should be running
    And Check data is intact

Scenario 11
    [Documentation]    RWO volume with replica on attached node, and power off the volume attached node
    [Tags]    
    Given Create ${volume_size_gb} GB RWX volume with 1 replicas
    And Settings default-data-locality is disabled
    And Settings node-down-pod-deletion-policy is delete-both-statefulset-and-deployment-pod
    And Create pod with Deployment deployed
    When Power off the node ${volunme_attached_node}
    And Sleep 1 minutes
    Then Pod state should be ContainerCreating
    And Volume state should be faulty
    When Power on the node ${volunme_attached_node}
    Then Volume state should be healthy
    And Volume attach state should be attached
    And Pod state should be running
    And Check data is intact
    
Scenario 12
    [Documentation]    RWO volume with replica on attached node, and power off the volume attached node
    [Tags]    
    Given Create ${volume_size_gb} GB RWX volume with 1 replicas
    And Settings default-data-locality is strict-local
    And Settings node-down-pod-deletion-policy is delete-both-statefulset-and-deployment-pod
    And Create pod with Deployment deployed
    When Power off the node ${volunme_attached_node}
    And Sleep 1 minutes
    Then Pod state should be ContainerCreating
    And Volume state should be faulty
    When Power on the node ${volunme_attached_node}
    Then Volume state should be healthy
    And Volume attach state should be attached
    And Pod state should be running
    And Check data is intact