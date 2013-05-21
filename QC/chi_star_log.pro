;+
;
;  NAME: 
;     chi_star_log
;
;  PURPOSE: 
;   
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      chi_star_log
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
;      chi_star_log
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2013.04.13 12:59:46
;
;-
pro chi_star_log, $
postplot = postplot, $
hdnum = hdnum

date = log[0].date
objname = hdnum
year = '20'+strmid(date,0,2)
ldir = '/home/matt/idl/CHIRON/logstructs'
mdir = '/ologs/acenalogs/'
spawn, 'hostname', host
;if strmid(host, 13,14, /reverse) eq 'astro.yale.edu' then ldir = '/tous'+ldir
;first test the ologs date directory, and make it for the new year if need be:
if ~file_test(ldir+'/ologs', /directory) then spawn, 'mkdir '+ldir+'/ologs'
;now test the mdir directory, and make it for the new year if need be:
if ~file_test(ldir+mdir, /directory) then spawn, 'mkdir '+ldir+mdir
lfn = ldir+mdir+'acenalog.dat'
newacena = where(strt(log.object) eq '128620', newacenct)
if file_test(lfn) then begin
restore, lfn

for i=0, newacenct-1 do begin
  already = where(strt(acenalog.filename) eq strt(log[newacena[i]].filename), alreadyct)
  if alreadyct eq 0 then acenalog = [acenalog, log[newacena[i]]]
endfor
endif else acenalog = log[newacena]

lfn = ldir+mdir+'acenalog.dat'
save, acenalog, filename=lfn
save, acenalog, filename=ldir+mdir+'acenalog'+date+'.dat'
spawn, 'chmod 777 '+lfn
spawn, 'chmod 777 '+ldir+mdir+'acenalog'+date+'.dat'


stop
end;chi_star_log.pro