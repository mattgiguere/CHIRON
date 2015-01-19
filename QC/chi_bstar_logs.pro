;+
;
;  NAME: 
;     chi_bstar_logs
;
;  PURPOSE: 
;   
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      chi_bstar_logs
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
;      chi_bstar_logs
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2013.06.13 13:37:35
;
;-
pro chi_bstar_logs, $
postplot = postplot

angstrom = '!6!sA!r!u!9 %!6!n'
!p.color=0
!p.background=255
loadct, 39, /silent
usersymbol, 'circle', /fill, size_of_sym = 0.5
if yalehost() then mdir='/home/matt/' else mdir='/Users/matt/'

loadct, 39, /silent
usersymbol, 'circle', /fill, size_of_sym = 0.5


date = log[0].date
objname = '10700'
year = '20'+strmid(date,0,2)
ldir = '/home/matt/data/CHIRPS'
arxdir = '/home/matt/data_archive/CHIRPS/logstructs'
mdir = '/starlogs/'

spawn, 'hostname', host
;if strmid(host, 13,14, /reverse) eq 'astro.yale.edu' then ldir = '/tous'+ldir
;first test the ologs date directory, and make it for the new year if need be:
;now test the mdir directory, and make it for the new year if need be:
if ~file_test(ldir+mdir, /directory) then spawn, 'mkdir '+ldir+mdir
lfn = ldir+mdir+'bstarlog.dat'
newbstars = where(strmid(strt(log.object),0,2) eq 'HR', newbct)
if newacenct gt 0 then begin
if file_test(lfn) then begin
restore, lfn

for i=0, newacenct-1 do begin
  already = where(strt(bstarlog.filename) eq strt(log[newbstars[i]].filename), alreadyct)
  if alreadyct eq 0 then bstarlog = [bstarlog, log[newbstars[i]]]
endfor
endif else bstarlog = log[newbstars]

date = log[0].date

save, bstarlog, filename=lfn
save, bstarlog, filename=arxdir+mdir+objname+'/'+'bstarlog'+date+'.dat'
spawn, 'chmod 777 '+lfn
spawn, 'chmod 777 '+arxdir+mdir+objname+'/'+'bstarlog'+date+'.dat'
endif;newacencount gt 0 (there were observations of b stars on this night. 
stop
end;chi_bstar_logs.pro
