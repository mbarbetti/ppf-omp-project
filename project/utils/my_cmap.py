import numpy as np
from matplotlib.colors import ListedColormap

N = 32
my_cmap = dict()

# Color gradient taken from
# https://stackoverflow.com/questions/16500656/which-color-gradient-is-used-to-color-mandelbrot-in-wikipedia
colors = [ [   0 ,   0 ,   0 ] ,
           #[  66 ,  30 ,  15 ] ,
           [  25 ,   7 ,  26 ] ,
           [   9 ,   1 ,  47 ] ,
           [   4 ,   4 ,  73 ] , 
           [   0 ,   7 , 100 ] , 
           [  12 ,  44 , 138 ] , 
           [  24 ,  82 , 177 ] , 
           [  57 , 125 , 209 ] , 
           [ 134 , 181 , 229 ] , 
           [ 211 , 236 , 248 ] ,
           [ 241 , 233 , 191 ] ,
           [ 248 , 201 ,  95 ] ,
           [ 255 , 170 ,   0 ] ,
           [ 204 , 128 ,   0 ] ,
           [ 153 ,  87 ,   0 ] ,
           [ 106 ,  52 ,   3 ] ]

grad_colors = np.ones(3)
for i in range ( len(colors) - 1 ):
  r = np.linspace (colors[i][0]/256, colors[i+1][0]/256, N)
  g = np.linspace (colors[i][1]/256, colors[i+1][1]/256, N)
  b = np.linspace (colors[i][2]/256, colors[i+1][2]/256, N)
  grad_colors = np.vstack ( [grad_colors, np.c_[r,g,b]] )

my_cmap["stackof"] = ListedColormap ( np.c_ [grad_colors[1:], np.ones(len(grad_colors[1:]))] )
