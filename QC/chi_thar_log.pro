;+
;
;  NAME: 
;     chi_thar_log
;
;  PURPOSE: 
;   
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      chi_thar_log
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
;      chi_thar_log
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2012.03.14 07:31:19 PM
;
;-
pro chi_thar_log, $
postplot = postplot, $
log, $
dir = dir

loadct, 39, /silent
usersymbol, 'circle', /fill, size_of_sym = 0.5


date = log[0].date
objname = 'ThAr'
year = '20'+strmid(date,0,2)
ldir = '/home/matt/data/CHIRPS'
arxdir = '/home/matt/data_archive/CHIRPS/logstructs'
mdir = '/tharlogs/'
spawn, 'hostname', host

;if strmid(host, 13,14, /reverse) eq 'astro.yale.edu' then ldir = '/tous'+ldir
lfn = ldir+'/tharlog.dat'
;test the mdir directory, and make it for the new year if need be:
;if ~file_test(ldir+mdir, /directory) then spawn, 'mkdir '+ldir+mdir

newthar = where(strt(log.object) eq objname, newtharct)
if file_test(lfn) then begin
restore, lfn
for i=0, newtharct-1 do begin
  already = where(strt(tharlog.filename) eq strt(log[newthar[i]].filename), alreadyct)
  if alreadyct eq 0 then tharlog = [tharlog, log[newthar[i]]]
endfor
endif else tharlog = log[newthar]


date = log[0].date

acnr = where(strt(tharlog.object) eq objname and $
      strt(tharlog.ccdsum) eq '3 1' and strt(tharlog.decker) eq 'narrow_slit' and $
      tharlog.utshutjd lt julday(double(strmid(date, 2, 2)), $
      double(strmid(date, 4, 2))+1, $
      double('20'+strmid(date, 0, 2))), anrct)

acst = where(strt(tharlog.object) eq objname and $
      strt(tharlog.ccdsum) eq '3 1' and strt(tharlog.decker) eq 'slit' and $
      tharlog.utshutjd lt julday(double(strmid(date, 2, 2)), $
      double(strmid(date, 4, 2))+1, $
      double('20'+strmid(date, 0, 2))), astct)

acsc = where(strt(tharlog.object) eq objname and $
      strt(tharlog.ccdsum) eq '3 1' and strt(tharlog.decker) eq 'slicer' and $
      tharlog.utshutjd lt julday(double(strmid(date, 2, 2)), $
      double(strmid(date, 4, 2))+1, $
      double('20'+strmid(date, 0, 2))), ascct)

acfb = where(strt(tharlog.object) eq objname and $
      strt(tharlog.ccdsum) eq '4 4' and strt(tharlog.decker) eq 'fiber' and $
      tharlog.utshutjd lt julday(double(strmid(date, 2, 2)), $
      double(strmid(date, 4, 2))+1, $
      double('20'+strmid(date, 0, 2))), afbct)
;print, 'afbct is: ', afbct
if keyword_set(postplot) then begin
   thick, 2
   pdir = dir+'plots/'
   spawn, 'hostname', host
   ;first test the thar date directory, and make it for the new year if need be:
   tdatedir = pdir+'thar/20'+strmid(date,0,2)
   if ~file_test(tdatedir, /directory) then spawn, 'mkdir '+tdatedir
   afn = pdir+'thar/20'+strmid(date, 0, 2)+'/'+date+objname+'tpslt'
   if file_test(afn) then spawn, 'mv '+afn+' '+nextnameeps(afn+'_old')
   ps_open, afn, /encaps, /color
endif

if anrct gt 0 then maxnrjd = max(tharlog[acnr].utshutjd) else maxnrjd = 0
if anrct gt 0 then minnrjd = min(tharlog[acnr].utshutjd) else minnrjd = 1d8

if astct gt 0 then maxstjd = max(tharlog[acst].utshutjd) else maxstjd = 0
if astct gt 0 then minstjd = min(tharlog[acst].utshutjd) else minstjd = 1d8

