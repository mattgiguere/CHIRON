;+
;
;  NAME: 
;     chi_trim
;
;  PURPOSE: To trim a CHIRON bias removed image to only show the "good regions". 
;   
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      chi_trim
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
;      chi_trim
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2012.09.14 09:23:06 AM
;
;-
pro chi_trim, $
help = help, $
postplot = postplot, $
im, hd=hd

!p.color=0
!p.background=255
loadct, 39, /silent
usersymbol, 'circle', /fill, size_of_sym = 0.5

if keyword_set(help) then begin
	print, '*************************************************'
	print, '*************************************************'
	print, '        HELP INFORMATION FOR chi_trim'
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

geom = chip_geometry(name, hdr=hd)

imupleft = im[geom.image_trim.upleft[0]:geom.image_trim.upleft[1],geom.image_trim.upleft[2]:geom.image_trim.upleft[3]]
biasupleft = im[geom.bias_trim.upleft[0]:geom.bias_trim.upleft[1],geom.bias_trim.upleft[2]:geom.bias_trim.upleft[3]]
gainupleft = geom.gain.upleft

imupright = im[geom.image_trim.upright[0]:geom.image_trim.upright[1],geom.image_trim.upright[2]:geom.image_trim.upright[3]]
biasupright = im[geom.bias_trim.upright[0]:geom.bias_trim.upright[1],geom.bias_trim.upright[2]:geom.bias_trim.upright[3]]
gainupright = geom.gain.upright

imbotleft = im[geom.image_trim.botleft[0]:geom.image_trim.botleft[1],geom.image_trim.botleft[2]:geom.image_trim.botleft[3]]
biasbotleft = im[geom.bias_trim.botleft[0]:geom.bias_trim.botleft[1],geom.bias_trim.botleft[2]:geom.bias_trim.botleft[3]]
gainbotleft = geom.gain.botleft

imbotright = im[geom.image_trim.botright[0]:geom.image_trim.botright[1],geom.image_trim.botright[2]:geom.image_trim.botright[3]]
biasbotright = im[geom.bias_trim.botright[0]:geom.bias_trim.botright[1],geom.bias_trim.botright[2]:geom.bias_trim.botright[3]]
gainbotright = geom.gain.botright

im=[[imbotleft, imbotright],[imupleft, imupright]]  ; join the four parts

end;chi_trim.pro