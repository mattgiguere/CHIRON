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
pro chi_make_starlogs, log

spawn, 'echo $home', mdir

starfn = mdir+'/projects/CHIRPS/stars.txt'

readcol, starfn, stars, f='A'
for i=0, n_elements(stars)-1 do begin
	chi_star_log, log, hdnum=stars[i]
endfor

stop
end;chi_make_starlogs.pro