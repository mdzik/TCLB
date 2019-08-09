#!/bin/bash
set -e

# this script calculates sha1sum from .vti files in given dir on local computer
# hashes are used for unit tests

DIRNAME=$1

if test -d $DIRNAME
then
	# cd $DIRNAME
    for i in $DIRNAME/*.vti
    do
    	echo " --- hashing $i --- "
    	sha1sum $i > "$i.sha1"
    	#echo " --- launching job $i --- "
		#log_name=$(echo $i | sed 's/$DIRNAME//g' | sed 's/xml/log/g')
		# echo -e $log_name
		#eval "CLB/$MODEL/main $i | tee $log_name"
		# eval "CLB/$MODEL/main $i > $log_name 2>&1"
		# sleep 1
		# tsp "CLB/$MODEL/main $i"
    done
else
	echo directory doesnt exists
fi

echo -e "\n\n All *vti from $DIRNAME hashed!"
