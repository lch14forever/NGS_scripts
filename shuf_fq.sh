FQ1=$1
FQ2=$2
NUM=$3
PREFIX=${4:-random}

paste <(zcat $FQ1) <(zcat $FQ2) | paste - - - - | shuf | head -n $NUM | awk -F'\t' -v prefix=$PREFIX '{OFS="\n"; print $1,$3,$5,$7 > prefix".1.fq"; print $2,$4,$6,$8 > prefix".2.fq"}'
