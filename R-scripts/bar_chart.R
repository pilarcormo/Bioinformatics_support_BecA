###differentially expressed genes in each stage

data <- read.table("DE_genes_names.txt")
data

dfm <- melt(data, id.vars=c("V1","V2"))


ggplot(dfm, aes(x=reorder(V1, value), y=value, fill=V2,
                group = V1)) + geom_bar(stat="identity") + 
  theme_bw() + ggtitle("Differentially expressed genes by stage") + 
  xlab("Stage") + ylab("Number of genes") + 
  
  scale_fill_manual(values=c("cyan4", "coral1"), name=" ", breaks=c("up", "down"), labels=c("Upregulated", "Downregulated"))

#####Enriched functions

data <- read.table("go_terms_from_david.txt")


head(data)

x <- data[data$V2 > 60,]$V1
y <- data[data$V2 > 60,]$V2

df<-data.frame(x, y)


ggplot(df, aes(x=reorder(x, y), y=y)) + geom_bar(stat="identity") + 
  theme_bw() + ggtitle("") + 
  xlab("Go term associated to DE gene") + ylab("Count") + coord_flip() +
  theme(plot.title = element_text(size = 12), axis.text=element_text(size=10), axis.title=element_text(size=18,face="bold"))
  
  