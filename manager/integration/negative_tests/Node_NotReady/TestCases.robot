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
    [Tags]    RWO PowerOffNode
    # Recover: After restart the node, volume should be detached and replica is failed. Need manual to do reattached.
    Given Create ${volume_size_gb} GB RWO volume with 3 replicas
    And Attach volume to the node
    And Write data into mount point
    When Power off the node ${volunme_attached_node}
    Then Node ${volunme_attached_node} state should be NotReady
    And Volume state should be unknown
    And Engine state should be unknown
    And Replica on the node ${volunme_attached_node} state should be unknown

Scenario 2
    [Documentation]    RWO volume with replica on attached node, and power off the non volume attached node
    [Tags]    RWO PowerOffNode
    # Recover: After restart the node, delete the stopped replica, and re-update the replica count to do rebuilding
    Given Create ${volume_size_gb} GB RWO volume with 3 replicas
    And Attach volume to the node
    And Write data into mount point
    When Power off the node ${non_volunme_attached_node}
    Then Node ${non_volunme_attached_node} state should be NotReady
    And Volume state should be degraded
    And Engine state should be running
    And Replica on the node ${non_volunme_attached_node} state should be stopped
    And Check data is intact

RWO volume with replica on attached node, and Reboot the node ${volunme_attached_node}
# Recover: After the reboot node recover, volume should be Healthy through Unknown and the replicas and engines are running
    Given Create ${volume_size} GB RWO volume with 3 replicas
    And Attach volume to the node
    When Write data into mount point
    And Reboot the node ${volunme_attached_node}
    Then Node ${volunme_attached_node} state should be 'Down'
    And Volume final state is 'Healthy'
    And Engine final state is 'Running'
    And All replicas are 'Running'
    And Check data is intact
    
RWO volume with replica on attached node, and Reboot the node ${non_volunme_attached_node}
# Recover: After the reboot node recover, volume should be Healthy through Degraded and the replicas and engines are running
    Given Create ${volume_size} GB RWO volume with 3 replicas
    And Attach volume to the node
    When Write data into mount point
    And Reboot the node ${non_volunme_attached_node}
    Then Node ${non_volunme_attached_node} state should be 'Down'
    And Volume final state is 'Healthy'
    And Engine final state is 'Running'
    And All replicas are 'Running'
    And Check data is intact
    
RWO volume with replica on attached node, and Restart Kubelet on the node ${volunme_attached_node}
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size} GB RWO volume with 3 replicas
    And Attach volume to the node
    When Write data into mount point
    And Restart Kubelet on the node ${volunme_attached_node}
    Then Volume final state is 'Healthy'
    And Engine final state is 'Running'
    And All replicas are 'Running'
    And Check data is intact
    
RWO volume with replica on attached node, and restart Kubelet on the non volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size} GB RWO volume with 3 replicas
    And Attach volume to the node
    When Write data into mount point
    And Restart Kubelet on the node ${non_volunme_attached_node}
    Then Volume final state is 'Healthy'
    And Engine final state is 'Running'
    And All replicas are 'Running'
    And Check data is intact
    
RWO volume with replica on attached node, and Power off the node ${volunme_attached_node}
# Recover: After restart the node, volume should be detached and replica is failed. Need manual to do reattached.
    Given Create ${volume_size} GB RWO volume with 3 replicas
    And Attach volume to the node
    When Write data into mount point
    And Power off the node ${volunme_attached_node}
    Then Node ${volunme_attached_node} state should be 'Down'
    And Volume state should be 'Unknown'
    And Engine state should be 'unknown'
    And Replica on the node ${volunme_attached_node} state should be 'unknown'
    And Check data is intact
    
RWO volume with replica on attached node, and Power off the node ${non_volunme_attached_node}
# Recover: After restart the node, delete the stopped replica, and re-update the replica count to do rebuilding
    Given Create ${volume_size} GB RWO volume with 3 replicas
    And Attach volume to the node
    When Write data into mount point
    And Power off the node ${non_volunme_attached_node}
    Then Node ${non_volunme_attached_node} state should be 'Down'
    And Volume is still 'Degraded'
    And Replica on the node ${non_volunme_attached_node} should be 'stopped'
    And Check data is intact
    
