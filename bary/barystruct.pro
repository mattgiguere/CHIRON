pro barystruct,observatory=observatory

if strlowcase(observatory) eq 'magellan' then begin
    asciifile='/tous/mir5/bary/mbcvel.ascii'
    baryfile='mbcvel.dat'
endif
if strlowcase(observatory) eq 'keck' then begin
    asciifile='/tous/mir3/bary/kbcvel.ascii'
    baryfile='kbcvel.dat'
endif
if strlowcase(observatory) eq 'ctio' then begin
    asciifile='/tous/mir7/bary/qbcvel.ascii'
    baryfile='qbcvel.dat'
endif
if strlowcase(observatory) eq 'lick' then begin
    asciifile='/tous/mir1/bary/bcvel.ascii'
    baryfile='bcvel.dat'
endif
if strlowcase(observatory) eq 'aat' then begin
    asciifile='/tous/mir2/bary/ubcvel.ascii'
    baryfile='ubcvel.dat'
endif

openr,1,asciifile

line=' '
count=0l
;first find out how big to set the array
while ~ eof(1) do begin
	readf,1,line
	count=count+1l
end
close,1

bcat={obsnm:'?', objnm:'?', bc:0.0, jd:0.0, ha:0.0, obtype:'?'}
bcat=replicate(bcat,count-1l)

;if count gt 30000 then nobs=30000L else nobs=count

;stop
openr,1,asciifile
readf,1,line  		  ; throw away the first line
for i=0,count-2 do begin  ;because first line dropped
	readf,1,line
	bcat(i).obsnm=getwrd(line,0)
	bcat(i).objnm=getwrd(line,1)
	bcat(i).bc=float(getwrd(line,2))
        if bcat[i].objnm eq '10700' and bcat[i].jd gt 16100. then begin
stop
           restore,'/tous/mir7/iodspec/midpoints_tauceti.dat'
           xx=where(bcat[i].obsnm eq mdpts.obsnm and mdpts.em_midtime ne '00:00:00',nxx)
print,xx
           if nxx gt 0 then bcat[i].bc = bcat[i].bc + mdpts[xx].diff_from_geom
print,mdpts[xx].diff_from_geom
        endif 
	bcat(i).jd=float(getwrd(line,3))
	bcat(i).ha=float(getwrd(line,4))
	bcat(i).obtype=getwrd(line,5)
end

; old days - loops could not be larger than 32768
;if fix(nobs) gt 30000 then begin
;   addnum=count-30000l
;print,addnum
;   for i=0,addnum-2l do begin   ;because first line dropped
;	readf,1,line
;	bcat(i+30000l).obsnm=getwrd(line,0)
;	bcat(i+30000l).objnm=getwrd(line,1)
;	bcat(i+30000l).bc=float(getwrd(line,2))
;	bcat(i+30000l).jd=float(getwrd(line,3))
;	bcat(i+30000l).ha=float(getwrd(line,4))
;	bcat(i+30000l).obtype=getwrd(line,5)
;     end
;endif



close,1
;stop
save,bcat,file=baryfile
end
