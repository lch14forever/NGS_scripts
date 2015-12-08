threads=8
JAVA_EXTRA_ARGS="-Xmx4g -XX:ParallelGCThreads=$threads"
GATK_DIR=//mnt/software/stow/GenomeAnalysisTK-2.7-2-g6bda569/bin/

gatk_jar=$GATK_DIR/GenomeAnalysisTK.jar
bam_in=$1
ref_fa=../ref/hg19.fa
recal=$1.mdups.realn_recal.csv

bam_out=${bam_in%.bam}.realn.recal.bam
vcf=../ref/dbsnp_138.hg19.vcf.gz

#cat <<EOF
java $JAVA_EXTRA_ARGS -jar $gatk_jar \
        -T BaseRecalibrator \
        -I $bam_in \
        -l INFO \
        -R $ref_fa \
        -nct $threads \
        -knownSites $vcf \
        -o $recal || exit 1

java $JAVA_EXTRA_ARGS -jar $gatk_jar \
    -T PrintReads \
    -I $bam_in \
    -l INFO \
    -R $ref_fa \
    -BQSR $recal \
    -o $bam_out || exit 1
#EOF
