pro structify,silent=silent,bc=bc,asciifile=asciifile,$
              datfile=datfile,lick=lick

; Turn a bcvel.ascii into a struture ; same thing as debra's program barystruct
; 
; 2/99.  works on modern kbcvel.ascii
; 4/01. updated for DTM.
; 5/01. Updated to be run from redobary.pro
; 10/03. updated for Keck/berkeley.
; 06.   /lick keyword, otherwise assumes /keck
; BC=BC: Extract BC structure
;
line = '' & cz = 0.d0 & jd = 0.d0 &ha = fltarr(3) & i = 0 & obstype = ''

if keyword_set(lick) then begin
    bt = '/mir1/bary/'
    asciifile = bt +'bcvel.ascii' ; ok to use for input.
    datfile = bt +'bcvel.chris.dat' 
endif else begin
    bt = '/mir3/bary/'
    keckasciifile = bt +'kbcvel.ascii' ; ok to use for input.
    keckdatfile = bt +'kbcvel.chris.dat' 
endelse

if n_elements(asciifile) eq 0 then asciifile = keckasciifile
if n_elements(datfile) eq 0 then datfile = keckdatfile

if asciifile eq datfile then message,'Woah! Big problem:'
help,asciifile,datfile

print,'reading in ',asciifile,'...'
spawn,'cat '+asciifile,a        ; a = all the contents of the file
print,'done 

if getwrd(a(0)) eq 'Filename' then behead,a ; skip title line
N=n_elements(a)


bc = replicate({bc,file:'',name:'',cz:0.d0,mjd:0.d0,ha:0.d0,obstype:''},N)

print,'parsing...',N,' elements'

;Now loop through elements of a.  A normal line reads:
;ra14.33  5544A  -17345.2 2443342.2334  -0 30 13 o

for i = 0l,N-1l do begin
    bc(i).name =  getwrd(a(i),1)  
    bc(i).file = getwrd(a(i),0)  
;  if bc(i).file eq 'rk20.288' then  stop
    bc(i).cz = double(getwrd(a(i),2))
    bc(i).mjd = double(getwrd(a(i),3))
    bc(i).ha =  getwrd(a(i),4)
    bc(i).obstype = getwrd(a(i),5)
    if i/1000. eq i/1000 then print,i
endfor

print,'Done.'
txt = 'Save file '+datfile+ '?'
if keyword_set(silent) then  save,bc,file =datfile else $
  if yes(txt) then  save,bc,file =datfile else print,'not saved.'

end
