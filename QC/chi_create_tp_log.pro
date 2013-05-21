;+
;
;  NAME: 
;     chi_create_tp_log
;
;  PURPOSE: 
;   
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      chi_create_tp_log
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
;	DATE: The date to create the log for, in 'yymmdd' format
;	RESET: Optional keyword to create the log structure from scratch instead
;	of adding to one that already exists
;    
;  EXAMPLE:
;      chi_create_tp_log
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2012.12.06 11:18:57 AM
;
;-
pro chi_create_tp_log, $
help = help, $
postplot = postplot, $
date = date, $
reset = reset

!p.color=0
!p.background=255
loadct, 39, /silent
usersymbol, 'circle', /fill, size_of_sym = 0.5

;make sure the date was entered as a string with no spaces:
date = strt(date)
print, 'Now working on date: ', date

logdir = '/home/matt/data/CHIRPS/tps/'

;first tag is the timestamp, second tag is the corresponding JD, 3rd tag is the value:
;<-- START OF LOG 1
insttemps_i = create_struct($
'INSTTEMPTS', '', $ 
'INSTTEMPJD', 0D, $
'grating', 0D, $
'tabcen', 0D, $
'encltemp', 0D, $
'iodctemp', 0D, $
'enclsetp', 0D, $
'iodcsetp', 0D, $
'encl2', 0D, $
'tablow', 0D, $
'struct', 0d, $
'instsetp', 0d, $
'insttemp', 0d)

;<-- START OF LOG 2
dettemps_i = create_struct($
'DETTEMPTS', '', $
'DETTEMPJD', 0D, $
'ccdtemp', 0D, $
'necktemp', 0D, $
'ccdsetp', 0D)

;<-- START OF LOG 3 (same as chitemp)
chipress_i = create_struct($
'CHIPRESSTS', '', $
'CHIPRESSJD', 0D, $
'barometer', 0D, $
'echpress', 0D)

;if the keyword "reset" is set, then it will create a new log from scratch, 
;otherwise it will restore the old log structure and append information to
;that. 
if ~keyword_set(reset) then begin
  restore, logdir+'insttemp.sav'
  restore, logdir+'chipress.sav'
  restore, logdir+'dettemps.sav'
endif

;********************************************************************
;        NOW OPENING THE INSTTEMP LOG
;********************************************************************
;EXAMPLE LINE FROM AN INSTTEMP LOG FILE:
;2012-12-11T08:29:58 GRATING= 21.0720 TABCEN= 21.2340 ENCLTEMP= 19.0000 IODCTEMP= 40.1000 ENCLSETP= 20.0000 IODCSETP= 40.0000 ENCL2= 18.8840 TABLOW= 21.2020 STRUCT= 21.0590 INSTSETP= 21.0000 INSTTEMP= 21.0090
filename = '/tous/mir7/logs/temps/insttemp/insttemp'+date+'.log'
if file_test(filename) then begin
if long(date) gt 120101 then begin
readcol, filename, dates, bla1, grating, bla2, tabcen, bla3, room, $
	bla4, iodtemp, bla6, roomset, bla71, iodsetp, bla72, encl2, bla8, tablow, $
	bla9, struct, bla10, instsetp, bla11, insttempv,delimit=' ', $
	f = 'A,A,D,A,D,A,D,A,D,A,D,A,D,A,D,A,D,A,D,A,D,A,D', /silent
endif else begin
readcol, filename, dates, bla1, grating, bla2, tabcen, bla3, room, $
	bla4, tablow, bla5, struct, delimit=' ', f = 'A,A,D,A,D,A,D,A,D,A,D', /silent
	
endelse

;calculate the julian date for each entry:
jds = dblarr(n_elements(dates))
jds = julday(strmid(dates, 5, 2), strmid(dates, 8, 2), $
strmid(dates, 0, 4), strmid(dates, 11, 2), $
strmid(dates, 14, 2), strmid(dates, 17, 2) )

