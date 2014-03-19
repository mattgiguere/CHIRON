pro makeResPlots

;find how many lines there are in text files that
;have data on the resolution for different decker modes
;although the print*res.pro scripts look through the past
;90 days, some may have bad data and are skipped
;we need to know how many elements to make for the arrays that
;will hold the data in these files

numNarrow=FILE_LINES('narrowThArRes')
numSlit=FILE_LINES('slitThArRes')
numSlicer=FILE_LINES('slicerThArRes')
numFiber=FILE_LINES('fiberThArRes')

;create the structures that will hold data in *ThArRes files
;just create the variables w correct data types, we will read 
;in the actual data later

narrowStruct={YYMMDD:0L, MJD:0.0D, NLINES:0L, RES:0.0D, mode:'aaaaa'}
slitStruct={YYMMDD:0L, MJD:0.0D, NLINES:0L, RES:0.0D, mode:'aaaa'}
slicerStruct={YYMMDD:0L, MJD:0.0D, NLINES:0L, RES:0.0D, mode:'aaaa'}
fiberStruct={YYMMDD:0L, MJD:0.0D, NLINES:0L, RES:0.0D, mode:'aaaaa'}

;create arrays of these structures using replicate and lines counted above

narrowData=replicate(narrowStruct,numNarrow)
slitData=replicate(slitStruct,numSlit)
slicerData=replicate(slicerStruct,numSlicer)
fiberData=replicate(fiberStruct,numFiber)

;open files and read data into arrays, one array at a time

openr,ntr,'narrowThArRes', /GET_LUN
readf,ntr,narrowData
close,ntr
FREE_LUN,ntr

openr,slittr,'slitThArRes', /GET_LUN
readf,slittr,slitData
close,slittr
FREE_LUN,slittr

openr,slictr,'slicerThArRes', /GET_LUN
readf,slictr,slicerData
close,slictr
FREE_LUN,slictr

openr,ftr,'fiberThArRes', /GET_LUN
readf,ftr,fiberData
close,ftr
FREE_LUN,ftr

date=STRING(slicerData[0].YYMMDD)
d=STRCOMPRESS(date, /REMOVE_ALL)
entry_device=!d.name
set_plot, 'PS'
device, filename=d+'tharlines.ps', xsize=10, ysize=10, /inches
plot, fiberData.mjd-2450000, fiberData.nlines, psym=5, charsize=1.5, yrange=[500,1700], xtitle='MJD-2450000', ytitle='# ThAr lines used'
oplot, slicerData.mjd-2450000, slicerData.nlines, psym=6
oplot, slitData.mjd-2450000, slitData.nlines, psym=4
oplot, narrowData.mjd-2450000, narrowData.nlines, psym=2
device, /close_file
set_plot, entry_device


entry_device=!d.name
set_plot, 'PS'
device, filename=d+'tharresolution.ps'
plot, narrowData.mjd-2450000, narrowData.res, psym=2,charsize=1.5, xtitle='MJD-2450000', ytitle='Resolution'
oplot, slitData.mjd-2450000, slitData.res, psym=4
oplot, slicerData.mjd-2450000, slicerData.res, psym=6
oplot, fiberData.mjd-2450000, fiberData.res, psym=5 
device, /close_file
set_plot, entry_device

SPAWN, 'convert '+STRING(d)+'tharresolution.ps '+STRING(d)+'tharresolution.png'
SPAWN, 'convert '+STRING(d)+'tharlines.ps '+STRING(d)+'tharlines.png'
SPAWN, 'rm *thar*.ps'
SPAWN, 'mv *thar*.png /home/matt/Sites/chi/plots/thar/'

return
end
