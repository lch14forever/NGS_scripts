# Run lofreq to call variance and evaluate the results
# To run this: 
# ./run-lofreq.sh normal.bam tumor.bam method[bwa etc]

#REF=/projects/wilma/SOMATIC/dream-challenge/refseq/Homo_sapiens_assembly19.fasta
REF=/mnt/pnsg10_projects/wilma/lofreq/somatic/dream-challenge/refseq/Homo_sapiens_assembly19.fasta
LOFREQ_DIR=~wilma/local/testinstall/lofreq_star-2.0-RC2-63-g951e435/bin/
#DBSNP=/projects/wilma/SOMATIC/dream-challenge/refseq/dbsnp/00-All.no-indels-and-extras.vcf.gz
DBSNP=/mnt/pnsg10_projects/wilma/lofreq/somatic/dream-challenge/refseq/dbsnp/00-All.vcf.gz
REGION=~lich/ref/UCSC_RepeatMasked_hg19.bed

NORMAL_SAMPLE=$1
TUMOR_SAMPLE=$2
OUTPUT_PREFIX=$3


# run lofreq
$LOFREQ_DIR/lofreq somatic -f $REF \
    -n $NORMAL_SAMPLE -t $TUMOR_SAMPLE -o $OUTPUT_PREFIX \
    --threads 8 -d $DBSNP #-l $REGION 
