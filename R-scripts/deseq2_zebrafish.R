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
file<-paste(directory, "zebrafish.htseq.tab.txt", sep="") 

#Define conditions for each sample
cond<-c("2cells", "6h")
type<-c("2cells", "6h")


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

x2cells <- c("2cells")
x6h <- c("6h")

localTable<-countsTable[,c(x2cells,x6h)]
localCond<-c(rep("2cells", 1), rep("6h", 1))
colData<-data.frame(condition=factor(localCond))
dds<-DESeqDataSetFromMatrix(countData=localTable,colData,formula(~condition))
dds<-DESeq(dds)

res <- results(dds)
res_filtered <- subset(res, res$padj < 0.05)
resOrdered <- res_filtered[order(res_filtered$padj),]
write.csv(resOrdered,file=paste("6h_vs_2cells", ".csv", sep=""))





