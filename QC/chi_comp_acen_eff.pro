;+
;
;  NAME: 
;     chi_comp_acen_eff
;
;  PURPOSE: 
;   To compare the efficiency of CHIRON on a few nights before the upgrade to a few nights afterwards. 
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      chi_comp_acen_eff
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
;      chi_comp_acen_eff
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2012.02.28 05:17:17 PM
;
;-
pro chi_comp_acen_eff, $
help = help, $
postplot = postplot

if keyword_set(help) then begin
	print, '*************************************************'
	print, '*************************************************'
	print, '        HELP INFORMATION FOR chi_comp_acen_eff'
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



;dates before the upgrade:
bdates = ['110324', '110325', '110326', '110327', '110328', '110329', '110330', '110331', $
 '110401', '110402', '110403', '110404', '110405', '110406', '110407', '110408', $ ;no obs on 110409
 '110410', '110411', '110412']
;dates after the upgrade:
adates = ['120226', '120227', '120228', '120302', '120303', '120305', '120306', '120307', $
'120309', '120310', '120311', '120312', '120313', '120314', '120316', '120317', '120318', $
'120319', '120320', '120321', '120322', '120323', '120324', '120325', '120326', '120327']

objname = '128620'
bobnb = ''
bobna = ''
bi2 = ''
bmtime = ''
bexpt = ''
bbin = ''
bslit = ''
btotals = 0d
btotals2 = 0d
bjds = ''
;if 1 eq 0 then begin
bldir1 = '/tous/mir7/logsheets/2011/'

if keyword_set(postplot) then begin
ps_open, nextnameeps('bdates'), /encaps, /color
endif
  plot, findgen(1432), dblarr(1432)+12500, /nodata,$
  xtitle='Cross Disperion', ytitle='ADU', /ysty, yran=[0,12500d]
  colii = 0d
for bi=0, n_elements(bdates)-1 do begin
  readcol, bldir1+bdates[bi]+'.log', $
  obnb, obna, i2, mtime, expt, bin, slit, $
  f='(A,A,A,A,A,A,A,A)', skip=9, delim=' '
  bobnb = [bobnb ,obnb ]
  bobna = [bobna , obna]
  bi2 = [bi2 ,i2 ]
  bmtime = [bmtime , mtime]
  bexpt = [bexpt , expt]
  bbin = [bbin , bin]
  bslit = [bslit , slit]
  ac = where((obna eq objname) and (i2 eq 'y') and (bin eq '3x1') and (slit eq 'narrow'))
	 if long(bdates[bi]) lt 110408L then begin
		fn = '/raw/mir7/'+bdates[bi]+'/qa32.'+obnb[ac[0]]+'.fits'
    endif else fn = '/raw/mir7/'+bdates[bi]+'/qa33.'+obnb[ac[0]]+'.fits'
    
	 im = chi_rm_bias(filename=fn, hd=hd)
	 mask = im * 0d
	 mask[640:967, *] = 1d
	 mask = rotate(mask, 2)
;	 display, mask
;	 stop
  for aci = 0, n_elements(ac)-1 do begin
	 if long(bdates[bi]) lt 110408L then begin
    fn = '/raw/mir7/'+bdates[bi]+'/qa32.'+obnb[ac[aci]]+'.fits'
    endif else     fn = '/raw/mir7/'+bdates[bi]+'/qa33.'+obnb[ac[aci]]+'.fits'

	 im = chi_rm_bias(filename=fn, hd=hd)
	 im = im * mask
;	 stop
;    window, 0
;	 display, im
	 cgres = chip_geometry(fn, hdr=hd)
	 itul = cgres.image_trim.upleft
	 itur = cgres.image_trim.upright
	 ;window, 1
	 oplot, im[*, 2048], col=colii/9*8d
    print, 'date: ', bdates[bi], ' obnm: ',obna[ac[aci]],' obnb: ',obnb[ac[aci]], ' colii: ', colii, ' exptime: ', double(sxpar(hd, 'exptime'))
	 
	 
	 btotals = [btotals, (total(im[itul[0]:itul[1], itul[2]:itul[3]])*2.5d + $
	 							total(im[itur[0]:itur[1], itur[2]:itur[3]])*2.6d)/double(sxpar(hd, 'exptime'))]
	 							
	 btotals2 = [btotals2, (total(im[itul[0]:itul[1], itul[2]:itul[3]])*2.5d + $
	 							total(im[itur[0]:itur[1], itur[2]:itur[3]])*2.6d)]
	 							
	 bjds = [bjds, sxpar(hd, 'utshut')]
	 colii++
  endfor;aci
endfor;bi
if keyword_set(postplot) then begin
ps_close
endif
plot, btotals, ps=8
;stop
;endif
aobnb = ''
aobna = ''
ai2 = ''
amtime = ''
aexpt = ''
abin = ''
aslit = ''
atotals = 0d
atotals2 = 0d
ajds = ''
aemcts = 0d

