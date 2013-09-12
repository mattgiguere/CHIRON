function tycfix,name,fixed=fixed,silent=silent

; Fix a Tycho star name to be in line withh the standard
; convention 4-5-1 ie change: 3009-0603 to 3009-00603-1
; NAME: Bad Tycho Name

digits = strtrim(sindgen(10),2)
fixed = 0
newname = name
hyphchar = strpos(name,'-')     ; search for hyphen
if hyphchar(0) eq -1 then begin
    p = parse(name)
    case n_elements(p) of
       3: begin
            one = strn(p(0),length=4,padchar='0')
            two = strn(p(1),length=5,padchar='0')
            three = p(2)
            newname = one+'-'+two+'-'+three
            if p(2) ne '1' then message,/info,' oddname: '+name
            if p(2) ne '1' then message,/info,' newname: '+newname
            
        end
       2: begin
            one = strn(p(0),length=4,padchar='0')
            two = strn(p(1),length=5,padchar='0')
            three = '-1'
            newname = one+'-'+two+three
        end
        else: message,"Can't fix that name: "+name
    endcase
endif else  begin 
    posthyp = strmid(name,hyphchar+1)
    prehyp = strmid(name,0,hyphchar+1)
    if strlen(posthyp) eq 4 then begin
        newposthyp = '0'+posthyp+'-1'
        newname =prehyp+newposthyp
        fixed = 1
    endif else if not keyword_set(silent) then $
      print,'Not fixing tycho name: ',name
end

firsttwo = strupcase(strmid(newname,0,2))
third = strmid(newname,2,1)

if firsttwo eq 'TY' and memberof(digits,third) then $
    newname = strmid(newname,2,999)

return,newname

end
