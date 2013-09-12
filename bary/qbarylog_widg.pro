pro qbarylog,cep=cep,test=test,logfile,tyc=tyc

; FUNCTION: Calculate Barycentric Correction for
; 	    Stellar spectra.

;  METHOD: 1.) Obtain Object Name, FLUX-WIEGHTED mean epoch, etc. from
;              online logsheets.
;          2.) Star  positions are stored in: /mir7/bary/ctio_st.dat,  hip.dat,
;              kother.ascii (ktranslation.dat rarely used to find HIP numbers)
;          3.) Drive qbary.pro, which makes calculation.
;          4.) Append qbcvel.ascii file


;Create: NOV-7-93	ECW
;Modified: JUL-95	CMc.   Modified to Drive New Barycentric Routines 
;Modified; JAN-96       ECW    Modified to get input info from online 
;			       logsheets.  Currently setup to run on 
;                              the machines: hodge,quark,coude.
;Modified; Jan-97       GWM    cleaned up, made identical to Keck version
;Modified; Nov-97       GWM    Auto-read log lines; Invoke hipparcos catalog
;Modified; Nov-01   CMc    To accomodate 1000+ image seismology runs
;                               & general cleanup
;Modified; May-02   CMc    To include remove acc. calc. + other improvements
;Modified; Feb-05   CMc:
; --    To execute bcvel.ascii backups into bcvel_backup/ directory
; --    Convert From kbarylog to barylog for CTIO.
; --    "HR" designated stars do not have BC's computed.
;
;VARIABLE DECLARATION:
noerror=1 & chk='' & du='' & dum=''  &  dummy=''  &  tpname=''  &  req=''  
log='' &  logline='' &  obtype='' & mid=''
year=0  &  month=0  &  day=0  &  hr=0  & sc=0 & epoch=0
if n_elements(logfile) eq 0 then logfile='' 

;
skiplist= ['WIDEFLAT','WIDE','WF','W','WIDE-FLAT','WIDE/FLAT','W/F', $
           'WIDEFLATS','WIDES','WFS','WIDE-FLATS','WIDE/FLATS', $
           'WIDE_FLAT','FLAT','JUNK', 'FOCUS','quartz','QUARTZ','Quartz',$
           'QTZ', 'qtz', 'Qtz','FLATFIELD','SATURATED','SKIP']
iodlist = ['IODINE','I','I2','IOD']
thorlist = ['TH-AR','TH_AR','THAR','TH/AR','THORIUM','THORIUM-ARGON']
daylist = ['DAY','DS','DAYSKY','DAY-SKY','DAY_SKY', 'moon', 'MOON']
skylist = ['SKY', 'DARK','BIAS','narrowflat','narrflat','SUN','Sun','sun','SKYTEST']

;DEFINE STRUCTURES
maxsize = 5000                  ; 
log = {log, object: '', hour: '', min: '', sec: '', type: ''}
temp = {bcvel, filename:'', object:'', cz:0.d0, mjd:0.d0, ha:0.d0, type:''} ;Temporary structure for results
temp = replicate(temp[0],maxsize)


strucfile = '/mir7/bary/ctio_st.dat'
barydir = '/mir7/bary/'
logdir = '/mir7/logsheets/'

if (findfile(strucfile))(0) eq '' then message,strucfile+  ' is missing.'
if keyword_set(test) then bf='qbcvel.test.ascii' else bf='qbcvel.ascii'

bcfile = barydir+bf
bcfile = barydir+'qbcvel.ascii'  ; test.ascii'!!!

tempbcfile = strarr(maxsize)    ;temporary storage of ascii results: 200 lines

print,'     *************************************************************'
print,'     **      THE CTIO BARYCENTRIC CORRECTIONS PROGRAM           **'
print,'     **                                                         **'
print,'     ** You input:                                              **'
print,'     **            LOGSHEET filename ,ie., g38.logsheet1        **'
print,'     **            UT DATE of the Observations                  **'
print,'     **                                                         **'
print,'     ** Output to: '  +  bcfile  +      '                       **'
print,'     **                                                         **'
print,'     *************************************************************'

;PROMPT FOR ONLINE LOGSHEET FILENAME
print,' '
GETLOGSHEET:

if  logfile[0] eq '' then begin
    print,''
    print,'Enter the logsheet filename (i.e., 080810)'
    print,'(Do not include path.)'
    read,logfile
    print,'Enter the tpname (e.g. qa02): '
    read,tpname
endif

logfileorig = logfile
firstlet = strmid(logfile,0,1) 

;period = strpos(logfile,'.')
;if period[0] ne -1 then tpname = strmid(logfile,0,period) else 

;READ LOGSHEET

print,'reading: ',logfile

restore,strucfile & cat = dum   ;RESTORE COORD. STRUCTURE

