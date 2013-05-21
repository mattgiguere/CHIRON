;+
;
;  NAME: 
;     chi_comp_vign
;
;  PURPOSE: 
;   To compare the CCD before and after rotation using reduced
;	images. 
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      chi_comp_vign
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
;      chi_comp_vign
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2012.02.27 01:35:40 PM
;
;-
pro chi_comp_vign

loadct, /silent, 8
!p.color=0

rdsk, im1, 'achi120217.1295', 1
rdsk, im2, 'achi120223.1183', 1 

contf, im1[*,31], c1, nord=5
plot, im1[*,0]/max(c1), /xsty, /ysty, $
xtitle='Dispersion Direction', $
ytitle='Normalized Counts', $
title='Ca IRT (Last Order in the Red)'

contf, im2[*,29], c2, nord=5
col2 = 170
oplot, reverse(im2[*,60]/max(c2)), color=col2

al_legend, ['120217.1295', '120223.1183'], $
color=[0, col2], textcolor=[0, col2]

stop
end;chi_comp_vign.pro