unmapped_tparva.tab
install.packages("pheatmap")

d<-read.table("~/tparva/goterms_by_stage.tab", row.names=1,header = TRUE)
head(d)

#order the table by descending number of observations (OTUs or functions(e.g. KOs)), 
#so we can just plot the top most number or rows later
d_sorted<-d[order(-rowSums(d)),]
head(d_sorted)

#we are going to log to increase visibility of lower counts so need to get rid of these 0's 
#This is obviously not ok if you have small counts, 
#but on a big heatmap with large counts the difference between 0 or 1 will not be distiguishable
d_sorted[d_sorted==0]<-1


#draw the heatmap with log scaled intensities
#only top 1000 rows are plotted here. Personally I have used 4000 rows, but I try a few to see if it increases visibility
#colors go from black to blue, you can substitute different colours. 
pdf(paste("heatmap_goterms", ".pdf", sep="") ,onefile=TRUE, width = 10, height = 30)
p<-pheatmap(log10(d_sorted),
            show_rownames=TRUE,show_colnames=TRUE, cellheight = 7, fontsize = 8)
dev.off()
#since labels on legend are log values you can set them manually here AFTER visualizing (or just edit them in GIMP).

p<-pheatmap(d_sorted,colorRampPalette(c('black','blue'))(50),show_rownames=FALSE,show_colnames=FALSE,annotation=map,legend_breaks=0:3,legend_labels=c(0,10,100,1000))



data <- read.table("~/tparva/Blast/unmapped_tparva.tab", header=TRUE)
data
select <-order(rowMeans(counts(data)),decreasing=TRUE)
nt <- normTransform(dds) # defaults to log2(x+1)
log2.norm.counts <- assay(nt)[select,]
df <- as.data.frame(colData(dds)[,c("condition")])
install.packages("heatmap.3")
library(heatmap.3)
library(pheatmap)
p <-pheatmap(assay(rld)[select,],
             cluster_rows=FALSE, 
             show_rownames=TRUE,cluster_cols=FALSE,
             annotation_col=df)