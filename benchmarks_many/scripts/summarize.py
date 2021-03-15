#!/usr/bin/python3

import os
from statistics import median

def parse_file(fname, data, label):
  with open(fname,'r') as fd:
    lines = fd.readlines()

  for line in lines:
    line=line.strip()
    if not line.startswith("=== Size: "):
      continue # not a data line

    larr=line.strip().split(' time: ')
    if len(larr)!=2:
      continue # not a data line

    larr1=larr[1].split()
    larr2=larr[0].split(' Type: ')
    larr3=larr2[0].split()

    dt=int(larr1[0])
    type=larr2[1].split()[0] # ignore eventual fp32
    samples=int(larr3[2])
    itr=int(larr3[4])

    if type not in data.keys():
      data[type] = {}
    if samples not in data[type].keys():
      data[type][samples] = {}
    if label not in data[type][samples].keys():
      data[type][samples][label] = {}

    if itr in data[type][samples][label].keys():
      print("WARNING: Duplicate %s:%i:%s:%i"%(type,samples,label,itr))
    data[type][samples][label][itr] = dt

  return data

def parse_dir(dname, data, label):
  files = os.listdir(dname)

  for fname in files:
    if fname.find("_p")>0:
      continue # these are horizontal scaling results
    if (fname.endswith('.out')) or (fname.find("sh.o")>0):
      parse_file(os.path.join(dname,fname), data, label)

  return data

data={}
parse_dir("../org/CPU_Intel_Xeon_Gold_6242",data,"org_cpu_xeon")
parse_dir("../v0.20.2/CPU_Intel_Xeon_Gold_6242",data,"cpu_xeon")
parse_dir("../v0.20.2/GPU_NVIDIA_V100_32GB",data,"gpu_v100")
parse_dir("../v0.20.2/GPU_NVIDIA_A40",data,"gpu_a40 fp32")

inputs={}
with open("../inputs.csv","r") as fd:
  lines=fd.readlines()
  for line in lines[1:]:
    larr=line.strip().split(",")
    inputs[int(larr[0])]=larr[1:]


#print(data)

fname={'unweighted':'summary_uw.csv', 'weighted_normalized':'summary_wn.csv'}
labels=["org_cpu_xeon","cpu_xeon","gpu_v100","gpu_a40 fp32"]

for type in ['unweighted','weighted_normalized']:
  samples=list(data[type].keys())
  samples.sort()

  with open("../%s"%fname[type],"w") as fd:
    fd.write("#samples")
    for label in labels:
      fd.write(", median %s, min %s, max %s"%(label, label, label))
    fd.write(", stripes, median n_embs, min n_emb, max n_emb")
    fd.write("\n")

    for s in samples:
      fd.write("%i"%s)
      for label in labels:
        if label in data[type][s].keys():
          dts=data[type][s][label].values()
          imedian=median(dts)
          imin=min(dts)
          imax=max(dts)
          fd.write(", %i, %i, %i"%(imedian, imin, imax))
        else:
          fd.write(",,,") # no data
      fd.write(", %i, %i, %i, %i"%(int(inputs[s][0]),int(inputs[s][1]),int(inputs[s][2]),int(inputs[s][3])))
      fd.write("\n")

