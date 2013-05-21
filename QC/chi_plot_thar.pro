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
date = date

date = strt(date)

angstrom = '!6!sA!r!u!9 %!6!n'
!p.color=0
!p.background=255
loadct, 39, /silent
usersymbol, 'circle', /fill, size_of_sym = 0.5

restore, '/tous/mir7/logstructs/20'+strmid(date, 0, 2)+'/'+date+'log.dat'
thfile = where(strt(log.object) eq 'ThAr' and strt(log.ccdsum) eq '3 1')

im = readfits(log[thfile[0]].filename)
display, im, /log
stop
if keyword_set(postplot) then begin
   fn = nextnameeps('plot')
   thick, 2
   ps_open, fn, /encaps, /color
endif

if keyword_set(postplot) then begin
   ps_close
endif

stop
end;chi_plot_thar.pro