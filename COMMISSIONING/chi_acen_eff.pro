;+
;
;  NAME: 
;     chi_acen_eff
;
;  PURPOSE: 
;   
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      chi_acen_eff
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
;      chi_acen_eff
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2012.03.12 02:27:20 PM
;
;-
pro chi_acen_eff, $
help = help, $
postplot = postplot, $
log, $
objname = objname, $
dir = dir

if keyword_set(help) then begin
	print, '*************************************************'
	print, '*************************************************'
	print, '        HELP INFORMATION FOR chi_acen_eff'
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
usersymbol, 'circle', /fill, size_of_sym = 1.5

date = log[0].date

if ~keyword_set(objname) then objname = '128620'
acnr = where(strt(log.object) eq objname and strt(log.iodcell) eq 'IN' and $
      strt(log.ccdsum) eq '3 1' and strt(log.decker) eq 'narrow_slit', anrct)

acst = where(strt(log.object) eq objname and strt(log.iodcell) eq 'IN' and $
      strt(log.ccdsum) eq '3 1' and strt(log.decker) eq 'slit', astct)

acsc = where(strt(log.object) eq objname and strt(log.iodcell) eq 'IN' and $
      strt(log.ccdsum) eq '3 1' and strt(log.decker) eq 'slicer', ascct)

if keyword_set(postplot) then begin
   thick, 2
   pdir = dir+'plots/'
   ;first test the acen_eff date directory, and make it for the new year if need be:
   acdatedir = pdir+'acen_eff/20'+strmid(date,0,2)
   if ~file_test(acdatedir, /directory) then spawn, 'mkdir '+acdatedir
   afn = pdir+'acen_eff/20'+strmid(date, 0, 2)+'/'+date+objname+'tps'
   if file_test(afn) then spawn, 'mv '+afn+' '+nextnameeps(afn+'_old')
   ps_open, afn, /encaps, /color
endif
gtm = anrct > astct > ascct
totpho = [log[acnr].totpho, log[acst].totpho, log[acsc].totpho]
totphops = [log[acnr].totpho/log[acnr].exptime, log[acst].totpho/log[acst].exptime, log[acsc].totpho/log[acsc].exptime]
if gtm gt 1 then begin
  plot, findgen(gtm), yran=[1d2, 1.2* max(totphops)], $
  xtitle='Observation #', $
  ytitle='Total Photoelectrons Per Second', $
  title=objname+' on '+date, /xsty, /nodata
  al_legend, ['Narrow', 'Slit', 'Slicer'], textcolor=[0, 110, 230], /right
endif;gtm>1

if anrct gt 1 then oplot,log[acnr].totpho/log[acnr].exptime, ps=8
if astct gt 1 then oplot,log[acst].totpho/log[acst].exptime, ps=8, color=110
if ascct gt 1 then oplot,log[acsc].totpho/log[acsc].exptime, ps=8, color=230

if keyword_set(postplot) then begin
   ps_close
   spawn, 'convert -density 200 '+afn+'.eps '+afn+'.png'
endif

if keyword_set(postplot) then begin
   thick, 2
   a2fn = pdir+'acen_eff/20'+strmid(date, 0, 2)+'/'+date+objname+'tot'
   if file_test(a2fn) then spawn, 'mv '+a2fn+' '+nextnameeps(a2fn+'_old')
   ps_open, a2fn, /encaps, /color
endif
if gtm gt 1 then begin
  plot, findgen(gtm), yran=[1d2, 1.2* max(totpho)], $
  xtitle='Observation #', $
  ytitle='Total Photoelectrons', $
  title=objname+' on '+date, /xsty, /nodata
  al_legend, ['Narrow', 'Slit', 'Slicer'], textcolor=[0, 110, 230], /right
endif;gtm>1

if anrct gt 1 then oplot, log[acnr].totpho, ps=8
if astct gt 1 then oplot, log[acst].totpho, ps=8, color=110
if ascct gt 1 then oplot, log[acsc].totpho, ps=8, color=230

if keyword_set(postplot) then begin
   ps_close
   spawn, 'convert -density 200 '+a2fn+'.eps '+a2fn+'.png'
endif
end;chi_acen_eff.pro