*** Settings ***
Documentation
...               Keywords defined here can be used where this Keywords.resource in loaded.
Library    ../libs/steps.py

*** Variables ***
${POD_EVICTION_TIME_OUT}=    300

*** Keywords ***
A ${size} GB ${volume_type} volume with ${request_replica_count} replicas
    ${volume_name} =    create_volume   ${size}   ${request_replica_count}   ${volume_type}
    Set Test Variable    ${volume_name}
    Set Test Variable    ${request_replica_count}
    Get the index of the cluster nodes
    Get node index with replica
    Get node index without replica

Get the index of the cluster nodes
    ${cluster_node_index} =    get_cluster_node_index   ${volume_name}   ${request_replica_count}
    Set Test Variable    ${cluster_node_index}

Attach volume to the node ${node_index}
    ${target_node_index} =    Evaluate    ${node_index}-1
    ${volume_attached_node} =    attach_volume   ${volume_name}   ${cluster_node_index}[${target_node_index}]
    ${non_volume_attached_node} =    get_non_volume_attached_node   ${volume_attached_node}
    Set Test Variable    ${volume_attached_node}
    Set Test Variable    ${non_volume_attached_node}

Attach volume to node ${node_index} with replica node
    ${target_node_index} =    Evaluate    ${node_index}-1
    ${volume_attached_node} =    attach_volume   ${volume_name}   ${node_index_with_replica}[${target_node_index}]
    ${non_volume_attached_node} =    get_non_volume_attached_node   ${volume_attached_node}
    Set Test Variable    ${volume_attached_node}
    Set Test Variable    ${non_volume_attached_node}

Attach volume to node ${node_index} without replica node
    ${target_node_index} =    Evaluate    ${node_index}-1
    ${volume_attached_node} =    attach_volume   ${volume_name}   ${node_index_without_replica}[${target_node_index}]
    ${non_volume_attached_node} =    get_non_volume_attached_node   ${volume_attached_node}
    Set Test Variable    ${volume_attached_node}
    Set Test Variable    ${non_volume_attached_node}

Attach volume to the no replica node
    ${volume_attached_node} =    attach_volume_without_replica   ${volume_name}   ${request_replica_count}
    ${non_volume_attached_node} =    get_non_volume_attached_node   ${volume_attached_node}
    Set Test Variable    ${volume_attached_node}
    Set Test Variable    ${non_volume_attached_node}

Write data into mount point
    ${volume_data_checksum} =    write_volume_random_data   ${volume_name}    512
    Set Test Variable    ${volume_data_checksum}

Power off the node ${node_index}
    ${target_node_index} =    Evaluate    ${node_index}-1
    power_off_node   ${cluster_node_index}[${target_node_index}]

Power off node ${node_index} with replica node
    ${target_node_index} =    Evaluate    ${node_index}-1
    power_off_node   ${node_index_with_replica}[${target_node_index}]

Power off node ${node_index} without replica node
    ${target_node_index} =    Evaluate    ${node_index}-1
    power_off_node   ${node_index_without_replica}[${target_node_index}]

Power on the node ${node_index}
    ${target_node_index} =    Evaluate    ${node_index}-1
    power_on_node   ${cluster_node_index}[${target_node_index}]

Power on node ${node_index} with replica node
    ${target_node_index} =    Evaluate    ${node_index}-1
    power_on_node   ${node_index_with_replica}[${target_node_index}]

Power on node ${node_index} without replica node
    ${target_node_index} =    Evaluate    ${node_index}-1
    power_on_node   ${node_index_without_replica}[${target_node_index}]

Restart Kubelet the node ${node_index}
    ${target_node_index} =    Evaluate    ${node_index}-1
    restart_kubelet   ${cluster_node_index}[${target_node_index}]    0

Restart Kubelet node ${node_index} with replica node
    ${target_node_index} =    Evaluate    ${node_index}-1
    restart_kubelet   ${node_index_with_replica}[${target_node_index}]    0

Restart Kubelet node ${node_index} without replica node
    ${target_node_index} =    Evaluate    ${node_index}-1
    restart_kubelet   ${node_index_without_replica}[${target_node_index}]    0

Restart Kubelet timeout on the node ${node_index}
    ${target_node_index} =    Evaluate    ${node_index}-1
    restart_kubelet   ${cluster_node_index}[${target_node_index}]   ${POD_EVICTION_TIME_OUT}

Restart Kubelet timeout on node ${node_index} with replica node
    ${target_node_index} =    Evaluate    ${node_index}-1
    restart_kubelet   ${node_index_with_replica}[${target_node_index}]   ${POD_EVICTION_TIME_OUT}

