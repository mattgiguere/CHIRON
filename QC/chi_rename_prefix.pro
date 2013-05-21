;+
;;  NAME: 
;     chi_rename_prefix
;;  PURPOSE: To change the prefix of all files in a directory. 
;   
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      chi_rename_prefix
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
;      chi_rename_prefix
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2011.09.09 09:19:14 AM
;
;-
pro chi_rename_prefix, $
spawnit = spawnit

search1 = '*.fits'
directory1 = '/mir7/raw/111003/'
directory2 = '/mir7/raw/111003/'
spawn, 'ls -1 '+directory1, filearr
;stop
oldpref = 'chi111002.'
newpref = 'chi111003.'
for i=0, n_elements(filearr)-1 do begin
;suf = strmid(filearr[i], 5, 9) ;for the "qa"s
suf = strmid(filearr[i], 10, 9) ;for the "chi"s

cmd = 'mv '+directory1+oldpref+suf+' '+directory2+newpref+suf
print, cmd
if keyword_set(spawnit) then spawn, cmd
;stop
endfor
stop
end;chi_rename_prefix.pro