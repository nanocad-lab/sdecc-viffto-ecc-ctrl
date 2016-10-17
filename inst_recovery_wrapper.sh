#!/bin/bash

BINARY_LOCATION=$1
ISA=$2
N=$3
K=$4
ORIGINAL_MESSAGE=$5
ERROR_PATTERN=$6
CODE_TYPE=$7
POLICY=$8
MNEMONIC_HOTNESS_FILENAME=${9}
RD_HOTNESS_FILENAME=${10}
VERBOSE=${11}

if [[ "$MWG_MACHINE_NAME" == "hoffman" ]]; then
    MY_PRELOAD=$GCC5/lib64/libstdc++.so.6
elif [[ "$MWG_MACHINE_NAME" == "nanocad-server-testbed" ]]; then
    MY_PRELOAD=/usr/lib/x86_64-linux-gnu/libstdc++.so.6
fi

echo "THIS SCRIPT IS BROKEN! We currently do not have an easy way to pass in INSTRUCTION_MNEMONIC_HOTNESS and INSTRUCTION_RD_HOTNESS 2D cell array data structures. FIXME and TODO later for Spike-driven evaluations..."
exit 1

LD_PRELOAD=$MY_PRELOAD LD_LIBRARY_PATH=$MCRROOT/bin/glnxa64:$MCRROOT/runtime/glnxa64:$LD_LIBRARY_PATH $BINARY_LOCATION/inst_recovery $ISA $N $K $ORIGINAL_MESSAGE $ERROR_PATTERN $CODE_TYPE $POLICY $MNEMONIC_HOTNESS_FILENAME $RD_HOTNESS_FILENAME $VERBOSE
