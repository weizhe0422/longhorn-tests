#!/bin/bash

specific_test_file=$1
specific_test_case=$2

echo ${specific_test_case}

#robot -L debug negative.robot
if [ -z "${specific_test_case}" ]; then
    robot -L debug ./node_not_ready/${specific_test_file}.robot
else
    echo "Run specific test case: " ${specific_test_case} "@" ./node_not_ready/${specific_test_file}.robot
    robot -L debug -t "${specific_test_case}" ./node_not_ready/${specific_test_file}.robot
fi
#robot negative.robot
