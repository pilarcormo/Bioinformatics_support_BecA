1. Transpose file 
	```cat data.tab | awk -f transpose.awk > datat.ped```
2. Replace NN by OO

	```sed 's/NN/00/g' datat.ped > data_n.ped```
3. Make 2 columns per genotype 

	```comp_geno.sh data_n.ped > data.ped```
