#!/bin/bash
set -e

#this script launches jobs.xml from given dir

DIRNAME=$1

MODEL="d3q27q27_cm_cht_OutFlowNeumann_AVG_IBB"

if test -d $DIRNAME
then
    for i in $DIRNAME*.xml
    do
        # echo -e "\n Launching $i !"
        eval "p/run $MODEL $i 8 --time=24:00:00"
    done
else
	echo directory doesnt exists
fi

echo -e "\n All jobs from $DIRNAME launched!"
