;this function returns where all Landsat, MCD43A4 and MOD09A1 have ok values
function where_ALL_data_ok, DATA
  total_ne_1 = where(data.FCOVER.exp_tot lt 0.95 or data.FCOVER.exp_tot gt 1.05, count)
  exp_tot = data.FCOVER.exp_tot
  if count ge 1 then exp_tot[total_ne_1]=!values.F_nan
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
;              [data.Landsat_QLD.B1],         $
;              [data.Landsat_QLD.B2],         $
;              [data.Landsat_QLD.B3],         $
;              [data.Landsat_QLD.B4],         $
;              [data.Landsat_QLD.B5],         $
;              [data.Landsat_QLD.B6],         $
              [exp_tot],         $   ;ADD THIS TO MAKE SURE NaN ARE DELETED
              [data.Landsat_scaling.SAM_40x40]] 
   negs = where(big_array lt 0, count)           
   if count ge 1 then big_array[negs] = !VALUES.F_NAN     
   total_finite = Total(Finite(big_array), 2)
   where_ok = Where(total_finite eq (SIZE(big_array))[2])
   return, where_ok
end


; will try and copy what Peter does in his SAGE worksheet

pro analyse_SLATS_same_SAGE_plots, $
  data=data, weight=weight, sensor=sensor, split=split, subset_data=subset_data, crossvalidation=crossvalidation, $
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
  
  folder = 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\SAGE\plots\'
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
  if sensor eq 'Landsat_9x9' then $
    satelliteReflectance= [[data.Landsat_scaling.B1_9x9], $
                          [data.Landsat_scaling.B2_9x9], $ 
                          [data.Landsat_scaling.B3_9x9], $ 
                          [data.Landsat_scaling.B4_9x9], $ 
                          [data.Landsat_scaling.B5_9x9], $ 
                          [data.Landsat_scaling.B6_9x9]]
  if sensor eq 'Landsat_17x17' then $
    satelliteReflectance= [[data.Landsat_scaling.B1_17x17], $
                          [data.Landsat_scaling.B2_17x17], $ 
                          [data.Landsat_scaling.B3_17x17], $ 
                          [data.Landsat_scaling.B4_17x17], $ 
                          [data.Landsat_scaling.B5_17x17], $ 
                          [data.Landsat_scaling.B6_17x17]]
  if sensor eq 'Landsat_25x25' then $
    satelliteReflectance= [[data.Landsat_scaling.B1_25x25], $
                          [data.Landsat_scaling.B2_25x25], $ 
                          [data.Landsat_scaling.B3_25x25], $ 
                          [data.Landsat_scaling.B4_25x25], $ 
                          [data.Landsat_scaling.B5_25x25], $ 
                          [data.Landsat_scaling.B6_25x25]]
  if sensor eq 'Landsat_33x33' then $
    satelliteReflectance= [[data.Landsat_scaling.B1_33x33], $
                          [data.Landsat_scaling.B2_33x33], $ 
                          [data.Landsat_scaling.B3_33x33], $ 
                          [data.Landsat_scaling.B4_33x33], $ 
                          [data.Landsat_scaling.B5_33x33], $ 
                          [data.Landsat_scaling.B6_33x33]]
  if sensor eq 'Landsat_40x40' then $
    satelliteReflectance= [[data.Landsat_scaling.B1_40x40], $
                          [data.Landsat_scaling.B2_40x40], $ 
                          [data.Landsat_scaling.B3_40x40], $ 
                          [data.Landsat_scaling.B4_40x40], $ 
                          [data.Landsat_scaling.B5_40x40], $ 
                          [data.Landsat_scaling.B6_40x40]]
  if sensor eq 'Landsat_42x42' then $
    satelliteReflectance= [[data.Landsat_scaling.B1_42x42], $
                          [data.Landsat_scaling.B2_42x42], $ 
                          [data.Landsat_scaling.B3_42x42], $ 
                          [data.Landsat_scaling.B4_42x42], $ 
                          [data.Landsat_scaling.B5_42x42], $ 
                          [data.Landsat_scaling.B6_42x42]]
  if sensor eq 'Landsat_QLD' then $
    satelliteReflectance= [[data.Landsat_QLD.B1], $
                          [data.Landsat_QLD.B2], $ 
                          [data.Landsat_QLD.B3], $ 
                          [data.Landsat_QLD.B4], $ 
                          [data.Landsat_QLD.B5], $ 
                          [data.Landsat_QLD.B6]]
   ;help, satelliteReflectance

   Landsat_Wavelenghts = [485, 560, 660, 830, 1650, 2215]
   MODIS_Wavelenghts = [(459 + 479)/2., $
     (545 + 565)/2., $
     (620 + 670)/2., $
     (841 + 876)/2., $
     (1230 + 1250)/2., $
     (1628 + 1652)/2., $
     (2105 + 2155)/2.]

;  Recover Satellite PV, NPV and Bare;  
;  Now need to work out the fractions as seen by the satellite!;  
;  The requires a bit of correction since we are observing from the midstorey;  
;  Note the requirement to convert back to counts and then account for occlusion and probabilities of interception in the various layers
  ; JUAN: this is already done by the read_SLATS_data() function and returned as the Fcover_Qld structure   
;  Does the total add up to 100% (give or take some crypto)

  fname = 'SumOfFractions.ps'
  if (FILE_INFO(fname)).exists eq 0 then begin
    PS_Start, fname
      !P.Multi = [0,2,1]
      cgDisplay, 1000, 400
      cgPlot, (data.FCOVER_QLD.totalpvcover + data.FCOVER_QLD.totalnpvcover + data.FCOVER_QLD.totalbarecover)$
        [sort(data.FCOVER_QLD.totalpvcover + data.FCOVER_QLD.totalnpvcover + data.FCOVER_QLD.totalbarecover)], psym=16, $
        xTitle='Site#', yTitle='Sum of fractions (no crypto)', Ticklen=1, xGridstyle=1, yGridstyle=1
      cgPlot, (data.FCOVER_QLD.totalpvcover + data.FCOVER_QLD.totalnpvcover + data.FCOVER_QLD.totalbarecover + data.FCOVER_QLD.satGroundCryptoCover)$
        [sort(data.FCOVER_QLD.totalpvcover + data.FCOVER_QLD.totalnpvcover + data.FCOVER_QLD.totalbarecover + data.FCOVER_QLD.satGroundCryptoCover)], psym=16, $
        xTitle='Site#', yTitle='Sum of fractions (with crypto)', Ticklen=1, xGridstyle=1, yGridstyle=1
    PS_End;, resize=100, /PNG
  EndIf
  
