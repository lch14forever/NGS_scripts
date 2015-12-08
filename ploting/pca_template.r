df <- read.table('../1normalized/eu_cnI.UQN.shared.csv', head=T, row.names = 1, sep =',')
#df <- read.table('../1normalized/eu_cnI.UQN.shared.PCcorrected.csv', head=T, row.names = 1, sep =',')
df <- read.table('../1normalized/eu_cnI.CSS.log.shared.tsv', head=T, row.names = 1, sep=',')

disease_label <- unlist(df[1,], use.names = F)
cohort_label <- c(rep(1,145), rep(2,145))

df_t <- t(df[-1,])

CP <- prcomp(df_t, center = T ,scale = T)
summary(CP)

#eu_labels <- unlist(read.table('../european.labels.numeric', row.names = 1), use.names = F)
#cn_labels <- unlist(read.table('../chinese.stageI.labels.numeric', row.names = 1), use.names = F)

#disease_label <- c(cn_labels), cn_labels)
#cohort_label <- c(rep(1,145)), rep(2,145))

c1 <- 1
c2 <- 2
plot(CP$x[,c1], CP$x[,c2],
     col=disease_label+2 ,
     pch = cohort_label+15,
     main = "PCA biplot",
     xlab = paste("PC ",c1, '; ', round(CP$sdev[c1],4)),
     ylab = paste("PC ",c2, '; ', round(CP$sdev[c2],4)))
legend("bottomright", legend=c("Normal", "T2D", "Impaired_glucose", "European", "Chinese"),
       col=c(2, 3, 4, 1, 1),pch = c(15,15,15,16,17), border = FALSE,
       bty = 'n', y.intersp = 0.8, cex=0.8)

# what if we do pca analyses on normal
df_normal <- df_t_nonZero[disease_label==0,]
CP <- prcomp(df_normal[,colSums(df_normal) > 0], center = T ,scale = T)
summary(CP)
c1 <- 3
c2 <- 2
plot(CP$x[,c1], CP$x[,c2],
#     col=disease_label+1 ,
 #    pch = cohort_label+15,
     cex= 2,
     main = "PCA biplot",
     xlab = paste("PC ",c1, '; ', round(CP$sdev[c1],4)),
     ylab = paste("PC ",c2, '; ', round(CP$sdev[c2],4)))