;files can typically have many days worth of data in them. This section determines
;which indeces are for the particular day of interest (+/-1 since
;logs are discontinuous):
;The "dates" variable is from the CTIO log, and is in the format yyyy-mm-dd
;the "date" variable is in my format, yymmdd, hence the STRMIDs:

;make the dates in a better format:
datesbf = long(strmid(strt(dates), 2,2)+strmid(dates,5,2)+strmid(dates,8,2))
x = where(datesbf ge date-1L AND  datesbf le date+1L, ndays)

if ndays gt 0 then begin
  insttemp_new = replicate(insttemps_i, ndays)
  insttemp_new.insttempts = dates[x]
  insttemp_new.insttempjd = jds[x]
  insttemp_new.grating = grating[x]
  insttemp_new.tabcen = tabcen[x]
  insttemp_new.encltemp = room[x]
  insttemp_new.iodctemp = iodtemp[x]
  insttemp_new.enclsetp = roomset[x]
  insttemp_new.iodcsetp = iodsetp[x]
  insttemp_new.encl2 = encl2[x]
  insttemp_new.tablow = tablow[x]
  insttemp_new.struct = struct[x]
  insttemp_new.instsetp = instsetp[x]
  insttemp_new.insttemp = insttempv[x]
  
  if ~keyword_set(reset) then begin
	;now add them to the existing structure, but don't add duplicates:
	for i=0, ndays-1 do begin
	  dup = where(strt(insttemp.insttempts) eq strt(insttemp_new[i].insttempts), ndups)
	  if ndups lt 1 then insttemp = [insttemp, insttemp_new[i]]
	endfor
  endif else insttemp = insttemp_new
  save, insttemp, filename=logdir+'insttemp.sav'
endif;ndays > 0
endif;filetest(filename)

;********************************************************************
;        NOW OPENING THE DETTEMP LOG
;********************************************************************
dettfn = '/tous/mir7/logs/temps/dettemp/dettemp'+date+'.log'
if file_test(dettfn) then begin
readcol, dettfn, dtdates, bla1, ccdtemps, bla2, necktemps, bla3, ccdsetp, $
delimit=' ', f = 'A,A,D,A,D,A,D', /silent

dtjds = dblarr(n_elements(dtdates))


dtjds = julday(strmid(dtdates, 5, 2), strmid(dtdates, 8, 2), $
strmid(dtdates, 0, 4), strmid(dtdates, 11, 2), $
strmid(dtdates, 14, 2), strmid(dtdates, 17, 2) )
;stop

;files can typically have many days worth of data in them. This section determines
;which indeces are for the particular day of interest (+/-1 since
;logs are discontinuous):
;The "dates" variable is from the CTIO log, and is in the format yyyy-mm-dd
;the "date" variable is in my format, yymmdd, hence the STRMIDs:
dtdatesbf = long(strmid(strt(dtdates), 2,2)+strmid(dtdates,5,2)+strmid(dtdates,8,2))
x2 = where(dtdatesbf ge date-1L AND  dtdatesbf le date+1L, ndays)

if ndays gt 0 then begin
  dettemps_new = replicate(dettemps_i, ndays)
  dettemps_new.dettempts = dtdates[x2]
  dettemps_new.dettempjd = dtjds[x2]
  dettemps_new.ccdtemp = ccdtemps[x2]
  dettemps_new.necktemp = necktemps[x2]
  dettemps_new.ccdsetp = ccdsetp[x2]
  
  if ~keyword_set(reset) then begin
	;now add them to the existing structure, but don't add duplicates:
	for i=0, ndays-1 do begin
	  dup = where(strt(dettemps.dettempts) eq strt(dettemps_new[i].dettempts), ndups)
	  if ndups lt 1 then dettemps = [dettemps, dettemps_new[i]]
	endfor
  endif else dettemps = dettemps_new
  save, dettemps, filename=logdir+'dettemps.sav'
endif
endif;filetest(dettfn)

;********************************************************************
;        NOW OPENING THE INSTPRESS LOG
;********************************************************************
chipfn = '/tous/mir7/logs/pressures/chipress/chipress'+date+'.log'
if file_test(chipfn) then begin
readcol, chipfn, cpdates, bla1, cpbar, bla2, cpech, $
delimit=' ', f = 'A,A,D,A,D', /silent

