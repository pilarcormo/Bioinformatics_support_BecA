######CUMMERBUND
source("https://bioconductor.org/biocLite.R")
biocLite("cummeRbund")
install.packages("sqldf")

library(cummeRbund)
library(sqldf)
########

dbFile<-paste('~/RNAseq_practical/cuffdiff_zebrafish',"/Zebrafish/cuffData.db", sep="")

###create a database out of cuffdiff output files. 
cuff<-readCufflinks('~/RNAseq_practical/cuffdiff_zebrafish', rebuild=T) 
cuff

#Retrive significant gene IDs (XLOC) with a pre-specified alpha
diffGeneIDs <- getSig(cuff,level="genes",significant=='yes')


#Use returned identifiers to create a CuffGeneSet object with all relevant info for given genes
#Get list of differentially expresssed genes 
diffGenes<-getGenes(cuff,diffGeneIDs)

gene_diff_data <- diffData(genes(cuff))

#global quality - check dispersion of data

disp<-dispersionPlot(genes(cuff))
disp

###Distance matrix
myDistHeat<-csDistHeat(genes(cuff))
myDistHeat

#Create dendogram (tree) to check distance between samples 

dend<-csDendro(genes(cuff), replicates = T) 
dend

###distribution of FPKM scores across samples
dens<-csDensity(genes(cuff))
dens
densRep<-csDensity(genes(cuff),replicates=T)
densRep
brep<-csBoxplot(genes(cuff),replicates=T)
brep

##scatter
scatter<-csScatterMatrix(genes(cuff))
scatter
scatter<-csScatterMatrix(genes(cuff),replicates=T)
scatter

###volcano plot. 
####A volcano plot is a scatter plot that also identifies differentially 
#expressed genes (by color) between samples

v<-csVolcanoMatrix(genes(cuff))
v
v<-csVolcanoMatrix(genes(cuff), replicates=T)
tab<-getSigTable(cuff)

##overview of significant features 
mySigMat<-sigMatrix(cuff,level='genes',alpha=0.05) 
mySigMat




#######Dimensionality reduction
###PCA
genes.PCA<-PCAplot(genes(cuff),x="PC1", y="PC2", replicates=T, ,showPoints = FALSE)
genes.PCA 


#Create heatmap for differentially expressed genes 
csHeatmap(diffGenes, clustering='row', labCol=T, logMode=T, border=FALSE, fullnames = T) + theme(axis.text.x=element_text(size=14),axis.text.y=element_text(size=6))

names<-featureNames(diffGenes)

####Gene clusters 
ic <- csCluster(diffGenes,  k=2) 
csClusterPlot(ic, pseudocount=1.0,drawSummary=TRUE,sumFun=mean_cl_boot)
write.table(ic$clustering, "clusters_cuff.txt")

#finding espression of specific genes, isoforms or CDS 
myGene<-getGene(cuff, "XLOC_003485")

expressionPlot(myGene,replicates=TRUE) + theme_bw()



