*** Settings ***
Documentation    Longhorn volume related keywords resources

Library    ../libs/steps.py

*** Keywords ***
A ${size} GB ${volume_type} volume with ${request_replica_count} replicas
    ${volume_name} =    create_volume   ${size}   ${request_replica_count}   ${volume_type}
    Set Test Variable    ${volume_name}
    Set Test Variable    ${request_replica_count}
    Get the index of the cluster nodes
    Get node index with replica
    Get node index without replica

Create a volume ${size} GB with ${replica_count} replicas
    ${volume_name} =    create_volume   ${size}    ${replica_count}
    attach_volume    ${volume_name}
    Set Test Variable    ${volume_name}

Attach volume to node ${node_index}
    ${target_node_index} =    Evaluate    ${node_index}-1
    ${volume_attached_node} =    attach_volume   ${volume_name}   ${cluster_node_index}[${target_node_index}]
    ${non_volume_attached_node} =    get_non_volume_attached_node   ${volume_attached_node}
    Set Test Variable    ${volume_attached_node}
    Set Test Variable    ${non_volume_attached_node}

Write data into mount point
    ${volume_data_checksum} =    write_volume_random_data   ${volume_name}    512
    Set Test Variable    ${volume_data_checksum}

Write data to the volume
    ${volume_data_checksum} =     write_volume_random_data   ${volume_name}    1024
    Set Test Variable    ${volume_data_checksum}

Delete replica ${replica_0} to trigger replica ${replica_0} rebuilding
    delete_replica    ${volume_name}    ${replica_0}
    wait_for_replica_rebuilding_start    ${volume_name}    ${replica_0}

During replica ${replica_0} rebuilding, delete replica ${replica_1}
    wait_for_replica_rebuilding_start    ${volume_name}    ${replica_0}
    delete_replica    ${volume_name}    ${replica_1}

Wait until replica ${replica_0} rebuilt, delete replica ${replica_2}
    wait_for_replica_rebuilding_complete    ${volume_name}    ${replica_0}
    delete_replica    ${volume_name}    ${replica_2}

Check data is intact
    check_data    ${volume_name}    ${volume_data_checksum}

Wait until all replicas rebuilt
    wait_for_replica_rebuilding_complete    ${volume_name}    0
    wait_for_replica_rebuilding_complete    ${volume_name}    1
    wait_for_replica_rebuilding_complete    ${volume_name}    2

Volume ${volume_name} data checksum should be ${volume_data_checksum}
    check_data    ${volume_name}    ${volume_data_checksum}

Volume state should be ${expected_volume_state}
    Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_timeout_second} seconds    ${retry_interval} seconds    Check volume state should be ${expected_volume_state}

Check volume state should be ${expected_volume_state}
    ${volume_current_state} =   get_volume_state   ${volume_name}
    Should Be Equal    ${volume_current_state}    ${expected_volume_state}
