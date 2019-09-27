#!/bin/bash

## requirement:
## BWA, samtools >= 1.7

ref=$1
r1=$2
r2=$3
outprefix=$4
threads=${5:-4}

bwa mem -t ${threads} $ref $r1 $r2 | samtools fastq -f12 -F256  -1  ${outprefix}.r1.fastq.gz -2 ${outprefix}.r2.fastq.gz - 
