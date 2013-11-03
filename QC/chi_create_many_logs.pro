;+
;
;  NAME: 
;     chi_create_many_logs
;
;  PURPOSE: 
;   
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      chi_create_many_logs
;
;  INPUTS:
;
;  OPTIONAL INPUTS:
;		BARY: Runs the barycentric correction, adding the given range of dates
;			to qbcvel.ascii and qbcvel.dat
;		HDNUM: Set this to the HD (Henry Draper Catalog) number of the CHIRPS
;			target you'd like to create a star log for. If not set, no log
;			will be created for that star.
;		STARTDATE: The start date, in the format of yymmdd, of when you want to start
;			creating logs for. If this is not set, it was start checking on the first 
;			date in the date array below (currently set to 120302)
;		ENDDATE: The end date, in the format of yymmdd, of when you want to end
;			creating logs for. If not set, it will create logs until the end date of
;			the date arr. This routing will only create logs until whichever is earliest
;			in time, either the set enddate keyword, OR the latest date in the datearr
;			array. This means if you want to create logs until 130905, but the datearr
;			only goes until 130715, then you'll need to add those dates to datearr. To
;			determine which dates to comment out, consult either the QC pages, or
;			chi_update_qc_index.
;		REPIPE: Rerun the reduction pipeline for the dates of interest, but don't add
;			anything new to the barycentric correction ASCII table (avoid duplicates).
;		JUSTLOG: Don't create the QC, just the log and count check
;		JUSTTHARS: Create the ThAr log
;		JUSTACENA: Just the Alpha Cen A Log
;		JUSTACENB: Just the Alpha Cen B Log
;		JUSTQUALITY: Regenerate the quality control pages
;
;  OUTPUTS:
;
;  OPTIONAL OUTPUTS:
;
;  KEYWORD PARAMETERS:
;    
;  EXAMPLE:
;      chi_create_many_logs
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2012.05.03 05:25:10 PM
;
;-
pro chi_create_many_logs, $
bary = bary, $
postplot = postplot, $
justlog = justlog, $
justthars = justthars, $
justacena = justacena, $
justacenb = justacenb, $
justtau = justtau, $
justquality = justquality, $
startdate = startdate, $
enddate = enddate, $
hdnum = hdnum, $
repipe = repipe

