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
;        c. Matt Giguere 2012.03.19 04:47:22 PM
;
;-
pro chi_plot_thar, $
help = help, $
postplot = postplot, $
log, $
dir = dir

if keyword_set(help) then begin
	print, '*************************************************'
	print, '*************************************************'
	print, '        HELP INFORMATION FOR chi_plot_thar'
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
newthars = where(strt(log.object) eq 'ThAr', newtharct)

if keyword_set(postplot) then begin
   thick, 2
;   pdir = '/mir7/quality/plots/'
   pdir = dir+'plots/'
   spawn, 'hostname', host
;   if strmid(host, 13,14, /reverse) eq 'astro.yale.edu' then pdir = '/tous'+pdir
   tfn = pdir+'thar/20'+strmid(date, 0, 2)+'/'+date+'tharlt'
   if file_test(tfn) then spawn, 'mv '+tfn+' '+nextnameeps(tfn+'_old')
   ps_open, mfn, /encaps, /color
endif

;NOW PLOTTING THE THAR EXPOSURES:
tharnar = where(strt(log.object) eq 'ThAr' and strt(log.decker) eq 'narrow_slit')
tharslt = where(strt(log.object) eq 'ThAr' and strt(log.decker) eq 'slit')
tharscr = where(strt(log.object) eq 'ThAr' and strt(log.decker) eq 'slicer')
tharfib = where(strt(log.object) eq 'ThAr' and strt(log.decker) eq 'fiber')


if keyword_set(postplot) then begin
   ps_close
   spawn, 'convert -density 200 '+tfn+'.eps '+tfn+'.png'
endif
stop
end;chi_plot_thar.pro