;+
;
;  NAME: 
;     chi_plot_all_pars
;
;  PURPOSE: This program was created to compare the velocities
;	of any target against ALL parameters to see if there's any 
;	correlation between the velocities and anything else. 
;   
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      chi_plot_all_pars
;
;  INPUTS:
;
;  OPTIONAL INPUTS:
;		SAVEVELS: Set this keyword to save the tauceti log structure
;		once the velocities have been matched up with the observations.
;
;  OUTPUTS:
;
;  OPTIONAL OUTPUTS:
;
;  KEYWORD PARAMETERS:
;	pickgoodones: If set, the user will be prompted after every parameter whether or not
;		they want to keep it. If set to 1, it will be added to an array and used later 
;		for a large plot. If not set, the program will stop after every tag. 
;	skipbeg: Again, for my professional seminar talk, I added this so I could skip
;		right to the creation of the plot. 
;	postplotpfsem: Make the plot of RVs as a function of ALL the parameters for my
;		professional seminar presentation
;	hdnum: The HD number of the star you want to plot.
;    
;  EXAMPLE:
;      chi_plot_all_pars
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2013.05.13 16:20:14
;
;-
pro chi_plot_all_pars, $
postplot = postplot, $
postplotpfsem = postplotpfsem, $
pickgoodones = pickgoodones, $
savevels = savevels, $
skipbeg = skipbeg, $
hdnum = hdnum

if ~keyword_set(hdnum) then hdnum = 10700L
hdnum = long(hdnum)

angstrom = '!6!sA!r!u!9 %!6!n'
!p.color=0
!p.background=255
loadct, 39, /silent
usersymbol, 'circle', /fill, size_of_sym = 0.5

if yalehost() then rdir = '/home/' else rdir = '/Users/'

if hdnum eq 10700 the begin
  ;restore, rdir+'matt/idl/CHIRON/vst/vst10700_adh.dat'
  restore, rdir+'matt/idl/CHIRON/vst/vst10700_all.dat'
  tclogfn =rdir+'matt/idl/CHIRON/logstructs/ologs/taucetilogs/taucetilog.dat' 
  restore, tclogfn
endif

if hdnum eq 128621 then begin
  restore, rdir+'matt/idl/CHIRON/vst/vst10700_all.dat'
  tclogfn =rdir+'matt/idl/CHIRON/logstructs/ologs/taucetilogs/taucetilog.dat' 
  restore, tclogfn
endif


;now to match up the velocities with every
for i=0, n_elements(cf3)-1 do begin
  x = where('a'+taucetilog.prefix+'.'+taucetilog.seqnum eq cf3[i].obnm, nct)
  
  if nct gt 0 then begin
  taucetilog[x].cmnvel = cf3[i].mnvel
  taucetilog[x].cerrvel = cf3[i].errvel
  taucetilog[x].cmdvel = cf3[i].mdvel
  taucetilog[x].barycor = cf3[i].bc
  endif
endfor
if keyword_set(savevels) then save, taucetilog, filename=tclogfn
stop
;** Structure CFSTR, 22 tags, length=400, data length=388:
;   OBNM            STRING    'achi120703.1113'
;   IODNM           STRING    '?'
;   BC              FLOAT           26589.2
;   Z               FLOAT       7.89022e-07
;   JD              DOUBLE           16112.937
;   DEWAR           INT             50
;   GAIN            FLOAT           1.30000
;   CTS             LONG             16646
;   MNVEL           FLOAT          -2.81269
;   MDVEL           FLOAT          -1.01587
;   MED_ALL         FLOAT           26826.1
;   ERRVEL          FLOAT          0.989104
;   MDCHI           FLOAT          0.978672
;   NCHUNK          INT            691
;   MDPAR           FLOAT     Array[20] <--RULED OUT
;   MNPAR           FLOAT     Array[20] <--RULED OUT
;   SP1             FLOAT           0.00000
;   SP2             FLOAT           0.00000
;   SPST            STRING    '?'
;   PHASE           FLOAT           0.00000
;   PSFPIX          FLOAT     Array[15] <--RULED OUT
;   PSFSIG          FLOAT     Array[15] <--RULED OUT
;for i=0, 14 do begin
;plot, cf3.psfsig[i], cf3.mnvel, ps=8, title='PSFPIX '+strt(i), /ysty
;stop
;endfor
;plot, cf3.jd, cf3.mnvel, ps=8, /xsty

g = where(taucetilog.cmnvel ne 0)
tagnms = tag_names(taucetilog)
if ~keyword_set(skipbeg) then begin
answer = ''
keepers = -1
for i=0, n_tags(taucetilog)-1 do begin
  print, 'Tag: '+strt(i)+' of '+strt(n_tags(taucetilog)-1)
  gg = where(double(taucetilog[g].(i)) ne 0d, ggct)
  if ggct gt 1 then begin 
	plot, double(taucetilog[g[gg]].(i)), taucetilog[g[gg]].cmnvel, ps=8, title=tagnms[i]+' '+strt(i)
	if strt(tagnms[i]) eq 'RA' then begin
	  ras = double(strmid(taucetilog[g[gg]].(i), 0, 2)) + $
			double(strmid(taucetilog[g[gg]].(i), 3, 2))/60d + $
			double(strmid(taucetilog[g[gg]].(i), 6, 5))/3600d
	  plot, ras*15d, taucetilog[g[gg]].cmnvel, ps=8, title=tagnms[i]+' '+strt(i)
	endif
	if strt(tagnms[i]) eq 'DEC' then begin
	  decs = double(strmid(taucetilog[g[gg]].(i), 0, 3)) + $
			double(strmid(taucetilog[g[gg]].(i), 4, 2))/60d + $
			double(strmid(taucetilog[g[gg]].(i), 7, 4))/3600d
	  plot, decs, taucetilog[g[gg]].cmnvel, ps=8, title=tagnms[i]+' '+strt(i)
	endif
	if strt(tagnms[i]) eq 'HA' then begin
	  has = strsplit(taucetilog[g[gg]].(i), ':', /extract)
	  has2 = has.ToArray(type='double')
	  plot, has2, taucetilog[g[gg]].cmnvel, ps=8, title=tagnms[i]+' '+strt(i)
	endif;HA
  endif;ggct > 1
  print, 'Tag: '+strt(i)+' of '+strt(n_tags(taucetilog)-1)
  if keyword_set(pickgoodones) then begin
  read, answer, prompt='Enter 1 to keep this one.'
  if answer eq '1' then keepers = [keepers, i] 
  endif else stop
