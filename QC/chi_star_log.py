import numpy as np
import sys
from scipy.io.idl import readsav

print "Hello World!"
s = readsav("/Users/matt/data/CHIRPS/starlogs/22049log.dat")
#print s