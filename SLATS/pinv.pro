function ones,m,n
  return, replicate(1,m,n)
end



function pinv,A
  svdc,A,S,U,V
  j=size(A)
  m=j(1)
  n=j(2)
  s=transpose(S)
  t = max(m,n) * max(s) * 1e-5
  r = total(s gt t)-1
  s = float(ones(r+1,1)) / s(0:r)
  sv=fltarr(r+1,r+1)
  for k=0,r do sv(k,k)=s(k)
  return, V(0:r,*) ## sv ## transpose(U(0:r,*))
end
