#!/bin/bash

# creates an HTML page from the logs of each replicate
# $1 is the unique name of the experiment
# $2 is the number of batches (16 replicates each) to run

if [ -f /tmp/$1.log ] ; then
  # already finished 
  exit 0
fi

if [ ! -f ../cancer-outputs/$1.html ] ; then
  # create empty results page
  cat prefix.html postfix.html > ../cancer-outputs/$1.html
fi

log_count=$(ls $1/*/slurm-*.out | wc -l)

count=$(ls $1/*/16_runs.txt | wc -l)

if [ $log_count -gt 0 ] ; then
  echo "No errors have been encountered so far. " > /tmp/log_preface
  cat /tmp/log_preface $1/*/slurm-*.out > ../cancer-outputs/$1.log
  rm /tmp/log_preface
elif [ ! -f ../cancer-outputs/$1.log ] ; then
  # do this only if the log file has yet to be created
  echo "Job is still in the ARC job queue. Try again later." > ../cancer-outputs/$1.log
fi

if [ $count == 0 ] ; then
   # too early no results ready yet
   exit 0 
fi

cat prefix.html $1/*/16_runs.txt postfix.html > ../cancer-outputs/$1.html

echo "Job completed. See <a href='${2}batches-${1}.html'>results</a>." > ../cancer-outputs/$1.log

#if last one then delete temporary files

if [ $count -eq $2 ] ; then 
   # schedule the full clean up since a script can't remove itself without errors
   sbatch --partition=devel temp/clean_up_$1.sh $1
fi
