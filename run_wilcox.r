#!/mnt/software/bin/Rscript-3.1.2

library(getopt)


spec <- matrix(c(
    'help','h',0,'logical','Show this help information',
    'input', 'i', 1, 'character', 'Input file (tsv)',
    'group_control', 'N',1, 'integer', 'The number of controls',
    'group_case', 'P',1,'integer', 'The number of cases [ncol - 1 - group_control]',
    'group_order', 'O', 1,'logical', 'Is control in front of case? [default: TRUE]',
    'output', 'o', 1, 'character', 'Output file [default: stdout]'
    ), byrow=T, ncol=5)

opt = getopt(spec);

usage_message <- 'This script run two sided wilcoxon rank sum test on the input.\n'
no_input_message <- 'The input file is missing.\n'
no_label_message <- 'The group information is missing.\n'

if ( !is.null(opt$help) ) {
    cat(usage_message)
    cat(getopt(spec, usage=TRUE));
    q(status=1);
}

if ( is.null(opt$input ) ) {
    cat(no_input_message)
    cat(getopt(spec, usage=TRUE));
    q(status=1);
}
if ( is.null(opt$group_control) ) {
    cat(no_label_message)
    cat(getopt(spec, usage=TRUE));
    q(status=1);

}
if ( is.null(opt$group_order ) ) { opt$group_order = TRUE }

INPUT <- opt$input
OUTPUT <- opt$output
    
data=read.table(INPUT,sep='\t',head=T, row.names=1)

# filter out all the rows with all zeros
data <- data[rowSums(data) != 0,]

if ( is.null(opt$group_case ) ) { opt$group_case = dim(data)[2] - opt$group_control }

if(opt$group_order){ group = c(rep("N", opt$group_control), rep("P", opt$group_case))
}else {group = c(rep("P", opt$group_case), rep("N", opt$group_control)) }


p_values <- sapply(1:dim(data)[1], function(x) wilcox.test(unlist(data[x, group=='N']), unlist(data[x, group == 'P']))$p.value)
p_values_adj <- p.adjust(p_values, method='fdr')

logFC <- sapply(1:dim(data)[1], function(x) log2(mean(unlist(data[x, group == 'P']))/mean(unlist(data[x, group=='N']))+0.00000000001))

out <- data.frame(GENE=rownames(data), logFC=logFC, p_value=p_values, FDR=p_values_adj)

if ( is.null(opt$output ) ){
    print(out)
}else{
    write.table(out, OUTPUT, row.names=F, sep = "\t", quote=F)
}
