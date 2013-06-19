;+
;
;  NAME: 
;     chi_update_qc_index
;
;  PURPOSE: 
;   
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      chi_update_qc_index
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
;      chi_update_qc_index
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2012.03.15 06:52:40 PM
;
;-
pro chi_update_qc_index, $
help = help, $
postplot = postplot, $
rootdir = rootdir

green='#5CEC21'
yellow='yellow'
cyan='cyan'
red='#EC020B'

if ~keyword_set(rootdir) then rootdir = '/home/matt/Sites/chi/'
mstringarr = ['January', 'February', 'March', 'April', 'May', 'June', $
'July', 'August', 'September', 'October', 'November', 'December']
mdays = [31, 28, 31, 30, 31, 30, $
         31, 31, 30, 31, 30, 31]
loadct, 39, /silent
usersymbol, 'circle', /fill, size_of_sym = 0.5
bdate = 120302L
byear = 2012L
bmonth = 03L
caldat, systime(/julian, /utc), cmonth, cday, cyear
nmonths = (cyear - byear)*12 + cmonth - bmonth + 1
cdate = long(strmid(strt(cyear),2,2)+strt(cmonth,f='(I02)')+strt(cday, f='(I02)'))
print, 'Number of months: ', nmonths
spawn, 'ls -1 '+rootdir+'*quality.html', files
dates = strmid(files, 21, 6)
links = strmid(files, 21, 18)
htmlfn = rootdir+'index.html'
openw, 3, htmlfn
printf, 3, '<html>'
printf, 3, '<head>'
printf, 3, '<title>'
printf, 3, 'CHIRON Quality Control Page'
printf, 3, '</title>'
printf, 3, '</head>'
printf, 3, '<body>'

printf, 3, '<h4>Index</h4><br>'
printf, 3, '<table border ="+1">'
printf, 3, '<tr>'
printf, 3, '<td width=20 bgcolor='+green+'>'
printf, 3, '</td>'
printf, 3, '<td> good'
printf, 3, '</td>'
printf, 3, '</tr>'

printf, 3, '<tr>'
printf, 3, '<td bgcolor='+yellow+'>'
printf, 3, '</td>'
printf, 3, '<td> checked'
printf, 3, '</td>'
printf, 3, '</tr>'

printf, 3, '<tr>'
printf, 3, '<td bgcolor='+cyan+'>'
printf, 3, '</td>'
printf, 3, '<td> no data'
printf, 3, '</td>'
printf, 3, '</tr>'

printf, 3, '<tr>'
printf, 3, '<td bgcolor='+red+'>'
printf, 3, '</td>'
printf, 3, '<td> error'
printf, 3, '</td>'
printf, 3, '</tr>'

printf, 3, '</table>'

nodata = [$
'120303', $
'120304', $
'120308', $
'120409', $
'120525', $
'120526', $
'120527', $
'120528', $
'120529', $
'120530', $
'120602', $
'120803', $
'120813', $
'120815', $
'120816', $
'120817', $
'120822', $
'120823', $
'120830', $
'120902', $
'120909', $
'120917', $
'121005', $
'121006', $
'121007', $
'121008', $
'121021', $
'121114', $ ;shutter malfunction
'121115', $ ;shutter malfunction
'121210', $ ;dewar repair
'121211', $ ;dewar repair
'121219', $ ;bad weather
'121224', $ ;night off
'121225', $ ;night off
'121230', $ ;no data/slicer motor died
'121231', $ ;vacation
'130101', $ ;holiday
'130107', $ ;manuel's medical tests
'130108', $ ;manuel's medical tests
'130109', $ ;manuel's medical tests
;'130119', $ ;quartz not working - calibs copied over from the 130118
'130120', $ ;bad weather all night
'130213', $ ;RC Spec all night
'130215', $ ;RC Spec all night
'130217',  $ ;RC Spec all night
'130219',  $ ;RC Spec all night
'130221',  $ ;RC Spec all night
'130222',  $ ;SIMON Commissioning
'130223',  $ ;SIMON Commissioning
'130224',  $ ;SIMON Commissioning
'130225',  $ ;SIMON Commissioning
'130226',  $ ;SIMON Commissioning
'130227',  $ ;SIMON Commissioning
'130228',  $ ;SIMON Commissioning
'130301',  $ ;SIMON Commissioning
'130302',  $ ;SIMON Commissioning
'130303',  $ ;SIMON Commissioning
'130304',  $ ;SIMON Commissioning
'130305',  $ ;SIMON Commissioning
'130306',  $ ;SIMON Commissioning
'130307',  $ ;SIMON Commissioning
'130308' , $ ;SIMON Commissioning, but test observations made
'130320', $ ;Maneul took the night off for medical testing
'130409',  $ ;Bad weather
'130430',  $ ;Bad weather all night
'130512', $ ;bad weather
'130517', $ ;pouring rain all night
'130527', $ ;rain all night
'130529', $ ;unexpected vacation
'130530', $ ;unexpected vacation
'130606', $ ;unexpected vacation, SIMON only
'130607', $ ;unexpected vacation, SIMON only
'130608', $ ;unexpected vacation, SIMON only
'130609', $ ;unexpected vacation, SIMON only
'130610', $ ;unexpected vacation, SIMON only
'130611', $ ;unexpected vacation, SIMON only
'130612' $ ;unexpected vacation, SIMON only
]

