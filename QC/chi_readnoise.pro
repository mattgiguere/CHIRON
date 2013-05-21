;+
;
;  NAME: 
;     chi_readnoise
;
;  PURPOSE: 
;   
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      chi_readnoise
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
;      chi_readnoise
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2011.11.30 04:47:06 PM
;
;-
pro chi_readnoise, $
fn = fn, $
help = help, $
postplot = postplot, $
pngplot = pngplot, $
reset = reset, $
 mlimarr = mlimarr, $
 mrimarr=mrimarr, $
 nims = nims

tdir = '/tous/mir7/'
rdir = '/raw/mir7/'
!p.color=0
usersymbol, 'circle', /fill
loadct, 39, /silent

if keyword_set(help) then begin
	print, '*************************************************'
	print, '*************************************************'
	print, '        HELP INFORMATION FOR chi_readnoise'
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

if ~keyword_set(fn) then fn=rdir+'110804/qa39.1967.fits'
;if ~keyword_set(fn) then fn=rdir+'110902/qa39.8575.fits'
;if ~keyword_set(fn) then fn=rdir+'111128/chi111128.1079.fits'

im = readfits(fn, hd, /silent)

date = sxpar(hd, 'date')
  year = strmid(date, 0, 4)
  mon = strmid(date, 5, 2)
  day = strmid(date, 8, 2)
  hour = strmid(date, 11, 2)
  mint = strmid(date, 14, 2)
  sec = strmid(date, 17, 2)
  jd = julday(mon, day, year, hour, mint, sec)

;TSEC21  = '[2:684,1:4112]'     / Good section from det 1  amp 21                
;ASEC21  = '[1:2048,4112:1]'    / CCD  section in read order                     
;CSEC21  = '[2:684,1:4112]'     / copy from DSEC from det 1  amp 21              
;BSEC21  = '[685:700,1:4112]'   / Overscan section from det 1  amp 21            
;DSEC21  = '[2:684,1:4112]'     / Data section from det 1  amp 21                
;SCSEC21 = '[1:2048,1:4112]'    / CCD section from det 1  amp 21                 
;TSEC22  = '[718:1400,1:4112]'  / Good section from det 1  amp 22                
;ASEC22  = '[4096:2049,4112:1]' / CCD  section in read order                     
;CSEC22  = '[718:1400,1:4112]'  / copy from DSEC from det 1  amp 22              
;BSEC22  = '[701:717,1:4112]'   / Overscan section from det 1  amp 22            
;DSEC22  = '[718:1400,1:4112]'  / Data section from det 1  amp 22                
;SCSEC22 = '[2049:4096,1:4112]' / CCD section from det 1  amp 22                 

;These are the values from the FITS header. They were confirmed to be
;exactly the same as those reported in Andrei's "report_Mar6.pdf" document. 
;GAIN21  =                 2.59 / Gain for Amp C                                 
;RON21   =                  9.6 / Read Noise for Amp 21                          
;GAIN22  =                 2.19 / Gain for Amp D                                 
;RON22   =                  7.4 / Read Noise for Amp 22                          

xst = file_info(tdir+'idldat/ronstruct.dat')
if xst.exists then begin
  restore, tdir+'idldat/ronstruct.dat' 
  x = where((*ronstruct.pdate) eq date, ct)
endif else begin 
  reset = 1
  ct = 0
endelse

if ((ct le 0) or (keyword_set(reset))) then begin

nrows = 4112d
rnarr1 = dblarr(nrows)
rnarr2 = dblarr(nrows)

l1 = strmid(sxpar(hd, 'tsec21'), 1,2)
r1 = strmid(sxpar(hd, 'tsec21'), 4,3)
l2 = strmid(sxpar(hd, 'tsec22'), 1,3)
r2 = strmid(sxpar(hd, 'tsec22'), 5,4)
print, l1, ' ', r1, ' ', l2, ' ', r2

imsz = size(im)
if double(r2) ge imsz[1] then r2=double(r2)-1
;stop


for i=0, nrows-1 do begin
rnarr1[i] = stddev(im[l1:r1, i])
rnarr2[i] = stddev(im[l2:r2, i])
endfor

