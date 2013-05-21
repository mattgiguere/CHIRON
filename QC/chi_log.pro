;+
;
;  NAME: 
;     chi_log
;
;  PURPOSE: To create a log structure containing useful information
;			from the night's observations
;   
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      chi_log
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
;      chi_log
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2012.03.10 10:00:14 AM
;
;-
function chi_log, $
help = help, $
postplot = postplot, $
date = date

loadct, 39, /silent
usersymbol, 'circle', /fill, size_of_sym = 0.5

if keyword_set(help) then begin
	print, '*************************************************'
	print, '*************************************************'
	print, '        HELP INFORMATION FOR chi_log'
	print, 'KEYWORDS: '
	print, ''
	print, 'HELP: Use this keyword to print all available arguments'
	print, ''
	print, ''
	print, ''
	print, '*************************************************'
	print, '                     EXAMPLE                     '
	print, "IDL>log = chi_log(date='120309') "
	print, "IDL>"
	print, '*************************************************'
	stop
endif


log_init = create_struct($
'FILENAME', '', $
'SIMPLE', '', $
'BITPIX', '', $
'NAXIS', '', $
'NAXIS1', '', $
'NAXIS2', '', $
'EXTEND', '', $
'BZERO', '', $
'BSCALE', '', $
'OBJECT', '', $
'OBSERVER', '', $
'PROPID', '', $
'OBSID', '', $
'IMAGETYP', '', $
'CCDSUM', '', $
'ROIREQ', '', $
'UTSHUT', '', $
'UTSHUTJD', 0d, $
'DATE', date, $
'DATEHD', '', $
'NAMPSYX', '', $
'AMPLIST', '', $
'TSEC11', '', $
'ASEC11', '', $
'CSEC11', '', $
'BSEC11', '', $
'DSEC11', '', $
'SCSEC11', '', $
'TSEC12', '', $
'ASEC12', '', $
'CSEC12', '', $
'BSEC12', '', $
'DSEC12', '', $
'SCSEC12', '', $
'TSEC22', '', $
'ASEC22', '', $
'CSEC22', '', $
'BSEC22', '', $
'DSEC22', '', $
'SCSEC22', '', $
'TSEC21', '', $
'ASEC21', '', $
'CSEC21', '', $
'BSEC21', '', $
'DSEC21', '', $
'SCSEC21', '', $
'DETECTOR', '', $
'FPA', '', $
'REXPTIME', '', $
'EXPTIME', '', $
'TEXPTIME', '', $
'DARKTIME', '', $
'DHEINF', '', $
'DHEFIRM', '', $
'SPEEDMOD', '', $
'GEOMMOD', '', $
'PIXTIME', '', $
'GAIN11', '', $
'RON11', '', $
'GAIN12', '', $
'RON12', '', $
'GAIN21', '', $
'RON21', '', $
'GAIN22', '', $
'RON22', '', $
'POWSTAT', '', $
'SLOT00', '', $
'SLOT01', '', $
;'SLOT02', '', $
'SLOT03', '', $
'SLOT04', '', $
'SLOT07', '', $
;'SLOT02', '', $
'PANID', '', $
'EMTIMOPN', '', $
'EMTIMOPNJD', 0d, $
'EMTIMCLS', '', $
'EMTIMCLSJD', 0d, $
'EMNUMSMP', '', $
'EMAVG', '', $
'EMAVGSQ', '', $
'EMPRDSUM', '', $
'EMNETINT', '', $
'EMMNWOB', '', $
'EMMNWOBJD', 0d, $
'EMMNWB', '', $
'EMMNWBJD', 0d, $
'DHSID', '', $
'DECKPOS', '', $
'DECKER', '', $
'FOCUS', '', $
'THRES', '', $
'MAXEXP', '', $
'PMHV', '', $
'CCDTEMP', '', $
'NECKTEMP', '', $
'TEMPGRAT', '', $
'TEMPTLOW', '', $
'TEMPTCEN', '', $
'TEMPSTRU', '', $
'TEMPENCL', '', $
'TEMPINST', '', $
'TEMIODIN', '', $
'DEWPRESS', '', $
'ECHPRESS', '', $
'BAROMETE', '', $
'COMPLAMP', '', $
'IODCELL', '', $
'ID', '', $
'OBSERVAT', '', $
'TELESCOP', '', $
'DATEOBS', '', $
'UT', '', $
'RA', '', $
'RADECDEG', 0D, $
'DEC', '', $
'DECDECDEG', 0D, $
'EPOCH', '', $
'ALT', '', $
'ALTITUDE', 0D, $
'AZIMUTH', 0D, $
'HA', '', $
'HADECDEG', 0D, $
'ST', '', $
'ZD', '', $
'AIRMASS', '', $
'WEATIME', '', $
'OUTTEMP', '', $
'OUTHUM', '', $
'OUTPRESS', '', $
'WNDSPEED', '', $
'WNDDIR', '', $
'SEETIME', '', $
'SEEING', '', $
'SAIRMASS', '', $
'SNRBP5500', 0d, $
'RESOLUTION', 0d, $
'CREATED', systime(), $
'SEQNUM', '', $
'PREFIX', '', $
'READNOISE', dblarr(4), $
'MEDBIAS', dblarr(4), $
'MEDOVERSCAN', dblarr(4), $
'MAXCTS', 0d, $ ;Max ADU at center swath of chip
'MAXCTS11', 0d, $ ;Max ADU at center of chip
'MAXCTS12', 0d, $ ;Max ADU at center of chip
'MAXCTS21', 0d, $ ;Max ADU at center of chip
'MAXCTS22', 0d, $ ;Max ADU at center of chip
'MEDCTS11', 0d, $ ;Median ADU of quadrant
'MEDCTS12', 0d, $ ;Median ADU at quadrant
'MEDCTS21', 0d, $ ;Median ADU at quadrant
'MEDCTS22', 0d, $ ;Median ADU at quadrant
'TOTCTS', 0d, $ ;Total ADU
'TOTPHO', 0d, $ ;Total Photoelectrons on chip
'FSPECXST', 0L, $
'ISPECXST', 0L, $
'THIDXST', 0L, $
'WAVXST', 0L, $
'NTIMGT5', 0D, $
'TTIMGT5', 0D, $
'IBTIME', 0D, $
'COBNM', 0D, $
'CMNVEL', 0D, $
'CERRVEL', 0D, $
'CMDVEL', 0D, $
'JMNVEL', 0D, $
'JERRVEL', 0D, $
'JMDVEL', 0D, $
'SENSDEPTHSARR', DBLARR(7), $
'STABDEPTHSARR', DBLARR(7), $
'CCSHIFTARR', DBLARR(7), $
'BARYCOR', 0D) 

