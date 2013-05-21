;+
;
;  NAME: 
;     chi_vank
;
;  PURPOSE: 
;   
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      chi_vank
;
;  INPUTS:
;		STRNM: The star name
;		TMPTP: Short for "template tape" this is archaic astronomical tongue
;			for the image prefix of the template observation that'll be used
;		LBL: VD label (e.g. 'vdv'). What does VD mean?
;
;  OPTIONAL INPUTS:
;       MCT: Minimum acceptable counts.
;
;  OUTPUTS:
;		CF1: Archaic. A structure containing all the velocities
;		CF2: Archaic. Nightly corrected version of CF1
;		CF3: "Raw counts" (?) corrected version of CF1. 
;
;  OPTIONAL OUTPUTS:
;
;  EXAMPLE:
;      chi_vank, '10700', 'ac', 'vdam', cf1, cf3, /ctio
;      chi_vank, '10700', 'am', 'vdam', cf1, cf3, /ctio
;
;  INFORMATION FORM VANK.PRO
;
; vank,'moon','c','vdcnso_',cf1,cf3,mct=8000.  
; lbl is everything before the starnm in the vd files
;
;vank,'75732','daf','daf',cf1,cf3 
;
; cf1  output structure   all velocities
; cf2  output structure    nightly corrected version of cf1
; cf3  output structure    "Raw Counts" corrected version of cf1
;
; mct  keyword integer     minimum acceptable counts,
;			     overrides the hardwired rules
;
;INPUTS
;strnm  (string)  '458'    star_name
;tmptp  (string)  'rk12'   template_tape
;lbl    (string)  'vdv'    VD label
;
;
;  MODIFICATION HISTORY:
;        c. Adapted from vank. Matt Giguere 2012.10.04 06:16:42 PM
;
;-
pro chi_vank, $
strnm,tmptp,lbl,cf1,cf3,$
cf=cfout,$
ctio=ctio,$
dfd=dfd,$
dircf=dircf,$
doptest=doptest,$
help = help, $
maxchi=maxchi,$
mct=mct,$
noclean=noclean,$
nopatch=nopatch,$
outfile=outfile,$
postplot = postplot, $
reject=reject,$
title=title,$
vdarr=vdarr

;IDL built in debugging procedure. 
;0: if there's an error, stop immediately at the 
;	statement that caused the error.
on_error, 0

if ~keyword_set(tmptp) then tmptp='b'
if ~keyword_set(lbl) then lbl='vdbnso'
if ~keyword_set(doptest) then doptest=1

!p.color=0
!p.background=255
loadct, 39, /silent
usersymbol, 'circle', /fill, size_of_sym = 0.5

if keyword_set(help) then begin
	print, '*************************************************'
	print, '*************************************************'
	print, '        HELP INFORMATION FOR chi_vank'
	print, 'KEYWORDS: '
	print, ''
	print, 'HELP: Use this keyword to print all available arguments'
	print, ''
	print, ''
	print, ''
	print, '*************************************************'
	print, '                     EXAMPLE                     '
	print, "IDL>"
	print, 'IDL> '
	print, '*************************************************'
	stop
endif

;mk_cf,strnm,tag=tmptp
   m7_psfpix = 1.2*[0.00, -2.2,-1.7, -1.2, -0.7,-0.3, 0.3, 0.7, 1.2, 1.7, 2.2]
   m7_psfsig = 1.2*[1.10,  0.6, 0.6,  0.6,  0.6, 0.4, 0.4, 0.6, 0.6, 0.6, 0.6]

vstdsk = '/home/matt/idl/CHIRON/vnk/'
if keyword_set(ctio) then begin
   restore,'/tous/mir7/bary/qbcvel.dat'
   if ~keyword_set(dfd) then dfd='/tous/mir7/files/'
   fildsk = '/tous/mir7/files/'+lbl+strnm+'_'
   cfdsk = '/home/matt/idl/CHIRON/cf/'
   bankdir = '/home/matt/idl/CHIRON/vst/'
endif

grnm=dfd+lbl+strnm
ff=file_search(grnm+'*',count=count)

;create the temporary structure for the velocities:
tmp={cfstr,obnm:'?',iodnm:'?',bc:0.,z:0.,jd:double(0.),dewar:50,gain:1.3, $
 cts:long(0),mnvel:0.,mdvel:0.,med_all:0.,errvel:0.,mdchi:0.,nchunk:0, $
 mdpar:fltarr(20),mnpar:fltarr(20),sp1:0.,sp2:0.,spst:'?',phase:0., $
 psfpix:[m7_psfpix[0:10], 0.00, 0.00, 0.00,0.00],$
 psfsig:[m7_psfsig[0:10], 0.00, 0.00, 0.00,0.00]}

;now replicate that structure to create the final one:
cf=replicate(tmp,count)

;fill the cf structure with information from QBCVEL.DAT:
for i = 0, count-1 do begin
   x1=strpos(ff[i],'_',/reverse_search)
   obnm=strmid(ff[i],x1+1,strlen(ff[i])-x1)
   if strmid(obnm, 0,1) eq 'a' then x=where(bcat.obsnm eq strmid(obnm,1,strlen(obnm)-1),nx) else $
   x=where(bcat.obsnm eq obnm,nx)
   if nx eq 0 then stop,' no matches in bcat'
   if nx gt 1 then stop,' more than one match in bcat'
   cf[i].obnm=obnm
   cf[i].bc=bcat[x].bc
   cf[i].jd=bcat[x].jd
