#!/bin/bash
set -e

DIRNAME=$1

if test -d $DIRNAME
then
	for input in $DIRNAME/*.{jpg,bmp}
	do	
		output=$(echo "$input" | sed "s/bmp/jpg/g")
		echo " --- parsing $input to  $output --- "		
		convert -trim $input $output
	done
	
	echo -e "\n\n All files from $DIRNAME parsed!"
else
	echo directory doesnt exists
fi