;TAGS TO ADD:
;sun_angular_distance
;moon_angular_distance
;moon_illumination
;O_BZERO 
;ROOTDIR 
;LOGDIR  
;LOGSTDIR
;IODSPECD
;PLOTSDIR
;FITSDIR 
;THIDDIR 
;THIDFILE
;RAWDIR  
;IMDIR   
;DATE    
;SEQNUM  
;VERSIOND
;VERSIONN
;PREFIX_T
;PREFIX  
;FLATDIR 
;BIASDIR 
;BIASMODE
;ORDERDIR
;BARYDIR 
;XTRIM   
;YTRIM   
;READMODE
;NLC     
;GAINS   
;RON     
;GAIN    
;BINNING 
;MODE    
;FLATNORM
;MINFLATV
;SLICERFL
;PKCOEFS 
;PKCOEFS1
;NORDS   
;MODES   
;XWIDS   
;DPKS    
;BINNINGS
;DEBUG   
;THARFNAM
;SEETIMEJD
;WEATTIMEJD


rdir = '/mir7/raw/'+date
spawn, 'hostname', host
if strmid(host, 13,14, /reverse) eq 'astro.yale.edu' then rdir = '/raw/mir7/'+date
spawn, 'ls -1 '+rdir+'/*.fits', files

nfil = n_elements(files)
log = replicate(log_init, nfil)

