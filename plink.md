###1. Obtain .map and .ped for PLINK 1.9 

1) Fix truncated columns

2) Change genotype names to ID number

3) Remove final rows with no chr or pos information

4) Make 2 columns per genotype in ped file. From AA to A	A 

5) Fix duplicate genotypes names by add .1 to the repeated ones. 


###2. Create phenotype file

- Include phenotype : FID has to match between external phenotype file and ped file (0 for all of them works)


###3. Filtering 

Remove bad SNPs and individuals. Change the following numbers for a more or less restrictive filtering. 

- Remove individuals that have less than  for example 95% genotype data (--mind 0.05). This will remove the genotypes/individuals that have missing data (NN) for 5% of the positions. 

- Remove rare SNPs that have less 1% minor allele frequencies (--maf 0.01). This command will remove SNPs if the second most common allele occuring in the population is present in less than 1% of the genotypes/individuals

- Remove SNPs that have less < 90% genotype call rate or >10% genotype error rate (--geno 0.1). In order words, remove loci (SNPs) that do not have at least 90% of data from all the individuals.    ```
plink --bfile data --pheno pheno.txt --allow-no-sex --mind 0.05 --geno 0.1 --maf 0.05 --hwe 0.001 --out qc_fb_phe --make-bed --recode
```###4. Association study

```plink --bfile data -–assoc --allow-no-sex```
It will only take the first column of phenotypic data (Dmg_Rating)In R:
```library(qqman)
c <- read.table("~/plink.qassoc", header = TRUE)
manhattan(c, cex=0.8, col=c("blue4", "orange3"))```

