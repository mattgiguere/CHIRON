;+
;
;  NAME: 
;     chi_comp_raw_vign
;
;  PURPOSE: 
;    To compare the vignetting using raw images instead of reduced
;	by looking at H_alpha in one frame versus the rotated other.
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      chi_comp_raw_vign
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
;      chi_comp_raw_vign
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2012.02.27 01:50:16 PM
;
;-
pro chi_comp_raw_vign

amps=4
rdir = '/mir7/raw/'
im1 = readfits(rdir+'120217/chi120217.1295.fits', hd1)
im2 = readfits(rdir+'120223/chi120223.1183.fits', hd2)
im2 = rotate(im2, 2)
im1 = double(im1)
im2 = double(im2)
loadct, 8, /silent




;*******************************************************
;SUBTRACTING THE BIAS
;*******************************************************
header = hd1
if amps eq 4 then begin
   ;returns x1, y1, x2, y2
   bblarr = str_coord_split(sxpar(header, 'bsec11')) - 1d
   bbrarr = str_coord_split(sxpar(header, 'bsec12')) - 1d
   bularr = str_coord_split(sxpar(header, 'bsec21')) - 1d
   burarr = str_coord_split(sxpar(header, 'bsec22')) - 1d
   
   datblarr = str_coord_split(sxpar(header, 'dsec11')) - 1d
   datbrarr = str_coord_split(sxpar(header, 'dsec12')) - 1d
   datularr = str_coord_split(sxpar(header, 'dsec21')) - 1d
   daturarr = str_coord_split(sxpar(header, 'dsec22')) - 1d

   ;bbl (11)
   for i=datblarr[2], datblarr[3] do begin
	 im1[datblarr[0]:datblarr[1], i] = $
	 im1[datblarr[0]:datblarr[1], i] - $
	 median(im1[(bblarr[0]+2):(bblarr[1]-3), i])
   endfor
   
   ;bul (21)
   for i=datularr[2], datularr[3] do begin
	 im1[datularr[0]:datularr[1], i] = $
	 im1[datularr[0]:datularr[1], i] - $
	 median(im1[(bularr[0]+2):(bularr[1]-3), i])
   endfor
   
   ;bbr (12)
   for i=datbrarr[2], datbrarr[3] do begin
	 im1[datbrarr[0]:datbrarr[1], i] = $
	 im1[datbrarr[0]:datbrarr[1], i] - $
	 median(im1[(bbrarr[0]+2):(bbrarr[1]-3), i])
   endfor
   
   ;bur (22)
   for i=daturarr[2], daturarr[3] do begin
	 im1[daturarr[0]:daturarr[1], i] = $
	 im1[daturarr[0]:daturarr[1], i] - $
	 median(im1[(burarr[0]+2):(burarr[1]-3), i])
   endfor
endif;4 amp readout
header = hd2
if amps eq 4 then begin
   ;returns x1, y1, x2, y2
   bblarr = str_coord_split(sxpar(header, 'bsec11')) - 1d
   bbrarr = str_coord_split(sxpar(header, 'bsec12')) - 1d
   bularr = str_coord_split(sxpar(header, 'bsec21')) - 1d
   burarr = str_coord_split(sxpar(header, 'bsec22')) - 1d
   
   datblarr = str_coord_split(sxpar(header, 'dsec11')) - 1d
   datbrarr = str_coord_split(sxpar(header, 'dsec12')) - 1d
   datularr = str_coord_split(sxpar(header, 'dsec21')) - 1d
   daturarr = str_coord_split(sxpar(header, 'dsec22')) - 1d

   ;bbl (11)
   for i=datblarr[2], datblarr[3] do begin
	 im2[datblarr[0]:datblarr[1], i] = $
	 im2[datblarr[0]:datblarr[1], i] - $
	 median(im2[(bblarr[0]+2):(bblarr[1]-3), i])
   endfor
   
   ;bul (21)
   for i=datularr[2], datularr[3] do begin
	 im2[datularr[0]:datularr[1], i] = $
	 im2[datularr[0]:datularr[1], i] - $
	 median(im2[(bularr[0]+2):(bularr[1]-3), i])
   endfor
   
   ;bbr (12)
   for i=datbrarr[2], datbrarr[3] do begin
	 im2[datbrarr[0]:datbrarr[1], i] = $
	 im2[datbrarr[0]:datbrarr[1], i] - $
	 median(im2[(bbrarr[0]+2):(bbrarr[1]-3), i])
   endfor
   
   ;bur (22)
   for i=daturarr[2], daturarr[3] do begin
	 im2[daturarr[0]:daturarr[1], i] = $
	 im2[daturarr[0]:daturarr[1], i] - $
	 median(im2[(burarr[0]+2):(burarr[1]-3), i])
   endfor
endif;4 amp readout
;*******************************************************
;*******************************************************
display, im2/total(im2)
stop
im2n = im2/total(im2)
im1n = im1/total(im1)
window, xsize=1400, ysize=900
display, im2n - im1n
stop











window, xsize=1400, ysize=900
display, im1[700:*, *]
;cursor, x1, y1, /down
;print, 'Your coordinates for im1 are:', x1, y1

display, im2[700:*, *]
;cursor, x2, y2, /down
;print, 'Your coordinates for im1 are:', x2, y2

i='b'
while i ne 'b' do begin
display, im1[700:*, *]
 wait, 1
display, im2[700:*, *]
 wait, 1
endwhile

while i eq 'b' do begin
display, im1[0:699, *]
 wait, 1
display, im2[0:699, *]
 wait, 1
endwhile


stop
end;chi_comp_raw_vign.pro