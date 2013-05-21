;+
;
;  NAME: 
;     chi_plot_fts
;
;  PURPOSE: 
;   
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      chi_plot_fts
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
;      chi_plot_fts
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2012.04.05 10:43:54 AM
;
;-
pro chi_plot_fts, $
help = help, $
postplot = postplot

if keyword_set(help) then begin
	print, '*************************************************'
	print, '*************************************************'
	print, '        HELP INFORMATION FOR chi_plot_fts'
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


;restore, '/tous/mir7/dopcode/dop/atlas/iodine_chiron_pnnl_lo.dat'
restore, '/tous/mir7/dopcode/dop/atlas/iodine_chiron_pnnl_hi.dat'
;restore, 'iodine_chiron_pnnl_lo.dat'
cellttl = 'P2-High'
;cellttl = 'P2-Low'
;wmin = 6d5 & wmax=6.6d5
;wmin = 4d5 & wmax=4.6d5
;wmin = 0d & wmax=0.6d5
wmin = 5.43d6 & wmax=5.49d6

cf = create_struct('jd', iodine_wvac[wmin:wmax], 'mnvel', iodine_tran[wmin:wmax])
!p.multi=[0,1,2]

if keyword_set(postplot) then begin
   fn = nextnameeps('~/idl/CHIRON/I2_plots/'+cellttl)
   thick, 2
   ps_open, fn, /encaps, /color
endif
plot, iodine_wvac[wmin:wmax], iodine_tran[wmin:wmax], /xsty, $
xtitle='wavelength', title=cellttl
xyouts, 0.1, 0.6, 'Min Wavelength = '+strt(iodine_wvac[wmin], f='(F8.2)')+' A', /normal
xyouts, 0.6, 0.6, 'Max Wavelength = '+strt(iodine_wvac[wmax], f='(F8.2)')+' A', /normal

pergram, cf, nu_out, perout, lowper=0.3, /noplot
pky = where(perout eq max(perout))

plot, 1d / nu_out, perout, $
xtitle='Period [A]', ytitle='Power', /xlog, /xsty, yran=[0d, 1.1*max(perout)], /ysty, title=cellttl
xyouts, 1d / nu_out[pky[0]], perout[pky[0]], strt(1d/nu_out[pky[0]], f='(F8.3)')+' A'

if keyword_set(postplot) then begin
   ps_close
endif

stop
end;chi_plot_fts.pro