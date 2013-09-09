;+
;
;  NAME: 
;     chi_quality
;
;  PURPOSE: To make a page for a quality check on the CHIRON data.
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      chi_quality
;
;  INPUTS:
;		DATE: The date to run the quality control on, in yymmdd format
;
;  OUTPUTS: none
;
;  OPTIONAL KEYWORD PARAMETERS:
;		SKIPLOG: Set this to NOT generate the log structure
;
;		SKIPPLOTS: Set this to NOT create the QC plots
;
;		dodopqc: Run the update_qc_index2 code, which makes 
;			the Doppler QC page, but takes WAY longer.
;    
;  EXAMPLE:
;      chi_quality, date='121117'
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2012.03.10 09:56:25 AM
;
;-
pro chi_quality, $
date = date, $
dodopqc = dodopqc, $
skiplog=skiplog, $
skipplots=skipplots

loadct, 39, /silent
usersymbol, 'circle', /fill, size_of_sym = 0.5
!p.multi=[0,1,1]

;restore CHIRON temperature and pressure structures:
restore, '/home/matt/data/CHIRPS/tps/insttemp.sav'
restore, '/home/matt/data/CHIRPS/tps/chipress.sav'
restore, '/home/matt/data/CHIRPS/tps/dettemps.sav'

;number of quartz exposures to check for:
nqtzbon = 10
nqtzeon = 10
ntharbon = 1
nthareon = 1
ni2bon = 1
ni2eon = 1
nbias11bon = 9
nbias11eon = 9
nbias31bon = 9
nbias31eon = 9
nbias44bon = 9
nbias44eon = 9

;bias and readnoise thresholds:
normrn31thres = 8d ;normal readnoise 3x1 threshold
normmedos31thres = 1150d ;normal median overscan 3x1 threshold
normmedbias31thres = 1150d ;normal median overscan 3x1 threshold
normrn11thres = 7d ;normal readnoise 1x1 threshold
normmedos11thres = 1150d ;normal median overscan 1x1 threshold
normmedbias11thres = 1150d ;normal median overscan 1x1 threshold

;envinonmental parameters:
if date gt 130301 then begin
  ;1. INSTTEMP LOG:
  gratingtempmax = 24d
  gratingtempmin = 22d
  tabcentempmin = 22d
  tabcentempmax = 24d
  encltempmin = 19.5d
  encltempmax = 23d
  enclsetpmin = 22d
  enclsetpmax = 22d
  encl2tempmin = 19d
  encl2tempmax = 23d
  iodtempmin = 39.8d
  iodtempmax = 40.2d
  iodspmin = 40d
  iodspmax = 40d
  tablowmin = 22d
  tablowmax = 24d
  structtempmin = 22d
  structtempmax = 24d
  instsetpmin = 23d
  instsetpmax = 23d
  insttempmin = 22.0d
  insttempmax = 23.1d
  ;2. DETTEMPS LOG:
  ccdtempmin = -129d
  ccdtempmax = -127
  ccdsetpmin = -128d
  ccdsetpmax = -128d
  necktempmin = -200d
  necktempmax = -150d
  ;3. CHIPRESS LOG:
  barpressmin = 770d
  barpressmax = 790d
  echelleenclmin = 0.1d
  echelleenclmax = 6d
endif;date=after Andrei turned up the temp.

if date lt 130301 then begin
  ;1. INSTTEMP LOG:
  gratingtempmax = 21.5d
  gratingtempmin = 21.2
  tabcentempmax = 21.7
  tabcentempmin = 21.5
  encltempmin = 19.9
  encltempmax = 20.5
  enclsetpmin = 20d
  enclsetpmax = 20d
  encl2tempmin = 19.5d
  encl2tempmax = 20.3d
  iodtempmin = 39.7d
  iodtempmax = 40.3d
  iodspmin = 40d
  iodspmax = 40d
  tablowmin = 21.49d
  tablowmax = 21.7d
  structtempmin = 21.2d
  structtempmax = 21.5d
  instsetpmin = 21d
  instsetpmax = 21d
  insttempmin = 20.9d
  insttempmax = 21.1d
  ;2. DETTEMPS LOG:
  ccdtempmin = -129d
  ccdtempmax = -127
  ccdsetpmin = -128d
  ccdsetpmax = -128d
  necktempmin = -153d
  necktempmax = -150d
  ;3. CHIPRESS LOG:
  barpressmin = 770d
  barpressmax = 790d
  echelleenclmin = 0.1d
  echelleenclmax = 3d
endif;date=before Andrei turned up the temp.

qdir = '/home/matt/Sites/chi/'
year = '20'+strmid(date,0,2)
greencol = '<td bgcolor =#5CEC21 align=center>'
redcol = '<td bgcolor =#EC020B align=center>'
if keyword_set(skiplog) then begin
lfn = '/mir7/logstructs/'+year+'/'+date+'log.dat'
spawn, 'hostname', host
if strmid(host, 13,14, /reverse) eq 'astro.yale.edu' then lfn = '/tous'+lfn
restore, lfn
endif else begin
log = chi_log(date=date)
chi_count_check, log
chi_create_tp_log, date=date
endelse

if ~keyword_set(skipplots) then begin
   ;CREATE THE DAILY AND WEEKLY ENVIRONMENTAL PLOTS:
   !p.multi=[0,1,1]
   chi_qc_plot_temps, $
   insttemp = insttemp, dettemps = dettemps, chipress = chipress, $
   date = date, dir = qdir, /postplot

   chi_med_bias, log, postplot=~keyword_set(skipplots), /normal, /bin31, dir = qdir
   chi_med_bias, log, postplot=~keyword_set(skipplots), /fast, /bin31, dir = qdir
   chi_med_bias, log, postplot=~keyword_set(skipplots), /normal, /bin11, dir = qdir
   chi_med_bias, log, postplot=~keyword_set(skipplots), /fast, /bin11, dir = qdir
   !p.multi=[0,1,1]
   chi_plot_counts, log, postplot=~keyword_set(skipplots), dir = qdir
   chi_thar_log, log, postplot=~keyword_set(skipplots), dir = qdir
   chi_plot_thar, postplot=~keyword_set(skipplots), dir = qdir, date = date
   if file_test('/tous/mir7/logs/guider/guider'+date+'.log') then begin
   guidrms = chi_guider_plot(log, postplot=~keyword_set(skipplots), dir = qdir)
   endif
   dum = where(strt(log.object) eq '128620', acenact)
   if acenact then chi_acen_eff, log, postplot=~keyword_set(skipplots), objname='128620', dir = qdir
   dum = where(strt(log.object) eq '128621', acenbct)
   if acenbct then chi_acen_eff, log, postplot=~keyword_set(skipplots), objname='128621', dir = qdir
   chi_acena_log, log, postplot=~keyword_set(skipplots), dir = qdir
   chi_acenb_log, log, postplot=~keyword_set(skipplots), dir = qdir
   chi_tauceti_log, log, postplot=~keyword_set(skipplots), dir = qdir
endif;skipplots
chi_check_reduction, log=log, $
  /iodspec, iodres = iodres, $
  /fitspec, fitsres=fitsres, $
  /getthid, thidres=thidres, $
  /wavcheck, wavres=wavres

spawn, 'chmod -R 777 '+qdir+'plots/'
;************************************************************************
PRINT, '*****************************************************************'
PRINT, 'NOW PRINTING TO HTML'
PRINT, '*****************************************************************'
;************************************************************************
qfile = qdir+date+'quality.html'
spawn, 'hostname', host
;if strmid(host, 13,14, /reverse) eq 'astro.yale.edu' then qfile = '/tous'+qfile
openw, 2, qfile
printf, 2, '<html>'
printf, 2, '<head>'
printf, 2, '<title>Logsheet for '+date+'</title>'
printf, 2, '</head>'
printf, 2, '<body>'
printf, 2, '<center>'

printf, 2, '<h3>Logsheet for '+date+' </h3>'
printf, 2, '<br>'
;************************************************************************
;PRELIMINARY INFO
;************************************************************************
printf, 2, 'APO Position (mm): ', log[0].focus
printf, 2, '<br>'
narthar = where(strt(log.object) eq 'ThAr' and strt(log.decker) eq 'narrow_slit' and $
                strt(log.speedmod) eq 'normal' and strt(log.ccdsum) eq '3 1', nartharct)
if nartharct then begin

i=0
repeat begin
   tharfn = '/tous/mir7/thid/thidfile/a'+$
			log[narthar[i]].prefix+'.'+$
			log[narthar[i]].seqnum+'.thid'
   if file_test(tharfn) then begin
	  restore, tharfn
	  nlines = strt(n_elements(thid.fwhm))
	  medfwhm = strt(median(thid.fwhm), f='(F7.2)')
	  printf, 2, strt(log[narthar[i]].decker),' mode median FWHM (px) of ',nlines,' lines: ', medfwhm
      printf, 2, '<br>'
	  printf, 2, 'Corresponding Resolution: ', strt(thid.resol, f='(F10.0)')
      printf, 2, '<br>'
   endif
   i++
endrep until (i ge nartharct OR file_test(tharfn))

if file_test('/batman') then begin 
  print, 'batman exists'
  foc, inpfile=log[narthar[0]].filename, slicevals=slicevals;, /plt, /mark
  focfwhm = strt(slicevals.avgfwhm, f='(F7.3)')
  ;printf, 2, 'Narrow FWHM (px): ', focfwhm
endif;batman
printf, 2, '<br>'
endif ;else printf, 2, 'Narrow FWHM (px): ---'

;************************************************************************
;OBSERVATION TIME SUMMARY TABLE
;************************************************************************
suntimes, observatory='ctio', date=date, resolution=0.25, stimes=stimes
printf, 2, 'Observing Time Report: <br>'
printf, 2, '<table border ="+1">'
printf, 2, '<tr>'
printf, 2, '<th align=center>'
printf, 2, 'Parameter'
printf, 2, '</th>'
printf, 2, '<th align=center>'
printf, 2, 'Value'
printf, 2, '</th>'
printf, 2, '<th align=center>'
printf, 2, 'Parameter'
printf, 2, '</th>'
printf, 2, '<th align=center>'
printf, 2, 'Value'
printf, 2, '</th>'
printf, 2, '<th align=center>'
printf, 2, 'Parameter'
printf, 2, '</th>'
printf, 2, '<th align=center>'
printf, 2, 'Value'
printf, 2, '</th>'
printf, 2, '</tr>'

;SUNRISE/SUNSET:
printf, 2, '<tr>'
printf, 2, '<td>'
printf, 2, 'Sunset UTC'
printf, 2, '</td>'
printf, 2, '<td>'
printf, 2, jul2cal(stimes.sunset)
printf, 2, '</td>'
printf, 2, '<td>'
printf, 2, 'Sunrise UTC'
printf, 2, '</td>'
printf, 2, '<td>'
printf, 2, jul2cal(stimes.sunrise)
printf, 2, '</td>'
printf, 2, '<td>'
printf, 2, 'Total Hours'
printf, 2, '</td>'
printf, 2, '<td>'
srhours = floor((stimes.sunrise-stimes.sunset)*24d)
srmins = floor((stimes.sunrise-stimes.sunset - srhours/24d)*24d*60d)
printf, 2, strt(srhours)+'h '+strt(srmins)+'m'
printf, 2, '</td>'
printf, 2, '</tr>'

;NAUTICAL TIMES:
printf, 2, '<tr>'
printf, 2, '<td>'
printf, 2, '12<sup>o</sup> Dusk UTC'
printf, 2, '</td>'
printf, 2, '<td>'
printf, 2, jul2cal(stimes.nautset)
printf, 2, '</td>'
printf, 2, '<td>'
printf, 2, '12<sup>o</sup> Dawn UTC'
printf, 2, '</td>'
printf, 2, '<td>'
printf, 2, jul2cal(stimes.nautris)
printf, 2, '</td>'
printf, 2, '<td>'
printf, 2, 'Total Hours'
printf, 2, '</td>'
printf, 2, '<td>'
nrhours = floor((stimes.nautris-stimes.nautset)*24d)
nrmins = floor((stimes.nautris-stimes.nautset - nrhours/24d)*24d*60d)
printf, 2, strt(nrhours)+'h '+strt(nrmins)+'m'
printf, 2, '</td>'
printf, 2, '</tr>'

