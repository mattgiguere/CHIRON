;+
;
;  NAME: 
;     chi_plot_thar
;
;  PURPOSE: 
;   
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      chi_plot_thar
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
;      chi_plot_thar
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2013.05.13 23:07:45
;
;-
pro chi_plot_thar, $
postplot = postplot, $
date = date, $
dir = dir

date = strt(date)
objname = 'ThAr'

angstrom = '!6!sA!r!u!9 %!6!n'
!p.color=0
!p.background=255
loadct, 39, /silent
usersymbol, 'circle', /fill, size_of_sym = 0.5

restore, '/tous/mir7/logstructs/20'+strmid(date, 0, 2)+'/'+date+'log.dat'
thfile = where(strt(log.object) eq 'ThAr' and strt(log.ccdsum) eq '3 1')

if keyword_set(postplot) then begin
   thick, 2
   pdir = dir+'plots/'
   spawn, 'hostname', host
   ;first test the thar date directory, and make it for the new year if need be:
   tdatedir = pdir+'thar/20'+strmid(date,0,2)
   if ~file_test(tdatedir, /directory) then spawn, 'mkdir '+tdatedir
   afn = pdir+'thar/20'+strmid(date, 0, 2)+'/'+date+objname+'Disp'
   if file_test(afn) then spawn, 'mv '+afn+' '+nextnameeps(afn+'_old')
   ps_open, afn, /encaps, /color
endif
im = readfits(log[thfile[0]].filename)
display, im, /log, title='ThAr '+strt(log[thfile[0]].seqnum)
if keyword_set(postplot) then begin
   ps_close
   spawn, 'convert -density 200 '+afn+'.eps '+afn+'.png'
endif

end;chi_plot_thar.pro