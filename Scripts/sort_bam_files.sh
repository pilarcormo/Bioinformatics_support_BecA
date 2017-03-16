#!/bin/bash
#SBATCH -p batch
#SBATCH -J bam_files
#SBATCH -n 1

sample=$1

module load samtools/1.3.1

samtools sort $sample/top_hat/accepted_hits.bam -o $sample/$sample.bam
samtools index $sample/$sample.bam
