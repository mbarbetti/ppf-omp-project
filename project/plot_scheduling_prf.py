import os
import numpy as np
import pandas as pd
import multiprocessing as mp
import matplotlib.pyplot as plt

from argparse import ArgumentParser

avail_threads = [ f"{i+1}" for i in range(mp.cpu_count()) ]   # list of available threads

parser = ArgumentParser()
parser . add_argument ( "-f" , "--file"        , default = None )
parser . add_argument ( "-s" , "--scheduling"  , default = None , choices = ["static", "dynamic"] )
parser . add_argument ( "-n" , "--num_threads" , default = None , choices = avail_threads )
args = parser.parse_args()

dfs = list()   # list of DataFrames

if (args.file is not None):

  filename = args.file.split("/")[-1] if ("/" in args.file) else args.file
  img_name = f"./img/time_{filename[:-4]}.png"

  ext = filename.split(".")[-1]
  if (ext != "csv"): 
    raise ValueError (f"The elapsed times should be passes as CSV file, instead {args.file} passed.")
  
  dfs . append ( pd.read_csv (args.file, index_col = 0) )
  labels = [ None ]

else:

  if (args.scheduling is not None) and (args.num_threads is not None):
    img_name = f"./img/time_psVSpsc_{args.num_threads}threads_{args.scheduling}.png"

    for vrs in ["ps", "psc"]:
      file = f"./data/times/{vrs}_{args.num_threads}threads_{args.scheduling}.csv"
      if not os.path.exists (file): 
        raise ValueError (f"{file} not found.")
      dfs . append ( pd.read_csv (file, index_col = 0) )
    labels = [ "only inner loop parallelized", "$\mathtt{collapse(2)}$ directive used" ]

  else:
    raise ValueError ( f"You should decide if passing a file ('-f') obtaining the relative "
                       f"performance plot, OR passing both the scheduling type ('-s') and "
                       f"the number of threads ('-n') to obtaine the comparison plot." )

if ("static" in img_name):
  title = "Static scheduling performance"
elif ("dynamic" in img_name):
  title = "Dynamic scheduling performance"
else:
  title = None

if title:
  if ("threads" in img_name):
    text = img_name.split("_")[-2]
    text = text.split("t")
    title += f" ({text[0]} t{text[1]})"

## Elapsed time plot
fig, ax = plt.subplots ( figsize = (7,5), dpi = 200 )

for i, (df, label) in enumerate ( zip(dfs, labels) ):
  chunksize = df.values[:,1].astype(np.int32)
  t_mean = np.mean (df.values[:,4:].astype(np.float32), axis = 1)
  t_errs = np.std  (df.values[:,4:].astype(np.float32), axis = 1)

  ax.set_title  ( f"{title}", fontsize = 14 )
  ax.set_xlabel ( "Scheduling chunksize", fontsize = 12 )
  ax.set_ylabel ( "Elapsed time [s]", fontsize = 12 )
  ax.errorbar ( chunksize, t_mean, yerr = t_errs, marker = "o", markersize = 2, 
                capsize = 2, elinewidth = 1, lw = 0.75, label = label, zorder = i )
  ax.set_xscale ( "log" )

if (args.file is None): plt.legend ( loc = "upper left", fontsize = 10 )

plt.savefig (img_name)
plt.show()

print ( f"Elapsed time plot correctly exported to {img_name}" )
