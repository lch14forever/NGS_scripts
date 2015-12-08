# This script was not used.
# It was transformed into a bpipe pipeline

# Variables
SAMPLE_NORMAL=/projects/wilma/SOMATIC/dream-challenge/synthetic.challenge.set3/normal.bam
SAMPLE_TUMOR=/projects/wilma/SOMATIC/dream-challenge/synthetic.challenge.set3/tumor.bam

#-------------------------------------
# 1 extract chr19 & convert to fastqs
#-------------------------------------

samtools view -ubh $SAMPLE_NORMAL 19 | \
    htscmd bamshuf -uOn 128 - /tmp/htscmd.tmp | \
    htscmd bam2fq -a -O - | /home/wilma/local/src/compbio-utils-git/deinterleave_fastq.py - ~/tmp/synthetic.challenge.set3-normal-chr19

samtools view -ubh $SAMPLE_TUMOR 19 | \
    htscmd bamshuf -uOn 128 - /tmp/htscmd.tmp | \
    htscmd bam2fq -a -O - | /home/wilma/local/src/compbio-utils-git/deinterleave_fastq.py - ~/tmp/synthetic.challenge.set3-tumor-chr19
