;+
;
;  NAME: 
;     gain_nl
;
;  PURPOSE: 
;   To compute the gain for CHIRON and also examine the non-linearity.
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      gain_nl
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
;      gain_nl
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2011.02.21 12:29:18 AM
;
;-
pro gain_nl, observatory=observatory, $
showall=showall
usersymbol, 'circle', /fill
!p.charsize=2.
loadct, 39, /silent

if ~keyword_set(observatory) then observatory='ctio'

if observatory eq 'ctio' then begin
im1 = double(readfits('rlin0003.fits', hd1))
im2 = double(readfits('rlin0004.fits', hd2))
print, hd1
display, im1, /log
if keyword_set(showall) then stop

print, '************************************************'
print, '              HEADER 2: '
print, '************************************************'
print, hd2

display, im2, /log
if keyword_set(showall) then stop

if keyword_set(showall) then stop

bs1 = double(readfits('rlin0012.fits', hdb1))
bs2 = double(readfits('rlin0013.fits', hdb2))

print, '************************************************'
print, '              BIAS HEADER 1: '
print, '************************************************'
print, hdB1

display, bs1, /log
if keyword_set(showall) then stop

print, '************************************************'
print, '              BIAS HEADER 2: '
print, '***********************************************'
print, hdB2

display, bs2, /log
if keyword_set(showall) then stop

;reduce the image size to just the data section, and
;fill the new array with the data:
nim1 = dblarr(4096, 4112)
nim1[0:2047, *] = im1[52:2099, *]
nim1[2048:4095, *] = im1[2199:4246, *]

;now subtract the median of the overscan region
;(with a little buffer inside of the overscan region):
;for row = 0, 4111 do begin
;nim1[0:2047, row] -= median(im1[2105:2145, row])
;nim1[2048:4095, row] -= median(im1[2155:2195, row])
;endfor

;plot a histogram of the ADU in the overscan-subtracted image:
plothist, nim1, /xsty
if keyword_set(showall) then stop

;now the histogram zoomed into the peak region:
;x = where(nim1 lt 300d)
;plothist, nim1[x]
if keyword_set(showall) then stop


;***************************************************************
;			REPEAT FOR THE SECOND IMAGE:
;***************************************************************

;reduce the image size to just the data section, and
;fill the new array with the data:
nim2 = dblarr(4096, 4112)
nim2[0:2047, *] = im2[52:2099, *]
nim2[2048:4095, *] = im2[2199:4246, *]

;now subtract the median of the overscan region
;(with a little buffer inside of the overscan region):
;for row = 0, 4111 do begin
;nim2[0:2047, row] -= median(im2[2105:2145, row])
;nim2[2048:4095, row] -= median(im2[2155:2195, row])
;endfor

;***************************************************************
;			REPEAT FOR THE BIASES:
;***************************************************************
nbs1 = dblarr(4096, 4112)
nbs1[0:2047, *] = bs1[52:2099, *]
nbs1[2048:4095, *] = bs1[2199:4246, *]

nbs2 = dblarr(4096, 4112)
nbs2[0:2047, *] = bs2[52:2099, *]
nbs2[2048:4095, *] = bs2[2199:4246, *]

dif1 = nim1 - nbs1
nar1 = where(dif1 gt 0 and dif1 lt 200d)
plothist, dif1[nar1], /xsty
if keyword_set(showall) then stop

;***************************************************************
;			THRESHOLDS:
;***************************************************************
spots = where(dif1 gt 2500d)
hghim = dblarr(4096, 4112)
hghim[spots] = 120
display, hghim
if keyword_set(showall) then stop
nim1 = nim1[spots]
nim2 = nim2[spots]
nbs1 = nbs1[spots]
nbs2 = nbs2[spots]

;***************************************************************
;			NOW THE MEANS OF EACH:
;***************************************************************
mnim1 = mean(nim1)
mnim2 = mean(nim2)
mnbs1 = mean(nbs1)
mnbs2 = mean(nbs2)

print, 'The mean flat 1: ', mnim1
print, 'The mean flat 2: ', mnim2
print, 'The mean bias 1: ', mnbs1
print, 'The mean bias 2: ', mnbs2


;***************************************************************
;			VARIANCES:
;***************************************************************
sigbs = stddev( bs1 - bs2)
sigis = stddev(im1 - im2)

print, '1-sigma of the flat: ', sigis
print, '1-sigma of the bias: ', sigbs

;***************************************************************
;			CALCULATE GAIN:
;***************************************************************
gnum = (mnim1 + mnim2) - (mnbs1 + mnbs2)
gden = sigis^2 - sigbs^2
gain = gnum / gden
print, 'The gain is: ', gain

;***************************************************************
;			READ NOISE:
;***************************************************************
rnoise = gain * sigbs / sqrt(2d)
print, 'The read noise is: ', rnoise


endif ;observatory was CTIO






stop
end;gain_nl.pro