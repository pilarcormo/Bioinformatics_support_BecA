### DESeq2 for Zebfrafish example 

1. Install Deseq2 and other libraries 

	```
	source("https://bioconductor.org/biocLite.R")
	biocLite("DESeq2")
	library(DESeq2)
	library("gplots")
	library("RColorBrewer")
	library(pheatmap)
	```

1. Set working directory 
 
	```
	setwd("~/RNAseq_practical")
	directory <- "~/RNAseq_practical/"
	```
2. Open tab file with htseq output

	```
	file<-paste(directory, "zebrafish.htseq.tab.txt", sep="") 
	```
3. Define conditions for each sample

	```
	cond<-c("2cells", "6h")
	type<-c("2cells", "6h")
	```

4. Prepare the table

	```
	countsTable<-read.table(file,header=T)
	rownames(countsTable)<-countsTable$gene
	countsTable<-countsTable[,-1] 
	rlog = rlogTransformation
	```

5. Differential expression - Compare all 

	```
	localTable<-countsTable
	localCond<-cond
	colData<-data.frame(condition=factor(localCond), type=factor(type))
	dds<-DESeqDataSetFromMatrix(countData=localTable,colData,formula(~condition))
	dds <- DESeq(dds)
	rld <- rlog(dds)
	```
6. Plot MA to check distribution of differentially expressed genes 
	
	```
	plotMA(dds)
	```
	
7. Plot PCA to see sample distribution 
	
	```
	data <- plotPCA(rld, intgroup=c("condition"), returnData=TRUE)
	percentVar <- round(100 * attr(data, "percentVar"))
	ggplot(data, aes(PC1, PC2, color=condition)) + theme_bw() +
	  geom_point(size=7) +
	  xlab(paste0("PC1: ",percentVar[1],"% variance")) +
	  ylab(paste0("PC2: ",percentVar[2],"% variance"))
	```
	
8. Get results, order them and filter by p-adj 
	
	```
	res <- results(dds)
	res_filtered <- subset(res, res$padj < 0.05)
	resOrdered <- res_filtered[order(res_filtered$padj),]
	write.csv(as.data.frame(resOrdered),file=paste("results_listeria", ".csv", 	sep=""))
	```
	
9. Make heatmap for sample distance
	
	```
	sampleDists <- dist(t(assay(rld)))  
	sampleDistMatrix <- as.matrix(sampleDists)
	colours = colorRampPalette( rev(brewer.pal(9, "Blues")) )(255)
	heatmap.2(sampleDistMatrix, trace="none", col=colours)
	```
	
10.  Take 50 first DE genes and make heatmap 
	
	```
	select <-head(order(rowMeans(counts(dds,normalized=FALSE)),decreasing=TRUE), 50	)
	nt <- normTransform(dds) # defaults to log2(x+1)
	log2.norm.counts <- assay(nt)[select,]
	df <- as.data.frame(colData(dds)[,c("condition")])
	```
	
	```
	p <-pheatmap(assay(rld)[select,], cluster_rows=FALSE, 	show_rownames=TRUE,cluster_cols=FALSE, annotation_col=df)
	```
	
11. Differential expression - Pairwise comparision 
	
	```
	2cells <- c("2cells")
	6h <- c("6h")
	```
	```
	localTable<-countsTable[,c(2cells,6h)]
	localCond<-c(rep("2cells", 1), rep("6h", 1))
	colData<-data.frame(condition=factor(localCond))
	dds<-DESeqDataSetFromMatrix(countData=localTable,colData,formula(~condition))
	dds<-DESeq(dds)
	```
	```
	res <- results(dds)
	res_filtered <- subset(res, res$padj < 0.05)
	resOrdered <- res_filtered[order(res_filtered$padj),]
	write.csv(resOrdered,file=paste("6h_vs_2cells", ".csv", sep=""))
	```


### cummeRbund for Zebrafish example
1. Install cummeRbund

	```
	source("https://bioconductor.org/biocLite.R")
	biocLite("cummeRbund")
	library(cummeRbund)
	```
2. Import data and create a database out of cuffdiff output files

	```
	dbFile<-paste('~/RNAseq_practical/cuffdiff_zebrafish',"/Zebrafish/cuffData.	db", sep="")
	cuff<-readCufflinks('~/RNAseq_practical/cuffdiff_zebrafish', rebuild=T) 
	cuff
	```
3. Retrive significant gene IDs (XLOC)

	```
	diffGeneIDs <- getSig(cuff,level="genes",significant=='yes')
	```
	
4. Get list of differentially expresssed genes 

	```
	diffGenes<-getGenes(cuff,diffGeneIDs)
	gene_diff_data <- diffData(genes(cuff))
	```

5. Check global quality - dispersion of data

	```
	disp<-dispersionPlot(genes(cuff))
	disp
	```
6. Check distance between samples 

	```
	myDistHeat<-csDistHeat(genes(cuff))
	myDistHeat
	dend<-csDendro(genes(cuff), replicates = T) 
	dend
	```

7. PCA

	```
	genes.PCA<-PCAplot(genes(cuff),x="PC1", y="PC2", replicates=T, ,showPoints = 	FALSE)
	genes.PCA 
	```
6. Distribution of FPKM scores across samples

	```
	dens<-csDensity(genes(cuff))
	dens
	densRep<-csDensity(genes(cuff),replicates=T)
	densRep
	brep<-csBoxplot(genes(cuff),replicates=T)
	brep
	```

7.  Pairwise scatterplots to check differentially expressed genes in the comparisons

	```
	scatter<-csScatterMatrix(genes(cuff))
	scatter
	scatter<-csScatterMatrix(genes(cuff),replicates=T)
	scatter
	```

8. Volcano plot - a scatter plot that also identifies differentially expressed genes (by color) between samples

	```
	v<-csVolcanoMatrix(genes(cuff))
	v
	v<-csVolcanoMatrix(genes(cuff), replicates=T)
	```

9. Overview of significant differentially expressed features 

	```
	mySigMat<-sigMatrix(cuff,level='genes',alpha=0.05) 
	mySigMat
	```


10. Create heatmap for differentially expressed genes 

	```
	csHeatmap(diffGenes, clustering='row', labCol=T, logMode=T, border=FALSE, 	fullnames = T) + theme(axis.text.x=element_text(size=14),axis.text.	y=element_text(size=6))
	```

11. Gene clusters 

	```
	ic <- csCluster(diffGenes,  k=2) 
	csClusterPlot(ic,pseudocount=1.0,drawSummary=TRUE,sumFun=mean_cl_boot)
	write.table(ic$clustering, "clusters_cuff.txt")
	```
	
12. Finding espression of specific genes, isoforms or CDS 


	```
	myGene<-getGene(cuff, "XLOC_003485")
	expressionPlot(myGene,replicates=TRUE) + theme_bw()
	```