endfor
keepers = keepers[1:*]
endif else begin ;KW(skipbeg)
restore, '/Users/matt/idl/CHIRON/keepers2.dat'
endelse;KW:skipbeg

noz = where(taucetilog[g].emmnwobjd ne 0d)
geomtime = taucetilog[g[noz]].utshutjd + taucetilog[g[noz]].exptime/3600d/24d/2d


if keyword_set(postplot) then begin
   fn = nextnameeps('~/Desktop/gmem')
   thick, 3
   ps_open, fn, /encaps, /color
endif

plot, (taucetilog[g[noz]].EMMNWOBJD - geomtime)*24d*3600d, $
taucetilog[g[noz]].cmnvel, ps=8, $
ytitle='RV [m/s]', $
xtitle = 'EMMNWOBJD - Geometric Midpoint (in seconds)'

if keyword_set(postplot) then begin
   ps_close
endif

;keepers = rm_elements(keepers, 16)

stop
;*****************************************************************
; PLOT THE VELOCITIES AS A FUNCTION OF EVERYTHING:
;*****************************************************************
if keyword_set(postplotpfsem) then begin
   fn = nextnameeps('~/Desktop/allpars')
   thick, 1
   ps_open, fn, /encaps, /color
   usersymbol, 'circle', /fill, size_of_sym=0.25
   !p.charsize = 0.5
endif else begin
window, xsize=1800, ysize=1800
endelse

!p.multi=[0,9,8]
;make a huge plot with all the variables:
for i=0, n_elements(keepers)-1 do begin
gg = where(double(taucetilog[g].(keepers[i])) ne 0d, ggct)

plot, double(taucetilog[g[gg]].(keepers[i])), $
		taucetilog[g[gg]].cmnvel, ps=8, title=tagnms[keepers[i]]
regs = where(strt(taucetilog[g[gg]].decker) eq 'slit', regct)
if regct gt 1 then oplot, double(taucetilog[g[gg[regs]]].(keepers[i])), $
		taucetilog[g[gg[regs]]].cmnvel, ps=8, col=250
print, 'i: ', i, 'keepers[i]: ', keepers[i]
;if i gt 41 then stop
endfor
if keyword_set(postplotpfsem) then ps_close


;*****************************************************************
; PLOT THE ERRORS AS A FUNCTION OF EVERYTHING:
;*****************************************************************
if keyword_set(postplotpfsem) then begin
   fn = nextnameeps('~/Desktop/allerrpars')
   thick, 1
   ps_open, fn, /encaps, /color
   usersymbol, 'circle', /fill, size_of_sym=0.25
   !p.charsize = 0.5
endif else begin
window, xsize=1800, ysize=1800
endelse
stop
!p.multi=[0,9,8]
;make a huge plot with all the variables:
for i=0, n_elements(keepers)-1 do begin
gg = where(double(taucetilog[g].(keepers[i])) ne 0d, ggct)

plot, double(taucetilog[g[gg]].(keepers[i])), $
		taucetilog[g[gg]].cerrvel, ps=8, title=tagnms[keepers[i]]
regs = where(strt(taucetilog[g[gg]].decker) eq 'slit', regct)
if regct gt 1 then oplot, double(taucetilog[g[gg[regs]]].(keepers[i])), $
		taucetilog[g[gg[regs]]].cerrvel, ps=8, col=250
print, 'i: ', i, 'keepers[i]: ', keepers[i], ' regct: ', regct
;if i gt 41 then stop
endfor
stop
if keyword_set(postplotpfsem) then ps_close


;NOW JUST PLOT THE EXPOSURE METER ROGUE OBSERVATIONS:
if keyword_set(postplotpfsem) then begin
   fn = nextnameeps('~/Desktop/emnumsmp')
   thick, 3
   ps_open, fn, /encaps, /color
   usersymbol, 'circle', /fill, size_of_sym=1
   !p.charsize = 1
endif
i=17
gg = where(double(taucetilog[g].(keepers[i])) ne 0d, ggct)
plot, double(taucetilog[g[gg]].(keepers[i])), taucetilog[g[gg]].cmnvel, ps=8, xtitle=tagnms[keepers[i]], ytitle='RV [m/s]'
if keyword_set(postplotpfsem) then ps_close

if keyword_set(postplotpfsem) then begin
   fn = nextnameeps('~/Desktop/emprdsum')
   thick, 3
   ps_open, fn, /encaps, /color
   usersymbol, 'circle', /fill, size_of_sym=1
   !p.charsize = 1
endif
i=20
gg = where(double(taucetilog[g].(keepers[i])) ne 0d, ggct)
plot, double(taucetilog[g[gg]].(keepers[i])), taucetilog[g[gg]].cmnvel, ps=8, xtitle=tagnms[keepers[i]], ytitle='RV [m/s]'
if keyword_set(postplotpfsem) then ps_close

stop
end;chi_plot_all_pars.pro