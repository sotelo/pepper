#!/bin/bash
#PBS -l walltime=47:00:00
#PBS -l nodes=1:ppn=12
#PBS -t 1-24

echo "New job started."
echo $PBS_JOBID
echo $PBS_ARRAYID

cd $HOME/code

echo "Data path is:"
export FUEL_DATA_PATH=/lscratch/data

echo $FUEL_DATA_PATH

FILE=$FUEL_DATA_PATH/blizzard/raw_blizzard_80h.hdf5

if [ -f $FILE ];
then echo "File $FILE exists."
else
   echo "Copying file"
   mkdir $FUEL_DATA_PATH
   mkdir $FUEL_DATA_PATH/blizzard
   cp -v $SCRATCH/data/blizzard/* $FUEL_DATA_PATH/blizzard/
fi

echo "Finished copying file in:"
echo $FILE

# Change following line for name.
export RESULTS_DIR=/lscratch/data/
mkdir $RESULTS_DIR

python play/datasets/converters/blizzard_mgc_sentence.py $PBS_ARRAYID &> $SCRATCH/out_$PBS_ARRAYID.txt &
TRAINER_PID=$!

wait $TRAINER_PID

mv $RESULTS_DIR/blizzard/chunk_$PBS_ARRAYID\_sentence.hdf5 $SCRATCH/data/blizzard/
echo "Finished program."
