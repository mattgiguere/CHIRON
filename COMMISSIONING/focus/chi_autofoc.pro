;+
;  NAME: 
;     chi_autofoc
;  PURPOSE: 
;   To autofocus CHIRON
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      chi_autofoc
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
;		SKIPTAKES: Set this to NOT take the exposures, but just to analyze them.
;		DATE: Set this to the date you want to look at exposures for
;		STARTNUM: If you don't want to look at every image in a directory, 
;			then set this to specify the starting sequence number to analyze
;		ENDNUM: Set this to the end sequence number. 
;    
;  EXAMPLE:
;      chi_autofoc
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2011.06.17 04:08:06 PM
;
;-
pro chi_autofoc, $
skiptakes = skiptakes, $
date = date, $
startnum = startnum, $
endnum = endnum

spawn, 'hostname', hostname
host = strsplit(hostname, '.', /extract)
domainnm = host[1]
for i=2, n_elements(host)-1 do domainnm+='.'+host[i]

;domain = strmid(strt(hostname), 13, 14, /reverse)

if ~keyword_set(date) then spawn, 'date "+%y%m%d"', date
date=strt(date)
exptime = 5000 ;exposure time in seconds
chi_dir = '/data/'+date
ct1_dir = '/mir7/raw/'+date

startpos = 9.5d ;mm
domain = 1.5d ;startpos + domain = finalpos (mm)

if ~keyword_set(skiptakes) and domainnm eq 'ctio.noao.edu' then begin
  
  spawn, 'ssh ctioe1 mkdir /data/'+date
  nsteps = 40d
  steps = dindgen(nsteps+1)/nsteps *domain + startpos
  print, steps
  
  ;spawn, 'ssh ctioe1 pan appmacro set_roi FULL'
  ;spawn, 'ssh ctioe1 pan appmacro set_binning 3 1'
  ;spawn, 'ssh ctioe1 pan appmacro speed_normal'
  ;spawn, 'ssh ctioe1 slicer MOVE narrow_slit'
  
  spawn, 'ssh ctioe1 iodcell get iodine', pos
  posx = strsplit(pos, ' ', /extract)
  
  if (posx[1] eq "OFF" ) OR (posx[1] eq "OUT") then begin
	print, 'The iodine cell was already out'
  endif else begin
	spawn, 'ssh ctioe1 iodcell set iodine OUT'
  endelse
  
  print, 'now turning the ThAr Lamp on.'
  spawn, 'ssh ctioe1 lamp set TH-AR on'
  wait, 1
  
  print, 'now setting the exposure time. '
  spawn, 'ssh ctioe1 pan set exptime '+strt(exptime)
  spawn, 'ssh ctioe1 GUIUPDATE exptime'
  wait, 2
  
  print, 'now changing the title'
  spawn, 'ssh ctioe1 pan set image.title "focus"'
  spawn, 'ssh ctioe1 GUIUPDATE title'
  wait, 2
  
  ;#print, 'now changing the basename'
  ;#spawn, 'ssh ctioe1 pan set image.basename "qa38."'
  ;#spawn, 'ssh ctioe1 GUIUPDATE basename'
  ;#wait, 2
  ;
  ;#print, 'now changing the image number'
  spawn, 'ssh ctioe1 pan get image.number', startingim
  ;#spawn, 'ssh ctioe1 GUIUPDATE imnumber'
  ;#wait, 2
  
  print, 'now changing the number of images to take. '
  spawn, 'ssh ctioe1 pan set obs.nimages 1'
  spawn, 'ssh ctioe1 GUIUPDATE nimages'
  wait, 2
  
  print, 'now changing the observer name'
  spawn, 'ssh ctioe1 dhe set obs.observer "chi_autofoc"'
  spawn, 'ssh ctioe1 GUIUPDATE observer'
  wait, 2
  
  print, 'now setting the observation type.'
  spawn, 'ssh ctioe1 pan set obs.obstype Calibration'
  spawn, 'ssh ctioe1 GUIUPDATE obstype'
  wait, 2
  
  spawn, 'ssh ctioe1 pan set autoshutter on'
  
  spawn, 'ssh ctioe1 pan set image.directory '+chi_dir
  spawn, 'ssh ctioe1 GUIUPDATE directory'
  wait, 2
  
  spawn, 'ssh ctioe1 pan dbs set propid CPS STR'
  spawn, 'ssh ctioe1 GUIUPDATE propid'
  wait, 2
  
  spawn, 'ssh ctioe1 pan set image.comment "autofocus "'
  spawn, 'ssh ctioe1 GUIUPDATE comment'
  
  spawn, 'ssh ctioe1 CHIRON2 OPTGUI GUI UPDATE autolamps off'
  
  for i=0, nsteps - 1 do begin
	print, 'now on step ',strt(i), ' of ', strt(nsteps)
	movecomm = 'ssh ctioe1 CHIRON2 FOCUS MOVE '+strt(steps[i], f='(F8.2)')
	print, movecomm
	spawn, movecomm
	spawn, 'ssh ctioe1 pan expose'
  endfor
  
  spawn, 'mkdir /mir7/raw/'+date
  spawn, 'rsync -zuva ctioe1:/data/'+date+'/ /mir7/raw/'+date+'/'
  
