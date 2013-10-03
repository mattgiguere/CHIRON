from scipy.io.idl import readsav
import pylab as pl
import numpy as np

def em_calib(star):
	mdir = '/home/matt/'
	slogfn = mdir+'data/CHIRPS/starlogs/'+star+'log.dat'
	sl = readsav(slogfn)
	#to print the contents of the "OBJECT" tag:
	#sl.starlog.object
	snr = sl.starlog.snrbp5500
	emavgstr = sl.starlog.emavg
	emnumsmpstr = sl.starlog.emnumsmp
	emavg = np.zeros(len(emavgstr))
	emnumsmp = np.zeros(len(emavgstr))
	for i in range(len(emavgstr)):
		emavg[i] = float(emavgstr[i])
		emnumsmp[i] = float(emnumsmpstr[i])
	emcts = emavg * emnumsmp
	pl.xlabel('EM Counts')
	pl.ylabel('SNR')
	pl.plot(emcts, snr, 'bo')
	pl.show()
	
star = '20794'
	