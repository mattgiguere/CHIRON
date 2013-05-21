;+
;;  NAME: 
;     chi_comp_em_data
;;  PURPOSE: 
;   To plot the exposure meter data and compare it to the totaled photons from each observation. 
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      chi_comp_em_data
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
;      chi_comp_em_data
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2011.06.15 02:03:32 PM
;
;-
pro chi_comp_em_data

emctsf = '/mir7/expmeter/asciis/20110613213658.asc'

readcol, emctsf, emtimes, emcts, delim=' '
emhrs = emtimes/3600d

plot, emhrs, emcts, ps=8, /xsty

;stop
;now just get alpha cen A with the slicer:
x = where( (emhrs lt 24.15) and (emhrs gt 23.85))

;ps_open, 'ExpMeterComparison', /encaps, /color
;usersymbol, 'circle', /fill, size_of_sym=0.5
;plot, emhrs[x], emcts[x], ps=-8, /xsty, $
;ytitle='Count Rate', xtitle='Timestamp/3600', /ysty


p1 = plot(emhrs[x], emcts[x]/max(emcts[x]), $
symbol='circle', $
/xsty, $
ytitle='Normalized Value', $
xtitle='Timestamp/3600', $
sym_size=0.5, $
/sym_filled, $
sym_fill_color='black', $
name='Exp Meter', $
yrange=[0, 1.3],$
/fill_background, $
title='HD 1289620 Slicer Data from 110613' )
;stop


prefix = '/mir7/fitspec/rqa37.'
init_obs = 6422L
nel = 40

counts = dblarr(nel)
utshuts = strarr(nel)
uts = strarr(nel)
ras = strarr(nel)
decs = strarr(nel)
alt = dblarr(nel)
has = strarr(nel)
zds = dblarr(nel)
airmasses = strarr(nel)
weatimes = strarr(nel)
outtemps = dblarr(nel)
outhums = dblarr(nel)
outpresses = dblarr(nel)
wndspeeds = dblarr(nel)
seeings = dblarr(nel)
sairmasses = dblarr(nel)




;now to restore each file and sum the number of counts:
for i=0L, nel-1 do begin
fitsfl       = mrdfits(prefix+strt(init_obs+i)+'.fits', 0, header)
counts[i]    = total(fitsfl[1,*,*])
utshuts[i]   = sxpar(header, 'UTSHUT')
uts[i]       = sxpar(header, 'UT')
ras[i]       = sxpar(header, 'RA')
decs[i]      = sxpar(header, 'DEC')
alt[i]       = sxpar(header, 'ALT')
has[i]       = sxpar(header, 'HA')
zds[i]       = sxpar(header, 'ZD')
airmasses[i] = sxpar(header, 'AIRMASS')
weatimes[i]       = sxpar(header, 'WEATIME')
outtemps[i]       = sxpar(header, 'OUTTEMP')
OUTHUMS[i]       = sxpar(header, 'OUTHUM')
OUTPRESSES[i]       = sxpar(header, 'OUTPRESS')
WNDSPEEDS[i]       = sxpar(header, 'WNDSPEED')
SEEINGS[i]       = sxpar(header, 'SEEING')
SAIRMASSES[i]       = sxpar(header, 'SAIRMASS')
endfor

;stop
rans = dblarr(nel)
hans = dblarr(nel)
decns = dblarr(nel)
utshutns = dblarr(nel)
for i=0, nel-1 do rans[i] = time2number(ras[i])
for i=0, nel-1 do hans[i] = time2number(has[i])
for i=0, nel-1 do utshutns[i] = time2number(strmid(utshuts[i], 11, 11))
for i=0, nel-1 do decns[i] = time2number(decs[i])

;window, /free
loadct, 39, /silent
;usersymbol, 'circle', /fill, size_of_sym=1


p2 = plot(utshutns+19d, counts/max(counts), symbol='o', /sym_filled, sym_color='red', linestyle='none', name='Total e!u-!n from CCD', /over)

l1 = legend(target=[p1, p2], position=[0.55, 0.85], /normal)

chidir = '/home/matt/Documents/ASTROPHYSICS/RESEARCH/OBSERVING/CHIRON/EXPMETERCOMP/'
;p1.Save, nextname(chidir+'totcts', '.png')
;stop


