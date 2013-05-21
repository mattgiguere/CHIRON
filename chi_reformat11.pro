;+
;
;  NAME: 
;     chi_reformat11
;
;  PURPOSE: 
;   
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      chi_reformat11
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
;      chi_reformat11
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2012.03.21 06:38:20 PM
;
;-
pro chi_reformat11, $
help = help, $
postplot = postplot, $
spawnit = spawnit

if keyword_set(help) then begin
	print, '*************************************************'
	print, '*************************************************'
	print, '        HELP INFORMATION FOR chi_reformat11'
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

loadct, 39, /silent
usersymbol, 'circle', /fill, size_of_sym = 0.5

dates = [$
'110122', $
'110125', $
'110126', $
'110127', $
'110131', $
'110201', $
'110309', $
'110310', $
'110311', $
'110312', $
'110313', $
'110314', $
'110315', $
'110316', $
'110317', $
'110318', $
'110319', $
'110320', $
'110321', $
'110322', $
'110323', $
'110324', $
'110325', $
'110326', $
'110327', $
'110328', $
'110329', $
'110330', $
'110331', $
'110401', $
'110402', $
'110403', $
'110404', $
'110405', $
'110406', $
'110407', $
'110408', $
'110409', $
'110410', $
'110411', $
'110412', $
'110413', $
'110414', $
'110415', $
'110416', $
'110417', $
'110418', $
'110419', $
'110420', $
'110421', $
'110422', $
'110423', $
'110424', $
'110425', $
'110426', $
'110427', $
'110428', $
'110429', $
'110430', $
'110501', $
'110502', $
'110503', $
'110504', $
'110505', $
'110506', $
'110507', $
'110508', $
'110509', $
'110510', $
'110511', $
'110512', $
'110513', $
'110514', $
'110515', $
'110516', $
'110518', $
'110519', $
'110520', $
'110521', $
'110522', $
'110523', $
'110524', $
'110525', $
'110526', $
'110527', $
'110528', $
'110529', $
'110530', $
'110531', $
'110601', $
'110602', $
'110607', $
'110609', $
'110610', $
'110611', $
'110612', $
'110613', $
'110614', $
'110615', $
'110616', $
'110617', $
'110621', $
'110622', $
'110623', $
'110624', $
'110625', $
'110626', $
'110627', $
'110628', $
'110629', $
'110630', $
'110701', $
'110702', $
'110704', $
'110705', $
'110706', $
'110708', $
'110710', $
'110711', $
'110712', $
'110713', $
'110714', $
'110715', $
'110718', $
'110720', $
'110721', $
'110722', $
'110723', $
'110724', $
'110726', $
'110727', $
'110728', $
'110802', $
'110803', $
'110804', $
'110806', $
'110808', $
'110809', $
'110810', $
'110812', $
'110814', $
'110818', $
'110820', $
'110822', $
'110824', $
'110828', $
'110830', $
'110902', $
'110904', $
'110906', $
'110908', $
'110910', $
'110912', $
'110914', $
'110918', $
'110919']

suf='.fits'
search1 = '*.fits'
;stop
for d=0, n_elements(dates)-1 do begin
	directory1 = '/raw/mir7/'+dates[d]+'/'
	directory2 = '/tous/mir7/iodspec/'+dates[d]+'/'
	directory3 = '/tous/mir7/fitspec/'+dates[d]+'/'
	spawn, 'ls -1 '+directory1+'qa*', filearr
	oldrpref = strmid(filearr, 13, 5, /reverse)
	oldipref1 = 'r'+oldrpref
	oldipref2 = 'a'+oldrpref
;	oldpref = 'chi111002.'
	newrpref = 'chi'+dates[d]+'.'
	oldseqn = strmid(filearr, 8, 4, /reverse)
	stop
	for i=0, n_elements(filearr)-1 do begin
;		suf = strmid(filearr[i], 5, 9) ;for the "qa"s
;		suf = strmid(filearr[i], 10, 9) ;for the "chi"s
		
		cmdr = 'cp '+directory1+oldrpref[i]+oldseqn[i]+suf+' '+directory1+newrpref+oldseqn[i]+suf
		print, cmdr
		stop
		if keyword_set(spawnit) then spawn, cmdr
		if file_test(directory2+oldrpref[i]+oldseqn[i]) then begin
		spawn, 'mkdir '+directory2
		cmdi = 'mv '+directory2+oldrpref[i]+oldseqn[i]
		endif
		;stop
	endfor
endfor
stop
end;chi_reformat11.pro