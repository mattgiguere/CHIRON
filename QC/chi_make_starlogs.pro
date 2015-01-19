;+
;
;  NAME: 
;     chi_make_starlogs
;
;  PURPOSE: 
;   
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      chi_make_starlogs
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
;      chi_make_starlogs
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2014.01.14 19:29:01
;
;-
pro chi_make_starlogs, log, starfn = starfn

spawn, 'echo $home', mdir

if ~keyword_set(starfn) then begin
   starfn = mdir+'/projects/CHIRPS/stars.txt'
endif

readcol, starfn, stars, f='A'
for i=0, n_elements(stars)-1 do begin
	dum = where(strt(log.object) eq stars[i], nobs)
	if nobs gt 0 then begin
		print, 'Now making starlog for : ', stars[i]
		chi_star_log, log, hdnum=stars[i]
	endif
endfor

;stop
end;chi_make_starlogs.pro