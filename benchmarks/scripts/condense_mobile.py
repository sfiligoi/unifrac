#!/usr/bin/python

import os

def parse_file(fname):
  with open(fname,'r') as fd:
    lines = fd.readlines()

  header=None
  samples=0
  data={}
  for line in lines:
    line=line.strip()
    if line.startswith("Total samples: "):
      larr=line.strip().split()
      samples=larr[2]
      continue

    if not line.startswith("=== "):
      continue # not a data line
    if not line.endswith(" ==="):
      continue # not a data line

    larr=line[4:].split("time: ")
    if len(larr)!=2:
      # header only
      if header!=None:
        continue # only read one
      header = line[4:].rsplit(None,1)[0].split(None,1)[1]
      #print(header)
    else:
      # this line contains time data
      key = larr[0].strip()
      t   = larr[1].split()[0]
      #print(key,t)
      data[key]=t

  return (header,samples,data)

def parse_dir(dname):
  files = os.listdir(dname)

  data =  {}
  for fname in files:
    if not fname.startswith('ssu_')>0:
      continue 
    if fname.find('pcoa')>0:
      continue # ignore pcoa data points
    h,n,f=parse_file(os.path.join(dname,fname))
    if h==None:
      continue # not a valid data file
    if h in data.keys():
      for k in f.keys():
        if k in data[h][1]:
          print("WARNING: Duplicate %s %s"%(h,k))
        data[h][1][k] = f[k]
    else:
      data[h] = [n,f]

  return data


def get_embs():
  with open("../input_md/input_mbs.csv","r") as fd:
    lines=fd.readlines()

  data={}
  for line in lines:
    line=line.strip()
    if line.startswith("#"):
      continue
    larr=line.split(",")
    if len(larr)==3:
      data[larr[0]]=(larr[1],larr[2])

  return data

resnames=('org_cpu_i7','cpu_i7','gpu_1050')
dnames={'org_cpu_i7':"org/CPU_Mobile_Intel_Core_i7-8850H_OSX",
        'cpu_i7':"v0.20.2/CPU_Mobile_Intel_Core_i7-8850H_OSX",
        'gpu_1050':"v0.20.2/GPU_Mobile_NVIDIA_GTX1050"}

rtypes={'unweighted': 'mobile_summary_uw.csv',
        'unweighted -f': 'mobile_summary_uw_f.csv',
        'weighted_normalized': 'mobile_summary_wn.csv',
        'weighted_normalized -f': 'mobile_summary_wn_f.csv'} 

rtypes_fp32={'unweighted': 'unweighted fp32',
             'unweighted -f': 'unweighted fp32 -f',
             'weighted_normalized': 'weighted_normalized fp32',
             'weighted_normalized -f': 'weighted_normalized fp32 -f'}     


#msizes=['500/1k','1k/2k','2.5k/5k',
#        '5k/10k','10k/20k','12k/25k',
#        'EMP 12k/25k','15k/30k',
#        '25k/50k','AG+EMP 25k/50k']
msizes=['500/1k','1k/2k','2.5k/5k',
        '5k/10k','10k/20k','12k/25k',
        'EMP 12k/25k','15k/30k',
        '25k/50k']

embs = get_embs()

data={}
for k in resnames:
  data[k]=parse_dir("../"+dnames[k])

for rtype in rtypes.keys():
  with open("../"+rtypes[rtype],"w") as fd:
    str="#Label,n_samples,n_embs,org_cpu"
    for k in resnames[1:]:
      str+=",%s,%s fp32"%(k,k)
    fd.write(str+"\n")

    for s in msizes:
      str="%s"%s

      sdel1=","
      for k in resnames:
        if s in data[k].keys():
         if data[k][s][0]>0:
          sdel1=",%s"%data[k][s][0]
          break # get the first one, should all be the same
      str += sdel1

      if s in embs.keys():
        if rtype.find(" -f")>0:
          str += ",%s"%embs[s][1]
        else:
          str += ",%s"%embs[s][0]
      else:
        str += ","

      for k in resnames[:1]: #cpu_org is special
        sdel1=","

        if s in data[k].keys():
          if rtype in data[k][s][1].keys():
            sdel1 = ",%s"%data[k][s][1][rtype]
        str += sdel1
      for k in resnames[1:]:
        sdel1=","
        sdel2=","

        if s in data[k].keys():
          if rtype in data[k][s][1].keys():
            sdel1 = ",%s"%data[k][s][1][rtype]
          if rtypes_fp32[rtype] in data[k][s][1].keys():
            sdel2 = ",%s"%data[k][s][1][rtypes_fp32[rtype]]
        str += sdel1+sdel2
      fd.write(str+"\n")


