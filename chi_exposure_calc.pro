;+
;
;  NAME: 
;     chi_exposure_calc
;
;  PURPOSE: 
;   
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      chi_exposure_calc
;
;  INPUTS:
;
;  OPTIONAL INPUTS:
;
;  OUTPUTS:
;
;  OPTIONAL OUTPUTS:
;
;  KEYWORD PARAMETERS:
;    
;  EXAMPLE:
;      chi_exposure_calc
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2011.03.13 04:02:24 PM
;
;-
function chi_exposure_calc, $
vmag = vmag, $
airmass = airmass, $
snr = snr, $
counts = counts, $
iodine=iodine

if ~keyword_set(airmass) then airmass = 1d
if ~keyword_set(snr) then snr = 200d
if ~keyword_set(counts) then counts = 5000d
if ~keyword_set (vmag) then vmag = 2d

;First things first, calculate the exposure time:
;To do this, I'll work with a few objects that I have
;observed and calculate the exposure time as a function
;of V magnitude, airmass, and iodine.

nstars = 7d
vmagarr = dblarr(nstars)
exptimearr = dblarr(nstars)
countsarr = dblarr(nstars)
airmassarr = dblarr(nstars)

;88218: qa31.3051
airmassarr[0] = 1.135d
vmagarr[0] = 6.13d
countsarr[0] = 1150d
exptimearr[0]= 1200d ;seconds
decker='narrow'

;50281
vmagarr[1] = 6.57d
exptimearr[1] = 1200d
countsarr[1] = 600d

;115617
vmagarr[2] = 4.74d
exptimearr[2] = 1020d
countsarr[2] = 4d3

;114613
vmagarr[3]    = 4.85
exptimearr[3] = 1020d
countsarr[3]   = 3200d

;76151
vmagarr[4]    = 6.00d
exptimearr[4] = 1200d
countsarr[4]   = 1200d

;50806
vmagarr[5]    = 6.00d
exptimearr[5] = 1200d
countsarr[5]   = 1100d

;canopus
vmagarr[6]    = -0.72d
exptimearr[6] = 15d
countsarr[6]   = 7900

y = countsarr/exptimearr * 10d ^ (vmagarr / 2.512d)
plot, y, ps=8, $
xtitle='Observation', $
ytitle='Scaling Coefficient'

x=dindgen(nstars)
res = linfit(x, y, /double, yfit=yfit)
eff = res[0]

loadct, 39, /silent
oplot, x, eff + x*res[1], color=240

;GOAL: 5000 COUNTS ABOVE BASELINE

exptime = counts / eff * 10d ^ (vmag / 2.512d)
return, exptime
;stop
end;chi_exposure_calc.pro