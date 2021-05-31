#!/bin/bash

# $1 is the unique name of the experiment
# $2 is the number of batches (48 replicates each) to run
# $3 3d (lower case)  or nothing (for 2D)

# set the number of nodes to 1
#SBATCH --nodes=1

# set number of processes 48 per node
#SBATCH --ntasks-per-node=48

# set max wall time to 10 minutes (to qualify for developer priority)
#SBATCH --time=00:09:00

# set the name of the job
#SBATCH --job-name=cancer_model

# start job from the directory it was submitted
cd $SLURM_SUBMIT_DIR

# load NetLogo
module load netlogo

bash ../../netlogo-headless$3.sh \
--model $SLURM_SUBMIT_DIR/cancer.nlogo$3 \
--setup-file $SLURM_SUBMIT_DIR/run_experiment.xml \
--experiment run-experiment \
--threads 48

cat log* > 48_runs.txt

cd ../..

bash make_html.sh $1 $2
