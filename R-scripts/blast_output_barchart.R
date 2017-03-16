
library(ggplot2)


###Stacked bar chart for species names in blast output

data <- read.table("blast_output_species_names.txt")


counts <- table(data)
data

t<- data.frame(table(data))

order <- t[order(t$Freq),] 
x <- order[order$Freq > 40,]$data
y <- order[order$Freq > 40,]$Freq

df2 <- data.frame(x, y)


b_percent <- ggplot(df2, aes(x = reorder(x, y), y = y)) + geom_bar(stat = "identity",  width=.8) +
  xlab("") + ylab("%") +theme_bw() + geom_bar(stat = "identity",  width=.8) + ggtitle("counts Blast") + 
  coord_flip() 


b_percent