if ascct gt 0 then maxscjd = max(tharlog[acsc].utshutjd) else maxscjd = 0
if ascct gt 0 then minscjd = min(tharlog[acsc].utshutjd) else minscjd = 1d8

if afbct gt 0 then maxfbjd = max(tharlog[acfb].utshutjd) else maxfbjd = 0
if afbct gt 0 then minfbjd = min(tharlog[acfb].utshutjd) else minfbjd = 1d8
gtm = anrct > astct > ascct > afbct
maxjd = maxnrjd > maxstjd > maxscjd > maxfbjd
minjd = minnrjd < minstjd < minscjd < minfbjd
botjd = floor(minjd)
totpho = [tharlog[acnr].totpho, tharlog[acst].totpho, tharlog[acsc].totpho]
totphops = [tharlog[acnr].totpho/tharlog[acnr].exptime, tharlog[acst].totpho/tharlog[acst].exptime, tharlog[acsc].totpho/tharlog[acsc].exptime]
plot, [minjd, maxjd] - botjd, [0,0], yran=[min(totphops), 1.1* max(totphops)], $
xtitle='JD - '+strt(jul2cal(botjd)), $
ytitle='Total Photoelectrons Per Second', $
title=objname, /xsty, /nodata, xran = [minjd-1, maxjd+1] - botjd, /ylog

oplot,tharlog[acnr].utshutjd - botjd, tharlog[acnr].totpho/tharlog[acnr].exptime, ps=8
if astct gt 1 then oplot,tharlog[acst].utshutjd - botjd, tharlog[acst].totpho/tharlog[acst].exptime, ps=8, color=110
if ascct gt 1 then oplot,tharlog[acsc].utshutjd - botjd, tharlog[acsc].totpho/tharlog[acsc].exptime, ps=8, color=230
if afbct gt 1 then oplot,tharlog[acfb].utshutjd - botjd, tharlog[acfb].totpho/tharlog[acfb].exptime, ps=8, color=40
al_legend, ['Narrow', 'Slit', 'Slicer', 'Fiber'], textcolor=[0, 110, 230, 40], /right

if keyword_set(postplot) then begin
   ps_close
   spawn, 'convert -density 200 '+afn+'.eps '+afn+'.png'
endif

if keyword_set(postplot) then begin
   thick, 2
   a2fn = pdir+'thar/20'+strmid(date, 0, 2)+'/'+date+objname+'totlt'
   if file_test(a2fn) then spawn, 'mv '+a2fn+' '+nextnameeps(a2fn+'_old')
   ps_open, a2fn, /encaps, /color
endif
plot, [minjd, maxjd] - botjd, [0,0], yran=[min(totpho), 1.1* max(totpho)], $
xtitle='JD - '+strt(jul2cal(botjd)), $
ytitle='Total Photoelectrons', $
title=objname+' on '+date, /xsty, /nodata, xran = [minjd-1, maxjd+1] - botjd, /ylog

oplot,tharlog[acnr].utshutjd - botjd, tharlog[acnr].totpho, ps=8
if astct gt 1 then oplot, tharlog[acst].utshutjd - botjd, tharlog[acst].totpho, ps=8, color=110
if ascct gt 1 then oplot, tharlog[acsc].utshutjd - botjd, tharlog[acsc].totpho, ps=8, color=230
if afbct gt 1 then oplot, tharlog[acfb].utshutjd - botjd, tharlog[acfb].totpho, ps=8, color=40
al_legend, ['Narrow', 'Slit', 'Slicer', 'Fiber'], textcolor=[0, 110, 230, 40], /right

if keyword_set(postplot) then begin
   ps_close
   spawn, 'convert -density 200 '+a2fn+'.eps '+a2fn+'.png'
endif

;lfn = ldir+'/tharlog.dat'
save, tharlog, filename=lfn
;save, tharlog, filename=arxdir+mdir+'tharlog'+date+'.dat'
spawn, 'chmod 777 '+lfn
;spawn, 'chmod 777 '+arxdir+mdir+'tharlog'+date+'.dat'
;stop
end;chi_thar_log.pro