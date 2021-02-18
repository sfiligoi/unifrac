#!/bin/bash
#SBATCH --time 24:00:00 -p gpu --exclusive
hostname
lscpu
date
nvidia-smi

cd /panfs/panfs1.ucsd.edu/panscratch/isfiligoi/anaconda3_2020.11_20.2/benchmarks/ssu_gpu

./ssu_200k_a.sh > ssu_200k_a.sh.out 2>ssu_200k_a.sh.err </dev/null &
./ssu_200k_b.sh > ssu_200k_b.sh.out 2>ssu_200k_b.sh.err </dev/null &

wait

