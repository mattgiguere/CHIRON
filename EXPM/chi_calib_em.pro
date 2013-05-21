;+
;
;  NAME: 
;     chi_calib_em
;
;  PURPOSE: 
;   To calibrate the CHIRON exposure meter set point with a SNR
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      chi_calib_em
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
;      chi_calib_em
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2011.11.30 03:02:46 PM
;
;-
pro chi_calib_em, $
help = help

if keyword_set(help) then begin
	print, '*************************************************'
	print, '*************************************************'
	print, '        HELP INFORMATION FOR chi_calib_em'
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

angs = '!6!sA!r!u!9 %!6!n'
;restore an exposure of tau ceti:
im = readfits('/mir7/fitspec/achi111128.1257.fits', hd)
s = chi_wavspec(im)
ord = 21
ps_open, nextnameeps('~/Desktop/emplot'), /encaps, /color
plot, s.wav[*,ord], s.spec[*,ord], ps=-8, /xsty, /ysty, $
xtitle='Wavelength ['+angs+']', ytitle='Flux'
;contf, s.spec[*,ord], c, nord=3
;loadct, 39, /silent
;oplot, s.wav[*,ord], c, ps=8, color=70

;contf, s.spec[*,ord], c, nord=4
;loadct, 39, /silent
;oplot, s.wav[*,ord], c, ps=8, color=120

contf, s.spec[*,ord], c, nord=5
loadct, 39, /silent
oplot, s.wav[*,ord], c, ps=8, color=170

ps_close
;contf, s.spec[*,ord], c, nord=6
;loadct, 39, /silent
;oplot, s.wav[*,ord], c, ps=8, color=220

;contf, s.spec[*,ord], c, nord=7
;loadct, 39, /silent
;oplot, s.wav[*,ord], c, ps=8, color=245


maxloc = where(c eq max(c))
maxwav = s.wav[maxloc, ord]
maxcts = max(c)
print, 'The continuum max is at: ', strt(maxwav),' AA and has a max of ',strt(c[maxloc]), ' cts.'
print, 'SNR is: ', sqrt(maxcts)

print, transpose(hd)
stop
end;chi_calib_em.pro