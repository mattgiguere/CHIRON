;+
;
;  NAME: 
;     chi_obs
;
;  PURPOSE: 
;    The ultimate widget for observing on CHIRON...
;		-Calculate Exposure Time
;		-Local Sidereal Clock
;		-Chilean Time Clock
;		-List all of the targets
;		-Generate a target list
;		-Plot radial velocities
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      chi_obs
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
;      chi_obs
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2011.03.13 12:00:34 AM
;
;-
pro chi_obs


;**********************************
;CREATE THE WIDGET
;**********************************

loadct, 39, /silent                
!p.background = 255
!p.color = 0
usersymbol, 'CIRCLE', /fill
p_orig = !p

 ;The percentage of the screen you want the widget to take up:
 y_widget_size = 0.5d
 x_widget_size = 0.5d
;controlbase_xsize = 250d
;botrow_ysize = 230d
x_offset = 0d
y_offset = 0d
;sm=90
mon_size = get_screen_size()
;draw_x_size = round(( mon_size[0] - controlbase_xsize - 25)* x_widget_size)
;draw_y_size = round(( mon_size[1] - botrow_ysize - sm)* y_widget_size)
draw_x_size = round( mon_size[0]* x_widget_size)
draw_y_size = round( mon_size[1]* y_widget_size)

;**************************************************************
;                   DRAW THE USER INTERFACE
;**************************************************************
;make the top level base and add resize events:
tlb = widget_base(title = 'CHI_OBS 0.1 ', $
/col, xoff = x_offset, yoff = y_offset, /tlb_size_events)

;Make a base to hold the clock:
clockbase = widget_base(tlb, /col, scr_ysize=125, frame=1)
observatory, 'ctio', ctio
;while 1 eq 1 do begin
;ct2lst, lst, ctio.longitude, dum, systime(/julian)
;print, lst
;wait, 1
;endwhile
clckrow1 = widget_base(clockbase, /row)
xsz = 15
snrnum = 200d
utctext = widget_text(clckrow1, value='UTC:', xsize=10)
utcval = widget_text(clckrow1, value=strt(systime(/utc)), $
	/editable, event_pro='chi_obs_clck_utc', xsize=20)

clckrow2 = widget_base(clockbase, /row)
cttext = widget_text(clckrow2, value='CT:', xsize=10)
ctval = widget_text(clckrow2, value=strt(systime(/utc)), $
	/editable, event_pro='chi_obs_clck_ct', xsize=20)

clckrow3 = widget_base(clockbase, /row)
lsttext = widget_text(clckrow3, value='LST:', xsize=10)
lstval = widget_text(clckrow3, value=strt(systime(/utc)), $
	/editable, event_pro='chi_obs_clck_lst', xsize=20)


;OBJECT NAMES:
objbase = widget_base(tlb, /col, frame=1)
objrow1 = widget_base(objbase, /row)
xsz = 15
hdnum = 128620
hdtext = widget_text(objrow1, value='HD #:', xsize=xsz)
hdval = widget_text(objrow1, value=strt(hdnum), $
	/editable, event_pro='chi_obs_hdval', xsize=xsz)

objrow2 = widget_base(objbase, /row)
hipnum = 71683
hiptext = widget_text(objrow2, value='HIP #:', xsize=xsz)
hipval = widget_text(objrow2, value=strt(hipnum), $
	/editable, event_pro='chi_obs_hipval', xsize=xsz)

objrow3 = widget_base(objbase, /row)
hrnum = 5459
hrtext = widget_text(objrow3, value='HR #:', xsize=xsz)
hrval = widget_text(objrow3, value=strt(hrnum), $
	/editable, event_pro='chi_obs_hrval', xsize=xsz)






;EXPOSURE CALCULATIONS:
;Make a base to hold the textfields for exposure calculation:
expbase = widget_base(tlb, /col, frame=1)

exprow1 = widget_base(expbase, /row)
xsz = 15
airnum = 1d
snrtext = widget_text(exprow1, value='Current Airmass:', xsize=xsz)
snrval = widget_text(exprow1, value=strt(airnum), $
	/editable, event_pro='chi_obs_airval', xsize=xsz)

exprow2 = widget_base(expbase, /row)
xsz = 15
snrnum = 200d
snrtext = widget_text(exprow2, value='S/N Desired:', xsize=xsz)
snrval = widget_text(exprow2, value=strt(round(snrnum)), $
	/editable, event_pro='chi_obs_snrval', xsize=xsz)

exprow3 = widget_base(expbase, /row)
ctsnum = 5000d
ctstext = widget_text(exprow3, value='Cts Desired:', xsize=xsz)
ctsval = widget_text(exprow3, value=strt(round(ctsnum)), $
	/editable, event_pro='chi_obs_ctsval', xsize=xsz)

exprow40 = widget_base(expbase, /row)
vmagnum = -0.01
vmagtext = widget_text(exprow40, value='Vmag:', xsize=xsz)
vmagval = widget_text(exprow40, value=strt(vmagnum, f='(F6.2)'), $
	/editable, event_pro='chi_obs_vmagval', xsize=xsz)

exprow4 = widget_base(expbase, /row)
exptext = widget_text(exprow4, value='Exp Time:', xsize=xsz)

expbuttn = widget_button(exprow4, value = ' = ')
expval = widget_text(exprow4, value='20', $
	/editable, event_pro='chi_obs_expval', xsize=xsz - 6)

 ;Make a droplist to hold line style choices:
 symbols = ['NARROW SLIT', 'SLIT', 'SLICER', 'FIBER']
 
exprow5 = widget_base(expbase, /row)
 symboldrop = widget_droplist(exprow5, value=symbols, $
 title = '', event_pro = 'mpf_widget_sym', xsize=halfcol)


;Draw the widget hierarchy to the screen:
widget_control, tlb, /realize, tlb_set_yoffset=0;, xoffset=1920

;Get the window index of the draw widget:
;widget_control, draw, get_value=win_id

widget_control, tlb, set_uvalue = pstate

;Call XMANAGER to start event handling:
xmanager, 'lcme', tlb, $
cleanup='lcme_cleanup', $
event_handler='lcme_resize', $
/no_block


stop
end;chi_obs.pro