cpjds = dblarr(n_elements(cpdates))


cpjds = julday(strmid(cpdates, 5, 2), strmid(cpdates, 8, 2), $
strmid(cpdates, 0, 4), strmid(cpdates, 11, 2), $
strmid(cpdates, 14, 2), strmid(cpdates, 17, 2) )

;files can typically have many days worth of data in them. This section determines
;which indeces are for the particular day of interest (+/-1 since
;logs are discontinuous):
;The "dates" variable is from the CTIO log, and is in the format yyyy-mm-dd
;the "date" variable is in my format, yymmdd, hence the STRMIDs:
cpdatesbf = long(strmid(strt(cpdates), 2,2)+strmid(cpdates,5,2)+strmid(cpdates,8,2))
x3 = where(cpdatesbf ge date-1L AND  cpdatesbf le date+1L, cpndays)

if cpndays gt 0 then begin
  chipress_new = replicate(chipress_i, cpndays)
  chipress_new.chipressts = cpdates[x3]
  chipress_new.chipressjd = cpjds[x3]
  chipress_new.barometer = cpbar[x3]
  chipress_new.echpress = cpech[x3]
  
  if ~keyword_set(reset) then begin
	;now add them to the existing structure, but don't add duplicates:
	for i=0, cpndays-1 do begin
	  dup = where(strt(chipress.chipressts) eq strt(chipress_new[i].chipressts), ndups)
	  if ndups lt 1 then chipress = [chipress, chipress_new[i]]
	endfor
  endif else chipress = chipress_new
  save, chipress, filename=logdir+'chipress.sav'
endif
endif;filetest(chipfn)

end;chi_create_tp_log.pro

;********************************************************************
;********************************************************************

;********************************************************************
;********************************************************************

;********************************************************************
;********************************************************************

;********************************************************************
;********************************************************************

;********************************************************************
;********************************************************************

;********************************************************************
;********************************************************************

;********************************************************************
;********************************************************************

;********************************************************************
;********************************************************************

;OLD VERSIONS:
;********************************************************************
;1. THE DEWAR PRESSURE
;********************************************************************
;logdir = '/tous/mir7/logs/'
;filename = logdir+'pressures/dewpress/dewpress'+date+'.log'
;readcol, filename, dates, bla1, pressure, delimit=' ', f = 'A,A,D', /silent
;
;pjds = dblarr(n_elements(dates))
;;stop
;pjds = julday(strmid(dates, 5, 2), strmid(dates, 8, 2), $
;strmid(dates, 0, 4), strmid(dates, 11, 2), $
;strmid(dates, 14, 2), strmid(dates, 17, 2) )
;
;x1 = where(pjds gt max(pjds) -1d)
;
;; Create format strings for a two-level axis:
;dummy = LABEL_DATE(DATE_FORMAT=['%D-%M %H:%I'])
; 
;p1 = plot(pjds[x1], pressure[x1], symbol="o", $
;xstyle=1, $
;xtickformat='LABEL_DATE', $
;xtitle='Observation Time', $
;ytitle='Pressure [Torr]', $
;title='Dewar Pressure For '+date, $
;name='Dewar Pressure', $
;/sym_filled, $
;sym_size = 0.5, $
;xtickvalues = [min(pjds[x1]), median(pjds[x1]), max(pjds[x1])], $
;margin = [0.175, 0.09, 0.08, 0.075])
;
;p1.Save, nextname('/tous/mir7/plot_logs/pressures/dewpress/'+date+'dewpress', '.png')

;********************************************************************
;2. THE ROOM TEMPERATURE
;********************************************************************
if keyword_set(overdewpress) then begin
	scrm = (room[x2] - min(room[x2]))/ (max(room[x2]) - min(room[x2])) * max(pressure[x1])
	p2 = plot(jds[x2], scrm, symbol="o", $
	xstyle=1, $
	xtickformat='LABEL_DATE', $
	xtitle='Observation Time', $
	ytitle='Temp [C]', $
	title='Room Temp '+date, $
	name='ROOM', $
	/sym_filled, $
	sym_size = 0.25, $
	xtickvalues = [min(jds[x2]), median(jds[x2]), max(jds[x2])], $
	margin = [0.175, 0.09, 0.08, 0.075], $
	sym_fill_color = "red", color='red', /over)
