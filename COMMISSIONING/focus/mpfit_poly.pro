;+
;
;  NAME: 
;     mpfit_poly
;
;  PURPOSE: 
;    To do a polynomial fit using the MPFIT package. POLY_FIT
;		fails if it's not very near 
;
;  CATEGORY:
;      UTILITIES
;
;  CALLING SEQUENCE:
;
;      mpfit_poly
;
;  INPUTS:
;
;		X: THE ABSCISAE VALUES
;		Y: THE ORDINATES
;	
;  OPTIONAL INPUTS:
;
;  OUTPUTS:
;
;  OPTIONAL OUTPUTS:
;
;  KEYWORD PARAMETERS:
;    
;		INIT: The initial guess for the fit
;		ORDER: The order of the polynomial
;		XERR: IF THERE'S ERROR IN THE X DIRECTION, 
;			SET THIS KEYWORD TO THE ERROR ARRAY
;		YERR: SAME AS XERR, ONLY IN THE Y DIRECTION
;
;  EXAMPLE:
;      mpfit_poly
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2011.02.25 05:14:10 PM
;
;-

function mpfit_poly, X, Y, ORDER=ORDER, INIT=INIT, $
XERR=XERR, YERR=YERR, yfit=yfit

if ~keyword_set(init) and keyword_set(order) then init = dblarr(order+2)

res = MPFITFUN('MYPOLY', x, y, yerr, init, yfit=yfit)
return, res
end;mpfit_poly.pro