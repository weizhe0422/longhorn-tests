*** Settings ***
Documentation     
...               Keywords defined here can be used where this Keywords.resource in loaded.
Library    ../libs/steps.py

*** Keywords ***
Node ${node_number} state should be ${node_expect_state}
    ${node_current_state} =   get_node_state   ${node_number}
    Should Be Equal    ${node_current_state}    ${node_expect_state}

Volume state should be ${volume_expect_state}
    ${volume_current_state} =   get_volume_state   ${volume_name}
    Should Be Equal    ${volume_current_state}    ${volume_expect_state}
    
Engine state should be ${engine_expect_state}
    ${engine_current_state} =   get_engine_state   ${volume_name}   ${volunme_attached_node}
    check_workload_state    ${engine_current_state}    ${engine_expect_state}

Replica on the node ${node_number} state should be ${replica_expect_state}
    ${replica_current_state} =   get_replica_state   ${volume_name}   ${node_number}
    check_workload_state    ${replica_current_state}    ${replica_expect_state}

Check data is intact
    check_data    ${volume_name}    ${volume_data_checksum}

Sleep ${POD_EVICTION_TIME_OUT} seconds
    wait_with_time_interval    ${POD_EVICTION_TIME_OUT}

Settings ${setting_name} is ${setting_value}
    update_setting_custom_resource   ${setting_name}   ${setting_value}

Create ${replica_count} pod with Deployment deployed
    ${pod_list} =   create_pod_with_deployment   ${replica_count}   ${volume_name}
    Set Test Variable    ${pod_list}

Create ${replica_count} pod with StatefulSet deployed
    create_pod_with_statefulset   ${replica_count}

Pod state should be ${pod_expect_state}
    ${pod_current_state} =   get_pod_state   ${pod_list}
    check_workload_state    ${pod_current_state}    ${pod_expect_state}