;ASTRONOMICAL TIMES:
printf, 2, '<tr>'
printf, 2, '<td>'
printf, 2, '18<sup>o</sup> Dusk UTC'
printf, 2, '</td>'
printf, 2, '<td>'
printf, 2, jul2cal(stimes.astrset)
printf, 2, '</td>'
printf, 2, '<td>'
printf, 2, '18<sup>o</sup> Dawn UTC'
printf, 2, '</td>'
printf, 2, '<td>'
printf, 2, jul2cal(stimes.astrris)
printf, 2, '</td>'
printf, 2, '<td>'
printf, 2, 'Total Hours'
printf, 2, '</td>'
printf, 2, '<td>'
arhours = floor((stimes.astrris-stimes.astrset)*24d)
armins = floor((stimes.astrris-stimes.astrset - arhours/24d)*24d*60d)
printf, 2, strt(arhours)+'h '+strt(armins)+'m'
printf, 2, '</td>'
printf, 2, '</tr>'

;OBSERVING TIMES:
ASTOBS = where(strt(strlowcase(log.object)) ne 'thar' and $
strt(log.object) ne 'bias' and $
strt(strlowcase(log.object)) ne 'iodine' and $
strt(log.object) ne 'quartz' and $
strt(log.object) ne 'junk' and $
strt(log.object) ne 'dark' and $
strt(log.complamp) eq 'none', astobsct)
printf, 2, '<tr>'
printf, 2, '<td>'
printf, 2, '1st OBS Start UTC'
printf, 2, '</td>'
obssttm = log[astobs[0]].emtimopn
if strmid(strt(obssttm), 0, 4) eq '0000' or strmid(strt(obssttm), 0, 1) eq '0' then begin
obssttm = log[astobs[0]].dateobs
printf, 2, redcol
endif else printf, 2, '<td>'
obssttmjd = julday( $
strmid(obssttm, 5, 2), $ ;month
strmid(obssttm, 8, 2), $ ;day
strmid(obssttm, 0, 4), $ ;year
strmid(obssttm, 11, 2), $ ;hour
strmid(obssttm, 14, 2), $ ;minute
strmid(obssttm, 17, 2));second
print, 'the observing start time was: ', jul2cal(obssttmjd)
printf, 2, jul2cal(obssttmjd)
printf, 2, '</td>'
printf, 2, '<td>'
printf, 2, 'LAST OBS End UTC'
printf, 2, '</td>'
obsendtm = log[astobs[-1]].emtimcls
if strmid(strt(obsendtm), 0, 4) eq '0000' or strmid(strt(obsendtm), 0, 1) eq '0' then begin
obsendtm = log[astobs[-1]].dateobs
printf, 2, redcol
endif else printf, 2, '<td>'
obsendtmjd = julday( $
strmid(obsendtm, 5, 2), $ ;month
strmid(obsendtm, 8, 2), $ ;day
strmid(obsendtm, 0, 4), $ ;year
strmid(obsendtm, 11, 2), $ ;hour
strmid(obsendtm, 14, 2), $ ;minute
strmid(obsendtm, 17, 2));second
print, 'the observing end time was: ', jul2cal(obsendtmjd)
printf, 2, jul2cal(obsendtmjd)
printf, 2, '</td>'
printf, 2, '<td>'
printf, 2, 'Total Hours'
printf, 2, '</td>'
printf, 2, '<td>'

obshours = floor((obsendtmjd-obssttmjd)*24d)
obsmins = floor((obsendtmjd-obssttmjd - obshours/24d)*24d*60d)
printf, 2, strt(obshours)+'h '+strt(obsmins)+'m'
printf, 2, '</td>'
printf, 2, '</tr>'

;EFFICIENCY ROW:
printf, 2, '<tr>'
printf, 2, '<td>'
printf, 2, 'Delay of Start '
printf, 2, '</td>'
printf, 2, '<td>'
;additional minutes before nautical dusk and after nautical dawn:
addmin = 12d
dshoursfull=(obssttmjd-(stimes.nautset - addmin/(60d *24d)))*24d
if dshoursfull gt 0 then dshours=floor(dshoursfull) else dshours=ceil(dshoursfull)
dsmins = round((obssttmjd-stimes.nautset - dshours/24d)*24d*60d)
printf, 2, strt(dshours)+'h '+strt(dsmins)+'m'
printf, 2, '</td>'
printf, 2, '<td>'
printf, 2, 'Early Termination '
printf, 2, '</td>'
printf, 2, '<td>'
ethoursfull = ((stimes.nautris + addmin/(24d * 60d)) - obsendtmjd)*24d
if ethoursfull gt 0 then ethours=floor(ethoursfull) else ethours=ceil(ethoursfull)
etmins = round((stimes.nautris - obsendtmjd - ethours/24d)*24d*60d)
printf, 2, strt(ethours)+'h '+strt(etmins)+'m'
printf, 2, '</td>'
printf, 2, '<td>'
printf, 2, 'Total Int '
printf, 2, '</td>'
printf, 2, '<td>'
totint = total(double(log[astobs].exptime))
tihours = floor(totint/3600)
timins = floor((totint/3600 - tihours)*60d)
printf, 2, strt(tihours)+'h '+strt(timins)+'m'
printf, 2, '</td>'
printf, 2, '</tr>'
printf, 2, '</table>'
printf, 2, '</br>'

;************************************************************************
;THID LINES AND RESOLUTION TABLE
;************************************************************************
printf, 2, 'Wavelength Calibration Info:'
printf, 2, '<table border ="+1">'
printf, 2, '<tr>'
printf, 2, '<th align=center>'
printf, 2, 'Decker'
printf, 2, '</th>'
printf, 2, '<th>'
printf, 2, '# Lines'
printf, 2, '</th>'
printf, 2, '<th>'
printf, 2, 'Resolution'
printf, 2, '</th>'
printf, 2, '</tr>'
printf, 2, ''

tfslicer = where(strt(strupcase(log.object)) eq 'THAR' and strt(log.decker) eq 'slicer' and strt(log.ccdsum) eq '3 1', tfscct)
tfnarrow = where(strt(strupcase(log.object)) eq 'THAR' and strt(log.decker) eq 'narrow_slit' and strt(log.ccdsum) eq '3 1', tfnrct)
tfslit = where(strt(strupcase(log.object)) eq 'THAR' and strt(log.decker) eq 'slit' and strt(log.ccdsum) eq '3 1', tfstct)
tffiber = where(strt(strupcase(log.object)) eq 'THAR' and strt(log.decker) eq 'fiber' and strt(log.ccdsum) eq '4 4', tffbct)
if file_test('/tous/mir7/fitspec/'+date+'/achi'+date+'.'+strt(log[tfslicer[0]].seqnum)+'.fits') then begin
;***SLICER MODE***
printf, 2, '<tr>'
printf, 2, '<td>'
printf, 2, 'Slicer '
printf, 2, '</td>'
scnlinarr = dblarr(tfscct)
scresarr = dblarr(tfscct)
for i=0, tfscct-1 do begin
    if file_test('/tous/mir7/fitspec/'+date+'/achi'+date+'.'+log[tfslicer[i]].seqnum+'.fits') then begin
	   scnlinarr[i] = double($
	   fxpar(headfits('/tous/mir7/fitspec/'+date+'/achi'+date+'.'+log[tfslicer[i]].seqnum+'.fits'), 'THIDNLIN'))
	   print, fxpar(headfits('/tous/mir7/fitspec/'+date+'/achi'+date+'.'+log[tfslicer[i]].seqnum+'.fits'), 'THIDNLIN')
	   scresarr[i] = double($
	   fxpar(headfits('/tous/mir7/fitspec/'+date+'/achi'+date+'.'+log[tfslicer[i]].seqnum+'.fits'), 'RESOLUTN'))
	endif;reduced file exists
endfor
;NUMBER OF LINES
if mean(scnlinarr) gt 1000d then printf, 2, greencol else printf, 2, redcol
printf, 2, strt(mean(scnlinarr), f='(F8.2)')
printf, 2, '</td>'
;RESOLUTION
if mean(scresarr) gt 77000d and mean(scresarr) lt 81000d then printf, 2, greencol else printf, 2, redcol
printf, 2, strt(mean(scresarr), f='(F8.2)')
printf, 2, '</td>'
printf, 2, '</tr>'
printf, 2, ''

;***NARROW MODE***
printf, 2, '<tr>'
printf, 2, '<td>'
printf, 2, 'Narrow '
printf, 2, '</td>'
nrnlinarr = dblarr(tfnrct)
nrresarr = dblarr(tfnrct)
for i=0, tfnrct-1 do begin
	if file_test('/tous/mir7/fitspec/'+date+'/achi'+date+'.'+log[tfnarrow[i]].seqnum+'.fits') then begin
	   nrnlinarr[i] = double($
	   fxpar(headfits('/tous/mir7/fitspec/'+date+'/achi'+date+'.'+log[tfnarrow[i]].seqnum+'.fits'), 'THIDNLIN'))
	   nrresarr[i] = double($
	   fxpar(headfits('/tous/mir7/fitspec/'+date+'/achi'+date+'.'+log[tfnarrow[i]].seqnum+'.fits'), 'RESOLUTN'))
	endif;fitspec file exists
endfor
;NUMBER OF LINES
if mean(nrnlinarr) gt 1000d then printf, 2, greencol else printf, 2, redcol
printf, 2, strt(mean(nrnlinarr), f='(F8.2)')
printf, 2, '</td>'
;RESOLUTION
if mean(nrresarr) gt 135000d and mean(nrresarr) lt 141000d then printf, 2, greencol else printf, 2, redcol
printf, 2, strt(mean(nrresarr), f='(F10.2)')
printf, 2, '</td>'
printf, 2, '</tr>'
printf, 2, ''

;***SLIT MODE***
printf, 2, '<tr>'
printf, 2, '<td>'
printf, 2, 'Slit '
printf, 2, '</td>'
stnlinarr = dblarr(tfstct)
stresarr = dblarr(tfstct)
for i=0, tfstct-1 do begin
	if file_test('/tous/mir7/fitspec/'+date+'/achi'+date+'.'+log[tfslit[i]].seqnum+'.fits') then begin
	   stnlinarr[i] = double(fxpar(headfits('/tous/mir7/fitspec/'+$
		   date+'/achi'+date+'.'+log[tfslit[i]].seqnum+'.fits'), 'THIDNLIN'))
	   stresarr[i] = double(fxpar(headfits('/tous/mir7/fitspec/'+$
		   date+'/achi'+date+'.'+log[tfslit[i]].seqnum+'.fits'), 'RESOLUTN'))
	endif;fitspec file exists
endfor
;NUMBER OF LINES
if mean(stnlinarr) gt 1000d then printf, 2, greencol else printf, 2, redcol
printf, 2, strt(mean(stnlinarr), f='(F8.2)')
printf, 2, '</td>'
;RESOLUTION
if mean(stresarr) gt 94000d and mean(stresarr) lt 100000d then printf, 2, greencol else printf, 2, redcol
printf, 2, strt(mean(stresarr), f='(F8.2)')
printf, 2, '</td>'
printf, 2, '</tr>'
printf, 2, ''

;***FIBER MODE***
printf, 2, '<tr>'
printf, 2, '<td>'
printf, 2, 'Fiber '
printf, 2, '</td>'
fbnlinarr = dblarr(tffbct)
fbresarr = dblarr(tffbct)
for i=0, tffbct-1 do begin
	if file_test('/tous/mir7/fitspec/'+date+'/achi'+date+'.'+log[tffiber[i]].seqnum+'.fits') then begin
	fbnlinarr[i] = double(fxpar(headfits('/tous/mir7/fitspec/'+$
		date+'/achi'+date+'.'+log[tffiber[i]].seqnum+'.fits'), 'THIDNLIN'))
	fbresarr[i] = double(fxpar(headfits('/tous/mir7/fitspec/'+$
		date+'/achi'+date+'.'+log[tffiber[i]].seqnum+'.fits'), 'RESOLUTN'))
	endif;fitspec file exists
