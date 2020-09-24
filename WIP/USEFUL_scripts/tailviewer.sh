#!/bin/bash
set -e

#this reads tails of all logs from given dir

DIRNAME=$1

if test -d $DIRNAME
then
    for i in $DIRNAME/*.log
    do
    	if test -f $i
		then
			echo "=== reading tail of $i ==="
			grep -nr "Setting output path to: /net/scratch/people/" $i
			tail --lines 5 $i
		else
			echo -e "\n no local logs"
		fi
    done

    for i in $DIRNAME/slurm*
	do
		if test -f $i
		then
			echo "=== reading tail of $j ==="
			grep -nr "Setting output path to: /net/scratch/people/" $i
			tail --lines 5 $i
		else
			echo -e "\n no slurm logs"
		fi
	done
else
	echo directory doesnt exists
fi
