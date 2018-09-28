data <- read.table("~/tparva/DE_isoforms_tpm.txt", header=TRUE)
list <- read.table("~/tparva/real_DE_isoforms.txt", header=FALSE)
con <- read.table("~/tparva/Transcript-geneID_clean.txt")
head(list$V1)
head(data)

for (gene in list$V1){
  x <- data[data$id==gene,]
  tp <- con[con$V1==gene,]$V2
  filename<-paste(gene, sep="")
  name=paste0(gene,'.2')
  y <- data[data$id==name,]
  df <- rbind(x, y)
  dfm <- melt(df, id.vars="id")
  pdf(paste(filename, ".pdf", sep="") ,onefile=TRUE)
  print(ggplot(dfm, aes(x=variable, y=value, colour=id, group = id)) + 
    ylab("tpm") + xlab("") + theme(legend.title = element_blank()) +
    geom_point() +geom_line() + theme_bw() + ggtitle(tp))
  dev.off()
}