Restart Kubelet timeout on node ${node_index} without replica node
    ${target_node_index} =    Evaluate    ${node_index}-1
    restart_kubelet   ${node_index_without_replica}[${target_node_index}]   ${POD_EVICTION_TIME_OUT}

Reboot the node ${node_index}
    ${target_node_index} =    Evaluate    ${node_index}-1
    reboot_node   ${cluster_node_index}[${target_node_index}]

Reboot node ${node_index} with replica node
    ${target_node_index} =    Evaluate    ${node_index}-1
    reboot_node   ${node_index_with_replica}[${target_node_index}]

Reboot node ${node_index} without replica node
    ${target_node_index} =    Evaluate    ${node_index}-1
    reboot_node   ${node_index_without_replica}[${target_node_index}]

Get node index without replica
    ${node_index_without_replica} =    get_no_replica_node   ${volume_name}   ${request_replica_count}
    Set Test Variable    ${node_index_without_replica}

Get node index with replica
    ${node_index_with_replica} =    get_with_replica_node   ${volume_name}   ${request_replica_count}
    Set Test Variable    ${node_index_with_replica}

Restart Kubelet on node ${node_name} exceeds the pod eviction timeout
    stop_kubelet_aws_ec2_instance   ${node_name}
    sleep ${POD_EVICTION_TIME_OUT}
    start_kubelet_aws_ec2_instance   ${node_name}

Reboot node ${node_name} exceeds the pod eviction timeout
    stop_aws_ec2_instance   ${node_name}
    sleep ${POD_EVICTION_TIME_OUT}
    start_aws_ec2_instance   ${node_name}

Disconnect the network on node ${node_index}
    disconnect_network   ${node_index}

Connect the network on node ${node_index}
    connect_network   ${node_index}

Interrupt the node ${node_index} network for ${time_inerval} seconds
    ${target_node_index} =    Evaluate    ${node_index}-1
    interrupt_network   ${cluster_node_index}[${target_node_index}]   ${time_inerval}

Interrupt node ${node_index} of with replica nodes network for ${time_inerval} seconds
    ${target_node_index} =    Evaluate    ${node_index}-1
    interrupt_network   ${node_index_with_replica}[${target_node_index}]   ${time_inerval}

Interrupt node ${node_index} of without replica nodes network for ${time_inerval} seconds
    ${target_node_index} =    Evaluate    ${node_index}-1
    interrupt_network   ${node_index_without_replica}[${target_node_index}]   ${time_inerval}

During writing data into mount point interrupt the node ${node_index} network for ${time_inerval} seconds
    ${target_node_index} =    Evaluate    ${node_index}-1
    during_data_wrting_interrupt_network   ${cluster_node_index}[${target_node_index}]   ${time_inerval}   ${volume_name}   512

During writing data into mount point interrupt node ${node_index} of with replica nodes network for ${time_inerval} seconds
    ${target_node_index} =    Evaluate    ${node_index}-1
    during_data_wrting_interrupt_network   ${node_index_with_replica}[${target_node_index}]   ${time_inerval}   ${volume_name}   512

During writing data into mount point interrupt node ${node_index} of without replica nodes network for ${time_inerval} seconds
    ${target_node_index} =    Evaluate    ${node_index}-1
    during_data_wrting_interrupt_network   ${node_index_without_replica}[${target_node_index}]   ${time_inerval}   ${volume_name}    2048

The node ${node_index} state should be ${expected_node_state}
    ${target_node_index} =    Evaluate    ${node_index}-1
    Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_timeout_second} seconds    ${retry_interval} seconds    Check node ${cluster_node_index}[${target_node_index}] state should be ${expected_node_state}

Node ${node_index} with replica node state should be ${expected_node_state}
    ${target_node_index} =    Evaluate    ${node_index}-1
    Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_timeout_second} seconds    ${retry_interval} seconds    Check node ${node_index_with_replica}[${target_node_index}] state should be ${expected_node_state}

Node ${node_index} without replica node state should be ${expected_node_state}
    ${target_node_index} =    Evaluate    ${node_index}-1
    Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_timeout_second} seconds    ${retry_interval} seconds    Check node ${node_index_without_replica}[${target_node_index}] state should be ${expected_node_state}

Check node ${node_index} state should be ${expected_node_state}
    ${node_current_state} =   get_node_state   ${node_index}
    Should Be Equal    ${node_current_state}    ${expected_node_state}
