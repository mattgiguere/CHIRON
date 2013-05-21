;+
;
;  NAME: 
;     chi_comp_total_reduceds
;
;  PURPOSE: 
;   
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      chi_comp_total_reduceds
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
;      chi_comp_total_reduceds
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2012.02.27 02:26:44 PM
;
;-
pro chi_comp_total_reduceds

loadct, 39, /silent
idir = '/mir7/iodspec/'

rdsk, im1, idir+'achi120217.1295', 1
rdsk, im2, idir+'achi120223.1183', 1

;make im3 the im2 version with the same dims as im1
im3 = rotate(im2, 2)
im3 = im3[*, 1:59]

tim1 = total(im1, 1)
mx = where(tim1 eq max(tim1))
ntim1 = tim1/tim1[mx[0]]
tim3 = total(im3, 1)
ntim3 = tim3/tim3[mx[0]]
plot, ntim3, ps=8
oplot, ntim1, ps=8, color=250

al_legend, ['achi120217.1295', 'achi120223.1183'], $
textcolor = [250, 0]


stop
end;chi_comp_total_reduceds.pro