;+
;
;  NAME: 
;     chi_plot_alphacen
;
;  PURPOSE: 
;    To plot the latest velocities for Alpha Cen A & B. 
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      chi_plot_alphacen
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
;      chi_plot_alphacen
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2011.05.25 04:42:47 PM
;
;-
pro chi_plot_alphacen

restore, '~fischer/dop/vank/vstbank/vst128620.dat'

timearr = cf3.jd - min(cf3.jd)
plot, timearr, cf3.mnvel, $
xtitle='Time [d]', $
ytitle = 'RVs [m s!u-1!n]', ps=8

stop

restore, '~fischer/dop/vank/vstbank/vst128620_kd.dat'

timearr = cf3.jd - min(cf3.jd)
plot, timearr, cf3.mnvel, $
xtitle='Time [d]', $
ytitle = 'RVs [m s!u-1!n]', ps=8


stop
end;chi_plot_alphacen.pro