endfor
;NUMBER OF LINES
if mean(fbnlinarr) gt 700d then printf, 2, greencol else printf, 2, redcol
printf, 2, strt(mean(fbnlinarr), f='(F8.2)')
printf, 2, '</td>'
;RESOLUTION
if mean(fbresarr) gt 26000d and mean(fbresarr) lt 30000d then printf, 2, greencol else printf, 2, redcol
printf, 2, strt(mean(fbresarr), f='(F8.2)')
printf, 2, '</td>'
printf, 2, '</tr>'
printf, 2, ''
printf, 2, ''

printf, 2, '</table>'
printf, 2, '</br>'

endif;reduced files exist

;************************************************************************
;BIAS TABLE
;************************************************************************
printf, 2, 'Bias Offset and Readnoise:'
printf, 2, '<br>'
printf, 2, '<table border ="+1">'
printf, 2, '<tr>'
printf, 2, '<th align=center>'
printf, 2, 'Binning'
printf, 2, '</th>'
printf, 2, '<th align=center>'
printf, 2, 'Read Speed'
printf, 2, '</th>'
printf, 2, '<th align=center>'
printf, 2, 'Parameter'
printf, 2, '</th>'
printf, 2, '<th>'
printf, 2, 'Q11'
printf, 2, '</th>'
printf, 2, '<th>'
printf, 2, 'Q12'
printf, 2, '</th>'
printf, 2, '<th>'
printf, 2, 'Q21'
printf, 2, '</th>'
printf, 2, '<th>'
printf, 2, 'Q22'
printf, 2, '</th>'
printf, 2, '</tr>'
printf, 2, ''

;3x1 normal readnoise (rms e-)
n31rn = where(strt(log.ccdsum) eq '3 1' and strt(log.speedmod) eq 'normal')
printf, 2, '<tr>'
printf, 2, '<td>'
printf, 2, '3x1'
printf, 2, '</td>'
printf, 2, '<td>'
printf, 2, 'normal'
printf, 2, '</td>'
printf, 2, '<td>'
printf, 2, 'readnoise (rms e-)'
printf, 2, '</td>'
for i=0, 3 do begin
  rni = log[n31rn[0]].readnoise[i]
  if rni gt normrn31thres then printf, 2, redcol else printf, 2, greencol
  printf, 2, strt(rni, f='(F10.2)')
  printf, 2, '</td>'
endfor
printf, 2, '<br>'

;3x1 normal median overscan (ADU)
printf, 2, '<tr>'
printf, 2, '<td>'
printf, 2, '3x1'
printf, 2, '</td>'
printf, 2, '<td>'
printf, 2, 'normal'
printf, 2, '</td>'
printf, 2, '<td>'
printf, 2, 'median overscan (ADU)'
printf, 2, '</td>'
for i=0, 3 do begin
  moi = log[n31rn[0]].medoverscan[i]
  if moi gt normmedos31thres then printf, 2, redcol else printf, 2, greencol
  printf, 2, strt(moi, f='(F10.0)')
  printf, 2, '</td>'
endfor
printf, 2, '<br>'

;3x1 normal median bias (ADU)
printf, 2, '<tr>'
printf, 2, '<td>'
printf, 2, '3x1'
printf, 2, '</td>'
printf, 2, '<td>'
printf, 2, 'normal'
printf, 2, '</td>'
printf, 2, '<td>'
printf, 2, 'median bias (ADU)'
printf, 2, '</td>'
for i=0, 3 do begin
  mbi = log[n31rn[0]].medbias[i]
  if mbi gt normmedbias31thres then printf, 2, redcol else printf, 2, greencol
  printf, 2, strt(mbi, f='(F10.0)')
  printf, 2, '</td>'
endfor
printf, 2, '<br>'

;****************************
; 1 x 1
;****************************
n11rn = where(strt(log.ccdsum) eq '1 1' and strt(log.speedmod) eq 'normal', n11rnct)
if n11rnct gt 0 then begin
  ;1x1 normal readnoise (rms e-)
  printf, 2, '<tr>'
  printf, 2, '<td>'
  printf, 2, '1x1'
  printf, 2, '</td>'
  printf, 2, '<td>'
  printf, 2, 'normal'
  printf, 2, '</td>'
  printf, 2, '<td>'
  printf, 2, 'readnoise (rms e-)'
  printf, 2, '</td>'
  for i=0, 3 do begin
	rni = log[n11rn[0]].readnoise[i]
	if rni gt normrn11thres then printf, 2, redcol else printf, 2, greencol
	printf, 2, strt(rni, f='(F10.2)')
	printf, 2, '</td>'
  endfor
  printf, 2, '<br>'

  ;1x1 normal median overscan (ADU)
  printf, 2, '<tr>'
  printf, 2, '<td>'
  printf, 2, '1x1'
  printf, 2, '</td>'
  printf, 2, '<td>'
  printf, 2, 'normal'
  printf, 2, '</td>'
  printf, 2, '<td>'
  printf, 2, 'median overscan (ADU)'
  printf, 2, '</td>'
  for i=0, 3 do begin
	moi = log[n11rn[0]].medoverscan[i]
	if moi gt normmedos11thres then printf, 2, redcol else printf, 2, greencol
	printf, 2, strt(moi, f='(F10.0)')
	printf, 2, '</td>'
  endfor
  printf, 2, '<br>'
  
  ;1x1 normal median bias (ADU)
  printf, 2, '<tr>'
  printf, 2, '<td>'
  printf, 2, '1x1'
  printf, 2, '</td>'
  printf, 2, '<td>'
  printf, 2, 'normal'
  printf, 2, '</td>'
  printf, 2, '<td>'
  printf, 2, 'median bias (ADU)'
  printf, 2, '</td>'
  for i=0, 3 do begin
	mbi = log[n11rn[0]].medbias[i]
	if mbi gt normmedbias11thres then printf, 2, redcol else printf, 2, greencol
	printf, 2, strt(mbi, f='(F10.0)')
	printf, 2, '</td>'
  endfor
  printf, 2, '<br>'
endif
printf, 2, '</table>'
printf, 2, '<br>'

;************************************************************************
;CREATING THE STATUS TABLE
;************************************************************************
printf, 2, 'Guider and Missing Info:'
printf, 2, '<table border ="+1">'
printf, 2, '<tr>'
printf, 2, '<th align=center>'
printf, 2, 'Parameter'
printf, 2, '</th>'
printf, 2, '<th>'
printf, 2, 'Value'
printf, 2, '</th>'
printf, 2, '</tr>'
printf, 2, ''

if size(guidrms, /type) then begin
;GUIDER RIGHT ASCENSION
printf, 2, '<tr>'
printf, 2, '<td>'
printf, 2, 'Guider RA rms: '
printf, 2, '</td>'
if guidrms[0] lt 2.5d then begin			   
printf, 2, '<td bgcolor =#5CEC21 align=center>'
endif else printf, 2, '<td bgcolor =#EC020B align=center>'
printf, 2, strt(guidrms[0], f='(F8.2)')
printf, 2, '</td>'
printf, 2, '</tr>'
printf, 2, ''

;GUIDER DECLINATION
printf, 2, '<tr>'
printf, 2, '<td>'
printf, 2, 'Guider dec rms: '
printf, 2, '</td>'
if guidrms[1] lt 3d then begin			   
printf, 2, '<td bgcolor =#5CEC21 align=center>'
endif else printf, 2, '<td bgcolor =#EC020B align=center>'
printf, 2, strt(guidrms[1], f='(F8.2)')
printf, 2, '</td>'
printf, 2, '</tr>'
printf, 2, ''

;LAG RIGHT ASCENSION
printf, 2, '<tr>'
printf, 2, '<td>'
printf, 2, 'Mean RA Lag: '
printf, 2, '</td>'
if guidrms[2] le 0.6d then begin			   
printf, 2, '<td bgcolor =#5CEC21 align=center>'
endif else printf, 2, '<td bgcolor =#EC020B align=center>'
printf, 2, strt(guidrms[2], f='(F8.2)')
printf, 2, '</td>'
printf, 2, '</tr>'
printf, 2, ''

;LAG DECLINATION
printf, 2, '<tr>'
printf, 2, '<td>'
printf, 2, 'Mean dec lag: '
printf, 2, '</td>'
if guidrms[3] le 0.6d then begin			   
  printf, 2, '<td bgcolor =#5CEC21 align=center>'
endif else printf, 2, '<td bgcolor =#EC020B align=center>'
printf, 2, strt(guidrms[3], f='(F8.2)')
printf, 2, '</td>'
printf, 2, '</tr>'
printf, 2, ''
endif;guider data exist

;EARLY TERMINATION
;FIRST FIND ALL THE SCIENCE EXPOSURES:
scs = where(strt(log.propid) ne 'Calib' and $
  strt(log.propid) ne 'Calib11' and $
  strt(log.object) ne 'junk', nscs)
;EARLY TERMINATION COMPARISON; FIND ALL VALUES THAT ARE LESS THAN
;1% OF THE THRESHOLD (THESE ARE THE GOOD VALUES)  
etcomp = double(log.emavg)*double(log.emnumsmp) lt 1.01 * double(log.thres)
;MAKE A SLIGHT EXCEPTION (< 2%) FOR SHORT EXPOSURES:
x = where(double(log.exptime) lt 15d)
etcomp[x] = double(log[x].emavg)*double(log[x].emnumsmp) lt 1.02 * double(log[x].thres)
;MAKE ANOTHER EXCEPTION FOR REALLY SHORT EXPOSURES:
x = where(double(log.exptime) lt 5d)
etcomp[x] = double(log[x].emavg)*double(log[x].emnumsmp) lt 1.05 * double(log[x].thres)
;IGNORE OBSERVATIONS WHERE THE EM THRESHOLD WASN'T SET
x = where(double(log.thres) le 0)
etcomp[x] = 1
;NOT A GREAT NAME, BUT WHERE GOOD = 0 
etgood = where(etcomp[scs] eq 0, etgoodct)

printf, 2, '<tr>'
printf, 2, '<td>'
printf, 2, 'Non ETs: '
printf, 2, '</td>'
if etgoodct eq 0 then begin			   
printf, 2, '<td bgcolor =#5CEC21 align=center>'
endif else printf, 2, '<td bgcolor =#EC020B align=center>'
printf, 2, strt(etgoodct)
printf, 2, '</td>'
printf, 2, '</tr>'
printf, 2, ''

;BAD EM FITS HEADERS
noemfh = where(log.emnumsmp eq 0 and $
strt(log.object) ne 'bias' and $
strt(log.object) ne 'junk', noemfhct)
;set the etcomp flag to zero for these so that the EM CTS column
;is highlighted as red for these exposures:
etcomp[noemfh] = 0
printf, 2, '<tr>'
printf, 2, '<td>'
printf, 2, 'No EM FITS: '
printf, 2, '</td>'
if noemfhct eq 0 then begin			   
printf, 2, '<td bgcolor =#5CEC21 align=center>'
endif else printf, 2, '<td bgcolor =#EC020B align=center>'
printf, 2, strt(noemfhct)
printf, 2, '</td>'
printf, 2, '</tr>'
printf, 2, ''

;NO DECKER IN HEADER
nodeck = where(strt(log.decker) eq '0', nodeckct)
printf, 2, '<tr>'
printf, 2, '<td>'
printf, 2, 'No DECKER: '
printf, 2, '</td>'
if nodeckct eq 0 then begin			   
printf, 2, '<td bgcolor =#5CEC21 align=center>'
endif else printf, 2, '<td bgcolor =#EC020B align=center>'
printf, 2, strt(nodeckct)
printf, 2, '</td>'
printf, 2, '</tr>'
printf, 2, ''

;NO I2 IN HEADER
noi2 = where(strt(log.iodcell) eq '0', noi2ct)
printf, 2, '<tr>'
printf, 2, '<td>'
printf, 2, 'No I2: '
printf, 2, '</td>'
if noi2ct eq 0 then begin			   
printf, 2, '<td bgcolor =#5CEC21 align=center>'
endif else printf, 2, '<td bgcolor =#EC020B align=center>'
printf, 2, strt(noi2ct)
printf, 2, '</td>'
printf, 2, '</tr>'
printf, 2, ''

