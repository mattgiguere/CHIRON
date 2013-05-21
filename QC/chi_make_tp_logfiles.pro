;+
;
;  NAME: 
;     chi_make_tp_logfiles
;
;  PURPOSE: To copy files from the CTIO format to my format. For 
;	example, take the "insttemp.log.2012_03_15T02_38_24" file, 
;	which has information from 20120302 - 20120315, and make a
;	bunch of daily files, which have names of the format
;	"insttempyymmdd.log". This should work for all 3 CHIRON
;	temperature and pressure logs. 
;   
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      chi_make_tp_logfiles
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
;      chi_make_tp_logfiles
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2012.12.14 06:18:00 PM
;
;-
pro chi_make_tp_logfiles, $
help = help, $
postplot = postplot

!p.color=0
!p.background=255
loadct, 39, /silent
usersymbol, 'circle', /fill, size_of_sym = 0.5

if keyword_set(help) then begin
	print, '*************************************************'
	print, '*************************************************'
	print, '        HELP INFORMATION FOR chi_make_tp_logfiles'
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
end;chi_make_tp_logfiles.pro