;+
;
;  NAME: 
;     chi_plot_flats
;
;  PURPOSE: 
;   To plot the maximum counts for the flat field exposures
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      chi_plot_flats
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
;      chi_plot_flats
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2012.02.01 05:58:16 PM
;
;-
pro chi_plot_flats, $
help = help

if keyword_set(help) then begin
	print, '*************************************************'
	print, '*************************************************'
	print, '        HELP INFORMATION FOR chi_plot_flats'
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
date = '111128'
dir = '/raw/mir7/'+date+'/'
prefix = 'chi'+date+'.'

flatnums = lindgen(60)+1007L
str = create_struct('exptime', 0d, $
'emavgsq', 0d, $
'decker', '', $
'snr', 0d, $




end;chi_plot_flats.pro