#!/bin/bash


for sz in 150; do 

let szfull=1000*sz
let stripes=500*sz

echo "==== Size ${sz}k"

for itr in 0 1 2 3 4 5 6 7 8 9; do

fnameb=/panfs/panfs1.ucsd.edu/panscratch/isfiligoi/dev/t8/inputs/new/samples-${szfull}-iteration-${itr}

echo "==== Processing ${fnameb}"
echo "=== Size: ${szfull} Iteration: ${itr} ==="
md5sum ${fnameb}.biom
md5sum ${fnameb}.tre
../../dev/t5/unifrac/sucpp/ssu -i ${fnameb}.biom -t ${fnameb}.tre -m unweighted_fp32 -o /dev/shm/unifrac.tmp --mode partial-report
../../dev/t5/unifrac/sucpp/ssu -i ${fnameb}.biom -t ${fnameb}.tre -m unweighted_fp32 -o /dev/shm/unifrac.tmp --mode partial --start 0 --stop 1
rm -f /dev/shm/unifrac.tmp

done
 
done

