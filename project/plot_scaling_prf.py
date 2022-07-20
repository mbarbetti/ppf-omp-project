import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

from argparse import ArgumentParser

parser = ArgumentParser()
parser . add_argument ( "-s" , "--scaling" , required = True , choices = ["strong", "weak"] )
parser . add_argument ( "-f" , "--file"    , required = True )
args = parser.parse_args()

filename = args.file.split("/")[-1] if ("/" in args.file) else args.file
img_name = f"./img/t_exec_{filename[:-4]}.png"

ext = filename.split(".")[-1]
if (ext != "csv"):
  raise ValueError (f"The execution times should be passes as CSV file, instead {args.file} passed.")

if (args.scaling == "strong"):
  title = "Strong scaling performance"
  loc_1 = "upper right" ; loc_2 = "upper left"
else:
  title = "Weak scaling performance"
  loc_1 = "upper left" ; loc_2 = "lower left"

if ("static" in img_name) or ("dynamic" in img_name):
  text = img_name[:-4].split("_")[-1]
  text = text.split("c")
  title += " ($\mathtt{schedule(%sc,%s)}$)" % (text[0], text[1])

df = pd.read_csv (args.file, index_col = 0)
processors = df.values[:,0]

## Execution time study
t_mean = np.mean (df.values[:,3:], axis = 1)
t_errs = np.std  (df.values[:,3:], axis = 1)
t_ideal = t_mean[0] / processors if (args.scaling == "strong") else t_mean[0] * np.ones_like(t_mean)

fig, ax = plt.subplots ( figsize = (7,5), dpi = 200 )
ax.set_title  ( title, fontsize = 14 )
ax.set_xlabel ( "Number of processors", fontsize = 12 )
ax.set_ylabel ( "Execution time [s]", fontsize = 12 )
ax.plot ( processors, t_ideal, color = "black", ls = "--", 
          lw = 0.75, label = "ideal execution time", zorder = 0 )
ax.errorbar ( processors, t_mean, yerr = t_errs, marker = "o", markersize = 2, capsize = 2, 
              elinewidth = 1, lw = 0.75, label = "measured execution time", zorder = 1 )
if (args.scaling == "strong"): ax.set_yscale ( "log" )
ax.legend ( loc = loc_1, fontsize = 10 )
plt.savefig (img_name)
plt.show()

print ( f"Execution time plot correctly exported to {img_name}" )

## Speedup study
speedup = t_mean[0] / t_mean
speedup_errs  = t_errs[0] / t_mean + t_mean[0] * t_errs / t_mean**2 ; speedup_errs[0] = 0.0
speedup_ideal = processors if (args.scaling == "strong") else np.ones_like(processors)

fig, ax = plt.subplots ( figsize = (7,5), dpi = 200 )
ax.set_title  ( title, fontsize = 14 )
ax.set_xlabel ( "Number of processors", fontsize = 12 )
ax.set_ylabel ( "Speedup", fontsize = 12 )
ax.plot ( processors, speedup_ideal, color = "black", ls = "--", 
          lw = 0.75, label = "ideal speedup", zorder = 0 )
ax.errorbar ( processors, speedup, yerr = speedup_errs, marker = "o", markersize = 2, 
              capsize = 2, elinewidth = 1, lw = 0.75, label = "measured speedup", zorder = 1 )
ax.legend ( loc = "upper left", fontsize = 10 )
img_name = f"./img/speedup_{filename[:-4]}.png"
plt.savefig (img_name)
plt.show()

print ( f"Speedup plot correctly exported to {img_name}" )
