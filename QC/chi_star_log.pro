;+
;
;  NAME: 
;     chi_star_log
;
;  PURPOSE: To create log structures for all the CHIRPS targets.
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
objname = strt(hdnum)
year = '20'+strmid(date,0,2)
if yalehost() then mdir='/home/matt/' else mdir='/Users/matt/'
ldir = mdir+'data/CHIRPS/starlogs/'

lfn = ldir+objname+'log.dat'
newstarob = where(strt(log.object) eq objname, newstarct)
if file_test(lfn) then begin
  restore, lfn
  for i=0, newstarct-1 do begin
	already = where(strt(starlog.filename) eq strt(log[newstarob[i]].filename), alreadyct)
	if alreadyct eq 0 then starlog = [starlog, log[newstarob[i]]]
  endfor
endif else starlog = log[newstarob]

save, acenalog, filename=lfn
save, acenalog, filename=ldir+objname+'log'+date+'.dat'
spawn, 'chmod 777 '+lfn
spawn, 'chmod 777 '+ldir+objname+'log'+date+'.dat'
stop
end;chi_star_log.pro