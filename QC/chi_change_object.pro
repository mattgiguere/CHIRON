;+
;
;  NAME: 
;     chi_change_object
;
;  PURPOSE: TO change the object name of a bunch of observations. Specifically, 
;		this was designed to change 156274A to 156274 for several entries.
;   
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      chi_change_object
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
;      chi_change_object
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2013.09.13 10:18:51
;
;-
pro chi_change_object, $
help = help, $
postplot = postplot

angstrom = '!6!sA!r!u!9 %!6!n'
!p.color=0
!p.background=255
loadct, 39, /silent
usersymbol, 'circle', /fill, size_of_sym = 0.5

spawn, 'grep 156274A /tous/mir7/logsheets/2013/*.log', files
print, files
print, 'Total observations to modify: ', n_elements(files)
for i=0, n_elements(files)-1 do begin
   filearr = strsplit(files[i], ' ', /extract)
   patharr = strsplit(filearr[0],  '/', /extract)
   date = strmid(patharr[-1], 0, 6)
   seqnum = filearr[1]
   fn = '/raw/mir7/'+date+'/'+'chi'+date+'.'+seqnum+'.fits'
   print, 'Now modifying: ',fn
   im = readfits(fn, hd)
   fxaddpar, hd, 'OBJECT', '156274', 'Name of object observed'
   fxaddpar, hd, 'OBJECT_I', '156274A', 'Initial name of object. Later changed.'
   fxwrite, fn, hd, im
   logmaker, date, /over, /nofoc
   chi_quality, date=date
   stop
endfor


stop
end;chi_change_object.pro