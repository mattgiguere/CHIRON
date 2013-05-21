;+
;
;  NAME: 
;     chi_flat_test_3x1
;
;  PURPOSE: 
;     To see how the spectra come out when using various slicer
;		modes for the flat fielding frames. This time for 
;		the case when it's binned 3x1
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      chi_flat_test
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
;      chi_flat_test
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2011.03.10 07:12:18 PM
;
;-
pro chi_flat_test_3x1

biasfn = '/mir7/raw/110310/qa31.1024.fits'
bias = double(readfits(biasfn))


;flatnarslitfn = '/mir7/raw/110310/qa31.1023.fits' 1x1
;flatnarslitfn = '/mir7/raw/110310/qa31.1002.fits' 1x1
;flatnarslitfn = '/mir7/raw/110309/qa31.0087.fits' 1x1
flatnarslitfn = '/mir7/raw/110309/qa31.0110.fits' ;3x1
flatnarslit = double(readfits(flatnarslitfn))

;stop

;flatnarslit -= bias

;flatnarslitfnn1 = '/mir7/raw/110309/qa31.0037.fits' 1x1
;flatnarslitfnn1 = '/mir7/raw/110310/qa31.0118.fits' 1x1
flatnarslitfnn1 = '/mir7/raw/110310/qa31.1025.fits' ;3x1

flatnarslitn1 = double(readfits(flatnarslitfnn1))
;flatnarslitn1 -= bias


loadct, 39, /silent

!p.thick = 3
!x.thick = 3
!y.thick = 3

plot, flatnarslit[*, 2000]
xfit1 = 600
xfit2 = 620
plot, flatnarslit[xfit1:xfit2, 2000] 
print, 'you are here.'
stop
;ps_open, '~/narrowcomp', /encaps, /color
plot, flatnarslit[xfit1:xfit2, 2000] / max(flatnarslit[xfit1:xfit2, 2000]), color=0, $
xtitle='Cross Dispersion Direction [pix]', $
ytitle='Normalized Counts'
oplot, flatnarslitn1[xfit1:xfit2, 2000] / $
	max(flatnarslitn1[xfit1:xfit2, 2000]), color=240
legendpro, ['110309', '110310'], linestyle=[0,0], color=[0,240]
;ps_close

stop

;NOW TO GAUSSFIT ONE OF THE ORDERS FOR EACH OF THE TWO QUARTZ 
;EXPOSURES EACH WITH THE NARROW SLIT:

x = lindgen((xfit2 - xfit1)+1) + xfit1
y1 = flatnarslit[xfit1:xfit2, 2000] / max(flatnarslit[xfit1:xfit2, 2000])
y2 = flatnarslitn1[xfit1:xfit2, 2000] / max(flatnarslitn1[xfit1:xfit2, 2000])

res1 = gaussfit(x, y1, coeff1)
res2 = gaussfit(x, y2, coeff2)

fnpxs = nextnameeps('pixelshift')
ps_open, fnpxs, /encaps, /color
plot, x, y1, color=0, $
xtitle='Cross Dispersion Direction [pix]', $
ytitle='Normalized Counts'
oplot, x, y2, color=240
legendpro, ['110309', '110310'], linestyle=[0,0], color=[0,240]

oplot, x, res1, linestyle=3
oplot, x, res2, linestyle=3, color=240
xyouts, 0.7, 0.8, 'Center 1: '+strt(coeff1[1], f='(F8.2)'), /normal
xyouts, 0.7, 0.75, 'Center 2: '+strt(coeff2[1], f='(F8.2)'), /normal, color=240
ps_close
stop





ps_open, '~/fullcomp', /encaps, /color
plot, flatfib[1800:1900, 2000] / max(flatfib[1800:1900, 2000]), $
color=0, $
xtitle='Cross Dispersion Direction [pix]', $
ytitle='Normalized Counts'
oplot, flatslicer[1800:1900, 2000]/ $
max(flatslicer[1800:1900, 2000]), col=80
oplot, flatslit[1800:1900, 2000] / $
max(flatslit[1800:1900, 2000]), color=120
oplot, flatnarslit[1800:1900, 2000] / $
max(flatnarslit[1800:1900, 2000]), color=240
legendpro, ['Fiber', 'Slicer', 'Slit', 'Narrow'], $
linestyle=[0,0, 0, 0], color=[0,80, 120, 240], $
position=[0.4,0.9], /normal
ps_close

xfc1 = 1851L
xfc2 = 1900L
ps_open, '~/fullcomp2', /encaps, /color
plot, flatfib[xfc1:xfc2, 2000] / max(flatfib[xfc1:xfc2, 2000]), $
color=0, $
xtitle='Cross Dispersion Direction [pix]', $
ytitle='Normalized Counts'
oplot, flatslicer[xfc1:xfc2, 2000]/ $
max(flatslicer[xfc1:xfc2, 2000]), col=80
oplot, flatslit[xfc1:xfc2, 2000] / $
max(flatslit[xfc1:xfc2, 2000]), color=120
oplot, flatnarslit[xfc1:xfc2, 2000] / $
max(flatnarslit[xfc1:xfc2, 2000]), color=240
legendpro, ['Fiber', 'Slicer', 'Slit', 'Narrow'], $
linestyle=[0,0, 0, 0], color=[0,80, 120, 240], $
position=[0.75,0.9], /normal
ps_close


stop
end;chi_flat_test_3x1.pro