#install.packages("qqman")
library(qqman)
c <- read.table("~/Report-DCob16-2442-Pascal/GbS_beanfly/assoc_val2.qassoc", header = TRUE)

head(c)

order <- c[order(c$P),]
write.csv(order, "output_manhattan.csv")

head(order)

manhattan(c, cex=0.8, col=c("blue4", "orange3"))
qq(gwasResults$P, main="Q-Q plot of P-values")

#######################
#source("https://bioconductor.org/bioclite.R")

#biocLite("SNPRelate")


library(GWASTools)
library(SNPRelate)
bed.fn <- "~/Downloads/qc_fb_phe2.bed"
fam.fn <- "~/Downloads/qc_fb_phe2.fam"
bim.fn <- "~/Downloads/qc_fb_phe2.bim"
gdsfile <- "snps.gds"

snpgdsBED2GDS(bed.fn, fam.fn, bim.fn, gdsfile)

genofile <- snpgdsOpen("snps.gds")

pca <- snpgdsPCA(genofile)
 
tab <- data.frame(sample.id = pca$sample.id,
                  EV1 = pca$eigenvect[,1],    # the first eigenvector
                  EV2 = pca$eigenvect[,2],    # the second eigenvector
                  stringsAsFactors = FALSE)

plot(tab$EV2, tab$EV1, xlab="eigenvector 2", ylab="eigenvector 1")


