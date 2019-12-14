#!/bin/bash

## Convert amphora peptide sequences back to DNA sequences
## Usage: amphoraPep2DNA.sh WORKING_DIR FASTA_SEQ [NAME_PREFIX]
## NAME_PREFIX will be the id of FASTA_SEQ by default

wd=$1
fa=$2
header=`head -n1 $fa | cut -f1 -d ' ' | sed 's/>//'`
bact=${3:-$header}

for i in $wd/*pep;
do
    bs=`basename $i`
    grep '>' $i | awk -v OFS="\t" '{print $2,$4,$5$6}'   | sed 's/\[//' | sed 's/\]//' | sed 's/(REVERSESENSE)/-/' | sed -E 's/[^0-9\t-]+/+/' | paste <(echo $bact) <(echo $bs |sed 's/.pep//') - | awk -v OFS="\t" '{if($3<$4) print $1,$2,$3,$4,$5; else print $1,$2,$4,$3,$5}'
done > $wd/regions.gtf

#seqkit subseq -r 1466717:1468516 sequence.fasta
while read n g s e d;
do
    seqkit subseq -r $s:$e $wd/$fa | tail -n+2 | cat <(echo \>${n}_$g\;$s\;$e\;$d) -
done<$wd/regions.gtf
