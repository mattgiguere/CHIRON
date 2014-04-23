#!/usr/bin/env python

"""
Created on 2014-04-08T14:49:44
"""
from __future__ import division, print_function
import sys
import subprocess

__author__       = "Matt Giguere (github: @mattgiguere)"
__maintainer__ = "Matt Giguere"
__email__         = "matthew.giguere@yale.edu"
__status__         = " Development NOT(Prototype or Production)"
__version__       = '0.0.1'

"""PURPOSE: To sync raw data from /raw to /raw2"""
def chi_syncraw(arg1):
  rdir = subprocess.check_output(["ls","-1","/raw/mir7"])
  rdirs = rdir.split()
  pref = ['rsync', '-uva', '/raw/mir7/']
  #rdirs = [x if x]
  suf = '/raw2/mir7/'
  for i in rdirs:
    comm = pref[:-1]
    comm.append(''.join(pref[-1]+i+'/'))
    comm.append(suf+i+'/')
    if arg1 == 'test':
      #print(comm)
      print(' '.join(comm))
    if arg1 == 'exec':
      print("***************************")
      print("Now syncing "+i)
      print(subprocess.check_output(comm))


if __name__ == '__main__':
    if len(sys.argv) != 2:
      print('')
      print("***Invalid call to chi_syncraw***")
      print("***Must be of the following form***")
      print('python chi_syncraw.py test OR exec')
      print("# of arguments actually passed in: ", len(sys.argv))
      print("Arguments: ", sys.argv)
      if len(sys.argv) > 1:
          print(sys.argv[1])
      print('')
      sys.exit(2)
    else:
      print("Arguments: ", sys.argv)
      arg1 = str(sys.argv[1])
      chi_syncraw(arg1)