;NOW TO GO FROM SIGMA to FWHM:
rnarr1 *= 2.35482d
rnarr2 *= 2.35482d

;The read noise is FWHM*GAIN (See p. 54 of the Handbook of CCD Astronomy by Howell)
gain1 = 2.59d
gain2 = 2.19d

;NOW TO GO FROM FWHM to RON:
rnarr1 *= gain1
rnarr2 *= gain2

med21 = median(rnarr1)
med22 = median(rnarr2)
std21 = stddev(rnarr1)
std22 = stddev(rnarr2)

imdif = readfits('/raw/mir7/110804/qa39.1967.fits', difhd, /silent)
;exclude outliers:
lim = im[l1:r1, *]
diflim = double(im[l1:r1, *]) - double(imdif[l1:r1, *])
lgoods = where(lim lt 3d3)
rim = im[l2:r2, *]
difrim = double(im[l2:r2, *]) - double(imdif[l2:r2, *])
rgoods = where(rim lt 3d3)

if keyword_set(plot) then begin
if keyword_set(postplot) or keyword_set(pngplot) then begin
  thick, 5
  fname = tdir+'logs/ron/eps/'+year+mon+day+hour+mint+sec
  ps_open, nextnameeps(fname), /encaps, /color
endif
window, 0
!p.color=0
plot, rnarr1, ps=8,/ysty, /xsty, $
xtitle='Row', ytitle='Readout Noise(Row)', yran = [0,30], $
title=fn
 ;stop
oplot, rnarr2, ps=8, color=250
items = ['amp21', 'amp22']

al_legend, items, psym = [8,8], colors = [0, 250]
xyouts, 0.8, 0.925, 'Median N!dR!n 21: '+strt(med21, f='(F8.1)'), /normal
xyouts, 0.8, 0.9, 'Median N!dR!n 22: '+strt(med22, f='(F8.1)'), /normal

if keyword_set(postplot) or keyword_set(pngplot) then begin
  ps_close
endif

if keyword_set(pngplot) then begin
  pngnm = tdir+'logs/ron/pngs/'+year+mon+day+hour+mint+sec
  spawn, 'convert -density 200 '+fname+'.eps '+pngnm+'.png'
endif

window, 1
plothist, lim[lgoods], bin=1d
plothist, rim[rgoods], bin=1d, /over, color=250
;stop
window, 2
if n_elements(uniq(diflim[lgoods])) gt 1 then plothist, diflim[lgoods], bin=1d
window, 3
if n_elements(uniq(difrim[rgoods])) gt 1 then plothist, difrim[rgoods], bin=1d, color=250
endif;KW:plot


  window, 3
  plothist, mlimarr
  restore, '/tous/mir7/idldat/mlimarr110804.dat'
  restore, '/tous/mir7/idldat/mrimarr110804.dat'

  if ~keyword_set(reset) then begin
	 datarr = [(*ronstruct.pdate), date]
	 jdarr = [(*ronstruct.pjd), jd]
	 r21arr = [(*ronstruct.pron21), med21]
	 r22arr = [(*ronstruct.pron22), med22]
	 full21arr = [(*ronstruct.pfull21), stddev(lim[lgoods])]
	 full22arr = [(*ronstruct.pfull22), stddev(rim[rgoods])]
	 diffull21arr = [(*ronstruct.pdiffull21), stddev(diflim[lgoods])]
	 diffull22arr = [(*ronstruct.pdiffull22), stddev(difrim[rgoods])]
	 std21arr = [(*ronstruct.pstd21arr), std21]
	 std22arr = [(*ronstruct.pstd22arr), std22]
	 rnarr1arr = [[(*ronstruct.prnarr1arr)], [rnarr1]]
	 rnarr2arr = [[(*ronstruct.prnarr2arr)], [rnarr2]]
;	 mlimarrarr = [[[(*ronstruct.pmlimarrarr)]], [[mlimarr]]]
;	 mrimarrarr = [[[(*ronstruct.pmrimarrarr)]], [[mrimarr]]]
	 mlimstd = [(*ronstruct.pmlimstd), stddev(mlimarr)]
	 mrimstd = [(*ronstruct.pmrimstd), stddev(mrimarr)]
