pro blink_chis

im1 = double(readfits('/mir7/raw/110810/qa39.2700.fits', hd1))

im2 = double(readfits('/mir7/raw/110810/qa39.2703.fits', hd2))

im3 = double(readfits('/mir7/raw/110810/qa39.2953.fits', hd2))

im4 = double(readfits('/mir7/raw/110810/qa39.2968.fits', hd2))

im5 = double(readfits('/mir7/raw/110810/qa39.2978.fits', hd2))

loadct, 39, /silent

plot, im1[245, 1020:1035]  
oplot, im2[245, 1020:1035] , color=40
oplot, im3[245, 1020:1035] , color=80
oplot, im4[245, 1020:1035] , color=120
oplot, im5[245, 1020:1035] , color=240
 
 
stop

dif = im1 - im2
while 1 ne 0 do begin
display, dif[200:300, 1000:1100], /log, title='im1'
wait, 0.25
stop
display, im1[200:300, 1000:1100], /log, title='im2'
endwhile

stop
end;blink_chis.pro