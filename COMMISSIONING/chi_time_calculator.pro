;+
;;  NAME: 
;     chi_time_calculator
;;  PURPOSE: To calculate the exposure time for the various slit positions
;   
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      chi_time_calculator
;
;  KEYWORD PARAMETERS:
;    
;  EXAMPLE:
;      chi_time_calculator, vmag = 6.0, snr = 150, /normal
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2011.09.26 04:48:28 PM
;
;-
pro chi_time_calculator, $
narrow = narrow, $
normal = normal, $
slicer = slicer, $
fiber = fiber, $
vmag = vmag, $
snr = snr, $
i2 = i2

if ~keyword_set(vmag) then vmag = 6d
if ~keyword_set(snr) then snr = 150d

snr = double(snr)
vmag = double(vmag)

gain = 2.5d
VTAU = 3.5d
;CTSTAU = 10150d
;TTAU = 1200d seconds
;FTAU = CTSTAU / TTAU
FTAU = 8.458d
if keyword_set(normal) then FTAU *= 2.5d ;additional countrate due to using normal slit vs narrow slit
if keyword_set(slicer) then FTAU *= 5d ;additional countrate from using slicer vs narrow slit
if keyword_set(fiber) then FTAU *= 10d ;additional countrate from using fiber vs narrow slit
if keyword_set(i2) then FTAU /= 2d

;calculate the desired counts needed to reach the desired SNR
cts = snr^2d / (3d * GAIN)
print, 'cts is: ', cts

exp_time = cts / (FTAU * 10d ^ (0.4d * (3.5d - vmag) ) )
print, 'The exposure time needed is: ', exp_time
stop
end;chi_time_calculator.pro