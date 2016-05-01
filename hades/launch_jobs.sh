
JOB_LAUNCHER=restart_handwriting.pbs
NUM_DAYS=3
REPEATS=$((NUM_DAYS-1))

DICT_FILE=/RQusagers/sotelo/code/pepper/hades/handwriting_dict.txt

NUM_CONFIG=$(wc -l < $DICT_FILE)

for CONFIG_IDX in $(seq 1 $NUM_CONFIG)
do
    export CONFIG_VARS=$(head -n $CONFIG_IDX $DICT_FILE | tail -n1)
    echo "NEW CONFIG: $CONFIG_VARS"

    # Code to launch one job, given CONFIG_VARS
    WAIT_FOR_JOB_ID=$(qsub -v CONFIG_VARS $JOB_LAUNCHER)
    JOB_NAME=$(cut -f1 -d"[" <<< $WAIT_FOR_JOB_ID)
    JOB_NAME=$(cut -f1 -d"." <<< $JOB_NAME)
    echo "JOB NAME: $JOB_NAME"

    for COUNTER in $(seq 1 $REPEATS)
    do
        WAIT_FOR_JOB_ID=$(qsub -W depend=afterok:$WAIT_FOR_JOB_ID -v CONFIG_VARS,LOAD_FROM=$JOB_NAME $JOB_LAUNCHER)
        JOB_NAME=$(cut -f1 -d"[" <<< $WAIT_FOR_JOB_ID)
        JOB_NAME=$(cut -f1 -d"." <<< $JOB_NAME)
        echo "JOB NAME: $JOB_NAME"
    done
    # Finish code to launch one job. This should be defined as function.
done