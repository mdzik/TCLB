#!/bin/bash
set -e

# this renames all output files from  simulation. 
# Next, it corrects the names in .pvti files.


while getopts d:r:p: option 
do 
 case "${option}" 
 in 
 d) DIRNAME=${OPTARG};; 
 r) Re=${OPTARG};; 
 p) Pr=${OPTARG};; 
 esac 
done 
 

echo "Re:"$Re 
echo "Pr:"$Pr
echo "DIRNAME:"=$DIRNAME
#Re="10"
#Pr="100"

if test -d $DIRNAME
then
	for input in $DIRNAME/*.pvti
	do
		echo " --- parsing $input --- "
		#log_name=$(echo $i | sed 's/$DIRNAME//g' | sed 's/xml/log/g')
		# sed -i 's/old-text/new-text/g' input
		#sed "s/nu_0\.[0-9]*_k_0\.[0-9]*/Re"$Re"_Pr"$Pr"/" $input #Print only
		sed -i "s/nu_0\.[0-9]*_k_0\.[0-9]*/Re"$Re"_Pr"$Pr"/" $input
	done
	
	cd  $DIRNAME/
		rename -f "s/nu_0\.[0-9]*_k_0\.[0-9]*/Re"$Re"_Pr"$Pr"/" *
	cd ..
	#rename -f "s/nu_0\.[0-9]*_k_0\.[0-9]*/Re"$Re"_Pr"$Pr"/" $DIRNAME/*
	echo -e "\n\n All files from $DIRNAME parsed!"
else
	echo directory doesnt exists
fi



#rename -f 's/nu_0.03_k_0.003/Re10_Pr10/' *

