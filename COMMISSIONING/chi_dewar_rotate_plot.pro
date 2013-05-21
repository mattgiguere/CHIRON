;+
;
;  NAME: 
;     chi_dewar_rotate_plot
;
;  PURPOSE: 
;   
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      chi_dewar_rotate_plot
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
;      chi_dewar_rotate_plot
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2012.04.05 05:39:47 PM
;
;-
pro chi_dewar_rotate_plot, $
help = help, $
postplot = postplot

if keyword_set(help) then begin
	print, '*************************************************'
	print, '*************************************************'
	print, '        HELP INFORMATION FOR chi_dewar_rotate_plot'
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

im1 = chi_rm_bias(filename='/raw/mir7/120217/chi120217.1295.fits')
im2 = chi_rm_bias(filename='/raw/mir7/120223/chi120223.1183.fits')
im3 = rotate(im1, 2)
im4 = im2/4d1
im5 = im4 - im3
display, im5
stop
slcim3 = median(im3[*,1990:2010], dimen=2)
slcim4 = median(im4[*,1990:2010], dimen=2)
ps_open, '~/Desktop/rotate_slice', /encaps, /color
plot, slcim4, /xsty
oplot, slcim3, color=250
ps_close

if keyword_set(postplot) then begin
   fn = nextnameeps('plot')
   thick, 2
   ps_open, fn, /encaps, /color
endif

if keyword_set(postplot) then begin
   ps_close
endif

stop
end;chi_dewar_rotate_plot.pro