library(gplots)
library(EDDA)

UQNnormalization <- function(counts, p = 0.75) {
     data <- counts
     i <- apply(data <= 0, 1, all)
     if (any(i))
         data <- data[!i, , drop = FALSE]
     f <- apply(data, 2, function(x) quantile(x, p = p))
     normFactors <- f/exp(mean(log(f)))
   
     normCounts <- round(as.matrix(sweep(data, 2, normFactors,
         "/")))
     return(normCounts)
}

data <- read.table('skinmicro_all.readcount.tsv', head=T, row.names = 1, sep='\t')
data[is.na(data)] <- 0
# black for patient, gray for control
label_col <- c(rep('black',49))
label_col[c(1,2,5:8,17,18,19,20)] <-'gray'

m_data <- as.matrix(log10(data[,c(-1,-2)]+1))
m_data <- log10(UQNnormalization(data[,c(-1,-2)])+1)

png('readcount_heatmap.png',width=1800,height=1100,res=200)
heatmap.2(m_data, trace="none",
          cexRow = 0.8, cexCol = 0.8 , Rowv = T, Colv = T,scale='row',
          ColSideColors = label_col[c(-1,-2)],
          col=bluered(300)
          )
legend("topright", legend=c("Normal",  "Patient"),
       fill=c("gray", 'black'), border = FALSE,
       bty = 'n', y.intersp = 0.8, cex=0.8)
dev.off()