RWO volume with replica on attached node, and Reboot the node ${volunme_attached_node}
# Recover: After the reboot node recover, volume should be Healthy through Unknown and the replicas and engines are running
    Given Create ${volume_size} GB RWO volume with 3 replicas
    And Attach volume to the node
    When Write data into mount point
    And Reboot the node ${volunme_attached_node}
    Then Node ${volunme_attached_node} state should be 'Down'
    And Volume final state is 'Healthy'
    And Engine final state is 'Running'
    And All replicas are 'Running'
    And Check data is intact
    
RWO volume with replica on attached node, and Reboot the node ${non_volunme_attached_node}
# Recover: After the reboot node recover, volume should be Healthy through Degraded and the replicas and engines are running
    Given Create ${volume_size} GB RWO volume with 3 replicas
    And Attach volume to the node
    When Write data into mount point
    And Reboot the node ${non_volunme_attached_node}
    Then Node ${non_volunme_attached_node} state should be 'Down'
    And Volume final state is 'Healthy'
    And Engine final state is 'Running'
    And All replicas are 'Running'
    And Check data is intact
    
RWO volume with replica on attached node, and Restart Kubelet on the node ${volunme_attached_node}
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size} GB RWO volume with 3 replicas
    And Attach volume to the node
    When Write data into mount point
    And Restart Kubelet on the node ${volunme_attached_node}
    Then Volume final state is 'Healthy'
    And Engine final state is 'Running'
    And All replicas are 'Running'
    And Check data is intact
    
RWO volume with replica on attached node, and restart Kubelet on the non volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size} GB RWO volume with 3 replicas
    And Attach volume to the node
    When Write data into mount point
    And Restart Kubelet on the node ${non_volunme_attached_node}
    Then Volume final state is 'Healthy'
    And Engine final state is 'Running'
    And All replicas are 'Running'
    And Check data is intact
    
RWO volume with no replica on attached node, and Power off the node ${volunme_attached_node}
# Recover: After restart the node, volume should be detached and replica is failed. Need manual to do reattached.
    Given Create 5 GB RWO volume with 2 replicas
    And Attach volume to the 3rd node
    When Write data into mount point
    And Power off the node ${volunme_attached_node}
    Then 
    And Check data is intact
    
RWO volume with no replica on attached node, and Power off the node ${non_volunme_attached_node}
# Recover: After restart the node, delete the stopped replica, and re-update the replica count to do rebuilding
    Given Create 5 GB RWO volume with 2 replicas
    And Attach volume to the 3rd node
    When Write data into mount point
    And Power off the node ${non_volunme_attached_node}
    Then 
    And Check data is intact
    
RWO volume with no replica on attached node, and Reboot the node ${volunme_attached_node}
# Recover: After the reboot node recover, volume should be Healthy through Unknown and the replicas and engines are running
    Given Create 5 GB RWO volume with 2 replicas
    And Attach volume to the 3rd node
    When Write data into mount point
    And Reboot the node ${volunme_attached_node}
    Then 
    And Check data is intact
    
RWO volume with no replica on attached node, and Reboot the node ${non_volunme_attached_node}
# Recover: After the reboot node recover, volume should be Healthy through Degraded and the replicas and engines are running
    Given Create 5 GB RWO volume with 2 replicas
    And Attach volume to the 3rd node
    When Write data into mount point
    And Reboot the node ${non_volunme_attached_node}
    Then 
    And Check data is intact
    
RWO volume with no replica on attached node, and Restart Kubelet on the node ${volunme_attached_node}
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create 5 GB RWO volume with 2 replicas
    And Attach volume to the 3rd node
    When Write data into mount point
    And Restart Kubelet on the node ${volunme_attached_node}
    Then 
    And Check data is intact
    
RWO volume with no replica on attached node, and restart Kubelet on the non volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create 5 GB RWO volume with 2 replicas
    And Attach volume to the 3rd node
    When Write data into mount point
    And Restart Kubelet on the node ${non_volunme_attached_node}
    Then 
    And Check data is intact
    