;	 mdiflimarrarr = [[[(*ronstruct.pmdiflimarrarr)]], [[mlimarr - mlimarr110804]]]
;	 mdifrimarrarr = [[[(*ronstruct.pmdifrimarrarr)]], [[mrimarr - mrimarr110804]]]
	 mdiflimstd = [(*ronstruct.pmdiflimstd), stddev(mlimarr - mlimarr110804)]
	 mdifrimstd = [(*ronstruct.pmdifrimstd), stddev(mrimarr - mrimarr110804)]
	 nimsarr = [(*ronstruct.pnimsarr), nims]
	 
	 pdate = ptr_new(datarr)
	 pjd = ptr_new(jdarr)
	 pron21 = ptr_new(r21arr)
	 pron22 = ptr_new(r22arr)
	 pfull21 = ptr_new(full21arr)
	 pfull22 = ptr_new(full22arr)
	 pdiffull21 = ptr_new(diffull21arr)
	 pdiffull22 = ptr_new(diffull22arr)
	 pstd21arr = ptr_new(std21arr)
	 pstd22arr = ptr_new(std22arr)
	 prnarr1arr = ptr_new(rnarr1arr)
	 prnarr2arr = ptr_new(rnarr2arr)
;	 pmlimarrarr = ptr_new(mlimarrarr)
;	 pmrimarrarr = ptr_new(mrimarrarr)
	 pmlimstd = ptr_new(mlimstd)
	 pmrimstd = ptr_new(mrimstd)
;	 pmdiflimarrarr = ptr_new(mdiflimarrarr)
;	 pmdifrimarrarr = ptr_new(mdifrimarrarr)
	 pmdiflimstd = ptr_new(mdiflimstd)
	 pmdifrimstd = ptr_new(mdifrimstd)
	 pnimsarr = ptr_new(nimsarr)
	 
	 
	 jdoff = julday(8,1,2011,12,0,0)
	 jdarr = double((*ronstruct.pjd))
	 nd = where(jdarr lt 2455896d)
	 jdarr -= jdoff
	 std2fwhm = 2.35482d
	 farr21 = (*ronstruct.pfull21)*2.59
	 farr22 = (*ronstruct.pfull22)*2.19
	 mfarr21 = (*ronstruct.pmlimstd)*2.59*sqrt((*ronstruct.pnimsarr))
	 mfarr22 = (*ronstruct.pmrimstd)*2.19*sqrt((*ronstruct.pnimsarr))
	 mdfarr21 = (*ronstruct.pmdiflimstd)*2.59*sqrt((*ronstruct.pnimsarr))
	 mdfarr22 = (*ronstruct.pmdifrimstd)*2.19*sqrt((*ronstruct.pnimsarr))
	 
	 if n_elements(jdarr) gt 1 then begin
	 window, 4, xpos = 3700
	 ;print, 'farr21 is: ', farr21
	 plot, jdarr, mfarr21, ps=8, yran = [0,50], /xsty, $
	 xtitle='JD - AUG 1 2011', $
	 ytitle = 'Readnoise [e!u-!n]'
	 oplot, jdarr, mfarr22, ps=8, color=250
	 
	 dec1 = julday(12,1,2011,12,0,0)
	 oplot, [dec1, dec1] - jdoff, [0,50], linestyle=2
	 xyouts, dec1 - jdoff, 12, 'DEC', orient=90
	 nov1 = julday(11,1,2011,12,0,0)
	 oplot, [nov1, nov1] - jdoff, [0,50], linestyle=2
	 xyouts, nov1 - jdoff, 12, 'NOV', orient=90
	 oct1 = julday(10,1,2011,12,0,0)
	 oplot, [oct1, oct1] - jdoff, [0,50], linestyle=2
	 xyouts, oct1 - jdoff, 12, 'OCT', orient=90
	 sep1 = julday(9,1,2011,12,0,0)
	 oplot, [sep1, sep1] - jdoff, [0,50], linestyle=2
	 xyouts, sep1 - jdoff, 12, 'SEP', orient=90
	 al_legend, ['Amp 21', 'Amp 22'], psym=[8,8], color=[0,250], /right
	 
	 window, 5, xpos = 3700, ypos = 50
	 ;print, 'farr21 is: ', farr21
	 plot, jdarr, mdfarr21, ps=8, yran = [0,50], /xsty, $
	 xtitle='JD - AUG 1 2011', $
	 ytitle = 'Differenced Readnoise [e!u-!n]'
	 oplot, jdarr, mdfarr22, ps=8, color=250
	 
	 dec1 = julday(12,1,2011,12,0,0)
	 oplot, [dec1, dec1] - jdoff, [0,50], linestyle=2
	 xyouts, dec1 - jdoff, 12, 'DEC', orient=90
	 nov1 = julday(11,1,2011,12,0,0)
	 oplot, [nov1, nov1] - jdoff, [0,50], linestyle=2
	 xyouts, nov1 - jdoff, 12, 'NOV', orient=90
	 oct1 = julday(10,1,2011,12,0,0)
	 oplot, [oct1, oct1] - jdoff, [0,50], linestyle=2
	 xyouts, oct1 - jdoff, 12, 'OCT', orient=90
	 sep1 = julday(9,1,2011,12,0,0)
	 oplot, [sep1, sep1] - jdoff, [0,50], linestyle=2
	 xyouts, sep1 - jdoff, 12, 'SEP', orient=90
	 al_legend, ['Amp 21', 'Amp 22'], psym=[8,8], color=[0,250], /right
	 
	 
	 
	 endif

  endif else begin;NO RESET
	 pdate = ptr_new(date)
	 pjd = ptr_new(jd)
	 pron21 = ptr_new(med21)
	 pron22 = ptr_new(med22)
	 pfull21 = ptr_new(stddev(lim[lgoods]))
	 pfull22 = ptr_new(stddev(rim[rgoods]))
	 pdiffull21 = ptr_new(stddev(diflim[lgoods]))
	 pdiffull22 = ptr_new(stddev(difrim[rgoods]))
	 pstd21arr = ptr_new(std21)
	 pstd22arr = ptr_new(std22)
	 prnarr1arr = ptr_new(rnarr1)
	 prnarr2arr = ptr_new(rnarr2)
