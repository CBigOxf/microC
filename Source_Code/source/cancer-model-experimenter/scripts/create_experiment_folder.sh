#!/bin/bash

# add default files to experiment folder

# $1 is the experiment folder name

cd /data/donc-onconet/share/cancer

mkdir $1

cp mutations.txt           $1
cp input-parameters.txt    $1
cp diffusion-parameters.txt $1
cp associations.txt        $1
cp parameters.txt          $1
cp regulatoryGraph.html    $1



#cp regulatoryGraph.html /data/donc-onconet/share/cancer/process-rules
#cd /data/donc-onconet/share/cancer/process-rules
#/panfs/pan01/system/software/linux-x86_64/matlab/R2015b/bin/matlab -r simplify_rule
#cp regulatoryGraphProcessed.html /data/donc-onconet/share/cancer/$1
#rm regulatoryGraphProcessed.html
#rm regulatoryGraph.html
#cd /data/donc-onconet/share/cancer/