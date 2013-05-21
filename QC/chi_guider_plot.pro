;+
;
;  NAME: 
;     chi_guider_plot
;
;  PURPOSE: 
;    To plot the guider status
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      chi_guider_plot
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
;      chi_guider_plot
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2012.03.13 10:07:46 AM
;		adapted from quick routine from Tokovinin
;
;-
function chi_guider_plot, $
help = help, $
postplot = postplot, $
log, $
dir = dir

if keyword_set(help) then begin
	print, '*************************************************'
	print, '*************************************************'
	print, '        HELP INFORMATION FOR chi_guider_plot'
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

; Read log-files of PCguider
; located in pcguider in home/logs
; set start=[2012, 2, 24, 4, 33] to start at 4:33UT on feb 24, 2012
;pro getguider, JD, x, y, start=start
date = log[0].date
start = ['20'+strmid(date, 0, 2), $
strmid(date, 2, 2), $
long(strmid(date, 4, 2)), 12, 0]


close, /all
;openr, 11, 'guider.currentLog'
;openr, 11, 'guider.Wed_Jul_20'
gfn = '/mir7/logs/guider/guider'+date+'.log'
spawn, 'hostname', host
if strmid(host, 13,14, /reverse) eq 'astro.yale.edu' then gfn = '/tous'+gfn
openr, 11, gfn

;nmax = 500000L
;nmax = 6000L
nmax = 20864L
;nskip = 5000L

if keyword_set(start) then $
 jdcnv, start[0], start[1], start[2], start[3]+start[4]/60., jdstart $
else jdstart = 0D


JD = dblarr(nmax)
x = fltarr(nmax) ; x-correction
y = fltarr(nmax) ; y-correction

lc = 0L ; line counter
k = 0L  ; data counter

months=['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec']

line=''
buf=''

print, 'reading the file...'
while (not eof(11)) and (k lt nmax) do begin
  readf, 11, line
  buf = strsplit(line, /extract)
  if buf[6] ne '1' then continue ; skip
  lc++
  ; if lc lt nskip then continue ; skip first portion of file

  month = where(buf[1] eq months) + 1
  day = long(buf[2])
  hms = long(strsplit(buf[3],':', /extract))
  ut = hms[0] + hms[1]/60. + hms[2]/3600.
  yr = long(buf[4])

  jdcnv, yr, month, day, ut, julday

  if julday lt jdstart then continue
  if k eq 0L then print, buf[0:4] ; mark beginning

  jd[k] = julday 
  x[k] = float(buf[7])
  y[k] = float(buf[8])
  k++
endwhile

gojd = where(jd gt 0)
jd = jd[gojd]
x = x[gojd]
y = y[gojd]

if buf[0] ne '' then print, buf[0:4] ; mark end

print, 'Done, k=',k
close, 11
!p.charsize = 0.5
time = (jd -jd[0])*24.
if n_elements(time) gt 1 then begin
if keyword_set(postplot) then begin
   thick, 2
   pdir = dir+'plots/'
   ;first test the guider date directory, and make it for the new year if need be:
   gdatedir = pdir+'guider/20'+strmid(date,0,2)
   if ~file_test(gdatedir, /directory) then spawn, 'mkdir '+gdatedir
   grfn = pdir+'guider/20'+strmid(date, 0, 2)+'/'+date+'guiderRA'
   if file_test(grfn) then spawn, 'mv '+grfn+' '+nextnameeps(grfn+'_old')
   ps_open, grfn, /encaps, /color
endif
plot, time, x, xtitle='Hours', ytitle='Correction', xs=1, $
yran = [-10,10], ps=8, $
title='Guider RA Corrections from '+jul2cal(jd[0])+' - '+jul2cal(jd[-1])
oplot, [time[0], time[-1]], [0,0], color=250
rmsx = sqrt(total(x^2)/n_elements(x))
xyouts, 0.2, 0.1, 'RMS in X: '+strt(rmsx, f='(F4.2)'), /normal
if keyword_set(postplot) then begin
   ps_close
   spawn, 'convert -density 200 '+grfn+'.eps '+grfn+'.png'
endif
if keyword_set(postplot) then begin
   thick, 2
   gdfn = pdir+'guider/20'+strmid(date, 0, 2)+'/'+date+'guiderdec'
   if file_test(gdfn) then spawn, 'mv '+gdfn+' '+nextnameeps(gdfn+'_old')
   ps_open, gdfn, /encaps, /color
endif
plot, time, y, xtitle='Hours', ytitle='Correction', xs=1, $
yran = [-10,10], ps=8, $
title='Guider dec Corrections from '+jul2cal(jd[0])+' - '+jul2cal(jd[-1])
oplot, [time[0], time[-1]], [0,0], color=250
rmsy = sqrt(total(y^2)/n_elements(y))
xyouts, 0.2, 0.1, 'RMS in Y: '+strt(rmsy, f='(F4.2)'), /normal
if keyword_set(postplot) then begin
   ps_close
   spawn, 'convert -density 200 '+gdfn+'.eps '+gdfn+'.png'
endif

nc = 5 ; covariance plot
cov = dblarr(nc)
for j=0,nc-1 do cov[j] = total(x*shift(x,j))
cov = cov/cov[0]
covx = cov
if keyword_set(postplot) then begin
   thick, 2
   lrfn = pdir+'guider/20'+strmid(date, 0, 2)+'/'+date+'lagRA'
   if file_test(lrfn) then spawn, 'mv '+lrfn+' '+nextnameeps(lrfn+'_old')
   ps_open, lrfn, /encaps, /color
endif
plot, covx, xtitle='RA Lag (in seconds)', ytitle='Correlation', $
title='X Lag '+jul2cal(jd[0])+' - '+jul2cal(jd[-1])
oplot, covx, psym=6
if keyword_set(postplot) then begin
   ps_close
   spawn, 'convert -density 200 '+lrfn+'.eps '+lrfn+'.png'
endif

cov = dblarr(nc)
for j=0,nc-1 do cov[j] = total(y*shift(y,j))
cov = cov/cov[0]
covy = cov
if keyword_set(postplot) then begin
   thick, 2
   ldfn = pdir+'guider/20'+strmid(date, 0, 2)+'/'+date+'lagdec'
   if file_test(ldfn) then spawn, 'mv '+ldfn+' '+nextnameeps(ldfn+'_old')
   ps_open, ldfn, /encaps, /color
endif
plot, covy, xtitle='Dec Lag (in seconds)', ytitle='Correlation', $
title='Y Lag '+jul2cal(jd[0])+' - '+jul2cal(jd[-1])
oplot, covy, psym=6
if keyword_set(postplot) then begin
   ps_close
   spawn, 'convert -density 200 '+ldfn+'.eps '+ldfn+'.png'
endif

return, [rmsx, rmsy, mean(covx), mean(covy)]
endif;time > 1
end;chi_guider_plot.pro