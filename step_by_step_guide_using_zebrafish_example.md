### Step by step guide using Zebrafish example 

Example data from [EBI training course](https://www.ebi.ac.uk/training/online/course/ebi-next-generation-sequencing-practical-course/rna-sequencing/rna-seq-analysis-transcriptome)


1. Connect to the HPC

	``ssh <username>@hpc.ilri.cgiar.org``
2. Make directory for project
 
	``mkdir Zebrafish``
	
	``cd Zebrafish``
3. Make 1 directory per sample

	``mkdir 2_cells``
	
	``mkdir 6h ``
	
	``...``
	
4. Move reads to the directory

	If PE reads: 	

	``mv 2cells_1.fastq 2_cells``
		
	``mv 2cells_2.fastq 2_cells``
		
	``mv 6h_1.fastq 6h``
		
	``mv 6h_2.fastq 6h``
		
3. Make sure the following scripts are in the project directory (Zebrafish)

	```
	[pmoreno@hpc Zebra]$ ls
	2_cells  cuffdiff.sh   fastqc.sh  htseq.sh sort_bam_files.sh  trimmomatic.sh
	6h cufflinks.sh genome index_reference.sh top_hat.sh
	```


6. Create directory for genome and move files inside 

	``mkdir genome``


	```
	[pmoreno@hpc Zebra]$ ls genome
	Danio_rerio.GRCz10.87.gtf  Danio_rerio.GRCz10.dna.toplevel.fa
	```

7. Fastqc

	``sbatch fastqc.sh 2_cells``
	
	``sbatch fastqc.sh 6h``
	
	Download  and check on browser 2cells_1_fastqc.html, 2cells_2_fastqc.html, 6h_1_fastqc.html,6h_2_fastqc.html 


8. Trimmomatic 

	``sbacth trimmomatic.sh 2_cells``

	``sbacth trimmomatic.sh 6h``


	Download  and check on browser 2_cells/paired_R1_fastqc.html, 2_cells/paired_R2_fastqc.html, 6h/paired_R1_fastqc.html,6h/paired_R2_fastqc.html 

9. Index reference 

	``sbatch index_reference.sh``

10. Run alignment using tophat

	``sbatch top_hat.sh 2_cells``

	``sbatch top_hat.sh 6h``

11. Check % of mapped reads

	``less 2_cells/top_hat/align_summary.txt``

	``less 6h/top_hat/align_summary.txt``

12. Sort and index bam files 

	``sbatch sort_bam_files.sh 2_cells``

	``sbatch sort_bam_files.sh 6h``

13. Run Htseq to quantify transcripts

	``sbatch htseq.sh 2_cells``

	``sbatch htseq.sh 6h``

14. Make joined htseq file and  and separate

	``join 2_cells/2_cells.htseq.txt 6h/6h.htseq.txt > merge_htseq.txt``

15. Add names of samples to htseq file 	
	``sed -i '1s/^/genes 2_cells 6h \n/' merge_htseq.txt``

16. Separate columns by tabs
	``tr ' ' '\t' < merge_htseq.txt > merge_htseq_tab.txt``

14. **OR** run Cufflinks to quantify transcripts

	``sbatch cufflinks.sh 2_cells``	

	``sbatch cufflinks.sh 6h``

15. Run cuffdiff to find genes differentially expressed

	``sbatch cuffdiff.sh``


### Useful commands to remember

``sacct`` -  to check if job is running/failed/completed

If failed, open the output slurm file: 

``less slurm_<jobID>.out``










