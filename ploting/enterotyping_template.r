require(clusterSim)
require(ade4)

# Kullback-Leibler divergence
# KLD <- function(x,y) sum(x * log(x/y)) 
# Jensen-Shannon distance
# JSD<- function(x,y) sqrt(0.5 * KLD(x, (x+y)/2) + 0.5 * KLD(y, (x+y)/2))

# Calculating JSD matrix
dist.JSD <- function(inMatrix, pseudocount=0.000001, ...) {
	KLD <- function(x,y) sum(x *log(x/y))
	JSD<- function(x,y) sqrt(0.5 * KLD(x, (x+y)/2) + 0.5 * KLD(y, (x+y)/2))
	matrixColSize <- length(colnames(inMatrix))
	matrixRowSize <- length(rownames(inMatrix))
	colnames <- colnames(inMatrix)
	resultsMatrix <- matrix(0, matrixColSize, matrixColSize)
        
  inMatrix = apply(inMatrix,1:2,function(x) ifelse (x==0,pseudocount,x))

	for(i in 1:matrixColSize) {
		for(j in 1:matrixColSize) { 
			resultsMatrix[i,j]=JSD(as.vector(inMatrix[,i]),
			as.vector(inMatrix[,j]))
		}
	}
	colnames -> colnames(resultsMatrix) -> rownames(resultsMatrix)
	as.dist(resultsMatrix)->resultsMatrix
	attr(resultsMatrix, "method") <- "dist"
	return(resultsMatrix) 
 }

# pam
pam.clustering <- function(x,k) { # x is a distance matrix and k the number of clusters
                         require(cluster)
                         cluster = as.vector(pam(as.dist(x), k, diss=TRUE)$clustering)
                         return(cluster)
                        }

noise.removal <- function(dataframe, percent=0.01, top=NULL){
	dataframe->Matrix
	bigones <- rowSums(Matrix)*100/(sum(rowSums(Matrix))) > percent 
	Matrix_1 <- Matrix[bigones,]
	print(percent)
	return(Matrix_1)
 }

data <- read.table("../1normalized/eu_cnI.UQN.shared.csv", header=T, row.names=1, sep=",")
data <- read.table("../1normalized/eu_cnI.cpm.noBatch.csv", header=T, row.names=1, sep=",")
data <- 2^data[-1,]/1e6
#data <- read.table("../0rawDATA/chinese_stageI_raw.tsv", header=T, row.names = 1)
data <- read.table("../../t2d_new/species/genus_count_eu_cnI.tsv", header=T, row.names=1)
data <- read.table("../../t2d_new/0raw_data/KO_count_eu_cnI.csv", header=T, row.names=1, sep = ',')
labels <- c(rep(1,145), rep(2,145))

labels <- unlist(data[1,], use.names = F)
data <- apply(data[-1, ], 2, function(x) x/sum(x))

# normals
# sum(labels[1:145] == 0) # 43
# sum(labels[146:290] == 0) # 74
# data <- apply(data[-1, labels==0], 2, function(x) x/sum(x))

#data <- apply(data, 2, function(x) x/sum(x))
#data <- data[-which(row.names(data)=='Unknown'), ]

data.dist <- dist.JSD(data)

nclusters=NULL

for (k in 1:20) { 
	if (k==1) {
            nclusters[k]=NA 
        } else {
            data.cluster_temp=pam.clustering(data.dist, k)
            nclusters[k]=index.G1(t(data),data.cluster_temp,  d = data.dist,
                         centrotypes = "medoids")
        }
    }

plot(nclusters, type="h", xlab="k clusters", ylab="CH index")


# 2 or 3 clusters

data.cluster=pam.clustering(data.dist, k=3)
mean(silhouette(data.cluster, data.dist)[,3])
data.cluster=pam.clustering(data.dist, k=2)
mean(silhouette(data.cluster, data.dist)[,3])

# 2 clusters
#data.denoized=noise.removal(data, percent=0.01)

#obs.pca=dudi.pca(data.frame(t(data)), scannf=F, nf=10)
#obs.bet=bca(obs.pca, fac=as.factor(data.cluster), scannf=F, nf=3-1) 
#s.class(obs.bet$ls, fac=as.factor(data.cluster), grid=F)


obs.pcoa=dudi.pco(data.dist, scannf=F, nf=3)
s.class(obs.pcoa$li, fac=as.factor(data.cluster), grid=F, pch=labels)
