#!/bin/bash 
#SBATCH -p batch
#SBATCH -J trimmomatic 
#SBATCH -n 1

sample=$1 #provide name of the directory containing the reads as an argument

#Usage: sbatch trimmomatic.sh <sample-name>

path="/export/apps/trimmomatic/0.33/"

java -jar $path/trimmomatic-0.33.jar PE -phred33 $sample/*_1.fastq $sample/*_2.fastq $sample/paired_R1.fq $sample/unpaired_R1.fq $sample/paired_R2.fq $sample/unpaired_R2.fq  HEADCROP:14 LEADING:20 TRAILING:20 SLIDINGWINDOW:20:20 MINLEN:20 ILLUMINACLIP:TruSeq-PE.fa:1:20:10
####check quality of trimmed reads:

module load fastqc/0.11.5

fastqc $sample/paired_R1.fq
fastqc $sample/paired_R2.fq
