### 1. Obtain .map and .ped for PLINK 1.9 

1) Fix truncated columns

2) Change genotype names to ID number

3) Remove final rows with no chr or pos information

4) Make 2 columns per genotype in ped file. From AA to A	A 

5) Fix duplicate genotypes names by add .1 to the repeated ones. 


### 2. Create phenotype file

- Include phenotype : FID has to match between external phenotype file and ped file (0 for all of them works)


### 3. Filtering 

Remove bad SNPs and individuals. Change the following numbers for a more or less restrictive filtering. 

- Remove individuals that have less than  for example 95% genotype data (--mind 0.05). This will remove the genotypes/individuals that have missing data (NN) for 5% of the positions. 

- Remove rare SNPs that have less 1% minor allele frequencies (--maf 0.01). This command will remove SNPs if the second most common allele occuring in the population is present in less than 1% of the genotypes/individuals

- Remove SNPs that have less < 90% genotype call rate or >10% genotype error rate (--geno 0.1). In order words, remove loci (SNPs) that do not have at least 90% of data from all the individuals.    ```
plink --bfile data --pheno pheno.txt --allow-no-sex --mind 0.05 --geno 0.1 --maf 0.05 --hwe 0.001 --out qc_fb_phe --make-bed --recode
```### 4. Association study

```plink --bfile data -–assoc --allow-no-sex```


It will only take the first column of phenotypic data.To add another column in the pheno file that is not the first one, we can use the name of the column: ```
plink --bfile <data> --pheno pheno.txt –pheno-name <col2> --out <include_phe> --make-bed –recode```In R:
```library(qqman)
c <- read.table("~/plink.qassoc", header = TRUE)
manhattan(c, cex=0.8, col=c("blue4", "orange3"))```
### 5. Population structure 

##### 5.1 PCA

```
plink  --bfile data --pca --out pca
```



Run []()

##### 5.2 MDS
```
plink --bfile data --cluster --mds-plot 4 –out mds
```

##### 5.3 Structure

[Lizards-are-awesome](https://github.com/furious-luke/lizards-are-awesome) is a Docker workflow that takes a csv file of DartSeq data and generates a set of plink files and then runs fastStructure to identify populations structure. You'd need to install [Docker](https://docs.docker.com/engine/installation/) 

```
wget https://github.com/furious-luke/lizards-are-awesome
pip install lizards-are-awesome
sudo laa init
```
- Run fastStructure for k=2```laa fast <plink file> strout 2
```- Run fastStructore from k=1 to k=10
```for k in {1..10}do	echo "Running fastStructure with k = $k"	laa fast <plink file> strout $kdone 
```
- Tell fastStructure to find the most probably value of k
```laa choosek eucalypt eucalypt.out --maxk=7
```

##### 5.3 Tree 

```
plink --bfile data --distance square --out tree
```

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