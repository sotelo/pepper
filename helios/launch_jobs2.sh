
JOB_LAUNCHER=lyrebird.pbs
DICT_FILE=$SCRATCH/code/pepper/helios/lyrebird_dict.txt

NUM_CONFIG=$(wc -l < $DICT_FILE)
NUM_CONFIG=$((NUM_CONFIG+1))
echo "NUM CONFIG: $NUM_CONFIG"

for CONFIG_IDX in $(seq 1 $NUM_CONFIG)
do
    # Define configuration for sequence of experiments.
    export CONFIG_VARS=$(head -n $CONFIG_IDX $DICT_FILE | tail -n1)
    echo "NEW CONFIG: $CONFIG_VARS"

    # Launch first job given CONFIG_VARS
    msub -v CONFIG_VARS $JOB_LAUNCHER 
done