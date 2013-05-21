;+
;
;  NAME: 
;     chi_check_reduction
;
;  PURPOSE: 
;   
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      chi_check_reduction
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
;      chi_check_reduction
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2012.05.01 02:18:16 PM
;
;-
pro chi_check_reduction, $
log=log, $
iodspec=iodspec, iodres = iodres, $
fitspec=fitspec, fitsres=fitsres, $
getthid=getthid, thidres=thidres, $
wavcheck=wavcheck, wavres=wavres, $
help = help, $
postplot = postplot

if keyword_set(help) then begin
	print, '*************************************************'
	print, '*************************************************'
	print, '        HELP INFORMATION FOR chi_check_reduction'
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

;stop
end;chi_check_reduction.pro