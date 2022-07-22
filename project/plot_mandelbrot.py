import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

from argparse import ArgumentParser
from utils.my_cmap import my_cmap

parser = ArgumentParser()
parser . add_argument ( "-x" , "--xsize" , default = 1024 )
parser . add_argument ( "-y" , "--ysize" , default = 768  )
args = parser . parse_args()

xsize = int(args.xsize)
ysize = int(args.ysize)

df = pd.read_csv ( f"./data/mandelbrot/matrix_{xsize}x{ysize}.csv", header = None )

fig, ax = plt.subplots ( figsize = (4,3), dpi = 300 )
ax.axes.xaxis.set_visible (False)
ax.axes.yaxis.set_visible (False)
ax.pcolormesh ( np.arange(xsize+1), np.arange(ysize+1), df.values, cmap = plt.get_cmap (my_cmap["stackof"]), vmax = 32 )
filename = f"./img/mandelbrot_{xsize}x{ysize}.png"
plt.savefig (filename, bbox_inches = "tight")
plt.show()

print ( f"Mandelbrot picture correctly exported to {filename}" )
