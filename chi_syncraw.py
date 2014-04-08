#!/usr/bin/env python

"""
Created on 2014-04-08T14:49:44
"""

__author__       = "Matt Giguere (github: @mattgiguere)"
__maintainer__ = "Matt Giguere"
__email__         = "matthew.giguere@yale.edu"
__status__         = " Development NOT(Prototype or Production)"
__version__       = '0.0.1'

from __future__ import division, print_function
import sys

def chi_syncraw(arg1):
	"""PURPOSE: To sync raw data from /raw to /raw2"""
  import subprocess
  rdirs = subprocess.check_output(["ls","-1","/Volumes/epsilon/raw/mir7"])
  pref = ['rsync', '-uva', '/Volumes/epsilon/raw/mir7/']
  suf = ['/Volumes/kappa/raw2/mir7/']
  if arg1 == 'test':
    for i in rdirs:
      print pref,i,'/ ',suv,i,'/'

if __name__ == '__main__':
    if len(sys.argv) != 1:
        print('')
        print('python chi_syncraw.py test OR exec')
        print('')
        sys.exit(2)

    arg1 = str(sys.argv[1])

    chi_syncraw(arg1)
