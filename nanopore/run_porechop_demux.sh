#!/bin/bash

set -e -o pipefail

input=$1
threads=${2:-4}

echo Running porechop with $threads theads...

bs=`basename $input`
bs=${bs%%.fastq.gz}
dir=`dirname $input`
demux_folder=${dir}/demux_$bs

PORECHOP=/mnt/software/unstowable/anaconda/envs/nanopore_py3/bin/porechop

$PORECHOP -i $input -b $demux_folder -t $threads -v 2 

echo Renaming output folders...

for i in ${demux_folder}/*fastq;
do
    bs_i=`basename $i`
    f=${dir}/${bs%%_*}_${bs_i%%.fastq}
    gzip $i
    mkdir $f
    mv $i.gz ${f}/${bs%%_*}_${bs_i}.gz
done
rmdir $demux_folder
