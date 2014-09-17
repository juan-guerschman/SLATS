function norm_ratio, x, y
  
  return, (y-x)/(y+x)
end

function ratio, x, y
  
  return, x/y
end

pro Unmix_Slats
  compile_opt idl2

  ; LOAD DATA 
  data = read_SLATS_data()
  
  LANDSAT_Qld = data.LANDSAT_Qld
  LANDSAT_Scaling = data.LANDSAT_Scaling
  MCD43A4 = data.MCD43A4
  MOD09A1 = data.MOD09A1
  Rain = data.Rain
  Fcover = DATA.Fcover
  Rain = Data.Rain
  
  output_folder = 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\plots\unmix\'
  n = n_elements(LANDSAT_Qld.Obs_key)
  cd, output_folder
  
  ;Some Defaults for saving: 
  cgwindow_setdefs, IM_Resize=100
  
   ;-------------------------------------------------------------------------- 
   ;Calculate julian days
   day = intarr(n)
   month = intarr(n)
   year = intarr(n)
   for i=0, n-1 do day[i]= (strsplit((LANDSAT_Qld.obs_time)[i], '/', /EXTRACT))[0]
   for i=0, n-1 do month[i]= (strsplit((LANDSAT_Qld.obs_time)[i], '/', /EXTRACT))[1]
   for i=0, n-1 do year[i]= (strsplit((LANDSAT_Qld.obs_time)[i], '/', /EXTRACT))[2]
   Jul_Day = JULDAY(Month, Day, Year)
   
   ;-------------------------------------------------------------------------- 

    Landsat_spectra_3x3 = [[LANDSAT_Scaling.b1_3x3], [LANDSAT_Scaling.b2_3x3], [LANDSAT_Scaling.b3_3x3], [LANDSAT_Scaling.b4_3x3], [LANDSAT_Scaling.b5_3x3], [LANDSAT_Scaling.b6_3x3]]
    Landsat_spectra_3x3 = float(Transpose(Landsat_spectra_3x3))
    Landsat_spectra_40x40 = [[LANDSAT_Scaling.b1_40x40], [LANDSAT_Scaling.b2_40x40], [LANDSAT_Scaling.b3_40x40], [LANDSAT_Scaling.b4_40x40], [LANDSAT_Scaling.b5_40x40], [LANDSAT_Scaling.b6_40x40]]
    Landsat_spectra_40x40 = float(Transpose(Landsat_spectra_40x40))
    MOD09A1_spectra = [[MOD09A1.b3], [MOD09A1.b4], [MOD09A1.b1], [MOD09A1.b2], [MOD09A1.b5], [MOD09A1.b6], [MOD09A1.b7]]
    MOD09A1_spectra = float(Transpose(MOD09A1_spectra)) * 0.0001   ; convert to reflectance 0-1
    where_bad = Where(MOD09A1_spectra le 0, count) & if count ge 1 then MOD09A1_spectra[where_bad]= !VALUES.F_NAN
    MCD43A4_spectra = [[MCD43A4.b3], [MCD43A4.b4], [MCD43A4.b1], [MCD43A4.b2], [MCD43A4.b5], [MCD43A4.b6], [MCD43A4.b7]]
    MCD43A4_spectra = float(Transpose(MCD43A4_spectra))* 0.0001   ; convert to reflectance 0-1
    where_bad = Where(MCD43A4_spectra le 0, count) & if count ge 1 then MCD43A4_spectra[where_bad]= !VALUES.F_NAN
 
  for loops=0, 8 do begin
     ; derive endmembers as the spectra of sites with > 90% of a given cover 
     threshold = 0.90 
     CASE loops of  
      0: data = {reflectance: Landsat_spectra_3x3, sensor: 'Landsat 3x3'}
      1: data = {reflectance: Landsat_spectra_40x40, sensor: 'Landsat_spectra 40x40'} 
      2: data = {reflectance: MCD43A4_spectra, sensor: 'MCD43A43'} 
      3: data = {reflectance: MOD09A1_spectra, sensor: 'MOD09A1'} 
      4: data = {reflectance: MCD43A4_spectra[0:3, *], sensor: 'MCD43A43_noBand5'} 
      5: data = {reflectance: MOD09A1_spectra[0:3, *], sensor: 'MOD09A1_noBand5'} 
      6: data = {reflectance: [norm_ratio(Landsat_spectra_3x3[2, *], Landsat_spectra_3x3[3, *]), ratio(Landsat_spectra_3x3[5, *], Landsat_spectra_3x3[4, *])], sensor: 'Landsat 3x3 NDVI SR65'} 
      7: data = {reflectance: [norm_ratio(MCD43A4_spectra[2, *], MCD43A4_spectra[3, *]), ratio(MCD43A4_spectra[6, *], MCD43A4_spectra[5, *])], sensor: 'MCD43A4 NDVI SR76'} 
      8: data = {reflectance: [norm_ratio(MOD09A1_spectra[2, *], MOD09A1_spectra[3, *]), ratio(MOD09A1_spectra[6, *], MOD09A1_spectra[5, *])], sensor: 'MOD09A1 NDVI SR76'} 
     EndCase
 
     reflectance = data.reflectance & sensor = data.sensor
     size_reflectance = SIZE(reflectance) 
     endmember_ge_90 = fltarr(size_reflectance[1], 3)
     where_PV = Where(Fcover.Exp_PV ge threshold, count_spectra)
     endmember_ge_90[*,0] = MEAN(reflectance[*,where_PV], DIMENSION=2, /NaN)
     where_NPV = Where(Fcover.Exp_NPV ge threshold, count_spectra)
     endmember_ge_90[*,1] = MEAN(reflectance[*,where_NPV], DIMENSION=2, /NaN)
     where_BS = Where(Fcover.Exp_BS ge threshold, count_spectra)
     endmember_ge_90[*,2] = MEAN(reflectance[*,where_BS], DIMENSION=2, /NaN)
  
  
    ; plot spectra
    MODIS_W = MODIS_NBAR_WAVELENGHTS()
    Landsat_W = Landsat_WAVELENGHTS()
     
     
     M = endmember_ge_90
  ;   M = [[Landsat_PV_end_MAX], [Landsat_NPV_end_MIN], [Landsat_BS_end_MAX]]
     X = reflectance
     F = [[Fcover.Exp_PV],[Fcover.Exp_NPV],[Fcover.Exp_BS]]
     
     round = 0.0
     lower_bound = 0.0 - round
     upper_bound = 1.0 + round
  
    ; unmix using bvls
      spectra = reflectance
      endmembers = M
      
    unmixed = unmix_3_fractions_bvls(spectra, endmembers, lower_bound, upper_bound)
  
    ; now derive endmembers using inversion (two methods)
    ; pinv_x is the Moore-Penrose Pseudoinverse of X   
    ; 
    ; first get rid of NaNs    
    where_Nans = Where(Total(Finite(spectra), 1) ne size_reflectance[1], COMPLEMENT=where_OK, count)
    if count ge 1 then begin
      new_spectra = fltarr(size_reflectance[1], n_elements(where_OK))
      new_F = fltarr(n_elements(where_OK), 3)
      for i=0, n_elements(where_OK)-1 do new_spectra[*, i] = spectra[*, where_OK[i]]
      for i=0, n_elements(where_OK)-1 do new_F[i, *] = F[where_OK[i], *]
    endif  
  
  ;  pinv_X = pinv(new_spectra)
  ;  help, pinv_x
  ;  
  ;  ; A is the pinv times F (equation 6 in paper)
  ;  A = pinv_X ## F
  ;  help, A 
    
    ; M is obtained calculating the pseudoinverse of A (equation 8 in paper)  
    M = pinv(pinv(new_spectra) ## transpose(new_F))
  
    ; now invert eq 1 dirctly (as per eq 9 in paper, in theory what shouldnt be done)  
    M_eq9 = new_spectra # pinv(transpose(new_F))
    
    ; now unmix fractions using these endmembers
    unmixed_M = unmix_3_fractions_bvls(new_spectra, M, lower_bound, upper_bound)
    unmixed_M_eq9 = unmix_3_fractions_bvls(new_spectra, M_eq9, lower_bound, upper_bound)
    
     
     ; plot 
     fname = 'endmembers_and_unmixing_'+sensor+'.png' 
     if (File_Info(fname)).exists eq 0 then begin
       PS_Start, fname 
         cgDisplay, 1000, 500 
         xRange = [-.05, 1.05]
         yRange=xRange  
         !P.Multi=[0,5,3]
         yTitle='observed'
         xTitle='modelled'
      
         cgPlot, endmembers[*,0], psym = -1, symSize=1, yRange=[min(endmembers), max(endmembers)], thick=2, color='green', title='endmembers from >90% sites' 
         cgPlot, endmembers[*,1], psym = -1, symSize=1, thick=2,  color='red',  /overplot      
         cgPlot, endmembers[*,2], psym = -1, symSize=1, thick=2,  color='blue',  /overplot      
         cgPlot, unmixed, F, psym=16, symsize=0.25, xRange=xRange, yRange=yRange, xStyle=1, yStyle=1,  color='black', title='RMSE= '+string(sqrt(mean((unmixed - F)^2))), xTitle=xTitle, yTitle=yTitle
         cgPlot, [-1,2], [-1,2], psym=-3,  /overplot
         cgPlot, unmixed[*,0], F[*,0], psym=16, symsize=0.25, xRange=xRange, yRange=yRange, xStyle=1, yStyle=1,  color='green', title='RMSE= '+string(sqrt(mean((unmixed[*,0] - F[*,0])^2))), xTitle=xTitle, yTitle=yTitle
         cgPlot, [-1,2], [-1,2], psym=-3,  /overplot
         cgPlot, unmixed[*,1], F[*,1], psym=16, symsize=0.25, xRange=xRange, yRange=yRange, xStyle=1, yStyle=1,  color='red', title='RMSE= '+string(sqrt(mean((unmixed[*,1] - F[*,1])^2))), xTitle=xTitle, yTitle=yTitle
         cgPlot, [-1,2], [-1,2], psym=-3,  /overplot
         cgPlot, unmixed[*,2], F[*,2], psym=16, symsize=0.25, xRange=xRange, yRange=yRange, xStyle=1, yStyle=1,  color='blue', title='RMSE= '+string(sqrt(mean((unmixed[*,2] - F[*,2])^2))), xTitle=xTitle, yTitle=yTitle
         cgPlot, [-1,2], [-1,2], psym=-3,  /overplot
      
      
         cgPlot, M[*,0], psym = -1, symSize=1, yRange=[min(M), max(M)] ,  thick=2, color='green', title='endmembers inversion'       
         cgPlot, M[*,1], psym = -1, symSize=1, thick=2,  color='red',  /overplot      
         cgPlot, M[*,2], psym = -1, symSize=1, thick=2,  color='blue',  /overplot      
         cgPlot, unmixed_M, new_F, psym=16, symsize=0.25, xRange=xRange, yRange=yRange, xStyle=1, yStyle=1,  color='black', title='RMSE= '+string(sqrt(mean((unmixed_M - new_F)^2))), xTitle=xTitle, yTitle=yTitle
         cgPlot, [-1,2], [-1,2], psym=-3,  /overplot
         cgPlot, unmixed_M[*,0], new_F[*,0], psym=16, symsize=0.25, xRange=xRange, yRange=yRange, xStyle=1, yStyle=1,  color='green', title='RMSE= '+string(sqrt(mean((unmixed_M[*,0] - new_F[*,0])^2))), xTitle=xTitle, yTitle=yTitle
         cgPlot, [-1,2], [-1,2], psym=-3,  /overplot
         cgPlot, unmixed_M[*,1], new_F[*,1], psym=16, symsize=0.25, xRange=xRange, yRange=yRange, xStyle=1, yStyle=1,  color='red', title='RMSE= '+string(sqrt(mean((unmixed_M[*,1] - new_F[*,1])^2))), xTitle=xTitle, yTitle=yTitle
         cgPlot, [-1,2], [-1,2], psym=-3,  /overplot
         cgPlot, unmixed_M[*,2], new_F[*,2], psym=16, symsize=0.25, xRange=xRange, yRange=yRange, xStyle=1, yStyle=1,  color='blue', title='RMSE= '+string(sqrt(mean((unmixed_M[*,2] - new_F[*,2])^2))), xTitle=xTitle, yTitle=yTitle
         cgPlot, [-1,2], [-1,2], psym=-3,  /overplot
        
         cgPlot, M_eq9[*,0], psym = -1, symSize=1, yRange=[min(M_eq9), max(M_eq9)], thick=2, color='green', title='endmembers inversion, eq 9'       
         cgPlot, M_eq9[*,1], psym = -1, symSize=1, thick=2,  color='red',  /overplot      
         cgPlot, M_eq9[*,2], psym = -1, symSize=1, thick=2,  color='blue',  /overplot      
         cgPlot, unmixed_M_eq9, new_F, psym=16, symsize=0.25, xRange=xRange, yRange=yRange, xStyle=1, yStyle=1,  color='black', title='RMSE= '+string(sqrt(mean((unmixed_M_eq9 - new_F)^2))), xTitle=xTitle, yTitle=yTitle 
         cgPlot, [-1,2], [-1,2], psym=-3,  /overplot
         cgPlot, unmixed_M_eq9[*,0], new_F[*,0], psym=16, symsize=0.25, xRange=xRange, yRange=yRange, xStyle=1, yStyle=1,  color='green', title='RMSE= '+string(sqrt(mean((unmixed_M_eq9[*,0] - new_F[*,0])^2))) , xTitle=xTitle, yTitle=yTitle
         cgPlot, [-1,2], [-1,2], psym=-3,  /overplot
         cgPlot, unmixed_M_eq9[*,1], new_F[*,1], psym=16, symsize=0.25, xRange=xRange, yRange=yRange, xStyle=1, yStyle=1,  color='red', title='RMSE= '+string(sqrt(mean((unmixed_M_eq9[*,1] - new_F[*,1])^2))) , xTitle=xTitle, yTitle=yTitle
         cgPlot, [-1,2], [-1,2], psym=-3,  /overplot
         cgPlot, unmixed_M_eq9[*,2], new_F[*,2], psym=16, symsize=0.25, xRange=xRange, yRange=yRange, xStyle=1, yStyle=1,  color='blue', title='RMSE= '+string(sqrt(mean((unmixed_M_eq9[*,2] - new_F[*,2])^2))) , xTitle=xTitle, yTitle=yTitle
         cgPlot, [-1,2], [-1,2], psym=-3,  /overplot
       PS_End, resize=100, /PNG
     endif
   endfor  
   
end

