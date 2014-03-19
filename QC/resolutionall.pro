pro resolutionall, DATE

SPAWN, 'ls -rd /tous/mir7/fitspec/1*', pathnames
;numdates=FILE_LINES('/tous/CHIRON/QC/datedirs')
;pathnames=STRARR(numdates)
;openr,batman,'datedirs',/GET_LUN
;readf,batman,pathnames
;close,batman
;FREE_LUN, batman

datedirsmod=STRMID(pathnames,19,26)
datedirsnum=LONG(datedirsmod)
index = where(datedirsnum LE DATE)
indexshort = index[0:90]
datadates=datedirsnum[indexshort]

narrowStruct={MJD:0.0D, NLINES:0L, RES:0.0D}
slitStruct={MJD:0.0D, NLINES:0L, RES:0.0D}
slicerStruct={MJD:0.0D, NLINES:0L, RES:0.0D}
fiberStruct={MJD:0.0D, NLINES:0L, RES:0.0D}

strcLen=N_ELEMENTS(datadates)

narrowData=replicate(narrowStruct,strcLen)
slitData=replicate(slitStruct,strcLen)
slicerData=replicate(slicerStruct,strcLen)
fiberData=replicate(fiberStruct,strcLen)

datadatesS=STRING(datadates)
FOR i =0, strcLen-1 DO BEGIN
   imageN=STRCOMPRESS('/tous/mir7/fitspec/'+datadatesS[i]+'/achi'+datadatesS[i]+'.1001.fits',/REMOVE)
   imageST=STRCOMPRESS('/tous/mir7/fitspec/'+datadatesS[i]+'/achi'+datadatesS[i]+'.1002.fits',/REMOVE)
   imageSR=STRCOMPRESS('/tous/mir7/fitspec/'+datadatesS[i]+'/achi'+datadatesS[i]+'.1003.fits',/REMOVE)
   imageF=STRCOMPRESS('/tous/mir7/fitspec/'+datadatesS[i]+'/achi'+datadatesS[i]+'.1004.fits',/REMOVE)
   IF (FILE_TEST(imageN) eq 1) THEN BEGIN
      headN=headfits(imageN)
      narrowData[i].MJD=date_conv(sxpar(headN,'UTSHUT'),'J')
      narrowData[i].NLINES=sxpar(headN,'THIDNLIN')
      narrowData[i].RES=sxpar(headN,'RESOLUTN')
   ENDIF
   IF (FILE_TEST(imageST) eq 1) THEN BEGIN
      headST=headfits(imageST)
      slitData[i].MJD=DATE_CONV(SXPAR(headST,'UTSHUT'),'J')
      slitData[i].NLINES=SXPAR(headST,'THIDNLIN')
      slitData[i].RES=SXPAR(headST,'RESOLUTN')
   ENDIF
   IF (FILE_TEST(imageSR) eq 1) THEN BEGIN
      headSR=headfits(imageSR)
      slicerData[i].MJD=DATE_CONV(SXPAR(headSR,'UTSHUT'),'J')
      slicerData[i].NLINES=SXPAR(headSR,'THIDNLIN')
      slicerData[i].RES=SXPAR(headSR,'RESOLUTN')
   ENDIF
   IF (FILE_TEST(imageF) eq 1) THEN BEGIN
      headF=headfits(imageF)
      fiberData[i].MJD=DATE_CONV(SXPAR(headF,'UTSHUT'),'J')
      fiberData[i].NLINES=SXPAR(headF,'THIDNLIN')
      fiberData[i].RES=SXPAR(headF,'RESOLUTN')
   ENDIF
ENDFOR
inarrowData=where(narrowData.mjd NE 0)
islitData=where(slitData.mjd NE 0)
islicerData=where(slicerData.mjd NE 0)
ifiberData=where(fiberData.mjd NE 0)

entry_device=!d.name
set_plot, 'PS'
sDATE=STRCOMPRESS(STRING(DATE), /REMOVE_ALL)
;ps_open, '/home/matt/Sites/chi/plots/thar/'+sDate+'tharlines'
device, filename='/home/matt/Sites/chi/plots/thar/'+sDate+'tharlines.ps', xsize=10, ysize=10, /inches
plot, narrowdata[inarrowData].mjd-2450000, narrowData[inarrowData].nlines, psym=1, charsize=1.5, yrange=[500,1700], xtitle='MJD', ytitle='# ThAr Lines'
oplot, slitData[islitData].mjd-2450000, slitData[islitData].nlines, psym=4
oplot, slicerData[islicerData].mjd-2450000, slicerData[islicerData].nlines, psym=6
oplot, fiberData[ifiberData].mjd-2450000, fiberdata[ifiberData].nlines, psym=5
al_legend, ['Narrow','Slit','Slicer','Fiber'],psym=[1,4,6,5], /bottom, /right
;ps_close
device, /close_file
set_plot, entry_device

entry_device=!d.name
set_plot, 'PS'
device,filename='/home/matt/Sites/chi/plots/thar/'+sDATE+'tharresolution.ps'
plot, narrowData[inarrowData].mjd-2450000, narrowData[inarrowData].res, psym=1, charsize=1.5, xtitle='MJD', ytitle='RESOLUTION'
oplot, slitData[islitData].mjd-2450000, slitData[islitData].res, psym=4
oplot, slicerData[islicerData].mjd-2450000, slicerData[islicerData].res, psym=6
oplot, fiberData[ifiberData].mjd-2450000, fiberData[ifiberData].res, psym=5
al_legend, ['Narrow','Slit','Slicer','Fiber'],psym=[1,4,6,5], /bottom, /right
device, /close_file
set_plot, entry_device

path='/home/matt/Sites/chi/plots/thar/'
spawn, 'convert -density 100 '+path+sDATE+'tharlines.ps '+path+sDATE+'tharlines.png'
spawn, 'convert -density 100 '+path+sDate+'tharresolution.ps '+path+sDATE+'tharresolution.png' 

END
