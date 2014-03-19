pro printNarrowRes

datedirslis=STRARR(90)
NameOfFile='datedirs'
openr,pnrdd,NameOfFile, /GET_LUN
readf,pnrdd,datedirslis
close,pnrdd
openW,pnr,'narrowThArRes', /GET_LUN
cd, '/tous/mir7/fitspec'
for i=0,89 do begin
	image='achi'+datedirslis[i]+'.1001.fits'
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
		printf,pnr, datedirslis[i], MJDotime, numlines, res, " ", mode
	ENDIF
	cd, '/tous/mir7/fitspec/'
endfor
close,pnr
FREE_LUN, pnr
FREE_LUN, pnrdd

cd, '/tous/CHIRON/QC'

return
end
