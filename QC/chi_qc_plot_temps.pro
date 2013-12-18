;+
;
;  NAME: 
;     chi_qc_plot_temps
;
;  PURPOSE: 
;   
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      chi_qc_plot_temps
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
;      chi_qc_plot_temps
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2013.03.13 13:58:20
;
;-
pro chi_qc_plot_temps, $
date = date, $
insttemp = insttemp, $
dettemps = dettemps, $
chipress = chipress, $
postplot = postplot, $
dir = dir

if ~keyword_set(dir) then dir = '/home/matt/Sites/chi/'
pdir = dir+'plots/'
tpsdir = pdir+'tps'
if ~file_test(tpsdir, /directory) then spawn, 'mkdir '+tpsdir

angstrom = '!6!sA!r!u!9 %!6!n'
!p.color=0
!p.background=255
loadct, 39, /silent
usersymbol, 'circle', /fill, size_of_sym = 0.5

;returns the date in Julian form (beginning at noon)
datejd = julform(date = date, form = 'yymmdd')

;INSTTEMP PLOTTING:
if keyword_set(insttemp) then begin
  ;first the daily plotting:
  xit = where(insttemp.insttempjd ge datejd and $
	  insttemp.insttempjd lt datejd+1, nxit)

  if nxit gt 1 then begin
	it1 = insttemp[xit]
	minjd = min(it1.insttempjd)
	xarr = (it1.insttempjd - minjd)*24d
	
	;set the plot y-range:
	miny = 0.99* (min(it1.grating) < min(it1.tabcen) < min(it1.encltemp) < $
		min(it1.enclsetp) < min(it1.encl2) < min(it1.tablow) < $
		min(it1.struct) < min(it1.instsetp) < min(it1.insttemp))

	maxy = 1.01* (max(it1.grating) > max(it1.tabcen) > max(it1.encltemp) > $
		max(it1.enclsetp) > max(it1.encl2) > max(it1.tablow) > $
		max(it1.struct) > max(it1.instsetp) > max(it1.insttemp))

	if keyword_set(postplot) then begin
	  ;first test the temps date directory, and make it for the new year if need be:
	  tpdatedir = pdir+'tps/20'+strmid(date,0,2)
	  if ~file_test(tpdatedir, /directory) then spawn, 'mkdir '+tpdatedir
	  tpfn = pdir+'tps/20'+strmid(date, 0, 2)+'/insttempdayeps/'+date+'insttempday'
	  tpfnp = pdir+'tps/20'+strmid(date, 0, 2)+'/insttempdaypng/'+date+'insttempday'
	  if file_test(tpfn) then spawn, 'mv '+tpfn+' '+nextnameeps(tpfn+'_old')
	   thick, 2
	   ps_open, tpfn, /encaps, /color
	endif

	plot, xarr, it1.grating, ps=-8, $
	xtitle='Hours after '+jul2cal(minjd)+ ' UT', $
	/ysty, yran=[miny, maxy], $
	ytitle = 'Temp [K]', /xsty
	
	oplot, xarr, it1.tablow, ps=-8, col=208
	oplot, xarr, it1.tabcen, ps=-8, col=40
	oplot, xarr, it1.struct, ps=-8, col=250
	oplot, xarr, it1.instsetp, ps=-8, col=90
	oplot, xarr, it1.insttemp, ps=-8, col=30
	
	items = ['tablow', 'tabcen','struct', 'grating', 'instsetp', 'insttemp']
	colors = [208,40,250,0,90,30]
	al_legend, items, color=colors, psym=[-8, -8, -8, -8, -8, -8], /right

	oplot, xarr, it1.encltemp, ps=-8, col=75
	oplot, xarr, it1.enclsetp, ps=-8, col=120
	oplot, xarr, it1.encl2, ps=-8, col=90

	items = ['encltemp', 'enclsetp', 'encl2']
	colors = [75,120,90]
	al_legend, items, color=colors, psym=[-8, -8, -8], /right, /bottom

	if keyword_set(postplot) then begin
	   ps_close
	   spawn, 'convert -density 100 '+tpfn+'.eps '+tpfnp+'.png'
	   spawn, 'chmod 777 '+tpfn+'*'
	   spawn, 'chmod 777 '+tpfnp+'*'
	endif
  endif;nxit>0

  ;now the insttemp weekly plotting:
  xit = where(insttemp.insttempjd ge (datejd - 6) and $
	  insttemp.insttempjd lt datejd+1, nxit7)

  if nxit gt 0 then begin
	it1 = insttemp[xit]
	minjd = min(it1.insttempjd)
	xarr = it1.insttempjd - minjd
	
	;set the plot y-range:
	miny = 0.99* (min(it1.grating) < min(it1.tabcen) < min(it1.encltemp) < $
		min(it1.enclsetp) < min(it1.encl2) < min(it1.tablow) < $
		min(it1.struct) < min(it1.instsetp) < min(it1.insttemp))

	maxy = 1.01* (max(it1.grating) > max(it1.tabcen) > max(it1.encltemp) > $
		max(it1.enclsetp) > max(it1.encl2) > max(it1.tablow) > $
		max(it1.struct) > max(it1.instsetp) > max(it1.insttemp))

	if keyword_set(postplot) then begin
	  ;first test the temps date directory, and make it for the new year if need be:
	  tpdatedir = pdir+'tps/20'+strmid(date,0,2)
	  if ~file_test(tpdatedir, /directory) then spawn, 'mkdir '+tpdatedir
	  tpfn = pdir+'tps/20'+strmid(date, 0, 2)+'/insttempweekeps/'+date+'insttempweek'
	  tpfnp = pdir+'tps/20'+strmid(date, 0, 2)+'/insttempweekpng/'+date+'insttempweek'
	  if file_test(tpfn) then spawn, 'mv '+tpfn+' '+nextnameeps(tpfn+'_old')
	   thick, 2
	   ps_open, tpfn, /encaps, /color
	endif

	plot, xarr, it1.grating, ps=-8, $
	xtitle='JD - '+jul2cal(minjd), /ysty, yran=[miny, maxy], $
	ytitle = 'Temp [K]', /xsty
	
	oplot, xarr, it1.tablow, ps=-8, col=208
	oplot, xarr, it1.tabcen, ps=-8, col=40
	oplot, xarr, it1.struct, ps=-8, col=250
	oplot, xarr, it1.instsetp, ps=-8, col=90
	oplot, xarr, it1.insttemp, ps=-8, col=30
	
	items = ['tablow', 'tabcen','struct', 'grating', 'instsetp', 'insttemp']
	colors = [208,40,250,0,90,30]
	al_legend, items, color=colors, psym=[-8, -8, -8, -8, -8, -8], /right

	oplot, xarr, it1.encltemp, ps=-8, col=75
	oplot, xarr, it1.enclsetp, ps=-8, col=120
	oplot, xarr, it1.encl2, ps=-8, col=90

	items = ['encltemp', 'enclsetp', 'encl2']
	colors = [75,120,90]
	al_legend, items, color=colors, psym=[-8, -8, -8], /right, /bottom

	if keyword_set(postplot) then begin
	   ps_close
	   spawn, 'convert -density 100 '+tpfn+'.eps '+tpfnp+'.png'
	   spawn, 'chmod 777 '+tpfn+'*'
	   spawn, 'chmod 777 '+tpfnp+'*'
	endif
  endif;nxit7>0