;TORRENT SATURATED OR MISSING QUADRANT:
tor_q = where($
double(log.maxcts11) gt '5d4' or $
double(log.maxcts11) le '0d' or $
double(log.maxcts12) gt '5d4' or $
double(log.maxcts12) le '0d' or $
double(log.maxcts21) gt '5d4' or $
double(log.maxcts21) le '0d' or $
double(log.maxcts22) gt '5d4' or $
double(log.maxcts22) le '0d' and $
strt(log.object) ne 'junk', ntor_q)
;stop
printf, 2, '<tr>'
printf, 2, '<td>'
printf, 2, 'Missing Qs: '
printf, 2, '</td>'
if ntor_q eq 0 then begin			   
printf, 2, '<td bgcolor =#5CEC21 align=center>'
endif else printf, 2, '<td bgcolor =#EC020B align=center>'
printf, 2, strt(ntor_q)
printf, 2, '</td>'
printf, 2, '</tr>'
printf, 2, ''

printf, 2, '</table>'
printf, 2, '<br>'

;************************************************************************
;CREATING THE ENVIRONMENTAL TABLE
;************************************************************************

printf, 2, 'Environmental Info:'
printf, 2, '<table border ="+1">'
printf, 2, '<tr>'
printf, 2, '<th align=center>'
printf, 2, 'Parameter'
printf, 2, '</th>'
printf, 2, '<th>'
printf, 2, 'Min Value'
printf, 2, '</th>'
printf, 2, '<th>'
printf, 2, 'Max Value'
printf, 2, '</th>'
printf, 2, '</tr>'
printf, 2, ''

  ;*****************************************
  ;        ***LOG 1: INSTTEMP ***
  ;*****************************************
jddate = julday(strmid(date,2,2),strmid(date,4,2),double('20'+strmid(date,0,2)))
xit = where(insttemp.insttempjd gt jddate and $
insttemp.insttempjd le jddate+1d , nxit)

if nxit gt 0 then begin
  ;GRATING TEMP
  gtminmax = minmax(insttemp[xit].grating)
  printf, 2, '<tr>'
  printf, 2, '<td>'
  printf, 2, 'Grating Temp: '
  printf, 2, '</td>'
  if gtminmax[0] lt gratingtempmin then begin			   
	printf, 2, redcol
  endif else printf, 2, greencol
  printf, 2, strt(gtminmax[0], f='(F8.2)')
  printf, 2, '</td>'
  if gtminmax[1] gt gratingtempmax then begin			   
	printf, 2, redcol
  endif else printf, 2, greencol
  printf, 2, strt(gtminmax[1], f='(F8.2)')
  printf, 2, '</td>'
  printf, 2, '</tr>'
  printf, 2, ''
  
  ;TABCEN TEMP
  tabcenminmax = minmax(insttemp[xit].tabcen)
  printf, 2, '<tr>'
  printf, 2, '<td>'
  printf, 2, 'Tabcen Temp: '
  printf, 2, '</td>'
  if tabcenminmax[0] lt tabcentempmin then begin			   
	printf, 2, redcol
  endif else printf, 2, greencol
  printf, 2, strt(tabcenminmax[0], f='(F8.2)')
  printf, 2, '</td>'
  if tabcenminmax[1] gt tabcentempmax then begin			   
	printf, 2, redcol
  endif else printf, 2, greencol
  printf, 2, strt(tabcenminmax[1], f='(F8.2)')
  printf, 2, '</td>'
  printf, 2, '</tr>'
  printf, 2, ''
  
  ;ENCL TEMP
  enclminmax = minmax(insttemp[xit].encltemp)
  printf, 2, '<tr>'
  printf, 2, '<td>'
  printf, 2, 'Enclosure Temp: '
  printf, 2, '</td>'
  if enclminmax[0] lt encltempmin then begin			   
	printf, 2, redcol
  endif else printf, 2, greencol
  printf, 2, strt(enclminmax[0], f='(F8.2)')
  printf, 2, '</td>'
  if enclminmax[1] gt encltempmax then begin			   
	printf, 2, redcol
  endif else printf, 2, greencol
  printf, 2, strt(enclminmax[1], f='(F8.2)')
  printf, 2, '</td>'
  printf, 2, '</tr>'
  printf, 2, ''
  
  ;ENCL SETPOINT
  enclspminmax = minmax(insttemp[xit].enclsetp)
  printf, 2, '<tr>'
  printf, 2, '<td>'
  printf, 2, 'Enclosure Setpoint: '
  printf, 2, '</td>'
  if enclspminmax[0] lt enclsetpmin then begin			   
	printf, 2, redcol
  endif else printf, 2, greencol
  printf, 2, strt(enclspminmax[0], f='(F8.2)')
  printf, 2, '</td>'
  if enclspminmax[1] gt enclsetpmax then begin			   
	printf, 2, redcol
  endif else printf, 2, greencol
  printf, 2, strt(enclspminmax[1], f='(F8.2)')
  printf, 2, '</td>'
  printf, 2, '</tr>'
  printf, 2, ''
  
  ;ENCL2 TEMP
  encl2minmax = minmax(insttemp[xit].encl2)
  printf, 2, '<tr>'
  printf, 2, '<td>'
  printf, 2, 'Encl2 Temp: '
  printf, 2, '</td>'
  if encl2minmax[0] lt encl2tempmin then begin			   
	printf, 2, redcol
  endif else printf, 2, greencol
  printf, 2, strt(encl2minmax[0], f='(F8.2)')
  printf, 2, '</td>'
  if encl2minmax[1] gt encl2tempmax then begin			   
	printf, 2, redcol
  endif else printf, 2, greencol
  printf, 2, strt(encl2minmax[1], f='(F8.2)')
  printf, 2, '</td>'
  printf, 2, '</tr>'
  printf, 2, ''
  
  ;IOD TEMP
  iodminmax = minmax(insttemp[xit].iodctemp)
  printf, 2, '<tr>'
  printf, 2, '<td>'
  printf, 2, 'Iodine Temp: '
  printf, 2, '</td>'
  if iodminmax[0] lt iodtempmin then begin			   
	printf, 2, redcol
  endif else printf, 2, greencol
  printf, 2, strt(iodminmax[0], f='(F8.2)')
  printf, 2, '</td>'
  if iodminmax[1] gt iodtempmax then begin			   
	printf, 2, redcol
  endif else printf, 2, greencol
  printf, 2, strt(iodminmax[1], f='(F8.2)')
  printf, 2, '</td>'
  printf, 2, '</tr>'
  printf, 2, ''
  
  ;IODSETP TEMP
  iodspminmax = minmax(insttemp[xit].iodcsetp)
  printf, 2, '<tr>'
  printf, 2, '<td>'
  printf, 2, 'Iodine Setpoint: '
  printf, 2, '</td>'
  if iodspminmax[0] lt iodspmin then begin			   
	printf, 2, redcol
  endif else printf, 2, greencol
  printf, 2, strt(iodspminmax[0], f='(F8.2)')
  printf, 2, '</td>'
  if iodspminmax[1] gt iodspmax then begin			   
	printf, 2, redcol
  endif else printf, 2, greencol
  printf, 2, strt(iodspminmax[1], f='(F8.2)')
  printf, 2, '</td>'
  printf, 2, '</tr>'
  printf, 2, ''
  
  ;TABLOW TEMP
  tablowminmax = minmax(insttemp[xit].tablow)
  printf, 2, '<tr>'
  printf, 2, '<td>'
  printf, 2, 'Tablow Temp: '
  printf, 2, '</td>'
  if tablowminmax[0] lt tablowmin then begin			   
	printf, 2, redcol
  endif else printf, 2, greencol
  printf, 2, strt(tablowminmax[0], f='(F8.2)')
  printf, 2, '</td>'
  if tablowminmax[1] gt tablowmax then begin			   
	printf, 2, redcol
  endif else printf, 2, greencol
  printf, 2, strt(tablowminmax[1], f='(F8.2)')
  printf, 2, '</td>'
  printf, 2, '</tr>'
  printf, 2, ''
  
  ;STRUCT TEMP
  structminmax = minmax(insttemp[xit].struct)
  printf, 2, '<tr>'
  printf, 2, '<td>'
  printf, 2, 'Struct Temp: '
  printf, 2, '</td>'
  if structminmax[0] lt structtempmin then begin			   
	printf, 2, redcol
  endif else printf, 2, greencol
  printf, 2, strt(structminmax[0], f='(F8.2)')
  printf, 2, '</td>'
  if structminmax[1] gt structtempmax then begin			   
	printf, 2, redcol
  endif else printf, 2, greencol
  printf, 2, strt(structminmax[1], f='(F8.2)')
  printf, 2, '</td>'
  printf, 2, '</tr>'
  printf, 2, ''
  
  ;INSTSETP TEMP
  instspminmax = minmax(insttemp[xit].instsetp)
  printf, 2, '<tr>'
  printf, 2, '<td>'
  printf, 2, 'Inst Setpoint: '
  printf, 2, '</td>'
  if instspminmax[0] lt instsetpmin then begin			   
	printf, 2, redcol
  endif else printf, 2, greencol
  printf, 2, strt(instspminmax[0], f='(F8.2)')
  printf, 2, '</td>'
  if instspminmax[1] gt instsetpmax then begin			   
	printf, 2, redcol
  endif else printf, 2, greencol
  printf, 2, strt(instspminmax[1], f='(F8.2)')
  printf, 2, '</td>'
  printf, 2, '</tr>'
  printf, 2, ''
  
  ;INST TEMP
  instminmax = minmax(insttemp[xit].insttemp)
  printf, 2, '<tr>'
  printf, 2, '<td>'
  printf, 2, 'Inst Temp: '
  printf, 2, '</td>'
  if instminmax[0] lt insttempmin then begin			   
	printf, 2, redcol
  endif else printf, 2, greencol
  printf, 2, strt(instminmax[0], f='(F8.2)')
  printf, 2, '</td>'
  if instminmax[1] gt insttempmax then begin			   
	printf, 2, redcol
  endif else printf, 2, greencol
  printf, 2, strt(instminmax[1], f='(F8.2)')
  printf, 2, '</td>'
  printf, 2, '</tr>'
  printf, 2, ''
endif;nxdt>0
  
xdt = where(dettemps.dettempjd gt jddate and $
dettemps.dettempjd le jddate + 1d, nxdt)

if nxdt gt 0 then begin
  ;*****************************************
  ;        ***LOG 2: DETTEMPS ***
  ;*****************************************
  printf, 2, '<tr>'
  printf, 2, '<td>'
  printf, 2, '</td>'
  printf, 2, '<td>'
  printf, 2, '</td>'
  printf, 2, '<td>'
  printf, 2, '</td>'
  printf, 2, '</tr>'
  printf, 2, ''
  
  ;CCDTEMP
  ccdtminmax = minmax(dettemps[xdt].ccdtemp)
  printf, 2, '<tr>'
  printf, 2, '<td>'
  printf, 2, 'CCD Temp: '
  printf, 2, '</td>'
  if ccdtminmax[0] lt ccdtempmin then begin			   
	printf, 2, redcol
  endif else printf, 2, greencol
  printf, 2, strt(ccdtminmax[0], f='(F8.2)')
  printf, 2, '</td>'
  if ccdtminmax[1] gt ccdtempmax then begin			   
	printf, 2, redcol
  endif else printf, 2, greencol
  printf, 2, strt(ccdtminmax[1], f='(F8.2)')
  printf, 2, '</td>'
  printf, 2, '</tr>'
  printf, 2, ''
  
  ;CCDSETP
  ccdspminmax = minmax(dettemps[xdt].ccdsetp)
  printf, 2, '<tr>'
  printf, 2, '<td>'
  printf, 2, 'CCD Setpoint: '
  printf, 2, '</td>'
  if ccdspminmax[0] lt ccdsetpmin then begin			   
	printf, 2, redcol
  endif else printf, 2, greencol
  printf, 2, strt(ccdspminmax[0], f='(F8.2)')
  printf, 2, '</td>'
  if ccdspminmax[1] gt ccdsetpmax then begin			   
	printf, 2, redcol
  endif else printf, 2, greencol
  printf, 2, strt(ccdspminmax[1], f='(F8.2)')
  printf, 2, '</td>'
  printf, 2, '</tr>'
  printf, 2, ''
  
  ;NECK TEMP:
  ncktminmax = minmax(dettemps[xdt].necktemp)
  printf, 2, '<tr>'
  printf, 2, '<td>'
  printf, 2, 'Neck Temp: '
  printf, 2, '</td>'
  if ncktminmax[0] lt necktempmin then begin			   
	printf, 2, redcol
  endif else printf, 2, greencol
  printf, 2, strt(ncktminmax[0], f='(F8.2)')
  printf, 2, '</td>'
  if ncktminmax[1] gt necktempmax then begin			   
	printf, 2, redcol
  endif else printf, 2, greencol
  printf, 2, strt(ncktminmax[1], f='(F8.2)')
  printf, 2, '</td>'
  printf, 2, '</tr>'
  printf, 2, ''
