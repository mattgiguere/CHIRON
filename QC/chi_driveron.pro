;+
;
;  NAME: 
;     chi_driveron
;
;  PURPOSE: 
;   To get the readout noise information for every bias observation
;	and save it to an IDL structure. 
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      chi_driveron
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
;      chi_driveron
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2011.12.02 04:37:12 PM
;
;-
pro chi_driveron, $
help = help, $
manuald = manuald, $
postplot = postplot

loadct, 39, /silent
if keyword_set(help) then begin
	print, '*************************************************'
	print, '*************************************************'
	print, '        HELP INFORMATION FOR chi_driveron'
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

if ~keyword_set(manuald) then begin
datearr = [$
'110804', $
'110806', $
'110808', $
'110809', $
'110812', $
'110814', $
'110818', $
'110820', $
'110822', $
'110824', $
'110828', $
'110830', $
'110902', $
'110904', $
'110906', $
'110908', $
'110910', $
'110912', $
'110914', $
'110918', $
'110919', $
'110920', $
'110922', $
'110924', $
'110926', $
'110928', $
'110930', $
'111002', $
'111003', $
'111004', $
'111006', $
'111008', $
'111010', $
'111012', $
'111013', $
'111014', $
'111018', $
'111020', $
'111022', $
'111024', $
'111026', $
'111028', $
'111030', $
'111031', $
'111102', $
'111104', $
'111106', $
'111107', $
'111108', $
'111109', $
'111110', $
'111111', $
'111112', $
'111114', $
'111117', $
'111118', $
'111120', $
'111122', $
'111124', $
'111126', $
'111127', $
'111128', $
'111130', $
'111201', $
'111202', $
'111203', $
'111204', $
'111205', $
'111206', $
'111207', $
'111208', $
'111209', $
'111210', $
'111211']
endif else datearr = manuald;manuald


ndats = n_elements(datearr)

for i=0, ndats-1 do begin
  print, '*********************************'
  print, '*********************************'
  print, 'DATE IS: ', datearr[i]
  print, '*********************************'
  print, '*********************************'
  logpath='/tous/mir7/logsheets/2011/'
  logsheet=logpath+datearr[i]+'.log'
  
  ;read in the image prefix used for the night:
  readcol,logsheet, obs, fn, ln, tel, ct, 1.5, pre, prefix, f='A,A,A,A,A,A,A,A', skip=3, num=1
  
  ;read in the logsheet from the night:
  readcol,logsheet, obnm, objnm, i2, mdpt, exptm, bin, slit, propid, $
	  skip=9, delim=' ', f = 'A,A,A,A,A,A,A,A'
  
  z = where(((objnm eq 'bias') and (bin eq '3x1') and (exptm eq '0.00')), zct)
;  z = where(((objnm eq 'quartz') and (bin eq '3x1') and (strt(slit) eq 'narrow')), zct)
  if zct gt 0 then begin
	 fn = '/raw/mir7/'+datearr[i]+'/'+prefix+'.'+obnm[z[0]]+'.fits'
    im = readfits(fn, hd0, /silent)
    chipst = chip_geometry(hdr=hd0)
    l1 = chipst.image_trim.upleft[0]
    r1 = chipst.image_trim.upleft[1]
    l2 = chipst.image_trim.upright[0]
    r2 = chipst.image_trim.upright[1]
;	 l1 = strmid(sxpar(hd0, 'tsec21'), 1,2)
;	 r1 = strmid(sxpar(hd0, 'tsec21'), 4,3)
;	 l2 = strmid(sxpar(hd0, 'tsec22'), 1,3)
;	 r2 = strmid(sxpar(hd0, 'tsec22'), 5,4)
	 if double(r2) eq 1400d then r2 = 1399d ; kludge that has to do with the binning. 
    lim = im[l1:r1, *]
    rim = im[l2:r2, *]
    limarr = [ [[im[l1:r1, *]]] ]
    rimarr = [ [[im[l2:r2, *]]] ]
    fullim = [ [[im]] ]
    for mz = 1, zct-1 do begin
		fn = '/raw/mir7/'+datearr[i]+'/'+prefix+'.'+obnm[z[mz]]+'.fits'
		im = readfits(fn, hd0, /silent)
		fullim = [ [[fullim]], [[im]] ]
    endfor
    mfullim = median(fullim, dim=3)
    
;    for mz = 1, zct-1 do begin
;		fn = '/raw/mir7/'+datearr[i]+'/'+prefix+'.'+obnm[z[mz]]+'.fits'
;		im = readfits(fn, hd0, /silent)
;		limarr = [ [[limarr]], [[im[l1:r1, *]]] ]
;		rimarr = [ [[rimarr]], [[im[l2:r2, *]]] ]
 ;   endfor
    
;    mlimarr = median(limarr, dim=3)
;    mrimarr = median(rimarr, dim=3)
;    stop

	 if keyword_set(postplot) then begin
		 fn = nextnameeps('median'+datearr[i])
		 thick, 2
		 ps_open, fn, /encaps, /color
	 endif

    chipst2 = chip_geometry(hdr=hd0)
	 display, mfullim, min=2100, max=2525, /hist, $
	 ytitle='Dispersion Direction (px)', $
	 xtitle='Cross Dispersion Direction (px)'
	 
	 oplot_square, chipst2.image_trim.upleft, linestyle = 0, thick=5, color=210
	 oplot_square, chipst2.image_trim.upright, linestyle = 0, thick=5, color=110

	 if keyword_set(postplot) then begin
		 ps_close
	 endif
	 stop
	 for zz = 0, zct-1 do begin
		print, obnm[z[zz]], '  ',objnm[z[zz]], '  ',exptm[z[zz]], '  ',bin[z[zz]], '  ',slit[z[zz]]
		fn = '/raw/mir7/'+datearr[i]+'/'+prefix+'.'+obnm[z[zz]]+'.fits'
		print, 'FILE IS: ', fn
		chi_readnoise, fn=fn, mlimarr = mlimarr, mrimarr=mrimarr, nims = zct;, /pngplot
	 endfor; zz
  endif;zct > 0
  ;stop
endfor ;ndats

end;chi_driveron.pro