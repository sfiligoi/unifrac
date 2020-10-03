#!/bin/bash -x
#SBATCH --time 24:00:00 -p gpu --exclusive

export ACC_DEVICE_NUM=4
export OMP_NUM_THREADS=8

md5sum /data/unifrac/merged_nosingletonsdoubletons_even500_nobloom.biom
md5sum /data/unifrac/merged_nosingletonsdoubletons_even500_sepp_nobloom_placement.tog.tre


/root/unifrac/sucpp/ssu --mode partial-report -i /data/unifrac/merged_nosingletonsdoubletons_even500_nobloom.biom -t /data/unifrac/merged_nosingletonsdoubletons_even500_sepp_nobloom_placement.tog.tre -m unweighted_fp32 -f

t1=`date +%s`
t0=${t1}
rm -f /oot/emp115_8f.out.0
echo "=== Starting 1/4 `date` ($t1)"
taskset -c 0-7 time /root/unifrac/sucpp/ssu --mode partial --start 0 --stop 14400  -i /data/unifrac/merged_nosingletonsdoubletons_even500_nobloom.biom -t /data/unifrac/merged_nosingletonsdoubletons_even500_sepp_nobloom_placement.tog.tre -m unweighted_fp32 -n 1 -f -o /root/emp2_8f.out.0

t2=`date +%s`
echo "=== End 1/4 `date` ($t2)"
let dt=$t2-$t1
echo "Waltime 1: $dt"

ls -l /root/emp115_8f.out.0


t1=`date +%s`
rm -f /root/emp115_8f.out.0
echo "=== Starting 2/4 `date` ($t1)"
taskset -c 0-7 time /root/unifrac/sucpp/ssu --mode partial --start 14400 --stop 28800  -i /data/unifrac/merged_nosingletonsdoubletons_even500_nobloom.biom -t /data/unifrac/merged_nosingletonsdoubletons_even500_sepp_nobloom_placement.tog.tre -m unweighted_fp32 -n 1 -f -o /root/emp2_8f.out.0

t2=`date +%s`
echo "=== End 2/4 `date` ($t2)"
let dt=$t2-$t1
echo "Waltime 1: $dt"

ls -l /root/emp115_8f.out.0

t1=`date +%s`
rm -f /root/emp115_8f.out.0
echo "=== Starting 3/4 `date` ($t1)"
taskset -c 0-7 time /root/unifrac/sucpp/ssu --mode partial --start 28800 --stop 43200  -i /data/unifrac/merged_nosingletonsdoubletons_even500_nobloom.biom -t /data/unifrac/merged_nosingletonsdoubletons_even500_sepp_nobloom_placement.tog.tre -m unweighted_fp32 -n 1 -f -o /root/emp2_8f.out.0

t2=`date +%s`
echo "=== End 3/4 `date` ($t2)"
let dt=$t2-$t1
echo "Waltime 1: $dt"

ls -l /root/emp115_8f.out.0

t1=`date +%s`
rm -f /dev/shm/emp2_8f.out.0
echo "=== Starting 4/4 `date` ($t1)"
taskset -c 0-7 time /root/unifrac/sucpp/ssu --mode partial --start 43200 --stop 56861   -i /data/unifrac/merged_nosingletonsdoubletons_even500_nobloom.biom -t /data/unifrac/merged_nosingletonsdoubletons_even500_sepp_nobloom_placement.tog.tre -m unweighted_fp32 -n 1 -f -o /root/emp115_8f.out.0

t2=`date +%s`
echo "=== End 4/4 `date` ($t2)"
let dt=$t2-$t1
echo "Waltime 2: $dt"

echo "====== All done ======"
let dt=$t2-$t0
echo "Waltime total: $dt"

ls -l /root/emp115_8f.out.0
rm -f /root/emp115_8f.out.0