for i=0, nfil-1 do begin
hd = headfits(files[i])
log[i].FILENAME = files[i]
rdl = strlen(rdir+'/')
fspl = strsplit(files[i], '.', /extract)
log[i].PREFIX = strmid(fspl[0], rdl, strlen(fspl[0])-rdl) ;without the dot
log[i].SEQNUM = fspl[1]
log[i].SIMPLE   = sxpar(hd, 'SIMPLE')
log[i].BITPIX   = sxpar(hd, 'BITPIX  ')
log[i].NAXIS    = sxpar(hd, 'NAXIS   ')
log[i].NAXIS1   = sxpar(hd, 'NAXIS1  ')
log[i].NAXIS2   = sxpar(hd, 'NAXIS2  ')
log[i].EXTEND   = sxpar(hd, 'EXTEND  ')
log[i].BZERO    = sxpar(hd, 'BZERO   ')
log[i].BSCALE   = sxpar(hd, 'BSCALE  ')
log[i].OBJECT   = sxpar(hd, 'OBJECT  ')
log[i].OBSERVER = sxpar(hd, 'OBSERVER')
log[i].PROPID   = sxpar(hd, 'PROPID  ')
log[i].OBSID    = sxpar(hd, 'OBSID   ')
log[i].IMAGETYP = sxpar(hd, 'IMAGETYP')
log[i].CCDSUM   = sxpar(hd, 'CCDSUM  ')
log[i].ROIREQ   = sxpar(hd, 'ROIREQ  ')
utst            = sxpar(hd, 'UTSHUT  ')
log[i].UTSHUT = utst
log[i].UTSHUTJD = julday(strmid(utst, 5,2), $ ;month
						 strmid(utst, 8,2), $ ;day
						 strmid(utst, 0,4), $ ;year
						 strmid(utst, 11,2), $ ;hour
						 strmid(utst, 14,2), $ ;minute
						 strmid(utst, 17,6))   ;second
