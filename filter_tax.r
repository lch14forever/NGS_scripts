#!/usr/bin/env Rscript-3.3.1

### run:
####$ script.r input_file library_size_thre presence_thre sample_proportion_thre
##args[1]: input file
##args[2]: discard sample if total number of reads is small
##args[3]: determine presence/absence of taxon/OTU
##args[4]: proportion of sample containing the taxa in order to keep it

args <- commandArgs(trailingOnly=T)


##args[1] <- "/mnt/projects/lich/dream_challenge/MDSINE/project_int/SRC/david_et_al/stool/otu.table.ggref.stools.tsv"
## args[2] <- 10000
## args[3] <- 5
## args[4] <- 0.99

df <- read.table(args[1], head =TRUE, row.names=1, comment.char = "!")

## filter samples:
samples <- colSums(df) >= as.numeric(args[2])
samples_not <- colSums(df) < as.numeric(args[2])

write("====================================", stderr())
write("Samples removed:", stderr())
write(colnames(df)[samples_not], stderr())
write("====================================", stderr())

df.f <- df[, samples]

nSample <- dim(df.f)[2]

presence <- rowSums(df.f > as.numeric(args[3]))/nSample

others <- t(data.frame(colSums(df.f[presence<as.numeric(args[4]), ])))
rownames(others) <- "Low_abundance"

out <- rbind(others, df.f[presence>=as.numeric(args[4]),] )

write.table(out, paste0(args[1] ,
                        ".filtered_", args[2], "_", args[3], "_", args[4]),
            quote=F, sep='\t', col.names=NA)
