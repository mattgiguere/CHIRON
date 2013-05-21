;+
;;  NAME: 
;     chi_make_logplots
;;  PURPOSE: 
;   
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      chi_make_logplots
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
;      chi_make_logplots
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2011.10.20 03:19:15 PM
;
;-
pro chi_make_logplots

dir = '/mir7/logs/pressures/chipress/'
for ii=2, 26 do begin
spawn, 'date -v -'+strt(ii)+'d "+%y%m%d"', newdate

chi_plot_ptlog, date=newdate
endfor

end;chi_make_logplots.pro