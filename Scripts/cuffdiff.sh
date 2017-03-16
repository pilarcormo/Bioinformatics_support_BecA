#!/bin/bash
#SBATCH -p batch
#SBATCH -n 1 # number of cores

module load cufflinks/2.2.1


FA='genome/Danio_rerio.GRCz10.dna.toplevel.fa'
GFF='genome/Danio_rerio.GRCz10.87.gtf'

mkdir cuffdiff

######################
###STEP 2 - cuffmerge
######################

ls */$OUT/transcripts.gtf > cuffdiff/assemblies.txt
cuffmerge -s $FA -g $GFF -o cuffdiff/merged_asm cuffdiff/assemblies.txt

######################
###STEP 3 - cuffdifff
######################

cuffdiff -L 2cells, 6h  -o cuffdiff cuffdiff/merged.gtf 2_cells/2_cells.bam 6h/6h.bam
