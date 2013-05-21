;+
;;  NAME: 
;     chi_i2_throughput
;;  PURPOSE: To plot the throughput of the I2 cell as a function of wavelength. 
;   
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      chi_i2_throughput
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
;      chi_i2_throughput
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2011.09.30 01:35:37 PM
;
;-
pro chi_i2_throughput

;I created a few files to test this out. 
;rchi110928.1279.fits is a reduced quartz exposure with the i2 cell in the 
;optical path
;rchi110928.1511.fits is a reduced quartz exposure with the i2 cell out of
;the optical path. 

imyi = readfits('/mir7/fitspec/rchi110928.1279.fits', hdyi)
imni = readfits('/mir7/fitspec/rchi110928.1511.fits', hdni)

wavyi = dblarr(3200, 40)
specyi = dblarr(3200, 40)
wavni = dblarr(3200, 40)
specni = dblarr(3200, 40)

for i=0, 39 do begin
wavyi[*, i] = imyi[0,*,i]
specyi[*, i] = imyi[1,*,i]
wavni[*, i] = imni[0,*,i]
specni[*, i] = imni[1,*,i]
endfor
expfac = double(fxpar(hdyi, 'EXPTIME'))/double(fxpar(hdni, 'EXPTIME'))
print, 'Exposure time difference is: ', expfac
specni *= expfac
usersymbol, 'circle', size_of_sym = 0.5, /fill
loadct, 39, /silent
difarr=dblarr(40)
ps_open, nextnameeps('~/idl/CHIRON/i2plots/nfwav'), /encaps, /color, /portrait
!p.multi=[0,2,4]
for i=0, 7 do begin
plot, wavni[*,i], specni[*,i]/max(specni[*,i]), ps=8, $
xtitle='Wavelength [Angstroms]', $
ytitle='Normalized Flux', $
title='Order '+strt(i), /xsty, /ysty
oplot, wavyi[*,i], specyi[*,i]/max(specni[*,i]), ps=8, color=210
dif = total(specyi[*,i])/total(specni[*,i])
difarr[i] = dif
xpos = wavyi[1070, i]
xyouts, xpos, 0.2, 'I2/noI2: '+strt(dif, f='(F6.2)')
xyouts, xpos, 0.3, 'Max flux: '+strt(max(specni[*,i]), f='(I12)')
print, 'Difference for order '+strt(i)+': '+strt(dif, f='(F6.2)')
legendpro, ['noI2', 'I2'], colors=[0,210], psym=[8,8]
;wait, 2
endfor
ps_close


ps_open, nextnameeps('~/idl/CHIRON/i2plots/nfwav'), /encaps, /color, /portrait
!p.multi=[0,2,4]
for i=8, 15 do begin
plot, wavni[*,i], specni[*,i]/max(specni[*,i]), ps=8, $
xtitle='Wavelength [Angstroms]', $
ytitle='Normalized Flux', $
title='Order '+strt(i), /xsty, /ysty
oplot, wavyi[*,i], specyi[*,i]/max(specni[*,i]), ps=8, color=210
dif = total(specyi[*,i])/total(specni[*,i])
difarr[i] = dif
xpos = wavyi[1070, i]
xyouts, xpos, 0.2, 'I2/noI2: '+strt(dif, f='(F6.2)')
xyouts, xpos, 0.3, 'Max flux: '+strt(max(specni[*,i]), f='(I12)')
print, 'Difference for order '+strt(i)+': '+strt(dif, f='(F6.2)')
legendpro, ['noI2', 'I2'], colors=[0,210], psym=[8,8]
;wait, 2
endfor
ps_close

ps_open, nextnameeps('~/idl/CHIRON/i2plots/nfwav'), /encaps, /color, /portrait
!p.multi=[0,2,4]
for i=16, 23 do begin
plot, wavni[*,i], specni[*,i]/max(specni[*,i]), ps=8, $
xtitle='Wavelength [Angstroms]', $
ytitle='Normalized Flux', $
title='Order '+strt(i), /xsty, /ysty
oplot, wavyi[*,i], specyi[*,i]/max(specni[*,i]), ps=8, color=210
dif = total(specyi[*,i])/total(specni[*,i])
difarr[i] = dif
xpos = wavyi[1070, i]
xyouts, xpos, 0.2, 'I2/noI2: '+strt(dif, f='(F6.2)')
xyouts, xpos, 0.3, 'Max flux: '+strt(max(specni[*,i]), f='(I12)')
print, 'Difference for order '+strt(i)+': '+strt(dif, f='(F6.2)')
legendpro, ['noI2', 'I2'], colors=[0,210], psym=[8,8]
;wait, 2
endfor
ps_close

ps_open, nextnameeps('~/idl/CHIRON/i2plots/nfwav'), /encaps, /color, /portrait
!p.multi=[0,2,4]
for i=24, 35 do begin
plot, wavni[*,i], specni[*,i]/max(specni[*,i]), ps=8, $
xtitle='Wavelength [Angstroms]', $
ytitle='Normalized Flux', $
title='Order '+strt(i), /xsty, /ysty
oplot, wavyi[*,i], specyi[*,i]/max(specni[*,i]), ps=8, color=210
dif = total(specyi[*,i])/total(specni[*,i])
difarr[i] = dif
xpos = wavyi[1070, i]
xyouts, xpos, 0.2, 'I2/noI2: '+strt(dif, f='(F6.2)')
xyouts, xpos, 0.3, 'Max flux: '+strt(max(specni[*,i]), f='(I12)')
print, 'Difference for order '+strt(i)+': '+strt(dif, f='(F6.2)')
legendpro, ['noI2', 'I2'], colors=[0,210], psym=[8,8]
;wait, 2
endfor
ps_close

ps_open, nextnameeps('~/idl/CHIRON/i2plots/nfwav'), /encaps, /color, /portrait
!p.multi=[0,2,4]
for i=36, 39 do begin
plot, wavni[*,i], specni[*,i]/max(specni[*,i]), ps=8, $
xtitle='Wavelength [Angstroms]', $
ytitle='Normalized Flux', $
title='Order '+strt(i), /xsty, /ysty
oplot, wavyi[*,i], specyi[*,i]/max(specni[*,i]), ps=8, color=210
dif = total(specyi[*,i])/total(specni[*,i])
difarr[i] = dif
xpos = wavyi[1070, i]
xyouts, xpos, 0.2, 'I2/noI2: '+strt(dif, f='(F6.2)')
xyouts, xpos, 0.3, 'Max flux: '+strt(max(specni[*,i]), f='(I12)')
print, 'Difference for order '+strt(i)+': '+strt(dif, f='(F6.2)')
legendpro, ['noI2', 'I2'], colors=[0,210], psym=[8,8]
;wait, 2
endfor
ps_close

stop

;ps_open, nextnameeps('~/idl/CHIRON/i2plots/difarr'), /encaps, /color, /portrait
;!p.multi=[0,1,1]

plot, difarr, ps=8, $
xtitle='Order', $
ytitle='Total(I2)/Total(no I2) for Order'





stop



print, 'total difference: ', total(specyi)/total(specni)
difspec = specyi/specni
;img = image(difspec, rgb_table=13, title='I2 Spec / no I2 Spec')
display, difspec, title='I2 Spec / no I2 Spec', levels = dindgen(256)/255d, $
xtitle='Dispersion Direction [pixels]', $
ytitle='Order'
colorbar, ncolors = 256, min = 0d, max = 1d
stop
end;chi_i2_throughput.pro