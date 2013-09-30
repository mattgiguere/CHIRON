import pyfits as pf
import pylab as pl
#import sys
import numpy as np

def chi_tiptilttest(seqnums):
	print "seqnums: "+str(seqnums)
	ttmode = np.zeros(len(seqnums))
	emavgcts = np.zeros(len(seqnums))
	date = '130921'
	fdir = '/raw/mir7/'+date+'/'
	for i in range(len(seqnums)):
		hd = pf.getheader(fdir+'chi'+date+'.'+str(seqnums[i])+'.fits')
		ttcom = hd['comment', 2]
		if ttcom.split(' ')[2] == 'OFF':
			ttmode[i] = 0
		elif ttcom.split(' ')[2] == 'ON':
			ttmode[i] = 1
		else:
			ttmode[i] = -1
		emavgcts[i] = hd['EMAVG']
		print str(seqnums[i])+' '+str(emavgcts[i])
	return emavgcts, ttmode

seqnums=range(1132, 1138)
emavgcts, ttmode = chi_tiptilttest(seqnums)
print emavgcts
#pl.plot(seqnums, emavgcts, 'ko')

tton = np.where(ttmode == 1)[0]
ttoff = np.where(ttmode == 0)[0]
onseqs = [0]*len(tton)
onemavg = np.zeros(len(tton))
for i in range(len(tton)):
	onseqs[i] = seqnums[tton[i]]
	onemavg[i] = emavgcts[tton[i]]
offseqs = [0]*len(tton)
offemavg = np.zeros(len(tton))
for i in range(len(ttoff)):
	offseqs[i] = seqnums[ttoff[i]]
	offemavg[i] = emavgcts[ttoff[i]]

def plot_tiptilt(onseqs, onemavg, offseqs, offemavg):
	pl.xlabel('Sequence Number')
	pl.ylabel('Average EM Countrate')
	pl.xlim([1131, 1138])
	pl.plot(onseqs, onemavg, 'bo', label='Tip Tilt ON')
	pl.plot(offseqs, offemavg, 'ro', label='Tip Tilt OFF')
	pl.legend()
	pl.show()
	pl.savefig('~/plots/CHIRON/TIPTILT/tiptilt_res.png')
