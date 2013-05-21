;+
;
;  NAME: 
;     nonlinearity
;
;  PURPOSE: 
;   To test the nonlinearity of the detector
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      nonlinearity
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
;      nonlinearity
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2011.02.21 02:47:15 AM
;
;-
pro nonlinearity

;************************************
;        im1
;*************************************
im1 = double(readfits('rlin0001.fits', hd1))
im1t = double(sxpar(hd1, 'EXPTIME'))
;reduce the image size to just the data section, and
;fill the new array with the data:
nim1 = dblarr(4096, 4112)
nim1[0:2047, *] = im1[52:2099, *]
nim1[2048:4095, *] = im1[2199:4246, *]

;now subtract the median of the overscan region
;(with a little buffer inside of the overscan region):
for row = 0, 4111 do begin
nim1[0:2047, row] -= median(im1[2105:2145, row])
nim1[2048:4095, row] -= median(im1[2155:2195, row])
endfor
im1tot = total(nim1)

;************************************
;        im2
;*************************************
im2 = double(readfits('rlin0002.fits', hd1))
im2t = double(sxpar(hd1, 'EXPTIME'))
;reduce the image size to just the data section, and
;fill the new array with the data:
nim2 = dblarr(4096, 4112)
nim2[0:2047, *] = im2[52:2099, *]
nim2[2048:4095, *] = im2[2199:4246, *]

;now subtract the median of the overscan region
;(with a little buffer inside of the overscan region):
for row = 0, 4111 do begin
nim2[0:2047, row] -= median(im2[2105:2145, row])
nim2[2048:4095, row] -= median(im2[2155:2195, row])
endfor
im2tot = total(nim2)


;************************************
;        im3
;*************************************
im3 = double(readfits('rlin0003.fits', hd1))
im3t = double(sxpar(hd1, 'EXPTIME'))
;reduce the image size to just the data section, and
;fill the new array with the data:
nim3 = dblarr(4096, 4112)
nim3[0:2047, *] = im3[52:2099, *]
nim3[2048:4095, *] = im3[2199:4246, *]

;now subtract the median of the overscan region
;(with a little buffer inside of the overscan region):
for row = 0, 4111 do begin
nim3[0:2047, row] -= median(im3[2105:2145, row])
nim3[2048:4095, row] -= median(im3[2155:2195, row])
endfor
im3tot = total(nim3)

;************************************
;        im4
;*************************************
im4 = double(readfits('rlin0004.fits', hd1))
im4t = double(sxpar(hd1, 'EXPTIME'))
;reduce the image size to just the data section, and
;fill the new array with the data:
nim4 = dblarr(4096, 4112)
nim4[0:2047, *] = im4[52:2099, *]
nim4[2048:4095, *] = im4[2199:4246, *]

;now subtract the median of the overscan region
;(with a little buffer inside of the overscan region):
for row = 0, 4111 do begin
nim4[0:2047, row] -= median(im4[2105:2145, row])
nim4[2048:4095, row] -= median(im4[2155:2195, row])
endfor
im4tot = total(nim4)

;************************************
;        im5
;*************************************
im5 = double(readfits('rlin0005.fits', hd1))
im5t = double(sxpar(hd1, 'EXPTIME'))
;reduce the image size to just the data section, and
;fill the new array with the data:
nim5 = dblarr(4096, 4112)
nim5[0:2047, *] = im5[52:2099, *]
nim5[2048:4095, *] = im5[2199:4246, *]

;now subtract the median of the overscan region
;(with a little buffer inside of the overscan region):
for row = 0, 4111 do begin
nim5[0:2047, row] -= median(im5[2105:2145, row])
nim5[2048:4095, row] -= median(im5[2155:2195, row])
endfor
im5tot = total(nim5)

;************************************
;        im6
;*************************************
im6 = double(readfits('rlin0006.fits', hd1))
im6t = double(sxpar(hd1, 'EXPTIME'))
;reduce the image size to just the data section, and
;fill the new array with the data:
nim6 = dblarr(4096, 4112)
nim6[0:2047, *] = im6[52:2099, *]
nim6[2048:4095, *] = im6[2199:4246, *]

;now subtract the median of the overscan region
;(with a little buffer inside of the overscan region):
for row = 0, 4111 do begin
nim6[0:2047, row] -= median(im6[2105:2145, row])
nim6[2048:4095, row] -= median(im6[2155:2195, row])
endfor
im6tot = total(nim6)

;************************************
;        im7
;*************************************
im7 = double(readfits('rlin0007.fits', hd1))
im7t = double(sxpar(hd1, 'EXPTIME'))
;reduce the image size to just the data section, and
;fill the new array with the data:
nim7 = dblarr(4096, 4112)
nim7[0:2047, *] = im7[52:2099, *]
nim7[2048:4095, *] = im7[2199:4246, *]

