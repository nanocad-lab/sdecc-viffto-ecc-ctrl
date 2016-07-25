#!/bin/bash

BINARY_LOCATION=$1
ISA=$2
BENCHMARK=$3
N=$4
K=$5
NUM_INST=$6
INPUT_FILE=$7
OUTPUT_FILE=$8
NUM_THREADS=$9
CODE_TYPE=${10}
POLICY=${11}
TIEBREAK_POLICY=${12}

# Library paths are for running on Hoffman2
LD_PRELOAD=$GCC5/lib64/libstdc++.so.6 LD_LIBRARY_PATH=$MATLAB/bin/glnxa64:$MATLAB/runtime/glnxa64:$LD_LIBRARY_PATH $BINARY_LOCATION/swd_ecc_inst_heuristic_recovery $ISA $BENCHMARK $N $K $NUM_INST $INPUT_FILE $OUTPUT_FILE $NUM_THREADS $CODE_TYPE $POLICY $TIEBREAK_POLICY
