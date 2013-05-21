;+
;
;  NAME: 
;     chi_dr_quality
;
;  PURPOSE: 
;   
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      chi_dr_quality
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
;      chi_dr_quality
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2012.03.15 08:00:11 PM
;
;-
pro chi_dr_quality, $
help = help, $
postplot = postplot

dates = ['120302', $
'120305', $
'120306', $
'120307', $
'120309', $
'120310', $
'120311', $
'120312', $
'120313', $
'120314']
ndates = n_elements(dates)-1
for i=0, ndates do chi_quality, date=dates[i]

stop
end;chi_dr_quality.pro