;  Plot the relative Proportions of the viewable cover types  
;  JUAN: make 3 plots instead of one. 
    
  fname = 'RelativeProportions.ps'
  if (FILE_INFO(fname)).exists eq 0 then begin
    PS_Start, fname
      !P.Multi = [0,2,2]
      cgDisplay, 1000, 1000
       cgHistoplot, data.FCOVER_QLD.totalpvcover, polycolor='lime green', title='PV', /fillpolygon 
       cgHistoplot, data.FCOVER_QLD.totalnpvcover, polycolor='red', title='NPV', /fillpolygon
       cgHistoplot, data.FCOVER_QLD.totalbarecover, polycolor='blue', title='bare', /fillpolygon
       cgHistoplot, data.FCOVER_QLD.satGroundCryptoCover, polycolor='tomato', title='crypto', /fillpolygon
    PS_End;, resize=100, /PNG
  EndIf

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
     sensor eq 'Landsat_9x9' or $
     sensor eq 'Landsat_17x17' or $
     sensor eq 'Landsat_25x25' or $
     sensor eq 'Landsat_33x33' or $
     sensor eq 'Landsat_40x40' or $
     sensor eq 'Landsat_42x42' or $
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
  ED_17X17_ = data.landsat_scaling.ED_17x17 
  ED_40X40_ = data.landsat_scaling.ED_40x40 
  ;fix couple of cases where ED was large for the wrong reasons
  ED_17x17_[where(ED_17x17_ ge 0.2)]= !VALUES.F_NAN 
  ED_40X40_[where(ED_40X40_ ge 0.2)]= !VALUES.F_NAN 
  SAM_40X40_[where(ED_40X40_ ge 0.2)]= !VALUES.F_NAN 

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
    folder = 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\SAGE\plots\subset_data\NEW_20130729\'
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
  ED_17x17=fltarr(count)
  ED_40X40=fltarr(count)
  weights_new=fltarr(count)
  obs_key = STRARR(count)
  image_name = STRARR(count)
  site = STRARR(count)
  latitude= fltarr(count)
  longitude= fltarr(count)
  year= intarr(count)
  month= intarr(count)
  day= intarr(count)
  timelag = intarr(count)
  Soil_RED = fltarr(count)
  Soil_GREEN = fltarr(count)
  Soil_BLUE = fltarr(count)
  Wsat_4days = fltarr(count)
  ASCAT012345 = fltarr(count)
  Wsat_4days_ = (Data.Wsat.WsatMinus0+Data.Wsat.WsatMinus1+Data.Wsat.WsatMinus2+Data.Wsat.WsatMinus3)/4
  ASCAT012345_ = Data.ASCAT.Ascat012345
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
    for i=0, count-1 do siteDataArray_invert[0,i]=data.FCOVER_QLD.totalPVcover[where_ok[i]]  ; + data.FCOVER_QLD.satGroundCryptoCover[where_ok[i]]
    for i=0, count-1 do siteDataArray_invert[1,i]=data.FCOVER_QLD.totalNPVcover[where_ok[i]]  ; + data.FCOVER_QLD.satGroundCryptoCover[where_ok[i]]    
    for i=0, count-1 do siteDataArray_invert[2,i]=data.FCOVER_QLD.totalBAREcover[where_ok[i]] ; + data.FCOVER_QLD.satGroundCryptoCover[where_ok[i]]
    siteDataArray=siteDataArray_invert
  EndElse  
  

  for i=0, count-1 do SAM_40X40[i] = (SAM_40x40_)[where_ok[i]] 
  for i=0, count-1 do ED_17x17[i] = (ED_17x17_)[where_ok[i]] 
  for i=0, count-1 do ED_40X40[i] = (ED_40x40_)[where_ok[i]] 
  for i=0, count-1 do weights_new[i] = (weights)[where_ok[i]]
  weights = weights_new
  for i=0, count-1 do obs_key[i] = (data.field_all.obs_key)[where_ok[i]]
  for i=0, count-1 do image_name[i] = (data.landsat_scaling.image_name)[where_ok[i]]
  for i=0, count-1 do site[i] = (data.field_all.site)[where_ok[i]]
  for i=0, count-1 do latitude[i] = (data.field_all.latitude)[where_ok[i]]
  for i=0, count-1 do longitude[i] = (data.field_all.longitude)[where_ok[i]]
  for i=0, count-1 do year[i] = (data.field_all.year)[where_ok[i]]
  for i=0, count-1 do month[i] = (data.field_all.month)[where_ok[i]]
  for i=0, count-1 do day[i] = (data.field_all.day)[where_ok[i]]
  for i=0, count-1 do timelag[i] = (data.landsat_scaling.timelag)[where_ok[i]]
  for i=0, count-1 do SOIL_RED[i] = (Data.SoilColor.RED)[where_ok[i]]
  for i=0, count-1 do SOIL_GREEN[i] = (Data.SoilColor.GREEN)[where_ok[i]]
  for i=0, count-1 do SOIL_BLUE[i] = (Data.SoilColor.BLUE)[where_ok[i]]
  for i=0, count-1 do Wsat_4days[i] = Wsat_4days_[where_ok[i]]
  for i=0, count-1 do ASCAT012345[i] = ASCAT012345_[where_ok[i]]

  where_more50pcBare = Where(siteDataArray[2,*] ge 0.5)
   
;-------------------------------------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------------------------------------
  fname = 'WeightEQ_'+StrTrim(weight_factor,2)+'.png'
  if (FILE_INFO(fname)).exists eq 0 then begin
    PS_Start, fname
      !P.Multi=[0,2,3]
      cgDisplay, 800, 1000
      cgPlot, ED_40X40, Weights, psym=16, Ticklen=1, xGridstyle=1, yGridstyle=1, $
        xTitle='Spectral Angle 40x40', yTitle='weights'
      cgPlot, ALOG10(ED_40X40), Weights, psym=16, Ticklen=1, xGridstyle=1, yGridstyle=1, $
        xTitle='LOG of Spectral Angle 40x40', yTitle='weights'
      cgHistoplot, ED_40X40, xTitle='Euclidean Distance 40x40'
      cgHistoplot, ALOG10(ED_40X40), xTitle='Log of Euclidean Distance 40x40'
      if weight_factor ne 0 then cgHistoplot, Weights, xTitle='Weights'      
    PS_End, resize=100, /PNG
  EndIf
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
  fname = 'SingularValues_'+output_string+'.png'
  if (FILE_INFO(fname)).exists eq 0 then begin
    PS_Start, fname
      cgPlot, alog(toleranceSVs), psym=16, Ticklen=1, xGridstyle=1, yGridstyle=1
    PS_End, resize=100, /PNG
  EndIf
      
  
