#!/bin/bash 
#SBATCH -p batch
#SBATCH -J fastqc
#SBATCH -n 1

sample=$1 #provide name of the directory containing the reads as an argument

#Usage: sbatch fastqc.sh <sample-name>

module load fastqc/0.11.5

fastqc $sample/*1.fastq
fastqc $sample/*2.fastq

