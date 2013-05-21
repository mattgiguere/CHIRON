;+
;;  NAME: 
;     chi_make_logfiles
;;  PURPOSE: 
;   
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      chi_make_logfiles
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
;      chi_make_logfiles
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2011.10.20 03:10:55 PM
;
;-
pro chi_make_logfiles
;dir = '/mir7/logs/pressures/chipress/'
dir = '/mir7/logs/temps/chitemp/'
for ii=2, 26 do begin
spawn, 'date -v -'+strt(ii)+'d "+%y%m%d"', newdate
spawn, 'cp '+dir+'chitemp111019.log '+dir+'chitemp'+newdate+'.log'
;print, 'cp '+dir+'chitemp111019.log '+dir+'chitemp'+newdate+'.log'
endfor
end;chi_make_logfiles.pro