RWO volume with no replica on attached node, and Power off the node ${volunme_attached_node}
# Recover: After restart the node, volume should be detached and replica is failed. Need manual to do reattached.
    Given Create 5 GB RWO volume with 2 replicas
    And Attach volume to the 3rd node
    When Write data into mount point
    And Power off the node ${volunme_attached_node}
    Then 
    And Check data is intact
    
RWO volume with no replica on attached node, and Power off the node ${non_volunme_attached_node}
# Recover: After restart the node, delete the stopped replica, and re-update the replica count to do rebuilding
    Given Create 5 GB RWO volume with 2 replicas
    And Attach volume to the 3rd node
    When Write data into mount point
    And Power off the node ${non_volunme_attached_node}
    Then 
    And Check data is intact
    
RWO volume with no replica on attached node, and Reboot the node ${volunme_attached_node}
# Recover: After the reboot node recover, volume should be Healthy through Unknown and the replicas and engines are running
    Given Create 5 GB RWO volume with 2 replicas
    And Attach volume to the 3rd node
    When Write data into mount point
    And Reboot the node ${volunme_attached_node}
    Then 
    And Check data is intact
    
RWO volume with no replica on attached node, and Reboot the node ${non_volunme_attached_node}
# Recover: After the reboot node recover, volume should be Healthy through Degraded and the replicas and engines are running
    Given Create 5 GB RWO volume with 2 replicas
    And Attach volume to the 3rd node
    When Write data into mount point
    And Reboot the node ${non_volunme_attached_node}
    Then 
    And Check data is intact
    
RWO volume with no replica on attached node, and Restart Kubelet on the node ${volunme_attached_node}
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create 5 GB RWO volume with 2 replicas
    And Attach volume to the 3rd node
    When Write data into mount point
    And Restart Kubelet on the node ${volunme_attached_node}
    Then 
    And Check data is intact
    
RWO volume with no replica on attached node, and restart Kubelet on the non volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create 5 GB RWO volume with 2 replicas
    And Attach volume to the 3rd node
    When Write data into mount point
    And Restart Kubelet on the node ${non_volunme_attached_node}
    Then 
    And Check data is intact
    
##
RWO volume with replica on attached node, and Power off the node ${volunme_attached_node}
# Recover: After restart the node, volume should be detached and replica is failed. Need manual to do reattached.
    Given Create ${volume_size} GB RWO volume with 3 replicas
    And Attach volume to the node
    When Write data into mount point
    And Power off the node ${volunme_attached_node}
    Then Node state should be 'Down'
    And Volume state should be 'Unknown'
    And Engine state should be 'unknown'
    And Replica on the node ${volunme_attached_node} state should be 'unknown'
    And Check data is intact
    
RWO volume with replica on attached node, and Power off the node ${non_volunme_attached_node}
# Recover: After restart the node, delete the stopped replica, and re-update the replica count to do rebuilding
    Given Create ${volume_size} GB RWO volume with 3 replicas
    And Attach volume to the node
    When Write data into mount point
    And Power off the node ${non_volunme_attached_node}
    Then Node state should be 'Down'
    And Volume is still 'Degraded'
    And Replica on the node ${non_volunme_attached_node} should be 'stopped'
    And Check data is intact
    
RWO volume with replica on attached node, and Reboot the node ${volunme_attached_node}
# Recover: After the reboot node recover, volume should be Healthy through Unknown and the replicas and engines are running
    Given Create ${volume_size} GB RWO volume with 3 replicas
    And Attach volume to the node
    When Write data into mount point
    And Reboot the node ${volunme_attached_node}
    Then Node state should be 'Down'
    And Volume final state is 'Healthy'
    And Engine final state is 'Running'
    And All replicas are 'Running'
    And Check data is intact
    
