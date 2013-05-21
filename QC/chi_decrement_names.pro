;+
;
;  NAME: 
;     chi_decrement_names
;
;  PURPOSE: 
;   
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      chi_decrement_names
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
;	EXECUTESPAWN: Commit changes and move things. If this keyword is NOT set, 
;		then the command that will be used will be printed (for a check)
;		but nothing will have actually been moved/changed.
;	LOGMAKER: Recreate the logsheet afterwards
;	CHI_QUALITY: Recreate the QC page afterwards
;    
;  EXAMPLE:
;      chi_decrement_names
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2011.05.21 05:40:50 PM
;		-added EXECUTESPAWN keyword 2012.11.28 MJG
;		-added LOGMAKER and CHI_QUALITY keywords and the section
;		to get rid of the dashed filename too 2013.03.26 MJG
;
;-
pro chi_decrement_names, $
executespawn = executespawn, $
logmaker = logmaker, $
chi_quality = chi_quality, $
nodash = nodash, $
skipshift = skipshift

date = '130411'
dir = '/raw/mir7/'+date+'/'

;orig is the original last observation from the night:
orig = 1115L
;final is the name of the last file of the night after
;incrementing all the names:
final = 0900L
dashfile = dindgen(116)+1000L
ndashfiles = n_elements(dashfile)
nfiles = dashfile[0] - orig

prefix = 'chi'+date+'.'
;prefix = 'chi130118.'
;prefix = 'chi120514.'
;prefix = 'chi120607.'
;prefix = 'chi120302.'
suffix = '.fits'

;First shift the observation numbers of all files down by final-orig:
;set nospawn to 1 to ONLY print, and not actually move anything (for a check)
nospawn = 1
if keyword_set(executespawn) then nospawn = 0
print, 'nospawn is: ', nospawn
stop
if ~keyword_set(skipshift) then begin
  ;Shift all files:
  for i=0LL, nfiles, -1 do begin
	;command = 'mv -iv '+dir+prefix+strt(orig+i)+'-0'+suffix+' '+dir+prefix+strt(final+i, f='(I04)')+suffix
	command = 'mv -iv '+dir+prefix+strt(orig+i)+suffix+' '+dir+prefix+strt(final+i, f='(I04)')+suffix
	if nospawn then  print, command
	if ~nospawn then  spawn, command
  endfor
endif;KW:skipshift
stop
if ~keyword_set(nodash) then begin
   ;now get rid of the dash files:
   for i=0, ndashfiles-1 do begin
	 cmd2 = 'mv -iv '+dir+prefix+strt(dashfile[i], f='(I04)')+'-0'+suffix+' '+dir+prefix+strt(dashfile[i], f='(I04)')+suffix
	 if ~nospawn then spawn, cmd2
	 if nospawn then print, cmd2
   endfor
endif

if keyword_set(logmaker) then logmaker, strt(date), /nofoc, /over
if keyword_set(chi_quality) then chi_quality, date=date

stop
end;chi_decrement_names.pro
