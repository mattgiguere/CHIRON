;+
;
;  NAME: 
;     chi_chip_regions
;
;  PURPOSE: 
;   To display the good regions as defined in the FITS header
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      chi_chip_regions
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
;      chi_chip_regions
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2012.02.07 03:36:15 PM
;
;-
pro chi_chip_regions, $
help = help, $
postplot = postplot

if keyword_set(help) then begin
	print, '*************************************************'
	print, '*************************************************'
	print, '        HELP INFORMATION FOR chi_chip_regions'
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

im1 = readfits('/raw/mir7/111014/chi111014.1067.fits', hd1)
im2 = readfits('/raw/mir7/111102/chi111102.1067.fits', hd2)
im3 = readfits('/raw/mir7/111130/chi111130.1067.fits', hd3)
chipst1 = chip_geometry(hdr=hd1)
chipst2 = chip_geometry(hdr=hd2)
chipst3 = chip_geometry(hdr=hd3)

if keyword_set(postplot) then begin
   fn = nextnameeps('chi111014.1067.trimmed')
   thick, 2
   ps_open, fn, /encaps, /color
endif

display, im1, min=2100, max=2500, /hist, $
ytitle='Dispersion Direction (px)', $
xtitle='Cross Dispersion Direction (px)'

oplot_square, chipst1.image_trim.upleft, linestyle = 0, thick=5, color=210
oplot_square, chipst1.image_trim.upright, linestyle = 0, thick=5, color=110
if keyword_set(postplot) then begin
   ps_close
endif

;stop

if keyword_set(postplot) then begin
   fn = nextnameeps('chi111102.1067.trimmed')
   thick, 2
   ps_open, fn, /encaps, /color
endif

display, im2, min=2100, max=2500, /hist, $
ytitle='Dispersion Direction (px)', $
xtitle='Cross Dispersion Direction (px)'

oplot_square, chipst2.image_trim.upleft, linestyle = 0, thick=5, color=210
oplot_square, chipst2.image_trim.upright, linestyle = 0, thick=5, color=110
if keyword_set(postplot) then begin
   ps_close
endif

;stop

if keyword_set(postplot) then begin
   fn = nextnameeps('chi111130.1067.trimmed')
   thick, 2
   ps_open, fn, /encaps, /color
endif

display, im3, min=2100, max=2500, /hist, $
ytitle='Dispersion Direction (px)', $
xtitle='Cross Dispersion Direction (px)'

oplot_square, chipst3.image_trim.upleft, linestyle = 0, thick=5, color=210
oplot_square, chipst3.image_trim.upright, linestyle = 0, thick=5, color=90
if keyword_set(postplot) then begin
   ps_close
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
end;chi_chip_regions.pro