endif;KW(insttemp)

;*************************************************
;LOG 2: DETTEMPS PLOTS
;*************************************************

if keyword_set(dettemps) then begin
  ;first the daily plotting:
  xdt = where(dettemps.dettempjd ge datejd and $
	  dettemps.dettempjd lt datejd+1, nxdt)

  if nxdt gt 1 then begin
	dt1 = dettemps[xdt]
	minjd = min(dt1.dettempjd)
	xarr = (dt1.dettempjd - minjd) * 24d
	
	;set the plot y-range:
	miny = min(dt1.ccdtemp) < min(dt1.ccdsetp)
	miny = miny - 0.0003*abs(miny)
	maxy = min(dt1.ccdtemp) >max(dt1.ccdsetp)
	maxy = maxy + 0.0003*abs(maxy)

	miny2 = min(dt1.necktemp) - 0.01*abs(min(dt1.necktemp))
	maxy2 = max(dt1.necktemp) + 0.01*abs(max(dt1.necktemp))

	if keyword_set(postplot) then begin
	  ;first test the temps date directory, and make it for the new year if need be:
	  tpdatedir = pdir+'tps/20'+strmid(date,0,2)
	  if ~file_test(tpdatedir, /directory) then spawn, 'mkdir '+tpdatedir
	  tpfn = pdir+'tps/20'+strmid(date, 0, 2)+'/dettempdayeps/'+date+'dettempday'
	  tpfnp = pdir+'tps/20'+strmid(date, 0, 2)+'/dettempdaypng/'+date+'dettempday'
	  if file_test(tpfn) then spawn, 'mv '+tpfn+' '+nextnameeps(tpfn+'_old')
	   thick, 2
	   ps_open, tpfn, /encaps, /color
	endif;postplot

	!x.margin=[12,10]
	plot, xarr, dt1.ccdtemp, $
	xtitle='Hours after '+jul2cal(minjd)+ ' UT', $
	ytitle='CCD Temp [K]', ysty=8, yrange=[miny, maxy], $
	ps=-8, /nodata

	oplot, xarr, dt1.ccdsetp, ps=-8, col=208
	oplot, xarr, dt1.ccdtemp, ps=-8, col=70
	
	plot, xarr, dt1.necktemp, ps=-8, $
	ysty=4, /noerase, $
	/xsty, xrange=!x.crange, yrange=[miny2,maxy2]
	
	axis, yaxis=1, ytitle = 'Neck Temp [K]', yrange=!y.crange

	items = ['CCDTEMP', 'CCDSETP', 'NECKTEMP']
	colors = [70,208,0]
	al_legend, items, color=colors, psym=[-8,-8,-8], /right, /bottom
	
	if keyword_set(postplot) then begin
	   ps_close
	   spawn, 'convert -density 100 '+tpfn+'.eps '+tpfnp+'.png'
	   spawn, 'chmod 777 '+tpfn+'*'
	   spawn, 'chmod 777 '+tpfnp+'*'
	endif
  endif;nxdt>0

  ;now the weekly plotting:
  xdt7 = where(dettemps.dettempjd ge datejd -6 and $
	  dettemps.dettempjd lt datejd+1, nxdt7)

  if nxdt7 gt 1 then begin
	dt7 = dettemps[xdt7]
	minjd = min(dt7.dettempjd)
	xarr = dt7.dettempjd - minjd
	
	;set the plot y-range:
	miny = min(dt7.ccdtemp) < min(dt7.ccdsetp)
	miny = miny - 0.0004*abs(miny)
	maxy = min(dt7.ccdtemp) >max(dt7.ccdsetp)
	maxy = maxy + 0.0004*abs(maxy)

	miny2 = min(dt7.necktemp) - 0.01*abs(min(dt7.necktemp))
	maxy2 = max(dt7.necktemp) + 0.01*abs(max(dt7.necktemp))

	if keyword_set(postplot) then begin
	  ;first test the temps date directory, and make it for the new year if need be:
	  tpdatedir = pdir+'tps/20'+strmid(date,0,2)
	  if ~file_test(tpdatedir, /directory) then spawn, 'mkdir '+tpdatedir
	  tpfn = pdir+'tps/20'+strmid(date, 0, 2)+'/dettempweekeps/'+date+'dettempweek'
	  tpfnp = pdir+'tps/20'+strmid(date, 0, 2)+'/dettempweekpng/'+date+'dettempweek'
	  if file_test(tpfn) then spawn, 'mv '+tpfn+' '+nextnameeps(tpfn+'_old')
	   thick, 2
	   ps_open, tpfn, /encaps, /color
	endif;postplot

	!x.margin=[12,10]
	plot, xarr, dt7.ccdtemp, $
	xtitle='JD - '+jul2cal(minjd), /xsty, $
	ytitle='CCD Temp [K]', ysty=8, yrange=[miny, maxy], $
	ps=-8, /nodata

	oplot, xarr, dt7.ccdsetp, ps=-8, col=208
	oplot, xarr, dt7.ccdtemp, ps=-8, col=70
	
	plot, xarr, dt7.necktemp, ps=-8, $
	ysty=4, /noerase, $
	/xsty, xrange=!x.crange, yrange=[miny2,maxy2]
	
	axis, yaxis=1, ytitle = 'Neck Temp [K]', yrange=!y.crange

	items = ['CCDTEMP', 'CCDSETP', 'NECKTEMP']
	colors = [70,208,0]
	al_legend, items, color=colors, psym=[-8,-8,-8], /right, /bottom
	
	if keyword_set(postplot) then begin
	   ps_close
	   spawn, 'convert -density 100 '+tpfn+'.eps '+tpfnp+'.png'
	   spawn, 'chmod 777 '+tpfn+'*'
	   spawn, 'chmod 777 '+tpfnp+'*'
	endif
  endif;nxdt>0

