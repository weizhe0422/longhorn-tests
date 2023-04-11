#!/bin/bash

specific_test_case=$1

#robot -L debug negative.robot
if [ -z "${specific_test_case}" ]; then
    robot -L debug ./Node_NotReady/TestCases.robot
else
    echo "Run specific test case: " ${specific_test_case}
    robot -L debug -t ${specific_test_case} ./Node_NotReady/TestCases.robot
fi
#robot negative.robot