spawn, 'cat ' + logdir + logfile , output
output = cull(output)           ; remove any blank lines
logline = (output(where(getwrds(output,0,/nocull) eq 'UT')))[0] ; 1 element
firstlogline = strmid(logline,0,26) ; first part of line contains UT date


;PROMPT FOR DATE IN UNIVERSAL TIME.
repeat begin
    Print,'Here is the UT date from the log:'
    print & print,firstlogline  &   print

    daterite=0
    print,''
    print,'Enter the UT date of the observation:'
    repeat begin
        noerror=1
        read, 'Give Month [1-12]:', month
        read, 'Give UT Date [1-31]:', day
        read, 'Give the Year, i.e., 2004:', year
        if (year gt 2009 or year lt 1980) then noerror=0
        if (month gt 12) or (month lt 1) then noerror=0
        if (day gt 31) or (day lt 1) then noerror=0
        if noerror eq 0 then print, 'Error in the date. Please re-enter.'
        print,''
    endrep until noerror

;CONFIRM DATE ENTERED
    strdate = strcompress(month)+'/'+strcompress(day)+'/'+strcompress(year)
    print,'You entered date (month/day/year): '+strdate
    read,'Is your date correct (y or n)? ',chk
    if select(['Y'],strupcase(chk)) then daterite=1
endrep until daterite



;Save Backup copy of bcvel.ascii
if bf eq 'qbcvel.ascii' then begin
    strdate =strtrim(strcompress(day),2)+'_'+strtrim(strcompress(month),2)+$
      '_'+strtrim(strcompress(year),2)
    command = 'cp '+barydir+'qbcvel.ascii '+barydir+'bcvel_backup/qbcvel.ascii_'+strdate
    spawn,command
endif  else print,'NOT Backing up!  Since this version of bary is in test mode!'



num = 0
skip = 0                        ;Reset to NOT skip
strindgen = strtrim(string(indgen(10000)),2)
print,' '
print,'  Filename      Object     I2 in?   Time   Barycentric Corr. (m/s)'

print,'---------------------------------------------------------'
openr,logune,logdir+logfile,/get_lun
;LOOP THROUGH EACH LINE ON THE LOGSHEET
WHILE eof(logune) eq 0 do begin ;check for end of file (eof = 1)
    readf,logune,logline        ;read one line in the logsheet

;Read the first four entries on the line.
    recnum = strtrim(getwrd(logline[0],0),2) ;record number
;print,recnum
    log.object = strtrim(strupcase(getwrd(logline,1)),2) ;object name
    first2 = strmid(log.object,0,2)
    celltest = strtrim(strupcase(getwrd(logline,2)),2) ;Was cell in?
    strtime = strtrim(getwrd(logline,3),2) ;time from logsheet
    linelen = (strlen(logline))[0] ; first element only
    temptest = strpos(strupcase(logline),'TEMP') ; test for word "Template"

;Construct reduced filename
    filename = tpname + '.' + recnum

;Guarantee that this is really an observation of something useful
    IF ((celltest eq 'Y' or celltest eq 'N') and $ ;Was cell specified?
        (select(skiplist,log.object) ne 1) and $ ;Not wide flat nor skiplist?
        select(strindgen,recnum)) and  (linelen gt 1)  THEN BEGIN 

        if first2 eq 'HD' then log.object = strmid(log.object,2,strlen(log.object)-2)

        if (celltest eq 'Y') then log.type='o' else log.type='t'
        if select(iodlist,log.object) then begin
            log.type='i' & log.object='iodine'
        endif
        if select(thorlist,log.object) then begin
            log.type='u' & log.object='th-ar'
        endif
        if select(daylist,log.object) then begin
            log.type='s' & log.object='day_sky'
        endif
        if select(skylist,log.object) then begin
            log.type = 'u'            
        endif
                                ;
        if temptest[0] ne -1 and log.type ne 't' then begin ; Error Trap
            print,'****WARNING:  Possible Template Detected: '
            print,logline
            print,'But observation type is not "t".  Was I2 cell in?'
            help,log.type
            if no('Continue?') then stop
        endif


;ENTERING TIME RETRIEVAL SECTION
        colon1 = strpos(strtime,':') ;position of first colon
        colon2 = rstrpos(strtime,':') ;postiion of last colon

        strhour = strmid(strtime,0,colon1) ;string version of UT hour of obs.
        strminute = strmid(strtime,colon1+1,colon2-colon1-1) ;UT minute
        strsecond = strmid(strtime,colon2+1,10) ;UT second

        hour = float(strhour)
        minutes = float(strminute) + float(strsecond)/60.d0

        jdUTC = jdate([year,month,day,hour,minutes])
        mjd = jdUTC-2440000.d0  ; modified JD


