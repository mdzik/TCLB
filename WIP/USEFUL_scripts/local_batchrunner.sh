#!/bin/bash
set -e

#this script launches jobs.xml from given dir on local computer

DIRNAME=$1

TCLB_PATH="~/GITHUB/TCLB/CLB"
MODEL="d3q27q7_cm_cht_OutFlowNeumann_IBB"


if test -d $DIRNAME
then
	# cd $DIRNAME
    for i in $DIRNAME/*.xml
    do
    	echo " --- launching job $i --- "
		log_name=$(echo $i | sed 's/$DIRNAME//g' | sed 's/xml/log/g')
		# echo -e $log_name
		eval "CLB/$MODEL/main $i | tee $log_name"
		# eval "CLB/$MODEL/main $i > $log_name 2>&1"
		# sleep 1
		# tsp "CLB/$MODEL/main $i"
    done
else
	echo directory doesnt exists
fi

echo -e "\n\n All jobs from $DIRNAME launched!"

