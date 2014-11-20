;+
;
;  NAME: 
;     chi_change_names
;
;  PURPOSE: 
;   
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      chi_change_names
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
;	NODASHMOVE: Set this keyword to NOT move the dash file "*-0.fits", after
;		moving all the other files.
;    
;  EXAMPLE:
;      chi_change_names
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2011.05.21 05:40:50 PM
;		-added EXECUTESPAWN keyword 2012.11.28 MJG
;		-added LOGMAKER and CHI_QUALITY keywords and the section
;		to get rid of the dashed filename too 2013.03.26 MJG
;
;-
pro chi_change_names, $
executespawn = executespawn, $
logmaker = logmaker, $
chi_quality = chi_quality, $
nodashmove = nodashmove

date = '141117'
dir = '/raw/mir7/'+date+'/'

;orig is the original last observation from the night:
orig = 1328
;final is the name of the last file of the night after
;incrementing all the names:
final = 1329
dashfile = 1116
nfiles = dashfile - orig + 1

prefix = 'chi'+date+'.'
suffix = '.fits'

;First shift the observation numbers of all files up by final-orig:
;set nospawn to 1 to ONLY print, and not actually move anything (for a check)
nospawn = 1
if keyword_set(executespawn) then nospawn = 0
print, 'nospawn is: ', nospawn
;stop
for i=0LL, nfiles, -1 do begin
  command = 'mv -iv '+dir+prefix+strt(orig+i)+suffix+' '+dir+prefix+strt(final+i, f='(I04)')+suffix
  spawn, 'date "+%Y%m%d%H%M"', newdate
  if nospawn then  print, command
  if nospawn then print, 'touch -mt ' +newdate+ ' '+ dir+prefix+strt(final+i, f='(I04)')+suffix
  if ~nospawn then  spawn, command
  if ~nospawn then spawn, 'touch -mt ' +newdate+ ' '+ dir+prefix+strt(final+i, f='(I04)')+suffix
endfor
;now get rid of the dash file:
if ~keyword_set(nodashmove) then begin
  cmd2 = 'mv -iv '+dir+prefix+strt(dashfile, f='(I04)')+'-0'+suffix+' '+dir+prefix+strt(dashfile+1, f='(I04)')+suffix
  if ~nospawn then spawn, cmd2
  if nospawn then print, cmd2
endif;KW(nodashmove)

if keyword_set(logmaker) then logmaker, strt(date), /nofoc, /over
if keyword_set(chi_quality) then chi_quality, date=date

stop
end;chi_change_names.pro
