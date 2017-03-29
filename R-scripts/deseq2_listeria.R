source("https://bioconductor.org/biocLite.R")
biocLite("DESeq2")

library(DESeq2)
library("gplots")
library("RColorBrewer")
library(pheatmap)

#Set working directory 
setwd("~/RNAseq_practical")
directory <- "~/RNAseq_practical/"

#Open tab file with htseq output
file<-paste(directory, "listeria.htseq.tab", sep="") 

#Define conditions for each sample
cond<-c("wt", "wt", "mutant", "mutant")
type<-c("wt", "wt", "mutant", "mutant")



#Prepare the table
countsTable<-read.table(file,header=T)
rownames(countsTable)<-countsTable$gene
countsTable<-countsTable[,-1] 
rlog = rlogTransformation

#############
#COMPARE ALL#
#############
localTable<-countsTable
localCond<-cond

colData<-data.frame(condition=factor(localCond), type=factor(type))

dds<-DESeqDataSetFromMatrix(countData=localTable,colData,formula(~condition))

dds <- DESeq(dds)
rld <- rlog(dds)

#1. Plot MA to check distribution of differentially expressed genes 
plotMA(dds)

#2. Plot PCA to see sample distribution 
data <- plotPCA(rld, intgroup=c("condition"), returnData=TRUE)
percentVar <- round(100 * attr(data, "percentVar"))
ggplot(data, aes(PC1, PC2, color=condition)) + theme_bw() +
  geom_point(size=7) +
  xlab(paste0("PC1: ",percentVar[1],"% variance")) +
  ylab(paste0("PC2: ",percentVar[2],"% variance"))


#3. Get results, order them and filter by p-adj 
res <- results(dds)
res_filtered <- subset(res, res$padj < 0.05)
resOrdered <- res_filtered[order(res_filtered$padj),]
write.csv(as.data.frame(resOrdered),file=paste("results_listeria", ".csv", sep=""))


#4. Make heatmap for sample distance
sampleDists <- dist(t(assay(rld)))  
sampleDistMatrix <- as.matrix(sampleDists)
colours = colorRampPalette( rev(brewer.pal(9, "Blues")) )(255)
heatmap.2(sampleDistMatrix, trace="none", col=colours)

#5. Take 50 first DE genes and make heatmap 
select <-head(order(rowMeans(counts(dds,normalized=FALSE)),decreasing=TRUE), 50)
nt <- normTransform(dds) # defaults to log2(x+1)
log2.norm.counts <- assay(nt)[select,]
df <- as.data.frame(colData(dds)[,c("condition")])


p <-pheatmap(assay(rld)[select,], cluster_rows=FALSE, show_rownames=TRUE,cluster_cols=FALSE, annotation_col=df)


#####################
#PAIRWISE COMPARISON#
####################

wt<-c("wt1", "wt2")
Mutant<-c("mutant1", "mutant2")

localTable<-countsTable[,c(wt, Mutant)]
localCond<-c(rep("wt", 2), rep("mutant", 2))
colData<-data.frame(condition=factor(localCond))
dds<-DESeqDataSetFromMatrix(countData=localTable,colData,formula(~condition))
dds<-DESeq(dds)

res <- results(dds)
res_filtered <- subset(res, res$padj < 0.05)
resOrdered <- res_filtered[order(res_filtered$padj),]
write.csv(resOrdered,file=paste("wt_vs_mutant", ".csv", sep="")) 





