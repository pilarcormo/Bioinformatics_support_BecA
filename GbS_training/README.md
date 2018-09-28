### 1. Obtain .map and .ped for PLINK 1.9 

###### ped file (1st to 6th columns + columns for SNP genotypes):







See [how to create a ped file](https://github.com/pilarcormo/Bioinformatics_support_BecA/blob/master/Plink_training/Plink_input/make_ped.md)






### 2. Create phenotype file

**Important**: make sure that your phenotype file has information for all the genoytpes included in the .ped file. In other words, they need to have the same number of columns 





### 3. Filtering 

Remove bad SNPs and individuals. Change the following numbers for a more or less restrictive filtering. 

- Remove individuals that have less than  for example 95% genotype data (--mind 0.05). This will remove the genotypes/individuals that have missing data (NN) for 5% of the positions. 

- Remove rare SNPs that have less 1% minor allele frequencies (--maf 0.01). This command will remove SNPs if the second most common allele occuring in the population is present in less than 1% of the genotypes/individuals

- Remove SNPs that have less < 90% genotype call rate or >10% genotype error rate (--geno 0.1). In order words, remove loci (SNPs) that do not have at least 90% of data from all the individuals.    
plink --bfile data --pheno pheno.txt --allow-no-sex --mind 0.05 --geno 0.1 --maf 0.05 --hwe 0.001 --out qc_fb_phe --make-bed --recode
```

```


It will only take the first column of phenotypic data.To add another column in the pheno file that is not the first one, we can use the name of the column: 
plink --bfile <data> --pheno pheno.txt –pheno-name <col2> --out <include_phe> --make-bed –recode

c <- read.table("~/plink.qassoc", header = TRUE)
manhattan(c, cex=0.8, col=c("blue4", "orange3"))
### 5. Population structure 

##### 5.1 PCA

```
plink  --bfile data --pca --out pca
```

In R, run the PCA part in [pop_structure.R](https://github.com/pilarcormo/Bioinformatics_support_BecA/blob/master/R-scripts/pop_structure.R)

##### 5.2 MDS
```
plink --bfile data --cluster --mds-plot 4 –out mds
```
In R, run the MDS part in in [pop_structure.R](https://github.com/pilarcormo/Bioinformatics_support_BecA/blob/master/R-scripts/pop_structure.R)

##### 5.3 Structure

[Lizards-are-awesome](https://github.com/furious-luke/lizards-are-awesome) is a Docker workflow that takes a csv file of DartSeq data and generates a set of plink files and then runs fastStructure to identify populations structure. You'd need to install [Docker](https://docs.docker.com/engine/installation/) 

```
wget https://github.com/furious-luke/lizards-are-awesome
pip install lizards-are-awesome
sudo laa init
```









##### 5.3 Tree 

```
plink --bfile data --distance square --out tree
```

Add names of genotypes to the output matrix twice (first column and first line). Create a file with the names of the populations and the genoytpes:

```
awk '{print $1, $2}' <data.ped> > pop_ID.txt 
```

Then run the tree part in in [pop_structure.R](https://github.com/pilarcormo/Bioinformatics_support_BecA/blob/master/R-scripts/pop_structure.R)

##### 5.4 Fst

```
plink --file data --fst --within within.txt --out temp 
```

To perform pairwise comparisons between all the populations, run [runFst.sh](runFst.sh). Before running, edit the name of the input plink file and the populations

1. Change name of the input plink file 

	```
	data="plink.clean"
	```
2. Add names of populations for output 

	```
	output=$'id\pop1\pop2\pop3\pop4\n'
	```
	
3. Add names of populations for first and second one to iterate in loop

	```
	for first in pop1 pop2 pop3 pop4
	do
        output="$output$first"
        for second in pop1 pop2 pop3 pop4
	...
	```

Then, 

```
sh runFst.sh
```

In R, run in the part about Fst in [pop_structure.R](https://github.com/pilarcormo/Bioinformatics_support_BecA/blob/master/R-scripts/pop_structure.R)