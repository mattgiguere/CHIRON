; Remove median bias and combine in one image
; fn = '../images/qa30.0518';
;--------------------------------------------------------------------------
; returns [i1,i2,i3,i4] array from a string like [63:2110,1:2056]
function getsec, sec
comma =  strpos(sec, ',')
len = strlen(sec)
 sx =  strmid(sec, 1, comma-1)
 i1 =  fix(strmid(sx,0, strpos(sx, ':')))
 i2 = fix(strmid(sx,strpos(sx, ':')+1))

 sy =  strmid(sec, comma+1,len-comma-2)
 i3 =  fix(strmid(sy,0, strpos(sy, ':')))
 i4 = fix(strmid(sy,strpos(sy, ':')+1))
return, [i1,i2,i3,i4]

end
;--------------------------------------------------------------------------
; Linearity plot
pro lin


sections = ['21','22'] ; correspondence between image sections and quadrants

nf =11
files = strarr(nf)
close, /all
openr, 1, 'files.txt'
a=''
for i=0,nf-1 do begin 
 readf, 1, a
 files[i] = a
endfor
close, 1
print, 'File names: ', files
stop

dat = fltarr(nf, 3) ; texp, flux1, flux2

for i=0,nf-1 do begin
  print, 'Reading file '+files[i]
  img =  readfits(files[i]+'.fits', /noscale, hdr,  /silent )   

  texp = float(sxpar(hdr,'EXPTIME'))
  flux = fltarr(2)
  for j=0,1 do begin ; two image sections

    trim = getsec(sxpar(hdr,'TSEC'+sections[j]))-1
    bias = getsec( sxpar(hdr,'BSEC'+sections[j]))-1 
    medbias = median(img[bias[0]:bias[1],bias[2]:bias[3]])

; prepare bright-pixel masks from the first 5s exposure
    if (i eq 0) then begin    
       tmp = img[trim[0]:trim[1], trim[2]:trim[3]] - medbias
       sel = where(tmp ge 0.8*max(tmp)) ; 80% of maximum
      if (j eq 0) then mask0 = sel else mask1 = sel
    endif ; masks

    tmp = img[trim[0]:trim[1], trim[2]:trim[3]] - medbias
    if (j eq 0) then flux[j] = total(tmp[mask0]) else  flux[j] = total(tmp[mask1])
  endfor
  dat[i,*] = [texp, flux]
endfor
print, 'Files are processed'
save, fi='lin1.idl', dat

stop

!p.charsize = 1.5

ord = sort(dat[*,0])
texp = dat[ord, 0]
lin21 =  dat[ord,1]/texp
lin22 =  dat[ord,2]/texp

sig21 =  dat[ord,1]/n_elements(mask0) ; signal, ADU
sig22 =  dat[ord,2]/n_elements(mask1) ; signal, ADU

plot, texp, lin21, psym=6, /xlog,  xtitle='Exposure, sec', ytitle='Flux[21]/texp'
oplot,  texp, lin21

stop

plot, texp, lin22, psym=6, /xlog,  xtitle='Exposure, sec', ytitle='Flux[22]/texp'
oplot,  texp, lin22


stop

plot, sig21, lin21, psym=6, /xlog,  xtitle='Signal, ADU', ytitle='Flux[21]/texp'
oplot,  sig21, lin21

stop

plot, sig22, lin22, psym=6, /xlog,  xtitle='Signal, ADU', ytitle='Flux[22]/texp'
oplot,  sig22, lin22


stop

end