endif else begin
	p2 = plot(jds[x2], room[x2], symbol="o", $
	xstyle=1, $
	xtickformat='LABEL_DATE', $
	xtitle='Observation Time', $
	ytitle='Temp [C]', $
	title='Room Temp '+date, $
	name='ROOM', $
	/sym_filled, $
	sym_size = 0.25, $
	xtickvalues = [min(jds[x2]), median(jds[x2]), max(jds[x2])], $
	margin = [0.175, 0.09, 0.08, 0.075], $
	sym_fill_color = "red", color='red')
endelse

p2.Save, nextname('/tous/mir7/plot_logs/temps/insttemp/room/'+date+'room', '.png')

;stop

;********************************************************************
;2. THE I2 CELL TEMPERATURE
;********************************************************************
	p2 = plot(jds[x2], iodtemp[x2], symbol="o", $
	xstyle=1, $
	xtickformat='LABEL_DATE', $
	xtitle='Observation Time', $
	ytitle='I2 Cell Temp [C]', $
	title='Iodine Cell Temp '+date, $
	name='IODCELL', $
	/sym_filled, $
	sym_size = 0.25, $
	xtickvalues = [min(jds[x2]), median(jds[x2]), max(jds[x2])], $
	margin = [0.175, 0.09, 0.08, 0.075], $
	sym_fill_color = "red", color='red')

p2.Save, nextname('/tous/mir7/plot_logs/temps/insttemp/iodcell/'+date+'iodcell', '.png')

;stop

;********************************************************************
;6. THE GRATING TEMPERATURE
;********************************************************************
p6 = plot(jds[x2], grating[x2], symbol="o", $
	xstyle=1, $
	xtickformat='LABEL_DATE', $
	xtitle='Observation Time', $
	ytitle='Temp [C]', $
	title='CHIRON Temps '+date, $
	name='Grating', $
	/sym_filled, $
	sym_size = 0.25, $
	xtickvalues = [min(jds[x2]), median(jds[x2]), max(jds[x2])], $
	margin = [0.175, 0.09, 0.08, 0.075], $
	sym_fill_color = "red", color='red')

p7 = plot(jds[x2], tabcen[x2], $
	name='TABCEN', $
    symbol="o", $
	/sym_filled, $
	sym_size = 0.25, $
	sym_fill_color = "blue", color='blue', /over)

p8 = plot(jds[x2], tablow[x2], $
	name='TABLOW', $
    symbol="o", $
	/sym_filled, $
	sym_size = 0.25, $
	sym_fill_color = "green", color='green', /over)

p9 = plot(jds[x2], struct[x2], $
	name='STRUCT', $
    symbol="o", $
	/sym_filled, $
	sym_size = 0.25, $
	sym_fill_color = "orange", color='orange', /over)

l1 = legend(target=[p6, p7, p8, p9], position=[0.7, 0.8])

;stop
p9.Save, nextname('/tous/mir7/plot_logs/temps/insttemp/chiron/'+date+'chironts', '.png')
;stop

;********************************************************************
;3. THE CCD TEMPERATURE
;********************************************************************

p3 = plot(dtjds[x3], ccdtemps[x3], symbol="o", $
xstyle=1, $
xtickformat='LABEL_DATE', $
xtitle='Observation Time', $
ytitle='Temp [C]', $
title='CCD TEMP '+date, $
name='CCD TEMP', $
/sym_filled, $
sym_size = 0.25, $
xtickvalues = [min(dtjds[x3]), median(dtjds[x3]), max(dtjds[x3])], $
margin = [0.175, 0.09, 0.08, 0.075], $
sym_fill_color = "red", color='red')

p3.Save, nextname('/tous/mir7/plot_logs/temps/dettemp/ccdtemp/'+date+'ccdtemp', '.png')


