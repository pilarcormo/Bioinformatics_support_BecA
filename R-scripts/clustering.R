
###############
require(cluster)
fit <- pam(x = data, k = 50)

write.csv(fit$clustering, "clustering.csv")  # get cluster assignment

fit$medoids  # get coordinates of each medoid
# summary method
summary(fit)





############################

library(ggplot2)
library(reshape2)

data <- read.csv("average_tpm.csv", header=TRUE)
data
choose_cluster <- data[data$x== '12',]
df<-choose_cluster[,1:4]
df

############################
library(ggplot2)

dfm <- melt(df, id.vars="target_id")
head(dfm)

ggplot(dfm, aes(x=variable, y=value, colour=target_id, group = target_id)) + geom_point() +geom_line() + theme_bw() + ggtitle("Genes with similar expression to gene1")

