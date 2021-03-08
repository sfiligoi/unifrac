#!/usr/bin/python3

import os

samples_wl = [1000,2000,5000,10000,20000,25000,30000,50000,100000,150000,200000,250000,
              307237] # full 307k

samples_wl2 = [1000,2000,5000,10000,20000,25000,30000,50000,100000,150000,200000,250000,
              25145, #EMP
              50085, # AG
              113721, # 113k
              307237] # full 307k

for t in ['uw','wn']:
  data={}
  # first the many data
  header=None
  with open("../../benchmarks_many/summary_%s.csv"%t,"r") as fd:
    lines=fd.readlines()
    header=lines[0]
    for line in lines[1:]:
      larr=line.strip().split(",")
      samples=int(larr[0])
      if samples not in samples_wl2:
         continue # stick to whitelist
      if samples in data.keys():
        print("WARNING: Duplicate samples %i found!"%samples)
      data[samples]=larr[1:]

   # now add any single data
  with open("../../benchmarks/summary_%s.csv"%t,"r") as fd:
    lines=fd.readlines()
    for line in lines[1:]:
      larr=line.strip().split(",")
      samples=int(larr[1])
      if samples not in samples_wl2:
         continue # stick to whitelist
      if samples in data.keys():
        if (data[samples][0]=="") and (larr[3]!=""):
           data[samples][0] = larr[3]
        if (data[samples][3]=="") and (larr[4]!=""):
           data[samples][3] = larr[4]
        if (data[samples][6]=="") and (larr[6]!=""):
           data[samples][6] = larr[6]
        if (data[samples][9]=="") and (larr[9]!=""):
           data[samples][9] = larr[9]
      else:
        data[samples]=[larr[3],"","",
                       larr[4],"","",
                       larr[6],"","",
                       larr[9],"","",
                       "%i"%((samples+1)/2),
                       larr[2],"",""]

  #print(data)

  samples=list(data.keys())
  samples.sort()

  with open("../scaling_summary_%s.csv"%t,"w") as fd:
    fd.write(header)

    for s in samples:
      if s not in samples_wl:
         continue # stick to whitelist
      fd.write("%i,%s\n"%(s,",".join(data[s])))

  with open("../summary_%s.csv"%t,"w") as fd:
    fd.write(header)

    for s in samples:
      fd.write("%i,%s\n"%(s,",".join(data[s])))

