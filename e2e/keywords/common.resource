*** Settings ***
Documentation
...               Keywords defined here can be used where this Keywords.resource in loaded.
Library    ../libs/steps.py

Resource    ../keywords/node.resource
Resource    ../keywords/volume.resource
Resource    ../keywords/replica.resource
Resource    ../keywords/engine.resource

*** Variable ***
${retry_timeout_second}=    600
${retry_interval}=    5

*** Keywords ***
Data should be intact
    Run keyword And Continue On Failure    Wait Until Keyword Succeeds    ${retry_timeout_second} seconds    ${retry_interval} seconds    Volume ${volume_name} data checksum should be ${volume_data_checksum}

Sleep ${POD_EVICTION_TIME_OUT} seconds
    wait_with_time_interval    ${POD_EVICTION_TIME_OUT}

Update the ${setting_name} setting to ${setting_value}
    update_setting_custom_resource   ${setting_name}   ${setting_value}

Teardown
    cleanup_resources
    Run Keyword If Test Failed    generate_support_bundle    ${TEST NAME}