endif;nxdt>0


xct = where(chipress.chipressjd gt jddate and $
chipress.chipressjd le jddate + 1d, nxct)

if nxct gt 0 then begin
  ;*****************************************
  ;        ***LOG 3: CHIPRESS ***
  ;*****************************************
  printf, 2, '<tr>'
  printf, 2, '<td>'
  printf, 2, '</td>'
  printf, 2, '<td>'
  printf, 2, '</td>'
  printf, 2, '<td>'
  printf, 2, '</td>'
  printf, 2, '</tr>'
  printf, 2, ''
  
  ;BAROMETER
  barminmax = minmax(chipress[xct].barometer)
  printf, 2, '<tr>'
  printf, 2, '<td>'
  printf, 2, 'Barometer: '
  printf, 2, '</td>'
  if barminmax[0] lt barpressmin then begin			   
	printf, 2, redcol
  endif else printf, 2, greencol
  printf, 2, strt(barminmax[0], f='(F8.2)')
  printf, 2, '</td>'
  if barminmax[1] gt barpressmax then begin			   
	printf, 2, redcol
  endif else printf, 2, greencol
  printf, 2, strt(barminmax[1], f='(F8.2)')
  printf, 2, '</td>'
  printf, 2, '</tr>'
  printf, 2, ''

  ;ECHELLE ENCLOSURE PRESSURE
  echminmax = minmax(chipress[xct].echpress)
  printf, 2, '<tr>'
  printf, 2, '<td>'
  printf, 2, 'Echelle: '
  printf, 2, '</td>'
  if echminmax[0] lt echelleenclmin then begin			   
	printf, 2, redcol
  endif else printf, 2, greencol
  printf, 2, strt(echminmax[0], f='(F8.2)')
  printf, 2, '</td>'
  if echminmax[1] gt echelleenclmax then begin			   
	printf, 2, redcol
  endif else printf, 2, greencol
  printf, 2, strt(echminmax[1], f='(F8.2)')
  printf, 2, '</td>'
  printf, 2, '</tr>'
  printf, 2, ''
endif;nxct>0

printf, 2, '</table>'
printf, 2, '<br>'

print, '****************************************************************'
print, 'NIGHTLY LOG FROM IOS'
print, '****************************************************************'
ioslogfn = '/mir7/logs/IOS/nightly/'+date+'_IOS.log'
spawn, 'hostname', host
if strmid(host, 13,14, /reverse) eq 'astro.yale.edu' then ioslogfn = '/tous'+ioslogfn
print, 'DOES THE IOS LOG EXIST?', file_test(ioslogfn)
if file_test(ioslogfn) then begin
printf, 2, 'IOS Log:'
printf, 2, '<table border ="+1">'
printf, 2, '<tr>'
printf, 2, '<th align=center>'
printf, 2, ' # '
printf, 2, '</th>'
printf, 2, '<th align=center>'
printf, 2, 'stat'
printf, 2, '</th>'
printf, 2, '<th>'
printf, 2, 'cal'
printf, 2, '</th>'
printf, 2, '<th align=center>'
printf, 2, 'object'
printf, 2, '</th>'
printf, 2, '<th>'
printf, 2, 'ra'
printf, 2, '</th>'
printf, 2, '<th>'
printf, 2, 'dec'
printf, 2, '</th>'
printf, 2, '<th>'
printf, 2, 'vmag'
printf, 2, '</th>'
printf, 2, '<th>'
printf, 2, 'exptime'
printf, 2, '</th>'
printf, 2, '<th>'
printf, 2, 'nexp'
printf, 2, '</th>'
printf, 2, '<th>'
printf, 2, 'presetmode'
printf, 2, '</th>'
printf, 2, '<th>'
printf, 2, 'propid'
printf, 2, '</th>'
printf, 2, '<th>'
printf, 2, 'setpt'
printf, 2, '</th>'
printf, 2, '</tr>'
printf, 2, ''

if long(date) lt 120326L then delimr=' ' else delimr = ','

readcol, ioslogfn, stat, cal, object, ra, dec, vmag, exptime, nexp, $
	presetmode, propid, setpt, filename, delim=delimr, $
	form='A, A, A, A, A, A, A, A, A, A, A, A'

for i=0, n_elements(stat)-1 do begin

ioslogxst = where(strt(log.object) eq strt(object[i]) and $
						strt(log.propid) eq strt(propid[i]) and $
						strt(log.geommod) eq strt(presetmode[i]), niosxst)
;						strt(log.exptime) eq strt(exptime[i]) and $

;*********************************************************
;NOW THE SPECIAL CONDITIONS FOR BON, CALIB1, QTZ_I2_NARROW, EON, CALIB2 AND THARS
;1. BON exists
if strt(object[i]) eq 'BON' or strt(object[i]) eq 'BON Setup' then begin
dum = where(strt(log.object) eq 'ThAr' and long(log.seqnum) lt 1050L and $
	strt(log.propid) eq 'CPS' and strt(log.decker) eq 'narrow_slit' and $
	strt(log.geommod) eq 'Setup', niosxst)
endif

;2. EON exists
if strt(object[i]) eq 'EON' or strt(object[i]) eq 'EON Setup' then begin
dum = where(strt(log.object) eq 'ThAr' and long(log.seqnum) gt 1050L and $
	strt(log.propid) eq 'CPS' and strt(log.decker) eq 'narrow_slit' and $
	strt(log.geommod) eq 'Setup', niosxst)
endif

;2. Calib1
if strt(object[i]) eq 'Calib1' then begin
ioslogxst = where( (strt(log.propid) eq 'Calib') and $
	long(log.seqnum) le 1100, niosxstcals)
	print, '# Calib1s: ', niosxstcals
if niosxstcals gt 46 then niosxst = 1
endif

;3. Calib2
if strt(object[i]) eq 'Calib2' then begin
ioslogxst = where( (strt(log.propid) eq 'Calib') and $
	long(log.seqnum) gt 1100, niosxstcals)
	print, '# Calib2s: ', niosxstcals
if niosxstcals gt 46 then niosxst = 1
endif

;4. Qtz_i2_Narrow
if strt(presetmode[i]) eq 'Qtz_i2_Narrow' then begin
dum = where(strt(log.object) eq 'iodine' and $
	strt(log.decker) eq 'narrow_slit' and $
	strt(log.geommod) eq 'Quartz_i2_Narrow', niosxst)
endif

;5. Qtz_i2_Slit
if strt(presetmode[i]) eq 'Qtz_i2_Slit' then begin
dum = where(strt(log.object) eq 'iodine' and $
	strt(log.decker) eq 'slit' and $
	strt(log.geommod) eq 'Quartz_i2_Slit', niosxst)
endif

;6. Qtz_i2_Slicer
if strt(presetmode[i]) eq 'Qtz_i2_Slicer' then begin
dum = where(strt(log.object) eq 'iodine' and $
	strt(log.decker) eq 'slicer' and $
	strt(log.geommod) eq 'Quartz_i2_Slicer', niosxst)
endif

;6. Qtz_i2_Fiber
if strt(presetmode[i]) eq 'Qtz_i2_Fiber' then begin
dum = where(strt(log.object) eq 'iodine' and $
	strt(log.decker) eq 'fiber' and $
	strt(log.geommod) eq 'Quartz_i2_Fiber', niosxst)
endif

;7. ThAr_Fiber
if strt(presetmode[i]) eq 'ThAr_Fiber' then begin
dum = where(strt(log.object) eq 'ThAr' and $
	strt(log.decker) eq 'fiber' and $
;	strt(log.geommod) eq 'ThAr_Fiber' and $
	strt(log.propid) eq strt(propid[i]), niosxst)
	niosxst *= long(nexp[i])
endif

;8. ThAr_Slicer
if strt(presetmode[i]) eq 'ThAr_Slicer' then begin
dum = where(strt(log.object) eq 'ThAr' and $
	strt(log.decker) eq 'slicer' and $
;	strt(log.geommod) eq 'ThAr_Slicer' and $
	strt(log.propid) eq strt(propid[i]), niosxst)
	niosxst *= long(nexp[i])
endif

;8. ThAr_Slit
if strt(presetmode[i]) eq 'ThAr_Slit' then begin
dum = where(strt(log.object) eq 'ThAr' and $
	strt(log.decker) eq 'slit' and $
;	strt(log.geommod) eq 'ThAr_Slicer' and $
	strt(log.propid) eq strt(propid[i]), niosxst)
	niosxst *= long(nexp[i])
endif

;END OF SPECIAL CONDITIONS.
;*********************************************************

						
  printf, 2, '<tr>'

  if niosxst ge nexp[i] then begin
	 printf, 2, '<td bgcolor =#5CEC21 align=center>'
  endif else printf, 2, '<td bgcolor =#EC020B align=center>'
  printf, 2, strt(niosxst)
  printf, 2, '</td>'

  printf, 2, '<td>'
  printf, 2, stat[i]
  printf, 2, '</td>'
  printf, 2, '<td>'
  printf, 2, cal[i]
  printf, 2, '</td>'
  printf, 2, '<td>'
  printf, 2, object[i]
  printf, 2, '</td>'
  printf, 2, '<td>'
  printf, 2, ra[i]
  printf, 2, '</td>'
  printf, 2, '<td>'
  printf, 2, dec[i]
  printf, 2, '</td>'
  printf, 2, '<td>'
  printf, 2, vmag[i]
  printf, 2, '</td>'
  printf, 2, '<td>'
  printf, 2, exptime[i]
  printf, 2, '</td>'
  printf, 2, '<td>'
  printf, 2, nexp[i]
  printf, 2, '</td>'
  printf, 2, '<td>'
  printf, 2, presetmode[i]
  printf, 2, '</td>'
  printf, 2, '<td>'
  printf, 2, propid[i]
  printf, 2, '</td>'
  printf, 2, '<td>'
  printf, 2, setpt[i]
  printf, 2, '</td>'
endfor
endif;ioslogfn
printf, 2, '<table>'
printf, 2, '<br>'

;************************************************************************
;CREATING THE CALIBRATIONS TABLE
;************************************************************************
printf, 2, 'Calibrations:'
printf, 2, '<table border ="+1">'
printf, 2, '<tr>'
printf, 2, '<th align=center>'
printf, 2, '# Exp'
printf, 2, '</th>'
printf, 2, '<th>'
printf, 2, 'BON Calib Name'
printf, 2, '</th>'
printf, 2, '<th align=center>'
printf, 2, '# Exp'
printf, 2, '</th>'
printf, 2, '<th>'
printf, 2, 'EON Calib Name'
printf, 2, '</th>'
printf, 2, '</tr>'
printf, 2, ''

;NARROW QUARTZ
printf, 2, '<tr>'
qnr3b = where(strt(log.object) eq 'quartz' and $
			   double(strmid(log.seqnum,0,4)) lt 1090L and $
			   strt(log.ccdsum) eq '3 1' and $
			   strt(log.speedmod) eq 'normal' and $
			   strt(log.maxcts) gt 2d4 and $
			   strt(log.maxcts) lt 6d4 and $
			   strt(log.decker) eq 'narrow_slit', nqnr3b)
if nqnr3b ge nqtzbon then begin			   
printf, 2, '<td bgcolor =#5CEC21 align=center>'
endif else printf, 2, '<td bgcolor =#EC020B align=center>'
printf, 2, strt(nqnr3b)
printf, 2, '</td>'
printf, 2, '<td>'
printf, 2, ' Narrow  Quartz'
printf, 2, '</td>'
qnr3a = where(strt(log.object) eq 'quartz' and $
			   double(strmid(log.seqnum,0,4)) gt 1090L and $
			   strt(log.ccdsum) eq '3 1' and $
			   strt(log.speedmod) eq 'normal' and $
			   strt(log.maxcts) gt 2d4 and $
			   strt(log.maxcts) lt 6d4 and $
			   strt(log.decker) eq 'narrow_slit', nqnr3a)
