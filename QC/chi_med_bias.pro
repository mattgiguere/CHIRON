;+
;
;  NAME: 
;     chi_med_bias
;
;  PURPOSE: 
;   
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      chi_med_bias
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
;      chi_med_bias
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2012.03.12 03:58:21 PM
;
;-
pro chi_med_bias, $
help = help, $
postplot = postplot, $
log, $
fast = fast, $
normal = normal, $
bin31 = bin31, $
bin11 = bin11, $
dir = dir


if keyword_set(help) then begin
	print, '*************************************************'
	print, '*************************************************'
	print, '        HELP INFORMATION FOR chi_med_bias'
	print, 'KEYWORDS: '
	print, ''
	print, 'HELP: Use this keyword to print all available arguments'
	print, ''
	print, ''
	print, ''
	print, '*************************************************'
	print, '                     EXAMPLE                     '
	print, "IDL>"
	print, 'IDL> '
	print, '*************************************************'
	stop
endif

loadct, 39, /silent
usersymbol, 'circle', /fill, size_of_sym = 0.5

date = log[0].date

bobs = where(strt(log.object) eq 'bias' and strt(log.ccdsum) eq '3 1' and strt(log.speedmod) eq 'normal', bobsct)
allbobs = where(strt(log.ccdsum) eq '3 1' and strt(log.speedmod) eq 'normal', a31nct)

   pdir = dir+'plots/'
   ;first test the bias date directory, and make it for the new year if need be:
   bdatedir = pdir+'bias/20'+strmid(date,0,2)
   if ~file_test(bdatedir, /directory) then spawn, 'mkdir '+bdatedir
   if ~file_test(pdir+'bias') then spawn, 'mkdir '+pdir+'bias'
   if ~file_test(pdir+'bias/20'+strmid(date, 0, 2)) then spawn, 'mkdir '+pdir+'bias/20'+strmid(date, 0, 2)
   bfn = pdir+'bias/20'+strmid(date, 0, 2)+'/'+date+'bias31n'
   if file_test(bfn) then spawn, 'mv '+bfn+' '+nextnameeps(bfn+'_old')
   title = 'Median Bias of '+strt(bobsct)+' 3x1 Normal Exposures'

if keyword_set(bin11) and keyword_set(normal) then begin
  bobs = where(strt(log.object) eq 'bias' and strt(log.ccdsum) eq '1 1' and strt(log.speedmod) eq 'normal', bobsct)
  allbobs = where(strt(log.ccdsum) eq '1 1' and strt(log.speedmod) eq 'normal', a31nct)
   bfn = pdir+'bias/20'+strmid(date, 0, 2)+'/'+date+'bias11n'
   if file_test(bfn) then spawn, 'mv '+bfn+' '+nextnameeps(bfn+'_old')
   title = 'Median Bias of '+strt(bobsct)+' 1x1 Normal Exposures'
endif

if keyword_set(bin11) and keyword_set(fast) then begin
  bobs = where(strt(log.object) eq 'bias' and strt(log.ccdsum) eq '1 1' and strt(log.speedmod) eq 'fast', bobsct)
  allbobs = where(strt(log.ccdsum) eq '1 1' and strt(log.speedmod) eq 'fast', a31nct)
   bfn = pdir+'bias/20'+strmid(date, 0, 2)+'/'+date+'bias11f'
   if file_test(bfn) then spawn, 'mv '+bfn+' '+nextnameeps(bfn+'_old')
   title = 'Median Bias of '+strt(bobsct)+' 1x1 Fast Exposures'
endif

if keyword_set(bin31) and keyword_set(fast) then begin
  bobs = where(strt(log.object) eq 'bias' and strt(log.ccdsum) eq '3 1' and strt(log.speedmod) eq 'fast', bobsct)
  allbobs = where(strt(log.ccdsum) eq '3 1' and strt(log.speedmod) eq 'fast', a31nct)
   bfn = pdir+'bias/20'+strmid(date, 0, 2)+'/'+date+'bias31f'
   if file_test(bfn) then spawn, 'mv '+bfn+' '+nextnameeps(bfn+'_old')
   title = 'Median Bias of '+strt(bobsct)+' 3x1 Fast Exposures'
endif

if bobsct gt 2 then begin
bcube = dblarr(long(log[bobs[0]].naxis1), long(log[bobs[0]].naxis2), bobsct)
for i=0, bobsct-1 do begin
bcube[*,*,i] = readfits(log[bobs[i]].filename, hd)
endfor
bobsmed = median(bcube, /double, dimen=3)
chipst1 = chip_geometry(hd=hd)

log[allbobs].medbias = $
[median(bobsmed[chipst1.image_trim.upleft]), $
median(bobsmed[chipst1.image_trim.upright]), $
median(bobsmed[chipst1.image_trim.botleft]), $
median(bobsmed[chipst1.image_trim.botright])]

gul = chipst1.gain.upleft
gur = chipst1.gain.upright
gbl = chipst1.gain.botleft
gbr = chipst1.gain.botright

log[allbobs].readnoise = $
[stddev(bobsmed[chipst1.image_trim.upleft[0]:$
chipst1.image_trim.upleft[1], $
chipst1.image_trim.upleft[2]:$
chipst1.image_trim.upleft[3]])*gul, $
stddev(bobsmed[chipst1.image_trim.upright[0]:$
chipst1.image_trim.upright[1], $
chipst1.image_trim.upright[2]:$
chipst1.image_trim.upright[3]])*gur, $
stddev(bobsmed[chipst1.image_trim.botleft[0]:$
chipst1.image_trim.botleft[1], $
chipst1.image_trim.botleft[2]:$
chipst1.image_trim.botleft[3]])*gbl, $
stddev(bobsmed[chipst1.image_trim.botright[0]:$
chipst1.image_trim.botright[1], $
chipst1.image_trim.botright[2]:$
chipst1.image_trim.botright[3]])*gbr]*sqrt(bobsct)
print, 'readnoise is: ', log[allbobs[0]].readnoise

if keyword_set(postplot) then begin
   thick, 2
   ps_open, bfn, /encaps, /color
endif

display, bobsmed, /hist, $
ytitle='Dispersion Direction (px)', $
xtitle='Cross Dispersion Direction (px)', $
title=title

oplot_square, chipst1.image_trim.upleft, linestyle = 0, thick=5, color=100
oplot_square, chipst1.image_trim.upright, linestyle = 0, thick=5, color=210
oplot_square, chipst1.image_trim.botleft, linestyle = 0, thick=5, color=250
oplot_square, chipst1.image_trim.botright, linestyle = 0, thick=5, color=30
if keyword_set(postplot) then begin
   ps_close
   spawn, 'convert -density 200 '+bfn+'.eps '+bfn+'.png'
   spawn, 'chmod 777 '+bfn+'*'
;   stop
endif


lognm = '/mir7/logstructs/20'+strmid(date,0,2)+'/'+date+'log'
if file_test(lognm+'.dat') then begin
spawn, 'mv '+lognm+'.dat'+' '+nextname(lognm+'_old', '.dat')
endif
spawn, 'hostname', host
if strmid(host, 13,14, /reverse) eq 'astro.yale.edu' then lognm = '/tous'+lognm
save, log, filename=lognm+'.dat'
print, '--------------------------------------------------------'
print, 'FINISHED UPDATING LOG STRUCTURE IN CHI_MED_BIAS!'
print, '--------------------------------------------------------'
print, 'Log structure save to: ', lognm+'.dat'
print, '--------------------------------------------------------'
endif
end;chi_med_bias.pro