RWO volume with replica on attached node, and Reboot the node ${non_volunme_attached_node}
# Recover: After the reboot node recover, volume should be Healthy through Degraded and the replicas and engines are running
    Given Create ${volume_size} GB RWO volume with 3 replicas
    And Attach volume to the node
    When Write data into mount point
    And Reboot the node ${non_volunme_attached_node}
    Then Node state should be 'Down'
    And Volume final state is 'Healthy'
    And Engine final state is 'Running'
    And All replicas are 'Running'
    And Check data is intact
    
RWO volume with replica on attached node, and Restart Kubelet on the node ${volunme_attached_node}
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size} GB RWO volume with 3 replicas
    And Attach volume to the node
    When Write data into mount point
    And Restart Kubelet on the node ${volunme_attached_node}
    Then Volume final state is 'Healthy'
    And Engine final state is 'Running'
    And All replicas are 'Running'
    And Check data is intact
    
RWO volume with replica on attached node, and restart Kubelet on the non volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size} GB RWO volume with 3 replicas
    And Attach volume to the node
    When Write data into mount point
    And Restart Kubelet on the node ${non_volunme_attached_node}
    Then Volume final state is 'Healthy'
    And Engine final state is 'Running'
    And All replicas are 'Running'
    And Check data is intact
    
RWO volume with replica on attached node, and Power off the node ${volunme_attached_node}
# Recover: After restart the node, volume should be detached and replica is failed. Need manual to do reattached.
    Given Create ${volume_size} GB RWO volume with 3 replicas
    And Attach volume to the node
    When Write data into mount point
    And Power off the node ${volunme_attached_node}
    Then Node state should be 'Down'
    And Volume state should be 'Unknown'
    And Engine state should be 'unknown'
    And Replica on the node ${volunme_attached_node} state should be 'unknown'
    And Check data is intact
    
RWO volume with replica on attached node, and Power off the node ${non_volunme_attached_node}
# Recover: After restart the node, delete the stopped replica, and re-update the replica count to do rebuilding
    Given Create ${volume_size} GB RWO volume with 3 replicas
    And Attach volume to the node
    When Write data into mount point
    And Power off the node ${non_volunme_attached_node}
    Then Node state should be 'Down'
    And Volume is still 'Degraded'
    And Replica on the node ${non_volunme_attached_node} should be 'stopped'
    And Check data is intact
    
RWO volume with replica on attached node, and Reboot the node ${volunme_attached_node}
# Recover: After the reboot node recover, volume should be Healthy through Unknown and the replicas and engines are running
    Given Create ${volume_size} GB RWO volume with 3 replicas
    And Attach volume to the node
    When Write data into mount point
    And Reboot the node ${volunme_attached_node}
    Then Node state should be 'Down'
    And Volume final state is 'Healthy'
    And Engine final state is 'Running'
    And All replicas are 'Running'
    And Check data is intact
    
RWO volume with replica on attached node, and Reboot the node ${non_volunme_attached_node}
# Recover: After the reboot node recover, volume should be Healthy through Degraded and the replicas and engines are running
    Given Create ${volume_size} GB RWO volume with 3 replicas
    And Attach volume to the node
    When Write data into mount point
    And Reboot the node ${non_volunme_attached_node}
    Then Node state should be 'Down'
    And Volume final state is 'Healthy'
    And Engine final state is 'Running'
    And All replicas are 'Running'
    And Check data is intact
    
RWO volume with replica on attached node, and Restart Kubelet on the node ${volunme_attached_node}
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size} GB RWO volume with 3 replicas
    And Attach volume to the node
    When Write data into mount point
    And Restart Kubelet on the node ${volunme_attached_node}
    Then Volume final state is 'Healthy'
    And Engine final state is 'Running'
    And All replicas are 'Running'
    And Check data is intact
    
RWO volume with replica on attached node, and restart Kubelet on the non volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size} GB RWO volume with 3 replicas
    And Attach volume to the node
    When Write data into mount point
    And Restart Kubelet on the node ${non_volunme_attached_node}
    Then Volume final state is 'Healthy'
    And Engine final state is 'Running'
    And All replicas are 'Running'
    And Check data is intact
    
