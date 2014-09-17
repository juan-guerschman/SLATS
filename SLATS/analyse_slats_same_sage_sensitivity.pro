;this function returns where all Landsat, MCD43A4 and MOD09A1 have ok values
function where_ALL_data_ok, DATA
  big_array = [ $
              [Data.MCD43A4.B1], $
              [Data.MCD43A4.B2], $
              [Data.MCD43A4.B3], $
              [Data.MCD43A4.B4], $
              [Data.MCD43A4.B5], $
              [Data.MCD43A4.B6], $
              [Data.MCD43A4.B7], $
              [Data.MOD09A1.B1], $
              [Data.MOD09A1.B2], $
              [Data.MOD09A1.B3], $
              [Data.MOD09A1.B4], $
              [Data.MOD09A1.B5], $
              [Data.MOD09A1.B6], $
              [Data.MOD09A1.B7], $
              [data.Landsat_scaling.B1_3x3], $
              [data.Landsat_scaling.B2_3x3], $ 
              [data.Landsat_scaling.B3_3x3], $ 
              [data.Landsat_scaling.B4_3x3], $ 
              [data.Landsat_scaling.B5_3x3], $ 
              [data.Landsat_scaling.B6_3x3], $
              [data.Landsat_QLD.B1],         $
              [data.Landsat_QLD.B2],         $
              [data.Landsat_QLD.B3],         $
              [data.Landsat_QLD.B4],         $
              [data.Landsat_QLD.B5],         $
              [data.Landsat_QLD.B6],         $
              [data.Landsat_scaling.SAM_40x40]] 
   negs = where(big_array lt 0, count)           
   if count ge 1 then big_array[negs] = !VALUES.F_NAN     
   total_finite = Total(Finite(big_array), 2)
   where_ok = Where(total_finite eq (SIZE(big_array))[2])
   return, where_ok
end


; will try and copy what Peter does in his SAGE worksheet

pro analyse_slats_same_sage_plots_sensitivity, data=data, $
  weight=weight, sensor=sensor, split=split, subset_data=subset_data, crossvalidation=crossvalidation, $
  useoverstorey=useoverstorey, noAbares=noAbares

  report=''  ; this will summarise the results in an output file
  report += SysTime(0)+','

  ;Inverting field data to recover endmember spectra - MODIS version 
  ;Juan Guerschman March 2113
  ;This workbook outlines the fractional cover calibration process USING MODIS DATA. Built on Peter Scarth's worksheet which used Landsat data 
  ;The process attempts to recover M, the matrix of "endmembers" in the equation Mf≈r where f is the matrix if fractional cover estimates collected in the field, and r is the matrix of Landsat derived reflectances.
  ;Along the way we have to account for weighting due to site variability and changes due to the time between the field data and image data, the change in spectral response function from Landsat 5 to Landsat 7 and the very real possibility that the field observations, particulary when observing green and dead fractions, may be incorrect  due to observer bias.
  ;We use the pseudoinverse calculated using SVD to compute M as M=pinv(pinv(R) F)+
  ;
  ;Import the data
  ;To start, we import the linked field and image data with fields as outlined below: (bands correspond to MCD43A4, i.e. MODIS NBAR)

;  Data = read_SLATS_data()
  if Keyword_Set(data) eq 0 then $
    Data = read_SLATS_data_new()
  ; help, data, /str

  if keyword_set(sensor) eq 0 then $      ; if no keyword passed then assume it's modis nbar
    sensor='MCD43A4'  
  report = report+sensor+','

  if keyword_set(subset_data) eq 0 then $      ; if no keyword passed then assume it's modis nbar
    subset_data_str='allData' $
  Else $  
    subset_data_str='subsetData' 
  report = report+subset_data_str+','

  if keyword_set(noAbares) eq 0 then $      ; if no keyword passed then assume it's modis nbar
    noAbares_str='' $
  Else $  
    noAbares_str='_noAbares'  
  
  folder = 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\SAGE\plots\sensitivity\'
  IF (FILE_INFO(folder)).DIRECTORY eq 0 then FILE_MKDIR, folder
  cd, folder
  
;  Do something (nothing) about Cryptogram
;  well actually, just remove the sites which have more than 5% crypto. I dunno what to do about it...
;  TODO: Suggest it should be included as either a PV or NPV cover depending on it's colour.



  if sensor eq 'MCD43A4' or sensor eq 'MCD43A4_6B' then $
    satelliteReflectance= [[data.MCD43A4.B1], $
                          [data.MCD43A4.B2], $ 
                          [data.MCD43A4.B3], $ 
                          [data.MCD43A4.B4], $ 
                          [data.MCD43A4.B5], $ 
                          [data.MCD43A4.B6], $ 
                          [data.MCD43A4.B7]] * 0.0001
  if sensor eq 'MOD09A1' or sensor eq 'MOD09A1_6B' then $
    satelliteReflectance= [[data.MOD09A1.B1], $
                          [data.MOD09A1.B2], $ 
                          [data.MOD09A1.B3], $ 
                          [data.MOD09A1.B4], $ 
                          [data.MOD09A1.B5], $ 
                          [data.MOD09A1.B6], $ 
                          [data.MOD09A1.B7]] * 0.0001
  if sensor eq 'Landsat_3x3' then $
    satelliteReflectance= [[data.Landsat_scaling.B1_3x3], $
                          [data.Landsat_scaling.B2_3x3], $ 
                          [data.Landsat_scaling.B3_3x3], $ 
                          [data.Landsat_scaling.B4_3x3], $ 
                          [data.Landsat_scaling.B5_3x3], $ 
                          [data.Landsat_scaling.B6_3x3]]
  if sensor eq 'Landsat_40x40' then $
    satelliteReflectance= [[data.Landsat_scaling.B1_40x40], $
                          [data.Landsat_scaling.B2_40x40], $ 
                          [data.Landsat_scaling.B3_40x40], $ 
                          [data.Landsat_scaling.B4_40x40], $ 
                          [data.Landsat_scaling.B5_40x40], $ 
                          [data.Landsat_scaling.B6_40x40]]
  if sensor eq 'Landsat_QLD' then $
    satelliteReflectance= [[data.Landsat_QLD.B1], $
                          [data.Landsat_QLD.B2], $ 
                          [data.Landsat_QLD.B3], $ 
                          [data.Landsat_QLD.B4], $ 
                          [data.Landsat_QLD.B5], $ 
                          [data.Landsat_QLD.B6]]
   ;help, satelliteReflectance
  
;  Recover Satellite PV, NPV and Bare;  
;  Now need to work out the fractions as seen by the satellite!;  
;  The requires a bit of correction since we are observing from the midstorey;  
;  Note the requirement to convert back to counts and then account for occlusion and probabilities of interception in the various layers
  ; JUAN: this is already done by the read_SLATS_data() function and returned as the Fcover_Qld structure   
;  Does the total add up to 100% (give or take some crypto)

;  fname = 'SumOfFractions.ps.png'
;  if (FILE_INFO(fname)).exists eq 0 then begin
;    PS_Start, fname
;      !P.Multi = [0,2,1]
;      cgDisplay, 1000, 400
;      cgPlot, (data.FCOVER_QLD.totalpvcover + data.FCOVER_QLD.totalnpvcover + data.FCOVER_QLD.totalbarecover)$
;        [sort(data.FCOVER_QLD.totalpvcover + data.FCOVER_QLD.totalnpvcover + data.FCOVER_QLD.totalbarecover)], psym=16, $
;        xTitle='Site#', yTitle='Sum of fractions (no crypto)', Ticklen=1, xGridstyle=1, yGridstyle=1
;      cgPlot, (data.FCOVER_QLD.totalpvcover + data.FCOVER_QLD.totalnpvcover + data.FCOVER_QLD.totalbarecover + data.FCOVER_QLD.satGroundCryptoCover)$
;        [sort(data.FCOVER_QLD.totalpvcover + data.FCOVER_QLD.totalnpvcover + data.FCOVER_QLD.totalbarecover + data.FCOVER_QLD.satGroundCryptoCover)], psym=16, $
;        xTitle='Site#', yTitle='Sum of fractions (with crypto)', Ticklen=1, xGridstyle=1, yGridstyle=1
;    PS_End, resize=100, /PNG
;  EndIf
  
;  Plot the relative Proportions of the viewable cover types  
;  JUAN: make 3 plots instead of one. 
    
;  fname = 'RelativeProportions.ps.png'
;  if (FILE_INFO(fname)).exists eq 0 then begin
;    PS_Start, fname
;      !P.Multi = [0,2,2]
;      cgDisplay, 1000, 1000
;       cgHistoplot, data.FCOVER_QLD.totalpvcover, polycolor='dark green', title='PV', /fillpolygon 
;       cgHistoplot, data.FCOVER_QLD.totalnpvcover, polycolor='goldenrod', title='NPV', /fillpolygon
;       cgHistoplot, data.FCOVER_QLD.totalbarecover, polycolor='brown', title='bare', /fillpolygon
;       cgHistoplot, data.FCOVER_QLD.satGroundCryptoCover, polycolor='tomato', title='crypto', /fillpolygon
;    PS_End, resize=100, /PNG
;  EndIf