;********************************************************************
;4. THE CCD SET POINT
;********************************************************************

p4 = plot(dtjds[x3], ccdsetp[x3], symbol="o", $
xstyle=1, $
xtickformat='LABEL_DATE', $
xtitle='Observation Time', $
ytitle='Temp [C]', $
title='CCD SETPOINT '+date, $
name='CCD SETP', $
/sym_filled, $
sym_size = 0.25, $
xtickvalues = [min(dtjds[x3]), median(dtjds[x3]), max(dtjds[x3])], $
margin = [0.175, 0.09, 0.08, 0.075], $
sym_fill_color = "red", color='red')

p4.Save, nextname('/tous/mir7/plot_logs/temps/dettemp/ccdsetp/'+date+'ccdsetp', '.png')

;********************************************************************
;5. THE NECK TEMPERATURE
;********************************************************************
if keyword_set(overdewpress) then begin
	scrm = (necktemps[x3] - min(necktemps[x3]))/ $
		(max(necktemps[x3]) - min(necktemps[x])) * max(pressure[x1])
	
	
	p5 = plot(dtjds[x3], scrm, symbol="o", $
	;xstyle=1, $
	;xtickformat='LABEL_DATE', $
	;xtitle='Observation Time', $
	;ytitle='Temp [C]', $
	;title='NECK TEMP '+date, $
	;name='NECK TEMP', $
	/sym_filled, $
	sym_size = 0.25, $
	;xtickvalues = [min(dtjds[x3]), median(dtjds[x3]), max(dtjds[x3])], $
	;margin = [0.175, 0.09, 0.08, 0.075], $
	sym_fill_color = "red", color='red', /over)
endif else begin
	
	p5 = plot(dtjds[x3], necktemps[x3], symbol="o", $
	xstyle=1, $
	xtickformat='LABEL_DATE', $
	xtitle='Observation Time', $
	ytitle='Temp [C]', $
	title='NECK TEMP '+date, $
	name='NECK TEMP', $
	/sym_filled, $
	sym_size = 0.25, $
	xtickvalues = [min(dtjds[x3]), median(dtjds[x3]), max(dtjds[x3])], $
	margin = [0.175, 0.09, 0.08, 0.075], $
	sym_fill_color = "red", color='red')
	
endelse



;stop

p5.Save, nextname('/tous/mir7/plot_logs/temps/dettemp/necktemp/'+date+'necktemp', '.png')

;********************************************************************
;6. CHIRON TEMPERATURE FROM PRESSURE TRANSDUCER
;********************************************************************

p6 = plot(cpjds[x6], cptemps[x6], symbol="o", $
xstyle=1, $
xtickformat='LABEL_DATE', $
xtitle='Observation Time', $
ytitle='Temp [C]', $
title='CHI TEMP '+date, $
name='CHI TEMP', $
/sym_filled, $
sym_size = 0.25, $
xtickvalues = [min(cpjds[x6]), median(cpjds[x6]), max(cpjds[x6])], $
margin = [0.175, 0.09, 0.08, 0.075], $
sym_fill_color = "red", color='red')

p6.Save, nextname('/tous/mir7/plot_logs/temps/chitemp/'+date+'chitemp', '.png')

;********************************************************************
;7. CHIRON PRESSURE FROM PRESSURE TRANSDUCER
;********************************************************************

p7 = plot(cpjds[x6], cppress[x6]*1.33322d, symbol="o", $
xstyle=1, $
xtickformat='LABEL_DATE', $
xtitle='Observation Time', $
ytitle='Pressure [mbar]', $
title='CHI PRESS '+date, $
name='CHI PRESS', $
/sym_filled, $
sym_size = 0.25, $
xtickvalues = [min(cpjds[x6]), median(cpjds[x6]), max(cpjds[x6])], $
margin = [0.175, 0.09, 0.08, 0.075], $
sym_fill_color = "red", color='red')

p7.Save, nextname('/tous/mir7/plot_logs/pressures/chipress/'+date+'ccdpress', '.png')
