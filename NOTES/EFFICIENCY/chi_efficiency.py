import pyfits
import pylab
#import sys
import numpy as np
import asciitable
from scipy.interpolate import interp1d

def CompSpecFlux(im, hd):
    """
    Given the image (im) and header (hd), this routine
    returns the specific flux in erg s^-1 cm^-2 A^-1
    """
    
    #Planck's Constant (erg s):
    h = 6.626e-27
    #speed of light
    c = 2.99792458e10
    
    #1.5m area:
    area = 1.3135 * 10**4
    
    exptime = hd['EXPTIME']
    spec = im[:,:,1]
    wav = 1e-10 * im[:,:,0]

    z = im.shape
    fluxarrnu = np.zeros((z[0],z[1]))
    for i in range(z[0]):
        for j in range(z[1]):
            #Calculae pixel size:
            if j != 0 and j < len(range(z[1])) -1:
                pixwidthnu = (c/wav[i][j] + c/wav[i][j-1])/2. - (c/wav[i][j+1] + c/wav[i][j])/2.
            elif j == 0:
                pixwidthnu = c/wav[i][j] - c/wav[i][j+1]
            else:
                pixwidthnu = c/wav[i][j-1] - c/wav[i][j]
            #Convert to flux in erg s^-1 cm^-2 Hz^-1
            fluxarrnu[i][j] = h*c/wav[i][j]*spec[i][j]/exptime/pixwidthnu/area
    return fluxarrnu
    
def plotOrder(im, ord):
    x = im[ord,:,0]
    y = im[ord,:,1]
    pylab.xlabel('Wavelength [A]')
    pylab.ylabel('Photoelectrons')
    pylab.plot(x,y)
    pylab.show()
    
def plotFluxOrder(wav, spec, ord):
    x = wav[ord,:]
    y = spec[ord,:]
    pylab.xlabel('Wavelength [A]')
    pylab.ylabel('Flux [erg s^-1 cm^-2 Hz^-1')
    pylab.plot(x,y)
    pylab.show()
    #pylab.savefig('~/Desktop/fluxplot.png')
    
def getExtinction():
    extinctionfn = "/Users/matt/projects/CHIRON/EFFICIENCY/extinction.txt"
    curve = asciitable.read(extinctionfn, data_start=0, delimiter="\s")
    #pylab.plot(curve['col1'], curve['col2'])
    #pylab.show()
    return curve
    
def getMags(star):
    magsfn = "/Users/matt/projects/CHIRON/EFFICIENCY/"+star+"_hamuy1992.txt"
    magarr = asciitable.read(magsfn,delimiter="\s")
    #pylab.plot(magarr.wav, magarr.mag)
    #pylab.show()
    return magarr
    
def magsToFlux(magarr):
	#Solve for f_nu in Hamuy 92 Eqn 2:
	measflux = 10**(-0.4*(magarr.mag + 48.590))
	return measflux
    
def getImage(fileName):
    im = pyfits.getdata(fileName, 0)
    #print "Size of im:"
    #print im.shape
    return im

def getHeader(fileName):
    hd = pyfits.getheader(fileName)
    return hd

def getAirmass(hd):
    airmass = hd['AIRMASS']
    print "Airmass is: "+str(airmass)
    return airmass
    
def calculateEff(im, fluxarrnu, extinctionarr, magarr,airmass, peakarr, seqnum):
    imd = im.shape
    wav = im[:,:,0]
    interpext = interp1d(extinctionarr.col1, extinctionarr.col2, kind='cubic')
    medarr = np.zeros(imd[0])
    peakwav = np.zeros(imd[0])
    for ord in range(imd[0]):
    	medarr[ord] = np.median(fluxarrnu[ord, (peakarr[ord]-4):(peakarr[ord]+3)])
    	peakwav[ord] = wav[ord,peakarr[ord]]
    #the extinction, in magnitudes = airmass*extinction value:
    extval = interpext(peakwav)
    mext = np.zeros(extval.shape[0])
    for i in range(extval.shape[0]):
    	mext[i] = float(airmass) * extval[i]
    ftrue =  medarr*10**(0.4*mext)
    fmeas = interp1d(magarr.wav, magsToFlux(magarr), kind='cubic')
    fmeasinterp = fmeas(peakwav)
    eff = ftrue/fmeasinterp
    #pylab.plot(peakwav, eff*100.)
    #pylab.xlabel('Wavelength [A]')
    #pylab.ylabel('Efficiency (%)')
    #pylab.savefig.dpi=300
    #pylab.savefig('fig_eff_'+seqnum+'.eps')
    #pylab.show()
    return peakwav, eff

def peakLocations(date, hd):
    mode = "fiber"
    flatname = "/tous/mir7/flats/chi"+date+"."+mode+"flat.fits"
    flat = pyfits.getdata(flatname)
    peakarr = np.zeros(flat.shape[1])
    for zaidx in range(flat.shape[1]):
    	maxspot = pylab.transpose(pylab.where(flat[2,zaidx,:] == max(flat[2,zaidx,:])))
        peakarr[zaidx] = maxspot[0]
    return peakarr
    
def makeEff(star, date, seqnum, fileName):
	im = getImage(fileName)
	hd = getHeader(fileName)
	fluxarrnu = CompSpecFlux(im, hd)
	extinctionarr = getExtinction()
	magarr = getMags(star)
	airmass = getAirmass(hd)
	peakarr = peakLocations(date,hd)
	peakwav, eff = calculateEff(im, fluxarrnu, extinctionarr, magarr,airmass, peakarr, seqnum)
	return peakwav, eff
	