if nqnr3a ge nqtzeon then begin			   
printf, 2, '<td bgcolor =#5CEC21 align=center>'
endif else printf, 2, '<td bgcolor =#EC020B align=center>'
printf, 2, strt(nqnr3a)
printf, 2, '</td>'
printf, 2, '<td>'
printf, 2, ' Narrow  Quartz'
printf, 2, '</td>'
printf, 2, '</tr>'
printf, 2, ''
;SLIT QUARTZ:
printf, 2, '<tr>'
qst3b = where(strt(log.object) eq 'quartz' and $
			   double(strmid(log.seqnum,0,4)) lt 1090L and $
			   strt(log.ccdsum) eq '3 1' and $
			   strt(log.speedmod) eq 'normal' and $
			   strt(log.maxcts) gt 2d4 and $
			   strt(log.maxcts) lt 6d4 and $
			   strt(log.decker) eq 'slit', nqst3b)
if nqst3b ge nqtzbon then begin			   
printf, 2, '<td bgcolor =#5CEC21 align=center>'
endif else printf, 2, '<td bgcolor =#EC020B align=center>'
printf, 2, strt(nqst3b)
printf, 2, '</td>'
printf, 2, '<td>'
printf, 2, ' Slit  Quartz'
printf, 2, '</td>'
qst3a = where(strt(log.object) eq 'quartz' and $
			   double(strmid(log.seqnum,0,4)) gt 1090L and $
			   strt(log.ccdsum) eq '3 1' and $
			   strt(log.speedmod) eq 'normal' and $
			   strt(log.maxcts) gt 2d4 and $
			   strt(log.maxcts) lt 6d4 and $
			   strt(log.decker) eq 'slit', nqst3a)
if nqst3a ge nqtzeon then begin			   
printf, 2, '<td bgcolor =#5CEC21 align=center>'
endif else printf, 2, '<td bgcolor =#EC020B align=center>'
printf, 2, strt(nqst3a)
printf, 2, '</td>'
printf, 2, '<td>'
printf, 2, ' Slit  Quartz'
printf, 2, '</td>'
printf, 2, '</tr>'
printf, 2, ''

;SLICER QUARTZ
printf, 2, '<tr>'
qsc3b = where(strt(log.object) eq 'quartz' and $
			   double(strmid(log.seqnum,0,4)) lt 1090L and $
			   strt(log.ccdsum) eq '3 1' and $
			   strt(log.speedmod) eq 'normal' and $
			   strt(log.maxcts) gt 2d4 and $
			   strt(log.maxcts) lt 6d4 and $
			   strt(log.decker) eq 'slicer', nqsc3b)
if nqsc3b ge nqtzbon then begin			   
printf, 2, '<td bgcolor =#5CEC21 align=center>'
endif else printf, 2, '<td bgcolor =#EC020B align=center>'
printf, 2, strt(nqsc3b)
printf, 2, '</td>'
printf, 2, '<td>'
printf, 2, ' Slicer  Quartz'
printf, 2, '</td>'
qsc3a = where(strt(log.object) eq 'quartz' and $
			   double(strmid(log.seqnum,0,4)) gt 1090L and $
			   strt(log.ccdsum) eq '3 1' and $
			   strt(log.speedmod) eq 'normal' and $
			   strt(log.maxcts) gt 2d4 and $
			   strt(log.maxcts) lt 6d4 and $
			   strt(log.decker) eq 'slicer', nqsc3a)
if nqsc3a ge nqtzeon then begin			   
printf, 2, '<td bgcolor =#5CEC21 align=center>'
endif else printf, 2, '<td bgcolor =#EC020B align=center>'
printf, 2, strt(nqsc3a)
printf, 2, '</td>'
printf, 2, '<td>'
printf, 2, ' Slit  Quartz'
printf, 2, '</td>'
printf, 2, '</tr>'
printf, 2, ''

;FIBER QUARTZ

printf, 2, '<tr>'
qfb3b = where(strt(log.object) eq 'quartz' and $
			   double(strmid(log.seqnum,0,4)) lt 1090L and $
			   strt(log.ccdsum) eq '4 4' and $
			   strt(log.speedmod) eq 'normal' and $
			   strt(log.maxcts) gt 2d4 and $
			   strt(log.maxcts) lt 6d4 and $
			   strt(log.decker) eq 'fiber', nqfb3b)
if nqfb3b ge nqtzbon then begin			   
printf, 2, '<td bgcolor =#5CEC21 align=center>'
endif else printf, 2, '<td bgcolor =#EC020B align=center>'
printf, 2, strt(nqfb3b)
printf, 2, '</td>'
printf, 2, '<td>'
printf, 2, ' Fiber  Quartz'
printf, 2, '</td>'
qfb3a = where(strt(log.object) eq 'quartz' and $
			   double(strmid(log.seqnum,0,4)) gt 1090L and $
			   strt(log.ccdsum) eq '4 4' and $
			   strt(log.speedmod) eq 'normal' and $
			   strt(log.maxcts) gt 2d4 and $
			   strt(log.maxcts) lt 6d4 and $
			   strt(log.decker) eq 'fiber', nqfb3a)
if nqfb3a ge nqtzeon then begin			   
printf, 2, '<td bgcolor =#5CEC21 align=center>'
endif else printf, 2, '<td bgcolor =#EC020B align=center>'
printf, 2, strt(nqfb3a)
printf, 2, '</td>'
printf, 2, '<td>'
printf, 2, ' Fiber  Quartz'
printf, 2, '</td>'
printf, 2, '</tr>'
printf, 2, ''

;**************************************
;NARROW THAR
printf, 2, '<tr>'
tnr3b = where(strt(log.object) eq 'ThAr' and $
			   double(strmid(log.seqnum,0,4)) lt 1090L and $
			   strt(log.ccdsum) eq '3 1' and $
			   strt(log.decker) eq 'narrow_slit', ntnr3b)
if ntnr3b ge ntharbon then begin			   
printf, 2, '<td bgcolor =#5CEC21 align=center>'
endif else printf, 2, '<td bgcolor =#EC020B align=center>'
printf, 2, strt(ntnr3b)
printf, 2, '</td>'
printf, 2, '<td>'
printf, 2, ' Narrow  ThAr'
printf, 2, '</td>'
tnr3a = where(strt(log.object) eq 'ThAr' and $
			   double(strmid(log.seqnum,0,4)) gt 1090L and $
			   strt(log.ccdsum) eq '3 1' and $
			   strt(log.decker) eq 'narrow_slit', ntnr3a)
if ntnr3a ge nthareon then begin			   
printf, 2, '<td bgcolor =#5CEC21 align=center>'
endif else printf, 2, '<td bgcolor =#EC020B align=center>'
printf, 2, strt(ntnr3a)
printf, 2, '</td>'
printf, 2, '<td>'
printf, 2, ' Narrow  ThAr'
printf, 2, '</td>'
printf, 2, '</tr>'
printf, 2, ''

;SLIT THAR
printf, 2, '<tr>'
tst3b = where(strt(log.object) eq 'ThAr' and $
			   double(strmid(log.seqnum,0,4)) lt 1090L and $
			   strt(log.ccdsum) eq '3 1' and $
			   strt(log.decker) eq 'slit', ntst3b)
if ntst3b ge ntharbon then begin			   
printf, 2, '<td bgcolor =#5CEC21 align=center>'
endif else printf, 2, '<td bgcolor =#EC020B align=center>'
printf, 2, strt(ntst3b)
printf, 2, '</td>'
printf, 2, '<td>'
printf, 2, ' Slit  ThAr'
printf, 2, '</td>'
tst3a = where(strt(log.object) eq 'ThAr' and $
			   double(strmid(log.seqnum,0,4)) gt 1090L and $
			   strt(log.ccdsum) eq '3 1' and $
			   strt(log.decker) eq 'slit', ntst3a)
if ntst3a ge nthareon then begin			   
printf, 2, '<td bgcolor =#5CEC21 align=center>'
endif else printf, 2, '<td bgcolor =#EC020B align=center>'
printf, 2, strt(ntst3a)
printf, 2, '</td>'
printf, 2, '<td>'
printf, 2, ' Slit  ThAr'
printf, 2, '</td>'
printf, 2, '</tr>'
printf, 2, ''

;SLICER THAR
printf, 2, '<tr>'
tsc3b = where(strt(log.object) eq 'ThAr' and $
			   double(strmid(log.seqnum,0,4)) lt 1090L and $
			   strt(log.ccdsum) eq '3 1' and $
			   strt(log.decker) eq 'slicer', ntsc3b)
if ntsc3b ge ntharbon then begin			   
printf, 2, '<td bgcolor =#5CEC21 align=center>'
endif else printf, 2, '<td bgcolor =#EC020B align=center>'
printf, 2, strt(ntsc3b)
printf, 2, '</td>'
printf, 2, '<td>'
printf, 2, ' Slicer  ThAr'
printf, 2, '</td>'
tsc3a = where(strt(log.object) eq 'ThAr' and $
			   double(strmid(log.seqnum,0,4)) gt 1090L and $
			   strt(log.ccdsum) eq '3 1' and $
			   strt(log.decker) eq 'slicer', ntsc3a)
if ntsc3a ge nthareon then begin			   
printf, 2, '<td bgcolor =#5CEC21 align=center>'
endif else printf, 2, '<td bgcolor =#EC020B align=center>'
printf, 2, strt(ntsc3a)
printf, 2, '</td>'
printf, 2, '<td>'
printf, 2, ' Slicer  ThAr'
printf, 2, '</td>'
printf, 2, '</tr>'
printf, 2, ''

;FIBER THAR
printf, 2, '<tr>'
tfb3b = where(strt(log.object) eq 'ThAr' and $
			   double(strmid(log.seqnum,0,4)) lt 1090L and $
			   strt(log.ccdsum) eq '4 4' and $
			   strt(log.decker) eq 'fiber', ntfb3b)
if ntfb3b ge ntharbon then begin			   
printf, 2, '<td bgcolor =#5CEC21 align=center>'
endif else printf, 2, '<td bgcolor =#EC020B align=center>'
printf, 2, strt(ntfb3b)
printf, 2, '</td>'
printf, 2, '<td>'
printf, 2, ' Fiber  ThAr'
printf, 2, '</td>'
tfb3a = where(strt(log.object) eq 'ThAr' and $
			   double(strmid(log.seqnum,0,4)) gt 1090L and $
			   strt(log.ccdsum) eq '4 4' and $
			   strt(log.decker) eq 'fiber', ntfb3a)
if ntfb3a ge nthareon then begin			   
printf, 2, '<td bgcolor =#5CEC21 align=center>'
endif else printf, 2, '<td bgcolor =#EC020B align=center>'
printf, 2, strt(ntfb3a)
printf, 2, '</td>'
printf, 2, '<td>'
printf, 2, ' Fiber  ThAr'
printf, 2, '</td>'
printf, 2, '</tr>'
printf, 2, ''

;*************************************
;IODINE OBSERVATIONS
;NARROW I2
printf, 2, '<tr>'
i2nr3b = where(strt(log.object) eq 'iodine' and $
			   double(strmid(log.seqnum,0,4)) lt 1090L and $
			   strt(log.ccdsum) eq '3 1' and $
			   strt(log.decker) eq 'narrow_slit', ni2nr3b)
if ni2nr3b ge ni2bon then begin			   
printf, 2, '<td bgcolor =#5CEC21 align=center>'
endif else printf, 2, '<td bgcolor =#EC020B align=center>'
printf, 2, strt(ni2nr3b)
printf, 2, '</td>'
printf, 2, '<td>'
printf, 2, ' Narrow  Iodine'
printf, 2, '</td>'
i2nr3a = where(strt(log.object) eq 'ThAr' and $
			   double(strmid(log.seqnum,0,4)) gt 1090L and $
			   strt(log.ccdsum) eq '3 1' and $
			   strt(log.decker) eq 'narrow_slit', ni2nr3a)