p1 = plot(emhrs[x], emcts[x]/max(emcts[x]), $
symbol='circle', $
/xsty, $
ytitle='Normalized Value', $
xtitle='Timestamp/3600', $
sym_size=0.5, $
/sym_filled, $
sym_fill_color='black', $
name='Exp Meter', $
yrange=[0, 1.3],$
/fill_background, $
title='HD 1289620 Slicer Data from 110613' )

p2 = plot( utshutns+19d, (rans - 14.6590d)/(max(rans - 14.6590d)), symbol='o', /sym_filled, sym_color='blue', linestyle='none', name='RA', /over)
l1 = legend(target=[p1, p2], position=[0.55, 0.85], /normal)
;p1.Save, nextname(chidir+'RA', '.png')
;stop

p1 = plot(emhrs[x], emcts[x]/max(emcts[x]), $
symbol='circle', $
/xsty, $
ytitle='Normalized Value', $
xtitle='Timestamp/3600', $
sym_size=0.5, $
/sym_filled, $
sym_fill_color='black', $
name='Exp Meter', $
yrange=[0, 1.3],$
/fill_background, $
title='HD 1289620 Slicer Data from 110613' )
var = hans

p2 = plot( utshutns+19d, var/max(var), symbol='o', /sym_filled, sym_color='blue', linestyle='none', name='HA', /over)
l1 = legend(target=[p1, p2], position=[0.55, 0.85], /normal)


;p1.Save, nextname(chidir+'HA', '.png')
;stop

p1 = plot(emhrs[x], emcts[x]/max(emcts[x]), $
symbol='circle', $
/xsty, $
ytitle='Normalized Value', $
xtitle='Timestamp/3600', $
sym_size=0.5, $
/sym_filled, $
sym_fill_color='black', $
name='Exp Meter', $
yrange=[0, 1.3],$
/fill_background, $
title='HD 1289620 Slicer Data from 110613' )

res = linfit(utshutns+19d, hans)
hansl = hans - res[1]*(utshutns+19d) - res[0]
hansl += abs(min(hansl))
var = hansl

p2 = plot( utshutns+19d, var/max(var), symbol='o', /sym_filled, sym_color='blue', linestyle='none', name='HA - LINFIT', /over)
l1 = legend(target=[p1, p2], position=[0.55, 0.85], /normal)
;p1.Save, nextname(chidir+'HA-LINFIT', '.png')
;stop


p1 = plot(emhrs[x], emcts[x]/max(emcts[x]), $
symbol='circle', $
/xsty, $
ytitle='Normalized Value', $
xtitle='Timestamp/3600', $
sym_size=0.5, $
/sym_filled, $
sym_fill_color='black', $
name='Exp Meter', $
yrange=[0, 1.3],$
/fill_background, $
title='HD 1289620 Slicer Data from 110613' )

var = seeings

p2 = plot( utshutns+19d, var/max(var), symbol='o', /sym_filled, sym_color='blue', linestyle='none', name='seeing', /over)
l1 = legend(target=[p1, p2], position=[0.55, 0.85], /normal)
;p1.Save, nextname(chidir+'seeing', '.png')
;stop



;plot, emhrs[x], emcts[x]/(1.25d * max(emcts[x])), ps=-8, /xsty, $
;ytitle='Normalized', xtitle='Timestamp/3600', /ysty, yrange=[0d, 1d]



;var = (rans - 14.659)
;oplot, utshutns+19d, var/(1.5d * max(var)), ps=8, color=80
;var = -1d * (decns + 60.833d)
;oplot, utshutns+19d, var/(1.5d * max(var)), ps=8, color=100

;var = seeings
;oplot, utshutns+19d, var/(1.5d * max(var)), ps=8, color=140

;var = seeings
;oplot, utshutns+19d, var/(1.5d * max(var)), ps=8, color=140




;********************************************************************
; NOW FOR SOME PERIODOGRAMS...
;********************************************************************
cf_em = create_struct('jd', emhrs[x]/24d, 'mnvel', emcts[x])
pergram, cf_em, pmin = 1d / (24d * 60d), /verbose

cf_ra = create_struct('jd', utshutns+19d, 'mnvel', (rans - 14.659))








;ps_close
stop
end;chi_comp_em_data.pro