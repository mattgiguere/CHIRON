pro printFiberRes

datedirslis=STRARR(90)
NameOfFile='datedirs'
openr,pfrdd,NameOfFile, /GET_LUN
readf,pfrdd,datedirslis
close,pfrdd
openW,pfr,'fiberThArRes', /GET_LUN
cd, '/tous/mir7/fitspec'
for i=0,89 do begin
	image='achi'+datedirslis[i]+'.1004.fits'
	filetest=FILE_TEST(datedirslis[i]+'/'+image)
	IF (filetest eq 1) THEN BEGIN
		cd,datedirslis[i]
;		print,datedirslis[i]
		head=headfits(image)
		res=sxpar(head,'RESOLUTN')
		numlines=sxpar(head,'THIDNLIN')
		otime=sxpar(head,'DATE-OBS')
		MJDotime=date_conv(otime,'J')
		mode=sxpar(head,'DECKER')
		printf,pfr, datedirslis[i], MJDotime, numlines, res," ", mode
	ENDIF
	cd, '/tous/mir7/fitspec/'
endfor
close,pfr
FREE_LUN,pfr
FREE_LUN,pfrdd


cd, '/tous/CHIRON/QC'

return
end
