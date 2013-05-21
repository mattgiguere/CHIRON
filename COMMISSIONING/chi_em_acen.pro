;+
;
;  NAME: 
;     chi_comp_acen_eff
;
;  PURPOSE: 
;   To compare the efficiency of CHIRON on a few nights before the upgrade 
;		to a few nights afterwards. 
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
pro chi_em_acen, $
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
;bdates = ['110324', '110325', '110326']
;dates after the upgrade:
;adates = ['120226', '120227', '120228', '120302']
adates = ['120306']

objname = 'Canopus'

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
atotalsim2 = 0d
atotalsim22 = 0d
atotals2 = 0d
ajds = ''
aemcts = 0d
nords = 62
aexptms = 0d
aseeing = 0d

aioddir = '/tous/mir7/iodspec/'
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
  ac = where((obna eq objname) and (i2 eq 'y') and $
  			(bin eq '3x1') and (slit eq 'narrow'), acnt)
    fnd = '/raw/mir7/'+adates[ai]+'/'
    fnm = 'chi'+adates[ai]+'.'+obnb[ac[0]]+'.fits'
    aiodtotals = dblarr(nords, acnt)
    fn = fnd+fnm
	 im = chi_rm_bias(filename=fn, hd=hd)
	 mask = im * 0d
	 mask2 = im * 0d
	 mask[640:967, *] = 1d
	 mask2[640:680, *] = 1d
	 mask = rotate(mask, 2)
	 mask2 = rotate(mask2, 2)
	 display, mask
	 display, mask2

  for aci = 0, n_elements(ac)-1 do begin
    fnd = '/raw/mir7/'+adates[ai]+'/'
    fnm = 'chi'+adates[ai]+'.'+obnb[ac[aci]]+'.fits'
    ifnm = 'achi'+adates[ai]+'.'+obnb[ac[aci]]
    fn = fnd+fnm
	 im0 = chi_rm_bias(filename=fn, hd=hd)
	 im = im0 * mask
	 im2 = im0 * mask2
;	 window, 0
	 display, im2, $
	 title=fnm+' '+sxpar(hd, 'speedmod')
	 cgres = chip_geometry(fn, hdr=hd)
	 itul = cgres.image_trim.upleft
	 itur = cgres.image_trim.upright
	 itbl = cgres.image_trim.botleft
	 itbr = cgres.image_trim.botright
;	 window, 1
	 oplot, im2[*, 2048], col=colii
	 
	 atotals = [atotals, (total(im0[itul[0]:itul[1], itul[2]:itul[3]])*1.3d + $
	 						total(im0[itur[0]:itur[1], itur[2]:itur[3]])*1.3d +$
	 						total(im0[itbl[0]:itbl[1], itbl[2]:itbl[3]])*1.3d +$
	 						total(im0[itbr[0]:itbr[1], itbr[2]:itbr[3]])*1.3d)/$
	 							double(sxpar(hd, 'exptim0e'))]
     thistot2 = (total(im0[itul[0]:itul[1], itul[2]:itul[3]])*1.3d + $
	 						total(im0[itur[0]:itur[1], itur[2]:itur[3]])*1.3d +$
	 						total(im0[itbl[0]:itbl[1], itbl[2]:itbl[3]])*1.3d +$
	 						total(im0[itbr[0]:itbr[1], itbr[2]:itbr[3]])*1.3d)
	 atotalsim2 = [atotals, (total(im2[itul[0]:itul[1], itul[2]:itul[3]])*1.3d + $
	 						total(im2[itur[0]:itur[1], itur[2]:itur[3]])*1.3d +$
	 						total(im2[itbl[0]:itbl[1], itbl[2]:itbl[3]])*1.3d +$
	 						total(im2[itbr[0]:itbr[1], itbr[2]:itbr[3]])*1.3d)/$
	 							double(sxpar(hd, 'exptim2e'))]
     thistotim2 = (total(im2[itul[0]:itul[1], itul[2]:itul[3]])*1.3d + $
	 						total(im2[itur[0]:itur[1], itur[2]:itur[3]])*1.3d +$
	 						total(im2[itbl[0]:itbl[1], itbl[2]:itbl[3]])*1.3d +$
	 						total(im2[itbr[0]:itbr[1], itbr[2]:itbr[3]])*1.3d)
	 atotals2 = [atotals2, thistot2]
	 atotalsim22 = [atotalsim22, thistotim2]
     rdsk, aiodim, aioddir+ifnm, 1
     aiodtotals[*,aci] = total(aiodim, 1)
	 ajds = [ajds, sxpar(hd, 'utshut')]
	 aseeing = [aseeing, sxpar(hd, 'seeing')]
	 aemcts = [aemcts, double(sxpar(hd, 'EMNUMSMP'))*double(sxpar(hd, 'EMAVG'))]
	 aexptms = [aexptms, double(sxpar(hd, 'exptime'))]
