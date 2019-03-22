
for i in slurm*
do
	echo "=== reading tail of $i ==="
	tail --lines 5 $i
done

