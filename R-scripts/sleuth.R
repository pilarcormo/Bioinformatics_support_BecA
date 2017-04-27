
# source("http://bioconductor.org/biocLite.R")
# biocLite("rhdf5")
# install.packages("devtools")
# devtools::install_github("pachterlab/sleuth")

library('sleuth')

setwd("Kallisto_output")
directory <- "Kallisto_output"


libs <- grep("kallisto_s", list.files(directory),value=T)

kal_dirs <- sapply(libs, function(id) file.path(directory, id))


s2c <- read.table(file.path(directory, "hiseq_info.txt"), header = TRUE, stringsAsFactors=FALSE)
s2c <- dplyr::select(s2c, sample = run_accession, condition)

s2c <- dplyr::mutate(s2c, path = kal_dirs)

########
so <- sleuth_prep(s2c, ~ condition)
so <- sleuth_wt(so, 'condition') ##condition=name of the condition
so <- sleuth_fit(so)
so <- sleuth_fit(so, ~1, 'reduced')

so <- sleuth_lrt(so, 'reduced', 'full')
sleuth_live(so)

plot_transcript_heatmap(so, transcripts, units = "tpm", trans = "log",offset = 1) # transcripts is a list of transcripts to include in the heatmap 

res <- sleuth_results(so, 'reduced:full', test_type = 'ltr')

#####################
######---Up and down regulated genes for a specific condition (cond1)
#####################

so <- sleuth_wt(so, 'cond1') #cond1 = one condition in the study 
r<-sleuth_results(so, 'cond1', test_type = "wt", which_model = "full", rename_cols = TRUE, show_all = TRUE)

upregulated = subset(r, qval < 0.01 & b > 0)
downregulated = subset(r, qval < 0.01 & b < 0)

write.csv(upregulated, "upregulated.csv", quote=FALSE)
write.csv(downregulated, "downregulated.csv", quote=FALSE)


#####################
#pairwise comparison#
#####################
  
cond1 <- which(s2c$condition == "cond1")
cond2 <- which(s2c$condition == "cond2")
s2c_cond1vscond2 <- s2c[c(cond1, cond2),]

so<-sleuth_prep(s2c_cond1vscond2, ~condition)
so <- sleuth_fit(so)
so <- sleuth_fit(so, ~1, 'reduced')

so <- sleuth_lrt(so, 'reduced', 'full')
r<-sleuth_results(so, 'reduced:full', test_type = 'lrt')
r_filtered <- subset(r, r$qval < 0.01)
