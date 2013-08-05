import pyfits
import pylab
#import sys
import numpy as np
import asciitable

def CompSpecFlux(im, hd):
    """
    Given the image (im) and header (hd), this routine
    returns the specific flux in erg s^-1 cm^-2 A^-1
    """
    
    #Planck's Constant (erg s):
    h = 6.626e-27
    #speed of light
    c = 2.99792458
    
    #1.5m area:
    area = 1.3 * 10**4
    
    exptime = hd['EXPTIME']
    spec = im[:,:,1]
    wav = im[:,:,0]

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
    #my_file = open(extinctionfn, "r+")
    #print my_file.read()
    #my_file.close()
    curve = asciitable.read(extinctionfn, data_start=0, delimiter="\s")
    #print "curve shape: "
    #print curve.shape
    #curve = ''
    #print curve[0]
    #print "The type is: "
    #print type(curve)
    #print curve[1]
    #print curve.dtype
    #print curve['col1']
    #wavs = curve['col1']
    #print wavs.shape
    #print wavs[0]
    #pylab.plot(curve['col1'], curve['col2'])
    #pylab.show()
    return curve
    
def getMags(star):
    magsfn = "/Users/matt/projects/CHIRON/EFFICIENCY/"+star+"_hamuy1992.txt"
    magarr = asciitable.read(magsfn,delimiter="\s")
    #print magarr
    #print magarr.dtype
    #print magarr.shape
    #pylab.plot(magarr.wav, magarr.mag)
    #pylab.show()
    return magarr
    
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
    
def calculateEff(im, fluxarrnu, exinctionarr, magarr,airmass):
    imd = im.shape
    wav = im[:,:,0]
    ord = 0
    idx = pylab.where(fluxarrnu[ord,:] == max(fluxarrnu[ord,:]))
    print idx, max(fluxarrnu[ord][:])
    print fluxarrnu[ord,idx]
    #for ord in range(imd[0]):
    #    idx = pylab.where(fluxarrnu[ord,:] == max(fluxarrnu[ord,:]))
    #    print idx, max(fluxarrnu[ord][:])
    return 0

def peakLocations(date, hd):
    mode = "fiber"
    flatname = "/tous/mir7/flats/chi"+date+"."+mode+"flat.fits"
    flat = pyfits.getdata(flatname)
    
    peakarr = 0
    return peakarr, flat
    
star = 'hr8634'
date = '130801'
fileName = '/tous/mir7/fitspec/'+date+'/achi'+date+'.1133.fits'    
im = getImage(fileName)
hd = getHeader(fileName)
fluxarrnu = CompSpecFlux(im, hd)
exinctionarr = getExtinction()
magarr = getMags(star)
airmass = getAirmass(hd)
calculateEff(im, fluxarrnu, exinctionarr, magarr,airmass)

#plotOrder(im, 39)
#plotFluxOrder(im[:,:,0],fluxarrnu, 29)
