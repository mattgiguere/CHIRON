pro resolutionplots, DATE

SPAWN, 'ls -rd /tous/mir7/fitspec/1* > /tous/CHIRON/QC/datedirslong'
numdates=FILE_LINES('datedirslong')
pathnames=STRARR(numdates)
openr,batman,'datedirslong',/GET_LUN
readf,batman,pathnames
close,batman
FREE_LUN,batman

openw,piderman,'datedirslongmod',/GET_LUN
printf,piderman,strmid(pathnames,19,26)
close,piderman
FREE_LUN,piderman

datelis=LONARR(numdates)
openr,supaman,'datedirslongmod',/GET_LUN
readf,supaman,datelis
close,supaman
FREE_LUN,supaman
index = where(datelis LE DATE)
indexshort=index[0:90]

openw,capnmerica,'datedirs',/GET_LUN
printf,capnmerica,datelis[indexshort],format='(i6)'
close,capnmerica
FREE_LUN, capnmerica

;.run printFiberRes.pro
;.run printNarrowRes.pro
;.run printSlicerRes.pro
;.run printSlitRes.pro
;.run makeResPlots.pro

printfiberres
printnarrowres
printslicerres
printslitres
makeresplots

SPAWN, 'rm *ThArRes'
SPAWN, 'rm datedirs'
SPAWN, 'rm datedirslong'
SPAWN, 'rm datedirslongmod'

return
end