######
RWO volume with no replica on attached node, and Power off the node ${volunme_attached_node}
# Recover: After restart the node, volume should be detached and replica is failed. Need manual to do reattached.
    Given Create 5 GB RWO volume with 2 replicas
    And Attach volume to the 3rd node
    When Write data into mount point
    And Power off the node ${volunme_attached_node}
    Then 
    And Check data is intact
    
RWO volume with no replica on attached node, and Power off the node ${non_volunme_attached_node}
# Recover: After restart the node, delete the stopped replica, and re-update the replica count to do rebuilding
    Given Create 5 GB RWO volume with 2 replicas
    And Attach volume to the 3rd node
    When Write data into mount point
    And Power off the node ${non_volunme_attached_node}
    Then 
    And Check data is intact
    
RWO volume with no replica on attached node, and Reboot the node ${volunme_attached_node}
# Recover: After the reboot node recover, volume should be Healthy through Unknown and the replicas and engines are running
    Given Create 5 GB RWO volume with 2 replicas
    And Attach volume to the 3rd node
    When Write data into mount point
    And Reboot the node ${volunme_attached_node}
    Then 
    And Check data is intact
    
RWO volume with no replica on attached node, and Reboot the node ${non_volunme_attached_node}
# Recover: After the reboot node recover, volume should be Healthy through Degraded and the replicas and engines are running
    Given Create 5 GB RWO volume with 2 replicas
    And Attach volume to the 3rd node
    When Write data into mount point
    And Reboot the node ${non_volunme_attached_node}
    Then 
    And Check data is intact
    
RWO volume with no replica on attached node, and Restart Kubelet on the node ${volunme_attached_node}
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create 5 GB RWO volume with 2 replicas
    And Attach volume to the 3rd node
    When Write data into mount point
    And Restart Kubelet on the node ${volunme_attached_node}
    Then 
    And Check data is intact
    
RWO volume with no replica on attached node, and restart Kubelet on the non volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create 5 GB RWO volume with 2 replicas
    And Attach volume to the 3rd node
    When Write data into mount point
    And Restart Kubelet on the node ${non_volunme_attached_node}
    Then 
    And Check data is intact
    
RWO volume with no replica on attached node, and Power off the node ${volunme_attached_node}
# Recover: After restart the node, volume should be detached and replica is failed. Need manual to do reattached.
    Given Create 5 GB RWO volume with 2 replicas
    And Attach volume to the 3rd node
    When Write data into mount point
    And Power off the node ${volunme_attached_node}
    Then 
    And Check data is intact
    
RWO volume with no replica on attached node, and Power off the node ${non_volunme_attached_node}
# Recover: After restart the node, delete the stopped replica, and re-update the replica count to do rebuilding
    Given Create 5 GB RWO volume with 2 replicas
    And Attach volume to the 3rd node
    When Write data into mount point
    And Power off the node ${non_volunme_attached_node}
    Then 
    And Check data is intact
    
RWO volume with no replica on attached node, and Reboot the node ${volunme_attached_node}
# Recover: After the reboot node recover, volume should be Healthy through Unknown and the replicas and engines are running
    Given Create 5 GB RWO volume with 2 replicas
    And Attach volume to the 3rd node
    When Write data into mount point
    And Reboot the node ${volunme_attached_node}
    Then 
    And Check data is intact
    
RWO volume with no replica on attached node, and Reboot the node ${non_volunme_attached_node}
# Recover: After the reboot node recover, volume should be Healthy through Degraded and the replicas and engines are running
    Given Create 5 GB RWO volume with 2 replicas
    And Attach volume to the 3rd node
    When Write data into mount point
    And Reboot the node ${non_volunme_attached_node}
    Then 
    And Check data is intact
    
RWO volume with no replica on attached node, and Restart Kubelet on the node ${volunme_attached_node}
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create 5 GB RWO volume with 2 replicas
    And Attach volume to the 3rd node
    When Write data into mount point
    And Restart Kubelet on the node ${volunme_attached_node}
    Then 
    And Check data is intact
    
