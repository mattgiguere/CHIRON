;+
;
;  NAME: 
;     chi_get_fitspec
;
;  PURPOSE: To download all the fitspec files for a star of interest
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      chi_get_fitspec
;
;  INPUTS:
;
;  OPTIONAL INPUTS:
;	HDNUM: The HD number of the star you would like to download all of the 
;		fitspec for.
;
;  OUTPUTS:
;
;  OPTIONAL OUTPUTS:
;
;  KEYWORD PARAMETERS:
;    
;  EXAMPLE:
;      chi_get_fitspec
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2014.01.14 13:53:34
;
;-
pro chi_get_fitspec, $
postplot = postplot, $
hdnum=hdnum

if ~keyword_set(hdnum) then hdnum = '22049'
angstrom = '!6!sA!r!u!9 %!6!n'
!p.color=0
!p.background=255
loadct, 39, /silent
usersymbol, 'circle', /fill, size_of_sym = 0.5
if yalehost() then mdir='/home/matt/' else mdir='/Users/matt/'

restore, mdir+'data/CHIRPS/starlogs/'+hdnum+'log.dat'
x = where(starlog.date gt 130901)
for i=0, n_elements(starlog[x])-1 do begin
stdate = strt(starlog[x[i]].date)
fitdir = '/tous/mir7/fitspec/'+stdate+'/'
fitfn = fitdir+'achi'+stdate+'.'+strt(starlog[x[i]].seqnum)+'.fits'
spawn, 'rsync -zuva proxima.astro.yale.edu:'+fitfn+' '+fitdir
endfor

stop
end;chi_get_fitspec.pro