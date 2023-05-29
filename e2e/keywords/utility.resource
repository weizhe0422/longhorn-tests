*** Settings ***
Documentation     
...               Keywords defined here can be used where this Keywords.resource in loaded.
Library    ../libs/steps.py

*** Variable ***
${retry_time_out}=    600
${retry_interval}=    5

*** Keywords ***
Check volume state should be ${volume_expect_state}
    ${volume_current_state} =   get_volume_state   ${volume_name}
    Should Be Equal    ${volume_current_state}    ${volume_expect_state}

Check node ${node_number} state should be ${node_expect_state}
    ${node_current_state} =   get_node_state   ${node_number}
    Should Be Equal    ${node_current_state}    ${node_expect_state}

Check engine state should be ${engine_expect_state}
    ${engine_current_state} =   get_engine_state   ${volume_name}   ${volunme_attached_node}
    check_workload_state    ${engine_current_state}    ${engine_expect_state}

Check replica on the node ${node_number} state should be ${replica_expect_state}
    ${replica_current_state} =   get_replica_state   ${volume_name}   ${node_number}
    check_workload_state    ${replica_current_state}    ${replica_expect_state}

Check ${volume_name} data ${volume_data_checksum}
    check_data    ${volume_name}    ${volume_data_checksum}