; Define and Apply the transform equation we apply to Landsat bands

  where_nan = Where(satelliteReflectance le 0, count)
  if count ge 1 then satelliteReflectance[where_nan]=!VALUES.F_NAN

  B1 = satelliteReflectance[*,0]
  B2 = satelliteReflectance[*,1]
  B3 = satelliteReflectance[*,2]
  B4 = satelliteReflectance[*,3]
  B5 = satelliteReflectance[*,4]
  B6 = satelliteReflectance[*,5]
  if sensor eq 'MCD43A4' or sensor eq 'MOD09A1' then $
    B7 = satelliteReflectance[*,6]
  
  if sensor eq 'MCD43A4_6B' or sensor eq 'MOD09A1_6B' then begin
    B5 = satelliteReflectance[*,5]
    B6 = satelliteReflectance[*,6]
  Endif

  if sensor eq 'MCD43A4' or sensor eq 'MOD09A1' then $
    satelliteReflectanceTransformed = $
       [[b1],[b2],[b3],[b4],[b5],[b6],[b7], $
       [alog(b1)],[alog(b2)],[alog(b3)],[alog(b4)],[alog(b5)],[alog(b6)],[alog(b7)], $
       [alog(b1)*b1],[alog(b2)*b2],[alog(b3)*b3],[alog(b4)*b4],[alog(b5)*b5],[alog(b6)*b6],[alog(b7)*b7], $
        [b1*b2],[b1*b3],[b1*b4],[b1*b5],[b1*b6],[b1*b7], $
                [b2*b3],[b2*b4],[b2*b5],[b2*b6],[b2*b7], $
                        [b3*b4],[b3*b5],[b3*b6],[b3*b7], $
                                [b4*b5],[b4*b6],[b4*b7], $
                                        [b5*b6],[b5*b7], $
                                                [b6*b7], $
       [alog(b1)*alog(b2)],[alog(b1)*alog(b3)],[alog(b1)*alog(b4)],[alog(b1)*alog(b5)],[alog(b1)*alog(b6)],[alog(b1)*alog(b7)], $
                [alog(b2)*alog(b3)],[alog(b2)*alog(b4)],[alog(b2)*alog(b5)],[alog(b2)*alog(b6)],[alog(b2)*alog(b7)], $
                        [alog(b3)*alog(b4)],[alog(b3)*alog(b5)],[alog(b3)*alog(b6)],[alog(b3)*alog(b7)], $
                                [alog(b4)*alog(b5)],[alog(b4)*alog(b6)],[alog(b4)*alog(b7)], $
                                        [alog(b5)*alog(b6)],[alog(b5)*alog(b7)], $
                                                [alog(b6)*alog(b7)], $
        [(b2-b1)/(b2+b1)],[(b3-b1)/(b3+b1)],[(b4-b1)/(b4+b1)],[(b5-b1)/(b5+b1)],[(b6-b1)/(b6+b1)],[(b7-b1)/(b7+b1)], $
                          [(b3-b2)/(b3+b2)],[(b4-b2)/(b4+b2)],[(b5-b2)/(b5+b2)],[(b6-b2)/(b6+b2)],[(b7-b2)/(b7+b2)], $
                                            [(b4-b3)/(b4+b3)],[(b5-b3)/(b5+b3)],[(b6-b3)/(b6+b3)],[(b7-b3)/(b7+b3)], $
                                                              [(b5-b4)/(b5+b4)],[(b6-b4)/(b6+b4)],[(b7-b4)/(b7+b4)], $
                                                                                [(b6-b5)/(b6+b5)],[(b7-b5)/(b7+b5)], $
                                                                                                  [(b7-b6)/(b7+b6)]]
                                                                                                   
  if sensor eq 'Landsat_3x3' or $
     sensor eq 'Landsat_40x40' or $
     sensor eq 'MCD43A4_6B' or $
     sensor eq 'MOD09A1_6B' or $
     sensor eq 'Landsat_QLD' then $
    satelliteReflectanceTransformed = $
       [[b1],[b2],[b3],[b4],[b5],[b6], $
       [alog(b1)],[alog(b2)],[alog(b3)],[alog(b4)],[alog(b5)],[alog(b6)], $
       [alog(b1)*b1],[alog(b2)*b2],[alog(b3)*b3],[alog(b4)*b4],[alog(b5)*b5],[alog(b6)*b6], $
        [b1*b2],[b1*b3],[b1*b4],[b1*b5],[b1*b6],  $
                [b2*b3],[b2*b4],[b2*b5],[b2*b6],  $
                        [b3*b4],[b3*b5],[b3*b6],  $
                                [b4*b5],[b4*b6],  $
                                        [b5*b6],  $
       [alog(b1)*alog(b2)],[alog(b1)*alog(b3)],[alog(b1)*alog(b4)],[alog(b1)*alog(b5)],[alog(b1)*alog(b6)], $
                [alog(b2)*alog(b3)],[alog(b2)*alog(b4)],[alog(b2)*alog(b5)],[alog(b2)*alog(b6)], $
                        [alog(b3)*alog(b4)],[alog(b3)*alog(b5)],[alog(b3)*alog(b6)], $
                                [alog(b4)*alog(b5)],[alog(b4)*alog(b6)], $
                                        [alog(b5)*alog(b6)], $
        [(b2-b1)/(b2+b1)],[(b3-b1)/(b3+b1)],[(b4-b1)/(b4+b1)],[(b5-b1)/(b5+b1)],[(b6-b1)/(b6+b1)], $
                          [(b3-b2)/(b3+b2)],[(b4-b2)/(b4+b2)],[(b5-b2)/(b5+b2)],[(b6-b2)/(b6+b2)], $
                                            [(b4-b3)/(b4+b3)],[(b5-b3)/(b5+b3)],[(b6-b3)/(b6+b3)], $
                                                              [(b5-b4)/(b5+b4)],[(b6-b4)/(b6+b4)], $
                                                                                [(b6-b5)/(b6+b5)]] 
     ;help, satelliteReflectanceTransformed                                                                           
 
 
  ; Weighting. There are several ways to do it. I am playing with the weight_factor 
  SAM_40X40_ = data.landsat_scaling.SAM_40x40 
  ED_40X40_ = data.landsat_scaling.ED_40x40 

  if Keyword_Set(weight) eq 0 then begin        ;if no value passed then assume it's -1 (no weights, use all data)
    weight_factor = -1 
    weight = -1
  Endif Else Begin
    weight_factor=weight
  EndElse  
  if n_elements(weight) eq 1 then if weight eq 0 then weight_factor = 0  ; special case if zero is passed 
;  Weights = 1.0 / (SAM_40X40_ * weight_factor + 1.0)
  Weights = 1.0 / (ED_40X40_ * weight_factor + 1.0)
  IF weight_factor eq -1 then Weights[*] = 1.0        ; won't have any NaNs
  Weight_str = 'WeightEQ_'+strtrim(weight, 2)
  report = report+strtrim(weight, 2)+','

  ; check where Nans and get rid of them (creates new array)
  ; sites withouth data on weighting also get deleted (special case when -1 is passed then all weights are 1) 
  satelliteReflectanceTransformed = transpose(satelliteReflectanceTransformed)  
  size_satelliteReflectanceTransformed =Size(satelliteReflectanceTransformed)

  ; here i'll find the observations with data in all Landsat and MOD09A1 and MCD43A1
  IF keyword_Set(subset_data) then begin
    where_subset = where_ALL_data_ok(DATA)
    count = n_elements(where_subset)
    folder = 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\SAGE\plots\subset_data\'
    IF (FILE_INFO(folder)).DIRECTORY eq 0 then FILE_MKDIR, folder
    cd, folder
  EndIf Else Begin 
    where_subset = where(Total(finite(satelliteReflectanceTransformed), 1) + $
                    finite(Weights) eq size_satelliteReflectanceTransformed[1] + 1, complement=where_nan, count)     
  EndElse             
 
  IF keyword_Set(noAbares) then begin
    where_ok_noAbares = where((data.field_all.source)[where_subset] ne 'abares', count)
    where_ok = where_subset[where_ok_noAbares]
  endIf Else Begin
    where_ok = where_subset
  EndElse

  ;print, count, ' data point retained (no NaNs in reflectance nor weight)' 
  if count ge 1 then satelliteReflectanceTransformed_new = fltarr(size_satelliteReflectanceTransformed[1], count)
  if count ge 1 then for i=0, count-1 do satelliteReflectanceTransformed_new[*,i]=satelliteReflectanceTransformed[*,where_ok[i]] 
  if count ge 1 then satelliteReflectanceTransformed=satelliteReflectanceTransformed_new  
  ; also modify observed fractions if needed
  
  
  SAM_40X40=fltarr(count)
  ED_40X40=fltarr(count)
  weights_new=fltarr(count)
  obs_key = STRARR(count)
  image_name = STRARR(count)
  site = STRARR(count)
  source = STRARR(count)
  timelag = intarr(count)
  lat = fltarr(count)
  lon = fltarr(count)
  ; do something about crypto!!
  experiment = 'no_crypto'
  report = report+experiment+','

  
  output_string=sensor+'_WeightEQ_'+StrTrim(weight_factor,2)+'_'+experiment+'_'+subset_data_str+noAbares_str

  IF Keyword_Set(UseOverstorey) then Begin   ; if this keyword on then use 4 fractions (2 for PV)
    siteDataArray_invert=fltarr(4, count) 
    for i=0, count-1 do siteDataArray_invert[0,i]=data.FCOVER_QLD.totalPVcover[where_ok[i]]-data.FCOVER_QLD.canopyFoliageProjectiveCover[where_ok[i]]   ; + data.FCOVER_QLD.satGroundCryptoCover[where_ok[i]]
    for i=0, count-1 do siteDataArray_invert[1,i]=data.FCOVER_QLD.totalNPVcover[where_ok[i]]  ; + data.FCOVER_QLD.satGroundCryptoCover[where_ok[i]]    
    for i=0, count-1 do siteDataArray_invert[2,i]=data.FCOVER_QLD.totalBAREcover[where_ok[i]] ; + data.FCOVER_QLD.satGroundCryptoCover[where_ok[i]]
    for i=0, count-1 do siteDataArray_invert[3,i]=data.FCOVER_QLD.canopyFoliageProjectiveCover[where_ok[i]]
    siteDataArray=fltarr(3, count)
    siteDataArray[0,*]=siteDataArray_invert[0,*]+siteDataArray_invert[3,*]
    siteDataArray[1,*]=siteDataArray_invert[1,*] 
    siteDataArray[2,*]=siteDataArray_invert[2,*] 
    output_string += '_UseOverstorey'
  EndIf ELSE Begin
    siteDataArray_invert=fltarr(3, count) 
    for i=0, count-1 do siteDataArray_invert[0,i]=data.FCOVER_QLD.totalPVcover[where_ok[i]]   ; + data.FCOVER_QLD.satGroundCryptoCover[where_ok[i]]
    for i=0, count-1 do siteDataArray_invert[1,i]=data.FCOVER_QLD.totalNPVcover[where_ok[i]]  ; + data.FCOVER_QLD.satGroundCryptoCover[where_ok[i]]    
    for i=0, count-1 do siteDataArray_invert[2,i]=data.FCOVER_QLD.totalBAREcover[where_ok[i]] ; + data.FCOVER_QLD.satGroundCryptoCover[where_ok[i]]
    siteDataArray=siteDataArray_invert
  EndElse  
  

  for i=0, count-1 do SAM_40X40[i] = (data.landsat_scaling.SAM_40x40)[where_ok[i]] 
  for i=0, count-1 do ED_40X40[i] = (data.landsat_scaling.ED_40x40)[where_ok[i]] 
  for i=0, count-1 do weights_new[i] = (weights)[where_ok[i]]
  weights = weights_new
  for i=0, count-1 do obs_key[i] = (data.field_all.obs_key)[where_ok[i]]
  for i=0, count-1 do image_name[i] = (data.landsat_scaling.image_name)[where_ok[i]]
  for i=0, count-1 do site[i] = (data.field_all.site)[where_ok[i]]
  for i=0, count-1 do timelag[i] = (data.landsat_scaling.timelag)[where_ok[i]]
  for i=0, count-1 do source[i] = (data.field_all.source)[where_ok[i]]
  for i=0, count-1 do lat[i] = (data.field_all.latitude)[where_ok[i]]
  for i=0, count-1 do lon[i] = (data.field_all.longitude)[where_ok[i]]
   