date = '130801'

def createPlots():
	#For the first star:
	star = 'hr7596'
	seqarr = ['1130', '1131', '1132']
	effarr = np.zeros((9,62))
	effidx = 0
	#pylab.xlabel('Wavelength [A]')
	#pylab.ylabel('Efficiency (%)')
	for seq in seqarr:
		seqnum = seq
		fileName = '/tous/mir7/fitspec/'+date+'/achi'+date+'.'+seqnum+'.fits'
		peakwav, eff = makeEff(star, date, seqnum, fileName)
		peakwav.shape
		peakwav.dtype
		iodrange = ((peakwav > 5000.) & (peakwav < 6000.))
		print "median efficiency "+str(effidx)+": "+str(np.median(eff[iodrange]))
		print "max efficiency: "+str(max(eff))
		maxwav = eff == max(eff)
		print "wav @ max: "+str(peakwav[maxwav])
		#pylab.plot(peakwav, eff*100.)
		effarr[effidx,:] = eff
		effidx += 1
	#pylab.text(7500,7, star)
	#pylab.savefig('fig_eff_'+star+'_all.eps')
	#pylab.clf()

	#For the second star:
	star = 'hr8634'
	seqarr = ['1133', '1134', '1135']
	#pylab.xlabel('Wavelength [A]')
	#pylab.ylabel('Efficiency (%)')
	for seq in seqarr:
		seqnum = seq
		fileName = '/tous/mir7/fitspec/'+date+'/achi'+date+'.'+seqnum+'.fits'
		peakwav, eff = makeEff(star, date, seqnum, fileName)
		#pylab.plot(peakwav, eff*100.)
		effarr[effidx,:] = eff
		effidx += 1
	#pylab.text(7500,7, star)
	#pylab.savefig('fig_eff_'+star+'_all.eps')
	#pylab.clf()

	#For the third star:
	star = 'hr9087'
	seqarr = ['1149', '1150', '1151']
	#pylab.xlabel('Wavelength [$\AA$]')
	#pylab.ylabel('Efficiency (%)')
	for seq in seqarr:
		seqnum = seq
		fileName = '/tous/mir7/fitspec/'+date+'/achi'+date+'.'+seqnum+'.fits'
		peakwav, eff = makeEff(star, date, seqnum, fileName)
		#pylab.plot(peakwav, eff*100.)
		effarr[effidx,:] = eff
		effidx += 1
	#pylab.text(7500,6, star)
	#pylab.savefig('fig_eff_'+star+'_all.eps')
	#pylab.clf()
	medeff = np.median(effarr, axis=0)
	pylab.clf()
	pylab.xlabel('Wavelength [$\AA$]')
	pylab.ylabel('Efficiency (%)')
	for i in range(62):
		print i,medeff[i]*100.
	#pylab.plot(peakwav, medeff*100.,color='k', linewidth=2.0)
	pylab.plot(peakwav, medeff*100.,'bo')
	pylab.savefig('fig_medeff.eps')
	iodrange = ((peakwav > 5000.) & (peakwav < 6000.))
	print "=== FOR THE MEDIAN ARR==="
	print "max efficiency: "+str(max(medeff))
	mwav = pylab.transpose(pylab.where(medeff == max(medeff)))
	print "wavelength of max: "+str(peakwav[mwav])
	print "median efficiency: "+str(np.median(medeff[iodrange]))
	for i in range(9):
		iodrange = ((peakwav > 5000.) & (peakwav < 6000.))
		print "median efficiency "+str(i)+": "+str(np.median(effarr[i,iodrange]))
	return peakwav, medeff

def medEff():
	"""PURPOSE: To calculate the median efficiency of CHIRON"""

def cleanDotPlotMedEff():
	"""PURPOSE: To plot the median CHIRON efficiency
	as dots, and remove the "kinks" """
	peakwav, medeff = createPlots()
	pylab.clf()
	pylab.xlabel('Wavelength [$\AA$]')
	pylab.ylabel('Efficiency (%)')
	pylab.plot(peakwav, medeff*100.,'ko')
	return peakwav, medeff

def plotDataShort():
	""" PURPOSE: Read in the text file with the removed "kinks"
	and replot """
	medefffn="/Users/matt/projects/CHIRON/EFFICIENCY/data_short.txt"
	#medeff = asciitable.read(medefffn,delimiter=" ", data_start=2)
	medeff = asciitable.read(medefffn, data_start=0, delimiter="\s")
	pylab.clf()
	pylab.xlabel('Wavelength [$\AA$]')
	pylab.ylabel('Efficiency (%)')
	pylab.plot(medeff.wav, medeff.eff*100.,'ko')
	#pylab.savefig('fig_medeff_nokinks.eps')
	
def plotData():
	""" PURPOSE: Read in the text file and plot the median efficiency """
	medefffn="/Users/matt/projects/CHIRON/EFFICIENCY/data.txt"
	medeff = asciitable.read(medefffn, data_start=0, delimiter=" ")
	pylab.clf()
	pylab.xlabel('Wavelength [$\AA$]')
	pylab.ylabel('Efficiency (%)')
	pylab.plot(medeff.wav, medeff.eff*100.,'ko')
	pylab.savefig('fig_medeff.eps')
	
