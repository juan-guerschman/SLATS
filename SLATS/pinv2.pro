; NAME:
;   pinv2
;
; PURPOSE:
;   Compute the (Moore-Penrose) pseudo-inverse of a matrix.
;   Calculate a generalized inverse of a matrix using its singular-value decomposition and including all ‘large’ singular values.
;
; :Author:
;    Juan Pablo Guerschman
;    created based on a similar pinv function provided by Peter Scarth. 
;    
; :History:
;     Change History::
;        PINV function provided by Peter Scarth in December 2012
;        JPG added the rcond keyword to try and mimic the behaviour of the numpy pinv2 funtion: 3 April 2013




function ones,m,n
  return, replicate(1,m,n)
end



function pinv2, A, Rcond=Rcond
  svdc,A,S,U,V
  j=size(A)
  m=j(1)
  n=j(2)
  s=transpose(S)
  
  ; apply rcond as explained in scipy.linalg.pinv2 
  IF Keyword_Set(Rcond) THEN $
    s *= s gt Rcond
  
  t = max(m,n) * max(s) * 1e-5
  r = total(s gt t)-1
  s = float(ones(r+1,1)) / s(0:r)
  sv=fltarr(r+1,r+1)
  for k=0,r do sv(k,k)=s(k)
  return, V(0:r,*) ## sv ## transpose(U(0:r,*))
end