datearr=[ $
'120217', $ 
'120218', $ 
'120219', $ 
'120220', $ 
'120221', $ 
'120222', $ 
'120223', $ 
'120224', $ 
'120225', $ 
'120226', $ 
'120227', $ 
'120228', $ 
'120229', $ 
'120302', $ 
'120303', $
'120305', $
'120306', $
'120307', $
'120309', $
'120310', $
'120311', $
'120312', $
'120313', $
'120314', $
'120315', $
'120316', $
'120317', $
'120318', $
'120319', $
'120320', $
'120321', $
'120322', $
'120323', $
'120324', $
'120325', $
'120326', $
'120327', $
'120328', $
'120329', $
'120330', $
'120331', $ ;<--...TO HERE.
'120401', $
'120402', $
'120403', $
'120404', $
'120405', $
'120406', $
'120407', $
'120408', $
'120409', $
'120410', $
'120411', $
'120412', $
'120413', $
'120414', $
'120415', $
'120416', $
'120417', $
'120418', $
'120419', $
'120420', $
'120421', $
'120422', $
'120423', $
'120424', $
'120425', $
'120426', $
'120427', $
'120428', $
'120429', $
'120430', $
'120501', $
'120502', $
'120503', $
'120504', $
'120505', $
'120506', $
'120507', $
'120508', $
'120509', $
'120510', $
'120511', $
'120512', $
'120513', $
'120514', $
'120515', $
'120516', $
'120517', $
'120518', $
'120519', $
'120520', $
'120521', $
'120522', $
'120523', $
'120524', $
;'120525', $ <-NO DATA
;'120526', $ <-NO DATA
;'120527', $ <-NO DATA
;'120528', $ <-NO DATA
;'120529', $ <-NO DATA
;'120530', $ <-NO DATA
'120531', $
'120601', $
;'120602', $ <-NO DATA
'120603', $
'120604', $
'120605', $
'120606', $
;'120607', $ <-NO DATA
'120608', $
'120609', $
'120610', $
'120611', $
'120612', $
'120613', $
'120614', $
'120615', $
'120616', $
'120617', $
'120618', $
;'120619', $ <- PROBLEM W. TORRENT; ALL 1x1
;'120620', $ <- PROBLEM W. TORRENT; ALL 1x1
;'120621', $ <- PROBLEM W. TORRENT; ALL 1x1
;'120622', $ <-- NO CALIBS
;'120623', $ <- PROBLEM W. TORRENT; ALL 1x1
;'120624', $ <- PROBLEM W. TORRENT; ALL 1x1
;'120625', $ <- PROBLEM W. TORRENT; ALL 1x1
;'120626', $ <- NO EM INFO
'120627', $
'120628', $
'120629', $
'120630', $
'120701', $
'120702', $
'120703', $
'120704', $
'120705', $
'120706', $
'120707', $
'120708', $
'120709', $
'120710', $
'120711', $
'120712', $
'120713', $
'120714', $
'120715', $
'120716', $
'120717', $
'120718', $
'120719', $
'120720', $
'120721', $
'120722', $
'120723', $
'120724', $
'120725', $
'120726', $
'120727', $
'120728', $
'120729', $
'120730', $
'120731', $
'120801', $
'120802', $
;'120803', $ <-NO DATA
'120804', $
'120805', $
'120806', $
'120807', $
'120808', $
'120809', $
'120810', $
'120811', $
'120812', $
;'120813', $ <-NO DATA
'120814', $
;'120815', $ <-NO DATA
;'120816', $ <-NO DATA
;'120817', $ <-NO DATA
'120818', $
'120819', $
'120820', $
'120821', $
;'120822', $ <-NO DATA
;'120823', $ <-NO DATA
'120824', $
'120825', $
'120826', $
'120827', $
'120828', $
'120829', $
;'120830', $ <-NO DATA
'120831', $
'120901', $
;'120902', $ <-NO DATA
'120903', $
'120904', $
'120905', $
'120906', $
'120907', $
'120908', $
;'120909', $ <-NO DATA
'120910', $
'120911', $
'120912', $
'120913', $
'120914', $
'120915', $
'120916', $
;'120917', $ <-NO DATA
'120918', $
'120919', $
'120920', $
'120921', $
'120922', $
'120923', $
'120924', $
'120925', $
'120926', $
'120927', $
'120928', $
'120929', $
'120930', $
'121001', $
'121002', $
'121003', $
'121004', $
;'121005', $ <-NO DATA
;'121006', $ <-NO DATA
;'121007', $ <-NO DATA
;'121008', $ <-NO DATA
'121009', $
'121010', $
'121011', $
'121012', $
'121013', $
'121014', $
'121015', $
'121016', $
'121017', $
'121018', $
'121019', $
'121020', $
;'121021', $ <-NO DATA
'121022', $
'121023', $
'121024', $
'121025', $
'121026', $
'121027', $
'121028', $
'121029', $
'121030', $
'121031', $
'121101', $
'121102', $
'121103', $
'121104', $
'121105', $
'121106', $
'121107', $
'121108', $
'121109', $
'121110', $
'121111', $
'121112', $
'121113', $
;'121114', $<-SHUTTER MALFUNCTION
;'121115', $<-SHUTTER MALFUNCTION
'121116', $
'121117', $
'121118', $
'121119', $
'121120', $
'121121', $
'121122', $
'121123', $
'121124', $
'121125', $
'121126', $
'121127', $
'121128', $
'121129', $
'121130', $
'121201', $
'121202', $
'121203', $
'121204', $
'121205', $
'121206', $
'121207', $
'121208', $
'121209', $
;'121210', $<-NO DATA
;'121211', $<-NO DATA
'121212', $
'121213', $
'121214', $
'121215', $
'121216', $
'121217', $
'121218', $
;'121219', $<-NO DATA
'121220', $
'121221', $
'121222', $
'121223', $
;'121224', $<-NO DATA
;'121225', $<-NO DATA
'121226', $
'121227', $
'121228', $
'121229', $
;'121230', $<-NO DATA
;'121231', $<-NO DATA
;'130101', $<-NO DATA
'130102', $
'130103', $
'130104', $
'130105', $
'130106', $
;'130107', $<-NO DATA
;'130108', $<-NO DATA
;'130109', $<-NO DATA
'130110', $
'130111', $
'130112', $
'130113', $
'130114', $
'130115', $
'130116', $
'130117', $
'130118', $
'130119', $
;'130120', $<-NO DATA
'130121', $
'130122', $
'130123', $
'130124', $
'130125', $
'130126', $
'130127', $
'130128', $
'130129', $
'130130' , $
'130201', $
'130202', $
'130203', $
'130204', $
'130205', $
'130206', $
'130207', $
'130208', $
'130209', $
'130210', $
'130211', $
'130212', $
;'130213', $<-NO DATA
'130214', $
;'130215', $<-NO DATA
'130216', $
;'130217', $<-NO DATA
'130218', $
;'130219', $<-NO DATA
'130220', $
;'130221', $<-NO DATA
;'130222', $<-NO DATA
;'130223', $<-NO DATA
;'130224', $<-NO DATA
;'130225', $<-NO DATA
;'130226', $<-NO DATA
;'130227', $<-NO DATA
;'130228', $<-NO DATA
;'130301', $<-NO DATA
;'130302', $<-NO DATA
;'130303', $<-NO DATA
;'130304', $<-NO DATA
;'130305', $<-NO DATA
;'130306', $<-NO DATA
;'130307', $<-NO DATA
;'130308', $<-NO DATA
'130309', $
'130310', $
'130311', $
'130312', $
'130313', $
'130314', $
'130315', $
'130316', $
'130317', $
'130318', $
'130319', $
;'130320', $<-NO DATA
'130321', $
'130322', $
'130323', $
'130324', $
'130325', $
'130326', $
'130327', $
'130328', $
'130329', $
'130330', $
'130331', $
'130401', $
'130402', $
'130403', $
'130404', $
'130405', $
'130406', $
'130407', $
'130408', $
;'130409', $<-NO DATA
'130410', $
'130411', $
'130412', $
'130413', $
'130414', $
'130415', $
'130416', $
'130417', $
'130418', $
'130419', $
'130420', $
'130421', $
'130422', $
'130423', $
'130424', $
'130425', $
'130426', $
'130427', $
'130428', $
'130429', $
;'130430', $<-NO DATA
'130501', $
'130502', $
'130503', $
'130504', $
'130505', $
'130506', $
'130507', $
'130508', $
'130509', $
'130510', $
'130511', $
;'130512', $<-NO DATA
'130513', $
'130514', $
'130515', $
'130516', $
;'130517' $<-NO DATA; POURING RAIN ALL NIGHT
'130518', $
'130519', $
'130520', $
'130521', $
'130522', $
'130523', $
'130524', $
'130525', $
'130526', $
'130527', $
'130528', $
;'130529', $ unexpected vacation
;'130530', $ unexpected vacation
'130531', $
'130601', $
'130602', $
'130603', $
'130604', $
'130605', $
;'130606', $ ;unexpected vacation, SIMON only
;'130607', $ ;unexpected vacation, SIMON only
;'130608', $ ;unexpected vacation, SIMON only
;'130609', $ ;unexpected vacation, SIMON only
;'130610', $ ;unexpected vacation, SIMON only
;'130611', $ ;unexpected vacation, SIMON only
;'130612', $ ;unexpected vacation, SIMON only
'130613', $
'130614', $
'130615', $
'130616', $
'130617', $
'130618', $
'130619', $
'130620', $
'130621', $
'130622', $
'130623', $
'130624', $
'130625', $
'130626', $
;'130627', $;bad weather all night
'130628', $
'130629', $
'130701', $
'130702', $
'130703', $
;'130704', $;bad weather all night
;'130705', $;bad weather all night
'130706', $
'130707', $
'130708', $
'130711', $
'130712', $
'130713', $
'130714', $
'130715', $
'130716', $
'130717', $
'130718', $
'130720', $
'130722', $
'130723', $
'130724', $
'130725', $
'130726', $
'130727', $
'130728', $
'130729', $
'130730', $
'130731', $
'130801', $
'130802', $
'130803', $
'130804', $
'130805', $
'130806', $
'130807', $
'130808', $
'130809', $
'130810', $
'130811', $
'130812', $
'130813', $
'130814', $
'130815', $
'130816', $
'130817', $
'130818', $
'130819', $
'130820', $
'130821', $
'130824', $
'130825', $
'130826', $
'130827', $
'130828', $
'130829', $
'130830', $
'130831', $
'130901', $
'130902', $
'130903', $
'130904', $
'130905', $
'130906', $
'130907', $
'130908', $
'130909', $
'130910', $
'130911', $
'130912', $
'130913', $
'130914', $
'130915', $
'130916', $
'130917', $
'130918', $
'130919', $
'130920', $
'130921', $
'130922', $
'130923', $
'130924', $
'130925', $
'130926', $
'130927', $
'130928', $
'130929', $
'130930', $
'131001', $
'131002', $
'131003', $
'131004', $
'131005', $
'131006', $
'131007', $
'131008', $
'131009', $
'131010', $
'131011', $
'131012', $
'131013', $
'131014', $
'131015', $
'131016', $
'131017', $
'131018', $
'131019', $
'131020', $
'131021', $
'131022', $
'131023', $
'131024' $
]

