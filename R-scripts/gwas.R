#######################
#-----Manhattan plot from PLINK output

#install.packages("qqman")
library(qqman)
c <- read.table("~/Downloads/plink_mac/wgas3val2_assoc.qassoc", header = TRUE)

order <- c[order(c$P),]
write.csv(order, "output_manhattan.csv")

head(order)

manhattan(c, cex=0.8, col=c("blue4", "orange3"))
qq(gwasResults$P, main="Q-Q plot of P-values")

#######################
#-----PCA plot from PLINK output
pca <- read.table("~/Downloads/plink_mac/pca_wgas2.eigenvec")

library(ggplot2)
ggplot(pca, aes(x=V3, y=V4, colour=V1)) + geom_point()

#-----Another option

#source("https://bioconductor.org/bioclite.R")

#biocLite("SNPRelate")

library(GWASTools)
library(SNPRelate)
bed.fn <- "~/Downloads/plink_mac/wgas2.bed"
fam.fn <- "~/Downloads/plink_mac/wgas2.fam"
bim.fn <- "~/Downloads/plink_mac/wgas2bim"
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


#####------Tree


####