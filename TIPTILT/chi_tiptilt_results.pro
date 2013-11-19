;+
;
;  NAME: 
;     chi_tiptilt_results
;
;  PURPOSE: 
;   
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      chi_tiptilt_results
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
;      chi_tiptilt_results
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2013.11.13 11:52:56
;
;-
pro chi_tiptilt_results, $
postplot = postplot

angstrom = '!6!sA!r!u!9 %!6!n'
!p.color=0
!p.background=255
loadct, 39, /silent
usersymbol, 'circle', /fill, size_of_sym = 0.5
if yalehost() then mdir='/home/matt/' else mdir='/Users/matt/'

restore, '/tous/mir7/logstructs/2013/131003log.dat'
emcts = dblarr(7)
emctrt = dblarr(7)
snr = dblarr(7)
tiptilt = intarr(7)
exptime = dblarr(7)
airmass = dblarr(7)
for i=127, 133 do begin
   j = i-127
   emcts[j] = double(log[i].emavg)*double(log[i].emnumsmp)
   emctrt[j] = double(log[i].emavg)
   snr[j] = double(log[i].snrbp5500)
   exptime[j] = double(log[i].exptime)
   airmass[j] = double(log[i].airmass)
endfor;loop through tip tilt observations

tiptilt = [0,1,0,1,0,1,0]
on = where(tiptilt eq 1)
off = where(tiptilt eq 0)
seqnums = lindgen(7) + 1127L

if keyword_set(postplot) then begin
   fn = nextnameeps('131003_EM_CTS')
   thick, 2
   ps_open, fn, /encaps, /color
endif

usersymbol, 'circle', /fill, size_of=1
plot, seqnums, emcts/1d6, ps=8, col=0, xrange=[1126, 1134], /nodata, $
/ysty, yran=[2.845,2.853], $
xtitle='Sequence Number', ytitle='EM CTS/ 10!u6!n (EMAVG * EMNUMSMP/10!u6!n)'
oplot, seqnums[off], emcts[off]/1d6, col=250, ps=8
oplot, seqnums[on], emcts[on]/1d6, col=70, ps=8
al_legend, ['TT ON', 'TT OFF'], col=[70, 250], psym=[8,8]
if keyword_set(postplot) then begin
   ps_close
endif

stop

if keyword_set(postplot) then begin
   fn = nextnameeps('131003_EM_CT_RT')
   thick, 2
   ps_open, fn, /encaps, /color
endif

plot, seqnums, emctrt, ps=8, col=0, xrange=[1126, 1134], /nodata, $
/ysty, yran=[330,440], $
xtitle='Sequence Number', ytitle='EM AVG Count Rate'
oplot, seqnums[off], emctrt[off], col=250, ps=8
oplot, seqnums[on], emctrt[on], col=70, ps=8
al_legend, ['TT ON', 'TT OFF'], col=[70, 250], psym=[8,8]

print, 'Mean TT ON EXPM CT RATE: ', mean(emctrt[on])
print, 'Mean TT OFF EXPM CT RATE: ', mean(emctrt[off])

if keyword_set(postplot) then begin
   ps_close
endif

stop

if keyword_set(postplot) then begin
   fn = nextnameeps('131003_SNR')
   thick, 2
   ps_open, fn, /encaps, /color
endif

plot, seqnums, snr, ps=8, col=0, xrange=[1126, 1134], /nodata, $
/ysty, yran=[228,238], $
xtitle='Sequence Number', ytitle='SNR at Blaze Peak Nearest 5500 '+angstrom
oplot, seqnums[off], snr[off], col=250, ps=8
oplot, seqnums[on], snr[on], col=70, ps=8
al_legend, ['TT ON', 'TT OFF'], col=[70, 250], psym=[8,8]

if keyword_set(postplot) then begin
   ps_close
endif

stop
ccdctrt = snr^2 / exptime


if keyword_set(postplot) then begin
   fn = nextnameeps('131003_CCD_CT_RT')
   thick, 2
   ps_open, fn, /encaps, /color
endif

plot, seqnums, ccdctrt, ps=8, col=0, xrange=[1126, 1134], /nodata, $
/ysty, $
xtitle='Sequence Number', ytitle='CCD Count Rate at Blaze Peak Nearest 5500 '+angstrom
oplot, seqnums[off], ccdctrt[off], col=250, ps=8
oplot, seqnums[on], ccdctrt[on], col=70, ps=8
al_legend, ['TT ON', 'TT OFF'], col=[70, 250], psym=[8,8]

print, 'Mean TT ON CCD CT RATE: ', mean(ccdctrt[on])
print, 'Mean TT OFF CCD CT RATE: ', mean(ccdctrt[off])

if keyword_set(postplot) then begin
   ps_close
endif

if keyword_set(postplot) then begin
   fn = nextnameeps('131003_AIRMASS')
   thick, 2
   ps_open, fn, /encaps, /color
endif

plot, seqnums, airmass, ps=8, col=0, xrange=[1126, 1134], /nodata, $
/ysty, yran=[1,1.4], $
xtitle='Sequence Number', ytitle='Airmass'
oplot, seqnums[off], airmass[off], col=250, ps=8
oplot, seqnums[on], airmass[on], col=70, ps=8
al_legend, ['TT ON', 'TT OFF'], col=[70, 250], psym=[8,8], /right

if keyword_set(postplot) then begin
   ps_close
endif

stop

end;chi_tiptilt_results.pro