if ni2nr3a ge ni2eon then begin			   
printf, 2, '<td bgcolor =#5CEC21 align=center>'
endif else printf, 2, '<td bgcolor =#EC020B align=center>'
printf, 2, strt(ni2nr3a)
printf, 2, '</td>'
printf, 2, '<td>'
printf, 2, ' Narrow  Iodine'
printf, 2, '</td>'
printf, 2, '</tr>'
printf, 2, ''

;SLIT I2
printf, 2, '<tr>'
i2st3b = where(strt(log.object) eq 'iodine' and $
			   double(strmid(log.seqnum,0,4)) lt 1090L and $
			   strt(log.ccdsum) eq '3 1' and $
			   strt(log.decker) eq 'slit', ni2st3b)
if ni2st3b ge ni2bon then begin			   
printf, 2, '<td bgcolor =#5CEC21 align=center>'
endif else printf, 2, '<td bgcolor =#EC020B align=center>'
printf, 2, strt(ni2st3b)
printf, 2, '</td>'
printf, 2, '<td>'
printf, 2, ' Slit Iodine'
printf, 2, '</td>'
i2st3a = where(strt(log.object) eq 'ThAr' and $
			   double(strmid(log.seqnum,0,4)) gt 1090L and $
			   strt(log.ccdsum) eq '3 1' and $
			   strt(log.decker) eq 'slit', ni2st3a)
if ni2st3a ge ni2eon then begin			   
printf, 2, '<td bgcolor =#5CEC21 align=center>'
endif else printf, 2, '<td bgcolor =#EC020B align=center>'
printf, 2, strt(ni2st3a)
printf, 2, '</td>'
printf, 2, '<td>'
printf, 2, ' Slit Iodine'
printf, 2, '</td>'
printf, 2, '</tr>'
printf, 2, ''

;SLICER I2
printf, 2, '<tr>'
i2sc3b = where(strt(log.object) eq 'iodine' and $
			   double(strmid(log.seqnum,0,4)) lt 1090L and $
			   strt(log.ccdsum) eq '3 1' and $
			   strt(log.decker) eq 'slicer', ni2sc3b)
if ni2sc3b ge ni2bon then begin			   
printf, 2, '<td bgcolor =#5CEC21 align=center>'
endif else printf, 2, '<td bgcolor =#EC020B align=center>'
printf, 2, strt(ni2sc3b)
printf, 2, '</td>'
printf, 2, '<td>'
printf, 2, ' Slicer Iodine'
printf, 2, '</td>'
i2sc3a = where(strt(log.object) eq 'ThAr' and $
			   double(strmid(log.seqnum,0,4)) gt 1090L and $
			   strt(log.ccdsum) eq '3 1' and $
			   strt(log.decker) eq 'slicer', ni2sc3a)
if ni2sc3a ge ni2eon then begin			   
printf, 2, '<td bgcolor =#5CEC21 align=center>'
endif else printf, 2, '<td bgcolor =#EC020B align=center>'
printf, 2, strt(ni2sc3a)
printf, 2, '</td>'
printf, 2, '<td>'
printf, 2, ' Slicer Iodine'
printf, 2, '</td>'
printf, 2, '</tr>'
printf, 2, ''

;3x1 Normal BIAS
printf, 2, '<tr>'
bias31nb = where(strt(log.object) eq 'bias' and $
			   double(strmid(log.UTSHUT, 11, 2)) gt 17d and $
			   strt(log.ccdsum) eq '3 1' and $
			   strt(log.speedmod) eq 'normal' and $
			   strt(log.complamp) eq 'none', nbias31nb)
if nbias31nb ge nbias31bon then begin			   
printf, 2, '<td bgcolor =#5CEC21 align=center>'
endif else printf, 2, '<td bgcolor =#EC020B align=center>'
printf, 2, strt(nbias31nb)
printf, 2, '</td>'
printf, 2, '<td>'
printf, 2, ' 3x1 Normal Bias'
printf, 2, '</td>'
bias31ne = where(strt(log.object) eq 'bias' and $
			   double(strmid(log.UTSHUT, 11, 2)) le 17d and $
			   strt(log.ccdsum) eq '3 1' and $
			   strt(log.speedmod) eq 'normal' and $
			   strt(log.complamp) eq 'none', nbias31ne)
if nbias31ne ge nbias31eon then begin			   
printf, 2, '<td bgcolor =#5CEC21 align=center>'
endif else printf, 2, '<td bgcolor =#EC020B align=center>'
printf, 2, strt(nbias31ne)
printf, 2, '</td>'
printf, 2, '<td>'
printf, 2, ' 3x1 Normal Bias'
printf, 2, '</td>'
printf, 2, '</tr>'
printf, 2, ''

;4x4 Normal BIAS
printf, 2, '<tr>'
bias44nb = where(strt(log.object) eq 'bias' and $
			   double(strmid(log.UTSHUT, 11, 2)) gt 17d and $
			   strt(log.ccdsum) eq '4 4' and $
			   strt(log.speedmod) eq 'normal' and $
			   strt(log.complamp) eq 'none', nbias44nb)
if nbias44nb ge nbias44bon then begin			   
printf, 2, '<td bgcolor =#5CEC21 align=center>'
endif else printf, 2, '<td bgcolor =#EC020B align=center>'
printf, 2, strt(nbias44nb)
printf, 2, '</td>'
printf, 2, '<td>'
printf, 2, ' 4x4 Normal Bias'
printf, 2, '</td>'
bias44ne = where(strt(log.object) eq 'bias' and $
			   double(strmid(log.UTSHUT, 11, 2)) le 17d and $
			   strt(log.ccdsum) eq '4 4' and $
			   strt(log.speedmod) eq 'normal' and $
			   strt(log.complamp) eq 'none', nbias44ne)
if nbias44ne ge nbias44eon then begin			   
printf, 2, '<td bgcolor =#5CEC21 align=center>'
endif else printf, 2, '<td bgcolor =#EC020B align=center>'
printf, 2, strt(nbias44ne)
printf, 2, '</td>'
printf, 2, '<td>'
printf, 2, ' 4x4 Normal Bias'
printf, 2, '</td>'
printf, 2, '</tr>'
printf, 2, ''

;1x1 Normal BIAS
printf, 2, '<tr>'
bias11nb = where(strt(log.object) eq 'bias' and $
			   double(strmid(log.UTSHUT, 11, 2)) gt 17d and $
			   strt(log.ccdsum) eq '1 1' and $
			   strt(log.speedmod) eq 'normal' and $
			   strt(log.complamp) eq 'none', nbias11nb)
if nbias11nb ge nbias11bon then begin			   
printf, 2, '<td bgcolor =#5CEC21 align=center>'
endif else printf, 2, '<td bgcolor =#EC020B align=center>'
printf, 2, strt(nbias11nb)
printf, 2, '</td>'
printf, 2, '<td>'
printf, 2, ' 1x1 Normal Bias'
printf, 2, '</td>'
bias11ne = where(strt(log.object) eq 'bias' and $
			   double(strmid(log.UTSHUT, 11, 2)) le 17d and $
			   strt(log.ccdsum) eq '1 1' and $
			   strt(log.speedmod) eq 'normal' and $
			   strt(log.complamp) eq 'none', nbias11ne)
if nbias11ne ge nbias11eon then begin			   
printf, 2, '<td bgcolor =#5CEC21 align=center>'
endif else printf, 2, '<td bgcolor =#EC020B align=center>'
printf, 2, strt(nbias11ne)
printf, 2, '</td>'
printf, 2, '<td>'
printf, 2, ' 1x1 Normal Bias'
printf, 2, '</td>'
printf, 2, '</tr>'
printf, 2, ''

printf, 2, '</table>'
printf, 2, '<br>'

;************************************************************************
;************************************************************************
;NOW ON TO THE SCIENCE EXPOSURES:
;************************************************************************
;************************************************************************
printf, 2, 'Observations:'
printf, 2, '<table border ="+1">'
printf, 2, '<tr>'
printf, 2, '<th align=center>'
printf, 2, 'SEQ #'
printf, 2, '</th>'
printf, 2, '<th>'
printf, 2, 'OBJECT NAME'
printf, 2, '</th>'
printf, 2, '<th>'
printf, 2, 'I2'
printf, 2, '</th>'
printf, 2, '<th>'
printf, 2, 'EMMNWOB'
printf, 2, '</th>'
printf, 2, '<th align=center>'
printf, 2, 'EXP TIME'
printf, 2, '</th>'
printf, 2, '<th>'
printf, 2, 'BIN'
printf, 2, '</th>'
printf, 2, '<th>'
printf, 2, 'SPEED'
printf, 2, '</th>'
printf, 2, '<th>'
printf, 2, 'DECKER'
printf, 2, '</th>'
printf, 2, '<th>'
printf, 2, 'PROP ID'
printf, 2, '</th>'
printf, 2, '<th>'
printf, 2, 'MAX CTS'
printf, 2, '</th>'
printf, 2, '<th>'
printf, 2, 'MAXCTS 11'
printf, 2, '</th>'
printf, 2, '<th>'
printf, 2, 'MAXCTS 12'
printf, 2, '</th>'
printf, 2, '<th>'
printf, 2, 'MAXCTS 21'
printf, 2, '</th>'
printf, 2, '<th>'
printf, 2, 'MAXCTS 22'
printf, 2, '</th>'
printf, 2, '<th>'
printf, 2, 'CCD CTS'
printf, 2, '</th>'
printf, 2, '<th>'
printf, 2, 'EM CTS'
printf, 2, '</th>'
printf, 2, '<th>'
printf, 2, 'THRES'
printf, 2, '</th>'
printf, 2, '<th>'
printf, 2, 'LAMP'
printf, 2, '</th>'
printf, 2, '<th>'
printf, 2, 'B/W EXP'
printf, 2, '</th>'
printf, 2, '<th>'
printf, 2, 'G-E MP'
printf, 2, '</th>'
printf, 2, '<th>'
printf, 2, 'G-E CL'
printf, 2, '</th>'
printf, 2, '</tr>'
printf, 2, ''

