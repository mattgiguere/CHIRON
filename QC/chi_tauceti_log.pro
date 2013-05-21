;+
;
;  NAME: 
;     chi_tauceti_log
;
;  PURPOSE: 
;   
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      chi_tauceti_log
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
;      chi_tauceti_log
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2012.03.14 07:31:19 PM
;
;-
pro chi_tauceti_log, $
help = help, $
postplot = postplot, $
log, $
dir = dir

loadct, 39, /silent
usersymbol, 'circle', /fill, size_of_sym = 0.5


date = log[0].date
objname = '10700'
year = '20'+strmid(date,0,2)
ldir = '/home/matt/data/CHIRPS'
arxdir = '/home/matt/data_archive/CHIRPS/logstructs'
mdir = '/starlogs/'
spawn, 'hostname', host
;if strmid(host, 13,14, /reverse) eq 'astro.yale.edu' then ldir = '/tous'+ldir
;first test the ologs date directory, and make it for the new year if need be:
if ~file_test(ldir+'/ologs', /directory) then spawn, 'mkdir '+ldir+'/ologs'
;now test the mdir directory, and make it for the new year if need be:
if ~file_test(ldir+mdir, /directory) then spawn, 'mkdir '+ldir+mdir
lfn = ldir+mdir+'10700log.dat'
newtauceti = where(strt(log.object) eq '10700', newacenct)
if newacenct gt 0 then begin
if file_test(lfn) then begin
restore, lfn

for i=0, newacenct-1 do begin
  already = where(strt(taucetilog.filename) eq strt(log[newtauceti[i]].filename), alreadyct)
  if alreadyct eq 0 then taucetilog = [taucetilog, log[newtauceti[i]]]
endfor
endif else taucetilog = log[newtauceti]

date = log[0].date

acnr = where(strt(taucetilog.object) eq objname and strt(taucetilog.iodcell) eq 'IN' and $
      strt(taucetilog.ccdsum) eq '3 1' and strt(taucetilog.decker) eq 'narrow_slit' and $
      taucetilog.utshutjd lt julday(double(strmid(date, 2, 2)), $
      double(strmid(date, 4, 2))+1, $
      double('20'+strmid(date, 0, 2))), anrct)

acst = where(strt(taucetilog.object) eq objname and strt(taucetilog.iodcell) eq 'IN' and $
      strt(taucetilog.ccdsum) eq '3 1' and strt(taucetilog.decker) eq 'slit' and $
      taucetilog.utshutjd lt julday(double(strmid(date, 2, 2)), $
      double(strmid(date, 4, 2))+1, $
      double('20'+strmid(date, 0, 2))), astct)

acsc = where(strt(taucetilog.object) eq objname and strt(taucetilog.iodcell) eq 'IN' and $
      strt(taucetilog.ccdsum) eq '3 1' and strt(taucetilog.decker) eq 'slicer' and $
      taucetilog.utshutjd lt julday(double(strmid(date, 2, 2)), $
      double(strmid(date, 4, 2))+1, $
      double('20'+strmid(date, 0, 2))), ascct)

if keyword_set(postplot) then begin
   thick, 2
   pdir = dir+'plots/'
   ;first test the tauceti_eff date directory, and make it for the new year if need be:
   taudatedir = pdir+'tauceti_eff/20'+strmid(date,0,2)
   if ~file_test(taudatedir, /directory) then spawn, 'mkdir '+taudatedir
   afn = pdir+'tauceti_eff/20'+strmid(date, 0, 2)+'/'+date+objname+'tpslt'
   if file_test(afn) then spawn, 'mv '+afn+' '+nextnameeps(afn+'_old')
   ps_open, afn, /encaps, /color
endif

