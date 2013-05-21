;+
;
;  NAME: 
;     chi_medianbias
;
;  PURPOSE: 
;    To create and store median bias frames for the various modes for 
;	 bias subtraction
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      chi_medianbias
;
;  INPUTS:
;
;  OPTIONAL INPUTS:
;
;  OUTPUTS:
;
;  KEYWORD PARAMETERS:
;    
;  EXAMPLE:
;      chi_medianbias, redpar = redpar, log = log, /bin31, /normal
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2012.04.17 04:09:19 PM
;
;-
pro chi_medianbias, $
help = help, $
postplot = postplot, $
redpar = redpar, $
bin11 = bin11, $
bin31 = bin31, $
bin44 = bin44, $
normal = normal, $
fast = fast, $
log = log

if keyword_set(help) then begin
	print, '*************************************************'
	print, '*************************************************'
	print, '        HELP INFORMATION FOR chi_medianbias'
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

if keyword_set(bin31) then binsz='31'
if keyword_set(bin11) then binsz='11'
if keyword_set(bin44) then binsz='44'
if keyword_set(normal) then rdspd = 'normal'
if keyword_set(fast) then rdspd = 'fast'


bobs = where(strt(log.object) eq 'bias' and strt(log.ccdsum) eq '3 1' and strt(log.speedmod) eq 'normal', bobsct)

if keyword_set(bin11) and keyword_set(normal) then begin
  bobs = where(strt(log.object) eq 'bias' and strt(log.ccdsum) eq '1 1' and strt(log.speedmod) eq 'normal', bobsct)
endif

if keyword_set(bin11) and keyword_set(fast) then begin
  bobs = where(strt(log.object) eq 'bias' and strt(log.ccdsum) eq '1 1' and strt(log.speedmod) eq 'fast', bobsct)
endif

if keyword_set(bin31) and keyword_set(fast) then begin
  bobs = where(strt(log.object) eq 'bias' and strt(log.ccdsum) eq '3 1' and strt(log.speedmod) eq 'fast', bobsct)
endif

if keyword_set(bin44) and keyword_set(normal) then begin
  bobs = where(strt(log.object) eq 'bias' and strt(log.ccdsum) eq '4 4' and strt(log.speedmod) eq 'normal', bobsct)
endif
print, 'bobsct is: ', bobsct
if bobsct gt 2 then begin
bcube = dblarr(long(log[bobs[0]].naxis1), long(log[bobs[0]].naxis2), bobsct)
for i=0, bobsct-1 do begin
bcube[*,*,i] = readfits(log[bobs[i]].filename, hd)
endfor
bobsmed = median(bcube, /double, dimen=3)
fname = redpar.rootdir+redpar.biasdir+redpar.date+'_bin'+binsz+'_'+rdspd+'_medbias.dat'
save, bobsmed, filename=fname
print, 'Median bias frome filename saved as: ', fname
endif
end;chi_medianbias.pro