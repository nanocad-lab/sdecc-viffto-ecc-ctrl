#!/bin/bash

BINARY_LOCATION=$MWG_GIT_PATH/eccgrp-ecc-ctrl
ISA=rv64g
N=144
K=128
ORIGINAL_MESSAGE=$1
ERROR_PATTERN=111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
CODE_TYPE=kaneda1982
POLICY=filter-frequency-sort-pick-longest-pad
MNEMONIC_HOTNESS_FILENAME=$MWG_DATA_PATH/swd_ecc_data/rv64g/program-statistics/static/rv64g-mnemonic-hotness-export.csv
RD_HOTNESS_FILENAME=$MWG_DATA_PATH/swd_ecc_data/rv64g/program-statistics/static/rv64g-rd-hotness-export.csv
VERBOSE=0

if [[ "$MWG_MACHINE_NAME" == "hoffman" ]]; then
    MY_PRELOAD=$GCC5/lib64/libstdc++.so.6
elif [[ "$MWG_MACHINE_NAME" == "nanocad-server-testbed" ]]; then
    MY_PRELOAD=/usr/lib/x86_64-linux-gnu/libstdc++.so.6
fi
   
LD_PRELOAD=$MY_PRELOAD LD_LIBRARY_PATH=$MCRROOT/bin/glnxa64:$MCRROOT/runtime/glnxa64:$LD_LIBRARY_PATH $BINARY_LOCATION/inst_recovery $ISA $N $K $ORIGINAL_MESSAGE $ERROR_PATTERN $CODE_TYPE $POLICY $MNEMONIC_HOTNESS_FILENAME $RD_HOTNESS_FILENAME $VERBOSE
