;+
;
;  NAME: 
;     chi_pt_struct
;
;  PURPOSE: 
;   
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      chi_pt_struct
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
;      chi_pt_struct
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2012.01.23 11:02:44 AM
;
;-
pro chi_pt_struct, $
help = help, $
prefix = prefix, $
odate = odate, $
create_plots = create_plots

if keyword_set(help) then begin
	print, '*************************************************'
	print, '*************************************************'
	print, '        HELP INFORMATION FOR chi_pt_struct'
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

!p.color=0
!p.background = 255
loadct, 39, /silent

;use the 'a' or 'r' reduced files:
if ~keyword_set(prefix) then prefix = 'a'

airmass = 0d
alt = 0d
bin = ''
ccdtemp = 0d
continuum = dblarr(15211, 6)
complamp = ''
counts = 0d
date = ''
decker = ''
deckpos = 0d
dewpress = 0d
exptime = 0d
emnumsmp = 0d
emavg = 0d
emavgsq = 0d
fn = ''
ha = ''
iodcell = ''
inspress = 0d
maxexp = ''
maxrawcts = ''
object = ''
outhum = 0d
outpress = 0d
outtemp = 0d
peaklam = 0d
propid = ''
rawcts = 0d
readspeed = ''
seeing = 0d
snr = 0d
tempgrat = 0d
temproom = 0d
tempstru = 0d
temptcen = 0d
temptlow = 0d
utshut = ''
weatime = ''
wndspeed = 0d
zd = 0d

zzz = 0L
if ~keyword_set(odate) then odate = '111118'
spawn, 'ls -1d /raw/mir7/'+odate+'*', dirarr
dirarrd = strmid(dirarr, 10, 6)
for i=0, n_elements(dirarr)-1 do begin
	print, '******************************************'
	print, 'DATE: ', dirarrd[i]
	print, '******************************************'
	spawn, 'ls -1 '+dirarr[i], filearr
	for j=0, n_elements(filearr)-1 do begin
	  print, filearr[j]
	  im = readfits(dirarr[i]+'/'+filearr[j], hd, /silent)
	  airmass = [airmass,  sxpar(hd, 'airmass')]
	  alt = [alt,  sxpar(hd, 'alt')]
	  bin = [bin,  sxpar(hd, 'ccdsum')]
	  ccdtemp = [ccdtemp,  sxpar(hd, 'ccdtemp')]

	  complamp = [complamp,  sxpar(hd, 'complamp')]

	  date = [date, sxpar(hd, 'date')]
	  decker = [decker,  sxpar(hd, 'decker')]
	  deckpos = [deckpos,  sxpar(hd, 'deckpos')]
	  dewpress = [dewpress, sxpar(hd, 'dewpress')]
	  exptime = [exptime,  sxpar(hd, 'exptime')]
	  emnumsmp = [emnumsmp,  sxpar(hd, 'emnumsmp')]
	  emavg = [emavg,  sxpar(hd, 'emavg')]
	  emavgsq = [emavgsq,  sxpar(hd, 'emavgsq')]
	  fn = [fn, filearr[j]]
	  ha = [ha,  sxpar(hd, 'ha')]
	  iodcell = [iodcell,  sxpar(hd, 'iodcell')]
	  inspress = [inspress,  sxpar(hd, 'inspress')]
	  maxexp = [maxexp,  sxpar(hd, 'maxexp')]
	  maxrawcts = [maxrawcts,  max(im)]
	  object = [object,  sxpar(hd, 'object')]
	  outhum = [outhum,  double(sxpar(hd, 'outhum'))]
	  outpress = [outpress,  double(sxpar(hd, 'outpress'))]
	  outtemp = [outtemp,  double(sxpar(hd, 'outtemp'))]

	  propid = [propid,  sxpar(hd, 'propid')]
	  rawcts = [rawcts,  total(im, /double)]
	  readspeed = [readspeed,  sxpar(hd, 'readspeed')]
	  seeing = [seeing,  double(sxpar(hd, 'seeing'))]

	  tempgrat = [tempgrat, sxpar(hd, 'tempgrat')]
	  temproom = [temproom, sxpar(hd, 'temproom')]
	  tempstru = [tempstru, sxpar(hd, 'tempstru')]
	  temptcen = [temptcen, sxpar(hd, 'temptcen')]
	  temptlow = [temptlow, sxpar(hd, 'temptlow')]
	  utshut = [utshut, sxpar(hd, 'utshut')]
	  weatime = [weatime,  sxpar(hd, 'weatime')]
	  wndspeed = [wndspeed,  double(sxpar(hd, 'wndspeed'))]
	  zd = [zd,  sxpar(hd, 'zd')]

	  im = readfits(strt('/tous/mir7/fitspec/'+prefix+filearr[j]), hd, /silent)
	  if total(im) gt 0 then begin
		  counts = [counts, total(im)]
		  if strt(sxpar(hd, 'OBJECT')) ne 'ThAr' then begin
			  res = mpfit_poly(im[0,*,21], im[1,*,21], order=4, yfit=yfit, init=[8d4,0d,-5d1,0d,0d,5515d])
			  continuum[zzz, *] = res
			  maxc = max(yfit)
			  maxcx = where(yfit eq maxc)
			  peaklam = [peaklam, im[0,maxcx,21]]
			  snr = [snr, sqrt(maxc)*sqrt(0.025d / (im[0,maxcx,21] - im[0,maxcx - 1L,21]))]
			  print, 'snr: ', snr[-1]
			  plot, im[0,*,21], im[1,*,21], /xsty
			  oplot, im[0,*,21], yfit, color=240
		  endif else begin
		     snr = [snr, -1d]
		     peaklam = [peaklam, -1d]
		  endelse
	  endif else begin
           snr = [snr, -1d]
		     peaklam = [peaklam, -1d]
   		  counts = [counts, -1d]
     endelse
	  zzz++
	  ;stop
	endfor
