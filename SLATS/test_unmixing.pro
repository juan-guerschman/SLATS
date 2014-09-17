; test spectral unmixing following Scarth et al 2010
; 
; uses a synthetic dataset with known endmembers and tests if endmembers can be reproduced from data
; 



function ones,m,n
  return, replicate(1,m,n)
end


function pinv,A
  svdc,A,S,U,V
  j=size(A)
  m=j(1)
  n=j(2)
  s=transpose(S)
  t = max(m,n) * max(s) * 1e-4
  r = total(s gt t)-1
  s = float(ones(r+1,1)) / s(0:r)
  sv=fltarr(r+1,r+1)
  for k=0,r do sv(k,k)=s(k)
  return, V(0:r,*) ## sv ## transpose(U(0:r,*))
end



pro test_unmixing
  ; 1- define known endmembers (3 endmembers, 7 bands)
  
  PV  = [ 50, 120,  80, 500, 400, 300, 200]  
  NPV = [ 90, 110, 150, 200, 190, 170, 140]  
  BS  = [100, 170, 230, 240, 250, 250, 245] 
  
  ; M_orig is the original or "true" M array which i want to reproduce later
  M_orig = [[PV],[NPV],[BS]]/ 1000.
  help, M_orig 
  
  ; set of random n field data,
  n=1000 
  PV_obs = randomU(systime(1), n)
  NPV_obs = randomU(systime(1)+1, n)
  BS_obs = randomU(systime(1)+2, n)
  Total_F_orig = PV_obs + NPV_obs + BS_obs
  tPV_obs = PV_obs/Total_F_orig
  tNPV_obs = NPV_obs/Total_F_orig
  tBS_obs = BS_obs/Total_F_orig
  ;PV_obs = randomU(seed, n)
  ;NPV_obs = (1. - PV_obs) * randomU(seed, n)
  ;BS_obs  = 1. - (PV_obs + NPV_obs)
  ; F is an array of n field measurements of 3 fractions which add to 1
  F_orig = transpose([[tPV_obs], [tNPV_obs], [tBS_obs]])
  help, F_orig
  
  ; X is the array of field reflectance 
  X = M_orig # F_orig 
  help, X
  
  ; now add a random noise to the simulated field spectra 
  SIZE_X = SIZE(X) 
  sigma = 0.050  
  X += randomN(seed, SIZE_X[1], SIZE_X[2]) * sigma  
 
 ; Now add random noise to the field data
  SIZE_F = SIZE(F_orig) 
  sigma = 0.05
  F = F_orig + randomN(seed, SIZE_F[1], SIZE_F[2]) * sigma  
    
  ; plot endmembers and n field spectra 
  cgWindow, Wmulti=[0,3,1]
  cgDisplay, 1000, 600
  cgWindow, 'cgPlot', X[*,0], color='black', psym=-2, Yrange=[min(M_orig), max(M_orig)], Title='"true" endmembers and simulated spectra', /addcmd
  for i=0, SIZE_X[2]-1 do cgWindow, 'cgPlot', X[*,i], color='black', psym=-2, /addcmd, /overplot
  cgWindow, 'cgPlot', PV, color='green', psym=-2, thick=2, /addcmd, /overplot
  cgWindow, 'cgPlot', NPV, color='red', psym=-2, thick=2, /addcmd, /overplot
  cgWindow, 'cgPlot', BS, color='blue', psym=-2, thick=2, /addcmd, /overplot
  
  ; now add a column to X with ones (as per eq 4 in paper)     
  ;new_X = fltarr(SIZE_X[1]+1, SIZE_X[2]) + 1   
  ;new_X[0:SIZE_X[1]-1, *] = X   
  ;X = new_X
  ;help, X
  
  ; pinv_x is the Moore-Penrose Pseudoinverse of X      
  pinv_X = pinv(X)
  help, pinv_x
  
  ; A is the pinv times F (equation 6 in paper)
  A = pinv_X ## F
  help, A 
  
  ; M is obtained calculating the pseudoinverse of A (equation 8 in paper)  
  M = pinv(A)
  
  ; plot derived endmembers M 
  cgWindow, 'cgPlot', M[*,0], color='green', psym=-2, thick=2, yRange=[min(M), max(M)], Title='endmembers as in Eq 8', /addcmd
  cgWindow, 'cgPlot', M[*,1], color='red', psym=-2, thick=2, /addcmd, /overplot
  cgWindow, 'cgPlot', M[*,2], color='blue', psym=-2, thick=2, /addcmd, /overplot
  
  ; now invert eq 1 dirctly (as per eq 9 in paper, in theory what shouldnt be done)  
  M_eq9 = X # pinv(F)
  
  
  cgWindow, 'cgPlot', M_eq9[*,0], color='green', psym=-2, thick=2, yRange=[min(M_eq9), max(M_eq9)], Title='endmembers as in Eq 9', /addcmd
  cgWindow, 'cgPlot', M_eq9[*,1], color='red', psym=-2, thick=2, /addcmd, /overplot
  cgWindow, 'cgPlot', M_eq9[*,2], color='blue', psym=-2, thick=2, /addcmd, /overplot
 
; Recover the original fractions by solving the least squares equation
retrievedM = transpose(LA_LEAST_SQUARES(transpose(M),transpose(X)))
retrievedM_eq9 = transpose(LA_LEAST_SQUARES(transpose(M_eq9),transpose(X)))

help,retrievedM

; Work out the unmixing RMSE
errorM = sqrt(mean((retrievedM - F_orig)^2))
errorM_eq9 = sqrt(mean((retrievedM_eq9 - F_orig)^2))

print, "Unmixing RMSE, Classical Estimator", errorM
print, "Unmixing RMSE, Inverse  Estimator",errorM_eq9



end


