*** Settings ***
Documentation     
...               Keywords defined here can be used where this Keywords.resource in loaded.
Library    ../libs/steps.py
Resource    ../keywords/utility.resource

*** Variable ***
${retry_time_out}=    600
${retry_interval}=    5

*** Keywords ***
Volume state should be ${volume_expect_state}
    Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Check volume state should be ${volume_expect_state}

Node ${node_number} with replica node state should be ${node_expect_state}
    ${target_node_number} =    Evaluate    ${node_number}-1
    Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Check node ${node_number_with_replica}[${target_node_number}] state should be ${node_expect_state}

Node ${node_number} without replica node state should be ${node_expect_state}
    ${target_node_number} =    Evaluate    ${node_number}-1
    Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Check node ${node_number_without_replica}[${target_node_number}] state should be ${node_expect_state}

Engine state should be ${engine_expect_state}
    Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Check engine state should be ${engine_expect_state}

All replicas state should be ${replica_expect_state}
    FOR    ${node_number}    IN    @{node_number_with_replica}
        Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Check replica on the node ${node_number} state should be ${replica_expect_state}
    END

Replica state on node ${node_number} with replica should be ${replica_expect_state}
    ${target_node_number} =    Evaluate    ${node_number}-1
    Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Check replica on the node ${node_number_with_replica}[${target_node_number}] state should be ${replica_expect_state}

Data is intact
    Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_time_out} seconds    ${retry_interval} seconds    Check ${volume_name} data ${volume_data_checksum}

Sleep ${POD_EVICTION_TIME_OUT} seconds
    wait_with_time_interval    ${POD_EVICTION_TIME_OUT}

Update the ${setting_name} setting to ${setting_value}
    update_setting_custom_resource   ${setting_name}   ${setting_value}