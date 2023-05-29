*** Settings ***
Documentation   
...               Keywords defined here can be used where this Keywords.resource in loaded.
Library    ../libs/steps.py


*** Keywords ***
Volume state should be ${expected_volume_state}
    ${volume_current_state} =   get_volume_state   ${volume_name}
    Should Be Equal    ${volume_current_state}    ${expected_volume_state}