RWO volume with no replica on attached node, and restart Kubelet on the non volume-attached node
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create 5 GB RWO volume with 2 replicas
    And Attach volume to the 3rd node
    When Write data into mount point
    And Restart Kubelet on the node ${non_volunme_attached_node}
    Then 
    And Check data is intact
    
# Node abnormal exceeds the timeout for evicting the pod
RWO volume with replica on attached node, and powering off the volume-attached node exceeds the timeout for evicting the pod
# Recover: After restart the node, volume should be detached and replica is failed. Need manual to do reattached.
    Given Create ${volume_size} GB RWO volume with 3 replicas
    And Attach volume to the node
    When Write data into mount point
    And Powering off the node ${volunme_attached_node} exceeds the timeout for evicting the pod
    Then Node state should be 'Down'
    And Volume state should be 'Unknown'
    And Engine state should be 'unknown'
    And Replica on the node ${volunme_attached_node} state should be 'unknown'
    And Check data is intact
    
RWO volume with replica on attached node, and powering off the non volume-attached node exceeds the timeout for evicting the pod
# Recover: After restart the node, delete the stopped replica, and re-update the replica count to do rebuilding
    Given Create ${volume_size} GB RWO volume with 3 replicas
    And Attach volume to the node
    When Write data into mount point
    And Powering off the node ${non_volunme_attached_node} exceeds the timeout for evicting the pod
    Then Node state should be 'Down'
    And Volume is still 'Degraded'
    And Replica on the node ${non_volunme_attached_node} should be 'stopped'
    And Check data is intact
    
RWO volume with replica on attached node, and Reboot the node ${volunme_attached_node} exceeds the timeout for evicting the pod
# Recover: After the reboot node recover, volume should be Healthy through Unknown and the replicas and engines are running
    Given Create ${volume_size} GB RWO volume with 3 replicas
    And Attach volume to the node
    When Write data into mount point
    And Reboot the node ${volunme_attached_node} exceeds the timeout for evicting the pod
    Then Node state should be 'Down'
    And Volume final state is 'Healthy'
    And Engine final state is 'Running'
    And All replicas are 'Running'
    And Check data is intact
    
RWO volume with replica on attached node, and Reboot the node ${non_volunme_attached_node} exceeds the timeout for evicting the pod
# Recover: After the reboot node recover, volume should be Healthy through Degraded and the replicas and engines are running
    Given Create ${volume_size} GB RWO volume with 3 replicas
    And Attach volume to the node
    When Write data into mount point
    And Reboot the node ${non_volunme_attached_node} exceeds the timeout for evicting the pod
    Then Node state should be 'Down'
    And Volume final state is 'Healthy'
    And Engine final state is 'Running'
    And All replicas are 'Running'
    And Check data is intact
    
RWO volume with replica on attached node, and Restart Kubelet on the node ${volunme_attached_node} exceeds the timeout for evicting the pod
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size} GB RWO volume with 3 replicas
    And Attach volume to the node
    When Write data into mount point
    And Restart Kubelet on the node ${volunme_attached_node} exceeds the timeout for evicting the pod
    Then Volume final state is 'Healthy'
    And Engine final state is 'Running'
    And All replicas are 'Running'
    And Check data is intact
    
RWO volume with replica on attached node, and restart Kubelet on the non volume-attached node exceeds the timeout for evicting the pod
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size} GB RWO volume with 3 replicas
    And Attach volume to the node
    When Write data into mount point
    And Restart Kubelet on the node ${non_volunme_attached_node} exceeds the timeout for evicting the pod
    Then Volume final state is 'Healthy'
    And Engine final state is 'Running'
    And All replicas are 'Running'
    And Check data is intact
    
RWO volume with replica on attached node, and Power off the node ${volunme_attached_node} exceeds the timeout for evicting the pod
# Recover: After restart the node, volume should be detached and replica is failed. Need manual to do reattached.
    Given Create ${volume_size} GB RWO volume with 3 replicas
    And Attach volume to the node
    When Write data into mount point
    And Power off the node ${volunme_attached_node} exceeds the timeout for evicting the pod
    Then Node state should be 'Down'
    And Volume state should be 'Unknown'
    And Engine state should be 'unknown'
    And Replica on the node ${volunme_attached_node} state should be 'unknown'
    And Check data is intact
    
