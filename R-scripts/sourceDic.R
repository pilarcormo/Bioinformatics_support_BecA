##---If there are problems using install.packages(), try solution from https://www.haktansuren.com/installing-r-package-from-the-source/#comment-2604

source("https://bioconductor.org/biocLite.R")
biocLite("cummeRbund")

sourceDir <- function(path, trace = TRUE, ...) {
  for (nm in list.files(path, pattern = "\\.[RrSsQq]$")) {
    if(trace) cat(nm,":")           
    source(file.path(path, nm), ...)
    if(trace) cat("\n")
  }
}

sourceDir('DESeq2/R')
sourceDir('cummeRbund/R')

library(DESeq2)
library(cummeRbund)