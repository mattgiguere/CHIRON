;+
;
;  NAME: 
;     chi_star_log
;
;  PURPOSE: To create log structures for all the CHIRPS targets.
;   
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      chi_star_log
;
;  INPUTS:
;		HDNUM: The Henry Draper Catalog (HD) number of the star of interest.
;		   note: if it's a b star (HR #) do NOT include the space. 
;			example: IDL>chi_star_log, log, hdnum='HR472'
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
;      chi_star_log
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2013.04.13 12:59:46
;
;-
pro chi_star_log, $
log, $
postplot = postplot, $
hdnum = hdnum

date = log[0].date
objname = strt(hdnum)
year = '20'+strmid(date,0,2)
if yalehost() then mdir='/home/matt/' else mdir='/Users/matt/'
ldir = mdir+'data/CHIRPS/starlogs/'
if file_test(mdir+'data/CHIRPS/rvs/vst'+objname+'.dat') then begin
	restore, mdir+'data/CHIRPS/rvs/vst'+objname+'.dat'
	cf3xst = 1
endif else cf3xst=0
lfn = ldir+objname+'log.dat'
;put a space in it if it's an HR star:
if strmid(objname, 0, 2) eq 'HR' then objname = 'HR '+strmid(objname, 2, strlen(objname))

;find the indeces for observations in the nightly logstructure that are of the objects of interest:
newstarob = where(strt(log.object) eq objname, newstarct)

;only do the above if there were actually observations of this star...
if newstarct gt 0 then begin

if file_test(lfn) then begin
  restore, lfn
  for i=0, newstarct-1 do begin
	already = where(strt(starlog.filename) eq strt(log[newstarob[i]].filename), alreadyct)
	if alreadyct eq 0 then begin
		if cf3xst then begin
		  x = where(strt(cf3.obnm) eq 'achi'+strt(log[newstarob[i]].date)+$
			  '.'+strt(log[newstarob[i]].seqnum), xct)
		  if xct then begin
			   log[newstarob[i]].obnm = cf3[x].obnm
			   log[newstarob[i]].cmnvel = cf3[x].mnvel
			   log[newstarob[i]].cerrvel = cf3[x].errvel
			   log[newstarob[i]].cmdvel = cf3[x].mdvel
			   log[newstarob[i]].ccts = cf3[x].cts
			   log[newstarob[i]].barycor = cf3[x].bc
		  endif;xct>0
		endif;cf3xst
		starlog = [starlog, log[newstarob[i]]]
	endif else begin;already=0
	  ;check and make sure it has the SNR, etc. If not, and it now exists b/c the reduction
	  ;code has since been run, replace it:
	  if starlog[already].snrbp5500 eq 0 and log[newstarob[i]].snrbp5500 ne 0 then starlog[already]=log[newstarob[i]]
	endelse

  endfor;newstarct loop
endif else starlog = log[newstarob]

save, starlog, filename=lfn
spawn, 'chmod 777 '+lfn
endif else print, 'There were no observations of '+objname+' on '+date

;stop
end;chi_star_log.pro