;  Perform 50:50 cross validation - we are looking for a local minimum to select the optimal subspace to perform the inversion/unmixing
  sum2oneWeight=0.02
  lower_bound=-0.0 
  upper_bound=1.0 
  crossvalidationAmount=2
  bareRMSerror=[]
  numberSites=n_elements(satelliteReflectanceTransformed[0,*])  
 
; ALL THE CODE BELOW IS COMMENTED. WAS RUN ONCE IN POWERAPP AND THE OUTPUT SAVED. IT WAS SLOW TO RUN EVERY TIME
  fname = 'MeanRMSerror_'+output_string+'.png'
  out_name = 'MeanRMSerror_'+output_string+'.csv'
  print, output_string
  if (FILE_INFO(out_name)).exists eq 0 AND Keyword_set(crossvalidation) then begin
  for i=0, N_ELEMENTS(toleranceSVs)-1 do begin
    print, 'i ', i
    bareRMSerrorArray=[]
;    for loop =0, 99 do begin
    for loop =0, 99 do begin
       
      shuffleIndex = sort(randomU(systime(1), numberSites))
      calibrationSites=shuffleIndex[0:numberSites/crossvalidationAmount]
      validationSites=shuffleIndex[numberSites/crossvalidationAmount+1:*]      
      
      endmembersWeighted = svd_matrix_invert(svd_matrix_invert( $
         Weights_array[*, calibrationSites]*satelliteReflectanceTransformed[*, calibrationSites], rcond=toleranceSVs[i]) $
         ## (Weights_array[*, calibrationSites]*siteDataArray_invert[*, calibrationSites]))
      
      retrievedCoverFractions = unmix_3_fractions_bvls(satelliteReflectanceTransformed[*, validationSites], endmembersWeighted, $
          lower_bound=lower_bound, upper_bound=upper_bound, sum2oneWeight=sum2oneWeight)

      IF Keyword_Set(UseOverstorey) then Begin   ; reconstruct the 3 fractions by adding up the two greens
        retrievedCoverFractions[*,0] = retrievedCoverFractions[*,0]+retrievedCoverFractions[*,3]
        retrievedCoverFractions=retrievedCoverFractions[*,0:2]
      EndIf  
       
      rmsError=sqrt(mean((transpose(retrievedCoverFractions) - siteDataArray[*, validationSites])^2))
      bareRMSerrorArray=[bareRMSerrorArray,rmsError]      
       
    endfor
    
    bareRMSerror=[bareRMSerror,mean(bareRMSerrorArray)]
    
  endfor
     
  out_name = 'MeanRMSerror_'+output_string+'.csv'
  openW, lun,   out_name, /get_lun
  printF, lun, 'MeanRMSerror'
  for i=0, N_ELEMENTS(toleranceSVs)-1 do $
    printF, lun, bareRMSerror[i];, FORMAT='(1000(F9.5,:,","))'
  close, lun
  whereMinbareRMSerror = where(bareRMSerror eq min(bareRMSerror))
  ;print, whereMinbareRMSerror
    PS_Start, fname
      cgDisplay, 400, 400
      cgPlot, bareRMSerror, xTitle='weight / min= '+string(whereMinbareRMSerror), $
        yTitle='Mean RMS Error / Min='+string(min(bareRMSerror)), $
        Ticklen=1, xGridstyle=1, yGridstyle=1, THICK=3, /addcmd
      cgPlot, [whereMinbareRMSerror,whereMinbareRMSerror],[whereMinbareRMSerror,0], color='red', /overplot, /addcmd
      cgPlot, [0,n_elements(bareRMSerror)],[min(bareRMSerror),min(bareRMSerror)],color='red', /overplot      , /addcmd
      
    PS_End, resize=100, /PNG
  EndIf
;-------------------------------------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------------------------------------


;-------------------------------------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------------------------------------
; GIVE OUR "OPTIMAL" ENDMEMBERS A WHIRL

  ; the conditions below come from performing the cross validation for each sensor and then 
  ; selecting where the RMSE is the lowest. 
  if sensor eq 'MCD43A4' then rcond=toleranceSVs[23] 
  if sensor eq 'MOD09A1' then rcond=toleranceSVs[27] 
  if sensor eq 'Landsat_3x3' then rcond=toleranceSVs[23] 
  if sensor eq 'Landsat_9x9' then rcond=toleranceSVs[21] 
  if sensor eq 'Landsat_17x17' then rcond=toleranceSVs[21] 
  if sensor eq 'Landsat_25x25' then rcond=toleranceSVs[21] 
  if sensor eq 'Landsat_33x33' then rcond=toleranceSVs[22] 
  if sensor eq 'Landsat_40x40' then rcond=toleranceSVs[20] 
  if sensor eq 'Landsat_42x42' then rcond=toleranceSVs[20] 
  if sensor eq 'Landsat_QLD' then rcond=toleranceSVs[23] 
  if sensor eq 'MCD43A4_6B' then rcond=toleranceSVs[22] 
  if sensor eq 'MOD09A1_6B' then rcond=toleranceSVs[22]     ;check if OK!! 
   
   sum2oneWeight=0.02
   lower_bound=-0.0 
   upper_bound=1.0 
   
  endmembersWeighted = svd_matrix_invert(svd_matrix_invert(Weights_array*satelliteReflectanceTransformed, rcond=rcond) ## $
    (Weights_array*siteDataArray_invert))
  fname='TransformedReflectance_'+output_string+'.SAV'
  if (FILE_INFO(fname)).exists eq 0 then begin
    ;print, 'saving endmembersWeighted in ', fname
    SAVE, endmembersWeighted, FILENAME=fname
  EndIf
  fname='TransformedReflectance_'+output_string+'.csv'
  if (FILE_INFO(fname)).exists eq 0 then begin
    openW, lun, fname, /get_lun
    PrintF, lun, 'EM, PV, NPV, BS'
    for i=0, (size(endmembersWeighted))[1]-1 do $
      PrintF, lun, i, reform(endmembersWeighted[i,*]), format='(4(f, :,","))'  
    close, lun
  EndIf

;  ; invert using only the 6(7) original bands
;  endmembersWeighted_orig = svd_matrix_invert(svd_matrix_invert(Weights_array[0:5,*]*satelliteReflectanceTransformed[0:5,*], rcond=rcond) ## $
;    (Weights_array[0:5,*]*siteDataArray_invert))
  
  ; now invert eq 1 dirctly (as per eq 9 in paper, in theory what shouldnt be done)
  if sensor eq 'Landsat_3x3' or $
    sensor eq 'Landsat_9x9' or $
    sensor eq 'Landsat_17x17' or $
    sensor eq 'Landsat_25x25' or $
    sensor eq 'Landsat_33x33' or $
    sensor eq 'Landsat_40x40' or $
    sensor eq 'Landsat_42x42' or $
    sensor eq 'MCD43A4_6B' or $
    sensor eq 'MOD09A1_6B' or $
    sensor eq 'Landsat_QLD' then  begin 
      M_eq9 = satelliteReflectanceTransformed[0:5,*] # pinv(siteDataArray_invert)
      wavelenghts=  Landsat_Wavelenghts
    endif  
  if sensor eq 'MCD43A4' or sensor eq 'MOD09A1' then begin
    ; all the shit below because I need to re-arrange the MODIS bands 
    M_eq9 = [satelliteReflectanceTransformed[2,*],satelliteReflectanceTransformed[3,*],satelliteReflectanceTransformed[0,*],satelliteReflectanceTransformed[1,*],satelliteReflectanceTransformed[4:6,*]] # pinv(siteDataArray_invert)
      wavelenghts=  MODIS_Wavelenghts
  endif    
  
  fname='endmembers_Eq9_'+output_string+'.png'
  if (FILE_INFO(fname)).exists eq 0 then begin
    cgPS_Open, fname
      cgDisplay, 600, 400
      cgPlot, wavelenghts, M_eq9[*,0], Ticklen=1, xGridstyle=1, yGridstyle=1, color='lime green', psym=-9, thick=2, $
        xTitle='wavelength [nm]', yTitle='Reflectance', yrange=[0,0.45], xrange=[450, 2300]
      cgPlot, wavelenghts, M_eq9[*,1], Ticklen=1, xGridstyle=1, yGridstyle=1, color='red', psym=-9, thick=2, /overplot
      cgPlot, wavelenghts, M_eq9[*,2], Ticklen=1, xGridstyle=1, yGridstyle=1, color='blue', psym=-9, thick=2, /overplot
    cgPS_Close, resize=100;, /PNG
  EndIf

  fname='endmembers_Eq9_'+output_string+'.csv'
  if (FILE_INFO(fname)).exists eq 0 then begin
    openW, lun, fname, /get_lun
    PrintF, lun, 'EM, PV, NPV, BS'
    for i=0, (size(M_eq9))[1]-1 do $
      PrintF, lun, i, reform(M_eq9[i,*]), format='(4(f, :,","))'
    close, lun
  EndIf
  

  fname='TransformedReflectance_'+output_string+'.png'
  if (FILE_INFO(fname)).exists eq 0 then begin
    cgPS_Open, fname
      cgPlot, endmembersWeighted[*,0], Ticklen=1, xGridstyle=1, yGridstyle=1, color='lime green', $
        xTitle='Band', yTitle='Transformed Reflectance'
      cgPlot, endmembersWeighted[*,1], Ticklen=1, xGridstyle=1, yGridstyle=1, color='red', /overplot
      cgPlot, endmembersWeighted[*,2], Ticklen=1, xGridstyle=1, yGridstyle=1, color='blue', /overplot
    cgPS_Close, resize=100, /PNG
  EndIf
   
  retrievedCoverFractions = Transpose(unmix_3_fractions_bvls(satelliteReflectanceTransformed, endmembersWeighted, $
      lower_bound=lower_bound, upper_bound=upper_bound, sum2oneWeight=sum2oneWeight))
       
  IF Keyword_Set(UseOverstorey) then Begin   ; reconstruct the 3 fractions by adding up the two greens
    retrievedCoverFractions_4Endm=retrievedCoverFractions   ; keep the 4 endmembers 
    retrievedCoverFractions[0,*] = retrievedCoverFractions[0,*]+retrievedCoverFractions[3,*]
    retrievedCoverFractions=retrievedCoverFractions[0:2,*]
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
  ;if (FILE_INFO(fname)).exists eq 0 then begin
    PS_Start, fname
      color=['lime green','red','blue']
      title=['PV','NPV','BS']
      title=[' ',' ',' ']
;      !P.Multi=[0,4,2]
      !P.Multi=[0,3,1]
      cgDisplay, 1000, 300
      for i=0,2 do begin
        xTitle='estimated'
        yTitle='observed'
        cgPlot, retrievedCoverFractions[i,*], siteDataArray[i,*], color=color[i], psym=16, Symsize=.25, $
          xTitle=xTitle, yTitle=yTitle, Title=Title[i], $ ; xGridstyle=1, yGridstyle=1, , XTHICK=0.5, yTHICK=0.5, Ticklen=.5, 
          xRange=[-0.025, 1.025], yRange=[-0.025, 1.025], xStyle=1, yStyle=1, charsize=1.8
        cgPlot, [-1,2],[-1,2], /overplot
        oplot_regress, retrievedCoverFractions[i,*], siteDataArray[i,*], color='black', LineStyle=1, Thick=0.5, /NAN, /NO_EQUATION
        al_legend_stats, retrievedCoverFractions[i,*], siteDataArray[i,*], box=0, charsize=0.85, correl=1, rmse=1, meanBias=1, $
            /top, /left, margin=0, pos=[-0.025,0.975]
      endfor   
;        cgHistoplot, total(retrievedCoverFractions, 1), xTitle='Sum of Retrieved Covers', yTitle='Number of Sites', $
;          Title='RMSE ALL='+string(rmsErrorAll)

;      for i=0,2 do begin
;        xTitle='Residuals)'
;        yTitle='Field'
;        cgPlot, retrievedCoverFractions[i,*], residuals[i,*], color=color[i], psym=16, Symsize=.25, $
;          xTitle=xTitle, yTitle=yTitle, Ticklen=.5, xGridstyle=1, yGridstyle=1 , XTHICK=0.5, yTHICK=0.5
;        oplot_regress, retrievedCoverFractions[i,*], residuals[i,*], /NAN, /NO_EQUATION
;        cgPlot, [-1,2],[0,0], /overplot
;        al_legend_stats, retrievedCoverFractions[i,*], residuals[i,*], /n, box=0, charsize=0.6
;      endfor    
     PS_End, resize=100, /PNG
  ;endif  

  IF Keyword_Set(UseOverstorey) then Begin   ; plot the 4 fractions
    fname='ObservedPredictedFractions_'+output_string+'4Endmembers.ps'
    if (FILE_INFO(fname)).exists eq 0 then begin
    rmsError = []
    for i=0,3 do $
      rmsError=[rmsError,sqrt(mean((transpose(retrievedCoverFractions_4Endm[i,*]) - siteDataArray_invert[i,*])^2))]
      rmsErrorAll=mean(rmsError)
    PS_Start, fname
      color=['lime green','red','blue','lime green']
      title=['understorey GREEN','nonGREEN','BARE','overstorey GREEN']
      !P.Multi=[0,4,1]
      cgDisplay, 1300, 300
      for i=0,3 do begin
        xTitle='predicted'
        yTitle='Field'
        cgPlot, retrievedCoverFractions_4Endm[i,*], siteDataArray_invert[i,*], color=color[i], psym=16, Symsize=.25, $
          xTitle=xTitle, yTitle=yTitle, Ticklen=.5, xGridstyle=1, yGridstyle=1, Title=title[i], $
          xRange=[-0.05, 1.05], yRange=[-0.05, 1.05], xStyle=1, yStyle=1, XTHICK=0.5, yTHICK=0.5 
        oplot_regress, retrievedCoverFractions_4Endm[i,*], siteDataArray_invert[i,*], /NAN, /NO_EQUATION
        cgPlot, [-1,2],[-1,2], /overplot
        al_legend_stats, retrievedCoverFractions_4Endm[i,*], siteDataArray_invert[i,*], box=0, charsize=0.6
      endfor   
      PS_End, resize=100, /PNG
    EndIf
  EndIf 
;-------------------------------------------------------------------------------------------------------------------------
  fname='Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\SAGE\results_sage_Experiments.csv'
  OPENU, lun, fname, /GET_LUN, /APPEND
  print, report
  printF, lun, report
  close, lun
   
;  goto, skip_writeresiduals
  ;analise residuals and write output 
  fname='ResidualsStats_'+output_string+'.csv' 
  OPENW, lun, fname, /GET_LUN
  header = 'variable,PV_r,NPV_r,BS_r,PV_p,NPV_p,BS_p,PV_intercep,NPV_intercep,BS_intercep,PV_slope,NPV_slope,BS_slope,PV_n,NPV_n,BS_n' 
  PrintF, lun, header

  x_axis = alog10(ED_17x17)
        r_all=[] & p_all=[] & i_all=[] & s_all=[] & n_all=[]
  for i=0,2 do begin
        regression_all = REGRESSION_STATISTICS_KPB(reform(x_axis), reform(ABS(residuals[i,*])), /nan)
        r_all=[r_all,regression_all.r]
        p_all=[p_all,regression_all.p_value]
        i_all=[i_all,regression_all.a]
        s_all=[s_all,regression_all.b]
        n_all=[n_all,regression_all.n]
   endfor     
   printF, lun, 'ALOG10(ED(l17X17)))',r_all,p_all,i_all,s_all,n_all, format='(100(A,:,","))'
  
  x_axis = (Data.SoilColor.RED + Data.SoilColor.GREEN + Data.SoilColor.BLUE)[where_ok]
        r_all=[] & p_all=[] & i_all=[] & s_all=[] & n_all=[]
        r_BSge50=[] & p_BSge50=[] & i_BSge50=[] & s_BSge50=[] & n_BSge50=[]
  for i=0,2 do begin
        regression_all = REGRESSION_STATISTICS_KPB(reform(x_axis), reform(residuals[i,*]), /nan)
        regression_BSge50 = REGRESSION_STATISTICS_KPB(reform(x_axis[where_more50pcBare]), reform(residuals[i,where_more50pcBare]), /nan)
        r_all=[r_all,regression_all.r]
        p_all=[p_all,regression_all.p_value]
        i_all=[i_all,regression_all.a]
        s_all=[s_all,regression_all.b]
        n_all=[n_all,regression_all.n]
        r_BSge50=[r_BSge50,regression_BSge50.r]
        p_BSge50=[p_BSge50,regression_BSge50.p_value]
        i_BSge50=[i_BSge50,regression_BSge50.a]
        s_BSge50=[s_BSge50,regression_BSge50.b]
        n_BSge50=[n_BSge50,regression_BSge50.n]
   endfor     
    printF, lun, 'soilBrightness_ALL',r_all,p_all,i_all,s_all,n_all, format='(100(A,:,","))'
    printF, lun, 'soilBrightness_BSge50',r_BSge50,p_BSge50,i_BSge50,s_BSge50,n_BSge50, format='(100(A,:,","))'
  
  x_axis = ASCAT012345
        r_all=[] & p_all=[] & i_all=[] & s_all=[] & n_all=[]
        r_BSge50=[] & p_BSge50=[] & i_BSge50=[] & s_BSge50=[] & n_BSge50=[]
  for i=0,2 do begin
        regression_all = REGRESSION_STATISTICS_KPB(reform(x_axis), reform(residuals[i,*]), /nan)
        regression_BSge50 = REGRESSION_STATISTICS_KPB(reform(x_axis[where_more50pcBare]), reform(residuals[i,where_more50pcBare]), /nan)
        r_all=[r_all,regression_all.r]
        p_all=[p_all,regression_all.p_value]
        i_all=[i_all,regression_all.a]
        s_all=[s_all,regression_all.b]
        n_all=[n_all,regression_all.n]
        r_BSge50=[r_BSge50,regression_BSge50.r]
        p_BSge50=[p_BSge50,regression_BSge50.p_value]
        i_BSge50=[i_BSge50,regression_BSge50.a]
        s_BSge50=[s_BSge50,regression_BSge50.b]
        n_BSge50=[n_BSge50,regression_BSge50.n]
   endfor     
    printF, lun, 'soilMoisture_ASCAT_ALL',r_all,p_all,i_all,s_all,n_all, format='(100(A,:,","))'
    printF, lun, 'soilMoisture_ASCAT_BSge50',r_BSge50,p_BSge50,i_BSge50,s_BSge50,n_BSge50, format='(100(A,:,","))'
  
  x_axis = Wsat_4days
        r_all=[] & p_all=[] & i_all=[] & s_all=[] & n_all=[]
        r_BSge50=[] & p_BSge50=[] & i_BSge50=[] & s_BSge50=[] & n_BSge50=[]
  for i=0,2 do begin
        regression_all = REGRESSION_STATISTICS_KPB(reform(x_axis), reform(residuals[i,*]), /nan)
        regression_BSge50 = REGRESSION_STATISTICS_KPB(reform(x_axis[where_more50pcBare]), reform(residuals[i,where_more50pcBare]), /nan)
        r_all=[r_all,regression_all.r]
        p_all=[p_all,regression_all.p_value]
        i_all=[i_all,regression_all.a]
        s_all=[s_all,regression_all.b]
        n_all=[n_all,regression_all.n]
        r_BSge50=[r_BSge50,regression_BSge50.r]
        p_BSge50=[p_BSge50,regression_BSge50.p_value]
        i_BSge50=[i_BSge50,regression_BSge50.a]
        s_BSge50=[s_BSge50,regression_BSge50.b]
        n_BSge50=[n_BSge50,regression_BSge50.n]
   endfor     
    printF, lun, 'soilMoisture_AWRA.Wsat_ALL',r_all,p_all,i_all,s_all,n_all, format='(100(A,:,","))'
    printF, lun, 'soilMoisture_AWRA.Wsat_BSge50',r_BSge50,p_BSge50,i_BSge50,s_BSge50,n_BSge50, format='(100(A,:,","))'

  x_axis = timelag
        r_all=[] & p_all=[] & i_all=[] & s_all=[] & n_all=[]
  for i=0,2 do begin
        regression_all = REGRESSION_STATISTICS_KPB(reform(x_axis), reform(residuals[i,*]), /nan)
        regression_BSge50 = REGRESSION_STATISTICS_KPB(reform(x_axis[where_more50pcBare]), reform(residuals[i,where_more50pcBare]), /nan)
        r_all=[r_all,regression_all.r]
        p_all=[p_all,regression_all.p_value]
        i_all=[i_all,regression_all.a]
        s_all=[s_all,regression_all.b]
        n_all=[n_all,regression_all.n]
   endfor     
    printF, lun, 'timelag',r_all,p_all,i_all,s_all,n_all, format='(100(A,:,","))'

  x_axis = (Data.SoilColor.RED + Data.SoilColor.GREEN + Data.SoilColor.BLUE)[where_ok]
        r_all=[] & p_all=[] & i_all=[] & s_all=[] & n_all=[]
  for i=0,2 do begin
        regression_all = REGRESSION_STATISTICS_KPB(reform(x_axis), reform(siteDataArray[i,*]), /nan)
        r_all=[r_all,regression_all.r]
        p_all=[p_all,regression_all.p_value]
        i_all=[i_all,regression_all.a]
        s_all=[s_all,regression_all.b]
        n_all=[n_all,regression_all.n]
   endfor     
    printF, lun, 'soilBrightness_vs_observed',r_all,p_all,i_all,s_all,n_all, format='(100(A,:,","))'

  x_axis = ASCAT012345
        r_all=[] & p_all=[] & i_all=[] & s_all=[] & n_all=[]
  for i=0,2 do begin
        regression_all = REGRESSION_STATISTICS_KPB(reform(x_axis), reform(siteDataArray[i,*]), /nan)
        r_all=[r_all,regression_all.r]
        p_all=[p_all,regression_all.p_value]
        i_all=[i_all,regression_all.a]
        s_all=[s_all,regression_all.b]
        n_all=[n_all,regression_all.n]
   endfor     
    printF, lun, 'ASCAT_vs_observed',r_all,p_all,i_all,s_all,n_all, format='(100(A,:,","))'

  x_axis = Wsat_4days
        r_all=[] & p_all=[] & i_all=[] & s_all=[] & n_all=[]
  for i=0,2 do begin
        regression_all = REGRESSION_STATISTICS_KPB(reform(x_axis), reform(residuals[i,*]), /nan)
        r_all=[r_all,regression_all.r]
        p_all=[p_all,regression_all.p_value]
        i_all=[i_all,regression_all.a]
        s_all=[s_all,regression_all.b]
        n_all=[n_all,regression_all.n]
   endfor     
    printF, lun, 'AWRA_vs_observed',r_all,p_all,i_all,s_all,n_all, format='(100(A,:,","))'
  skip_writeresiduals: print, '' 
;-------------------------------------------------------------------------------------------------------------------------
;***
  ;write output for observations
  fname='AllObs_'+output_string+'.csv' 
  if (FILE_INFO(fname)).exists eq 0 then begin
    OPENW, lun, fname, /GET_LUN
    header = 'OBS,SITE_NAME,LAT,LON,YEAR,MONTH,DAY,obs_PV,obs_NPV,obs_BS,'+sensor+'_PV,'+sensor+'_NPV,'+sensor+'_BS' 
    PrintF, lun, header
    for i=0, count-1 do $
    printf,lun, strcompress(string(i+1, site[i], latitude[i], longitude[i], year[i], month[i], day[i], siteDataArray[*,i], retrievedCoverFractions[*,i], $
            Format='(100(A,:,","))'), /Remove_All)
    close, lun
       
  endif

; now make plots  
;-------------------------------------------------------------------------------------------------------------------------
  fname='Residuals_ED17x17(ABS)_'+output_string+'.ps.png'
  if (FILE_INFO(fname)).exists eq 0 then begin
    PS_Start, fname
      color=['lime green','red','blue']
      !P.Multi=[0,3,1]
      cgDisplay, 1000, 300
        x_axis = alog10(ED_17x17)
      for i=0,2 do begin
        n=fix(Total(finite(residuals[i,*])))
        xTitle='Log$\down10$(ED)'
        yTitle='ABS(residuals)'
        cgPlot, x_axis, ABS(residuals[i,*]), color=color[i], psym=16, Symsize=.25, charsize=1.5, $
          xTitle=xTitle, yTitle=yTitle, Ticklen=.5, xGridstyle=1, yGridstyle=1 , XTHICK=0.5, yTHICK=0.5
            
        oplot_regress, x_axis, ABS(residuals[i,*]), color='black', /NAN, /NO_EQUATION
        cgPlot, [-1000,1000],[0,0], /overplot
      endfor          
    PS_End, resize=100, /PNG
  endif  
;-------------------------------------------------------------------------------------------------------------------------
  fname='Residuals_soilBrightness_'+output_string+'.ps.png'
  if (FILE_INFO(fname)).exists eq 0 then begin
    PS_Start, fname
      color=['lime green','red','blue']
      !P.Multi=[0,3,1]
      cgDisplay, 1000, 300
        x_axis = (Data.SoilColor.RED + Data.SoilColor.GREEN + Data.SoilColor.BLUE)[where_ok]
      for i=0,2 do begin
        n=fix(Total(finite(residuals[i,*])))
        xTitle='Soil Brightness'
        yTitle='residuals'
        cgPlot, x_axis, residuals[i,*], color=color[i], psym=16, Symsize=.25, charsize=1.5, yRange=[-.81,.81], yStyle=1, $
          xTitle=xTitle, yTitle=yTitle, Ticklen=.5, xGridstyle=1, yGridstyle=1 , XTHICK=0.5, yTHICK=0.5
        cgPlot, x_axis[where_more50pcBare], residuals[i,where_more50pcBare], color='black', psym=16, Symsize=.25, /overplot
           
        oplot_regress, x_axis, residuals[i,*], color='black', thick=2, /NAN, /NO_EQUATION
        oplot_regress, x_axis[where_more50pcBare], residuals[i,where_more50pcBare], color='BLACK', LineStyle=1, thick=2, /NAN, /NO_EQUATION
        ;cgPlot, [-1000,1000],[0,0], /overplot
      endfor          
    PS_End, resize=100, /PNG
  endif  
;-------------------------------------------------------------------------------------------------------------------------
  fname='Observed_soilBrightness_'+output_string+'.ps.png'
  if (FILE_INFO(fname)).exists eq 0 then begin
    PS_Start, fname
      color=['lime green','red','blue']
      !P.Multi=[0,3,1]
      cgDisplay, 1000, 300
        x_axis = (Data.SoilColor.RED + Data.SoilColor.GREEN + Data.SoilColor.BLUE)[where_ok]
      for i=0,2 do begin
        xTitle='Soil Brightness'
        yTitle='observed'
        cgPlot, x_axis, siteDataArray[i,*], color=color[i], psym=16, Symsize=.25, charsize=1.5, yRange=[-.01,1.01], yStyle=1, $
          xTitle=xTitle, yTitle=yTitle, Ticklen=.5, xGridstyle=1, yGridstyle=1 , XTHICK=0.5, yTHICK=0.5
        ;cgPlot, x_axis[where_more50pcBare], siteDataArray[i,where_more50pcBare], color='black', psym=16, Symsize=.25, /overplot
           
        oplot_regress, x_axis, siteDataArray[i,*], color='black', /NAN, /NO_EQUATION
        ;oplot_regress, x_axis[where_more50pcBare], siteDataArray[i,where_more50pcBare], color='BLACK', /NAN, /NO_EQUATION
        ;cgPlot, [-1000,1000],[0,0], /overplot
      endfor          
    PS_End, resize=100, /PNG
  endif  
;-------------------------------------------------------------------------------------------------------------------------
  fname='Residuals_soilBrightness(ABS)_'+output_string+'.ps.png'
  if (FILE_INFO(fname)).exists eq 0 then begin
    PS_Start, fname
      color=['lime green','red','blue']
      !P.Multi=[0,3,1]
      cgDisplay, 1000, 300
        x_axis = (Data.SoilColor.RED + Data.SoilColor.GREEN + Data.SoilColor.BLUE)[where_ok]
      for i=0,2 do begin
        n=fix(Total(finite(residuals[i,*])))
        xTitle='Soil Brightness'
        yTitle='residuals'
        cgPlot, x_axis, ABS(residuals[i,*]), color=color[i], psym=16, Symsize=.25, charsize=1.5, $
          xTitle=xTitle, yTitle=yTitle, Ticklen=.5, xGridstyle=1, yGridstyle=1 , XTHICK=0.5, yTHICK=0.5
        cgPlot, x_axis[where_more50pcBare], ABS(residuals[i,where_more50pcBare]), color='black', psym=16, Symsize=.25, /overplot
           
        oplot_regress, x_axis, ABS(residuals[i,*]), color='black', thick=2, /NAN, /NO_EQUATION
        oplot_regress, x_axis[where_more50pcBare], ABS(residuals[i,where_more50pcBare]), color='BLACK', LineStyle=1, thick=2, $
                       /NAN, /NO_EQUATION
        ;cgPlot, [-1000,1000],[0,0], /overplot
      endfor          
    PS_End, resize=100, /PNG
  endif  
  
;-------------------------------------------------------------------------------------------------------------------------
  fname='Residuals_soilMoisture_ASCAT_'+output_string+'.ps.png'
  if (FILE_INFO(fname)).exists eq 0 then begin
    PS_Start, fname
      color=['lime green','red','blue']
      !P.Multi=[0,3,1]
      cgDisplay, 1000, 300
        x_axis = ASCAT012345
      for i=0,2 do begin
        n=fix(Total(finite(residuals[i,*])))
        xTitle='Soil moisture (ASCAT)'
        yTitle='residuals'
        cgPlot, x_axis, residuals[i,*], color=color[i], psym=16, Symsize=.25, charsize=1.5, yRange=[-.8,.8], yStyle=1, $
          xTitle=xTitle, yTitle=yTitle, Ticklen=.5, xGridstyle=1, yGridstyle=1 , XTHICK=0.5, yTHICK=0.5
        cgPlot, x_axis[where_more50pcBare], residuals[i,where_more50pcBare], color='black', psym=16, Symsize=.25, /overplot
           
        oplot_regress, x_axis, residuals[i,*], color='black', /NAN, /NO_EQUATION
        oplot_regress, x_axis[where_more50pcBare], residuals[i,where_more50pcBare], color='BLACK', LineStyle=1, $
                       /NAN, /NO_EQUATION
        cgPlot, [-1000,1000],[0,0], /overplot
      endfor          
    PS_End, resize=100, /PNG
  endif  
;-------------------------------------------------------------------------------------------------------------------------
  fname='Observed_soilMoisture_ASCAT_'+output_string+'.ps.png'
  if (FILE_INFO(fname)).exists eq 0 then begin
    PS_Start, fname
      color=['lime green','red','blue']
      !P.Multi=[0,3,1]
      cgDisplay, 1000, 300
        x_axis = ASCAT012345
      for i=0,2 do begin
        xTitle='Soil moisture (ASCAT)'
        yTitle='observed'
        cgPlot, x_axis, siteDataArray[i,*], color=color[i], psym=16, Symsize=.25, charsize=1.5, yRange=[-.01,1.01], yStyle=1, $
          xTitle=xTitle, yTitle=yTitle, Ticklen=.5, xGridstyle=1, yGridstyle=1 , XTHICK=0.5, yTHICK=0.5
        ;cgPlot, x_axis[where_more50pcBare], residuals[i,where_more50pcBare], color='black', psym=16, Symsize=.25, /overplot
           
        oplot_regress, x_axis, siteDataArray[i,*], color='black', /NAN, /NO_EQUATION
        ;oplot_regress, x_axis[where_more50pcBare], residuals[i,where_more50pcBare], color='BLACK', /NAN, /NO_EQUATION
        ;cgPlot, [-1000,1000],[0,0], /overplot
      endfor          
    PS_End, resize=100, /PNG
  endif  
;-------------------------------------------------------------------------------------------------------------------------
  fname='Residuals_soilMoisture_AWRA.Wsat_'+output_string+'.ps.png'
  if (FILE_INFO(fname)).exists eq 0 then begin
    PS_Start, fname
      color=['lime green','red','blue']
      !P.Multi=[0,3,1]
      cgDisplay, 1000, 300
        x_axis = Wsat_4days
      for i=0,2 do begin
        xTitle='Soil moisture (AWRA-L)'
        yTitle='residuals'
        cgPlot, x_axis, residuals[i,*], color=color[i], psym=16, Symsize=.25, charsize=1.5, yRange=[-.8,.8], yStyle=1, $
          xTitle=xTitle, yTitle=yTitle, Ticklen=.5, xGridstyle=1, yGridstyle=1 , XTHICK=0.5, yTHICK=0.5
        cgPlot, x_axis[where_more50pcBare], residuals[i,where_more50pcBare], color='black', psym=16, Symsize=.25, /overplot
           
        oplot_regress, x_axis, residuals[i,*], color='black', /NAN, /NO_EQUATION
        oplot_regress, x_axis[where_more50pcBare], residuals[i,where_more50pcBare], color='BLACK', LineStyle=1, $
                       /NAN, /NO_EQUATION
        ;cgPlot, [-1000,1000],[0,0], /overplot
    endfor          
    PS_End, resize=100, /PNG
  endif  
;-------------------------------------------------------------------------------------------------------------------------
  fname='Observed_soilMoisture_AWRA.Wsat_'+output_string+'.ps.png'
  if (FILE_INFO(fname)).exists eq 0 then begin
    PS_Start, fname
      color=['lime green','red','blue']
      !P.Multi=[0,3,1]
      cgDisplay, 1000, 300
        x_axis = Wsat_4days
      for i=0,2 do begin
        xTitle='Soil moisture (AWRA-L)'
        yTitle='observed'
        cgPlot, x_axis, siteDataArray[i,*], color=color[i], psym=16, Symsize=.25, charsize=1.5, yRange=[-.01,1.01], yStyle=1, $
          xTitle=xTitle, yTitle=yTitle, Ticklen=.5, xGridstyle=1, yGridstyle=1 , XTHICK=0.5, yTHICK=0.5
        ;cgPlot, x_axis[where_more50pcBare], residuals[i,where_more50pcBare], color='black', psym=16, Symsize=.25, /overplot
           
        oplot_regress, x_axis, siteDataArray[i,*], color='black', /NAN, /NO_EQUATION
        ;oplot_regress, x_axis[where_more50pcBare], residuals[i,where_more50pcBare], color='BLACK', /NAN, /NO_EQUATION
        ;cgPlot, [-1000,1000],[0,0], /overplot
    endfor          
    PS_End, resize=100, /PNG
  endif  
;-------------------------------------------------------------------------------------------------------------------------
  fname='Residuals_timelag_'+output_string+'.ps.png'
  if (FILE_INFO(fname)).exists eq 0 then begin
    PS_Start, fname
      color=['lime green','red','blue']
      !P.Multi=[0,3,1]
      cgDisplay, 1000, 300
        x_axis = timelag
      for i=0,2 do begin
        n=fix(Total(finite(residuals[i,*])))
        xTitle='Timelag'
        yTitle='residuals'
        cgPlot, x_axis, residuals[i,*], color=color[i], psym=16, Symsize=.25, charsize=1.5, yRange=[-.8,.8], yStyle=1, $
          xTitle=xTitle, yTitle=yTitle, Ticklen=.5, xGridstyle=1, yGridstyle=1 , XTHICK=0.5, yTHICK=0.5
        ;cgPlot, x_axis[where_more50pcBare], residuals[i,where_more50pcBare], color='black', psym=16, Symsize=.25, /overplot
           
        oplot_regress, x_axis, residuals[i,*], color='black', /NAN, /NO_EQUATION
        ;oplot_regress, x_axis[where_more50pcBare], residuals[i,where_more50pcBare], color='BLACK', /NAN, /NO_EQUATION
        cgPlot, [-1000,1000],[0,0], /overplot
      endfor          
    PS_End, resize=100, /PNG
  endif  
;-------------------------------------------------------------------------------------------------------------------------
  close, /all  
  
end      
      
      
      


pro analyse_SLATS_same_SAGE_new, data=data
  if Keyword_Set(data) eq 0 then $
    Data = read_SLATS_data_new()

  sensor=['Landsat_3x3', 'Landsat_17x17', $ 
          'MCD43A4', 'MOD09A1'];, $
;          'Landsat_9x9','Landsat_25x25','Landsat_33x33','Landsat_42x42']
;  sensor=['Landsat_QLD']
  weight=-1
  subset_data=[1]
  crossvalidation=0
  UseOverstorey=[0]
  noAbares=0
  
  for s=0, n_elements(sensor)-1 do $
    for w=0, n_elements(weight)-1 do $
      for sd=0, n_elements(subset_data)-1 do $
        for uo=0, n_elements(UseOverstorey)-1 do $
          for na=0, n_elements(noAbares)-1 do $
            analyse_SLATS_same_SAGE_plots, data=data, weight=weight[w], sensor=sensor[s], $
              subset_data=subset_data[sd], crossvalidation=crossvalidation, UseOverstorey=UseOverstorey[uo], $
              noAbares=noAbares[na]

  ;exit 

end
      