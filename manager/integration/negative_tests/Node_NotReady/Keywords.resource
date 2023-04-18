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

Attach volume to the node
    ${volunme_attached_node} =    attach_volume   ${volume_name}
    ${non_volunme_attached_node} =    get_non_volunme_attached_node   ${volunme_attached_node}
    Set Test Variable    ${volunme_attached_node}
    Set Test Variable    ${non_volunme_attached_node}

Write data into mount point
    ${volume_data_checksum} =    write_volume_random_data   ${volume_name}    2048
    Set Test Variable    ${volume_data_checksum}

Power off the node ${node_name}
    power_off_node   ${node_name}

Power on the node ${node_name}
    power_on_node   ${node_name}

Restart Kubelet on the node ${node_name}
    restart_kubelet   ${node_name}    0
    
Restart Kubelet on the node ${node_name} exceed ${POD_EVICTION_TIME_OUT} seconds
    restart_kubelet   ${node_name}    ${POD_EVICTION_TIME_OUT}

Disconnect node ${node_name} network ${TIME_INTERVAL} seconds
    disconnect_network   ${node_name}    ${TIME_INTERVAL}
    
Reboot the volume-attached node ${node_name}
    reboot_aws_ec2_instance   ${node_name}

Restart Kubelet on the node ${node_name} exceeds the pod eviction timeout
    stop_kubelet_aws_ec2_instance   ${node_name}
    sleep ${POD_EVICTION_TIME_OUT}
    start_kubelet_aws_ec2_instance   ${node_name}

Reboot the node ${node_name} exceeds the pod eviction timeout
    stop_aws_ec2_instance   ${node_name}
    sleep ${POD_EVICTION_TIME_OUT}
    start_aws_ec2_instance   ${node_name}

Node ${node_name} state should be ${node_expect_state}
    ${node_current_state} =   get_node_state   ${node_name}
    Should Be Equal    ${node_current_state}    ${node_expect_state}

Volume state should be ${volume_expect_state}
    ${volume_current_state} =   get_volume_state   ${volume_name}
    Should Be Equal    ${volume_current_state}    ${volume_expect_state}
    
Engine state should be ${engine_expect_state}
    ${engine_current_state} =   get_engine_state   ${volume_name}   ${volunme_attached_node}
    check_workload_state    ${engine_current_state}    ${engine_expect_state}

Replica on the node ${node_name} state should be ${replica_expect_state}
    ${replica_current_state} =   get_replica_state   ${volume_name}   ${node_name}
    check_workload_state    ${replica_current_state}    ${replica_expect_state}

Check data is intact
    check_data    ${volume_name}    ${volume_data_checksum}