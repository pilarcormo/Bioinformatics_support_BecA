#### Blast unmapped reads from Kallisto

1. Get unmapped reads from Kallisto

	```
	kallisto quant -i index -o out --pseudobam r1.fastq r2.fastq | samtools view -S -f 12 > unmapped.sam
	```

2. Sam to bam

	```
	samtools -view Sb unmapped.sam > unmapped.bam
	```

3. Bam to fq

	```
	module load bedtools/2.25.0
	bamToFastq -i unmapped.bam -fq unmapped.fq
	```

4. fq to fa:

	```
	awk 'NR % 4 == 1 {print ">" $0 } NR % 4 == 2 {print $0}' unmapped.fq > unmapped.fa
	```


5. Run blastn - get only best hit 

	```
	blastn -perc_identity 100 -db nr -query unmapped.fa -outfmt '6 qseqid sseqid evalue bitscore sgi sacc staxids sscinames scomnames stitle' -remote -out blast_besthit.	out -max_target_seqs 1
	```

6. Get only species names in output

	```
	sed 's/PREDICTED://g' blast_besthit.out > blast_unmapped.	out
	awk '{print $10, $11}' blast_unmapped.out > 	blast_unmapped_only_names.out
	sed 's/ /_/g' blast_unmapped_only_names.out > 	blast_unmapped_only_names_.txt
	```

7. Plot bar chart in R using [blast_output_barchart.R](https://github.com/pilarcormo/Bioinformatics_support_BecA/blob/master/R-scripts/blast_output_barchart.R)

8. Get gene description for a particular subgroup (Theileria genre)

	```
	grep "Theileria" blast_besthit.out | awk '{print $10, $11, $12, $13, $14, $15, $16}' - > Theileria_unmapped.out
	```

9. Get file with counts using R 

	```
	data <- read.table("Theileria_unmapped.out")
	counts <- table(data)
	t<- data.frame(table(data))
	order <- t[order(t$Freq),] 
	df2 <- data.frame(order$data, order$Freq)
	write.csv(df2, "blast.csv", quote=FALSE)
	```

10. Run [count_unmapped.rb](https://github.com/pilarcormo/Bioinformatics_support_BecA/blob/master/Scripts/count_unmapped.rb) to get a final csv file with counts for the unmapped genes in several samples 

