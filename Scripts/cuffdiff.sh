#!/bin/bash
#SBATCH -p batch
#SBATCH -n 1 # number of cores

module load cufflinks/2.2.1


FA='genome/*.fa'
GFF='genome/*.gtf'

mkdir cuffdiff

######################
###STEP 2 - cuffmerge
######################

ls */cufflinks/transcripts.gtf > cuffdiff/assemblies.txt
cuffmerge -s $FA -g $GFF -o cuffdiff/merged_asm cuffdiff/assemblies.txt

######################
###STEP 3 - cuffdifff
######################

cuffdiff -L 2cells, 6h  -o cuffdiff cuffdiff/merged.gtf 2_cells/2_cells.bam 6h/6h.bam