;-------------------------------------------------------------------------------------------------------------------------
; NEW BIT!! 
; DECIDE ON OBSERVATIONS (OUT OF THE VALID ONES) TO LEAVE OUT FOR SENSITIVITY ANALYSIS
  LO = 'Abares'
  WHERE_LO = where(source eq 'abares', count_lo, COMPLEMENT=where_LI, NCOMPLEMENT=count_LI)

;  LO = '75pc dark soils'
;  soil_brightness=(DATA.SoilColor.red+DATA.SoilColor.green+DATA.SoilColor.blue)[where_ok]
;  SB_75pc = soil_brightness[(sort(soil_brightness))[count*0.25]]
;  WHERE_LO = where(soil_brightness le SB_75pc, $
;    count_lo, COMPLEMENT=where_LI, NCOMPLEMENT=count_LI)

;   LO = '50pc random2'
;   random = RandomU(systime(1), count)
;   WHERE_LO = where(random gt 0.5, count_lo, COMPLEMENT=where_LI, NCOMPLEMENT=count_LI)
  output_string=output_string+'_leaveOut_'+LO 
;-------------------------------------------------------------------------------------------------------------------------
   
;-------------------------------------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------------------------------------
;  fname = 'WeightEQ_'+StrTrim(weight_factor,2)+'.ps.png'
;  if (FILE_INFO(fname)).exists eq 0 then begin
;    PS_Start, fname
;      !P.Multi=[0,2,3]
;      cgDisplay, 800, 1000
;      cgPlot, ED_40X40, Weights, psym=16, Ticklen=1, xGridstyle=1, yGridstyle=1, $
;        xTitle='Spectral Angle 40x40', yTitle='weights'
;      cgPlot, ALOG10(ED_40X40), Weights, psym=16, Ticklen=1, xGridstyle=1, yGridstyle=1, $
;        xTitle='LOG of Spectral Angle 40x40', yTitle='weights'
;      cgHistoplot, ED_40X40, xTitle='Euclidean Distance 40x40'
;      cgHistoplot, ALOG10(ED_40X40), xTitle='Log of Euclidean Distance 40x40'
;      if weight_factor ne 0 then cgHistoplot, Weights, xTitle='Weights'      
;    PS_End, resize=100, /PNG
;  EndIf
;-------------------------------------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------------------------------------
                                                                                         
                                                         
;-------------------------------------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------------------------------------
;  Crossvalidation to select optimum SVs;  
;  First have a look at the Singular Values, then use cross validation - 
;   we don't want to over fit which is a very real possibility given the number of transformed variables  
;  SVDC, transpose(satelliteReflectanceTransformed), S, U, Vh
  Weights_array = satelliteReflectanceTransformed*0.0
  for i=0, (Size(Weights_array))[1]-1 do Weights_array[i,*]=Weights
  SVDC, Weights_array*satelliteReflectanceTransformed, S, U, Vh
  toleranceSVs=s/max(s)
  ;print, 'Singular Values are:',  toleranceSVs[0:50]
  fname = 'SingularValues_'+output_string+'.ps.png'
;  if (FILE_INFO(fname)).exists eq 0 then begin
;    PS_Start, fname
;      cgPlot, alog(toleranceSVs), psym=16, Ticklen=1, xGridstyle=1, yGridstyle=1
;    PS_End, resize=100, /PNG
;  EndIf
      
  
;  Perform 50:50 cross validation - we are looking for a local minimum to select the optimal subspace to perform the inversion/unmixing
  sum2oneWeight=0.02
  lower_bound=-0.0 
  upper_bound=1.0 
  crossvalidationAmount=2
  bareRMSerror=[]
  numberSites=n_elements(satelliteReflectanceTransformed[0,*])  
 
