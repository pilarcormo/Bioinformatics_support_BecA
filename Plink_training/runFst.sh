#put the filename in a variable so that it is easy to change all instances of it
eucalypt="beanfly.mot.clean3"

#output=$'id\tbh br\tcr\tdr\tkh\tlj\tlr\tqv\trt\n'
output=$'id\tBF_A\tBF_M\tBL_A\tBL_M\tCR_A\tCR_M\tMM_A\tMW_A\tMW_M\tOT_M\tPP_A\tRD_A\tRD_M\tRM_A\tRS_A\tWT_A\tWT_M\n'

#This is a messy way to code for a newline character
nl=$'\n'
#Beginning of first loop to iterate over all populations
for first in BF_A BF_M BL_A BL_M CR_A CR_M MM_A MW_A MW_M OT_M PP_A RD_A RD_M RM_A RS_A WT_A WT_M
do
        #add id in first column of output
        output="$output$first"

        #Beginning of second loop to go over all populations in each population in first loop
        for second in BF_A BF_M BL_A BL_M CR_A CR_M MM_A MW_A MW_M OT_M PP_A RD_A RD_M RM_A RS_A WT_A WT_M
        do
                # When a variable is set to a value it does not have a dollar sign
                # but when we want to get the value from it we use the dollar sign.

                grep $first ${eucalypt}.ped | awk '{print $1, $2, $1}'  > within_$first_$second.txt
                grep $second ${eucalypt}.ped | awk '{print $1, $2,$1}' >> within_$first_$second.txt

                fst=0

  							#if we are comparing the same populations we will get an error message so cannot use those pairs
                				#linux scripts are particular about spaces, make sure you enter them exactly as here
                if [ "$first" != "$second" ]
                then
                        ./plink --file $eucalypt --fst --within within_$first_$second.txt --allow-no-sex --out temp
                        # we use back ticks ` to get the script to return the output of the command to the variable
                        fst=`grep "Mean Fst estimate:" temp.log | awk '{print $4}' `
                fi
                output="$output $fst"
        done
        #Add a carriage return to the output at the end of each loop
        output="$output$nl"
done

#print all the results to a file
echo $output
echo "$output" > "fst_matrix.txt"

