#!/bin/bash
#SBATCH -p batch
#SBATCH -N 1 # number of nodes
#SBATCH -n 1 # number of cores

module load cufflinks/2.2.1

sample=$1

FA='genome/*.fa'
GFF='genome/*.gtf'
OUT="$sample/cufflinks/"

#####################
###STEP 1 - cufflinks
#####################

BAM="$sample/$sample.bam"

mkdir $OUT
cufflinks -b $FA -G $GFF -o $OUT $BAM


