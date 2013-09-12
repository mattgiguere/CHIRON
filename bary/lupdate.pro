pro lupdate,test=test,datfile=datfile,star,lastrun=lastrun,startind=startind,$
            bc=bc

; LICK version of update.
; POSSIBLE improvement: excecute('bary, command')
; BC: input your own bc which you've created or restored.  This
; bypasses the lenghty (for lick) process of structifying bcvel.ascii.

journal,'lupdate.jour'
;
print,systime()
timediff,t
bt = './'

bcfile = '/mir1/bary/bcvel.chris.dat' 


;NOTE CHANGE THESE LINES TO SUIT YOUR PROGRAM
newbcfile = '/mir1/bary/bcvelnew.chris.dat'
comment = 'Added several new entries in bcvel.ascii and fixed some names'
print,comment
asciifile = './bcvelnew.ascii' ; final file
oldasciifile = '/mir1/bary/bcvel.ascii'  
catfile = '/mir1/bary/lick_st.dat'
;katfile = '/mir3/bary/keck_st.dat'

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

print,'restoring ',catfile  & restore,catfile
;print,'restoring ',katfile  & restore,katfile
if n_elements(bc) eq 0 then begin
    if not keyword_set(test) then structify,/lick
    print,'restoring ',bcfile  & restore,bcfile
endif

N = n_elements(bc)*1.d0
cz = 0.d0 & mjd = 0.d0 &ha = fltarr(3) & i = 0.d
obstype = '' & jd = 0.d0
diff = fltarr(N)	& diffha = diff ;new-old cz

if keyword_set(test) then begin
    N = 300 & bc = bc(0:N-1)     ;for testing do first 20
    newbcfile = bt+'bcvelnew.test.dat'
    asciifile = bt+'bcvelnew.test.ascii'
endif


if n_elements(star) ne 0 then begin
    star = strupcase(star)
    bc = bc(where(bc.name eq star)) ; limit test to one star
    newbcfile = bt+'bcvelnew.'+star+'.dat' 
    print,'  NOTE:  Output to file ',newbcfile
    print,'  Will be for ',star,'  ONLY   -------'
    N = n_elements(bc)*1.d0
    asciifile = 'bcvel.update.'+star+'.ascii'
endif

if n_elements(startind) eq 0 then begin

    startind = 0.d0
    bcnew=replicate({bcnew,file:'',name:'',mjd:0.d0,cz:0.d0,	$
                     ha:0.0,obstype:'',comment:''},N)
; Most parameters are not changed:
    bcnew.file = bc.file  
    bcnew.name = bc.name
    bcnew.mjd = bc.mjd & bcnew.obstype = bc.obstype
    bcnew.ha = bc.ha            
endif else begin
    print,' We are starting off with: ',startind
    restore,newbcfile
    print,"restore,newbcfile"
endelse 

; DON"T do this:
; bcnew.cz = bc.cz   ; default: keep same BC
; we want to see those differences (ie when we can't compute A BC)
; so that we can diagnose.  ESP. true for (hi SA) Mstars bumped to
; keck. and B stars, etc.


print,'File      Object                NEWBARY      OLDBARY         DIFF    '

; Loop Through All BC's and recompute
for i = startind,N-1.d0 do begin		
    czi = 0.0
    if bc(i).mjd eq 0 then print,i,"  No Observations in the 70's!"
    first2 = strupcase(strmid(bc(i).name,0,2))

    if bc(i).cz ne 0.0 and  first2 ne  'HR'   then begin ;this skips iodine exposures, etc.
        jdi = double(bc(i).mjd)+2440000.d0
;        lookup,bc(i).name,coords,epoch,pm,prlax,radvel,hip=hip,$
;          cat=lick,found=found,tyc=tyc
        klookup,bc(i).name,coords,epoch,pm,prlax,radvel,hip=hip,$
          found=found,tyc=tyc

        if not found then begin 
            print,' Not found at Lick, searching Keck list'

            klookup,bc(i).name,coords,epoch,pm,prlax,radvel,hip=hip,$
              found=found,tyc=tyc
            if found then print,'Found at Keck...continuing...' else begin
                print,  bc(i).name+ ' Not at Keck either. using old bc'
                bcnew(i).cz = bc(i).cz
            endelse

        endif            
        if coords(0) eq 99 or max(abs(coords)) eq 0  $
          then   print,'invalid coords' else begin
            bary,jdi,coords,epoch,czi,obs='LICK',pm = pm,$
              barydir=barydir, ha=hangle
            czi = rm_secacc(czi,pm,prlax,bc(i).mjd)
            bcnew(i).cz = czi
        endelse
    endif else begin            ; iodone wide flat ,e tc.
;      print,'Skipping',bc(i).name
        bcnew(i).cz  = 0
    endelse

    diff(i) = bcnew(i).cz - bc(i).cz   

    print,bc(i).file,' '+bc(i).name,bc(i).mjd,bcnew(i).cz,$
      bc(i).cz,diff(i)
;    if i/500 eq i/500. and i gt 0  and n_elements(star) eq 0 then begin
;        print,i,'/',N,systime()
;        help,where(bcnew.cz eq 0)
;        print,'Saving: ',newbcfile
;        save,bcnew,diff,file =newbcfile
;    endif

    if i mod 1000 eq 0 then begin 
        print,i,'/',N,' '+systime()
        help,where(bcnew.cz eq 0)
;        print,'Saving: ',newbcfile
;        save,bcnew,diff,file =newbcfile
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

print,' you should now asciify the new bcvel.ascii'
;if not keyword_set(star) then asciify,asciifile=asciifile,datfile=newbcfile
journal
stop
end