endif;KW(skiptakes)
if ~keyword_set(startnum) then begin
  spawn, 'ls -1 '+ct1_dir+'/qa38*', files
  len = strlen(ct1_dir+'/')
  for f=0, n_elements(files)-1 do begin
  files[f] = strmid(files[f], len, strlen(files[f]))
  endfor
  spawn, 'ls -1 '+ct1_dir, files
  files = ct1_dir+'/'+files
  
endif else begin;no startnum
  startnum = long(startnum)
  endnum = long(endnum)
  seqnums = lindgen(endnum - startnum + 1L) + startnum
  sseqnums = strt(seqnums)
  if domainnm eq 'astro.yale.edu' then rdir = '/raw/mir7/' else rdir = '/mir7/raw/'
  files = rdir+strt(date)+'/chi'+strt(date)+'.'+sseqnums+'.fits'
endelse
print, '**************************************'
print, 'CHI_AUTOFOC: THE FILES YOU ARE ABOUT TO'
PRINT, 'FIND THE FOCII OF ARE...'
print, '**************************************'
PRINT, transpose(files)
print, '**************************************'
print, 'CHI_AUTOFOC: TYPE ".C" TO CONTINUE...'
print, '**************************************'

stop
nfiles = n_elements(files) - 1
focpos = dblarr(nfiles)
focfwhm = dblarr(nfiles)

for i=0, nfiles-1 do begin
  inpfile = files[i]
  focpos[i] = sxpar(headfits(inpfile), 'FOCUS')
  foc, inpfile=inpfile, slicevals = slicevals, /plt, /mark
  focfwhm[i] = slicevals.avgfwhm
  print, strt(i)+'/'+strt(nfiles),' ',inpfile, $
  	' focpos: ', strt(focpos[i]), $
  	' focfwhm: ',strt(focfwhm[i])
endfor

thick, 2
;p1 = plot(focpos, focfwhm, symbol="o", $
;xtitle='Focus Position [mm]', $
;ytitle='Focus FWHM [px]', $
;name=date+' values', $
;linestyle='none', $
;sym_thick=2)
bv = where(focfwhm lt 9 and focfwhm gt 1.0 and focpos gt 7.5 and focpos lt 13.5)
if ~file_test('focus_plots', /directory) then spawn, 'mkdir focus_plots'
ps_open, nextnameeps('focus_plots/'+date+'autofoc'), /encaps, /color
plot, focpos[bv], focfwhm[bv], ps=8, $
xtitle='Focus Position [mm]', $
ytitle='Focus FWHM [px]', $
title='Focus for '+date

par = poly_fit(focpos[bv], focfwhm[bv], 2, /double, yfit=yfit)
xfine =dindgen(1d4+1)/1d4 * domain  + startpos
yfine = par[0] + par[1]*xfine + par[2] * xfine^2

oplot, xfine, yfine, ps=8, color=240

;x = where(focfwhm gt 0d)
myprow = mpfit_poly(focpos[bv], focfwhm[bv], $
order=2, yfit=yfit)
oplot, focpos[bv], yfit, ps=8, color=120
P = myprow
yfine2 = P[0] + P[1]*(xfine - P[3]) + P[2]*(xfine - P[3])^2d

oplot, xfine, yfine2, ps=8, color=80
;stop
print, min(yfine2)
yminloc = where(yfine2 eq min(yfine2))
print, 'xmin loc: ', xfine(yminloc[0])

;now overplot the dots so they're not covered by the lines:
oplot, focpos[bv], focfwhm[bv], ps=8

;the 0.0085 mm is to take into account the difference between where
;you tell the motor to move and where it actually moves when switching
;directions
if domainnm eq 'ctio.noao.edu' then $
spawn, 'ssh ctioe1 CHIRON2 FOCUS MOVE '+strt(xfine(yminloc) - 0.0085d, f='(F9.3)')

xyouts, 0.5, 0.75, 'Minimum FWHM: '+strt(min(yfine), f='(F9.3)')+' @ X = '+strt(xfine(yminloc), f='(F9.3)'), $
/normal, alignment=0.5
ps_close

if domainnm eq 'ctio.noao.edu' then begin
  spawn, 'ssh ctioe1 pan expose'
  spawn, 'rsync -zuva ctioe1:/data/'+date+'/ /mir7/raw/'+date+'/'
endif

;stop
end;chi_autofoc.pro
