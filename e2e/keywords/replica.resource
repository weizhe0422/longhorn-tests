*** Settings ***
Documentation    Volume Keywords

Library    ../libs/steps.py

*** Keywords ***
All replicas state should be ${expected_replica_state}
    FOR    ${node_index}    IN    @{node_index_with_replica}
        Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_timeout_second} seconds    ${retry_interval} seconds    Check replica on node ${node_index} state should be ${expected_replica_state}
    END

Replica state on node ${node_index} should be ${expected_replica_state}
    ${target_node_index} =    Evaluate    ${node_index}-1
    Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_timeout_second} seconds    ${retry_interval} seconds    Check replica on node ${node_index_with_replica}[${target_node_index}] state should be ${expected_replica_state}

Check replica on node ${node_index} state should be ${expected_replica_state}
    ${replica_current_state} =   get_replica_state   ${volume_name}   ${node_index}
    check_workload_state    ${replica_current_state}    ${expected_replica_state}
