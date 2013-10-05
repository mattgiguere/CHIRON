from scipy.io.idl import readsav
import pylab as pl
import numpy as np
import os

def mattdir():
	if os.path.exists('/Users/mattgiguere/'):
		mdir = '/Users/mattgiguere/'
	elif os.path.exists('/Users/matt/'):
		mdir = '/Users/matt/'
	elif os.path.exists('/home/matt/'):
		mdir = '/home/matt/'
	else:
		mdir = ''
	print "mdir is: "+mdir
	return mdir
	
def plot_em(emcts, snr, order, mdir, star, model):
	simsize = 3
	#clear the window
	pl.clf()
	#set the x-axis
	pl.xlabel('EM Counts / 10^6')
	pl.ylabel('SNR')
	pl.plot(emcts/1e6, snr, 'bo', markersize=simsize)
	print "max snr: "+str(max(snr))
	pl.plot(emcts/1e6, model, 'ro', markersize=simsize)
	stddev = np.std(snr - model)
	print "Standard Deviation: "+str(stddev)
	pl.text(5, 150, 'Polynomial Order: '+str(order))
	pl.text(5, 130, 'Standard Deviation: {:.3}'.format(stddev))
	#pl.show()
	pl.savefig(mdir+'projects/OTHER/NOTES/EXPM/em_cts_snr/'+star+'_emcts_snr_ord'+str(order)+'.eps')
	
def model_em(emcts, snr, ord):
	z = np.polyfit(emcts, snr, ord)
	print z
	mod = np.zeros(len(emcts))
	for i in range(ord+1):
		mod = mod + z[ord - i] * emcts**i
	return mod

def plot_airmass(snr, model, airmass, order, star):
	gdam = np.where(airmass != 0)[0]
	resids = np.zeros(len(gdam))
	airmgd = np.zeros(len(gdam))
	for i in range(len(gdam)):
		resids[i] = snr[gdam[i]] - model[gdam[i]]
		airmgd[i] = airmass[gdam[i]]
	pl.clf()
	pl.xlabel('Airmass')
	pl.ylabel('SNR - Model')
	pl.plot(airmgd, resids, 'ro')
	#pl.show()
	pl.savefig(mdir+'projects/OTHER/NOTES/EXPM/em_airmass/'+star+'_emcts_snr_ord'+str(order)+'.eps')
	
def em_calib(star, mdir):
	slogfn = mdir+'data/CHIRPS/starlogs/'+star+'log.dat'
	sl = readsav(slogfn)
	#to print the contents of the "OBJECT" tag:
	#sl.starlog.object
	snrall = sl.starlog.snrbp5500
	emavgstr = sl.starlog.emavg
	emnumsmpstr = sl.starlog.emnumsmp
	airmassall = sl.starlog.airmass
	#now use only the good ones, the values with velocities:
	gd = np.where(sl.starlog.cmnvel != 0)[0]
	#print gd
	snr = np.zeros(len(gd))
	emavg = np.zeros(len(gd))
	emnumsmp = np.zeros(len(gd))
	airmass = np.zeros(len(gd))
	#print len(gd)
	for i in range(len(gd)):
		print i, airmassall[gd[i]]
		snr[i] = float(snrall[gd[i]])
		emavg[i] = float(emavgstr[gd[i]])
		emnumsmp[i] = float(emnumsmpstr[gd[i]])
		if str(airmassall[gd[i]]).strip() != 'airmass' and str(airmassall[gd[i]]).strip() != '':
			airmass[i] = float(airmassall[gd[i]])
	emcts = emavg * emnumsmp
	return emcts, snr, airmass

##########################################################
### BEGIN CODE HERE
##########################################################

#Figure out what computer you're on:
mdir = mattdir()

#The polynomial fit for the SNR(emcts):
order = 3

#The star you want to plot:
star = '22049'

emcts, snr, airmass = em_calib(star, mdir)
model = model_em(emcts, snr, order)

plot_em(emcts, snr, order, mdir, star, model)
plot_airmass(snr, model, airmass, order, star)