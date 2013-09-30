;+
;
;  NAME: 
;     chi_starlog_sunmoon
;
;  PURPOSE: To add the sun and moon information to log structures.
;		if the log structure is passed in through the log keyword, 
;		it calculates the sunang, moonang, sunalt and moonillum for
;		every object with RA, dec and midpoint info. Otherwise it
;		checks to see if "hd" was passed and calculates all the above
;		for the starlog associated with that HD number.
;   
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      chi_starlog_sunmoon
;
;  INPUTS:
;	LOG: A log structure to calculate the sun and moon info for
;
;	HD: The HD number of the starlog to calculate all the above information for
;
;  OPTIONAL INPUTS:
;
;  OUTPUTS:
;		SUNANG, MOONANG, SUNALT and MOONILLUM keywords.
;
;  OPTIONAL OUTPUTS:
;
;  KEYWORD PARAMETERS:
;    
;  EXAMPLE:
;      chi_starlog_sunmoon
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2013.09.13 10:34:17
;
;-
pro chi_starlog_sunmoon, $
postplot = postplot, $
hd = hd

angstrom = '!6!sA!r!u!9 %!6!n'
!p.color=0
!p.background=255
loadct, 39, /silent
usersymbol, 'circle', /fill, size_of_sym = 0.5
if yalehost() then mdir='/home/matt/' else mdir='/Users/matt/'

if keyword_set(hd) then begin
   hd = strt(hd)
   starlogdir = mdir+'data/CHIRPS/starlogs/'
   restore, starlogdir+hd+'log.dat'
   log = starlog
endif;kw(hd)

if ~keyword_set(hd) and ~keyword_set(log) then begin
   print, '********************************************************'
   print, 'You need to either set the HD keyword for a starlog, or '
   print, 'set the log keyword for a nightly logstructure.'
   print, '********************************************************'
   stop
endif;!log and !hd

date = log[0].date
logdir = '/tous/mir7/logstructures/20'+strmid(date, 0, 2)+'/'
logfn = logdir+date+'log.dat'
;get information on the observatory location:
observatory, 'ctio', obs_struct
obsrvtrylat=obs_struct.latitude
obsrvtrylon=-obs_struct.longitude
obsrvtryalt=obs_struct.altitude
tzoff = -obs_struct.tz/24d

for i=0, n_elements(log)-1 do begin
jd = log[i].EMMNWOBJD
sunpos, jd, rasun, decsun
moonpos, jd, ramoon, decmoon
eq2hor, rasun, decsun, jd, altsun, azsun, $
	hasun, lat=obsrvtrylat, lon=obsrvtrylon, altitude=obsrvtryalt

sunmoonang = sphdist(rasun, decsun, ramoon, decmoon, /degrees)
;fraction of moon illuminated (from 0 to 1)
moonillum = sunmoonang / 180d
moonang = sphdist(log[i].radecdeg, log[i].decdecdeg, ramoon, decmoon, /degrees)
sunang = sphdist(log[i].radecdeg, log[i].decdecdeg, rasun, decsun, /degrees)

log[i].moonillum = moonillum
log[i].moonang = moonang
log[i].sunalt = altsun
log[i].sunang = sunang
print, log[i].prefix, '.', log[i].seqnum
print, log[i].dateobs
print, 'moonillum: ', moonillum
print, 'sunang: ', sunang
print, 'altsun: ', altsun
;stop
endfor;i->nlog


;If the HD number was initially set, save to starlog,
;otherwise save the logstructure.
if keyword_set(hd) then begin
starlog = log
save, starlog, filename=starlogdir+hd+'log.dat'
endif else begin
save, log, filename=logfn
endelse

end;chi_starlog_sunmoon.pro