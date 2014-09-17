;+
; THIS FUNCTION PERFORMS A LINEAR UMIXING USING THE NDVI AND THE RATIO OF
; MODIS BANDS 7 AND 6
; THE INPUTS (NDVI_INPUT & CAI_INPUT) MUST BE SCALARS OR VECTORS
;
;
; c1*e11 + c2*e21 + c3*e31 = P1
; c1*e12 + c2*e22 + c3*e32 = P2
; c1*1   + c2*1   + c3*1   = P3

;     [e11 e21 e31]
; A = [e12 e22 e32]
;     [ 1   1   1 ]

;     [P1]
; y = [P2]
;     [ 1]

;                    -1       -
; A * b = y  =>  b= A  * y    -
;
; author: Juan Pablo Guerschman

FUNCTION unmix_test, B, X

  size_B = SIZE(B)
  size_X = SIZE(X)
  
  BB=B
  XX=X
  undefine, B, X
  
  if size_B[1] ne size_X[1] then message, 'wrong sizes!! '
  
  ; transpose X and add last row with ones
  row_ones = intarr(size_X[2]) + 1 
  XX = [[Transpose(XX)],[row_ones]]
  
  ; add last column to reflectances with ones 
  column_ones = intarr(size_B[2]) + 1 
  BB = [BB, transpose(column_ones)] 
  
;  y = fltarr (8, elements_B1_input)
;  y [0,*] = B1_input
;  y [1,*] = B2_input
;  y [2,*] = B3_input
;  y [3,*] = B4_input
;  y [4,*] = B5_input
;  y [5,*] = B6_input
;  y [6,*] = B7_input
;  y [7,*] = 1
;  
;  ;A = [[ 0.8014 , 0.297 , 0.17],[ 0.3176 , 0.49 , 1.02], [ 1, 1, 1]]
;  A = [[0.900326082, 0.091675384, 0.156659779],[0.4, 0.671454581, 1.099804103],[1,1,1]]
;    PV  = [ 50, 120,  80, 500, 400, 300, 200]  
;    NPV = [ 90, 110, 150, 200, 190, 170, 140]  
;    BS  = [100, 170, 230, 240, 250, 250, 245] 
;    AA = transpose([[PV],[NPV],[BS]])
;    AA = [[AA],[1,1,1]]
    
  
  
  ;b= invert(transpose(a)) # y
  ;b = pinv(transpose(a)) # y 
  result = pinv(transpose(XX)) # BB 
  
  return, result

end
