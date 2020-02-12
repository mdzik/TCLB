# #!/bin/bash
# set -e


# #######################################################
# #                       README
# # to see OS environment variables from script,
# # put them in ~/.profile
# #
# #######################################################

# #this script downloads first/latest output from the given folder, recursively

ssh ${PRO_USER}@${PRO_HOST} <<'ENDSSH'
FOLDER="${SCRATCH}/output/batch_HotKarman_Re10_sizer*/"

LOG_NAME="to_download.txt"
rm $LOG_NAME
for d in $(find $FOLDER -type d)
do
    for i in 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16
    do 
        for extension in .vti .pvti .xml
        do
            pattern="_P${i}_"
            # echo $pattern

            f_xml=$(find $d/ -type f -name "*${pattern}*${extension}" | sort | head -n 1 ) 

            f_vti_heads=$(find $d/ -type f -name "*${pattern}*${extension}" | sort | head -n 1 ) 
            f_vti_tails=$(find $d/ -type f -name "*${pattern}*${extension}" | sort | tail -n 1 )  
            # echo $f_vti_tails

            if test ! -z "$f_vti_tails" 
            then
                echo -e "$f_vti_tails" >> $LOG_NAME
                echo -e "$f_vti_heads" >> $LOG_NAME

                # echo $f_vti_tails | sed "s/$pattern/${pattern}last_/g" >> $LOG_NAME
                # cp -v $f_vti_tails $(echo $f_vti_tails | sed "s/$pattern/${pattern}last_/g")       
            fi
        done
    done 

    for extension in .csv 
    do
        pattern="_P00_"
        f_csv=$(find $d/ -type f -name "*${pattern}*${extension}" | sort | tail -n 1 )  
        if test ! -z "$f_csv" 
        then
            echo -e "$f_csv" >> $LOG_NAME     
        fi
    done
done
ENDSSH


echo -e "\n=== Getting file list to be downloaded ==="
rsync -avzhe ssh --progress ${PRO_USER}@${PRO_HOST}:/net/people/${PRO_USER}/to_download.txt .

echo -e "\n=== Downloading the files ==="
# rsync -avzhe ssh --progress --stats --files-from=to_download.txt ${PRO_USER}@${PRO_HOST}:/ $HOME/Desktop/sshfsPrometheus/tmp/



# from rsync help:
# -c, --checksum              skip based on checksum, not mod-time & size
# -z, --compress              compress file data during the transfer
# -v, --verbose
# -e                          to specify any remote shell you like

# -a, --archive               archive mode; equals -rlptgoD (no -H,-A,-X)
# which preserves time stamps, 
# performs a recursive copy, keeps all file and directory permissions, 
# preserves owner and group information, and copies any symbolic links.