log[i].DATEHD     = sxpar(hd, 'DATE    ')
log[i].NAMPSYX  = sxpar(hd, 'NAMPSYX ')
log[i].AMPLIST  = sxpar(hd, 'AMPLIST ')
log[i].TSEC11   = sxpar(hd, 'TSEC11  ')
log[i].ASEC11   = sxpar(hd, 'ASEC11  ')
log[i].CSEC11   = sxpar(hd, 'CSEC11  ')
log[i].BSEC11   = sxpar(hd, 'BSEC11  ')
log[i].DSEC11   = sxpar(hd, 'DSEC11  ')
log[i].SCSEC11  = sxpar(hd, 'SCSEC11 ')
log[i].TSEC12   = sxpar(hd, 'TSEC12  ')
log[i].ASEC12   = sxpar(hd, 'ASEC12  ')
log[i].CSEC12   = sxpar(hd, 'CSEC12  ')
log[i].BSEC12   = sxpar(hd, 'BSEC12  ')
log[i].DSEC12   = sxpar(hd, 'DSEC12  ')
log[i].SCSEC12  = sxpar(hd, 'SCSEC12 ')
log[i].TSEC22   = sxpar(hd, 'TSEC22  ')
log[i].ASEC22   = sxpar(hd, 'ASEC22  ')
log[i].CSEC22   = sxpar(hd, 'CSEC22  ')
log[i].BSEC22   = sxpar(hd, 'BSEC22  ')
log[i].DSEC22   = sxpar(hd, 'DSEC22  ')
log[i].SCSEC22  = sxpar(hd, 'SCSEC22 ')
log[i].TSEC21   = sxpar(hd, 'TSEC21  ')
log[i].ASEC21   = sxpar(hd, 'ASEC21  ')
log[i].CSEC21   = sxpar(hd, 'CSEC21  ')
log[i].BSEC21   = sxpar(hd, 'BSEC21  ')
log[i].DSEC21   = sxpar(hd, 'DSEC21  ')
log[i].SCSEC21  = sxpar(hd, 'SCSEC21 ')
log[i].DETECTOR = sxpar(hd, 'DETECTOR')
log[i].FPA      = sxpar(hd, 'FPA     ')
log[i].REXPTIME = sxpar(hd, 'REXPTIME')
log[i].EXPTIME  = sxpar(hd, 'EXPTIME ')
log[i].TEXPTIME = sxpar(hd, 'TEXPTIME')
log[i].DARKTIME = sxpar(hd, 'DARKTIME')
log[i].DHEINF   = sxpar(hd, 'DHEINF  ')
log[i].DHEFIRM  = sxpar(hd, 'DHEFIRM ')
log[i].SPEEDMOD = sxpar(hd, 'SPEEDMOD')
log[i].GEOMMOD  = sxpar(hd, 'GEOMMOD ')
log[i].PIXTIME  = sxpar(hd, 'PIXTIME ')
log[i].GAIN11   = sxpar(hd, 'GAIN11  ')
log[i].RON11    = sxpar(hd, 'RON11   ')
log[i].GAIN12   = sxpar(hd, 'GAIN12  ')
log[i].RON12    = sxpar(hd, 'RON12   ')
log[i].GAIN21   = sxpar(hd, 'GAIN21  ')
log[i].RON21    = sxpar(hd, 'RON21   ')
log[i].GAIN22   = sxpar(hd, 'GAIN22  ')
log[i].RON22    = sxpar(hd, 'RON22   ')
log[i].POWSTAT  = sxpar(hd, 'POWSTAT ')
log[i].SLOT00   = sxpar(hd, 'SLOT00  ')
log[i].SLOT01   = sxpar(hd, 'SLOT01  ')
;log[i].SLOT02   = sxpar(hd, 'SLOT02  ')
log[i].SLOT03   = sxpar(hd, 'SLOT03  ')
log[i].SLOT04   = sxpar(hd, 'SLOT04  ')
log[i].SLOT07   = sxpar(hd, 'SLOT07  ')
;log[i].SLOT02   = sxpar(hd, 'SLOT02  ')
log[i].PANID    = sxpar(hd, 'PANID   ')
emojd           = sxpar(hd, 'EMTIMOPN')
log[i].EMTIMOPN = emojd
if emojd ne '0000-00-00T00:00:00.000' then begin
log[i].EMTIMOPNJD = julday(strmid(emojd, 5,2), $ ;month
						   strmid(emojd, 8,2), $ ;day
						   strmid(emojd, 0,4), $ ;year
						   strmid(emojd, 11,2), $ ;hour
						   strmid(emojd, 14,2), $ ;minute
						   strmid(emojd, 17,6))   ;second
endif						   
emcjd           = sxpar(hd, 'EMTIMCLS')
log[i].EMTIMCLS = emcjd
if emcjd ne '0000-00-00T00:00:00.000' then begin
log[i].EMTIMCLSJD = julday(strmid(emcjd, 5,2), $ ;month
						   strmid(emcjd, 8,2), $ ;day
						   strmid(emcjd, 0,4), $ ;year
						   strmid(emcjd, 11,2), $ ;hour
						   strmid(emcjd, 14,2), $ ;minute
						   strmid(emcjd, 17,6))   ;second