aldir = '/tous/mir7/logsheets/2012/'
window, /free
if keyword_set(postplot) then begin
ps_open, nextnameeps('adates'), /encaps, /color
endif
  plot, findgen(1432), dblarr(1432)+12500, /nodata,$
  xtitle='Cross Disperion', ytitle='ADU', /ysty, yran=[0,6d4]
  colii = 0d
for ai=0, n_elements(adates)-1 do begin
  readcol, aldir+adates[ai]+'.log', $
  obnb, obna, i2, mtime, expt, bin, slit, $
  f='(A,A,A,A,A,A,A,A)', skip=9, delim=' '
  aobnb = [aobnb ,obnb ]
  aobna = [aobna , obna]
  ai2 = [ai2 ,i2 ]
  amtime = [amtime , mtime]
  aexpt = [aexpt , expt]
  abin = [abin , bin]
  aslit = [aslit , slit]
  ac = where((obna eq objname) and (i2 eq 'y') and (bin eq '3x1') and (slit eq 'narrow'), account)
    fnd = '/raw/mir7/'+adates[ai]+'/'
    fnm = 'chi'+adates[ai]+'.'+obnb[ac[0]]+'.fits'
    fn = fnd+fnm
	 im = chi_rm_bias(filename=fn, hd=hd)
	 mask = im * 0d
	 mask[640:967, *] = 1d
	 mask = rotate(mask, 2)
	 display, mask
	if account gt 0 then begin
  for aci = 0, n_elements(ac)-1 do begin
    print, 'date: ', adates[ai], ' obnm: ',obna[ac[aci]],' obnb: ',aobnb[ac[aci]], ' colii: ', colii
    fnd = '/raw/mir7/'+adates[ai]+'/'
    fnm = 'chi'+adates[ai]+'.'+obnb[ac[aci]]+'.fits'
    fn = fnd+fnm
	 im = chi_rm_bias(filename=fn, hd=hd)
	 im = im * mask
;	 window, 0
	 display, im, $
	 title=fnm+' '+sxpar(hd, 'speedmod')
	 cgres = chip_geometry(fn, hdr=hd)
	 itul = cgres.image_trim.upleft
	 itur = cgres.image_trim.upright
	 itbl = cgres.image_trim.botleft
	 itbr = cgres.image_trim.botright
;	 window, 1
	 oplot, im[*, 2048], col=colii
	 
	 atotals = [atotals, (total(im[itul[0]:itul[1], itul[2]:itul[3]])*1.3d + $
	 							total(im[itur[0]:itur[1], itur[2]:itur[3]])*1.3d +$
	 							total(im[itbl[0]:itbl[1], itbl[2]:itbl[3]])*1.3d +$
	 							total(im[itbr[0]:itbr[1], itbr[2]:itbr[3]])*1.3d)/$
	 							double(sxpar(hd, 'exptime'))]
	 atotals2 = [atotals2, (total(im[itul[0]:itul[1], itul[2]:itul[3]])*1.3d + $
	 							total(im[itur[0]:itur[1], itur[2]:itur[3]])*1.3d +$
	 							total(im[itbl[0]:itbl[1], itbl[2]:itbl[3]])*1.3d +$
	 							total(im[itbr[0]:itbr[1], itbr[2]:itbr[3]])*1.3d)]
	 ajds = [ajds, sxpar(hd, 'utshut')]
	 aemcts = [aemcts, double(sxpar(hd, 'EMNUMSMP'))*double(sxpar(hd, 'EMAVG'))]
	 colii++
  endfor;aci
  endif ;account
endfor;ai
if keyword_set(postplot) then begin
ps_close
endif
loadct, 39, /silent
stop

if keyword_set(postplot) then begin
   fn = nextnameeps('OnSkyEfficiency')
   thick, 2
   ps_open, fn, /encaps, /color
endif
plot, atotals, ps=8, xtitle='Observation #', ytitle='Total Photoelectrons Per Second', title='Alpha Cen A', /xsty
oplot, btotals, ps=8, color=250
al_legend, ['Before Upgrade', 'After Upgrade'], textcolor=[250, 0], /right

if keyword_set(postplot) then begin
   ps_close
endif
stop
if keyword_set(postplot) then begin
   fn = nextnameeps('OnSkyCounts')
   thick, 2
   ps_open, fn, /encaps, /color
endif
plot, atotals2, ps=8, xtitle='Observation #', ytitle='Total Photoelectrons', title='Alpha Cen A', /ylog, yran=[1d7,1d10], /xsty
oplot, btotals2, ps=8, color=250
al_legend, ['Before Upgrade', 'After Upgrade'], textcolor=[250, 0], /right

if keyword_set(postplot) then begin
   ps_close
endif

ps_open, nextnameeps('EM-CCD'), /encaps, /color
thick, 2
plot, atotals2, aemcts, ps=8, $
xtitle='Total CCD Counts', $
ytitle='Total Exposure Meter Counts', $
title='3 Nights of Alpha Cen A Obs w. I2'

res = linfit(atotals2[1:*], aemcts[1:*], yfit=yfit, /double)
oplot, atotals2[1:*], yfit, color=250
al_legend, ['Y = '+strt(res[1])+'x + '+strt(res[0])], textcolor=250
ps_close
stop
end;chi_comp_acen_eff.pro