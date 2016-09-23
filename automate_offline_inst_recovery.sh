#!/bin/bash
#
# Author: Mark Gottscho
# mgottscho@ucla.edu

ARGC=$# # Get number of arguments excluding arg0 (the script itself). Check for help message condition.
if [[ "$ARGC" != 0 ]]; then # Bad number of arguments. 
	echo "Author: Mark Gottscho"
	echo "mgottscho@ucla.edu"
	echo ""
	echo "No arguments allowed."
	exit
fi

########################## FEEL FREE TO CHANGE THESE OPTIONS ##################################
ISA=rv64g    # Set the target ISA; benchmarks must be disassembled for this as well

INPUT_TYPE=static
MNEMONIC_HOTNESS_FILENAME=$MWG_DATA_PATH/swd_ecc_data/$ISA/program-statistics/$INPUT_TYPE/$ISA-mnemonic-hotness-export.csv
RD_HOTNESS_FILENAME=$MWG_DATA_PATH/swd_ecc_data/$ISA/program-statistics/$INPUT_TYPE/$ISA-rd-hotness-export.csv
if [[ "$INPUT_TYPE" == "static" ]]; then # Static evaluation
    SPEC_BENCHMARKS="400.perlbench 401.bzip2 403.gcc 410.bwaves 416.gamess 429.mcf 433.milc 434.zeusmp 435.gromacs 436.cactusADM 437.leslie3d 444.namd 445.gobmk 447.dealII 450.soplex 453.povray 454.calculix 456.hmmer 458.sjeng 459.GemsFDTD 462.libquantum 464.h264ref 465.tonto 470.lbm 471.omnetpp 473.astar 481.wrf 482.sphinx3 483.xalancbmk" # Static -- all are working
    INPUT_DIRECTORY=$MWG_DATA_PATH/swd_ecc_data/$ISA/disassembly/linux-gnu # For static
elif [[ "$INPUT_TYPE" == "dynamic-static-side-info" ]]; then # Dynamic evaluation with static side info
    SPEC_BENCHMARKS="400.perlbench 401.bzip2 403.gcc 410.bwaves 435.gromacs 436.cactusADM 444.namd 447.dealII 450.soplex 453.povray 454.calculix 456.hmmer 458.sjeng 459.GemsFDTD 462.libquantum 464.h264ref 465.tonto 470.lbm 471.omnetpp 473.astar" # Dynamic -- working
    INPUT_DIRECTORY=$MWG_DATA_PATH/swd_ecc_data/$ISA/spike # For dynamic
    MNEMONIC_HOTNESS_FILENAME=$MWG_DATA_PATH/swd_ecc_data/$ISA/program-statistics/static/$ISA-mnemonic-hotness-export.csv
    RD_HOTNESS_FILENAME=$MWG_DATA_PATH/swd_ecc_data/$ISA/program-statistics/static/$ISA-rd-hotness-export.csv
elif [[ "$INPUT_TYPE" == "dynamic" ]]; then # Dynamic
    SPEC_BENCHMARKS="400.perlbench 401.bzip2 403.gcc 410.bwaves 435.gromacs 436.cactusADM 444.namd 447.dealII 450.soplex 453.povray 454.calculix 456.hmmer 458.sjeng 459.GemsFDTD 462.libquantum 464.h264ref 465.tonto 470.lbm 471.omnetpp 473.astar" # Dynamic -- working
    INPUT_DIRECTORY=$MWG_DATA_PATH/swd_ecc_data/$ISA/spike # For dynamic
else
    echo "ERROR, bad INPUT_TYPE: $INPUT_TYPE"
    exit 1
fi

N=144
K=128
NUM_MESSAGES=1000
NUM_THREADS=$(cat /proc/cpuinfo | grep ^processor | wc -l ) 
CODE_TYPE=fujiwara1982
NUM_SAMPLED_ERROR_PATTERNS=1000
#NUM_SAMPLED_ERROR_PATTERNS=741 # Max for (39,32) SECDED
#NUM_SAMPLED_ERROR_PATTERNS=2556 # Max for (72,64) SECDED
#NUM_SAMPLED_ERROR_PATTERNS=14190 # Max for (45,32) DECTED
#NUM_SAMPLED_ERROR_PATTERNS=79079 # Max for (79,64) DECTED
#NUM_SAMPLED_ERROR_PATTERNS=141750 # Max for (144,128) ChipKill
POLICY=filter-frequency-sort-pick-longest-pad
VERBOSE_RECOVERY=0

OUTPUT_DIRECTORY=$MWG_DATA_PATH/swd_ecc_data/$ISA/inst-recovery/offline-$INPUT_TYPE/$CODE_TYPE/$POLICY

###############################################################################################

# Prepare directories
mkdir -p $OUTPUT_DIRECTORY

# Submit all the SPEC CPU2006 benchmarks
echo "Running..."
echo ""
for SPEC_BENCHMARK in $SPEC_BENCHMARKS; do
	echo "$SPEC_BENCHMARK..."
    if [[ "$INPUT_TYPE" == "static" ]]; then # Static evaluation
        INPUT_FILE="$INPUT_DIRECTORY/${ISA}-${SPEC_BENCHMARK}-instructions.txt" # For static analysis
    elif [[ "$INPUT_TYPE" == "dynamic" || "$INPUT_TYPE" == "dynamic-static-side-info" ]]; then 
        INPUT_FILE="$INPUT_DIRECTORY/spike_mem_data_trace_${SPEC_BENCHMARK}.txt.inst" # For dynamic analysis
    fi
    OUTPUT_FILE="$OUTPUT_DIRECTORY/${ISA}-${SPEC_BENCHMARK}-inst-heuristic-recovery.mat"
	./swd_ecc_offline_inst_heuristic_recovery_wrapper.sh $PWD $ISA $SPEC_BENCHMARK $N $K $NUM_MESSAGES $NUM_SAMPLED_ERROR_PATTERNS $INPUT_FILE $OUTPUT_FILE $NUM_THREADS $CODE_TYPE $POLICY $MNEMONIC_HOTNESS_FILENAME $RD_HOTNESS_FILENAME $VERBOSE_RECOVERY > $OUTPUT_DIRECTORY/${ISA}-${SPEC_BENCHMARK}-inst-heuristic-recovery.log 2>&1
done

echo "Done."
