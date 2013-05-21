;+
;
;  NAME: 
;     chi_make_acenalog
;
;  PURPOSE: 
;   
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      chi_make_acenalog
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
;      chi_make_acenalog
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2012.03.15 12:18:37 PM
;
;-
pro chi_make_acenalog, $
help = help, $
postplot = postplot

if keyword_set(help) then begin
	print, '*************************************************'
	print, '*************************************************'
	print, '        HELP INFORMATION FOR chi_make_acenalog'
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

restore, '/tous/mir7/logstructs/2012/120302log.dat'
date = log[0].date

year = '20'+strmid(date,0,2)
ldir = '/mir7/logstructs/'+year
spawn, 'hostname', host
if strmid(host, 13,14, /reverse) eq 'astro.yale.edu' then ldir = '/tous'+ldir
lfn = ldir+'/acenalog.dat'

newacena = where(strt(log.object) eq '128620', newacenct)

acenalog = log[newacena]

save, acenalog, filename=lfn

end;chi_make_acenalog.pro