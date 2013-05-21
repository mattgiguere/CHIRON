;+
;
;  NAME: 
;     chi_pressure_test
;
;  PURPOSE: 
;   
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      chi_pressure_test
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
;      chi_pressure_test
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2011.03.10 03:52:31 PM
;
;-
pro chi_pressure_test, $
constrain=constrain, $
fname=fname, $
post=post, $
compressor=compressor, $
nitrol=nitrol, $
nitros=nitros, $
day1=day1

;The name for labelling the plot:
if ~keyword_set(fname) then fname='pressure_test'

;The name of the file to restore:
filen='pressure_day1.csv'
if keyword_set(compressor) then begin
  filen='pressure2_compressor.csv'
  yrange=[783.5, 784.06d]
endif
if keyword_set(nitrol) then filen='pressure1_LN.csv'
if keyword_set(nitros) then filen='pressure1_LNs.csv'

pdir = '~/Documents/ASTROPHYSICS/RESEARCH/OBSERVING/'+$
		'CHIRON/COMMISSIONING/run2/pressure/'
;/Users/matt/Documents/ASTROPHYSICS/RESEARCH/OBSERVING/CHIRON/COMMISSIONING/run2/pressure/pressure_day1.csv
openr, fu, pdir+filen, /get_lun

nel=4d3
obsnum = dblarr(nel)
date = strarr(nel)
timearr = strarr(nel)
parr = dblarr(nel)
month = dblarr(nel)
day = dblarr(nel)
year = dblarr(nel)
hour = dblarr(nel)
minute = dblarr(nel)
sec = dblarr(nel)
jularr = dblarr(nel)

line=''
for i=0d, 7 do begin
  readf, fu, line
  print, line
endfor

i=0d
while ~EOF(fu) do begin
  readf, fu, line
  print, line
  vars = strsplit(line, ',', /extract)
  obsnum[i] = vars[0]
  date[i] = vars[1]
  timearr[i] = vars[2]
  parr[i] = vars[3]

;**************************************************
;			CREATE THE JULIAN DATES:
;**************************************************
;breaking it into the month day and year is a little
;more difficult than it should be since the stupid 
;Omega software doesn't include zeros. This series
;of IF statements will break the month, day, year, 
;hour, minute and second up and then create a julian
;date for plotting purposes:

;month
if strmid(date[i], 1, 1) eq '/' then begin
  month[i] = strmid(date[i], 0, 1)
  ml = 1
endif else begin
  month[i] = strmid(date[i], 0, 2)
  ml = 2
endelse
;day
if strmid(date[i], 2+ml, 1) eq '/' then begin
  day[i] = strmid(date[i], 1+ml, 1)
  dl = 1
endif else begin
  day[i] = strmid(date[i], 1+ml, 2)
  dl = 2
endelse
;year
year[i] = strmid(date[i], 2+ml+dl, 4)

;now for the time:
if strmid(timearr[i], 1, 1) eq ':' then begin
  hour[i] = strmid(timearr[i], 0, 1)
  hl = 1
endif else begin
  hour[i] = strmid(timearr[i], 0, 2)
  hl = 2
endelse

minute[i] = strmid(timearr[i], 1+hl, 2)
sec[i] = strmid(timearr[i], 4+hl, 2)
if hour[i] eq 12d then hour[i] = 0d
if strmid(timearr[i], 7+hl, 1) eq 'P' then hour[i] += 12d

jularr[i] = julday(month[i], day[i], year[i], $
					hour[i], minute[i], sec[i])
  i++
endwhile

x = where(year ne 0d)
month = month[x]
day = day[x]
year = year[x]
hour = hour[x]
minute = minute[x]
sec = sec[x]
jularr = jularr[x]
parr = parr[x]

usersymbol, 'circle', /fill

if max(jularr) - min(jularr) lt 0.1 then begin
date_label = LABEL_DATE(DATE_FORMAT = [' %I:%s'])
xtitle='Time of Observation [mm:ss]'
endif else begin
date_label = LABEL_DATE(DATE_FORMAT = ['%D %H:%I'])
xtitle='Time of Observation [day hh:mm]'
endelse

if size(yrange, /type) eq 0 then yrange = minmax(parr)

;OLD SCHOOL PLOTTING:
plot, jularr, parr, /ysty, $
xtitle=xtitle, $
ytitle = 'Pressure [mbar]', /xsty, $
XTICKFORMAT = 'LABEL_DATE', $
XTICKUNITS = 'Time', $
XTICKS = 3, $
yrange=yrange, psym=8

legendpro, fname, linestyle=0, /right


if keyword_set(post) then begin
  ;ptdir= '~/lnks/chicom/pressure/'
  pname = nextnameeps(fname)
  ;ps_open, ptdir+fname, /encaps, /color
  !p.thick = 5
  !x.thick = 5
  !y.thick = 5
endif

xleg = 0.5
if keyword_set(nitros) then xleg = 0.2
if keyword_set(compressor) then xleg = 0.3

;NEW SCHOOL PLOTTING:
p1 = plot(jularr, parr, /ysty, $
xtitle=xtitle, $
ytitle = 'Pressure [mbar]', /xsty, $
XTICKFORMAT = 'LABEL_DATE', $
XTICKUNITS = 'Time', $
XMAJOR = 3, $
yrange=yrange, $
name=fname, symbol="o", sym_filled=1, linestyle=' ', $
sym_size=0.5, $
thick = 2, xthick = 2, ythick = 2)
l = legend(target=p1, position=[xleg, 0.85], /normal)

if keyword_set(post) then p1.Save, pname+'.eps'
if keyword_set(post) then p1.Save, pname+'.png'
stop
end;chi_pressure_test.pro