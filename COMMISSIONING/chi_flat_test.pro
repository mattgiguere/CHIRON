;+
;
;  NAME: 
;     chi_flat_test_unfoc
;
;  PURPOSE: 
;   
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      chi_flat_test_unfoc
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
;      chi_flat_test_unfoc
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2012.09.12 06:40:29 PM
;
;-
pro chi_flat_test_unfoc, $
help = help, $
postplot = postplot

!p.color=0
!p.background=255
loadct, 39, /silent
usersymbol, 'circle', /fill, size_of_sym = 0.5

if keyword_set(help) then begin
	print, '*************************************************'
	print, '*************************************************'
	print, '        HELP INFORMATION FOR chi_flat_test'
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

fname10 = '/raw/mir7/120909/chi120909.1270.fits'
im10 = chi_rm_bias(filename=fname10, hd=hd10)

fname7 = '/raw/mir7/120909/chi120909.1264.fits'
im7 = chi_rm_bias(filename=fname7, hd=hd7)

fname4 = '/raw/mir7/120909/chi120909.1258.fits'
im4 = chi_rm_bias(filename=fname4, hd=hd4)

fname1 = '/raw/mir7/120909/chi120909.1253.fits'
im1 = chi_rm_bias(filename=fname1, hd=hd1)


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
end;chi_flat_test_unfoc.pro