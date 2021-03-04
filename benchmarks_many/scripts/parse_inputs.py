#!/usr/bin/python3

import os
from statistics import median

def parse_file(fname, data):
  with open(fname,'r') as fd:
    lines = fd.readlines()

  samples=None
  stripes=None
  itr=None
  n_emp=None

  for line in lines:
    line=line.strip()
    if line.startswith("=== Size: "):
      larr=line.strip().split()
      samples=int(larr[2])
      itr=int(larr[4])
      continue

    if line.startswith("Total samples: "):
      larr=line.strip().split()
      assert samples==int(larr[2])
      continue
    if line.startswith("Total stripes: "):
      larr=line.strip().split()
      stripes=int(larr[2])
      continue


    if line.startswith("nr_els "):
      larr=line.strip().split()
      n_emp=int(larr[1])
      assert samples!=None
      assert stripes!=None
      assert itr!=None
      if samples not in data.keys():
        data[samples] = {'stripes':stripes, 'itrs':{}}
      assert stripes==data[samples]['stripes']

      if itr in data[samples]['itrs'].keys():
        print("WARNING: Duplicate %i:%i"%(samples,itr))
      data[samples]['itrs'][itr] = n_emp

      samples=None
      stripes=None
      itr=None
      n_emp=None

      continue

  return data

def parse_dir(dname, data):
  files = os.listdir(dname)

  for fname in files:
    if not fname.endswith('.out')>0:
      continue 
    parse_file(os.path.join(dname,fname), data)

  return data

data={}
parse_dir("../inputs",data)

#print(data)

samples=list(data.keys())
samples.sort()

with open("../inputs.csv","w") as fd:
  fd.write("#samples, stripes, median n_embs, min n_emb, max n_emb\n")
  for s in samples:
    imedian=median(data[s]['itrs'].values())
    imin=min(data[s]['itrs'].values())
    imax=max(data[s]['itrs'].values())
    fd.write("%i, %i, %i, %i, %i\n"%(s, data[s]['stripes'], imedian, imin, imax))