if ~keyword_set(startdate) then startdate = datearr[0]
if ~keyword_set(enddate) then enddate = datearr[-1]
didx = where(long(datearr) ge long(startdate) and long(datearr) le long(enddate), datecount)
if datecount lt 1 then stop
datearr = datearr[didx]

for i=0, n_elements(datearr)-1 do begin
    ldir='/tous/mir7/logstructs/20'+strmid(datearr[i], 0, 2)+'/'
    lfn = ldir+datearr[i]+'log.dat'
    if ~file_test(lfn) or keyword_set(justlog) then begin
      ;f != exist
	  print, 'Now running chi_log on date ',datearr[i],' ', systime()
	  log = chi_log(date=datearr[i])
	  print, 'Now running chi_count_check on date ',datearr[i],' ', systime()
	  chi_count_check, log
	endif else restore, ldir+datearr[i]+'log.dat'
    print, 'Now running specialty log on date ',datearr[i],' ', systime()
	if keyword_set(justthars) then chi_thar_log, log
    ;print, 'Now running chi_acena_log on date ',datearr[i],' ', systime()
	if keyword_set(justacena) then chi_acena_log, log
	if keyword_set(justacenb) then chi_acenb_log, log
	if keyword_set(justtau) then chi_tauceti_log, log
    if keyword_set(hdnum) then chi_star_log, log, hdnum = hdnum
    if keyword_set(justquality) then chi_quality, date = datearr[i]
    if keyword_set(repipe) then chi_reduce_all, date=datearr[i], /skipbary
    if keyword_set(bary) then begin
	   lfn = '/tous/mir7/logsheets/20'+strmid(datearr[i], 0, 2)+$
		  '/'+strt(datearr[i])+'.log'
	   qbarylog, lfn, prefix='chi'+datearr[i]
    endif;kw(bary)
endfor

if keyword_set(bary) then barystruct_dbl, observatory='ctio'

stop
end;chi_create_many_logs.pro