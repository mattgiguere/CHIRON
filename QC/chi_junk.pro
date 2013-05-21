;+
;
;  NAME: 
;     chi_junk
;
;  PURPOSE: To change the image name from what it was previously
;			to junk.
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      chi_junk
;
;  INPUTS:
;		DATE: The date of the observations to junk in the format
;			yymmdd. It can be either a string or a long.
;	
;		SEQNUM:	The sequence number (or array of numbers) to
;			junk. 
;
;		STARTNUM: If you'd like to junk a large range of observations
;			instead of entering the individual sequence numbers, use
;			the STARTNUM to enter the starting sequence number, and 
;			ENDNUM to enter the ending sequence number. 
;
;		ENDNUM: See the description of STARTNUM above.
;
;		LOGMAKER: Set this keyword if you'd like to regenerate the 
;			logsheet to put the junked object names in place
;
;		CHI_QUALITY: Set this keyword if you'd like to regenerate
;			the CHIRON quality control page after junking the
;			object name.
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
;      chi_junk
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2012.08.13 11:42:43 AM
;
;-
pro chi_junk, $
help = help, $
postplot = postplot, $
date=date, $
seqnum=seqnum, $
startnum=startnum, $
endnum=endnum, $
logmaker=logmaker, $
chi_quality=chi_quality, $
reason=reason

if ~keyword_set(date) then begin 
  print, '***YOU NEED TO ENTER A DATE.***'
  help = 1
endif

if keyword_set(help) then begin
	print, '*************************************************'
	print, '*************************************************'
	print, '        HELP INFORMATION FOR chi_junk'
	print, 'KEYWORDS: '
	print, ''
	print, 'HELP: Use this keyword to print all available arguments'
	print, ''
	print, ';  INPUTS:''
	print, ';		DATE: The date of the observations to junk in the format'
	print, ';			yymmdd. It can be either a string or a long.'
	print, ';	'
	print, ';		SEQNUM:	The sequence number (or array of numbers) to'
	print, ';			junk. '
	print, ';'
	print, ';		STARTNUM: If youd like to junk a large range of observations'
	print, ';			instead of entering the individual sequence numbers, use'
	print, ';			the STARTNUM to enter the starting sequence number, and '
	print, ';			ENDNUM to enter the ending sequence number. '
	print, ';'
	print, ';		ENDNUM: See the description of STARTNUM above.'
	print, ';'
	print, ';		LOGMAKER: Set this keyword if youd like to regenerate the '
	print, ';			logsheet to put the junked object names in place'
	print, ';'
	print, ';		CHI_QUALITY: Set this keyword if youd like to regenerate'
	print, ';			the CHIRON quality control page after junking the'
	print, ';			object name.'
	print, ';'
	print, '        REASON: Enter the reason for junking this observation.'
	print, ';'
	print, ''
	print, ''
	print, '*************************************************'
	print, '                     EXAMPLE                     '
	print, "IDL>chi_junk, date=120810L, seqnum=1151L"
	print, 'IDL> '
	print, '*************************************************'
	stop
endif

date = strt(date)
if keyword_set(seqnum) then seqnum = strt(seqnum)
if keyword_set(startnum) then begin
startnum = long(startnum)
endnum = long(endnum)
nobs = endnum - startnum + 1
seqnum = lindgen(nobs)+ startnum
seqnum = strt(seqnum)
endif

fn = '/raw/mir7/'+date+'/chi'+date+'.'+seqnum+'.fits'
nobs = n_elements(fn)

for i=0, nobs-1 do begin
  h = headfits(fn[i])
  if strupcase(strt(sxpar(h, 'OBJECT'))) ne 'JUNK' then begin
	sxaddpar, h, 'OBJECT_I', sxpar(h, 'OBJECT'), 'Original object name before junking'
	sxaddpar, h, 'OBJECT', 'junk', 'See OBJECT_I for the original object name'
	if keyword_set(reason) then begin
	sxaddpar, h, 'JNKRSN', reason, 'The reason this object was junked'
	endif
	modfits, fn[i], 0, h
	print, 'Wrote changes to: ', fn[i]
  endif else print, 'OBJECT NAME IS ALREADY JUNK! NOTHING CHANGED.'
endfor

if keyword_set(logmaker) then logmaker, date, /over, /nofoc
if keyword_set(chi_quality) then chi_quality, date=date

end;chi_junk.pro