checked = [$
'120607',$
'120810', $
'']

;restore the bary log:
restore, '/tous/mir7/bary/qbcvel.dat'

for m=0, nmonths-1 do begin
;stop
;printed month:
pmonthn = (m + bmonth - 1) mod 12
;stop
pmonth = mstringarr[pmonthn]
;printed year:
pyear = 2012 + floor((m + bmonth - 1)/12d)
;stop
   printf, 3, '<h3> '+strt(pyear)+' '+pmonth+' </h3><br>'
   spawn, 'ls -1 '+rootdir+''+strmid(strt(pyear),2,2)+strt(pmonthn +1L, f='(I02)')+'*quality.html', mfiles
   mdates = strmid(mfiles, 21, 6)
   mlinks = strmid(mfiles, 21, 18)
   print, 'Now working on month: ', pmonth, ' of year: ', pyear, ', which has ',mdays[pmonthn], ' days.'
   
printf, 3, '<table border ="+1">'
printf, 3, '<tr><th>DATE</th><th>REDUCED</th><th>DISTRIB</th><th>BARY</th><th>DATE</th><th>REDUCED</th><th>DISTRIB</th><th>BARY</th><th>DATE</th><th>REDUCED</th><th>DISTRIB</th><th>BARY</th></tr>'
   for i=1, mdays[pmonthn], 3 do begin
     printf, 3, '<tr>'

     if i le mdays[pmonthn] then begin
	   ;FIRST DAY OF ROW
	   date = strmid(strt(pyear),2,2)+strt(pmonthn+1L, f='(I02)')+strt(i, f='(I02)')
	   link = date+'quality.html'
	   if long(date) ge bdate and long(date) lt cdate then begin
         ;column 1: the qc page:
		 if file_test(rootdir+link) then col=green else col=red
		 dum = where(nodata eq date, ndct)
		 if ndct then col=cyan
		 dum = where(checked eq date, ckct)
		 if ckct then col=yellow
		 printf, 3, '<td bgcolor='+col+' align=center>'
		 printf, 3, '<a href="'+link+'" > '+date+' </a>'
		 printf, 3, '</td>'

         ;column 2: the reduction dir:
		 if file_test('/tous/mir7/fitspec/'+date) then rcol=green else rcol=red
		 dum = where(nodata eq date, ndct)
		 if ndct then rcol=cyan
		 dum = where(checked eq date, ckct)
		 if ckct then rcol=yellow
		 printf, 3, '<td bgcolor='+rcol+' align=center>'
		 printf, 3, 'REDUCED'
		 printf, 3, '</td>'
		 
         ;column 3: the distribution dir:
		 if file_test('/tous/mir7/queueobs/'+date) then dcol=green else dcol=red
		 dum = where(nodata eq date, ndct)
		 if ndct then dcol=cyan
		 dum = where(checked eq date, ckct)
		 if ckct then dcol=yellow
		 
		 printf, 3, '<td bgcolor='+dcol+' align=center>'
		 printf, 3, 'DISTRIB'
		 printf, 3, '</td>'
		 
         ;column 4: in qbcvel.dat:
         dum = where(strmid(strt(bcat.obsnm),3,6) eq date, baryct)
		 if baryct gt 1 then dcol=green else dcol=red
		 dum = where(nodata eq date, ndct)
		 if ndct then dcol=cyan
		 dum = where(checked eq date, ckct)
		 if ckct then dcol=yellow
		 
		 printf, 3, '<td bgcolor='+dcol+' align=center>'
		 printf, 3, strt(baryct)
		 printf, 3, '</td>'
	   endif else printf, 3, '<td></td> <td></td> <td></td> <td></td>'
     endif

     if i+1 le mdays[pmonthn] then begin
	   ;SECOND DAY OF ROW
	   date = strmid(strt(pyear),2,2)+strt(pmonthn+1L, f='(I02)')+strt(i+1, f='(I02)')
	   link = date+'quality.html'
	   if long(date) ge bdate and long(date) lt cdate then begin
         ;column 1: the qc page:
		 if file_test(rootdir+link) then col=green else col=red
		 dum = where(nodata eq date, ndct)
		 if ndct then col=cyan
		 dum = where(checked eq date, ckct)
		 if ckct then col=yellow
		 printf, 3, '<td bgcolor='+col+' align=center>'
		 printf, 3, '<a href="'+link+'" > '+date+' </a>'
		 printf, 3, '</td>'

         ;column 2: the reduction dir:
		 if file_test('/tous/mir7/fitspec/'+date) then rcol=green else rcol=red
		 dum = where(nodata eq date, ndct)
		 if ndct then rcol=cyan
		 dum = where(checked eq date, ckct)
		 if ckct then rcol=yellow
		 printf, 3, '<td bgcolor='+rcol+' align=center>'
		 printf, 3, 'REDUCED'
		 printf, 3, '</td>'
		 
         ;column 3: the distribution dir:
		 if file_test('/tous/mir7/queueobs/'+date) then dcol=green else dcol=red
		 dum = where(nodata eq date, ndct)
		 if ndct then dcol=cyan
		 dum = where(checked eq date, ckct)
		 if ckct then dcol=yellow
		 
		 printf, 3, '<td bgcolor='+dcol+' align=center>'
		 printf, 3, 'DISTRIB'
		 printf, 3, '</td>'
		 
         ;column 4: in qbcvel.dat:
         dum = where(strmid(strt(bcat.obsnm),3,6) eq date, baryct)
		 if baryct gt 1 then dcol=green else dcol=red
		 dum = where(nodata eq date, ndct)
		 if ndct then dcol=cyan
		 dum = where(checked eq date, ckct)
		 if ckct then dcol=yellow
		 
		 printf, 3, '<td bgcolor='+dcol+' align=center>'
		 printf, 3, strt(baryct)
		 printf, 3, '</td>'
	   endif else printf, 3, '<td></td> <td></td> <td></td> <td></td>'
     endif

     if i+2 le mdays[pmonthn] then begin
	   ;THIRD DAY OF ROW
	   date = strmid(strt(pyear),2,2)+strt(pmonthn+1L, f='(I02)')+strt(i+2, f='(I02)')
	   link = date+'quality.html'
	   if long(date) ge bdate and long(date) lt cdate then begin
         ;column 1: the qc page:
		 if file_test(rootdir+link) then col=green else col=red
		 dum = where(nodata eq date, ndct)
		 if ndct then col=cyan
		 dum = where(checked eq date, ckct)
		 if ckct then col=yellow
		 printf, 3, '<td bgcolor='+col+' align=center>'
		 printf, 3, '<a href="'+link+'" > '+date+' </a>'
		 printf, 3, '</td>'

         ;column 2: the reduction dir:
		 if file_test('/tous/mir7/fitspec/'+date) then rcol=green else rcol=red
		 dum = where(nodata eq date, ndct)
		 if ndct then rcol=cyan
		 dum = where(checked eq date, ckct)
		 if ckct then rcol=yellow
		 printf, 3, '<td bgcolor='+rcol+' align=center>'
		 printf, 3, 'REDUCED'
		 printf, 3, '</td>'
		 
         ;column 3: the distribution dir:
		 if file_test('/tous/mir7/queueobs/'+date) then dcol=green else dcol=red
		 dum = where(nodata eq date, ndct)
		 if ndct then dcol=cyan
		 dum = where(checked eq date, ckct)
		 if ckct then dcol=yellow
		 
		 printf, 3, '<td bgcolor='+dcol+' align=center>'
		 printf, 3, 'DISTRIB'
		 printf, 3, '</td>'
		 
         ;column 4: in qbcvel.dat:
         dum = where(strmid(strt(bcat.obsnm),3,6) eq date, baryct)
		 if baryct gt 1 then dcol=green else dcol=red
		 dum = where(nodata eq date, ndct)
		 if ndct then dcol=cyan
		 dum = where(checked eq date, ckct)
		 if ckct then dcol=yellow
		 
		 printf, 3, '<td bgcolor='+dcol+' align=center>'
		 printf, 3, strt(baryct)
		 printf, 3, '</td>'
	   endif else printf, 3, '<td></td> <td></td> <td></td> <td></td>'
     endif

     printf, 3, '</tr>'
   endfor;ndays
     printf, 3, '</table>'
endfor;nmonths
printf, 3, '<br>'
printf, 3, '<br>'
printf, 3, '<a href="http://exoplanets.astro.yale.edu/~jspronck/chiron/CHIRTEMP.html" target="new">'
printf, 3, "Click here to go to the CHIRON Environmental Monitoring Pages </a>"
printf, 3, '<br>'
printf, 3, '<a href="http://exoplanets.astro.yale.edu/~jspronck/chiron/CHIRON_TIMELINE.html" target="new">'
printf, 3, "CHIRON TIMELINE </a>"
printf, 3, '<br>'
printf, 3, '<br>'
printf, 3, 'last modified: '+systime()
printf, 3, '</body>'
printf, 3, '</html>'
close, 3

end;chi_update_qc_index.pro