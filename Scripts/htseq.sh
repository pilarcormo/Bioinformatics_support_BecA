#!/bin/bash
#SBATCH -p batch
#SBATCH -n 1 # number of cores

module load htseq/0.6.1
module load samtools/1.3.1

sample=$1

BAM="$sample/$sample.bam"

SAM="$sample/$sample.sam"
GFF="genome/Danio_rerio.GRCz10.87.gtf"

####First run #samtools to convert the BAM files to SAM
samtools view -h $BAM > $SAM

####Then run htseq-count
htseq-count -s no $SAM $GFF > $sample/$sample.htseq.txt


