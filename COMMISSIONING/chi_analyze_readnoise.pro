;+
;
;  NAME: 
;     chi_analyze_readnoise
;
;  PURPOSE: 
;   To examine the readnoise pertaining to the CHIRON CCD
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      chi_analyze_readnoise
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
;      chi_analyze_readnoise
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2012.02.02 04:37:33 PM
;
;-
pro chi_analyze_readnoise, $
help = help, $
pergs = pergs, $
postplot = postplot

if keyword_set(help) then begin
	print, '*************************************************'
	print, '*************************************************'
	print, '        HELP INFORMATION FOR chi_analyze_readnoise'
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
usersymbol, 'circle', /fill, size_of_sym = 0.4
loadct, 39, /silent
restore, '/tous/mir7/idldat/ronstruct.dat'
x = (*ronstruct.prnarr1arr)
n_biases = n_elements(x[0,*])
if keyword_set(pergs) then begin
  for i=0, n_biases-1 do begin
  stds = x[*,i]
  goods = where(stds lt 40)
  cf = create_struct('jd', lindgen(n_elements(goods)), $
  'mnvel', stds[goods] - median(stds[goods]))
  window, 1
  plot, stds[goods], ps=8, /xsty, /ysty
  z = lindgen(n_elements(goods)) mod 2
  y = where(z eq 1)
  w = where(z eq 0)
  t = lindgen(n_elements(stds)) mod 2
  u = where(t eq 1)
  v = where(t eq 0)
  stop
  oplot, y, stds[goods[y]], ps=8, color=245
  xyouts, 0.8,0.9, 'Odds_Goods: '+strt(median(stds[goods[y]])), /normal
  xyouts, 0.8,0.88, 'Evens_Goods: '+strt(median(stds[goods[w]])), /normal
  xyouts, 0.8,0.86, 'Odds_All: '+strt(median(stds[u])), /normal
  xyouts, 0.8,0.84, 'Evens_All: '+strt(median(stds[v])), /normal
  
  pergram, cf, nu_out, peri_out, /noplot, pmax = 1024, /verbose
  window, 2
  plot, 1d / nu_out, peri_out, /xsty
  stop
  endfor
endif

;plot, (*ronstruct.pstd21arr), ps=8, yran=[0,40], /xsty
;oplot, (*ronstruct.pstd22arr), ps=8, color=245

if keyword_set(postplot) then begin
  thick, 2
  ps_open, nextnameeps('READNOISE'), /encaps, /color
endif
jdoff = julday(8,1,2011,12,0,0)
jdarr = double((*ronstruct.pjd))
nd = where(jdarr lt 2455896d)
jdarr -= jdoff
std2fwhm = 2.35482d
farr21 = (*ronstruct.pfull21)*2.59
farr22 = (*ronstruct.pfull22)*2.19
farr21 = (*ronstruct.pmlimstd)*2.59*sqrt((*ronstruct.pnimsarr))
farr22 = (*ronstruct.pmrimstd)*2.19*sqrt((*ronstruct.pnimsarr))
stop
plot, jdarr, farr21, ps=8, yran = [0,30], /xsty, $
xtitle='JD - AUG 1 2011', $
ytitle = 'Readnoise [e!u-!n]'
oplot, jdarr, farr22, ps=8, color=250

dec1 = julday(12,1,2011,12,0,0)
ypos = 1
oplot, [dec1, dec1] - jdoff, [0,50], linestyle=2
xyouts, dec1 - jdoff, ypos, 'DEC', orient=90
nov1 = julday(11,1,2011,12,0,0)
oplot, [nov1, nov1] - jdoff, [0,50], linestyle=2
xyouts, nov1 - jdoff, ypos, 'NOV', orient=90
oct1 = julday(10,1,2011,12,0,0)
oplot, [oct1, oct1] - jdoff, [0,50], linestyle=2
xyouts, oct1 - jdoff, ypos, 'OCT', orient=90
sep1 = julday(9,1,2011,12,0,0)
oplot, [sep1, sep1] - jdoff, [0,50], linestyle=2
xyouts, sep1 - jdoff, ypos, 'SEP', orient=90
al_legend, ['Amp 21', 'Amp 22'], psym=[8,8], color=[0,250], /right

if keyword_set(postplot) then begin
  ps_close
endif

if keyword_set(postplot) then begin
  thick, 2
  ps_open, nextnameeps('DIFREADNOISE'), /encaps, /color
endif
jdoff = julday(8,1,2011,12,0,0)
jdarr = double((*ronstruct.pjd))
nd = where(jdarr lt 2455896d)
jdarr -= jdoff
std2fwhm = 2.35482d
diffarr21 = (*ronstruct.pdiffull21)*2.59
diffarr22 = (*ronstruct.pdiffull22)*2.19

plot, jdarr, diffarr21, ps=8, $
;yran = [5,15], $
/xsty, $
xtitle='JD - AUG 1 2011', $
ytitle = 'Dif Readnoise [e!u-!n]'
oplot, jdarr, diffarr22, ps=8, color=250

dec1 = julday(12,1,2011,12,0,0)
ypos = 1
oplot, [dec1, dec1] - jdoff, [0,50], linestyle=2
xyouts, dec1 - jdoff, ypos, 'DEC', orient=90
nov1 = julday(11,1,2011,12,0,0)
oplot, [nov1, nov1] - jdoff, [0,50], linestyle=2
xyouts, nov1 - jdoff, ypos, 'NOV', orient=90
oct1 = julday(10,1,2011,12,0,0)
oplot, [oct1, oct1] - jdoff, [0,50], linestyle=2
xyouts, oct1 - jdoff, ypos, 'OCT', orient=90
sep1 = julday(9,1,2011,12,0,0)
oplot, [sep1, sep1] - jdoff, [0,50], linestyle=2
xyouts, sep1 - jdoff, ypos, 'SEP', orient=90
al_legend, ['Amp 21', 'Amp 22'], psym=[8,8], color=[0,250], /right

if keyword_set(postplot) then begin
  ps_close
endif

stop
end;chi_analyze_readnoise.pro