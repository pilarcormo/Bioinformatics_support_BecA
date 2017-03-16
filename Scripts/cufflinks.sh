#!/bin/bash
#SBATCH -p batch
#SBATCH -N 1 # number of nodes
#SBATCH -n 1 # number of cores

module load cufflinks/2.2.1

sample=$1

FA='genome/Danio_rerio.GRCz10.dna.toplevel.fa'
GFF='genome/Danio_rerio.GRCz10.87.gtf'
OUT="$sample/cufflinks/"

#####################
###STEP 1 - cufflinks
#####################

BAM="$sample/$sample.bam"

mkdir $OUT
cufflinks -b $FA -G $GFF -o $OUT $BAM


