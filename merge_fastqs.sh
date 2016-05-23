#!/bin/bash

input=$1
out_prefix=$2

cat `ls $input/*R1*fastq | sort` | gzip - > $out_prefix.R1.fastq.gz
cat `ls $input/*R2*fastq | sort` | gzip - > $out_prefix.R2.fastq.gz

