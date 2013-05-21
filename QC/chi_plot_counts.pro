;+
;
;  NAME: 
;     chi_plot_counts
;
;  PURPOSE: 
;   
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      chi_plot_counts
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
;      chi_plot_counts
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2012.03.12 10:29:11 AM
;
;-
pro chi_plot_counts, $
help = help, $
postplot = postplot, $
log, $
dir = dir

if keyword_set(help) then begin
	print, '*************************************************'
	print, '*************************************************'
	print, '        HELP INFORMATION FOR chi_plot_counts'
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

;pdir = '/mir7/quality/plots/'
pdir = dir+'plots/'
spawn, 'hostname', host
;if strmid(host, 13,14, /reverse) eq 'astro.yale.edu' then pdir = '/tous'+pdir

date = log[0].date
goods = where(strt(log.object) ne 'bias' and strt(log.object) ne 'dark' $
              and strt(log.object) ne 'ThAr' and strt(log.object) ne 'quartz' $
              and strt(log.object) ne 'quartz' and strt(log.propid) ne 'Calib' $
              and strt(log.object) ne 'iodine', goodcts)
if goodcts gt 1 then begin
  if keyword_set(postplot) then begin
	  thick, 2
	  ;first test the max counts date directory, and make it for the new year if need be:
	  mcdatedir = pdir+'maxcts/20'+strmid(date,0,2)
	  if ~file_test(mcdatedir, /directory) then spawn, 'mkdir '+mcdatedir
	  mfn = pdir+'maxcts/20'+strmid(date, 0, 2)+'/'+date+'maxcts'
	  if file_test(mfn) then spawn, 'mv '+mfn+' '+nextnameeps(mfn+'_old')
	  ps_open, mfn, /encaps, /color
  endif
  plot, log[goods].seqnum, log[goods].maxcts, ps=8, $
  yran=[8d2,1d5], /ysty, /xsty, $
  ytitle='Max Counts for '+date, $
  xtitle='Sequence #', /ylog, /nodata
  oplot, minmax(log[goods].seqnum), [max(log[goods[0]].medoverscan), max(log[goods[0]].medoverscan)], color=250
  oplot, minmax(log[goods].seqnum), [65535L, 65535L], color=250
  xyouts, log[goods[1]].seqnum, 850, 'Pedestal Level'
  xyouts, log[goods[1]].seqnum, 70000, 'Saturation Level'
  oplot, log[goods].seqnum, log[goods].maxcts, ps=8
  if keyword_set(postplot) then begin
	  ps_close
	  spawn, 'convert -density 100 '+mfn+'.eps '+mfn+'.png'
  endif;postplot
endif;goodcts
;NOW PLOTTING THE QUARTZ EXPOSURES:
qtznar = where(strt(log.object) eq 'quartz' and strt(log.decker) eq 'narrow_slit')
qtzslt = where(strt(log.object) eq 'quartz' and strt(log.decker) eq 'slit')
qtzscr = where(strt(log.object) eq 'quartz' and strt(log.decker) eq 'slicer')
qtzfib = where(strt(log.object) eq 'quartz' and strt(log.decker) eq 'fiber')

if keyword_set(postplot) then begin
   thick, 2
	  ;first test the quartz date directory, and make it for the new year if need be:
	  qdatedir = pdir+'quartz/20'+strmid(date,0,2)
	  if ~file_test(qdatedir, /directory) then spawn, 'mkdir '+qdatedir
   qfn = pdir+'quartz/20'+strmid(date, 0, 2)+'/'+date+'quartz'
   if file_test(qfn) then spawn, 'mv '+qfn+' '+nextnameeps(qfn+'_old')
   ps_open, qfn, /encaps, /color
endif

plot, log[qtznar].maxcts, yran=[0,6.6d4], /xsty, /ysty, ps=8, $
xtitle='Index #', $
ytitle='Max Counts for '+date

oplot, [9.5,9.5],[1,6.6d4], linestyle=1, color=230
xyouts, 9.5, 3d3, 'Middle of Night', orient=90, charsize=0.5

if goodcts gt 1 then begin
  oplot, minmax(log[goods].seqnum), [max(log[goods[0]].medoverscan), max(log[goods[0]].medoverscan)], color=250
  oplot, minmax(log[goods].seqnum), [65535L, 65535L], color=250
  xyouts, log[goods[1]].seqnum, 850, 'Pedestal Level'
  xyouts, log[goods[1]].seqnum, 70000, 'Saturation Level'
endif;goodcts

if n_elements(qtzslt) gt 1 then oplot, log[qtzslt].maxcts, color=80, ps=8
if n_elements(qtzsscr) gt 1 then oplot, log[qtzscr].maxcts, color=120, ps=8
if n_elements(qtzfib) gt 1 then oplot, log[qtzfib].maxcts, color=250, ps=8

al_legend, ['Qtz Narrow', 'Qtz Slit', 'Qtz Slicer', 'Qtz Fiber'], /right, $
textcolor = [0, 80, 120, 250]
if keyword_set(postplot) then begin
   ps_close
   spawn, 'convert -density 100 '+qfn+'.eps '+qfn+'.png'
endif
end;chi_plot_counts.pro