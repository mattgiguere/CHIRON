;+
;
;  NAME: 
;     chi_rm_bias
;
;  PURPOSE: 
;   To subtract the bias from the image
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      chi_rm_bias
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
;      chi_rm_bias
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2012.02.28 06:02:50 PM
;
;-
function chi_rm_bias, $
help = help, $
postplot = postplot, $
filename=filename, $
plot=plot, $
hd = hd, $
medbias = medbias

if keyword_set(help) then begin
	print, '*************************************************'
	print, '*************************************************'
	print, '        HELP INFORMATION FOR chi_rm_bias'
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

file_exists_wait, filename
rim = readfits(filename, hd, /silent)
rim = double(rim)

namps = n_elements(strsplit(sxpar(hd, 'amplist'), ' '))

if namps eq 2 then begin
  bularr = str_coord_split(sxpar(hd, 'bsec21')) - 1d
  burarr = str_coord_split(sxpar(hd, 'bsec22')) - 1d
  
  datularr = str_coord_split(sxpar(hd, 'dsec21')) - 1d
  daturarr = str_coord_split(sxpar(hd, 'dsec22')) - 1d
  
  ;bul (21)
  for i=datularr[2], datularr[3] do begin
	rim[datularr[0]:datularr[1], i] = $
	rim[datularr[0]:datularr[1], i] - $
	median(rim[(bularr[0]+2):(bularr[1]-3), i])
	;rim[101:2148, i] = rim[101:2148, i] - median(rim[1:47, i])
  endfor
  
  ;bur (22)
  for i=daturarr[2], daturarr[3] do begin
	rim[daturarr[0]:daturarr[1], i] = $
	rim[daturarr[0]:daturarr[1], i] - $
	median(rim[(burarr[0]+2):(burarr[1]-3), i])
  endfor
endif ;2 amp readout

if namps eq 4 then begin
   ;returns x1, y1, x2, y2
   ;BSEC is the overscan section (see FITS header comment)
   bblarr = str_coord_split(sxpar(hd, 'bsec11')) - 1d
   bbrarr = str_coord_split(sxpar(hd, 'bsec12')) - 1d
   bularr = str_coord_split(sxpar(hd, 'bsec21')) - 1d
   burarr = str_coord_split(sxpar(hd, 'bsec22')) - 1d
   
   datblarr = str_coord_split(sxpar(hd, 'dsec11')) - 1d
   datbrarr = str_coord_split(sxpar(hd, 'dsec12')) - 1d
   datularr = str_coord_split(sxpar(hd, 'dsec21')) - 1d
   daturarr = str_coord_split(sxpar(hd, 'dsec22')) - 1d

   ;bbl (11)
   for i=datblarr[2], datblarr[3] do begin
	 rim[datblarr[0]:datblarr[1], i] = $
	 rim[datblarr[0]:datblarr[1], i] - $
	 median(rim[(bblarr[0]+2):(bblarr[1]-3), i])
  endfor
  mbblarr = median(rim[(bblarr[0]+2):(bblarr[1]-3), datblarr[2]:datblarr[3]], dimen=1)
;   rim[datblarr[0]:datblarr[1], datblarr[2]:datblarr[3]] -= mbblarr
   
   
   ;bul (21)
   for i=datularr[2], datularr[3] do begin
	 rim[datularr[0]:datularr[1], i] = $
	 rim[datularr[0]:datularr[1], i] - $
	 median(rim[(bularr[0]+2):(bularr[1]-3), i])
   endfor
   mbularr = median(rim[(bularr[0]+2):(bularr[1]-3), datularr[2]:datularr[3]], dimen=1)
;   rim[datularr[0]:datularr[1], datularr[2]:datularr[3]] -= mbularr
   ;bbr (12)
   for i=datbrarr[2], datbrarr[3] do begin
	 rim[datbrarr[0]:datbrarr[1], i] = $
	 rim[datbrarr[0]:datbrarr[1], i] - $
	 median(rim[(bbrarr[0]+2):(bbrarr[1]-3), i])
   endfor
   mbbrarr = median(rim[(bbrarr[0]+2):(bbrarr[1]-3), datbrarr[2]:datbrarr[3]], dimen=1)
;   rim[datbrarr[0]:datbrarr[1], i] -= mbbrarr
   
   ;bur (22)
   for i=daturarr[2], daturarr[3] do begin
	 rim[daturarr[0]:daturarr[1], i] = $
	 rim[daturarr[0]:daturarr[1], i] - $
	 median(rim[(burarr[0]+2):(burarr[1]-3), i])
   endfor
   mburarr = median(rim[(burarr[0]+2):(burarr[1]-3), daturarr[2]:daturarr[3]], dimen=1)
;   rim[daturarr[0]:daturarr[1], i] -= mburarr
   medbias = [median(mbblarr), median(mbbrarr), median(mbularr), median(mburarr)]
endif;4 amp readout




if keyword_set(postplot) then begin
   fn = nextnameeps('plot')
   thick, 2
   ps_open, fn, /encaps, /color
endif

if keyword_set(postplot) then begin
   ps_close
endif

return, rim
stop
end;chi_rm_bias.pro