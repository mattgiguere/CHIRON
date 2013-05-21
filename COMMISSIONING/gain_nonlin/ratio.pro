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
; quad = 0...3 is the quadrant. quad=[2,3] for 'upperonly'
; Calculate img2/img1
pro ratio, filename1, filename2, quad

threshold = 1000d ; above bias
thres_max=5000d

sections = ['11', '12','21','22'] ; correspondence between image sections and quadrants

sec = sections[quad] 


  img =  readfits(filename1+'.fits', /noscale, hdr,  /silent )

  tsec = [sxpar(hdr,'TSEC'+sec[0]), sxpar(hdr,'TSEC'+sec[1])]
;   if (tsec eq 0 ) then begin
;     print, 'Image section is not found, returning'
;     return
;   endif

  trim = [getsec(sxpar(hdr,'TSEC'+sec[0]))-1, getsec(sxpar(hdr,'TSEC'+sec[1]))-1]
  bias = [getsec( sxpar(hdr,'BSEC'+sec[0]))-1 , getsec( sxpar(hdr,'BSEC'+sec[1]))-1 ]

  medbias1 = median(img[bias[0]:bias[1],bias[2]:bias[3]])
  timg1 = float(img[trim[0]:trim[1], trim[2]:trim[3]]) - medbias1
  nx = trim[1]-trim[0]+1 & ny =  trim[3]-trim[2]+1

  img =  readfits(filename2+'.fits', /noscale, hdr,  /silent )

 medbias2 = median(img[bias[0]:bias[1],bias[2]:bias[3]])
  timg2 = float(img[trim[0]:trim[1], trim[2]:trim[3]]) - medbias2
;   nx2 = trim[1]-trim[0]+1 & ny1 =  trim[3]-trim[2]+1


;    stop

  ratio = fltarr(nx,ny)
  sel = where(timg1 gt threshold and timg1 lt thres_max)
  rat = timg2[sel]/timg1[sel]
  mrat = mean(rat)

  print, 'Mean ratio: ', mrat


  int = timg1[sel]
;   ord = sort(int)
;   plot, int[ord],rat[ord], ys=1, psym=3, xtitle='Signal, ADU', ytitle='Intensity ratio'   

  ratio[sel] = rat
writefits, 'ratio.fits', ratio

stop

print, 'Computing the variance...'

nbin = 50
wbin = max(int)/nbin > 100

;wbin = 100. ; bin width
nbin = (max(int) - threshold)/wbin
bins = (findgen(nbin+1)+ 1)*wbin

av = fltarr(nbin) & var = fltarr(nbin) & npts = lonarr(nbin)
avrat = fltarr(nbin)

for j=0,nbin-1 do begin
s = where((int ge bins[j]) and (int lt bins[j+1]))
if (s[0] ge 0) then begin  
   av[j] = mean(int[s])
   var[j] = variance(rat[s])
   npts[j] = n_elements(s)
   avrat[j] = mean(rat[s])
endif
endfor
print, 'Done!'

ss = where(npts gt 100)
;ss = where(var gt 0)
var = var[ss] & av = av[ss]
avrat = avrat[ss]

plot, av, avrat, psym=6,  xtitle='Signal count, ADU', ytitle='Ratio', ys=1

stop

plot, av, var, psym=6, xtitle='Signal count, ADU', ytitle='Variance, ADU^2'

stop

ron = 3.1 ; ADU rms readout noise
; subtract RON from the variance of the ratio
var1 = var - ron^2/av^2*(1. + mrat^2) 


nph = mrat*(mrat+ 1.)/var1
gain = nph/av

plot, av, gain, psym=6, xtitle='Signal, ADU', ytitle='Gain, el/ADU' 


stop


end
