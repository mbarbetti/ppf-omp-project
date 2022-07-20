import numpy as np
import pandas as pd

from argparse import ArgumentParser

parser = ArgumentParser()
parser . add_argument ( "-f" , "--file"   , required = True )
# parser . add_argument ( "-c" , "--column" , required = True )
args = parser . parse_args()

with open (f"{args.file}") as f:
  lines = f.readlines()

cols = lines[0].split("\t\t")
cols[-1] = cols[-1][:-1]   # remove '\n'

data = list()
for i in range ( 1, len(lines) ):
  row = lines[i].split("\t")
  while "" in row:
    row.remove("")   # remove empty elements
  row[-1] = row[-1][:-1]   # remove '\n'
  data . append (row)

df = pd.DataFrame (data, columns = cols)

filename = args.file[:-3] + "csv"
df . to_csv (filename)

print ( f"Execution times correctly exported to {filename}" )
