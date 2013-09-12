pro lupdate,test=test,datfile=datfile,star,lastrun=lastrun

; POSSIBLE improvement: excecute('bary, command')
; We will now work with kbcvel.ascii directly because we can't be sure
; about kbcvel.dat, if it was created using new or old bary.
; kbcvel.ascii will always be old.

;
print,systime()
;timediff,t

if n_elements(datfile) eq 0 then bcfile = bt+'kbcvel.dat' else $
  bcfile = datfile

;NOTE CHANGE THESE LINES TO SUIT YOUR PROGRAM
newbcfile = bt+'kbcvelnew.dat'
comment = 'modern all IDL jbary with aug 2003'
print,comment
asciifile = '/mir3/bary/kbcvelnew.ascii'  ; final file
oldasciifile = '/mir3/bary/kbcvel.ascii'  
catfile = '/further/paul/idle/kdop/kvel/keck_st.dat'

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

print,'restoring ',catfile  & restore,catfile
print,'restoring ',bcfile  & restore,bcfile

structify,asciifile=oldasciifile,datfile=bcfile
N = n_elements(bc)
cz = 0.d0 & mjd = 0.d0 &ha = fltarr(3) & i = 0.
obstype = '' & jd = 0.d0
diff = fltarr(N)	& diffha = diff ;new-old cz
if keyword_set(test) then begin
    N = 20 & bc = bc(0:N-1)     ;for testing do first 20
    newbcfile = bt+'kbcvelnew.test.dat'
    asciifile = bt+'kbcvelnew.test.ascii'
endif


if n_elements(star) ne 0 then begin
    bc = bc(where(bc.name eq star)) ; limit test to one star
    newbcfile = bt+'kbcvelnew.'+star+'.dat' 
    print,'  NOTE:  Output to file ',newbcfile
    print,'  Will be for ',star,'  ONLY   -------'
    N = n_elements(bc)
    asciifile = kbary+'kbcvel.update.'+star+'.ascii'
endif

bcnew=replicate({bcnew,file:'',name:'',mjd:0.d0,cz:0.d0,	$
                 ha:0.0,obstype:'',comment:''},N)
; Most parameters are not changed:
bcnew.file = bc.file  
bcnew.name = bc.name
bcnew.mjd = bc.mjd & bcnew.obstype = bc.obstype
bcnew.ha = bc.ha            
bcnew.cz = bc.cz   ; default: keep same BC

print,'File      Object                NEWBARY      OLDBARY         DIFF    '

; Loop Through All BC's and recompute

if keyword_set(lastrun)   then begin
    read,'Guess staring line for this run:',guess
    print,bc(guess).file
    if no('Were you right?') then stop
    print,'starting with: ',bc(guess).file
    startind = long(guess)
endif else startind = 0

for i = startind,N-1 do begin		
    czi = 0.0
    if bc(i).mjd eq 0 then print,i,"  No Observations in the 70's!"
    if bc(i).cz ne 0.0 then begin ;this skips iodine exposures, etc.
        jdi = double(bc(i).mjd)+2440000.d0
        klookup,bc(i).name,coords,epoch,pm,prlax,radvel,hip=hip,$
          dumped=dumped,cat=dum

        if coords(0) eq 99 or max(abs(coords)) eq 0 or dumped $
          then   print,'Star dumped or invalid coords' else begin
            kbary,jdi,coords,epoch,czi,obs='CFHT',pm = pm,$
              barydir=barydir, ha=hangle
            czi = rm_secacc(czi,pm,prlax,bc(i).mjd)
            bcnew(i).cz = czi
            diff(i) = czi - bc(i).cz   
        endelse
    endif else begin            ; iodone wide flat ,e tc.
;      print,'Skipping',bc(i).name
        bcnew(i).cz = bc(i).cz
        czi = 0 
    endelse

    print,bc(i).file,'         ',bc(i).name,bcnew(i).cz,$
      bc(i).cz,diff(i),bcnew(i).cz-bc(i).cz
    if i/500 eq i/500. and i gt 0  and n_elements(star) eq 0 then begin
        print,i,'/',N,systime()
        help,where(bcnew.cz eq 0)
        print,'Saving: ',newbcfile
        save,bcnew,diff,file =newbcfile
    endif

endfor
print,systime()
;timediff,t
;underline,'Summary'
help,bcnew,diff
print,'minmax(bcnew): ',minmax(bcnew.cz)
print,'minmax(diff): ',minmax(diff)
print
help,where(bcnew.cz eq 0)

print,'about to save bcnew&diff',newbcfile
if yes('save?') then begin
    print,'Saving: ',newbcfile
    save,bcnew,diff,file =newbcfile

endif

if not keyword_set(star) then asciify,asciifile=asciifile,datfile=newbcfile

end
