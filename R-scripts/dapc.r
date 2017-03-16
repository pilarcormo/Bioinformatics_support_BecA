
library(adegenet)
library(ape)
myDNA<- read.dna("~/Barberine_gendiv/p104_all.fas", format = "fasta")
myDNA <- as.matrix(myDNA)
snpposi.plot(myDNA,codon=FALSE, title=FALSE)+ labs(title="Distribution of SNPs")
obj <- DNAbin2genind(myDNA, polyThres=0.01)

library(gplots)


# make PCA
pca1 <- dudi.pca(X,cent=FALSE,scale=TRUE,scannf=FALSE,nf=3)
colorplot(pca1$li, pca1$li, transp=TRUE, cex=3, xlab="PC 1", ylab="PC 2")
abline(v=0,h=0,col="grey", lty=2)
text(pca1$li, row.names(pca1$li), cex=0.6, pos=1)


library(ggplot2)
library(ggfortify)
library(cluster)
X <- tab(obj, NA.method="mean")
autoplot(prcomp(X), label = TRUE, label.size = 3, shape=TRUE)

p <- autoplot(X, shape = FALSE, label.colour = 'blue', label.size = 0.1, xlab="SNPs", ylab="Samples")
p + theme(axis.text.x = element_text(angle = 90, hjust = 1))


