

#-----PCA plot from PLINK output
library(ggplot2)
pca <- read.table("pca_wgas2.eigenvec")
ggplot(pca, aes(x=V3, y=V4, colour=V1)) + geom_point()

#-----Another option for PCA 

#source("https://bioconductor.org/bioclite.R")

#biocLite("SNPRelate")

library(GWASTools)
library(SNPRelate)
bed.fn <- "wgas2.bed"
fam.fn <- "wgas2.fam"
bim.fn <- "wgas2.bim"
gdsfile <- "snps.gds"

snpgdsBED2GDS(bed.fn, fam.fn, bim.fn, gdsfile)

genofile <- snpgdsOpen("snps.gds")

pca <- snpgdsPCA(genofile)
head(genofile)

tab <- data.frame(sample.id = pca$sample.id, pop=pca$
                    EV1 = pca$eigenvect[,1],    # the first eigenvector
                  EV2 = pca$eigenvect[,2],    # the second eigenvector
                  stringsAsFactors = FALSE)

ggplot(tab, aes(x=EV1, y=EV2, colour=sample.id)) + geom_point()


#####------MDS

library(ggplot2)

mds <- read.table("otp-mds.mds", header = TRUE)

#--MDS plot by genotype ID 
ggplot(mds, aes(x=C1, y=C2, colour=IID)) + geom_point() + theme_bw()

#--MDS plot by family ID 
ggplot(mds, aes(x=C1, y=C2, colour=FID)) + geom_point() + theme_bw()

###------TREE

library(ape)
library(RColorBrewer)

#1. Add IDs to distance matrix from PLINK. Both as a column and as a row. 
m <- as.matrix(read.table("tree.dist.txt", head=T, row.names=1))

#2. Create 2 column file with Family (population) ID in the first column and genotype ID in the 2nd column
names<-read.table("pop_ID.txt")
head(names)
plot(hclust(dist(m)))

arbol <- nj(as.dist(m))

jColors=data.frame(pop=levels(names),color=rainbow(nlevels(names)),colFact)

(jColors <-
    with(names,
         data.frame(pop = levels(V1),
                    color = I(brewer.pal(nlevels(V1), name = 'Dark2'))))) 

colScheme = jColors$color[match(names$V1,jColors$pop)]

plot(arbol, label.offset = 0.3, use.edge.length = FALSE, 
     cex=0.4, tip.color =colScheme, no.margin = TRUE)

legend("topleft",legend = jColors$pop,text.col=c(jColors$color))

####----FST  

m <- as.matrix(read.table("fst_matrix.txt", head=T, row.names=1))

arbol <- nj(as.dist(m))
hc = hclust(dist(m))

plot(as.phylo(hc), no.margin = FALSE, cex=0.7)

#add a scale bar. Ask means ask where you want the scale bar. #You must click on the plot where you want the scale bar
add.scale.bar(ask = TRUE)

