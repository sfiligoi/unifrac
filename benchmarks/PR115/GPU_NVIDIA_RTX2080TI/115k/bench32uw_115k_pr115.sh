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
echo "=== Starting 1/6 `date` ($t1)"
taskset -c 20-27 time /root/unifrac/sucpp/ssu --mode partial --start 0 --stop 9600  -i /data/unifrac/merged_nosingletonsdoubletons_even500_nobloom.biom -t /data/unifrac/merged_nosingletonsdoubletons_even500_sepp_nobloom_placement.tog.tre -m unweighted_fp32 -n 1 -f -o /root/emp2_8f.out.0

t2=`date +%s`
echo "=== End 1/6 `date` ($t2)"
let dt=$t2-$t1
echo "Waltime 1: $dt"

ls -l /root/emp115_8f.out.0


t1=`date +%s`
rm -f /root/emp115_8f.out.0
echo "=== Starting 2/6 `date` ($t1)"
taskset -c 20-27 time /root/unifrac/sucpp/ssu --mode partial --start 9600 --stop 19200  -i /data/unifrac/merged_nosingletonsdoubletons_even500_nobloom.biom -t /data/unifrac/merged_nosingletonsdoubletons_even500_sepp_nobloom_placement.tog.tre -m unweighted_fp32 -n 1 -f -o /root/emp2_8f.out.0

t2=`date +%s`
echo "=== End 2/6 `date` ($t2)"
let dt=$t2-$t1
echo "Waltime 1: $dt"

ls -l /root/emp115_8f.out.0

t1=`date +%s`
rm -f /root/emp115_8f.out.0
echo "=== Starting 3/6 `date` ($t1)"
taskset -c 20-27 time /root/unifrac/sucpp/ssu --mode partial --start 19200 --stop 28800  -i /data/unifrac/merged_nosingletonsdoubletons_even500_nobloom.biom -t /data/unifrac/merged_nosingletonsdoubletons_even500_sepp_nobloom_placement.tog.tre -m unweighted_fp32 -n 1 -f -o /root/emp2_8f.out.0

t2=`date +%s`
echo "=== End 3/6 `date` ($t2)"
let dt=$t2-$t1
echo "Waltime 1: $dt"

ls -l /root/emp115_8f.out.0

t1=`date +%s`
rm -f /root/emp115_8f.out.0
echo "=== Starting 4/6 `date` ($t1)"
taskset -c 20-27 time /root/unifrac/sucpp/ssu --mode partial --start 28800 --stop 38400  -i /data/unifrac/merged_nosingletonsdoubletons_even500_nobloom.biom -t /data/unifrac/merged_nosingletonsdoubletons_even500_sepp_nobloom_placement.tog.tre -m unweighted_fp32 -n 1 -f -o /root/emp2_8f.out.0

t2=`date +%s`
echo "=== End 4/6 `date` ($t2)"
let dt=$t2-$t1
echo "Waltime 1: $dt"

ls -l /root/emp115_8f.out.0

t1=`date +%s`
rm -f /root/emp115_8f.out.0
echo "=== Starting 5/6 `date` ($t1)"
taskset -c 20-27 time /root/unifrac/sucpp/ssu --mode partial --start 38400 --stop 48000  -i /data/unifrac/merged_nosingletonsdoubletons_even500_nobloom.biom -t /data/unifrac/merged_nosingletonsdoubletons_even500_sepp_nobloom_placement.tog.tre -m unweighted_fp32 -n 1 -f -o /root/emp2_8f.out.0

t2=`date +%s`
echo "=== End 5/6 `date` ($t2)"
let dt=$t2-$t1
echo "Waltime 1: $dt"

ls -l /root/emp115_8f.out.0


t1=`date +%s`
rm -f /dev/shm/emp2_8f.out.0
echo "=== Starting 6/6 `date` ($t1)"
taskset -c 20-27 time /root/unifrac/sucpp/ssu --mode partial --start 48000 --stop 56861   -i /data/unifrac/merged_nosingletonsdoubletons_even500_nobloom.biom -t /data/unifrac/merged_nosingletonsdoubletons_even500_sepp_nobloom_placement.tog.tre -m unweighted_fp32 -n 1 -f -o /root/emp115_8f.out.0

t2=`date +%s`
echo "=== End 6/6 `date` ($t2)"
let dt=$t2-$t1
echo "Waltime 2: $dt"

echo "====== All done ======"
let dt=$t2-$t0
echo "Waltime total: $dt"

ls -l /root/emp115_8f.out.0
rm -f /root/emp115_8f.out.0

