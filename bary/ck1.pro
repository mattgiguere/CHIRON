pro ck1

restore,'bcvel.dat'
openw,1,'missing_iodspec.txt'

x=where(strmid(bcat.obsnm,0,2) eq 'rb' or strmid(bcat.obsnm,0,2) eq 'rd' or strmid(bcat.obsnm,0,2) eq 'rf' or strmid(bcat.obsnm,0,2) eq 'rg',nx)
btmp=bcat(x)
form1='(a10,a10)'

for i=0,nx-1 do begin
	ff=findfile('/mir1/iodspec/'+btmp(i).obsnm,count=count)
	if count eq 0 then begin
	   printf,1,btmp(i).obsnm,btmp(i).objnm,format=form1
	end
end

close,1
stop
end