RWO volume with replica on attached node, and Power off the node ${non_volunme_attached_node} exceeds the timeout for evicting the pod
# Recover: After restart the node, delete the stopped replica, and re-update the replica count to do rebuilding
    Given Create ${volume_size} GB RWO volume with 3 replicas
    And Attach volume to the node
    When Write data into mount point
    And Power off the node ${non_volunme_attached_node} exceeds the timeout for evicting the pod
    Then Node state should be 'Down'
    And Volume is still 'Degraded'
    And Replica on the node ${non_volunme_attached_node} should be 'stopped'
    And Check data is intact
    
RWO volume with replica on attached node, and then Reboot the node ${volunme_attached_node} exceeds the timeout for evicting the pod
# Recover: After the reboot node recover, volume should be Healthy through Unknown and the replicas and engines are running
    Given Create ${volume_size} GB RWO volume with 3 replicas
    And Attach volume to the node
    When Write data into mount point
    And Reboot the node ${volunme_attached_node} exceeds the timeout for evicting the pod
    Then Node state should be 'Down'
    And Volume final state is 'Healthy'
    And Engine final state is 'Running'
    And All replicas are 'Running'
    And Check data is intact

RWO volume with replica on attached node, and Reboot the node ${non_volunme_attached_node} exceeds the timeout for evicting the pod
# Recover: After the reboot node recover, volume should be Healthy through Degraded and the replicas and engines are running
    Given Create ${volume_size} GB RWO volume with 3 replicas
    And Attach volume to the node
    When Write data into mount point
    And Reboot the node ${non_volunme_attached_node} exceeds the timeout for evicting the pod
    Then Node state should be 'Down'
    And Volume final state is 'Healthy'
    And Engine final state is 'Running'
    And All replicas are 'Running'
    And Check data is intact

RWO volume with replica on attached node, and Restart Kubelet on the node ${volunme_attached_node} exceeds the timeout for evicting the pod
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size} GB RWO volume with 3 replicas
    And Attach volume to the node
    When Write data into mount point
    And Restart Kubelet on the node ${volunme_attached_node} exceeds the timeout for evicting the pod
    Then Volume final state is 'Healthy'
    And Engine final state is 'Running'
    And All replicas are 'Running'
    And Check data is intact

RWO volume with replica on attached node, and restart Kubelet on the non volume-attached node exceeds the timeout for evicting the pod
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create ${volume_size} GB RWO volume with 3 replicas
    And Attach volume to the node
    When Write data into mount point
    And Restart Kubelet on the node ${non_volunme_attached_node} exceeds the timeout for evicting the pod
    Then Volume final state is 'Healthy'
    And Engine final state is 'Running'
    And All replicas are 'Running'
    And Check data is intact

######
RWO volume with no replica on attached node, and Power off the node ${volunme_attached_node} exceeds the timeout for evicting the pod
# Recover: After restart the node, volume should be detached and replica is failed. Need manual to do reattached.
    Given Create 5 GB RWO volume with 2 replicas
    And Attach volume to the 3rd node
    When Write data into mount point exceeds the timeout for evicting the pod
    And Power off the node ${volunme_attached_node}
    Then 
    And Check data is intact

RWO volume with no replica on attached node, and Power off the node ${non_volunme_attached_node} exceeds the timeout for evicting the pod
# Recover: After restart the node, delete the stopped replica, and re-update the replica count to do rebuilding
    Given Create 5 GB RWO volume with 2 replicas
    And Attach volume to the 3rd node
    When Write data into mount point
    And Power off the node ${non_volunme_attached_node} exceeds the timeout for evicting the pod
    Then 
    And Check data is intact

RWO volume with no replica on attached node, and Reboot the node ${volunme_attached_node} exceeds the timeout for evicting the pod
# Recover: After the reboot node recover, volume should be Healthy through Unknown and the replicas and engines are running
    Given Create 5 GB RWO volume with 2 replicas
    And Attach volume to the 3rd node
    When Write data into mount point
    And Reboot the node ${volunme_attached_node} exceeds the timeout for evicting the pod
    Then 
    And Check data is intact

