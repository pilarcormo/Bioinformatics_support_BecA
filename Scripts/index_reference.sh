#!/bin/bash
#SBATCH -p batch
#SBATCH -J index
#SBATCH -n 1


module load bowtie2/2.2.8	

Ref='genome/*.fa'

bowtie2-build $Ref Zebra_dna
