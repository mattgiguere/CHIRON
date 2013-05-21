;+
;
;  NAME: 
;     chi_quality_red
;
;  PURPOSE: 
;   
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      chi_quality_red
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
;      chi_quality_red
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2012.04.17 06:46:13 PM
;
;-
pro chi_quality_red, $
help = help, $
postplot = postplot

if keyword_set(help) then begin
	print, '*************************************************'
	print, '*************************************************'
	print, '        HELP INFORMATION FOR chi_quality_red'
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

if keyword_set(postplot) then begin
   fn = nextnameeps('plot')
   thick, 2
   ps_open, fn, /encaps, /color
endif

if keyword_set(postplot) then begin
   ps_close
endif




;************************************************************************
PRINT, '*****************************************************************'
PRINT, 'NOW PRINTING TO HTML'
PRINT, '*****************************************************************'
;************************************************************************
qfile = qdir+date+'quality.html'
spawn, 'hostname', host
;if strmid(host, 13,14, /reverse) eq 'astro.yale.edu' then qfile = '/tous'+qfile
openw, 2, qfile
printf, 2, '<html>'
printf, 2, '<head>'
printf, 2, '<title>Logsheet for '+date+'</title>'
printf, 2, '</head>'
printf, 2, '<body>'
printf, 2, '<center>'

printf, 2, '<h3>Logsheet for '+date+' </h3>'
printf, 2, '<br>'
;************************************************************************
;PRELIMINARY INFO
;************************************************************************
printf, 2, 'APO Position (mm): ', log[0].focus
printf, 2, '<br>'

stop
end;chi_quality_red.pro