RWO volume with no replica on attached node, and Reboot the node ${non_volunme_attached_node} exceeds the timeout for evicting the pod
# Recover: After the reboot node recover, volume should be Healthy through Degraded and the replicas and engines are running
    Given Create 5 GB RWO volume with 2 replicas
    And Attach volume to the 3rd node
    When Write data into mount point
    And Reboot the node ${non_volunme_attached_node} exceeds the timeout for evicting the pod
    Then 
    And Check data is intact

RWO volume with no replica on attached node, and Restart Kubelet on the node ${volunme_attached_node} exceeds the timeout for evicting the pod
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create 5 GB RWO volume with 2 replicas
    And Attach volume to the 3rd node
    When Write data into mount point
    And Restart Kubelet on the node ${volunme_attached_node} exceeds the timeout for evicting the pod
    Then 
    And Check data is intact

RWO volume with no replica on attached node, and restart Kubelet on the non volume-attached node exceeds the timeout for evicting the pod
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create 5 GB RWO volume with 2 replicas
    And Attach volume to the 3rd node
    When Write data into mount point
    And Restart Kubelet on the node ${non_volunme_attached_node} exceeds the timeout for evicting the pod
    Then 

RWO volume with no replica on attached node, and Power off the node ${volunme_attached_node} exceeds the timeout for evicting the pod
# Recover: After restart the node, volume should be detached and replica is failed. Need manual to do reattached.
    Given Create 5 GB RWO volume with 2 replicas
    And Attach volume to the 3rd node
    When Write data into mount point
    And Power off the node ${volunme_attached_node} exceeds the timeout for evicting the pod
    Then 
    And Check data is intact

RWO volume with no replica on attached node, and Power off the node ${non_volunme_attached_node} exceeds the timeout for evicting the pod
# Recover: After restart the node, delete the stopped replica, and re-update the replica count to do rebuilding
    Given Create 5 GB RWO volume with 2 replicas
    And Attach volume to the 3rd node
    When Write data into mount point
    And Power off the node ${non_volunme_attached_node} exceeds the timeout for evicting the pod
    Then 
    And Check data is intact

RWO volume with no replica on attached node, and Reboot the node ${volunme_attached_node} exceeds the timeout for evicting the pod
# Recover: After the reboot node recover, volume should be Healthy through Unknown and the replicas and engines are running
    Given Create 5 GB RWO volume with 2 replicas
    And Attach volume to the 3rd node
    When Write data into mount point
    And Reboot the node ${volunme_attached_node} exceeds the timeout for evicting the pod
    Then 
    And Check data is intact

RWO volume with no replica on attached node, and Reboot the node ${non_volunme_attached_node} exceeds the timeout for evicting the pod
# Recover: After the reboot node recover, volume should be Healthy through Degraded and the replicas and engines are running
    Given Create 5 GB RWO volume with 2 replicas
    And Attach volume to the 3rd node
    When Write data into mount point
    And Reboot the node ${non_volunme_attached_node} exceeds the timeout for evicting the pod
    Then 
    And Check data is intact

RWO volume with no replica on attached node, and Restart Kubelet on the node ${volunme_attached_node} exceeds the timeout for evicting the pod
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create 5 GB RWO volume with 2 replicas
    And Attach volume to the 3rd node
    When Write data into mount point
    And Restart Kubelet on the node ${volunme_attached_node} exceeds the timeout for evicting the pod
    Then 
    And Check data is intact

RWO volume with no replica on attached node, and restart Kubelet on the non volume-attached node exceeds the timeout for evicting the pod
# Restart kubelet: RKE1: 'sudo docker restart kubelet' RKE2: 'systemctl restart rke2-agent.service'
# Recover:
    Given Create 5 GB RWO volume with 2 replicas
    And Attach volume to the 3rd node
    When Write data into mount point
    And Restart Kubelet on the node ${non_volunme_attached_node} exceeds the timeout for evicting the pod
    Then 
    And Check data is intact    