endfor

save,cf,f=cfdsk+strupcase(strtrim(strnm,2))+'_'+tmptp+'.dat'
cfnm    = cfdsk  + strupcase(strtrim(strnm,2))+'_'+tmptp+'.dat'

if keyword_set(dircf) then cfnm = dircf
vstnm   = vstdsk + 'vst'+strlowcase(strtrim(strnm,2))+'.dat'
vnm     = strnm

if n_elements(mct) eq 1 then if mct gt 0 then begin
    print,'Using input value for minimum acceptable photons in exposure:  '+strtrim(mct,2)
    mncts=mct
endif

ff_cf=findfile(cfnm,count=cfcount)
if cfcount gt 0 then begin
  print, 'Now restoring CF file: ', cfnm
  restore,cfnm 
endif else begin
  print,'CF file '+cfnm+' not found'
  stop
endelse

cff=cf

PRINT,'************************************************'
print, 'CHI_VANK: NOW IN TAPE SECTION...'
PRINT,'************************************************'
tape = strmid(cff[0].obnm,0,2)
case 1 of
    tape eq 'rk': begin
        ordr=[21,30]  
        pixr=[70,1950]
    end
    tape eq 'rf' or tape eq 'rg' or tape eq 'ri': begin
        ordr=[38,53]
        pixr=[50,1770]
    end
    tape eq 'rj' : begin
        ordr=[1, 12]
        pixr=[50, 3970]
    end
    tape eq 'rq' : begin
;        ordr=[5, 20]
;        pixr=[280,1640]
        ordr=[12,29]
        pixr=[80,3040]
     end
    tape eq 'ac' or tape eq 'ch': begin
        ordr=[13,30]
        pixr=[80,3040]
    end
    tape eq 'em' and cff[0].jd ge 2.44d6+13480: begin
        ordr=[0, 14]
        pixr=[50, 3890]
    end
    tape eq 'rb' or tape eq 'rd' or tape eq 're': begin
        ordr=[38,53]
        pixr=[50,1770]
    end
    tape eq 'rs' or tape eq 'rt': begin
        ordr=[38,53]
        pixr=[50,1770]
    end
    tape eq 'ra' or tape eq 'rh' or tape eq 'rc': begin
	tapestring='?'
    end
    else: stop
endcase

if n_elements(cff) gt 1 then begin
    if n_elements(cff) eq 2 then begin
        restore,fildsk+cff(0).obnm  &   vd0=vd
        restore,fildsk+cff(1).obnm  &   vd1=vd
        cf1=cff
        dumfit=3.*median([vd0.fit,vd1.fit])
        dumwt=0.5*median(vd0.weight)
        ind=where(vd0.fit lt dumfit and vd1.fit lt dumfit and $
                  vd0.weight gt dumwt and $
                  vd0.pixt gt pixr(0) and vd0.pixt lt pixr(1) and $
                  vd0.ordt ge ordr(0) and vd0.ordt le ordr(1),nchunk)
        cf1(0).mnvel=mean(vd0(ind).vel)  &  cf1(0).mdvel=median(vd0(ind).vel)
        cf1(1).mnvel=mean(vd1(ind).vel)  &  cf1(1).mdvel=median(vd1(ind).vel)
        cf1(0).errvel=stdev(vd0(ind).vel)/sqrt(nchunk-1)
        cf1(1).errvel=stdev(vd1(ind).vel)/sqrt(nchunk-1)
        cf1(0).mdchi=median(vd0(ind).fit)
        cf1(1).mdchi=median(vd1(ind).fit)
        cf1(0).nchunk=nchunk
        cf1(1).nchunk=nchunk
        cf1(0).cts=median(vd0(ind).cts)
        cf1(1).cts=median(vd1(ind).cts)
        cf1.jd=cf1.jd-2440000.
    endif else begin

PRINT,'************************************************'
print, 'CHI_VANK: RUNNING VEL...'
PRINT,'************************************************'

if keyword_set(fit_key) then vel,vnm,cff,lbl,cf1,vdarr,ordr=ordr,pixr=pixr,upvel=1,dwr=dwr, $
  vdpath=dfd,mincts=mncts,maxchi=maxchi,ifit=fit_key,noclean=noclean,doptest=doptest else $
	     vel,vnm,cff,lbl,cf1,vdarr,ordr=ordr,pixr=pixr,mincts=mncts,maxchi=maxchi,dwr=dwr,$
	     vdpath=dfd,ifit=ifit,noclean=noclean,doptest=doptest
	end ;else
endif else begin
    print,'Less than two observations'
    return
endelse

bv=0.                  
cf3=cf1
velplot,cf3,0.006,d1,v1,e1,errcut=2.5
save,cf1,cf3,file=bankdir+'vst'+strlowcase(strtrim(strnm,2))+'.dat'
cfout=cf3

restore,bankdir+'vst'+strlowcase(strnm)+'.dat'
velplot,cf3,/fitline

end;chi_vank.pro
