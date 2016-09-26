#!/bin/bash

BINARY_LOCATION=$1
ISA=$2
BENCHMARK=$3
N=$4
K=$5
NUM_WORDS=$6
NUM_SAMPLED_ERROR_PATTERNS=$7
WORDS_PER_BLOCK=$8
INPUT_FILE=$9
OUTPUT_FILE=${10}
NUM_THREADS=${11}
CODE_TYPE=${12}
POLICY=${13}
VERBOSE_RECOVERY=${14}

if [[ "$MWG_MACHINE_NAME" == "hoffman" ]]; then
    MY_PRELOAD=$GCC5/lib64/libstdc++.so.6
elif [[ "$MWG_MACHINE_NAME" == "nanocad-server-testbed" ]]; then
    MY_PRELOAD=/usr/lib/x86_64-linux-gnu/libstdc++.so.6
elif [[ "$MWG_MACHINE_NAME" == "dfm" ]]; then
    MY_PRELOAD=/usr/lib64/libstdc++.so.6 # Not working as of 9/26/2016
fi

LD_PRELOAD=$MY_PRELOAD LD_LIBRARY_PATH=$MCRROOT/bin/glnxa64:$MCRROOT/runtime/glnxa64:$LD_LIBRARY_PATH $BINARY_LOCATION/swd_ecc_offline_data_heuristic_recovery $ISA $BENCHMARK $N $K $NUM_WORDS $NUM_SAMPLED_ERROR_PATTERNS $WORDS_PER_BLOCK $INPUT_FILE $OUTPUT_FILE $NUM_THREADS $CODE_TYPE $POLICY $VERBOSE_RECOVERY
