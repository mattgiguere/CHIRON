;+
;
;  NAME: 
;     chi_wavspec
;
;  PURPOSE: 
;   To output a wavelength calibrated spectrum
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      chi_wavspec
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
;      chi_wavspec
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2011.11.30 03:06:44 PM
;
;-
function chi_wavspec, $
im, $
help = help

if keyword_set(help) then begin
	print, '*************************************************'
	print, '*************************************************'
	print, '        HELP INFORMATION FOR chi_wavspec'
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

imdim = size(im)
wav = dblarr(imdim[2], imdim[3])
spec = dblarr(imdim[2], imdim[3])
for ii=0, imdim[3]-1 do begin 
  wav[*, ii] = im[0, *, ii]
  spec[*, ii] = im[1, *, ii]
endfor

a = create_struct('wav', wav, 'spec', spec)
return, a
end;chi_wavspec.pro