endif						   
log[i].EMNUMSMP = sxpar(hd, 'EMNUMSMP')
log[i].EMAVG    = sxpar(hd, 'EMAVG   ')
log[i].EMAVGSQ  = sxpar(hd, 'EMAVGSQ ')
log[i].EMPRDSUM = sxpar(hd, 'EMPRDSUM')
log[i].EMNETINT = sxpar(hd, 'EMNETINT')
emwob           = sxpar(hd, 'EMMNWOB ')
log[i].EMMNWOB  = emwob
if emwob ne '0000-00-00T00:00:00.000' then begin
log[i].EMMNWOBJD = julday(strmid(emwob, 5,2), $ ;month
						   strmid(emwob, 8,2), $ ;day
						   strmid(emwob, 0,4), $ ;year
						   strmid(emwob, 11,2), $ ;hour
						   strmid(emwob, 14,2), $ ;minute
						   strmid(emwob, 17,6))   ;second
endif						   
emnwb           = sxpar(hd, 'EMMNWB  ')
log[i].EMMNWB   = emnwb
if emnwb ne '0000-00-00T00:00:00.000' then begin
log[i].EMMNWBJD = julday(strmid(emnwb, 5,2), $ ;month
						   strmid(emnwb, 8,2), $ ;day
						   strmid(emnwb, 0,4), $ ;year
						   strmid(emnwb, 11,2), $ ;hour
						   strmid(emnwb, 14,2), $ ;minute
						   strmid(emnwb, 17,6))   ;second
endif
log[i].DHSID    = sxpar(hd, 'DHSID   ')
log[i].DECKPOS  = sxpar(hd, 'DECKPOS ')
log[i].DECKER   = sxpar(hd, 'DECKER  ')
log[i].FOCUS    = sxpar(hd, 'FOCUS   ')
log[i].THRES    = sxpar(hd, 'THRES   ')
log[i].MAXEXP   = sxpar(hd, 'MAXEXP  ')
log[i].PMHV     = sxpar(hd, 'PMHV    ')
log[i].CCDTEMP  = sxpar(hd, 'CCDTEMP ')
log[i].NECKTEMP = sxpar(hd, 'NECKTEMP')
log[i].TEMPGRAT = sxpar(hd, 'TEMPGRAT')
log[i].TEMPTLOW = sxpar(hd, 'TEMPTLOW')
log[i].TEMPTCEN = sxpar(hd, 'TEMPTCEN')
log[i].TEMPSTRU = sxpar(hd, 'TEMPSTRU')
log[i].TEMPENCL = sxpar(hd, 'TEMPENCL')
log[i].TEMPINST = sxpar(hd, 'TEMPINST')
log[i].TEMIODIN = sxpar(hd, 'TEMIODIN')
log[i].DEWPRESS = sxpar(hd, 'DEWPRESS')
log[i].ECHPRESS = sxpar(hd, 'ECHPRESS')
log[i].BAROMETE = sxpar(hd, 'BAROMETE')
log[i].COMPLAMP = sxpar(hd, 'COMPLAMP')
log[i].IODCELL  = sxpar(hd, 'IODCELL ')
log[i].ID       = sxpar(hd, 'ID      ')
log[i].OBSERVAT = sxpar(hd, 'OBSERVAT')
log[i].TELESCOP = sxpar(hd, 'TELESCOP')
log[i].DATEOBS = sxpar(hd, 'DATE-OBS')
log[i].UT       = sxpar(hd, 'UT      ')
rastr           = sxpar(hd, 'RA      ')
log[i].RA       = rastr
if strt(rastr) ne '' and strt(rastr) ne '0' and strt(rastr) ne 'ra' then begin
  rasplit = strsplit(rastr, ':', /extract)
  if n_elements(rasplit) eq 3 then begin
	log[i].RADECDEG       = double(rasplit[0])*15d +$
							double(rasplit[1])/60d*15d + $
							double(rasplit[2])/3600d*15d
  endif;#rasplit=3						
endif;rastr
						
