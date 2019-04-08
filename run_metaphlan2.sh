#!/bin/bash

## $script $r1 $r2 $outprefix

/mnt/software/unstowable/biobakery-metaphlan2-26610e07f840/metaphlan2.py $1,$2 \
   --mpa_pkl /mnt/genomeDB/misc/softwareDB/metaphlan2/db_v20/mpa_v20_m200.pkl  \
   --bowtie2db /mnt/genomeDB/misc/softwareDB/metaphlan2/db_v20/mpa_v20_m200 \
   --bowtie2out $3.metaphlan2.bz2 -s $3.metaphlan2.sam.bz2 --nproc 8 --input_type 'multifastq' > $3.metaphlan2.tsv

