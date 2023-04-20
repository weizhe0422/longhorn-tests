*** Settings ***
Documentation     
...               Keywords defined here can be used where this Keywords.resource in loaded.
Library    ../../framework/steps.py

*** Variables ***
${POD_EVICTION_TIME_OUT}=    300

*** Keywords ***
Create ${size} GB ${volume_type} volume with ${replica_count} replicas
    ${volume_name} =    create_volume   ${size}   ${replica_count}   ${volume_type}
    Set Test Variable    ${volume_name}

Attach volume to the node ${node_number}
    ${volunme_attached_node} =    attach_volume   ${volume_name}   ${node_number}
    ${non_volunme_attached_node} =    get_non_volunme_attached_node   ${volunme_attached_node}
    Set Test Variable    ${volunme_attached_node}
    Set Test Variable    ${non_volunme_attached_node}

Attach volume to the no replica node
    ${volunme_attached_node} =    attach_volume_without_replica   ${volume_name}
    ${non_volunme_attached_node} =    get_non_volunme_attached_node   ${volunme_attached_node}
    Set Test Variable    ${volunme_attached_node}
    Set Test Variable    ${non_volunme_attached_node}

Write data into mount point
    ${volume_data_checksum} =    write_volume_random_data   ${volume_name}    512
    Set Test Variable    ${volume_data_checksum}

Power off the node ${node_number}
    power_off_node   ${node_number}

Power off the without replica node 
    ${node_number_without_replica} =    get_no_replica_node   ${volume_name}
    power_off_node   ${node_number_without_replica}
    Set Test Variable    ${node_number_without_replica}

Power on the node ${node_number}
    power_on_node   ${node_number}

Restart Kubelet on the node ${node_number}
    restart_kubelet   ${node_number}    0
    
Restart Kubelet on the node ${node_number} exceed ${POD_EVICTION_TIME_OUT} seconds
    restart_kubelet   ${node_number}    ${POD_EVICTION_TIME_OUT}

Disconnect node ${node_number} network ${TIME_INTERVAL} seconds
    disconnect_network   ${node_number}    ${TIME_INTERVAL}
    
Reboot the node ${node_number}
    reboot_aws_ec2_instance   ${node_number}

Restart Kubelet on the node ${node_name} exceeds the pod eviction timeout
    stop_kubelet_aws_ec2_instance   ${node_name}
    sleep ${POD_EVICTION_TIME_OUT}
    start_kubelet_aws_ec2_instance   ${node_name}

Reboot the node ${node_name} exceeds the pod eviction timeout
    stop_aws_ec2_instance   ${node_name}
    sleep ${POD_EVICTION_TIME_OUT}
    start_aws_ec2_instance   ${node_name}

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