if anrct gt 0 then maxnrjd = max(taucetilog[acnr].utshutjd) else maxnrjd = 0
if astct gt 0 then maxstjd = max(taucetilog[acst].utshutjd) else maxstjd = 0
if ascct gt 0 then maxscjd = max(taucetilog[acsc].utshutjd) else maxscjd = 0
if anrct gt 0 then minnrjd = min(taucetilog[acnr].utshutjd) else minnrjd = 1d8
if astct gt 0 then minstjd = min(taucetilog[acst].utshutjd) else minstjd = 1d8
if ascct gt 0 then minscjd = min(taucetilog[acsc].utshutjd) else minscjd = 1d8
gtm = anrct > astct > ascct
maxjd = maxnrjd > maxstjd > maxscjd
minjd = minnrjd < minstjd < minscjd
botjd = floor(minjd)
totpho = [taucetilog[acnr].totpho, taucetilog[acst].totpho, taucetilog[acsc].totpho]
totphops = [taucetilog[acnr].totpho/taucetilog[acnr].exptime, taucetilog[acst].totpho/taucetilog[acst].exptime, taucetilog[acsc].totpho/taucetilog[acsc].exptime]
plot, [minjd, maxjd] - botjd, [0,0], yran=[min(totphops), 1.1* max(totphops)], $
xtitle='JD - '+strt(jul2cal(botjd)), $
ytitle='Total Photoelectrons Per Second', $
title=objname, /xsty, /nodata, /ylog, xran = [minjd-1, maxjd+1] - botjd

if anrct gt 1 then oplot,taucetilog[acnr].utshutjd - botjd, taucetilog[acnr].totpho/taucetilog[acnr].exptime, ps=8
if astct gt 1 then oplot,taucetilog[acst].utshutjd - botjd, taucetilog[acst].totpho/taucetilog[acst].exptime, ps=8, color=110
if ascct gt 1 then oplot,taucetilog[acsc].utshutjd - botjd, taucetilog[acsc].totpho/taucetilog[acsc].exptime, ps=8, color=230
al_legend, ['Narrow', 'Slit', 'Slicer'], textcolor=[0, 110, 230], /right

;OVERPLOTTING THE MONTH:
monarr = ['JAN', 'FEB', 'MAR', 'APR', 'MAY','JUN','JUL','AUG','SEP','OCT','NOV','DEC']
;if long(log[0].date) gt 120403L then stop
caldat, maxjd, maxmon, maxday, maxyear
;number of months to plot
nmons = (maxyear-2012)*12 + (maxmon - 3)
for i=0, nmons do begin
  jd = julday(03+i, 1, 2012, 0,0,0) - botjd
  oplot, [jd,jd], [1d-5,2d * max(totpho)], linestyle=3 
  monarridx2 = (i+2) mod 12
  xyouts, jd, max(totpho), monarr[monarridx2], orient=90
endfor

;END OVERPLOTTING THE MONTH

if keyword_set(postplot) then begin
   ps_close
   spawn, 'convert -density 200 '+afn+'.eps '+afn+'.png'
endif

if keyword_set(postplot) then begin
   thick, 2
   a2fn = pdir+'acen_eff/20'+strmid(date, 0, 2)+'/'+date+objname+'totlt'
   if file_test(a2fn) then spawn, 'mv '+a2fn+' '+nextnameeps(a2fn+'_old')
   ps_open, a2fn, /encaps, /color
endif
plot, [minjd, maxjd] - botjd, [0,0], yran=[min(totpho), 1.1* max(totpho)], $
xtitle='JD - '+strt(jul2cal(botjd)), $
ytitle='Total Photoelectrons', $
title=objname+' on '+date, /xsty, /nodata, xran = [minjd-1, maxjd+1] - botjd

if anrct gt 1 then oplot,taucetilog[acnr].utshutjd - botjd, taucetilog[acnr].totpho, ps=8
if astct gt 1 then oplot, taucetilog[acst].utshutjd - botjd, taucetilog[acst].totpho, ps=8, color=110
if ascct gt 1 then oplot, taucetilog[acsc].utshutjd - botjd, taucetilog[acsc].totpho, ps=8, color=230
al_legend, ['Narrow', 'Slit', 'Slicer'], textcolor=[0, 110, 230], /right

for i=0, nmons do begin
  jd = julday(03+i, 1, 2012, 0,0,0) - botjd
  oplot, [jd,jd], [0,2d * max(totpho)], linestyle=3 
  monarridx2 = (i+2) mod 12
  xyouts, jd, max(totpho), monarr[monarridx2], orient=90
endfor

;END OVERPLOTTING THE MONTH

if keyword_set(postplot) then begin
   ps_close
   spawn, 'convert -density 200 '+a2fn+'.eps '+a2fn+'.png'
endif

save, taucetilog, filename=lfn
save, taucetilog, filename=arxdir+mdir+objname+'/'+'10700log'+date+'.dat'
spawn, 'chmod 777 '+lfn
spawn, 'chmod 777 '+arxdir+mdir+objname+'/'+'10700log'+date+'.dat'
endif;newacencount gt 0 (there were actually observations of tau ceti on this night. 
end;chi_tauceti_log.pro