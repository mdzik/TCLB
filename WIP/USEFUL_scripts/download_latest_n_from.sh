# #!/bin/bash
# set -e


# #######################################################
# #                       README
# # to see OS environment variables from script,
# # put them in ~/.profile
# #
# #######################################################

# #this script downloads n latest outputs from given batch

# # CMD='ssh someone@host ls -l \$SCRATCH '


# MAIN_BATCH_FOLDER="output/batch_HotKarman3D_CM_HIGHER"
# CMD='ssh ${PRO_USER}@${PRO_HOST} ls \$SCRATCH/${MAIN_BATCH_FOLDER}'

# OUTPUT_FOLDER_LIST="folder_list.txt"
# echo "executing ${CMD}"
# # eval "${CMD}" > $OUTPUT_FOLDER_LIST

# cat $OUTPUT_FOLDER_LIST


# # echo $CMD
# # echo ssh "${PRO_USER}@${PRO_HOST} ls -l ${PRO_SCRATCH}"
# # echo ssh "${PRO_USER}@${PRO_HOST}:${PRO_SCRATCH}"

# # ls -lt keep_nu_and_k_sizer_2_Re10_Pr1000 | head -20 | grep "_P\([0-9]\)\{2\}_"



# ssh ${PRO_USER}@${PRO_HOST} <<'ENDSSH'
# ITERATIONS_TO_DOWNLOAD="3"
# cd $SCRATCH/output/batch_HotKarman3D_CM_HIGHER
# for D in *; do
#     if [ -d "${D}" ]; then
#         #ls -lt ${D} | head -40 | grep -oh "_P\([0-9]\)\{2\}_" | grep -oh "\([0-9]\)\{2\}" | sort | tail -1 | sed 's/^0*//'
#         N_CORES=$(ls -lt ${D} | head -40 | grep -oh "_P\([0-9]\)\{2\}_" | grep -oh "\([0-9]\)\{2\}" | sort | tail -1 | sed 's/00//') 
#         #TODO add 1 as counting starts from 0 ;p
#         echo "case ${D} was run on ${N_CORES} cores."  
#         VTI_FILES_TO_DOWNLOAD=$(($ITERATIONS_TO_DOWNLOAD * $N_CORES ))
#         # echo "there are ${VTI_FILES_TO_DOWNLOAD} .vti files to download"
#         # ls -l ${D}/*vti | head $VTI_FILES_TO_DOWNLOAD
#         echo -e "\n"
#     fi
# done
# ENDSSH

# # eval 'ssh ${PRO_USER}@${PRO_HOST}'
# # pwd
# # eval 'cd $SCRATCH'

# # get last (time) n outputs, and find the highest processor index i.e., how many cores were assigned to this job
# CASE_FOLDER="keep_nu_and_k_sizer_2_Re10_Pr1000"
# #ls -lt ${MAIN_FOLDER} | head -40 | grep -oh "_P\([0-9]\)\{2\}_" | grep -oh "\([0-9]\)\{2\}" | sort | tail -1 | sed 's/^0*//'




#!/bin/bash


# for d in $(find $FOLDER -type d)
# do
# 	f=$(find $d/ -type f -name '*.vti' | sort | tail -n 10 )
#     echo $f
# 	# cp  -v $f $(echo $f | sed 's/P00/P00_last/g' )
# done


# CASE_FOLDER="keep_nu_and_k_sizer_2_Re10_Pr1000"
# ls -lt ${FOLDER} | head -40 | grep -oh "_P\([0-9]\)\{2\}_" | sort | tail -5 
# # for d in $(find $FOLDER -type d -name '*output')



ssh ${PRO_USER}@${PRO_HOST} <<'ENDSSH'
FOLDER="${SCRATCH}/output/batch_HotKarman_Re1000/batch_HotKarman_Re1000_D0_1.28e+02_nu_0.003_U_2.34e-02_2nd_order_bc_Cumulants"


LOG_NAME="to_download.txt"
rm $LOG_NAME
for d in $(find $FOLDER -type d)
do
    #for i in {1..12}
    for i in 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16
    do 
        pattern="_P${i}_"
        # echo $pattern
        f=$(find $d/ -type f -name "*${pattern}*vti" | sort | tail -n 1 )  # tail -n 2 to get both .vti and .pvti
        # echo $f
        if test ! -z "$f" 
        then
            # echo "\$f is NOT empty"
            echo -e "$f" >> $LOG_NAME
            # echo $f | sed "s/$pattern/${pattern}last_/g" >> $LOG_NAME
            # cp -v $f $(echo $f | sed "s/$pattern/${pattern}last_/g")       
            # else
             # echo "\$f is empty"
        fi
    done 
done
ENDSSH


echo "Getting file list to be downloaded"
rsync -avzhe ssh --progress ${PRO_USER}@${PRO_HOST}:/net/people/${PRO_USER}/to_download.txt .