decstr          = sxpar(hd, 'DEC     ')
log[i].DEC      = decstr
if strt(decstr) ne '' and strt(decstr) ne '0' and strt(decstr) ne 'dec' then begin
decsplit = strsplit(decstr, ':', /extract)
if n_elements(decsplit) eq 3 then begin
if strmid(decstr,0,1) eq '-' then pmsgn = -1d else pmsgn = 1d
log[i].DECDECDEG      = double(decsplit[0])+$
						pmsgn*double(decsplit[1])/60d + $
						pmsgn*double(decsplit[2])/3600d
endif;#decsplit=3						
endif;decstr
log[i].EPOCH    = sxpar(hd, 'EPOCH   ')
log[i].ALT      = sxpar(hd, 'ALT     ')
;since the alt in the FITS header is incorrect:
eq2hor, log[i].radecdeg, log[i].decdecdeg, log[i].EMMNWOBJD, altitude, azimuth
log[i].ALTITUDE      = altitude
log[i].AZIMUTH      = azimuth
hastr           = sxpar(hd, 'HA      ')
log[i].HA       = hastr
if strt(hastr) ne '' and strt(hastr) ne '0' and $
	strt(hastr) ne 'ha' and strt(hastr) ne 'hour_angle' then begin
	
	hastrarr = strsplit(hastr, ':', /extract)
	if strmid(hastr,0,1) eq '-' then pmsgn = -1d else pmsgn = 1d
	  log[i].HADECDEG       = double(hastrarr[0]) +$
							  pmsgn*double(hastrarr[1])/60d + $
							  pmsgn*double(hastrarr[2])/3600d
endif;hastr
log[i].ST       = sxpar(hd, 'ST      ')
log[i].ZD       = sxpar(hd, 'ZD      ')
log[i].AIRMASS  = sxpar(hd, 'AIRMASS ')
log[i].WEATIME  = sxpar(hd, 'WEATIME ')
log[i].OUTTEMP  = sxpar(hd, 'OUTTEMP ')
log[i].OUTHUM   = sxpar(hd, 'OUTHUM  ')
log[i].OUTPRESS = sxpar(hd, 'OUTPRESS')
log[i].WNDSPEED = sxpar(hd, 'WNDSPEED')
log[i].WNDDIR   = sxpar(hd, 'WNDDIR  ')
log[i].SEETIME  = sxpar(hd, 'SEETIME ')
log[i].SEEING   = sxpar(hd, 'SEEING  ')
log[i].SAIRMASS = sxpar(hd, 'SAIRMASS')
print, strt(log[i].seqnum), ' ',log[i].object, strt(double(log[i].exptime), f='(F14.2)'),' ', log[i].ccdsum, log[i].decker
endfor

;first test the log structure date directory, and make it for the new year if need be:
lsdatedir = '/mir7/logstructs/20'+strmid(date,0,2)
if strmid(host, 13,14, /reverse) eq 'astro.yale.edu' then lsdatedir = '/tous'+lsdatedir
if ~file_test(lsdatedir, /directory) then spawn, 'mkdir '+lsdatedir


lognm = '/mir7/logstructs/20'+strmid(date,0,2)+'/'+date+'log'
if file_test(lognm+'.dat') then begin
spawn, 'mv '+lognm+'.dat'+' '+nextname(lognm+'_old', '.dat')
endif
spawn, 'hostname', host
if strmid(host, 13,14, /reverse) eq 'astro.yale.edu' then lognm = '/tous'+lognm
save, log, filename=lognm+'.dat'
print, '--------------------------------------------------------'
print, 'FINISHED CREATING LOG STRUCTURE!'
print, '--------------------------------------------------------'
print, 'Log structure save to: ', lognm+'.dat'
print, '--------------------------------------------------------'

if keyword_set(postplot) then begin
   fn = nextnameeps('plot')
   thick, 2
   ps_open, fn, /encaps, /color
endif

if keyword_set(postplot) then begin
   ps_close
endif
return, log
end;chi_log.pro