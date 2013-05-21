;+
;
;  NAME: 
;     chi_slicer_im
;
;  PURPOSE: 
;     To plot the raw slicer image of an iodine exposure taken with CHIRON.
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      chi_slicer_im
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
;      chi_slicer_im
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2011.07.15 08:36:30 PM
;
;-
pro chi_slicer_im

filename = '/mir7/raw/110714/qa38.4975.fits'

imo = double(readfits(filename, header))                                                                         

bularr = str_coord_split(sxpar(header, 'bsec21')) - 1d                                                             
burarr = str_coord_split(sxpar(header, 'bsec22')) - 1d                                                             
                                                                                                                   
datularr = str_coord_split(sxpar(header, 'dsec21')) - 1d                                                           
daturarr = str_coord_split(sxpar(header, 'dsec22')) - 1d                                                           
                                                                                                                   
;bul (21)                                                                                                          
for i=datularr[2], datularr[3] do begin                                                                            
  imo[datularr[0]:datularr[1], i] = $                                                                              
  imo[datularr[0]:datularr[1], i] - $                                                                              
  median(imo[(bularr[0]+2):(bularr[1]-3), i])                                                                      
  ;imo[101:2148, i] = imo[101:2148, i] - median(imo[1:47, i])                                                      
endfor                                                                                                             
                                                                                                                   
                                                                                                                   
;bur (22)                                                                                                          
;for i=2048, 4095 do begin                                                                                         
for i=daturarr[2], daturarr[3] do begin                                                                            
  imo[daturarr[0]:daturarr[1], i] = $                                                                              
  imo[daturarr[0]:daturarr[1], i] - $                                                                              
  median(imo[(burarr[0]+2):(burarr[1]-3), i])                                                                      
;imo[2149:4196, i] = imo[2149:4196, i] - median(imo[4249:4294, i])                                                 
endfor                                                                                                             

;window, xsize=1920, ysize=1178 
thick, 5
fdir = '~/Documents/ASTROPHYSICS/RESEARCH/OBSERVING/CHIRON/figures/'
ps_open, fdir+'chi_slicer_i2', /encaps, /color
loadct, 9, /silent                  
display, imo, /log, $
xtitle='Cross Dispersion [px]', $
ytitle='Dispersion direction [px]'
ps_close
stop
end;chi_slicer_im.pro