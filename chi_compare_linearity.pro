;+
;
;  NAME: 
;     chi_compare_linearity
;
;  PURPOSE: 
;   This procedure was designed to compare 2 spectra, one reduced
;	taking the 2nd order non-linearity correction into account, and
;	the other not taking the non-linearity correection into account. 
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      chi_compare_linearity
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
;      chi_compare_linearity
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2011.04.12 06:58:15 PM
;
;-
pro chi_compare_linearity
loadct, 39, /silent

pfn = '/mir7/fitspec/prenonlincor/rqa31.4538.fits'
res1 = readfits(pfn, h1)
r1s = size(res1)
im1 = dblarr(r1s[2], r1s[3])
for i=0, r1s[3]-1 do im1[*, i] = res1[1, *, i]
display, im1
;stop
cfn = '/mir7/fitspec/rqa31.4538.fits'
res2 = readfits(cfn, h2)
r2s = size(res2)
im2 = dblarr(r2s[2], r2s[3])
for i=0, r2s[3]-1 do  im2[*, i] = res2[1, *, i]

psdir = '/home/matt/Documents/ASTROPHYSICS/RESEARCH/OBSERVING'+$
		'/CHIRON/COMMISSIONING/nonlinearity_correction/'
ps_open, psdir+'after2', /encaps, /color
display, im2, $
xtitle='Dispersion Direction (px)', $
ytitle='Cross Dispersion Direction (order)', $
title='Non-linearity corrected rqa31.4538 (Alpha Cen A Through the Slicer)'
ps_close
;stop
dif = im1/im2
ps_open, psdir+'quotient', /encaps, /color
display, dif, $
xtitle='Dispersion Direction (px)', $
ytitle='Cross Dispersion Direction (order)', $
title='Non-linearity Correction (rqa31.4538 before)/(rqa31.4538 after) (Alpha Cen A Through the Slicer)'
ps_close

ord2plt=37
ps_open, psdir+'single_order1', /encaps, /color
plot, res2[0,*,ord2plt], dif[*,ord2plt], $
xtitle='Wavelength (A)', $
ytitle='Flux_NLC (before) / Flux_LC (after)', /ysty, /xsty
ps_close

stop
p1=plot(res2[0,*,ord2plt], res1[1,*,ord2plt], $
xtitle='Wavelength (A)', $
ytitle='Flux', /ysty, /xsty, $
sym_color='red', name='Before Correction')

p2=plot(res2[0,*,ord2plt], res2[1,*,ord2plt], $
color='green', name='After Correction', /over)

l1 = legend(target=[p1,p2], position = [0.15,0.25], /normal)
p1.Save, psdir+'ordcomp.eps'
stop
end;chi_compare_linearity.pro