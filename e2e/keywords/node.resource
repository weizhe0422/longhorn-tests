*** Settings ***
Documentation     
...               Keywords defined here can be used where this Keywords.resource in loaded.
Library    ../libs/steps.py
Resource    ../keywords/utility.resource

*** Variables ***
${POD_EVICTION_TIME_OUT}=    300

*** Keywords ***
The ${size} GB ${volume_type} volume with ${request_replica_count} replicas
    ${volume_name} =    create_volume   ${size}   ${request_replica_count}   ${volume_type}
    Set Test Variable    ${volume_name}
    Set Test Variable    ${request_replica_count}
    Get node index with replica
    Get node index without replica

Attach volume to the node ${node_number} with replica node
    ${target_node_number} =    Evaluate    ${node_number}-1
    ${volunme_attached_node} =    attach_volume   ${volume_name}   ${node_number_with_replica}[${target_node_number}]
    ${non_volunme_attached_node} =    get_non_volunme_attached_node   ${volunme_attached_node}
    Set Test Variable    ${volunme_attached_node}
    Set Test Variable    ${non_volunme_attached_node}

Attach volume to the node ${node_number} without replica node
    ${target_node_number} =    Evaluate    ${node_number}-1
    ${volunme_attached_node} =    attach_volume   ${volume_name}   ${node_number_without_replica}[${target_node_number}]
    ${non_volunme_attached_node} =    get_non_volunme_attached_node   ${volunme_attached_node}
    Set Test Variable    ${volunme_attached_node}
    Set Test Variable    ${non_volunme_attached_node}

Attach volume to the no replica node
    ${volunme_attached_node} =    attach_volume_without_replica   ${volume_name}   ${request_replica_count}
    ${non_volunme_attached_node} =    get_non_volunme_attached_node   ${volunme_attached_node}
    Set Test Variable    ${volunme_attached_node}
    Set Test Variable    ${non_volunme_attached_node}

Write data into mount point
    ${volume_data_checksum} =    write_volume_random_data   ${volume_name}    512
    Set Test Variable    ${volume_data_checksum}

Power off the node ${node_number} with replica node
    ${target_node_number} =    Evaluate    ${node_number}-1
    power_off_node   ${node_number_with_replica}[${target_node_number}]

Power off the node ${node_number} without replica node
    ${target_node_number} =    Evaluate    ${node_number}-1
    power_off_node   ${node_number_without_replica}[${target_node_number}]

Power on the node ${node_number} with replica node
    ${target_node_number} =    Evaluate    ${node_number}-1
    power_on_node   ${node_number_with_replica}[${target_node_number}]

Power on the node ${node_number} without replica node
    ${target_node_number} =    Evaluate    ${node_number}-1
    power_on_node   ${node_number_without_replica}[${target_node_number}]

Restart Kubelet the node ${node_number} with replica node
    ${target_node_number} =    Evaluate    ${node_number}-1
    restart_kubelet   ${node_number_with_replica}[${target_node_number}]    0

Restart Kubelet the node ${node_number} without replica node
    ${target_node_number} =    Evaluate    ${node_number}-1
    restart_kubelet   ${node_number_without_replica}[${target_node_number}]    0

Restart Kubelet timeout on the node ${node_number} with replica node
    ${target_node_number} =    Evaluate    ${node_number}-1
    restart_kubelet   ${node_number_with_replica}[${target_node_number}]   ${POD_EVICTION_TIME_OUT}

Restart Kubelet timeout on the node ${node_number} without replica node
    ${target_node_number} =    Evaluate    ${node_number}-1
    restart_kubelet   ${node_number_without_replica}[${target_node_number}]   ${POD_EVICTION_TIME_OUT}

Reboot the node ${node_number} with replica node
    ${target_node_number} =    Evaluate    ${node_number}-1
    reboot_node   ${node_number_with_replica}[${target_node_number}]

Reboot the node ${node_number} without replica node
    ${target_node_number} =    Evaluate    ${node_number}-1
    reboot_node   ${node_number_without_replica}[${target_node_number}]


Get node index without replica
    ${node_number_without_replica} =    get_no_replica_node   ${volume_name}   ${request_replica_count}
    Set Test Variable    ${node_number_without_replica}

Get node index with replica
    ${node_number_with_replica} =    get_with_replica_node   ${volume_name}   ${request_replica_count}
    Set Test Variable    ${node_number_with_replica}

Restart Kubelet on the node ${node_name} exceeds the pod eviction timeout
    stop_kubelet_aws_ec2_instance   ${node_name}
    sleep ${POD_EVICTION_TIME_OUT}
    start_kubelet_aws_ec2_instance   ${node_name}

Reboot the node ${node_name} exceeds the pod eviction timeout
    stop_aws_ec2_instance   ${node_name}
    sleep ${POD_EVICTION_TIME_OUT}
    start_aws_ec2_instance   ${node_name}

Disconnect network the node ${node_number}
    disconnect_network   ${node_number}

Connect network the node ${node_number}
    connect_network   ${node_number}

Interrupt the node ${node_number} of with replica nodes network for ${time_inerval} seconds
    ${target_node_number} =    Evaluate    ${node_number}-1
    interrupt_network   ${node_number_with_replica}[${target_node_number}]   ${time_inerval}

Interrupt the node ${node_number} of without replica nodes network for ${time_inerval} seconds
    ${target_node_number} =    Evaluate    ${node_number}-1
    interrupt_network   ${node_number_without_replica}[${target_node_number}]   ${time_inerval}

During writing data into mount point interrupt the node ${node_number} of with replica nodes network for ${time_inerval} seconds
    ${target_node_number} =    Evaluate    ${node_number}-1
    during_data_wrting_interrupt_network   ${node_number_with_replica}[${target_node_number}]   ${time_inerval}   ${volume_name}    512

During writing data into mount point interrupt the node ${node_number} of without replica nodes network for ${time_inerval} seconds
    ${target_node_number} =    Evaluate    ${node_number}-1
    during_data_wrting_interrupt_network   ${node_number_without_replica}[${target_node_number}]   ${time_inerval}   ${volume_name}    512