;now subtract the median of the overscan region
;(with a little buffer inside of the overscan region):
for row = 0, 4111 do begin
nim7[0:2047, row] -= median(im7[2105:2145, row])
nim7[2048:4095, row] -= median(im7[2155:2195, row])
endfor
im7tot = total(nim7)

;************************************
;        im8
;*************************************
im8 = double(readfits('rlin0008.fits', hd1))
im8t = double(sxpar(hd1, 'EXPTIME'))
;reduce the image size to just the data section, and
;fill the new array with the data:
nim8 = dblarr(4096, 4112)
nim8[0:2047, *] = im8[52:2099, *]
nim8[2048:4095, *] = im8[2199:4246, *]

;now subtract the median of the overscan region
;(with a little buffer inside of the overscan region):
for row = 0, 4111 do begin
nim8[0:2047, row] -= median(im8[2105:2145, row])
nim8[2048:4095, row] -= median(im8[2155:2195, row])
endfor
im8tot = total(nim8)

;************************************
;        im9
;*************************************
im9 = double(readfits('rlin0009.fits', hd1))
im9t = double(sxpar(hd1, 'EXPTIME'))
;reduce the image size to just the data section, and
;fill the new array with the data:
nim9 = dblarr(4096, 4112)
nim9[0:2047, *] = im9[52:2099, *]
nim9[2048:4095, *] = im9[2199:4246, *]

;now subtract the median of the overscan region
;(with a little buffer inside of the overscan region):
for row = 0, 4111 do begin
nim9[0:2047, row] -= median(im9[2105:2145, row])
nim9[2048:4095, row] -= median(im9[2155:2195, row])
endfor
im9tot = total(nim9)


fname=nextnameeps('nonlinearity')
ps_open, fname, /encaps, /color
times = [im1t, im2t, im3t, im4t, im5t, im6t, $
			im7t, im8t, im9t]
outpt = [im1tot, im2tot, im3tot, im4tot, im5tot, im6tot, $
			im7tot, im8tot, im9tot]
plot, times, outpt, ps=8, $
xtitle='Actual Exposure Time (Seconds)', $
ytitle='Output Signal (ADU)';, /xlog, /ylog

st = sort(times)
res = linfit(times[st], outpt[st], /double, yfit=yfit)
loadct, 39, /silent
thtimes = dindgen(1d3)/1d1
thadus = res[0] + res[1]*thtimes
oplot, thtimes, thadus, color=95
ps_close

;fname=nextnameeps('nonlinearity')
;ps_open, fname, /encaps, /color
times = [im1t, im2t, im3t, im6t, $
			im7t, im8t, im9t]
outpt = [im1tot, im2tot, im3tot,im6tot, $
			im7tot, im8tot, im9tot]
plot, times, outpt, ps=8, $
xtitle='Actual Exposure Time (Seconds)', $
ytitle='Output Signal (ADU)';, /xlog, /ylog

st = sort(times)
res = linfit(times[st], outpt[st], /double, yfit=yfit)
loadct, 39, /silent
thtimes = dindgen(1d3)/1d1
thadus = res[0] + res[1]*thtimes
oplot, thtimes, thadus, color=95
;ps_close

times = [im1t, im2t, im6t, $
			im7t, im8t, im9t]
outpt = [im1tot, im2tot, im6tot, $
			im7tot, im8tot, im9tot]
plot, times, outpt, ps=8, $
xtitle='Actual Exposure Time (Seconds)', $
ytitle='Output Signal (ADU)';, /xlog, /ylog

st = sort(times)
res = linfit(times[st], outpt[st], /double, yfit=yfit)
loadct, 39, /silent
thtimes = dindgen(1d3)/1d1
thadus = res[0] + res[1]*thtimes
oplot, thtimes, thadus, color=95



fname=nextnameeps('nonlinearity')
ps_open, fname, /encaps, /color
times = [im1t, im6t, $
			im7t, im8t, im9t]
outpt = [im1tot, im6tot, $
			im7tot, im8tot, im9tot]
plot, times, outpt, ps=8, $
xtitle='Actual Exposure Time (Seconds)', $
ytitle='Output Signal (ADU)';, /xlog, /ylog

st = sort(times)
res = linfit(times[st], outpt[st], /double, yfit=yfit)
loadct, 39, /silent
thtimes = dindgen(1d3)/1d1
thadus = res[0] + res[1]*thtimes
oplot, thtimes, thadus, color=95
ps_close

stop
end;nonlinearity.pro