#!/bin/bash

specific_test_file=$1
specific_test_case=$2

#robot -L debug negative.robot
if [ -z "${specific_test_case}" ]; then
    robot -L debug ./Node_NotReady/restart_kubelet.robot
else
    echo "Run specific test case: " ${specific_test_case} "@" ./Node_NotReady/${specific_test_file}.robot
    robot -L debug -t ${specific_test_case} ./Node_NotReady/${specific_test_file}.robot
fi
#robot negative.robot
