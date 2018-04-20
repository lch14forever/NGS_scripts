#!/bin/bash

REF=$1
READ=$2
OUT=$3

#/mnt/software/stow/bwa-0.7.12/bin/bwa mem -t 8 -x ont2d $REF $READ | samtools view -buS - | samtools sort -n - $OUT
/mnt/software/stow/bwa-0.7.12/bin/bwa mem -t 12 -x ont2d $REF $READ | samtools view -buS - | samtools sort -@4 - $OUT

