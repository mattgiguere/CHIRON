pro printSlitRes

datedirslis=STRARR(90)
NameOfFile='datedirs'
openr,pslitresdd,NameOfFile, /GET_LUN
readf,pslitresdd,datedirslis
close,pslitresdd
openW,pslitres,'slitThArRes', /GET_LUN
cd, '/tous/mir7/fitspec/'
for i=0,89 do begin
	image='achi'+datedirslis[i]+'.1002.fits'
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
		printf,pslitres, datedirslis[i], MJDotime, numlines, res, " ", mode
	ENDIF
	cd, '/tous/mir7/fitspec/'
endfor
close,pslitres

FREE_LUN,pslitresdd
FREE_LUN,pslitres

cd, '/tous/CHIRON/QC'

return
end
