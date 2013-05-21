;+
;
;  NAME: 
;     rotate_ccd
;
;  PURPOSE: 
;   To rotate the CCD to maintain resolution while
;	allowing for on-chip binning. 
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      rotate_ccd
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
;      rotate_ccd
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2011.03.11 11:58:41 AM
;
;-
pro rotate_ccd, filename= filename, ps=ps

  if ~keyword_set(filename) then filename = '/mir7/n1/qa30_0146.fits'
 ;For Alternate input file
  IF keyword_set(inpfile) then filename = inpfile
biasfn = '/mir7/data/110310/qa31.1000.fits'
bias = readfits(biasfn)
bias_t = double(transpose(bias))
; rdfits,im,filename
  imo = double(readfits(filename, header))
; display,imo,/log

;  bbl = sxpar(header, 'bsec11')
;  bbr = sxpar(header, 'bsec12')
;  bul = sxpar(header, 'bsec21')
;  bur = sxpar(header, 'bsec22')

loadct, 39, /silent
;returns x1, y1, x2, y2
;bblarr = str_coord_split(sxpar(header, 'bsec11')) - 1d
;bbrarr = str_coord_split(sxpar(header, 'bsec12')) - 1d
bularr = str_coord_split(sxpar(header, 'bsec21')) - 1d
burarr = str_coord_split(sxpar(header, 'bsec22')) - 1d

;datblarr = str_coord_split(sxpar(header, 'dsec11')) - 1d
;datbrarr = str_coord_split(sxpar(header, 'dsec12')) - 1d
datularr = str_coord_split(sxpar(header, 'dsec21')) - 1d
daturarr = str_coord_split(sxpar(header, 'dsec22')) - 1d
;stop
;bbl (11)
;for i=datblarr[2], datblarr[3] do begin
;  imo[datblarr[0]:datblarr[1], i] = $
;  imo[datblarr[0]:datblarr[1], i] - $
;  median(imo[(bblarr[0]+2):(bblarr[1]-3), i])
;  ;median(imo[1:47, i])
;endfor

;bul (21)
for i=datularr[2], datularr[3] do begin
  imo[datularr[0]:datularr[1], i] = $
  imo[datularr[0]:datularr[1], i] - $
  median(imo[(bularr[0]+2):(bularr[1]-3), i])
  ;imo[101:2148, i] = imo[101:2148, i] - median(imo[1:47, i])
endfor

;bbr (12)
;for i=0, 2047 do begin
;for i=datbrarr[2], datbrarr[3] do begin
;  imo[datbrarr[0]:datbrarr[1], i] = $
;  imo[datbrarr[0]:datbrarr[1], i] - $
;  median(imo[(bbrarr[0]+2):(bbrarr[1]-3), i])
;;imo[2149:4196, i] = imo[2149:4196, i] - median(imo[4249:4294, i])
;endfor

;bur (22)
;for i=2048, 4095 do begin
for i=daturarr[2], daturarr[3] do begin
  imo[daturarr[0]:daturarr[1], i] = $
  imo[daturarr[0]:daturarr[1], i] - $
  median(imo[(burarr[0]+2):(burarr[1]-3), i])
;imo[2149:4196, i] = imo[2149:4196, i] - median(imo[4249:4294, i])
endfor


  imo_t = transpose(imo)
  im = double(imo_t)
  loadct,0, /silent

window, 0, xsize=1800, ysize=1200
     titl = '!6 CTIO THORIUM FOCUS LINES'
     yt='ROW #'
     xt='COL #'
x0 = 102d
y0 = 1500d
y00 = 2000d
sizim = size(im)
xvec = indgen(sizim[1]-round(x0))+x0
yvec = indgen(round(y00)-round(y0)+1)+y0

     display,im[x0:*, y0:y00],xvec, yvec, titl=titl,ytit=yt,xtit=xt,/log; min=20, max=50000d;,/log

loadct, 39, /silent

oplot, [2048, 2048], [0,5000], color=240

for i=0, 20 do begin
oplot, [i*256, i*256], [0,5000], color=250, linestyle=3
endfor

for i=0, 5 do begin
oplot, [0, 4096], y0+[i*100,i*100], color=250, linestyle=3
endfor

