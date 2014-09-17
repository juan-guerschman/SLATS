pro extract_SLATS_MCD43A4
  
  ; first open SLATS spreadsheet, need lat, lon and dates from there
  ;Field_data = sat_fpar_anal_get_FC_field_data(N_MODELS=1)
;  fname = '\\wron\Working\work\Juan_Pablo\PV_NPV_BS\New_Validation\fractional_landsat_subsets\out_b3_3pixSorted.csv'
  fname = '\\wron\working\work\Juan_Pablo\PV_NPV_BS\New_Validation\field_data\merged\fractional_all.csv'
  Field_data = READ_ASCII_FILE(fname, /SURPRESS_MSG)
  
  ; open existing data extraction file.  
  fname = '\\wron\working\work\Juan_Pablo\PV_NPV_BS\New_Validation\GC_MCD43A4_Landsat_2013_04_29.csv'
  Existing= READ_ASCII_FILE(fname, /SURPRESS_MSG)
  
  
  
  ; outputs to be written in fname
  fname = '\\wron\working\work\Juan_Pablo\PV_NPV_BS\New_Validation\GC_MCD43A4_Landsat_2013_04_29_RAW.csv'
  OPENW, lun, fname, /GET_LUN
  PRINTF, lun, 'obs_key,site_name,latitude,longitude,year,month,day,B1,B2,B3,B4,B5,B6,B7,stdev3x3_B1,stdev3x3_B2,stdev3x3_B3,stdev3x3_B4,stdev3x3_B5,stdev3x3_B6,stdev3x3_B7,

  n = n_elements(Field_data.obs_key)

  ; sort data per julian date. That way it won't try and read same file several times 
  JULDATE = JULDAY(Field_data.MONTH, Field_data.DAY, Field_data.YEAR)
  SORT_JULDATE = SORT(JULDATE)
  
  line_print = strarr(n)
  
  for xx = 0, n-1 do begin
    site = SORT_JULDATE[xx]
;  for site = 0, 1 do begin
    obs_key = (Field_data.obs_key)[site]
    site_name = (Field_data.site)[site]
    lat = (Field_data.latitude)[site]
    lon = (Field_data.longitude)[site]
    ;DATE = STRSPLIT((Field_data.obs_time)[site], '/', /Extract)
    DAY = (Field_data.day)[site]
    MONTH = (Field_data.month)[site]
    YEAR = (Field_data.year)[site]
    JULDATE = JULDAY(MONTH, DAY, YEAR)
    
    ; this will get the previous composite to be used as backup 
    ; JULDATE -= 8 
    ; 
    
    CALDAT, JULDATE, MONTH_obs, DAY_obs, YEAR_obs
    DOY = JULDATE - JULDAY(1, 1, YEAR_obs) + 1
    
    
    composite = DOY / 8
    JULDATE_composite = JULDAY(1, 1, YEAR_obs) + composite * 8 
    CALDAT, JULDATE_composite, MONTH, DAY, YEAR
    
    pixVal = fltarr(7)
    stdevVal = fltarr(7)
    
    for band=1, 7 do begin
      ; first check if data exists in a previously saved file
      if band eq 1 then data = (Existing.B1)[site]
      if band eq 2 then data = (Existing.B2)[site]
      if band eq 3 then data = (Existing.B3)[site]
      if band eq 4 then data = (Existing.B4)[site]
      if band eq 5 then data = (Existing.B5)[site]
      if band eq 6 then data = (Existing.B6)[site]
      if band eq 7 then data = (Existing.B7)[site]
;      data = 0 
      
      if finite(data) eq 0 then begin       ; if data eq NaN means that the previous time extraction didnt work
        
        url= MCD43A4_Thredds_name(band, day, month, year)
        
        ; get MODIS values 3x3 window
        ; if date is earlier than 2000 don't even try (return an empty string)
        if year ge 2000 then $  
          array_str = get_data_from_thredds_3x3(url, lat, lon) $
        Else $
          array_str = strarr(3,3)
         
        ; Convert Array to long Integers
        array = float(array_str)
        
        ; check if values returned were all blanks. If so, change to NaN 
        IF total(array_str eq strarr(3,3)) eq 9 then $
          array[*] = !VALUES.F_NAN
        
        ;pixVal is the center pixel of the 3x3 array returned
        pixVal[band-1] = array[1,1]   
  
        ;stdevVal is standard deviation of 3x3 array returned
        ; convert -32768 into NaNs to ignore in StDev calculations. first array converted to float
        ; array = float(array)
        where_nodata = where(array lt -32000, count)
        IF count ge 1 then array[where_nodata] = !VALUES.F_NAN
        stdevVal[band-1] = STDDEV(array, /nan)
        
      endif else begin              ; here if data already exists 
        pixVal[band-1] = DATA  
        if band eq 1 then stdevVal[band-1] = (Existing.STDEV3x3_B1)[site]
        if band eq 2 then stdevVal[band-1] = (Existing.STDEV3x3_B2)[site]
        if band eq 3 then stdevVal[band-1] = (Existing.STDEV3x3_B3)[site]
        if band eq 4 then stdevVal[band-1] = (Existing.STDEV3x3_B4)[site]
        if band eq 5 then stdevVal[band-1] = (Existing.STDEV3x3_B5)[site]
        if band eq 6 then stdevVal[band-1] = (Existing.STDEV3x3_B6)[site]
        if band eq 7 then stdevVal[band-1] = (Existing.STDEV3x3_B7)[site]
      endelse  
    endfor
    
    FORMATLON   = '(10(I8, :, ", "))'  
    FORMATFLOAT = '(10(f8.1, :, ", "))'  
    line_print[site] = STRCOMPRESS( $
                        STRING(obs_key) + ',' + $
                        STRING(site_name) + ',' + $
                        STRING(lat) + ',' + $
                        STRING(lon) + ',' + $
                        STRING(year) + ',' + $
                        STRING(month) + ',' + $
                        STRING(day) + ',' + $
                        STRING(pixVal, format=FORMATFLOAT) + ',' + $
                        STRING(stdevVal, format=FORMATFLOAT),    $
                        /REMOVE_ALL)                  
           
     PRINTF, lun, line_print[site]              
     PRINT ,      line_print[site]              
    
  endfor
   
  ; PRINT OUTPUT IN SORTED ORDER  
  fname = '\\wron\working\work\Juan_Pablo\PV_NPV_BS\New_Validation\GC_MCD43A4_Landsat_2013_04_29.csv'
  OPENW, lun2, fname, /GET_LUN
  PRINTF, lun2, 'obs_key,site_name,latitude,longitude,year,month,day,B1,B2,B3,B4,B5,B6,B7,stdev3x3_B1,stdev3x3_B2,stdev3x3_B3,stdev3x3_B4,stdev3x3_B5,stdev3x3_B6,stdev3x3_B7,
  for yy = 0, n-1 do $
    PRINTF, lun2, line_print[yy]   
      
   
  close, /ALL
  
end

