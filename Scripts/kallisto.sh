#!/bin/bash
#SBATCH -p batch
#SBATCH -J "kallisto"
#SBATCH -n 1

m=$1 #directory where the reads are  

module load kallisto/0.43.0

FA='Reference/*.fa'
R1="/home/pmoreno/Tparva/data/$m/*_R1.fastq"
R2="/home/pmoreno/Tparva/data/$m/*_R2.fastq"

kallisto index -i ref.idx $FA
kallisto quant -i ref.idx -o kallist_$m/ -b 100 $R1 $R2