; Fix lengths of output strings
        len = (strlen(filename))[0]
        if len lt 9 then for jj=0,9-len-1 do filename = filename + ' '
        obj = log.object
        len = (strlen(obj))[0]
        if len lt 8 then for jj=0,8-len-1 do obj = ' '+obj 
        if strlen(strminute) eq 1 then strminute = '0'+strminute 
        if strlen(strsecond) eq 1 then strsecond = '0'+strsecond 
        strtime = strhour+':'+strminute+':'+strsecond
        len = (strlen(strtime))[0]
        if len lt 9 then for jj=0,9-len-1 do strtime = strtime + ' '
                                ;
        cz = 0.0d0 
        ha = 0.d0
        filename = 'r'+filename

        IF select(['o','t'],log.type) then begin ;need barycentric correction

;       LOOKUP COORDINATES: lookup.pro takes starname (log.object) and finds
;         coords, equinox, proper motion, parallax 
;         coords=[ra,dec], pm=[ra_motion, dec_motion]

            if first2 ne 'HR' then begin ; SKIP B STARS (no B.C. for B*s)

                lookup,log.object,coords,epoch,pm,parlax,radvel,hip=hip,$
                  barydir=barydir,cat=cat,tyc=tyc
                if coords(0) eq 0 or coords(1) eq 0 or abs(coords(0)) gt 24 $
                  or abs(coords(1)) gt 90 then begin
                    print,'Your coords for ',log.object,' look bad: ('+$
                      strmid(coords(0),2)+','+ strmid(coords(1),2)+')'
                    print,'If you continue, WRONG barycentric corrections could be '+$
                      'entered into ',bcfile
                    if no('Do you really want to do that?') then  stop
                endif

                if abs( coords(0)) eq 99.d0 then begin ;Logsheet star not found
                    coords = [0.d0,0.d0] ;force ra and dec = 0. :no object found
                    pm     = [0.d0,0.d0] ;dummy proper motion
                    epoch = 2000.d0 ;dummy epoch
                endif else begin 

                    qbary,jdUTC,coords,epoch,czi,obs='ctio',pm = pm,$
                      barydir=barydir, ha=ha
                    cz = rm_secacc(czi,pm,parlax,mjd)
                endelse
            endif  ; else print,'Skipping Bstar'
        ENDIF                   ; 

;Print Status to Screen
;    stcz = strtrim(string(fix(cz)),2)
        stcz = strtrim(string(cz),2)
        len = (strlen(stcz))[0]
        if len lt 7 then for jj=0,7-len-1 do stcz = ' '+stcz
        infoline = '|  '+filename+' |  '+obj+' |  '
        infoline = infoline + celltest+'  | '+strtime+' | '+stcz+' |'
        k = (strlen(infoline))[0]-1
        dashln = '-'
        for p = 1,k do dashln = dashln+'-'
;        print,dashln  &  print,infoline
        print,infoline &  print,dashln  

;Store results to Structure
        temp[num].filename = filename
        temp[num].object = log.object
        temp[num].cz = cz
        temp[num].mjd = mjd
        temp[num].ha = ha
        temp[num].type = log.type
        num=num+1
;if (num eq 20) or (num eq 40) then begin
;    print,'              Continuing ... '
;   print,'  Filename       Object   I2 Cell?   Time   Barycentric Corr. (m/s)'
;end
;
    ENDIF
END                             ;while

;STORE RESULTS IN BCVEL.ASCII ?
temp = temp[0:num-1]            ;trim temp structure array
print,' '
ans = ' '
read,'Did all the printed results (above) look OK? (y or n)?',ans

if strupcase(ans) eq 'Y' then begin
    get_lun,une                 ;get Logical Unit Number
    openu,une,bcfile,/append    ;open bcvel file for writing
;    form = '(A9,3X,A10,1X,D11.3,1X,D12.6,1X,F7.3,1X,A1)'; modified for
    form = '(A12,3X,A15,1X,D11.3,1X,D12.6,1X,F7.3,1X,A1)' ; long names
    
    print,'Printing results to '+bcfile+' ...'
    for j=0,num-1 do begin
        fn = temp[j].filename
        ob = temp[j].object
        cz = temp[j].cz
        mjd = temp[j].mjd
        ha = temp[j].ha
        type = temp[j].type
        printf,une,format=form,fn,ob,cz,mjd,ha,type
    end
    free_lun,une
    print,'Done with '+logfileorig
    print,' '
    comm=' '
    if num gt 55 then comm = 'No Pancakes Punishment.'
    if num lt 30 then comm = 'Warm up the maple syrup.'
    print,' You observed ',strcompress(num),' stars. '+comm
    print,' '
    print,'It''s been a long night. Go to sleep!  Sweet Dreams.'
endif else begin
    print,' '
    print,'Make necessary changes (to logsheet?) and start again.'
    print,'The file ',bcfile,' was not affected. Exiting ...'
endelse
free_lun,logune 
end


