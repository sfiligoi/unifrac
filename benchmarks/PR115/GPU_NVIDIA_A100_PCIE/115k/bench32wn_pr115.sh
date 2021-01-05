#!/bin/bash -x

export ACC_DEVICE_NUM=0
export OMP_NUM_THREADS=8

md5sum /root/merged_nosingletonsdoubletons_even500_nobloom.biom
md5sum /root/merged_nosingletonsdoubletons_even500_sepp_nobloom_placement.tog.tre

t1=`date +%s`
t0=${t1}
rm -f /dev/shm/emp2_8f.out.0
echo "=== Starting 1/2 `date` ($t1)"
taskset -c 0-7 time ssu --mode partial --start 0 --stop 28480  -i /root/merged_nosingletonsdoubletons_even500_nobloom.biom -t /root/merged_nosingletonsdoubletons_even500_sepp_nobloom_placement.tog.tre -m weighted_normalized_fp32 -n 1 -f -o /dev/shm/emp2_8f.out.0

t2=`date +%s`
echo "=== End 1/2 `date` ($t2)"
let dt=$t2-$t1
echo "Waltime 1: $dt"

ls -l /dev/shm/emp2_8f.out.0

t1=`date +%s`
rm -f /dev/shm/emp2_8f.out.0
echo "=== Starting 2/2 `date` ($t1)"
taskset -c 0-7 time ssu --mode partial --start 28480 --stop 56861   -i /root/merged_nosingletonsdoubletons_even500_nobloom.biom -t /root/merged_nosingletonsdoubletons_even500_sepp_nobloom_placement.tog.tre -m weighted_normalized_fp32 -n 1 -f -o /dev/shm/emp2_8f.out.0

t2=`date +%s`
echo "=== End 2/2 `date` ($t2)"
let dt=$t2-$t1
echo "Waltime 2: $dt"

echo "====== All done ======"
let dt=$t2-$t0
echo "Waltime total: $dt"

ls -l /dev/shm/emp2_8f.out.0
rm -f /dev/shm/emp2_8f.out.0

