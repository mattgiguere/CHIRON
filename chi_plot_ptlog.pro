;+
;
;  NAME: 
;     chi_plot_PTlog
;
;  PURPOSE: 
;   
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      chi_plot_PTlog
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
;      chi_plot_PTlog
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2011.07.12 07:23:34 PM
;
;-
pro chi_plot_ptlog, date = date

if ~keyword_set(date) then date = '110604'
date = strt(date)

;********************************************************************
;1. THE DEWAR PRESSURE
;********************************************************************
logdir = '/tous/mir7/logs/'
filename = logdir+'pressures/dewpress/dewpress'+date+'.log'
readcol, filename, dates, bla1, pressure, delimit=' ', f = 'A,A,D', /silent

pjds = dblarr(n_elements(dates))
;stop
pjds = julday(strmid(dates, 5, 2), strmid(dates, 8, 2), $
strmid(dates, 0, 4), strmid(dates, 11, 2), $
strmid(dates, 14, 2), strmid(dates, 17, 2) )

x1 = where(pjds gt max(pjds) -1d)

; Create format strings for a two-level axis:
dummy = LABEL_DATE(DATE_FORMAT=['%D-%M %H:%I'])
 
p1 = plot(pjds[x1], pressure[x1], symbol="o", $
xstyle=1, $
xtickformat='LABEL_DATE', $
xtitle='Observation Time', $
ytitle='Pressure [Torr]', $
title='Dewar Pressure For '+date, $
name='Dewar Pressure', $
/sym_filled, $
sym_size = 0.5, $
xtickvalues = [min(pjds[x1]), median(pjds[x1]), max(pjds[x1])], $
margin = [0.175, 0.09, 0.08, 0.075])

p1.Save, nextname('/tous/mir7/plot_logs/pressures/dewpress/'+date+'dewpress', '.png')

;********************************************************************
;        NOW OPENING THE INSTTEMP LOG
;********************************************************************
filename = '/tous/mir7/logs/temps/insttemp/insttemp'+date+'.log'
if long(date) gt 120101 then begin
readcol, filename, dates, bla1, grating, bla2, tabcen, bla3, room, bla4, tablow, bla5, struct, delimit=' ', f = 'A,A,D,A,D,A,D,A,D,A,D', /silent
endif else begin
readcol, filename, dates, bla1, grating, bla2, tabcen, bla3, room, bla4, iodtemp, bla6, roomset, bla7,encl2,bla8,tablow, bla5, struct, insttemp, bla9,delimit=' ', f = 'A,A,D,A,D,A,D,A,D,A,D,A,D,A,D,A,D,A,D', /silent
endelse

jds = dblarr(n_elements(dates))
;stop
jds = julday(strmid(dates, 5, 2), strmid(dates, 8, 2), $
strmid(dates, 0, 4), strmid(dates, 11, 2), $
strmid(dates, 14, 2), strmid(dates, 17, 2) )

x2 = where(jds gt max(jds) -1d)

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
;        NOW OPENING THE DETTEMP LOG
;********************************************************************
dettfn = '/tous/mir7/logs/temps/dettemp/dettemp'+date+'.log'
readcol, dettfn, dtdates, bla1, ccdtemps, bla2, necktemps, bla3, ccdsetp, $
delimit=' ', f = 'A,A,D,A,D,A,D', /silent

dtjds = dblarr(n_elements(dtdates))


dtjds = julday(strmid(dtdates, 5, 2), strmid(dtdates, 8, 2), $
strmid(dtdates, 0, 4), strmid(dtdates, 11, 2), $
strmid(dtdates, 14, 2), strmid(dtdates, 17, 2) )
;stop
x3 = where(dtjds gt max(dtjds) -1d)


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
;        NOW OPENING THE INSTPRESS LOG
;********************************************************************
chipfn = '/tous/mir7/logs/temps/chitemp/chitemp'+date+'.log'
readcol, chipfn, cpdates, bla1, cptemps, bla2, cppress, $
delimit=' ', f = 'A,A,D,A,D', /silent

cpjds = dblarr(n_elements(cpdates))


cpjds = julday(strmid(cpdates, 5, 2), strmid(cpdates, 8, 2), $
strmid(cpdates, 0, 4), strmid(cpdates, 11, 2), $
strmid(cpdates, 14, 2), strmid(cpdates, 17, 2) )
;stop
x6 = where(cpjds gt max(cpjds) -1d)


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


;stop
end;chi_plot_ptlog.pro