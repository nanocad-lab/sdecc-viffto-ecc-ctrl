#!/bin/bash

BINARY_LOCATION=$1
ISA=$2
BENCHMARK=$3
N=$4
K=$5
NUM_MESSAGES=$6
NUM_SAMPLED_ERROR_PATTERNS=$7
INPUT_FILE=$8
OUTPUT_FILE=$9
NUM_THREADS=${10}
CODE_TYPE=${11}
POLICY=${12}
MNEMONIC_HOTNESS_FILENAME=${13}
RD_HOTNESS_FILENAME=${14}
VERBOSE_RECOVERY=${15}

if [[ "$MWG_MACHINE_NAME" == "hoffman" ]]; then
    MY_PRELOAD=$GCC5/lib64/libstdc++.so.6
elif [[ "$MWG_MACHINE_NAME" == "nanocad-server-testbed" ]]; then
    MY_PRELOAD=/usr/lib/x86_64-linux-gnu/libstdc++.so.6
elif [[ "$MWG_MACHINE_NAME" == "dfm" ]]; then
    MY_PRELOAD=/usr/lib64/libstdc++.so.6 # Not working as of 9/26/2016
fi

LD_PRELOAD=$MY_PRELOAD LD_LIBRARY_PATH=$MCRROOT/bin/glnxa64:$MCRROOT/runtime/glnxa64:$LD_LIBRARY_PATH $BINARY_LOCATION/swd_ecc_offline_inst_heuristic_recovery $ISA $BENCHMARK $N $K $NUM_MESSAGES $NUM_SAMPLED_ERROR_PATTERNS $INPUT_FILE $OUTPUT_FILE $NUM_THREADS $CODE_TYPE $POLICY $MNEMONIC_HOTNESS_FILENAME $RD_HOTNESS_FILENAME $VERBOSE_RECOVERY