;	 pmlimarrarr = ptr_new(mlimarr)
;	 pmrimarrarr = ptr_new(mrimarr)
	 pmlimstd = ptr_new(stddev(mlimarr))
	 pmrimstd = ptr_new(stddev(mrimarr))
;	 pmdiflimarrarr = ptr_new(mlimarr - mlimarr110804)
;	 pmdifrimarrarr = ptr_new(mrimarr - mrimarr110804)
	 pmdiflimstd = ptr_new(stddev(mlimarr - mlimarr110804))
	 pmdifrimstd = ptr_new(stddev(mrimarr - mrimarr110804))
	 pnimsarr = ptr_new(nims)
	 
  endelse ;RESET
    print, 'HELP FOR prnarr1arr: '
    help, (*prnarr1arr)
	 ronstruct = create_struct('pdate', pdate, 'pjd', pjd, $
	 'pron21', pron21, 'pron22', pron22, $
	 'pfull21', pfull21, 'pfull22', pfull22, $
	 'pdiffull21', pdiffull21, 'pdiffull22', pdiffull22, $
	 'pstd21arr', pstd21arr, 'pstd22arr', pstd22arr, $
	 'prnarr1arr', prnarr1arr, 'prnarr2arr', prnarr2arr, $
;	 'pmlimarrarr', pmlimarrarr, 'pmrimarrarr', pmrimarrarr, $
	 'pmlimstd', pmlimstd, 'pmrimstd', pmrimstd, $
;	 'pmdiflimarrarr', pmdiflimarrarr, 'pmdifrimarrarr', pmdifrimarrarr, $
	 'pmdiflimstd', pmdiflimstd, 'pmdifrimstd', pmdifrimstd, $
	 'pnimsarr', pnimsarr)
	 
	 save, ronstruct, filename=tdir+'idldat/ronstruct.dat'
endif else begin
  print, '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
  print, 'THIS EXPOSURE IS ALREADY IN THE RON DATA STRUCTURE!'
  print, '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
endelse
;stop
end;chi_readnoise.pro