;NOW THE CURSOR PROCEDURE
sz = 10
cursor, x1, y1, /down
print, x1, y1
oplot, [(x1-sz),(x1+sz)], [(y1-sz),(y1-sz)], color=240           
oplot, [(x1-sz),(x1+sz)], [(y1+sz),(y1+sz)], color=240
oplot, [(x1-sz),(x1-sz)], [(y1-sz),(y1+sz)], color=240
oplot, [(x1+sz),(x1+sz)], [(y1-sz),(y1+sz)], color=240

cursor, x2, y2, /down
print, x2, y2
oplot, [(x2-sz),(x2+sz)], [(y2-sz),(y2-sz)], color=240           
oplot, [(x2-sz),(x2+sz)], [(y2+sz),(y2+sz)], color=240
oplot, [(x2-sz),(x2-sz)], [(y2-sz),(y2+sz)], color=240
oplot, [(x2+sz),(x2+sz)], [(y2-sz),(y2+sz)], color=240


if keyword_set(ps) then begin
	mypsopen, 'rotation_ccd.eps'
	  loadct,0, /silent
	display,im[x0:*, y0:y00],xvec, yvec, titl=titl,ytit=yt,xtit=xt,/log
	  loadct,39, /silent
	  oplot, [2048, 2048], [0,500], color=240

	for i=0, 20 do begin
		oplot, [i*256, i*256], [0,500], color=250, linestyle=3
	endfor
	
	oplot, [(x1-sz),(x1+sz)], [(y1-sz),(y1-sz)], color=240           
	oplot, [(x1-sz),(x1+sz)], [(y1+sz),(y1+sz)], color=240
	oplot, [(x1-sz),(x1-sz)], [(y1-sz),(y1+sz)], color=240
	oplot, [(x1+sz),(x1+sz)], [(y1-sz),(y1+sz)], color=240
	
	oplot, [(x2-sz),(x2+sz)], [(y2-sz),(y2-sz)], color=240           
	oplot, [(x2-sz),(x2+sz)], [(y2+sz),(y2+sz)], color=240
	oplot, [(x2-sz),(x2-sz)], [(y2-sz),(y2+sz)], color=240
	oplot, [(x2+sz),(x2+sz)], [(y2-sz),(y2+sz)], color=240
	psclose
endif

mash1 = total(im[(x1-sz):(x1+sz), (y1 - sz):(y1 + sz)], 1)
gfac1 = gaussfit(indgen(2d*sz+1), mash1, acoef1, nterms=4)
window, 2
plot, mash1, $
xtitle='Cross Dispersion Position for Box 1 (Pix)', $
ytitle='Counts'
oplot, gfac1, color=80
;stop

mash1d = total(im[(x1-sz):(x1+sz), (y1 - sz):(y1 + sz)], 2)
gfac1d = gaussfit(indgen(2d*sz+1), mash1d, acoef1d, nterms=4)
print, 'the FWHM of the 1st line in the D direction is: ', $
acoef1d[2] * 2.3548d


mash2 = total(im[(x2-sz):(x2+sz), (y2 - sz):(y2 + sz)], 1)
window, 3
plot, mash2, $
xtitle='Cross Dispersion Position for Box 2 (Pix)', $
ytitle='Counts'

mash2d = total(im[(x0+x2-sz):(x0+x2+sz), (y0+y2 - sz):(y0+y2 + sz)], 2)
gfac2d = gaussfit(indgen(2d*sz+1), mash2d, acoef2d, nterms=4)
print, 'the FWHM of the 2nd line in the D direction is: ', $
acoef2d[2] * 2.3548d


gfac2 = gaussfit(indgen(2d*sz+1), mash2, acoef2, nterms=4)
oplot, gfac2, color=80

cy1 = acoef1[1] + y0 + y1
cy2 = acoef2[1] + y0 + y2

print, 'the central row of the first line is: ', cy1
print, 'the central row of the second line is: ', cy2
print, 'the difference for Julien is: ', cy2 - cy1
;print, 'the difference for Chris is: ', (cy2 - cy1) * 20d*randomu(seed)

print, 'the difference in x is: ', x2 - x1

end; rotate_ccd.pro