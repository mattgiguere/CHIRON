;+
;;  NAME: 
;     chi_view_i2
;;  PURPOSE: 
;   
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      chi_view_i2
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
;      chi_view_i2
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2011.07.14 01:13:43 PM
;
;-
pro chi_view_i2, date = date

if ~keyword_set(date) then date = '110504'
dir = '/mir7/raw/'

if date eq '110504' then begin
imi2y = readfits(dir+date+'/qa34.7206.fits', hd)
imi2n = readfits(dir+date+'/qa34.7207.fits', hd)
endif

if date eq '110505' then begin
imi2y = readfits(dir+date+'/qa34.7706.fits', hd)
imi2n = readfits(dir+date+'/qa34.7707.fits', hd)
endif

if date eq '110531' then begin
imi2y = readfits(dir+date+'/qa37.3706.fits', hd)
imi2n = readfits(dir+date+'/qa37.3707.fits', hd)
endif

if date eq '110609' then begin
imi2y = readfits(dir+date+'/qa37.4206.fits', hd)
imi2n = readfits(dir+date+'/qa37.4207.fits', hd)
endif

if date eq '110611' then begin
imi2y = readfits(dir+date+'/qa37.5106.fits', hd)
imi2n = readfits(dir+date+'/qa37.5107.fits', hd)
endif

if date eq '110611' then begin
imi2y = readfits(dir+date+'/qa37.5106.fits', hd)
imi2n = readfits(dir+date+'/qa37.5107.fits', hd)
endif

if date eq '110712' then begin
imi2y = readfits(dir+date+'/qa38.3686.fits', hd)
imi2n = readfits(dir+date+'/qa38.3687.fits', hd)
endif



display, imi2y, /log

;stop
window, /free
display, imi2y[600:700, *], /log

window, /free
display, imi2y[640:660, *], /log

window, /free
display, imi2y[640:660, 900:1500], /log

window, /free
plot, imi2y[645, 900:1500]

plot, imi2n[645, 900:1500]*2d
oplot, imi2y[645, 900:1500]

start = 900L
fin = 1500L
px = lindgen(fin - start + 1) + start

p1 = plot(px, imi2n[645, start:fin]*2d, $
xtitle='pixel', $
ytitle='ADU', $
margin = [0.175, 0.09, 0.08, 0.075], $
name = date+' i2=n', $
yrange=[2d3, 12d3])

p2 = plot(px, imi2y[645, start:fin], $
name = date+' i2=y', $
color='orange', $
/over)

l1 = legend(target=[p1,p2], position=[0.6,0.3])
p1.save, nextname('/mir7/plot_i2/'+date+'iod', '.png')

;stop
end;chi_view_i2.pro