;; ALL THE CODE BELOW IS COMMENTED. WAS RUN ONCE IN POWERAPP AND THE OUTPUT SAVED. IT WAS SLOW TO RUN EVERY TIME
;  fname = 'MeanRMSerror_'+output_string+'.ps.png'
;  if (FILE_INFO(fname)).exists eq 0 AND Keyword_set(crossvalidation) then begin
;  for i=0, N_ELEMENTS(toleranceSVs)-1 do begin
;    print, 'i ', i
;    bareRMSerrorArray=[]
;;    for loop =0, 99 do begin
;    for loop =0, 9 do begin
;       
;      shuffleIndex = sort(randomU(systime(1), numberSites))
;      calibrationSites=shuffleIndex[0:numberSites/crossvalidationAmount]
;      validationSites=shuffleIndex[numberSites/crossvalidationAmount+1:*]      
;      
;      endmembersWeighted = svd_matrix_invert(svd_matrix_invert( $
;         Weights_array[*, calibrationSites]*satelliteReflectanceTransformed[*, calibrationSites], rcond=toleranceSVs[i]) $
;         ## (Weights_array[*, calibrationSites]*siteDataArray_invert[*, calibrationSites]))
;      
;      retrievedCoverFractions = unmix_3_fractions_bvls(satelliteReflectanceTransformed[*, validationSites], endmembersWeighted, $
;          lower_bound=lower_bound, upper_bound=upper_bound, sum2oneWeight=sum2oneWeight)
;
;      IF Keyword_Set(UseOverstorey) then Begin   ; reconstruct the 3 fractions by adding up the two greens
;        retrievedCoverFractions[*,0] = retrievedCoverFractions[*,0]+retrievedCoverFractions[*,3]
;        retrievedCoverFractions=retrievedCoverFractions[*,0:2]
;      EndIf  
;       
;      rmsError=sqrt(mean((transpose(retrievedCoverFractions) - siteDataArray[*, validationSites])^2))
;      bareRMSerrorArray=[bareRMSerrorArray,rmsError]      
;       
;    endfor
;    
;    bareRMSerror=[bareRMSerror,mean(bareRMSerrorArray)]
;    
;  endfor
;    
;  whereMinbareRMSerror = where(bareRMSerror eq min(bareRMSerror))
;  ;print, whereMinbareRMSerror
;    PS_Start, fname
;      cgDisplay, 400, 400
;      cgPlot, bareRMSerror, xTitle='weight / min= '+string(whereMinbareRMSerror), $
;        yTitle='Mean RMS Error / Min='+string(min(bareRMSerror)), $
;        Ticklen=1, xGridstyle=1, yGridstyle=1, THICK=3, /addcmd
;      cgPlot, [whereMinbareRMSerror,whereMinbareRMSerror],[whereMinbareRMSerror,0], color='red', /overplot, /addcmd
;      cgPlot, [0,n_elements(bareRMSerror)],[min(bareRMSerror),min(bareRMSerror)],color='red', /overplot      , /addcmd
;      
;    PS_End, resize=100, /PNG
;  EndIf
;;-------------------------------------------------------------------------------------------------------------------------
;;-------------------------------------------------------------------------------------------------------------------------


;-------------------------------------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------------------------------------
; GIVE OUR "OPTIMAL" ENDMEMBERS A WHIRL

  ; the conditions below come from performing the cross validation for each sensor and then 
  ; selecting where the RMSE is the lowest. 
  if sensor eq 'MCD43A4' then rcond=toleranceSVs[23] 
  if sensor eq 'MOD09A1' then rcond=toleranceSVs[24] 
  if sensor eq 'Landsat_3x3' then rcond=toleranceSVs[16] 
  if sensor eq 'Landsat_40x40' then rcond=toleranceSVs[18] 
  if sensor eq 'Landsat_QLD' then rcond=toleranceSVs[18] 
  if sensor eq 'MCD43A4_6B' then rcond=toleranceSVs[22] 
  if sensor eq 'MOD09A1_6B' then rcond=toleranceSVs[22]     ;check if OK!! 
   
   sum2oneWeight=0.02
   lower_bound=-0.0 
   upper_bound=1.0 
  
  endmembersWeighted = svd_matrix_invert(svd_matrix_invert(Weights_array*satelliteReflectanceTransformed, rcond=rcond) ## $
    (Weights_array*siteDataArray_invert))
  endmembersWeighted_LO = svd_matrix_invert(svd_matrix_invert(Weights_array[*,where_LI]*satelliteReflectanceTransformed[*,where_LI], rcond=rcond) ## $
    (Weights_array[*,where_LI]*siteDataArray_invert[*,where_LI]))
  fname='TransformedReflectance_'+output_string+'.SAV'
  if (FILE_INFO(fname)).exists eq 0 then begin
    ;print, 'saving endmembersWeighted in ', fname
    SAVE, endmembersWeighted, FILENAME=fname
  EndIf

;  fname='TransformedReflectance_'+output_string+'.ps.png'
;  if (FILE_INFO(fname)).exists eq 0 then begin
;    PS_Start, fname
;      cgPlot, endmembersWeighted[*,0], Ticklen=1, xGridstyle=1, yGridstyle=1, color='dark green', $
;        xTitle='Band', yTitle='Transformed Reflectance'
;      cgPlot, endmembersWeighted[*,1], Ticklen=1, xGridstyle=1, yGridstyle=1, color='goldenrod', /overplot
;      cgPlot, endmembersWeighted[*,2], Ticklen=1, xGridstyle=1, yGridstyle=1, color='brown', /overplot
;    PS_End, resize=100, /PNG
;  EndIf
   
  retrievedCoverFractions = Transpose(unmix_3_fractions_bvls(satelliteReflectanceTransformed, endmembersWeighted, $
      lower_bound=lower_bound, upper_bound=upper_bound, sum2oneWeight=sum2oneWeight))
  retrievedCoverFractions_LO = Transpose(unmix_3_fractions_bvls(satelliteReflectanceTransformed, endmembersWeighted_LO, $
      lower_bound=lower_bound, upper_bound=upper_bound, sum2oneWeight=sum2oneWeight))
       
  IF Keyword_Set(UseOverstorey) then Begin   ; reconstruct the 3 fractions by adding up the two greens
    retrievedCoverFractions_4Endm=retrievedCoverFractions   ; keep the 4 endmembers 
    retrievedCoverFractions[0,*] = retrievedCoverFractions[0,*]+retrievedCoverFractions[3,*]
    retrievedCoverFractions=retrievedCoverFractions[0:2,*]
  EndIf  
  
  ;; plot map with points
  fname='Map_'+output_string+'.ps.png'
  if (FILE_INFO(fname)).exists eq 0 then begin
    PS_Start, fname
      cgDisplay, (155-112)*10, (45-10)*10
      !P.Multi=0
      AusCoastline=auscoastline()
      cgPlot, lon, lat, psym=9, symsize=0.5, xRange=[112, 155], yRange=[-45, -10], xStyle=1, yStyle=1  
      cgPlot, AusCoastline.lon, AusCoastline.lat, color='blue', psym=-3, thick=2, /OVERPLOT 
      cgPlot, lon[where_LO], lat[where_LO], psym=16, symsize=0.7,  color='red', /overplot
    PS_End, resize=100, /PNG
  EndIf


  rmsError = []
  r = []
  n = []
  stdev_po = []
  rmsError_weighted = []
  for i=0,2 do $
    rmsError=[rmsError,sqrt(mean((retrievedCoverFractions[i,*] - siteDataArray[i,*])^2))]
    rmsErrorAll=sqrt(mean((retrievedCoverFractions - siteDataArray)^2))
  for i=0,2 do $
    r=[r,correlate_nan(retrievedCoverFractions[i,*], siteDataArray[i,*])]
    r_all=correlate_nan(retrievedCoverFractions, siteDataArray)
  for i=0,2 do $
    n=[n,fix(total(finite(retrievedCoverFractions[i,*] + siteDataArray[i,*])))]
  for i=0,2 do $
    stdev_po=[stdev_po,stddev(retrievedCoverFractions[i,*])/stddev(siteDataArray[i,*])]
    stdev_po_all=stddev(retrievedCoverFractions)/stddev(siteDataArray)
      
  report = report+strtrim(rmsError[0],2)+','+strtrim(rmsError[1],2)+','+strtrim(rmsError[2],2)+','+strtrim(rmsErrorAll,2)+','
  report = report+strtrim(r[0],2)+','+strtrim(r[1],2)+','+strtrim(r[2],2)+','+strtrim(r_all,2)+','
  report = report+strtrim(stdev_po[0],2)+','+strtrim(stdev_po[1],2)+','+strtrim(stdev_po[2],2)+','+strtrim(stdev_po_all,2)+','
  report = report+strtrim(n[0],2)+','+strtrim(n[1],2)+','+strtrim(n[2],2)
    
  for i=0,2 do $
    rmsError_weighted=[rmsError_weighted,sqrt(mean(((retrievedCoverFractions[i,*] - siteDataArray[i,*]) * weights)^2))]
    rmsErrorAll_weighted=mean(rmsError_weighted)
  ;print, rmsError,rmsErrorAll
  ;print, rmsError_weighted,rmsErrorAll_weighted
  residuals = retrievedCoverFractions - siteDataArray
   
  fname='ObservedPredictedFractions_'+output_string+'.ps.png'
  if (FILE_INFO(fname)).exists eq 0 then begin
    PS_Start, fname
      color=['dark green','goldenrod','brown']
      title=['GREEN','nonGREEN','BARE']
      !P.Multi=[0,4,2]
      cgDisplay, 1300, 600
      for i=0,2 do begin
        xTitle='predicted'
        yTitle='Field'
        cgPlot, retrievedCoverFractions[i,*], siteDataArray[i,*], color=color[i], psym=16, Symsize=.25, $
          xTitle=xTitle, yTitle=yTitle, Ticklen=.5, xGridstyle=1, yGridstyle=1, Title=Title[i], $
          xRange=[-0.05, 1.05], yRange=[-0.05, 1.05], xStyle=1, yStyle=1, XTHICK=0.5, yTHICK=0.5 
        cgPlot, retrievedCoverFractions[i,where_LO], siteDataArray[i,where_LO], color='RED', psym=16, Symsize=.25, /overplot
        oplot_regress, retrievedCoverFractions[i,*], siteDataArray[i,*], /NAN, /NO_EQUATION, color=color[i]
        oplot_regress, retrievedCoverFractions[i,where_LO], siteDataArray[i,where_LO], /NAN, /NO_EQUATION, color='red'
        cgPlot, [-1,2],[-1,2], /overplot
        al_legend_stats, retrievedCoverFractions[i,*], siteDataArray[i,*], box=0, charsize=0.6
        al_legend_stats, retrievedCoverFractions[i,where_LO], siteDataArray[i,where_LO], box=0, charsize=0.6, /bottom, /right
      endfor   
        cgPlot, retrievedCoverFractions[*,*], siteDataArray[*,*], color='grey', psym=16, Symsize=.25, $
          xTitle=xTitle, yTitle=yTitle, Ticklen=.5, xGridstyle=1, yGridstyle=1, Title='ALL', $
          xRange=[-0.05, 1.05], yRange=[-0.05, 1.05], xStyle=1, yStyle=1, XTHICK=0.5, yTHICK=0.5 
        cgPlot, retrievedCoverFractions[*,where_LO], siteDataArray[*,where_LO], color='RED', psym=16, Symsize=.25, /overplot
        oplot_regress, retrievedCoverFractions[*,*], siteDataArray[*,*], /NAN, /NO_EQUATION 
        oplot_regress, retrievedCoverFractions[*,where_LO], siteDataArray[*,where_LO], /NAN, /NO_EQUATION, color='red'
        cgPlot, [-1,2],[-1,2], /overplot
        al_legend_stats, retrievedCoverFractions[*,*], siteDataArray[*,*], box=0, charsize=0.6
        al_legend_stats, retrievedCoverFractions[*,where_LO], siteDataArray[*,where_LO], box=0, charsize=0.6, /bottom, /right

        
      for i=0,2 do begin
        xTitle='predicted'
        yTitle='Field'
        cgPlot, retrievedCoverFractions_LO[i,*], siteDataArray[i,*], color=color[i], psym=16, Symsize=.25, $
          xTitle=xTitle, yTitle=yTitle, Ticklen=.5, xGridstyle=1, yGridstyle=1, Title=Title[i], $
          xRange=[-0.05, 1.05], yRange=[-0.05, 1.05], xStyle=1, yStyle=1, XTHICK=0.5, yTHICK=0.5 
        cgPlot, retrievedCoverFractions_LO[i,where_LO], siteDataArray[i,where_LO], color='RED', psym=16, Symsize=.25, /overplot
        oplot_regress, retrievedCoverFractions_LO[i,where_LI], siteDataArray[i,where_LI], /NAN, /NO_EQUATION, color=color[i]
        oplot_regress, retrievedCoverFractions_LO[i,where_LO], siteDataArray[i,where_LO], /NAN, /NO_EQUATION, color='red'
        cgPlot, [-1,2],[-1,2], /overplot
        al_legend_stats, retrievedCoverFractions_LO[i,where_LI], siteDataArray[i,where_LI], box=0, charsize=0.6
        al_legend_stats, retrievedCoverFractions_LO[i,where_LO], siteDataArray[i,where_LO], box=0, charsize=0.6, /bottom, /right
      endfor   
        cgPlot, retrievedCoverFractions_LO[*,*], siteDataArray[*,*], color='grey', psym=16, Symsize=.25, $
          xTitle=xTitle, yTitle=yTitle, Ticklen=.5, xGridstyle=1, yGridstyle=1, Title='ALL', $
          xRange=[-0.05, 1.05], yRange=[-0.05, 1.05], xStyle=1, yStyle=1, XTHICK=0.5, yTHICK=0.5 
        cgPlot, retrievedCoverFractions_LO[*,where_LO], siteDataArray[*,where_LO], color='RED', psym=16, Symsize=.25, /overplot
        oplot_regress, retrievedCoverFractions_LO[*,where_LI], siteDataArray[*,where_LI], /NAN, /NO_EQUATION
        oplot_regress, retrievedCoverFractions_LO[*,where_LO], siteDataArray[*,where_LO], color='RED', /NAN, /NO_EQUATION
        cgPlot, [-1,2],[-1,2], /overplot
        al_legend_stats, retrievedCoverFractions_LO[*,where_LI], siteDataArray[*,where_LI], box=0, charsize=0.6
        al_legend_stats, retrievedCoverFractions_LO[*,where_LO], siteDataArray[*,where_LO], box=0, charsize=0.6, /bottom, /right
     PS_End, resize=100, /PNG
  endif  

  fname='Residuals_'+output_string+'.ps.png'
  if (FILE_INFO(fname)).exists eq 0 then begin
    PS_Start, fname
      color=['dark green','goldenrod','brown']
      title=['GREEN','nonGREEN','BARE']
      !P.Multi=[0,4,2]
      cgDisplay, 1300, 600
      for i=0,2 do begin
        xTitle='Residuals'
        yTitle='Field'
        cgPlot, retrievedCoverFractions_LO[i,*], residuals[i,*], color=color[i], psym=16, Symsize=.25, $
          xTitle=xTitle, yTitle=yTitle, Ticklen=.5, xGridstyle=1, yGridstyle=1 , XTHICK=0.5, yTHICK=0.5
        cgPlot, retrievedCoverFractions_LO[i,where_LO], residuals[i,where_LO], color='RED', psym=16, Symsize=.25, /overplot
        oplot_regress, retrievedCoverFractions_LO[i,*], residuals[i,*], /NAN, /NO_EQUATION
        cgPlot, [-1,2],[0,0], /overplot
        al_legend_stats, retrievedCoverFractions_LO[i,*], residuals[i,*], /n, box=0, charsize=0.6
      endfor    
        cgPlot, retrievedCoverFractions_LO[*,*], residuals[*,*], color='grey', psym=16, Symsize=.25, $
          xTitle=xTitle, yTitle=yTitle, Ticklen=.5, xGridstyle=1, yGridstyle=1 , XTHICK=0.5, yTHICK=0.5
        cgPlot, retrievedCoverFractions_LO[*,where_LO], residuals[*,where_LO], color='RED', psym=16, Symsize=.25, /overplot
        oplot_regress, retrievedCoverFractions_LO[*,*], residuals[*,*], /NAN, /NO_EQUATION
        cgPlot, [-1,2],[0,0], /overplot
        al_legend_stats, retrievedCoverFractions_LO[*,*], residuals[*,*], /n, box=0, charsize=0.6

      for i=0,2 do begin
        xTitle='Residuals'
        yTitle='Field'
        cgPlot, retrievedCoverFractions[i,*], residuals[i,*], color=color[i], psym=16, Symsize=.25, $
          xTitle=xTitle, yTitle=yTitle, Ticklen=.5, xGridstyle=1, yGridstyle=1 , XTHICK=0.5, yTHICK=0.5
        cgPlot, retrievedCoverFractions[i,where_LO], residuals[i,where_LO], color='RED', psym=16, Symsize=.25, /overplot
        oplot_regress, retrievedCoverFractions[i,*], residuals[i,*], /NAN, /NO_EQUATION
        cgPlot, [-1,2],[0,0], /overplot
        al_legend_stats, retrievedCoverFractions[i,*], residuals[i,*], /n, box=0, charsize=0.6
      endfor    
        cgPlot, retrievedCoverFractions[*,*], residuals[*,*], color='grey', psym=16, Symsize=.25, $
          xTitle=xTitle, yTitle=yTitle, Ticklen=.5, xGridstyle=1, yGridstyle=1 , XTHICK=0.5, yTHICK=0.5
        cgPlot, retrievedCoverFractions[*,where_LO], residuals[*,where_LO], color='RED', psym=16, Symsize=.25, /overplot
        oplot_regress, retrievedCoverFractions[*,*], residuals[*,*], /NAN, /NO_EQUATION
        cgPlot, [-1,2],[0,0], /overplot
        al_legend_stats, retrievedCoverFractions[*,*], residuals[*,*], /n, box=0, charsize=0.6
        
     PS_End, resize=100, /PNG
  endif  

;-------------------------------------------------------------------------------------------------------------------------
  ; create a Taylor diagram showing model performance
  ref_std = 1.0                                                
  stddev_max = 1.1                                             
 
  fname='Taylor_'+output_string+'.ps.png'
  if (FILE_INFO(fname)).exists eq 0 then begin
  PS_Start,  fname
    cgDisplay;, 200, 200
     cgTaylorDiagram, 1, 1, REF_STDDEV=ref_std, $
         STDDEV_MAX=stddev_max, LABELS='', C_SYMBOL='Dark grey', $
         C_CORRELATION='Dark grey', Symbol=3 
  
    sensorVal=['CSIRO_V2.1','CSIRO_V2.2']
    SYMBOL=[46, 45, 14, 4]
    C_SYMBOL=['dark green','goldenrod','brown']
  
    for i=0,2 do $;begin
     cgTaylorDiagram, stddev(retrievedCoverFractions[i,*])/stddev(siteDataArray[i,*]), $
         correlate_nan(retrievedCoverFractions[i,*],siteDataArray[i,*]), $
         REF_STDDEV=ref_std, STDDEV_MAX=stddev_max, LABELS='', C_SYMBOL=C_SYMBOL[i], $
         Symbol=SYMBOL[0], /overplot, SymSize=2
 
    for i=0,2 do $;begin
     cgTaylorDiagram, stddev(retrievedCoverFractions_LO[i,where_LI])/stddev(siteDataArray[i,where_LI]), $
         correlate_nan(retrievedCoverFractions_LO[i,where_LI],siteDataArray[i,where_LI]), $
         REF_STDDEV=ref_std, STDDEV_MAX=stddev_max, LABELS='', C_SYMBOL=C_SYMBOL[i], $
         Symbol=SYMBOL[1], /overplot, SymSize=2

    for i=0,2 do $;begin
     cgTaylorDiagram, stddev(retrievedCoverFractions[i,where_LO])/stddev(siteDataArray[i,where_LO]), $
         correlate_nan(retrievedCoverFractions[i,where_LO],siteDataArray[i,where_LO]), $
         REF_STDDEV=ref_std, STDDEV_MAX=stddev_max, LABELS='', C_SYMBOL=C_SYMBOL[i], $
         Symbol=SYMBOL[2], /overplot, SymSize=2

    for i=0,2 do $;begin
     cgTaylorDiagram, stddev(retrievedCoverFractions_LO[i,where_LO])/stddev(siteDataArray[i,where_LO]), $
         correlate_nan(retrievedCoverFractions_LO[i,where_LO],siteDataArray[i,where_LO]), $
         REF_STDDEV=ref_std, STDDEV_MAX=stddev_max, LABELS='', C_SYMBOL=C_SYMBOL[i], $
         Symbol=SYMBOL[3], /overplot, SymSize=2
    
      al_legend, ['all sites/model all','all sites/leave out '+LO,LO+'/model all', LO+'/leave out '+LO], $
        psym=SYMBOL, box=0, $
        position=[0.55,0.95], /normal;,  /right

     PS_End, resize=100, /PNG
  endif  


;  IF Keyword_Set(UseOverstorey) then Begin   ; plot the 4 fractions
;    fname='ObservedPredictedFractions_'+output_string+'4Endmembers.ps.png'
;    if (FILE_INFO(fname)).exists eq 0 then begin
;    rmsError = []
;    for i=0,3 do $
;      rmsError=[rmsError,sqrt(mean((transpose(retrievedCoverFractions_4Endm[i,*]) - siteDataArray_invert[i,*])^2))]
;      rmsErrorAll=mean(rmsError)
;    PS_Start, fname
;      color=['green','goldenrod','brown','dark green']
;      title=['understorey GREEN','nonGREEN','BARE','overstorey GREEN']
;      !P.Multi=[0,4,1]
;      cgDisplay, 1300, 300
;      for i=0,3 do begin
;        xTitle='predicted'
;        yTitle='Field'
;        cgPlot, retrievedCoverFractions_4Endm[i,*], siteDataArray_invert[i,*], color=color[i], psym=16, Symsize=.25, $
;          xTitle=xTitle, yTitle=yTitle, Ticklen=.5, xGridstyle=1, yGridstyle=1, Title=title[i], $
;          xRange=[-0.05, 1.05], yRange=[-0.05, 1.05], xStyle=1, yStyle=1, XTHICK=0.5, yTHICK=0.5 
;        oplot_regress, retrievedCoverFractions_4Endm[i,*], siteDataArray_invert[i,*], /NAN, /NO_EQUATION
;        cgPlot, [-1,2],[-1,2], /overplot
;        al_legend_stats, retrievedCoverFractions_4Endm[i,*], siteDataArray_invert[i,*], box=0, charsize=0.6
;      endfor   
;      PS_End, resize=100, /PNG
;    EndIf
;  EndIf 
;-------------------------------------------------------------------------------------------------------------------------
;  fname='Residuals_relationshipBetweenThem_'+output_string+'.ps.png'
;  if (FILE_INFO(fname)).exists eq 0 then begin
;    PS_Start, fname
;      color=['dark green','goldenrod','brown']
;      xRange=[-1,1]
;      yRange=xRange
;      !P.Multi=[0,3,1]
;      cgDisplay, 1000, 300
;      cgPlot, residuals[0,*], residuals[1,*], psym=16, Symsize=.25, $
;          xTitle='residuals green', yTitle='residuals nongreen', Ticklen=.5, xGridstyle=1, yGridstyle=1 , $
;          XTHICK=0.5, yTHICK=0.5, xRange=xRange, yRange=yRange
;        oplot_regress, residuals[0,*], residuals[1,*], /NAN, /NO_EQUATION
;      cgPlot, residuals[0,*], residuals[2,*], psym=16, Symsize=.25, $
;          xTitle='residuals green', yTitle='residuals bare', Ticklen=.5, xGridstyle=1, yGridstyle=1 , $
;          XTHICK=0.5, yTHICK=0.5, xRange=xRange, yRange=yRange
;        oplot_regress, residuals[0,*], residuals[2,*], /NAN, /NO_EQUATION
;      cgPlot, residuals[1,*], residuals[2,*], psym=16, Symsize=.25, $
;          xTitle='residuals nongreen', yTitle='residuals bare', Ticklen=.5, xGridstyle=1, yGridstyle=1 , $
;          XTHICK=0.5, yTHICK=0.5, xRange=xRange, yRange=yRange
;        oplot_regress, residuals[1,*], residuals[2,*], /NAN, /NO_EQUATION
;     PS_End, resize=100, /PNG
;  endif  
;-------------------------------------------------------------------------------------------------------------------------
;  fname='Residuals_heterogeneity_'+output_string+'.ps.png'
;  if (FILE_INFO(fname)).exists eq 0 then begin
;    PS_Start, fname
;      color=['dark green','goldenrod','brown']
;      !P.Multi=[0,3,2]
;      cgDisplay, 1000, 600
;      for i=0,2 do begin
;        n=fix(Total(finite(SAM_40X40)))
;        xTitle='LOG10(SAM) (n='+STRTRIM(n, 2)+')'
;        yTitle='ABS(Residuals) (n='+STRTRIM(n, 2)+')'
;        cgPlot, ALOG10(SAM_40X40), ABS(residuals[i,*]), color=color[i], psym=16, Symsize=.25, $
;          xTitle=xTitle, yTitle=yTitle, Ticklen=.5, xGridstyle=1, yGridstyle=1 , XTHICK=0.5, yTHICK=0.5
;        oplot_regress, ALOG10(SAM_40X40), ABS(residuals[i,*]), /NAN, /NO_EQUATION
;        cgPlot, [-10,2],[0,0], /overplot
;      endfor          
;      for i=0,2 do begin
;        n=fix(Total(finite(ED_40X40)))
;        xTitle='LOG10(ED) (n='+STRTRIM(n, 2)+')'
;        yTitle='ABS(Residuals) (n='+STRTRIM(n, 2)+')'
;        cgPlot, ALOG10(ED_40X40), ABS(residuals[i,*]), color=color[i], psym=16, Symsize=.25, $
;          xTitle=xTitle, yTitle=yTitle, Ticklen=.5, xGridstyle=1, yGridstyle=1 , XTHICK=0.5, yTHICK=0.5
;        oplot_regress, ALOG10(ED_40X40), ABS(residuals[i,*]), /NAN, /NO_EQUATION
;        cgPlot, [-10,2],[0,0], /overplot
;      endfor          
;     PS_End, resize=100, /PNG
;  endif  
;-------------------------------------------------------------------------------------------------------------------------
;  fname='Residuals_soilColour_'+output_string+'.ps.png'
;  if (FILE_INFO(fname)).exists eq 0 then begin
;    PS_Start, fname
;      color=['dark green','goldenrod','brown']
;      !P.Multi=[0,3,3]
;      cgDisplay, 1000, 900
;      for i=0,2 do begin
;        n=fix(Total(finite(residuals[i,*])))
;        xTitle='Soil RED'
;        yTitle='residuals'
;        cgPlot, (Data.SoilColor.RED)[where_ok], residuals[i,*], color=color[i], psym=16, Symsize=.25, $
;          xTitle=xTitle, yTitle=yTitle, Ticklen=.5, xGridstyle=1, yGridstyle=1 , XTHICK=0.5, yTHICK=0.5
;        oplot_regress, (Data.SoilColor.RED)[where_ok], residuals[i,*], /NAN, /NO_EQUATION
;        cgPlot, [-1000,1000],[0,0], /overplot
;      endfor          
;      for i=0,2 do begin
;        n=fix(Total(finite(residuals[i,*])))
;        xTitle='Soil GREEN'
;        yTitle='residuals'
;        cgPlot, (Data.SoilColor.GREEN)[where_ok], residuals[i,*], color=color[i], psym=16, Symsize=.25, $
;          xTitle=xTitle, yTitle=yTitle, Ticklen=.5, xGridstyle=1, yGridstyle=1 , XTHICK=0.5, yTHICK=0.5
;        oplot_regress, (Data.SoilColor.GREEN)[where_ok], residuals[i,*], /NAN, /NO_EQUATION
;        cgPlot, [-1000,1000],[0,0], /overplot
;      endfor          
;      for i=0,2 do begin
;        n=fix(Total(finite(residuals[i,*])))
;        xTitle='Soil BLUE'
;        yTitle='residuals'
;        cgPlot, (Data.SoilColor.BLUE)[where_ok], residuals[i,*], color=color[i], psym=16, Symsize=.25, $
;          xTitle=xTitle, yTitle=yTitle, Ticklen=.5, xGridstyle=1, yGridstyle=1 , XTHICK=0.5, yTHICK=0.5
;        oplot_regress, (Data.SoilColor.BLUE)[where_ok], residuals[i,*], /NAN, /NO_EQUATION
;        cgPlot, [-1000,1000],[0,0], /overplot
;      endfor          
;     PS_End, resize=100, /PNG
;  endif  
;;-------------------------------------------------------------------------------------------------------------------------
;  fname='Residuals_timelag_'+output_string+'.ps.png'
;  if (FILE_INFO(fname)).exists eq 0 then begin
;    PS_Start, fname
;      color=['dark green','goldenrod','brown']
;      !P.Multi=[0,3,2]
;      cgDisplay, 1300, 600
;      for i=0,2 do begin
;        n=fix(Total(finite(retrievedCoverFractions[i,*])))
;        xTitle='timelag (n='+STRTRIM(n, 2)+')'
;        yTitle='Field (n='+STRTRIM(n, 2)+')'
;        yTitle='Residuals (n='+STRTRIM(n, 2)+')'
;        cgPlot, timelag, (residuals[i,*]), color=color[i], psym=16, Symsize=.25, $
;          xTitle=xTitle, yTitle=yTitle, Ticklen=.5, xGridstyle=1, yGridstyle=1 , XTHICK=0.5, yTHICK=0.5
;        oplot_regress, (timelag), (residuals[i,*]), /NAN, /NO_EQUATION
;        cgPlot, [-100,100],[0,0], /overplot
;      endfor    
;
;      for i=0,2 do begin
;        n=fix(Total(finite(retrievedCoverFractions[i,*])))
;        xTitle='timelag (n='+STRTRIM(n, 2)+')'
;        yTitle='Field (n='+STRTRIM(n, 2)+')'
;        yTitle='ABS(Residuals) (n='+STRTRIM(n, 2)+')'
;        cgPlot, timelag, ABS(residuals[i,*]), color=color[i], psym=16, Symsize=.25, $
;          xTitle=xTitle, yTitle=yTitle, Ticklen=.5, xGridstyle=1, yGridstyle=1 , XTHICK=0.5, yTHICK=0.5
;        oplot_regress, (timelag), ABS(residuals[i,*]), /NAN, /NO_EQUATION
;        cgPlot, [-100,100],[0,0], /overplot
;      endfor    
;    PS_End, resize=100, /PNG
;  endif  
;;-------------------------------------------------------------------------------------------------------------------------
;;  ; save a csv file with sites and residuals
;  fname='report_'+output_string+'.csv'
;  if (FILE_INFO(fname)).exists eq 0 then begin
;    OPENW, lun, fname, /get_lun
;      printF,lun, 'OBS_KEY,site,image,OBS_PV,OBS_NPV,OBS_BS,MOD_PV,MOD_NPV,MOD_BS,RES_PV,RES_NPV,RES_BS'
;              FORMAT='(4(A,:,","),1000(F9.5,:,","))'
;      for i=0, count-1 do $
;      printF, lun, $
;                obs_key[i], $
;                site[i], $                
;                image_name[i], $
;                siteDataArray[0,i], $
;                siteDataArray[1,i], $
;                siteDataArray[2,i], $
;                retrievedCoverFractions[0,i], $
;                retrievedCoverFractions[1,i], $
;                retrievedCoverFractions[2,i], $
;                residuals[0,i], $
;                residuals[1,i], $
;                residuals[2,i], $
;                format=format
;    CLOSE, LUN
;  endif  
;;-------------------------------------------------------------------------------------------------------------------------
;  fname='ErrorVsWeight_'+output_string+'.ps.png'
;  if (FILE_INFO(fname)).exists eq 0 then begin
;    ; Select best Sum to One weighting
;    ; use the bare RMS Error
;    lower_bound=0.0
;    upper_bound=1.0
;    PVRMSError=[]
;    NPVRMSError=[]
;    BareRMSError=[]
;    for i=0, 19 do begin
;      sum2oneWeight=i/100.0
;      retrievedCoverFractions = Transpose(unmix_3_fractions_bvls(satelliteReflectanceTransformed, endmembersWeighted, $
;        lower_bound=lower_bound, upper_bound=upper_bound, sum2oneWeight=sum2oneWeight))
;      PVRMSError=[PVRMSError,sqrt(mean((transpose(retrievedCoverFractions[0,*]) - siteDataArray[0,*])^2))]  
;      NPVRMSError=[NPVRMSError,sqrt(mean((transpose(retrievedCoverFractions[1,*]) - siteDataArray[1,*])^2))]  
;      BareRMSError=[BareRMSError,sqrt(mean((transpose(retrievedCoverFractions[2,*]) - siteDataArray[2,*])^2))]  
;    endfor  
;
;    PS_Start, fname
;      cgPlot, indgen(20)/100.0, PVRMSError, color='dark green', Thick=2, Ticklen=.5, xGridstyle=1, yGridstyle=1, $
;        xTitle='Sum to one weight', yTitle='RMS Error', yRange=[Min([PVRMSError,NPVRMSError,BareRMSError]), max([PVRMSError,NPVRMSError,BareRMSError])] 
;      cgPlot, indgen(20)/100.0, NPVRMSError, color='goldenrod',  Thick=2, /overplot
;      cgPlot, indgen(20)/100.0, BareRMSError, color='brown',  Thick=2, /overplot
;    PS_End, resize=100, /PNG
;  endif  
;;-------------------------------------------------------------------------------------------------------------------------
;;  Check for inconsistencies in the PV to NPV fractions
;;  Note: Probably need to correct back from the groundcover rather then the satellite cover
;;  Note the outlier in the plot below - ot's these outliers where there is major error in 
;;  the PV mirrored by a corresponding opposite error in the NPV
;;  The basic premise is that I change the worst site a little, then try again...
;;  All in one - 130 iterations seems to do it
;  
;  fname='inconsistenciesPV_NPV_'+output_string+'.ps.png'
;  if (FILE_INFO(fname)).exists eq 0 then begin
;    print, 'running PV/NPV fixing ', fname
;    siteDataArrayEstimate=siteDataArray_invert
;    greenRMSerror=[]
;    nongreenRMSerror=[]
;    bareRMSerror=[]
;    meanRMSerror=[]
;    for xxx=0, 399 do begin
;      endmembersWeighted = svd_matrix_invert(svd_matrix_invert(Weights_array*satelliteReflectanceTransformed, rcond=rcond) ## $
;        (Weights_array*siteDataArrayEstimate))
;      
;      retrievedCoverFractions_PV_NPV = Transpose(unmix_3_fractions_bvls(satelliteReflectanceTransformed, endmembersWeighted, $
;        lower_bound=lower_bound, upper_bound=upper_bound, sum2oneWeight=sum2oneWeight))
;               
;      absError = siteDataArrayEstimate - retrievedCoverFractions_PV_NPV
;      rmsError=[]
;      for i=0,2 do $
;        rmsError=[rmsError,sqrt(mean((retrievedCoverFractions_PV_NPV[i,*] - siteDataArrayEstimate[i,*])^2))]
;        rmsErrorAll=mean(rmsError)
;      greenRMSerror = [greenRMSerror, rmsError[0]]
;      nongreenRMSerror = [nongreenRMSerror, rmsError[1]]
;      bareRMSerror = [bareRMSerror, rmsError[2]]
;      meanRMSerror = [meanRMSerror,rmsErrorAll]
;      
;      pvNpvError=abs(absError[0,*]-absError[1,*])
;      adjustSite = where(pvNpvError eq max(pvNpvError), count_argmax)
;      if count_argmax gt 1 then adjustSite=adjustSite[0]
;;      print, adjustSite
;;      print, absError[*, adjustSite]
;      
;      if absError[0, adjustSite] gt absError[1, adjustSite] then begin
;        siteDataArrayEstimate[0,adjustSite]=siteDataArrayEstimate[0,adjustSite] * 0.9
;        siteDataArrayEstimate[1,adjustSite]=1-(siteDataArrayEstimate[0,adjustSite]+siteDataArrayEstimate[2,adjustSite])
;      EndIf Else Begin
;        siteDataArrayEstimate[1,adjustSite]=siteDataArrayEstimate[1,adjustSite] * 0.9
;        siteDataArrayEstimate[0,adjustSite]=1-(siteDataArrayEstimate[1,adjustSite]+siteDataArrayEstimate[2,adjustSite])
;      Endelse  
;;      print, siteDataArrayEstimate[*, adjustSite]
;      
;    endfor   
;  
;    PS_Start, fname
;      yrange = [min([greenRMSerror, nongreenRMSerror, bareRMSerror]), max([greenRMSerror, nongreenRMSerror, bareRMSerror])]
;      cgplot,  meanRMSerror, yrange=yrange, xtitle='iteration', yTitle='RMSE', thick=2
;      cgplot, greenRMSerror, color='green', /overplot, thick=2
;      cgplot, nongreenRMSerror, color='goldenrod', /overplot, thick=2
;      cgplot, bareRMSerror, color='brown', /overplot, thick=2
;    PS_End, resize=100, /png  
;  fname='inconsistenciesPV_NPV_ObservedPredictedFractions_'+output_string+'.ps.png'
;    PS_Start, fname
;      color=['dark green','goldenrod','brown']
;      title=['GREEN','nonGREEN','BARE']
;      !P.Multi=[0,3,2]
;      cgDisplay, 1000, 600
;      for i=0,2 do begin
;        xTitle='predicted'
;        yTitle='Field - before fixing'
;        cgPlot, retrievedCoverFractions[i,*], siteDataArray[i,*], color=color[i], psym=16, Symsize=.25, $
;          xTitle=xTitle, yTitle=yTitle, Ticklen=.5, xGridstyle=1, yGridstyle=1, Title=Title[i], $
;          xRange=[-0.05, 1.05], yRange=[-0.05, 1.05], xStyle=1, yStyle=1, XTHICK=0.5, yTHICK=0.5 
;        oplot_regress, retrievedCoverFractions[i,*], siteDataArray[i,*], /NAN, /NO_EQUATION
;        cgPlot, [-1,2],[-1,2], /overplot
;        al_legend_stats, retrievedCoverFractions[i,*], siteDataArray[i,*], box=0, charsize=0.6
;      endfor   
;      for i=0,2 do begin
;        xTitle='predicted'
;        yTitle='Field - after fixing'
;        cgPlot, retrievedCoverFractions_PV_NPV[i,*], siteDataArrayEstimate[i,*], color=color[i], psym=16, Symsize=.25, $
;          xTitle=xTitle, yTitle=yTitle, Ticklen=.5, xGridstyle=1, yGridstyle=1, Title=Title[i], $
;          xRange=[-0.05, 1.05], yRange=[-0.05, 1.05], xStyle=1, yStyle=1, XTHICK=0.5, yTHICK=0.5 
;        oplot_regress, retrievedCoverFractions_PV_NPV[i,*], siteDataArrayEstimate[i,*], /NAN, /NO_EQUATION
;        cgPlot, [-1,2],[-1,2], /overplot
;        al_legend_stats, retrievedCoverFractions_PV_NPV[i,*], siteDataArrayEstimate[i,*], box=0, charsize=0.6
;      endfor   
;     PS_End, resize=100, /PNG
;  endif   
 
 
;-------------------------------------------------------------------------------------------------------------------------
;Start Splitting Endmembers
;We want to find another endmember - it seems 4 is as good as you can get without resorting to endmember selection methods
;The goal here is to find which of the PV, NPV and Banre endmembers do better by splitting
;Order the satellite reflectances by Brightness, NDVI etc.
;
;Split by Bare Endmember based on NDVI Ordering
;This seems a little weird, but I hope to solve the wet ground=NPV vegetation
 
;  for split_n = 0,2 do begin
;    
;    case split_n of
;      0: split_name='ndvi'
;      1: split_name='brightness'
;      2: split_name='SWIRbrightness'
;    endCase
;
;    fname = 'split_by_'+split_name+'_'+output_string+'.ps.png'
;    if (FILE_INFO(fname)).exists eq 0 AND Keyword_Set(split) then begin
;      
;      totalPVCoverEstimate = reform(SiteDataArray[0,*]) * 1.0
;      totalNPVCoverEstimate =reform(SiteDataArray[1,*]) * 1.0
;      totalBARECoverEstimate =reform(SiteDataArray[2,*]) * 1.0
;      
;      if split_name eq 'ndvi' AND (sensor eq 'MCD43A4' OR sensor EQ 'MOD09A1') then $
;        satINDEX = reform((satelliteReflectanceTransformed[1,*]-satelliteReflectanceTransformed[0,*]) / $
;                          (satelliteReflectanceTransformed[1,*]+satelliteReflectanceTransformed[0,*]))  
;      if split_name eq 'ndvi' AND (sensor eq 'Landsat_3x3' OR sensor EQ 'Landsat_40x40') then $
;        satINDEX = reform((satelliteReflectanceTransformed[3,*]-satelliteReflectanceTransformed[2,*]) / $
;                          (satelliteReflectanceTransformed[3,*]+satelliteReflectanceTransformed[2,*]))  
;      if split_name eq 'brightness' AND (sensor eq 'MCD43A4' OR sensor EQ 'MOD09A1') then $
;        satINDEX = reform(Total(satelliteReflectanceTransformed[0:6,*], 1))
;
;      if split_name eq 'brightness' AND (sensor eq 'Landsat_3x3' OR sensor EQ 'Landsat_40x40') then $
;        satINDEX = reform(MEAN(satelliteReflectanceTransformed[0:5,*], dimension=1))
;       
;      if split_name eq 'SWIRbrightness' AND (sensor eq 'MCD43A4' OR sensor EQ 'MOD09A1') then $
;        satINDEX = reform(mean(satelliteReflectanceTransformed[5:6,*], dimension=1))
;
;      if split_name eq 'SWIRbrightness' AND (sensor eq 'Landsat_3x3' OR sensor EQ 'Landsat_40x40') then $
;        satINDEX = reform(mean(satelliteReflectanceTransformed[4:5,*], dimension=1))
;      
;      NDVIOrder=SORT(satINDEX)
;      trialRMSerrorPV=[]
;      bestRMSPV=10
;      trialRMSerrorNPV=[]
;      bestRMSNPV=10
;      trialRMSerrorBARE=[]
;      bestRMSBARE=10
;      
;      step = 10
;      for NDVISplitPoint=0, n_elements(SiteDataArray[0,*])-1, step do begin
;        totalPVDarkCover=reform(SiteDataArray[0,*])*1.0
;        totalPVDarkCover[NDVIOrder[NDVISplitPoint+1:*]]=0
;        totalPVLightCover=reform(SiteDataArray[0,*])*1.0
;        totalPVLightCover[NDVIOrder[0:NDVISplitPoint]]=0
;  
;        totalNPVDarkCover=reform(SiteDataArray[1,*])*1.0
;        totalNPVDarkCover[NDVIOrder[NDVISplitPoint+1:*]]=0
;        totalNPVLightCover=reform(SiteDataArray[1,*])*1.0
;        totalNPVLightCover[NDVIOrder[0:NDVISplitPoint]]=0
;  
;        totalBareDarkCover=reform(SiteDataArray[2,*])*1.0
;        totalBareDarkCover[NDVIOrder[NDVISplitPoint+1:*]]=0
;        totalBareLightCover=reform(SiteDataArray[2,*])*1.0
;        totalBareLightCover[NDVIOrder[0:NDVISplitPoint]]=0
;        
;  
;        array4endm = Transpose([[totalPVDarkCover],[totalPVLightCover],[totalNPVCoverEstimate],[totalBARECoverEstimate]])
;        endmembersWeighted = svd_matrix_invert(svd_matrix_invert(Weights_array*satelliteReflectanceTransformed, rcond=rcond) ## $
;            (Weights_array*array4endm))
;        unmix4Endmembers = Transpose(unmix_3_fractions_bvls(satelliteReflectanceTransformed, endmembersWeighted, $
;          lower_bound=lower_bound, upper_bound=upper_bound, sum2oneWeight=sum2oneWeight))
;        retrievedCoverFractions=[unmix4Endmembers[0,*]+unmix4Endmembers[1,*],unmix4Endmembers[2,*],unmix4Endmembers[3,*]]
;        rmsErrorPV=sqrt(mean((retrievedCoverFractions - siteDataArray)^2))
;        trialRMSerrorPV=[trialRMSerrorPV, rmsErrorPV]
;      
;        if rmsErrorPV lt bestRMSPV then begin
;          ;print, NDVISplitPoint, rmsErrorPV
;          bestRMSPV = rmsErrorPV
;          bestRMSpositionPV = NDVISplitPoint
;        endif  
;  
;        array4endm = Transpose([[totalPVCoverEstimate],[totalNPVDarkCover],[totalNPVLightCover],[totalBARECoverEstimate]])
;        endmembersWeighted = svd_matrix_invert(svd_matrix_invert(Weights_array*satelliteReflectanceTransformed, rcond=rcond) ## $
;            (Weights_array*array4endm))
;        unmix4Endmembers = Transpose(unmix_3_fractions_bvls(satelliteReflectanceTransformed, endmembersWeighted, $
;          lower_bound=lower_bound, upper_bound=upper_bound, sum2oneWeight=sum2oneWeight))
;        retrievedCoverFractions=[unmix4Endmembers[0,*],unmix4Endmembers[1,*]+unmix4Endmembers[2,*],unmix4Endmembers[3,*]]
;        rmsErrorNPV=sqrt(mean((retrievedCoverFractions - siteDataArray)^2))
;        trialRMSerrorNPV=[trialRMSerrorNPV, rmsErrorNPV]
;      
;        if rmsErrorNPV lt bestRMSNPV then begin
;          ;print, NDVISplitPoint, rmsErrorNPV
;          bestRMSNPV = rmsErrorNPV
;          bestRMSpositionNPV = NDVISplitPoint
;        endif  
;  
;        array4endm = Transpose([[totalPVCoverEstimate],[totalNPVCoverEstimate],[totalBareDarkCover],[totalBareLightCover]])
;        endmembersWeighted = svd_matrix_invert(svd_matrix_invert(Weights_array*satelliteReflectanceTransformed, rcond=rcond) ## $
;            (Weights_array*array4endm))
;        unmix4Endmembers = Transpose(unmix_3_fractions_bvls(satelliteReflectanceTransformed, endmembersWeighted, $
;          lower_bound=lower_bound, upper_bound=upper_bound, sum2oneWeight=sum2oneWeight))
;        retrievedCoverFractions=[unmix4Endmembers[0,*],unmix4Endmembers[1,*],unmix4Endmembers[2,*]+unmix4Endmembers[3,*]]
;        rmsErrorBARE=sqrt(mean((retrievedCoverFractions - siteDataArray)^2))
;        trialRMSerrorBARE=[trialRMSerrorBARE, rmsErrorBARE]
;      
;        if rmsErrorBARE lt bestRMSBARE then begin
;          ;print, NDVISplitPoint, rmsErrorBARE
;          bestRMSBARE = rmsErrorBARE
;          bestRMSpositionBARE = NDVISplitPoint
;        endif  
;        
;      endfor  
;      
;      PS_Start, fname 
;        cgDisplay, 900, 600
;        !P.Multi=[0,3,2]
;        yrange=[min([trialRMSerrorPV,trialRMSerrorNPV,trialRMSerrorBARE]),max([trialRMSerrorPV,trialRMSerrorNPV,trialRMSerrorBARE])]
;        cgPlot, indgen(n_elements(trialRMSerrorPV))*step, trialRMSerrorPV, $
;          yrange=yRange, xTitle=split+' SplitPosition | min= '+STRtrim(bestRMSpositionPV, 2), $
;          yTitle='Mean RMS Error', color='Dark Green', thick=2
;        cgPlot, indgen(n_elements(trialRMSerrorNPV))*step, trialRMSerrorNPV, $
;          yrange=yRange, xTitle=split+' SplitPosition | min= '+STRtrim(bestRMSpositionNPV, 2), $
;          yTitle='Mean RMS Error', color='Goldenrod', thick=2 
;        cgPlot, indgen(n_elements(trialRMSerrorBARE))*step, trialRMSerrorBARE, $
;          yrange=yRange, xTitle=split+' SplitPosition | min= '+STRtrim(bestRMSpositionBARE, 2), $
;          yTitle='Mean RMS Error', color='Brown', thick=2 
;
;        cgPlot, satINDEX[NDVIOrder[indgen(n_elements(trialRMSerrorPV))*step]], trialRMSerrorPV, $
;          yrange=yRange, xTitle=split,  $
;          yTitle='Mean RMS Error', color='Dark Green', thick=2
;        cgPlot, satINDEX[NDVIOrder[indgen(n_elements(trialRMSerrorNPV))*step]], trialRMSerrorNPV, $
;          yrange=yRange, xTitle=split,  $
;          yTitle='Mean RMS Error', color='Goldenrod', thick=2 
;        cgPlot, satINDEX[NDVIOrder[indgen(n_elements(trialRMSerrorBARE))*step]], trialRMSerrorBARE, $
;          yrange=yRange, xTitle=split,  $
;          yTitle='Mean RMS Error', color='Brown', thick=2 
;      PS_End, resize=100, /PNG
;    EndIf 
;  Endfor 
   
;  ;write report to file
;  fname = 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\SAGE\results_sage_Experiments.csv'
;  if (FILE_INFO(fname)).exists eq 1 then begin ; only do if file exists
;    OPENU,lun, fname, /GET_LUN, /APPEND
;    PrintF, lun, report
;    Print, report
;    close, lun
;  endIf
end




pro analyse_SLATS_same_SAGE_sensitivity, data=data
  if Keyword_Set(data) eq 0 then $
    Data = read_SLATS_data_new()

  sensor=['MCD43A4', 'Landsat_3x3', 'MOD09A1', 'Landsat_40x40', 'MCD43A4_6B', 'MOD09A1_6B', 'Landsat_QLD']
;  sensor=['Landsat_QLD']
  weight=-1
  subset_data=[1,0]
  crossvalidation=0
  UseOverstorey=[0]
  noAbares=0
  
  for s=0, n_elements(sensor)-1 do $
    for w=0, n_elements(weight)-1 do $
      for sd=0, n_elements(subset_data)-1 do $
        for uo=0, n_elements(UseOverstorey)-1 do $
          for na=0, n_elements(noAbares)-1 do $
            analyse_SLATS_same_SAGE_plots_sensitivity, data=data, weight=weight[w], sensor=sensor[s], $
              subset_data=subset_data[sd], crossvalidation=crossvalidation, UseOverstorey=UseOverstorey[uo], $
              noAbares=noAbares[na]

  ;exit 

end