endif;KW(dettemp)

;*************************************************
;LOG 3: CHIPRESS PLOTS
;*************************************************

if keyword_set(chipress) then begin
  ;first the daily plotting:
  xcp = where(chipress.chipressjd ge datejd and $
	  chipress.chipressjd lt datejd+1, nxcp)

  if nxcp gt 1 then begin
	cp1 = chipress[xcp]
	minjd = min(cp1.chipressjd)
	xarr = (cp1.chipressjd - minjd) * 24d
	
	;set the plot y-range:
	miny = min(cp1.barometer) - 0.0003*abs(min(cp1.barometer))
	maxy = max(cp1.barometer) + 0.0003*abs(max(cp1.barometer))

	miny2 = min(cp1.echpress) - 0.0003*abs(min(cp1.echpress))
	maxy2 = max(cp1.echpress) + 0.0003*abs(max(cp1.echpress))

	if keyword_set(postplot) then begin
	  ;first test the temps date directory, and make it for the new year if need be:
	  tpdatedir = pdir+'tps/20'+strmid(date,0,2)
	  if ~file_test(tpdatedir, /directory) then spawn, 'mkdir '+tpdatedir
	  tpfn = pdir+'tps/20'+strmid(date, 0, 2)+'/chipressdayeps/'+date+'chipressday'
	  tpfnp = pdir+'tps/20'+strmid(date, 0, 2)+'/chipressdaypng/'+date+'chipressday'
	  if file_test(tpfn) then spawn, 'mv '+tpfn+' '+nextnameeps(tpfn+'_old')
	   thick, 2
	   ps_open, tpfn, /encaps, /color
	endif;postplot

	!x.margin=[12,10]
	plot, xarr, cp1.barometer, $
	xtitle='Hours after '+jul2cal(minjd)+ ' UT', xrange=!x.crange, $
	ytitle='CHIRON Pressure [mbar]', ysty=8, yrange=[miny, maxy], $
	ps=-8, /nodata

	oplot, xarr, cp1.barometer, ps=-8, col=208
	
	plot, xarr, cp1.echpress, ps=-8, $
	ysty=4, /noerase, $
	/xsty, xrange=!x.crange, yrange=[miny2,maxy2]
	
	axis, yaxis=1, ytitle = 'Grating Pressure [mbar]', yrange=!y.crange

	if keyword_set(postplot) then begin
	   ps_close
	   spawn, 'convert -density 100 '+tpfn+'.eps '+tpfnp+'.png'
	   spawn, 'chmod 777 '+tpfn+'*'
	   spawn, 'chmod 777 '+tpfnp+'*'
	endif
  endif;nxcp>0
  
  ;now the weekly plotting:
  xcp = where(chipress.chipressjd ge datejd-6 and $
	  chipress.chipressjd lt datejd+1, nxcp7)

  if nxcp7 gt 1 then begin
	cp7 = chipress[xcp]
	minjd = min(cp7.chipressjd)
	xarr = cp7.chipressjd - minjd
	
	;set the plot y-range:
	miny = min(cp7.barometer) - 0.002*abs(min(cp7.barometer))
	maxy = max(cp7.barometer) + 0.002*abs(max(cp7.barometer))

	miny2 = min(cp7.echpress) - 0.01*abs(min(cp7.echpress))
	maxy2 = max(cp7.echpress) + 0.01*abs(max(cp7.echpress))

	if keyword_set(postplot) then begin
	  ;first test the temps date directory, and make it for the new year if need be:
	  tpdatedir = pdir+'tps/20'+strmid(date,0,2)
	  if ~file_test(tpdatedir, /directory) then spawn, 'mkdir '+tpdatedir
	  tpfn = pdir+'tps/20'+strmid(date, 0, 2)+'/chipressweekeps/'+date+'chipressweek'
	  tpfnp = pdir+'tps/20'+strmid(date, 0, 2)+'/chipressweekpng/'+date+'chipressweek'
	  if file_test(tpfn) then spawn, 'mv '+tpfn+' '+nextnameeps(tpfn+'_old')
	   thick, 2
	   ps_open, tpfn, /encaps, /color
	endif;postplot

	!x.margin=[12,10]
	plot, xarr, cp7.barometer, $
	xtitle='JD - '+jul2cal(minjd), $
	ytitle='CHIRON Pressure [mbar]', ysty=8, yrange=[miny, maxy], $
	ps=-8, /nodata, /xsty

	oplot, xarr, cp7.barometer, ps=-8, col=208
	
	plot, xarr, cp7.echpress, ps=-8, $
	ysty=4, /noerase, $
	/xsty, xrange=!x.crange, yrange=[miny2,maxy2]
	
	axis, yaxis=1, ytitle = 'Grating Pressure [mbar]', yrange=!y.crange

	if keyword_set(postplot) then begin
	   ps_close
	   spawn, 'convert -density 100 '+tpfn+'.eps '+tpfnp+'.png'
	   spawn, 'chmod 777 '+tpfn+'*'
	   spawn, 'chmod 777 '+tpfnp+'*'
	endif
  endif;nxcp7>0
endif;KW(chipress)

end;chi_qc_plot_temps.pro