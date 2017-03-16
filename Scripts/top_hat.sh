#!/bin/bash
#SBATCH -p batch
#SBATCH -J tophat
#SBATCH -n 1

#Usage: sbatch top_hat.sh <sample_name> 

sample=$1 

module load bowtie2/2.2.8	
module load tophat2/2.1.0
module load samtools/1.3.1

Ref='genome/Zebra_dna'


R1="$sample/*_1.fastq"
R2="$sample/*_2.fastq"

mkdir $sample/top_hat
tophat -r 200 -o $sample/top_hat $Ref $R1 $R2
