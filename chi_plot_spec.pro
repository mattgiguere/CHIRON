;+
;
;  NAME: 
;     chi_plot_spec
;
;  PURPOSE: To plot the spectrum of a star taken with CHIRON
;   
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      chi_plot_spec
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
;      chi_plot_spec
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2011.09.01 04:24:26 PM
;
;-
pro chi_plot_spec, $
postplot = postplot, $
ords = ords, $
fname = fname

if ~keyword_set(fname) then fname = 'rqa38.3073.fits'
im = readfits('/tous/mir7/fitspec/'+fname, hd)

if keyword_set(ords) then ord=ords else ord=20
wav = dblarr(3200, 40)
spec = dblarr(3200, 40)

for i=0, 39 do wav[*, i] = im[0,*,i]
for i=0, 39 do spec[*, i] = im[1,*,i]

if 1 eq 0 then begin
ord = 0
p1 = plot(wav[*, ord], spec[*, ord], $
xtitle='Wavelength $\AA$', $
ytitle='Flux', $
title='CHIRON Spec of Alpha Cen Taken on 20110706 of Order '+strt(ord), $
/xstyle, /ystyle)

ord = 39
p2 = plot(wav[*, ord], spec[*, ord], $
xtitle='Wavelength $\AA$', $
ytitle='Flux', $
title='CHIRON Spec of Alpha Cen Taken on 20110706 of Order '+strt(ord), $
/xstyle, /ystyle)

ord = 37
p2 = plot(wav[*, ord], spec[*, ord], $
xtitle='Wavelength $\AA$', $
ytitle='Flux', $
title='CHIRON Spec of Alpha Cen Taken on 20110706 of Order '+strt(ord), $
/xstyle, /ystyle)
endif

window, /free, xsize = 2000, ysize=1300, xpos = 2000
;for ord = 0, 39 do begin
;window, /free
plot,wav[*, ord], spec[*, ord], $
xtitle='Wavelength $\AA$', $
ytitle='Flux', $
title='CHIRON Spec of Alpha Cen Taken on 20110706 of Order '+strt(ord), $
/xstyle, /ystyle
if keyword_set(ords) then stop
;wait, 1
;endfor

imo = double(readfits('/mir7/raw/110706/qa38.3073.fits', header))

bularr = str_coord_split(sxpar(header, 'bsec21')) - 1d
burarr = str_coord_split(sxpar(header, 'bsec22')) - 1d

datularr = str_coord_split(sxpar(header, 'dsec21')) - 1d
daturarr = str_coord_split(sxpar(header, 'dsec22')) - 1d
;bul (21)
for i=datularr[2], datularr[3] do begin
  imo[datularr[0]:datularr[1], i] = $
  imo[datularr[0]:datularr[1], i] - $
  median(imo[(bularr[0]+2):(bularr[1]-3), i])
  ;imo[101:2148, i] = imo[101:2148, i] - median(imo[1:47, i])
endfor

;bur (22)
for i=daturarr[2], daturarr[3] do begin
  imo[daturarr[0]:daturarr[1], i] = $
  imo[daturarr[0]:daturarr[1], i] - $
  median(imo[(burarr[0]+2):(burarr[1]-3), i])
endfor

;ps_open, '~/Desktop/AlphaCen38.3073', /encaps, /color

loadct, 40, /silent
display, imo, /log, title='qa38.3073: Alpha Cen on 110706', min=2.5d2, max=3d3
;ps_close
print, minmax(imo)
;stop


 loadct, 8, /silent
 ;ps_open, '~/Desktop/ac_ct8_green_box_ROI2', /encaps, /color
 display, imo, /log, title='qa38.3073: Alpha Cen on 110706', min=2.5d2, max=3d3
 loadct, 39, /silent
 oplot, [872,872], [0, 4d3], color=240
 oplot, [890,890], [0, 4d3], color=240
 oplot, [850,850], [0, 4d3], color=80
 oplot, [867,867], [0, 4d3], color=80 
 ;ps_close
 linemash3 = total(imo[850:867, *], 1)
window, /free, xsize = 2000, ysize=1300, xpos = 2000 
;ps_open, '~/Desktop/ac_rawmash8', /encaps, /color 
 plot, linemash3, title='qa38.3073: Alpha Cen Raw Mash im[850:867, *]', $
 xtitle='Cross Dispersion [px]', ytitle='Counts', /xsty, /ysty
 ;ps_close
window, /free, xsize = 2000, ysize=1300, xpos = 2000 
;ps_open, '~/Desktop/ac_reduce_wav_soln8', /encaps, /color
 ord = 8
 plot,wav[*, ord], spec[*, ord], $
 xtitle='Wavelength $\AA$', $
 ytitle='Flux', $
 title='CHIRON Spec of Alpha Cen Taken on 20110706 of Order '+strt(ord), $
 /xstyle, /ystyle
 ;ps_close
if keyword_set(postplot) then begin
ps_open, nextnameeps('~/Desktop/ac_orders_labeled'), /encaps, /color
!p.font=1
!p.charsize=0.5
endif else begin
winup, /all
window, /free, xsize = 2000, ysize=1300, xpos = 2000

endelse

loadct, 8, /silent
 display, imo, /log, title='CHIRON Observation qa38.3073: Alpha Cen on 110706', $
 min=2.5d2, max=3d3
 loadct, 39, /silent

