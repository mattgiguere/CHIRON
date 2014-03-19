pro printSlicerRes

datedirslis=STRARR(90)
NameOfFile='datedirs'
openr,pslicerresdd,NameOfFile, /GET_LUN
readf,pslicerresdd,datedirslis
close,pslicerresdd
openW,pslicerres,'slicerThArRes', /GET_LUN
cd, '/tous/mir7/fitspec/'
for i=0,89 do begin
	image='achi'+datedirslis[i]+'.1003.fits'
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
		printf,pslicerres, datedirslis[i], MJDotime, numlines, res," ", mode
	ENDIF
	cd, '/tous/mir7/fitspec/'
endfor
close,pslicerres
FREE_LUN, pslicerresdd
FREE_LUN, pslicerres

cd, '/tous/CHIRON/QC'

return
end