;scs = where(strt(log.object) ne 'bias' and strt(log.object) ne 'dark', nscs)
;we don't want people to know when we've observed batman:
scs = where(strt(log.object) ne 'batman', nscs)
;scs = lindgen(log)
;nscs = n_elements(log)
for i=0, nscs-1 do begin
	printf,2, '<tr>'
	printf,2, '<td>'
	printf, 2, strt(log[scs[i]].seqnum)
	printf,2, '</td>'
	printf,2, '<td>'
	printf, 2, strt(log[scs[i]].object)
	printf,2, '</td>'
	printf,2, '<td>'
	printf, 2, strt(log[scs[i]].iodcell)
	printf,2, '</td>'
	printf,2, '<td>'
	printf, 2, strmid(strt(log[scs[i]].emmnwob), 11, 12)
	printf,2, '</td>'
	printf,2, '<td>'
	printf, 2, strt(double(log[scs[i]].exptime), f='(F7.2)')
	printf,2, '</td>'
	printf,2, '<td>'
	printf, 2, strt(log[scs[i]].ccdsum)
	printf,2, '</td>'
	printf,2, '<td>'
	printf, 2, strt(log[scs[i]].speedmod)
	printf,2, '</td>'
	printf,2, '<td>'
	printf, 2, strt(log[scs[i]].decker)
	printf,2, '</td>'
	printf,2, '<td>'
	printf, 2, strt(log[scs[i]].propid)
	printf,2, '</td>'
	maxcts = log[scs[i]].maxcts
	if (((maxcts lt 5.5d4) and (maxcts gt 1049d)) $
	 or (strt(log[scs[i]].object) eq 'ThAr') $
	 or (strt(log[scs[i]].object) eq 'bias') $
	 or (strt(log[scs[i]].object) eq 'dark') $
	 or (strt(log[scs[i]].object) eq 'junk')) then begin
	printf, 2, '<td bgcolor =#5CEC21 align=center>'
	endif else printf, 2, '<td bgcolor =#EC020B align=center>'
	printf, 2, strt(maxcts, f='(E15.2)')
	printf,2, '</td>'
	mxmaxthresh = 5.5d4
	mxminthresh = 50d
	mxcts11 = log[scs[i]].maxcts11
	if ((mxcts11 lt mxmaxthresh) and (mxcts11 gt mxminthresh) $
	 or (strt(log[scs[i]].object) eq 'ThAr') $
	 or (strt(log[scs[i]].object) eq 'bias') $
	 or (strt(log[scs[i]].object) eq 'dark') $
	 or (strt(log[scs[i]].object) eq 'junk')) then begin
	printf, 2, greencol
	endif else printf, 2, redcol
	printf, 2, strt(mxcts11, f='(E15.2)')
	printf,2, '</td>'
	mxcts12 = log[scs[i]].maxcts12
	if ((mxcts12 lt mxmaxthresh) and (mxcts12 gt mxminthresh) $
	 or (strt(log[scs[i]].object) eq 'ThAr') $
	 or (strt(log[scs[i]].object) eq 'bias') $
	 or (strt(log[scs[i]].object) eq 'dark') $
	 or (strt(log[scs[i]].object) eq 'junk')) then begin
	printf, 2, greencol
	endif else printf, 2, redcol
	printf, 2, strt(mxcts12, f='(E15.2)')
	printf,2, '</td>'
	mxcts21 = log[scs[i]].maxcts21
	if ((mxcts21 lt mxmaxthresh) and (mxcts21 gt mxminthresh) $
	 or (strt(log[scs[i]].object) eq 'ThAr') $
	 or (strt(log[scs[i]].object) eq 'bias') $
	 or (strt(log[scs[i]].object) eq 'dark') $
	 or (strt(log[scs[i]].object) eq 'junk')) then begin
	printf, 2, greencol
	endif else printf, 2, redcol
	printf, 2, strt(mxcts21, f='(E15.2)')
	printf,2, '</td>'
	mxcts22 = log[scs[i]].maxcts22
	if ((mxcts22 lt mxmaxthresh) and (mxcts22 gt mxminthresh) $
	 or (strt(log[scs[i]].object) eq 'ThAr') $
	 or (strt(log[scs[i]].object) eq 'bias') $
	 or (strt(log[scs[i]].object) eq 'dark') $
	 or (strt(log[scs[i]].object) eq 'junk')) then begin
	printf, 2, greencol
	endif else printf, 2, redcol
	printf, 2, strt(mxcts22, f='(E15.2)')
	printf,2, '</td>'
	printf,2, '<td>'
	printf, 2, strt(log[scs[i]].totcts, f='(E15.2)')
	printf,2, '</td>'
	if strt(log[scs[i]].thres) ne 'NULL' then begin
	  if (double(strt(log[scs[i]].thres)) gt 0) or $
	  ((etcomp[i] eq 0) and (strt(log[scs[i]].object) ne 'bias')) then begin
		 if etcomp[scs[i]] eq 1 then begin			   
			printf, 2, '<td bgcolor =#5CEC21 align=center>'
		 endif else printf, 2, '<td bgcolor =#EC020B align=center>'
	  endif else printf,2, '<td>'
	endif else printf,2, '<td>'
	printf, 2, strt(double(log[scs[i]].emavg)*double(log[scs[i]].emnumsmp), f='(E15.2)')
	printf,2, '</td>'
	printf,2, '<td>'
	;printf, 2, strt(double(log[scs[i]].thres), f='(F15.0)')
	printf, 2, strt(log[scs[i]].thres)
	printf,2, '</td>'
	printf,2, '<td>'
	printf, 2, strt(log[scs[i]].complamp)
	printf,2, '</td>'
	istart = log[scs[i]].emtimopn
	pend = log[scs[i-1]].emtimcls
	if (strmid(istart,0,4) ne '0000' and strt(istart) ne '0' and strmid(pend,0,4) ne '0000' $
	   and strt(pend) ne 0 and i ne 0) then begin
	  istartjd = julday( $
	  strmid(istart, 5, 2), $ ;month
	  strmid(istart, 8, 2), $ ;day
	  strmid(istart, 0, 4), $ ;year
	  strmid(istart, 11, 2), $ ;hour
	  strmid(istart, 14, 2), $ ;minute
	  strmid(istart, 17, 2));second
	  pendjd = julday( $
	  strmid(pend, 5, 2), $ ;month
	  strmid(pend, 8, 2), $ ;day
	  strmid(pend, 0, 4), $ ;year
	  strmid(pend, 11, 2), $ ;hour
	  strmid(pend, 14, 2), $ ;minute
	  strmid(pend, 17, 2));second
	  ibhours = floor((istartjd-pendjd)*24d)
	  ibmins = floor((istartjd-pendjd - ibhours/24d)*24d*60d)
	  ibstring = strt(ibhours)+':'+strt(ibmins, f='(I02)')
	  if (ibhours*60d + ibmins) gt 5d then printf,2,redcol else printf,2,greencol
	endif else begin
	  pendjd = 0d
	  ibstring = ' '
	  printf,2,'<td>'
	endelse
	printf, 2, ibstring
	printf,2, '</td>'

	pend2 = log[scs[i]].emtimcls
	;GM MDPT - EM MDPT
	if (strmid(istart,0,4) ne '0000' and strt(istart) ne '0' and strmid(pend2,0,4) ne '0000' and i ne 0) then begin
	  gmmdpt = log[scs[i]].utshutjd + log[scs[i]].exptime/24d/3600d/2d
	  gmemdif = (gmmdpt - log[scs[i]].emmnwobjd)*24d*3600d
	  if abs(gmemdif) gt 60d then begin			   
		printf, 2, redcol
	  endif else printf, 2, greencol
	  printf, 2, strt(gmemdif, f='(F10.1)')
	  printf,2, '</td>'
	endif else printf,2, '<td></td>'

	;GM SHUT - EM SHUT
	if (strmid(istart,0,4) ne '0000' and strt(istart) ne '0' and strmid(pend2,0,4) ne '0000' and i ne 0) then begin
	  pend2jd = julday( $
	  strmid(pend2, 5, 2), $ ;month
	  strmid(pend2, 8, 2), $ ;day
	  strmid(pend2, 0, 4), $ ;year
	  strmid(pend2, 11, 2), $ ;hour
	  strmid(pend2, 14, 2), $ ;minute
	  strmid(pend2, 17, 2));second
	  gmshut = log[scs[i]].utshutjd + log[scs[i]].exptime/24d/3600d
	  gmemshutdif = (gmshut - pend2jd)*24d*3600d
	  if abs(gmemshutdif) gt 2d then printf, 2, redcol else printf, 2, greencol
	  printf, 2, strt(gmemshutdif, f='(F10.1)')
	  printf,2, '</td>'
	endif else printf,2, '<td></td>'
endfor
printf, 2, '</table>'

;pdir = '/mir7/quality/plots'
pdir = 'plots'
spawn, 'hostname', host
;if strmid(host, 13,14, /reverse) eq 'astro.yale.edu' then pdir = '/tous'+pdir
printf, 2, '<br>'
printf, 2, '<img src="'+pdir+'/thar/'+year+'/'+date+'ThArDisp.png" width=80% />'
printf, 2, '<br>'
printf, 2, '<img src="'+pdir+'/maxcts/'+year+'/'+date+'maxcts.png" width=80%/>'
printf, 2, '<img src="'+pdir+'/quartz/'+year+'/'+date+'quartz.png" width=80% />'
if file_test(qdir+pdir+'/acen_eff/'+year+'/'+date+'128620tot.png') then begin
  printf, 2, '<img src="'+pdir+'/acen_eff/'+year+'/'+date+'128620tot.png" width=80% />'
  printf, 2, '<img src="'+pdir+'/acen_eff/'+year+'/'+date+'128620tps.png" width=80% />'
endif
if file_test(qdir+pdir+'/acen_eff/'+year+'/'+date+'128621tot.png') then begin
  printf, 2, '<img src="'+pdir+'/acen_eff/'+year+'/'+date+'128621tot.png" width=80% />'
  printf, 2, '<img src="'+pdir+'/acen_eff/'+year+'/'+date+'128621tps.png" width=80% />'
endif
if file_test(qdir+pdir+'/bias/'+year+'/'+date+'bias11n.png') then begin
  printf, 2, '<img src="'+pdir+'/bias/'+year+'/'+date+'bias11n.png" width=80% />'
endif
if file_test(qdir+pdir+'/bias/'+year+'/'+date+'bias31n.png') then begin
  printf, 2, '<img src="'+pdir+'/bias/'+year+'/'+date+'bias31n.png" width=80% />'
endif
if file_test(qdir+pdir+'/bias/'+year+'/'+date+'bias11f.png') then begin
  printf, 2, '<img src="'+pdir+'/bias/'+year+'/'+date+'bias11f.png" width=80% />'
endif
if file_test(qdir+pdir+'/bias/'+year+'/'+date+'bias31f.png') then begin
  printf, 2, '<img src="'+pdir+'/bias/'+year+'/'+date+'bias31f.png" width=80% />'
endif
if file_test(qdir+pdir+'/guider/'+year+'/'+date+'guiderRA.png') then begin
  printf, 2, '<img src="'+pdir+'/guider/'+year+'/'+date+'guiderRA.png" width=80% />'
  printf, 2, '<img src="'+pdir+'/guider/'+year+'/'+date+'guiderdec.png" width=80% />'
  printf, 2, '<img src="'+pdir+'/guider/'+year+'/'+date+'lagRA.png" width=80% />'
  printf, 2, '<img src="'+pdir+'/guider/'+year+'/'+date+'lagdec.png" width=80% />'
endif
if file_test(qdir+pdir+'/tps/'+year+'/chipressdaypng/'+date+'chipressday.png') then begin
  printf, 2, '<img src="'+pdir+'/tps/'+year+'/chipressdaypng/'+date+'chipressday.png" width=80% />'
  printf, 2, '<img src="'+pdir+'/tps/'+year+'/dettempdaypng/'+date+'dettempday.png" width=80% />'
  printf, 2, '<img src="'+pdir+'/tps/'+year+'/insttempdaypng/'+date+'insttempday.png" width=80% />'
endif
printf, 2, '<br>'
printf, 2, '<h3>Long-Term Plots </h3>'
if file_test(qdir+pdir+'/tps/'+year+'/chipressweekpng/'+date+'chipressweek.png') then begin
  printf, 2, '<img src="'+pdir+'/tps/'+year+'/insttempweekpng/'+date+'insttempweek.png" width=80% />'
  printf, 2, '<img src="'+pdir+'/tps/'+year+'/dettempweekpng/'+date+'dettempweek.png" width=80% />'
  printf, 2, '<img src="'+pdir+'/tps/'+year+'/chipressweekpng/'+date+'chipressweek.png" width=80% />'
endif
;printf, 2, '<img src="'+pdir+'/acen_eff/'+year+'/'+date+'128620totlt.png" width=80% />'
;printf, 2, '<br>'
;printf, 2, '<img src="'+pdir+'/acen_eff/'+year+'/'+date+'128620tpslt.png" width=80% />'
;printf, 2, '<br>'
;printf, 2, '<img src="'+pdir+'/acen_eff/'+year+'/'+date+'128621totlt.png" width=80% />'
;printf, 2, '<br>'
;printf, 2, '<img src="'+pdir+'/acen_eff/'+year+'/'+date+'128621tpslt.png" width=80% />'
;printf, 2, '<br>'
;printf, 2, '<img src="'+pdir+'/thar/'+year+'/'+date+'ThArtotlt.png" width=80% />'
;printf, 2, '<br>'
;printf, 2, '<img src="'+pdir+'/thar/'+year+'/'+date+'ThArtpslt.png" width=80% />'
printf, 2, '<br>'
printf, 2, '<br>'
printf, 2, '<a href="http://exoplanets.astro.yale.edu/~jspronck/chiron/CHIRTEMP.html" target="new">'
printf, 2, '<h3>'
printf, 2, "CHIRON Environment Pages </a>"
printf, 2, '</h3>'
printf, 2, '</center>'
printf, 2, '<br>'
printf, 2, 'Created '+systime()
printf, 2, '<br>'
printf, 2, '</body>'
printf, 2, '</html>'
close, 2


chi_update_qc_index, rootdir=qdir
if keyword_set(dodopqc) then chi_update_qc_index2, rootdir=qdir
end;chi_quality.pro