endfor

pairmass = ptr_new(airmass[1:*], /allocate)
palt = ptr_new(alt[1:*], /allocate)
pbin = ptr_new(bin[1:*], /allocate)
pccdtemp = ptr_new(ccdtemp[1:*], /allocate)
pcontinuum = ptr_new(continuum, /allocate)
pcomplamp = ptr_new(complamp, /allocate)
pcounts = ptr_new(counts[1:*], /allocate)
pdate = ptr_new(date[1:*], /allocate)
pdecker = ptr_new(decker[1:*], /allocate)
pdeckpos = ptr_new(deckpos[1:*], /allocate)
pdewpress = ptr_new(dewpress[1:*], /allocate)
pexptime = ptr_new(exptime[1:*], /allocate)
pemnumsmp = ptr_new(emnumsmp[1:*], /allocate)
pemavgsq = ptr_new(emavgsq[1:*], /allocate)
pfn = ptr_new(fn[1:*], /allocate)
pha = ptr_new(ha[1:*], /allocate)
piodcell = ptr_new(iodcell[1:*], /allocate)
pinspress = ptr_new(inspress[1:*], /allocate)
pmaxexp = ptr_new(maxexp[1:*], /allocate)
pmaxrawcts = ptr_new(maxrawcts[1:*], /allocate)
pobject = ptr_new(object[1:*], /allocate)
pouthum = ptr_new(outhum[1:*], /allocate)
poutpress = ptr_new(outpress[1:*], /allocate)
pouttemp = ptr_new(outtemp[1:*], /allocate)
ppeaklam = ptr_new(peaklam[1:*], /allocate)
ppropid = ptr_new(propid[1:*], /allocate)
prawcts = ptr_new(rawcts[1:*], /allocate)
preadspeed = ptr_new(readspeed[1:*], /allocate)
pseeing = ptr_new(seeing[1:*], /allocate)
psnr = ptr_new(snr[1:*], /allocate)
ptempgrat = ptr_new(tempgrat[1:*], /allocate)
ptemproom = ptr_new(temproom[1:*], /allocate)
ptempstru = ptr_new(tempstru[1:*], /allocate)
ptemptcen = ptr_new(temptcen[1:*], /allocate)
ptemptlow = ptr_new(temptlow[1:*], /allocate)
putshut = ptr_new(utshut[1:*], /allocate)
pweatime = ptr_new(weatime[1:*], /allocate)
pwndspeed = ptr_new(wndspeed[1:*], /allocate)
pzd = ptr_new(zd[1:*], /allocate)


fitsst = create_struct( $
'pairmass',pairmass, $
'palt',palt, $
'pbin',pbin, $
'pccdtemp',pccdtemp, $
'pcontinuum', pcontinuum, $
'pcomplamp',pcomplamp, $
'pcounts', pcounts, $
'pdate',pdate, $
'pdecker',pdecker, $
'pdeckpos',pdeckpos, $
'pdewpress',pdewpress, $
'pexptime',pexptime, $
'pemnumsmp',pemnumsmp, $
'pemavgsq',pemavgsq, $
'pfn',pfn, $
'pha',pha, $
'piodcell',piodcell, $
'pinspress',pinspress, $
'pmaxexp',pmaxexp, $
'pmaxrawcts',pmaxrawcts, $
'pobject',pobject, $
'pouthum',pouthum, $
'poutpress',poutpress, $
'pouttemp',pouttemp, $
'ppeaklam', ppeaklam, $
'ppropid',ppropid, $
'prawcts',prawcts, $
'preadspeed',preadspeed, $
'pseeing',pseeing, $
'psnr', psnr, $
'ptempgrat',ptempgrat, $
'ptemproom',ptemproom, $
'ptempstru',ptempstru, $
'ptemptcen',ptemptcen, $
'ptemptlow',ptemptlow, $
'putshut', putshut, $
'pweatime',pweatime, $
'pwndspeed',pwndspeed, $
'pzd',pzd)


fitsstfn = nextname('~/idl/CHIRON/fitsst/'+odate+'fitsst', '.dat')
save, fitsst, filename=fitsstfn
print, 'File saved as: ', fitsstfn





if keyword_set(create_plots) then begin
  ns = where(decker eq 'narrow_slit')
  qtz = where(strt(object[ns]) eq 'quartz')
  bins = where(strt(bin[ns[qtz]]) eq '3 1')
  ioi = ns[qtz[bins]]
  !x.margin = [15, 3]
  ps_open, nextnameeps(odate+'CHIRONQuartzLampFlash'), /encaps, /color
  plot, rawcts[ns[qtz[bins]]], ps=8, /ysty, $
  xtitle=odate+' Beginning and End of Night Narrow Slit 3 x 1 Flat Exposure #', $
  ytitle='Total Raw Counts'
  loadct, 39, /silent
  oplot, lindgen(15)+15L, rawcts[ns[qtz[bins[15:*]]]], color=55, ps=8
  oplot, rawcts[ns[qtz[bins[0:14]]]], color=245, ps=8
  al_legend, ['BON', 'EON'], psym=[8,8], colors=[245,55], /right
  ps_close
  ps_open, nextnameeps(odate+'MaxRawCts'), /encaps, /color
  plot, maxrawcts[ns[qtz[bins]]], ps=8, /ysty, $
  xtitle=odate+' Beginning and End of Night Narrow Slit 3 x 1 Flat Exposure #', $
  ytitle='Max Raw Counts'
  ps_close
endif;KW:create_plots

end;chi_pt_struct.pro