#!/bin/bash

BINARY_LOCATION=$1
ISA=$2
BENCHMARK=$3
N=$4
K=$5
NUM_MESSAGES=$6
NUM_SAMPLED_ERROR_PATTERNS=$7
WORDS_PER_BLOCK=$8
INPUT_FILE=$9
OUTPUT_FILE=${10}
NUM_THREADS=${11}
CODE_TYPE=${12}
POLICY=${13}
MNEMONIC_HOTNESS_FILENAME=${14}
RD_HOTNESS_FILENAME=${15}
CRASH_THRESHOLD=${16}
VERBOSE_RECOVERY=${17}
FILE_VERSION=${18}
HASH_MODE=${19}

if [[ "$MWG_MACHINE_NAME" == "hoffman" ]]; then
    MY_PRELOAD=$GCC5/lib64/libstdc++.so.6
elif [[ "$MWG_MACHINE_NAME" == "nanocad-server-testbed" ]]; then
    MY_PRELOAD=/usr/lib/x86_64-linux-gnu/libstdc++.so.6
elif [[ "$MWG_MACHINE_NAME" == "dfm" ]]; then
    MY_PRELOAD=/app/apps.icsl/puneet/tools/gcc-5.4.0/lib64/libstdc++.so.6
elif [[ "$MWG_MACHINE_NAME" == "mwg-desktop-ubuntuvm" ]]; then
    MY_PRELOAD=/usr/lib/x86_64-linux-gnu/libstdc++.so.6
fi

LD_PRELOAD=$MY_PRELOAD LD_LIBRARY_PATH=$MCRROOT/bin/glnxa64:$MCRROOT/runtime/glnxa64:$LD_LIBRARY_PATH $BINARY_LOCATION/swd_ecc_offline_inst_heuristic_recovery $ISA $BENCHMARK $N $K $NUM_MESSAGES $NUM_SAMPLED_ERROR_PATTERNS $WORDS_PER_BLOCK $INPUT_FILE $OUTPUT_FILE $NUM_THREADS $CODE_TYPE $POLICY $MNEMONIC_HOTNESS_FILENAME $RD_HOTNESS_FILENAME $CRASH_THRESHOLD $VERBOSE_RECOVERY $FILE_VERSION $HASH_MODE
