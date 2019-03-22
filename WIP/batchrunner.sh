#!/bin/bash
set -e

#this script launches jobs.xml from given dir

DIRNAME=$1

MODEL="d2q9_cm_heat"

if test -d $DIRNAME
then
    for i in $DIRNAME*.xml
    do
        # echo -e "\n Launching $i !"
        eval "p/run $MODEL $i 4 --time=4:00:00"
    done
else
	echo directory doesnt exists
fi

echo -e "\n All jobs from $DIRNAME launched!"
