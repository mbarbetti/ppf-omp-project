import math
from argparse import ArgumentParser

parser = ArgumentParser()
parser . add_argument ( "-s" , "--size"      , required = True )
parser . add_argument ( "-p" , "--processor" , required = True )
args = parser . parse_args()

s = float(args.size)
p = float(args.processor)

new_s = s * math.sqrt(p)

print (f"prob size computed: {int(new_s)}")