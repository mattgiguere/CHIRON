;+
;;  NAME: 
;     chi_plot_ord
;;  PURPOSE: 
;   
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      chi_plot_ord
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
;      chi_plot_ord
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2011.10.20 03:57:54 PM
;
;-
pro chi_plot_ord, file=file, ord=ord

im = readfits('/mir7/fitspec/'+file, hd)
length = n_elements(im[0, *, 0])
ords = n_elements(im[0, 0, *])
wav = dblarr(length, ords)
spec = dblarr(length, ords)
for i=0, ords-1 do spec(*,i) = im(1,*,i)
for i=0, ords-1 do wav(*,i) = im(0,*,i) 

plot, wav[*, ord], spec[*, ord], ps=-8, /xsty, /ysty, $
xtitle='Wavelength [A]', $
ytitle='Flux'
stop
end;chi_plot_ord.pro