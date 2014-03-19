;+
;
;  NAME: 
;     chi_count_check
;
;  PURPOSE: To check the counts for each observation
;			and save the results to the log structure
;   
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      chi_count_check
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
;      chi_count_check
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2012.03.10 01:08:35 PM
;        lines 169,170,171 commented out. Imran Hasan 2014.02.11
;-
pro chi_count_check, $
help = help, $
postplot = postplot, $
log

if keyword_set(help) then begin
	print, '*************************************************'
	print, '*************************************************'
	print, '        HELP INFORMATION FOR chi_count_check'
	print, 'KEYWORDS: '
	print, ''
	print, 'HELP: Use this keyword to print all available arguments'
	print, ''
	print, ''
	print, ''
	print, '*************************************************'
	print, '                     EXAMPLE                     '
	print, "IDL>"
	print, 'IDL> '
	print, '*************************************************'
	stop
endif

loadct, 39, /silent
usersymbol, 'circle', /fill, size_of_sym = 0.5

if keyword_set(postplot) then begin
   fn = nextnameeps('plot')
   thick, 2
   ps_open, fn, /encaps, /color
endif

if keyword_set(postplot) then begin
   ps_close
endif

for i=0, n_elements(log.filename)-1 do begin
im = readfits(log[i].filename, hd)
log[i].totcts = total(im)
imnb = chi_rm_bias(filename=log[i].filename, medbias=medbias)
log[i].medoverscan = medbias
cgres = chip_geometry(log[i].filename, hdr=hd)
itul = cgres.image_trim.upleft
itur = cgres.image_trim.upright
itbl = cgres.image_trim.botleft
itbr = cgres.image_trim.botright
gul = cgres.gain.upleft
gur = cgres.gain.upright
gbl = cgres.gain.botleft
gbr = cgres.gain.botright
log[i].totpho = (total(imnb[itul[0]:itul[1], itul[2]:itul[3]])*gul + $
				 total(imnb[itur[0]:itur[1], itur[2]:itur[3]])*gur +$
				 total(imnb[itbl[0]:itbl[1], itbl[2]:itbl[3]])*gbl +$
				 total(imnb[itbr[0]:itbr[1], itbr[2]:itbr[3]])*gbr)
log[i].medcts11 = median(imnb[itul[0]:itul[1], itul[2]:itul[3]])
log[i].medcts12 = median(imnb[itur[0]:itur[1], itur[2]:itur[3]])
log[i].medcts21 = median(imnb[itbl[0]:itbl[1], itbl[2]:itbl[3]])
log[i].medcts22 = median(imnb[itbr[0]:itbr[1], itbr[2]:itbr[3]])
;print, log[i].medcts11
;print, log[i].medcts12
;print, log[i].medcts21
;print, log[i].medcts22

imnbsz = size(imnb)
swidth = 5
;stop
;log[i].maxcts11 = max(imnb[itul[0]:itul[1], itul[2]:itul[3]])
mid11 = itul[2] ;take the swidth*2 pixels nearest the center
imnbswath11 = imnb[itul[0]:itul[1],mid11:(mid11 + swidth*2)]
imnbswmed11 = median(imnbswath11, dimen=2, /double)
log[i].maxcts11 = max(imnbswmed11)

;log[i].maxcts12 = max(imnb[itur[0]:itur[1], itur[2]:itur[3]])
mid12 = itur[2]
imnbswath12 = imnb[itur[0]:itur[1],mid12:(mid12 + swidth*2)]
imnbswmed12 = median(imnbswath12, dimen=2, /double)
log[i].maxcts12 = max(imnbswmed12)

;log[i].maxcts21 = max(imnb[itbl[0]:itbl[1], itbl[2]:itbl[3]])
mid21 = itbl[3]
imnbswath21 = imnb[itbl[0]:itbl[1],(mid21 - swidth*2):(mid21)]
imnbswmed21 = median(imnbswath21, dimen=2, /double)
log[i].maxcts21 = max(imnbswmed21)

;log[i].maxcts22 = max(imnb[itbr[0]:itbr[1], itbr[2]:itbr[3]])
mid22 = itbr[3]
imnbswath22 = imnb[itbr[0]:itbr[1],(mid22 - swidth*2):(mid22)]
imnbswmed22 = median(imnbswath22, dimen=2, /double)
log[i].maxcts22 = max(imnbswmed22)
;print, log[i].maxcts11
;print, log[i].maxcts12
;print, log[i].maxcts21
;print, log[i].maxcts22
;stop

istart = log[i].emtimopn
pend = log[i-1].emtimcls
istart = strt(istart)
pend = strt(pend)
if (strmid(istart,0,4) ne '0000' and strt(istart) ne '0' and strmid(pend,0,4) ne '0000' and pend ne '0' and i ne 0) then begin
  istartjd = julday( $
  strmid(istart, 5, 2), $ ;month
  strmid(istart, 8, 2), $ ;day
  strmid(istart, 0, 4), $ ;year
  strmid(istart, 11, 2), $ ;hour
  strmid(istart, 14, 2), $ ;minute
  strmid(istart, 17, 2));second
  pendjd = julday( $
  strmid(pend, 5, 2), $ ;month
  strmid(pend, 8, 2), $ ;day
  strmid(pend, 0, 4), $ ;year
  strmid(pend, 11, 2), $ ;hour
  strmid(pend, 14, 2), $ ;minute
  strmid(pend, 17, 2));second
  ;minutes in between observations:
  ibmins = (istartjd-pendjd)*24d*60d
endif else begin
  ibmins=-1
endelse
;the minutes between the shutter close of the last observation and shutter
;open of the current observation:
log[i].ibtime = ibmins 
				 
imnbswath = imnb[*,(imnbsz[2]/2d - swidth):(imnbsz[2]/2d + swidth)]
imnbswmed = median(imnbswath, dimen=2, /double)
log[i].maxcts = max(imnbswmed)
endfor
ibts = where(log.ibtime gt 5d and log.ibtime le 60d and $
strt(log.object) ne 'quartz' and strt(log.object) ne 'dark' and $
strt(log.object) ne 'bias' and strt(log.object) ne 'ThAr', ntimgt5)
log.ntimgt5 = ntimgt5
log.ttimgt5 = total(log[ibts].ibtime)

date = log[0].date
lognm = '/mir7/logstructs/20'+strmid(date,0,2)+'/'+date+'log'
;if file_test(lognm+'.dat') then begin
;spawn, 'mv '+lognm+'.dat'+' '+nextname(lognm+'_old', '.dat')
;endif
spawn, 'hostname', host
if strmid(host, 13,14, /reverse) eq 'astro.yale.edu' then lognm = '/tous'+lognm
save, log, filename=lognm+'.dat'
print, '--------------------------------------------------------'
print, 'FINISHED UPDATING LOG STRUCTURE IN CHI_COUNT_CHECK!'
print, '--------------------------------------------------------'
print, 'Log structure save to: ', lognm+'.dat'
print, '--------------------------------------------------------'
end;chi_count_check.pro