;	 print, 'date: ', adates[ai], ' obnm: ',obna[ac[aci]],$
;		' obnb: ',obnb[ac[aci]], ' cts: ', thistot2,' colii: ', colii
	 print, 'date: ', adates[ai], ' obnm: ',obna[ac[aci]],$
		' obnb: ',obnb[ac[aci]], ' cts: ', thistot2,$
		' emcts: ', double(sxpar(hd, 'EMNUMSMP'))*double(sxpar(hd, 'EMAVG'))

	 colii++
  endfor;aci
endfor;ai
if keyword_set(postplot) then begin
ps_close
endif
loadct, 39, /silent
ps_open, nextnameeps('EM_ACEN_PLOT'), /encaps, /color
thick, 2
plot, findgen(62), /ylog, yran = [1d8, 1d10], /xsty, xtit='Ord #'
usersymbol, 'circle', /fill, size_of_sym = 0.25
for i=0, acnt-1 do oplot, aiodtotals[*,i], col = 5*i, ps=8
oplot, [12,12], [1,1d11], linestyle = 2, color=120
oplot, [31,31], [1,1d11], linestyle = 2, color=120
for i=0, acnt-1 do oplot, [i,i],[atotals2[i],atotals2[i]], col = 5*i, ps=4
for i=0, acnt-1 do oplot, [i,i],[aemcts[i],aemcts[i]]*1d3, col = 5*i, ps=2
for i=0, acnt-1 do oplot, [i,i],[aexptms[i],aexptms[i]]*1d7, col = 5*i, ps=5
al_legend, ['Order Total', 'I2 CCD Total', 'EM Total * 1d3', 'Exp T * 1d7'], $
	psym = [8,4,2,5], /right
ps_close

stop

if keyword_set(postplot) then begin
   fn = 'OnSkyEfficiency'
   if file_test(fn) then spawn, 'mv '+fn+' '+nextnameeps(fn+'_old')
   thick, 2
   ps_open, fn, /encaps, /color
endif
plot, atotals, ps=8, xtitle='Observation #', $
	ytitle='Total Photoelectrons Per Second', title='Alpha Cen A', /xsty
;oplot, btotals, ps=8, color=250
;al_legend, ['Before Upgrade', 'After Upgrade'], textcolor=[250, 0], /right

if keyword_set(postplot) then begin
   ps_close
endif
stop
if keyword_set(postplot) then begin
   fn = nextnameeps('OnSkyCounts')
   if file_test(fn) then spawn, 'mv '+fn+' '+nextnameeps(fn+'_old')
   thick, 2
   ps_open, fn, /encaps, /color
endif
plot, atotals2, ps=8, xtitle='Observation #', $
ytitle='Total Photoelectrons', title='Alpha Cen A', $
/ylog, yran=[1d7,1d10], /xsty
;oplot, btotals2, ps=8, color=250
;al_legend, ['Before Upgrade', 'After Upgrade'], textcolor=[250, 0], /right

if keyword_set(postplot) then begin
   ps_close
endif

ps_open, nextnameeps('EM-CCD'), /encaps, /color
thick, 2
plot, atotals2, aemcts, ps=8, $
xtitle='Total CCD Counts', $
ytitle='Total Exposure Meter Counts', $
title='3 Nights of Alpha Cen A Obs w. I2'
oplot, atotalsim22, aemcts, ps=8, color=85

res = linfit(atotals2[1:*], aemcts[1:*], yfit=yfit, /double)
oplot, atotals2[1:*], yfit, color=250
al_legend, ['Y = '+strt(res[1])+'x + '+strt(res[0])], textcolor=250
ps_close
stop
end;chi_comp_acen_eff.pro