xs = 1036
oplot, [xs,xs], [80,250], color=240
xyouts, xs, 25, '0', color=240, alignment = 0.5

xs = 1013
oplot, [xs,xs], [80,420], color=240
xyouts, xs, 25, '1', color=240, alignment = 0.5

xs = 990
oplot, [xs,xs], [80,400], color=240
xyouts, xs, 25, '2', color=240, alignment = 0.5

xs = 967
oplot, [xs,xs], [80,365], color=240
xyouts, xs, 25, '3', color=240, alignment = 0.5

xs = 944
oplot, [xs,xs], [80,325], color=240
xyouts, xs, 25, '4', color=240, alignment = 0.5

xs = 922
oplot, [xs,xs], [80,315], color=240
xyouts, xs, 25, '5', color=240, alignment = 0.5

xs = 901
oplot, [xs,xs], [80,315], color=240
xyouts, xs, 25, '6', color=240, alignment = 0.5

xs = 880
oplot, [xs,xs], [80,300], color=240
xyouts, xs, 25, '7', color=240, alignment = 0.5

xs = 860
oplot, [xs,xs], [80,285], color=240
xyouts, xs, 25, '8', color=240, alignment = 0.5

xs = 840
oplot, [xs,xs], [80,270], color=240
xyouts, xs, 25, '9', color=240, alignment = 0.5

xs = 820
oplot, [xs,xs], [80,270], color=240
xyouts, xs, 25, '10', color=240, alignment = 0.5

xs = 798
oplot, [xs,xs], [80,250], color=240
xyouts, xs, 25, '11', color=240, alignment = 0.5

xs = 778
oplot, [xs,xs], [80,180], color=240
xyouts, xs, 25, '12', color=240, alignment = 0.5

xs = 758
oplot, [xs,xs], [80,170], color=240
xyouts, xs, 25, '13', color=240, alignment = 0.5

xs = 738
oplot, [xs,xs], [80,170], color=240
xyouts, xs, 25, '14', color=240, alignment = 0.5

xs = 688
oplot, [xs,xs], [80,170], color=240
xyouts, xs, 25, '15', color=240, alignment = 0.5

xs = 669
xyouts, xs, 25, '16', color=240, alignment = 0.5

xs = 650
xyouts, xs, 25, '17', color=240, alignment = 0.5

xs = 631
xyouts, xs, 25, '18', color=240, alignment = 0.5

xs = 615
xyouts, xs, 25, '19', color=240, alignment = 0.5

xs = 597
xyouts, xs, 25, '20', color=240, alignment = 0.5

xs = 580
xyouts, xs, 25, '21', color=240, alignment = 0.5

xs = 563
xyouts, xs, 25, '22', color=240, alignment = 0.5

xs = 545
xyouts, xs, 25, '23', color=240, alignment = 0.5

xs = 528
xyouts, xs, 25, '24', color=240, alignment = 0.5

xs = 510
xyouts, xs, 25, '25', color=240, alignment = 0.5

xs = 493
xyouts, xs, 25, '26', color=240, alignment = 0.5

xs = 476
xyouts, xs, 25, '27', color=240, alignment = 0.5

xs = 459
xyouts, xs, 25, '28', color=240, alignment = 0.5

xs -= 17
xyouts, xs, 25, '29', color=240, alignment = 0.5

xs -= 16
xyouts, xs, 25, '30', color=240, alignment = 0.5

xs -= 16
xyouts, xs, 25, '31', color=240, alignment = 0.5

xs -= 16
xyouts, xs, 25, '32', color=240, alignment = 0.5

xs -= 16
xyouts, xs, 25, '33', color=240, alignment = 0.5

xs -= 16
xyouts, xs, 25, '34', color=240, alignment = 0.5

xs -= 15
xyouts, xs, 25, '35', color=240, alignment = 0.5

xs -= 15
xyouts, xs, 25, '36', color=240, alignment = 0.5

xs -= 15
xyouts, xs, 25, '37', color=240, alignment = 0.5

xs -= 15
xyouts, xs, 25, '38', color=240, alignment = 0.5

xs -= 14
xyouts, xs, 25, '39', color=240, alignment = 0.5

xyouts, 1070, 3600, '4544 '+STRING("305B), color=240, orientation = 90d

xyouts, 1040, 300, '4589 '+STRING("305B), color=240, orientation = 90d

xyouts, 880, 1500, 'H!d'+greek('beta')+'!n', color=240

xyouts, 856, 2190, 'Fe I (c)', color=240

xyouts, 738, 900, 'Mg I (b!d1!n)', color=240

xyouts, 738, 1550, 'Mg I (b!d2!n)', color=240

xyouts, 738, 3400, 'Mg I (b!d1!n)', color=240

xyouts, 476, 700, 'Na I (D!d2!n)', color=240

xyouts, 476, 3500, 'Na I (D!d2!n)', color=240

xyouts, 476, 3300, 'Na I (D!d1!n)', color=240

xyouts, 317, 1250, 'H!d'+greek('alpha')+'!n', color=240

xyouts, 305, 3850, '6640 '+STRING("305B), color=240, orientation = 90d

xyouts, 290, 100, '6740 '+STRING("305B), color=240, orientation = 90d





if keyword_set(postplot) then begin
ps_close
endif



stop
end;chi_plot_spec.pro