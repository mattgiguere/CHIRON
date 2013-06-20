;+
;
;  NAME: 
;     chi_acenb_log
;
;  PURPOSE: 
;   
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      chi_acenb_log
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
;      chi_acenb_log
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2012.03.14 07:31:19 PM
;
;-
pro chi_acenb_log, $
help = help, $
postplot = postplot, $
log, $
dir = dir

loadct, 39, /silent
usersymbol, 'circle', /fill, size_of_sym = 0.5
;this structure has the linedepth ratio information:
restore, '/home/matt/data/linedepths.dat'

;now to restore the velocities:
restore, '/home/matt/data/CHIRPS/RVs/vst128621.dat'

date = log[0].date
objname = '128621'
year = '20'+strmid(date,0,2)
ldir = '/home/matt/data/CHIRPS'
arxdir = '/home/matt/Data_archive/CHIRPS/logstructs'
mdir = '/starlogs/'
spawn, 'hostname', host
;if strmid(host, 13,14, /reverse) eq 'astro.yale.edu' then ldir = '/tous'+ldir
;test the mdir directory, and make it for the new year if need be:
if ~file_test(ldir+mdir, /directory) then spawn, 'mkdir '+ldir+mdir
lfn = ldir+mdir+'128621log.dat'
newacenb = where(strt(log.object) eq '128621', newacenct)
if file_test(lfn) then begin
  restore, lfn
  for i=0, newacenct-1 do begin
	already = where(strt(acenblog.filename) eq strt(log[newacenb[i]].filename), alreadyct)
	if alreadyct eq 0 then begin
	  acenblog = [acenblog, log[newacenb[i]]]
	  ;INSERT THE VELOCITIES:
	  rvidx = where(cf3.obnm eq 'chi'+strt(log[newacenb[i]].date)+'.'+strt(log[newacenb[i]].seqnum), rvct)
	  if rvct eq 1 then begin
		acenblog[-1].jmnvel = cf3[rvidx].mnvel
		acenblog[-1].jerrvel = cf3[rvidx].errvel
		acenblog[-1].jmdvel = cf3[rvidx].mdvel
		acenblog[-1].barycor = cf3[rvidx].bc
	  endif
	endif
  endfor
endif else acenblog = log[newacenb]

date = log[0].date


acnr = where(strt(acenblog.object) eq objname and strt(acenblog.iodcell) eq 'IN' and $
      strt(acenblog.ccdsum) eq '3 1' and strt(acenblog.decker) eq 'narrow_slit' and $
      acenblog.utshutjd lt julday(double(strmid(date, 2, 2)), $
      double(strmid(date, 4, 2))+1, $
      double('20'+strmid(date, 0, 2))), anrct)

acst = where(strt(acenblog.object) eq objname and strt(acenblog.iodcell) eq 'IN' and $
      strt(acenblog.ccdsum) eq '3 1' and strt(acenblog.decker) eq 'slit' and $
      acenblog.utshutjd lt julday(double(strmid(date, 2, 2)), $
      double(strmid(date, 4, 2))+1, $
      double('20'+strmid(date, 0, 2))), astct)

acsc = where(strt(acenblog.object) eq objname and strt(acenblog.iodcell) eq 'IN' and $
      strt(acenblog.ccdsum) eq '3 1' and strt(acenblog.decker) eq 'slicer' and $
      acenblog.utshutjd lt julday(double(strmid(date, 2, 2)), $
      double(strmid(date, 4, 2))+1, $
      double('20'+strmid(date, 0, 2))), ascct)

if keyword_set(postplot) then begin
   thick, 2
;   pdir = '/mir7/quality/plots/'
   pdir = dir+'plots/'
   spawn, 'hostname', host
;   if strmid(host, 13,14, /reverse) eq 'astro.yale.edu' then pdir = '/tous'+pdir
   afn = pdir+'acen_eff/20'+strmid(date, 0, 2)+'/'+date+objname+'tpslt'
   if file_test(afn) then spawn, 'mv '+afn+' '+nextnameeps(afn+'_old')
   ps_open, afn, /encaps, /color
endif

if anrct gt 0 then maxnrjd = max(acenblog[acnr].utshutjd) else maxnrjd = 0
if astct gt 0 then maxstjd = max(acenblog[acst].utshutjd) else maxstjd = 0
if ascct gt 0 then maxscjd = max(acenblog[acsc].utshutjd) else maxscjd = 0
if anrct gt 0 then minnrjd = min(acenblog[acnr].utshutjd) else minnrjd = 1d8
if astct gt 0 then minstjd = min(acenblog[acst].utshutjd) else minstjd = 1d8
if ascct gt 0 then minscjd = min(acenblog[acsc].utshutjd) else minscjd = 1d8
gtm = anrct > astct > ascct
maxjd = maxnrjd > maxstjd > maxscjd
minjd = minnrjd < minstjd < minscjd
botjd = floor(minjd)
totpho = [acenblog[acnr].totpho, acenblog[acst].totpho, acenblog[acsc].totpho]
totphops = [acenblog[acnr].totpho/acenblog[acnr].exptime, acenblog[acst].totpho/acenblog[acst].exptime, acenblog[acsc].totpho/acenblog[acsc].exptime]
plot, [minjd, maxjd] - botjd, [0,0], yran=[min(totphops), 1.1* max(totphops)], $
xtitle='JD - '+strt(jul2cal(botjd)), $
ytitle='Total Photoelectrons Per Second', $
title=objname, /xsty, /nodata, /ylog, xran = [minjd-1, maxjd+1] - botjd

if anrct gt 1 then oplot,acenblog[acnr].utshutjd - botjd, acenblog[acnr].totpho/acenblog[acnr].exptime, ps=8
if astct gt 1 then oplot,acenblog[acst].utshutjd - botjd, acenblog[acst].totpho/acenblog[acst].exptime, ps=8, color=110
if ascct gt 1 then oplot,acenblog[acsc].utshutjd - botjd, acenblog[acsc].totpho/acenblog[acsc].exptime, ps=8, color=230
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

if anrct gt 1 then oplot,acenblog[acnr].utshutjd - botjd, acenblog[acnr].totpho, ps=8
if astct gt 1 then oplot, acenblog[acst].utshutjd - botjd, acenblog[acst].totpho, ps=8, color=110
if ascct gt 1 then oplot, acenblog[acsc].utshutjd - botjd, acenblog[acsc].totpho, ps=8, color=230
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

lfn = ldir+mdir+'128621log.dat'
save, acenblog, filename=lfn
save, acenblog, filename=arxdir+mdir+objname+'/'+'128621log'+date+'.dat'
spawn, 'chmod 777 '+lfn
spawn, 'chmod 777 '+arxdir+mdir+objname+'/'+'128621log'+date+'.dat'

end;chi_acenb_log.pro