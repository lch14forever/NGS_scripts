#!/mnt/software/bin/Rscript-3.1.2

library(getopt)

####### a template for merging tables (2 columns) in one folder ##########
#######       merge according to 'Merge_Key'       #######################

spec <- matrix(c(
    'help','h',0,'logical','Show this help information',
    'colPattern','c',1,'character','Regex to match part of file names and use them as the column names [default: .+]',
    'folder', 'f', 1, 'character', 'Folder containing the inputs [default: cwd]',
    'fPattern', 'p', 1, 'character', 'File pattern for the input [default: *]',
    'withHeader', 'H', 1, 'logical', 'The input files contain a header line [default: TRUE]',
    'outFile', 'o', 1, 'character', 'Output file (will write in csv format) [default: stdout]'
    ), byrow=T, ncol=5)

opt = getopt(spec);

usage_message <- 'This script combine a set of files with to columns into one using the first column as the merge key.\n'
if ( !is.null(opt$help) ) {
    cat(usage_message)
    cat(getopt(spec, usage=TRUE));
    q(status=1);
}
#set some reasonable defaults for the options that are needed,
#but were not specified.
if ( is.null(opt$colPattern ) ) {opt$colPattern = '/.+'}
if ( is.null(opt$folder ) ) { opt$folder = '.' }
if ( is.null(opt$fPattern ) ) { opt$fPattern = '*' }
if ( is.null(opt$withHeader ) ) { opt$withHeader = TRUE }


Merge_Key <- 'Classification'# merge according to this column
Col_Pattern <- opt$colPattern   # name the columns according to the file name
Folder <- opt$folder       # folder containing tables
File_Pattern <- opt$fPattern # Pattern for matching file names

# input files list
filenames <- list.files(Folder, pattern=File_Pattern, full.names=TRUE)

df_list <- lapply(filenames, function(x) read.table(x, head=opt$withHeader, sep='\t', col.names=c(Merge_Key,
                                                                             regmatches(x, regexpr(Col_Pattern, x, perl=T))))) 
# merge DFs
df_merged <- Reduce(function(x,y)merge(x,y,all=T,by=Merge_Key), df_list)
rownames(df_merged) <- df_merged[,1]
df_merged <- df_merged[,2:ncol(df_merged)]
# NA removal
df_merged[is.na(df_merged)] <- 0

## # write to table
if ( !is.null(opt$outFile ) ){
    write.csv(df_merged, opt$outFile, quote=F)
}else{
    print(df_merged)
}
