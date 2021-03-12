#!/bin/bash
hostname
sysctl -n machdep.cpu -N |head -20
date


source ../../setup_conda.source
conda activate unifrac-10


echo "===="
#ssu -n 6 -i unifrac_10000.biom -t unifrac_10000.tre -m unweighted -o unifrac.tmp --mode partial-report
echo "=== weighted_normalized 5k/10k ==="
rm -fr unifrac.tmp

t1=`date +%s`
/usr/bin/time -l ssu -n 6 -m weighted_normalized -f -i unifrac_10000.biom -t unifrac_10000.tre -o unifrac.tmp --mode partial --start 0 --stop 5000
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== weighted_normalized -f time: $dt ==="


