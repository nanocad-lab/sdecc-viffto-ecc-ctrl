#!/bin/bash
#
# Author: Mark Gottscho
# Email: mgottscho@ucla.edu

INPUT_FILE=$1
OUTPUT_FILE=$2
grep "D\$ WR to MEM" $INPUT_FILE > $OUTPUT_FILE