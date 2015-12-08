FQ1=$1
FQ2=$2
NUM=$3

paste <(zcat $FQ1) <(zcat $FQ2) | paste - - - - | shuf | head -n $NUM | awk -F'\t' '{OFS="\n"; print $1,$3,$5,$7 > "random.1.fq"; print $2,$4,$6,$8 > "random.2.fq"}'