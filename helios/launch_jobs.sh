
JOB_LAUNCHER=blizzard.pbs
NUM_DAYS=4
REPEATS=$((NUM_DAYS-1))

DICT_FILE=/scratch/jvb-000-aa/sotelo/code/pepper/helios/blizzard_dict.txt

NUM_CONFIG=$(wc -l < $DICT_FILE)
NUM_CONFIG=$((NUM_CONFIG+1))
echo "NUM CONFIG: $NUM_CONFIG"

for CONFIG_IDX in $(seq 1 $NUM_CONFIG)
do
    # Define configuration for sequence of experiments.
    export CONFIG_VARS=$(head -n $CONFIG_IDX $DICT_FILE | tail -n1)
    echo "NEW CONFIG: $CONFIG_VARS"
    export CONFIG_VARS=${CONFIG_VARS// /*_*}

    # Launch first job given CONFIG_VARS
    WAIT_FOR_JOB_ID=$(msub -v CONFIG_VARS $JOB_LAUNCHER 2>&1 | sed '/^$/d')
    
    # Prefix for all the sequence of jobs
    JOB_ID=$WAIT_FOR_JOB_ID
    echo "JOB NAME: $JOB_ID"

    for COUNTER in $(seq 1 $REPEATS)
    do
        export LOAD_FROM=$JOB_ID\_$COUNTER
        export JOB_NAME=$JOB_ID\_$((COUNTER+1))
        WAIT_FOR_JOB_ID=$(msub -l depend=afterany:$WAIT_FOR_JOB_ID -v CONFIG_VARS,LOAD_FROM,JOB_NAME $JOB_LAUNCHER 2>&1 | sed '/^$/d')
        echo "LAUNCHED: $WAIT_FOR_JOB_ID LOADING: $LOAD_FROM"
    done
    # Finish code to launch one job. This should be defined as function.
done