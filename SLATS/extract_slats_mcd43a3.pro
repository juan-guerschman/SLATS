pro extract_SLATS_MCD43A3
  
  ; first open SLATS spreadsheet, need lat, lon and dates from there
  ;Field_data = sat_fpar_anal_get_FC_field_data(N_MODELS=1)
;  fname = '\\wron\Working\work\Juan_Pablo\PV_NPV_BS\New_Validation\fractional_landsat_subsets\out_b3_3pixSorted.csv'
  fname = '\\wron\working\work\Juan_Pablo\PV_NPV_BS\New_Validation\field_data\merged\fractional_all.csv'
  Field_data = READ_ASCII_FILE(fname, /SURPRESS_MSG)
  
  ; open existing data extraction file.  
  fname = '\\wron\working\work\Juan_Pablo\PV_NPV_BS\New_Validation\GC_MCD43A3_Landsat_2014_08_18.csv'
  Existing= READ_ASCII_FILE(fname, /SURPRESS_MSG)
  
;        1: file = '500m_0620_0670nm_albedo_black'
;        2: file = '500m_0841_0876nm_albedo_black'
;        3: file = '500m_0459_0479nm_albedo_black'
;        4: file = '500m_0545_0565nm_albedo_black'
;        5: file = '500m_1230_1250nm_albedo_black'
;        6: file = '500m_1628_1652nm_albedo_black'
;        7: file = '500m_2105_2155nm_albedo_black' 
;        8: file = '500m_0300_0700nm_albedo_black'
;        9: file = '500m_0700_5000nm_albedo_black'
;       10: file = '500m_0300_5000nm_albedo_black'
;       11: file = '500m_0620_0670nm_albedo_white'
;       12: file = '500m_0841_0876nm_albedo_white'
;       13: file = '500m_0459_0479nm_albedo_white'
;       14: file = '500m_0545_0565nm_albedo_white'
;       15: file = '500m_1230_1250nm_albedo_white'
;       16: file = '500m_1628_1652nm_albedo_white'
;       17: file = '500m_2105_2155nm_albedo_white'
;       18: file = '500m_0300_0700nm_albedo_white'
;       19: file = '500m_0700_5000nm_albedo_white'
;       20: file = '500m_0300_5000nm_albedo_white'
  
  
  ; outputs to be written in fname
  fname = '\\wron\working\work\Juan_Pablo\PV_NPV_BS\New_Validation\GC_MCD43A3_Landsat_2014_08_18_RAW.csv'
  OPENW, lun, fname, /GET_LUN
  PRINTF, lun, 'obs_key,site_name,latitude,longitude,year,month,day,' + $
                '500m_0620_0670nm_albedo_black' + ', ' + $
                '500m_0841_0876nm_albedo_black' + ', ' + $
                '500m_0459_0479nm_albedo_black' + ', ' + $
                '500m_0545_0565nm_albedo_black' + ', ' + $
                '500m_1230_1250nm_albedo_black' + ', ' + $
                '500m_1628_1652nm_albedo_black' + ', ' + $
                '500m_2105_2155nm_albedo_black' + ', ' + $
                '500m_0300_0700nm_albedo_black' + ', ' + $
                '500m_0700_5000nm_albedo_black' + ', ' + $
                '500m_0300_5000nm_albedo_black' + ', ' + $
                '500m_0620_0670nm_albedo_white' + ', ' + $
                '500m_0841_0876nm_albedo_white' + ', ' + $
                '500m_0459_0479nm_albedo_white' + ', ' + $
                '500m_0545_0565nm_albedo_white' + ', ' + $
                '500m_1230_1250nm_albedo_white' + ', ' + $
                '500m_1628_1652nm_albedo_white' + ', ' + $
                '500m_2105_2155nm_albedo_white' + ', ' + $
                '500m_0300_0700nm_albedo_white' + ', ' + $
                '500m_0700_5000nm_albedo_white' + ', ' + $
                '500m_0300_5000nm_albedo_white' 

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
    
    pixVal = fltarr(20)
;     stdevVal = fltarr(7)
    
    for band=1, 20 do begin
      ; first check if data exists in a previously saved file
      if band eq 1 then data = (Existing._500m_0620_0670nm_albedo_black)[site]
      if band eq 2 then data = (Existing._500m_0841_0876nm_albedo_black)[site]
      if band eq 3 then data = (Existing._500m_0459_0479nm_albedo_black)[site]
      if band eq 4 then data = (Existing._500m_0545_0565nm_albedo_black)[site]
      if band eq 5 then data = (Existing._500m_1230_1250nm_albedo_black)[site]
      if band eq 6 then data = (Existing._500m_1628_1652nm_albedo_black)[site]
      if band eq 7 then data = (Existing._500m_2105_2155nm_albedo_black)[site]
      if band eq 8 then data = (Existing._500m_0300_0700nm_albedo_black)[site]
      if band eq 9 then data = (Existing._500m_0700_5000nm_albedo_black)[site]
      if band eq 10 then data = (Existing._500m_0300_5000nm_albedo_black)[site]
      if band eq 11 then data = (Existing._500m_0620_0670nm_albedo_white)[site]
      if band eq 12 then data = (Existing._500m_0841_0876nm_albedo_white)[site]
      if band eq 13 then data = (Existing._500m_0459_0479nm_albedo_white)[site]
      if band eq 14 then data = (Existing._500m_0545_0565nm_albedo_white)[site]
      if band eq 15 then data = (Existing._500m_1230_1250nm_albedo_white)[site]
      if band eq 16 then data = (Existing._500m_1628_1652nm_albedo_white)[site]
      if band eq 17 then data = (Existing._500m_2105_2155nm_albedo_white)[site]
      if band eq 18 then data = (Existing._500m_0300_0700nm_albedo_white)[site]
      if band eq 19 then data = (Existing._500m_0700_5000nm_albedo_white)[site]
      if band eq 20 then data = (Existing._500m_0300_5000nm_albedo_white)[site]
      ;data = !Values.f_NAN
      
      if finite(data) eq 0 then begin       ; if data eq NaN means that the previous time extraction didnt work
        
        url= MCD43A3_Thredds_name(band, day, month, year)
        
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
;        where_nodata = where(array lt -32000, count)
;        IF count ge 1 then array[where_nodata] = !VALUES.F_NAN
;        stdevVal[band-1] = STDDEV(array, /nan)
        
      endif else begin              ; here if data already exists
        print, 'data already exists'
        pixVal[band-1] = DATA  
;        if band eq 1 then stdevVal[band-1] = (Existing.STDEV3x3_B1)[site]
;        if band eq 2 then stdevVal[band-1] = (Existing.STDEV3x3_B2)[site]
;        if band eq 3 then stdevVal[band-1] = (Existing.STDEV3x3_B3)[site]
;        if band eq 4 then stdevVal[band-1] = (Existing.STDEV3x3_B4)[site]
;        if band eq 5 then stdevVal[band-1] = (Existing.STDEV3x3_B5)[site]
;        if band eq 6 then stdevVal[band-1] = (Existing.STDEV3x3_B6)[site]
;        if band eq 7 then stdevVal[band-1] = (Existing.STDEV3x3_B7)[site]
      endelse  
    endfor
    
    FORMATLON   = '(10(I8, :, ", "))'  
    FORMATFLOAT = '(20(f8.1, :, ", "))'  
    line_print[site] = STRCOMPRESS( $
                        STRING(obs_key) + ',' + $
                        STRING(site_name) + ',' + $
                        STRING(lat) + ',' + $
                        STRING(lon) + ',' + $
                        STRING(year) + ',' + $
                        STRING(month) + ',' + $
                        STRING(day) + ',' + $
                        STRING(pixVal, format=FORMATFLOAT),  $
;                        STRING(stdevVal, format=FORMATFLOAT),    $
                        /REMOVE_ALL)                  
           
     PRINTF, lun, line_print[site]              
     PRINT ,      line_print[site]              
    
  endfor
   
  ; PRINT OUTPUT IN SORTED ORDER  
  fname = '\\wron\working\work\Juan_Pablo\PV_NPV_BS\New_Validation\GC_MCD43A3_Landsat_2014_08_18.csv'
  OPENW, lun2, fname, /GET_LUN
  PRINTF, lun2, 'obs_key,site_name,latitude,longitude,year,month,day,' + $
                '500m_0620_0670nm_albedo_black' + ', ' + $
                '500m_0841_0876nm_albedo_black' + ', ' + $
                '500m_0459_0479nm_albedo_black' + ', ' + $
                '500m_0545_0565nm_albedo_black' + ', ' + $
                '500m_1230_1250nm_albedo_black' + ', ' + $
                '500m_1628_1652nm_albedo_black' + ', ' + $
                '500m_2105_2155nm_albedo_black' + ', ' + $
                '500m_0300_0700nm_albedo_black' + ', ' + $
                '500m_0700_5000nm_albedo_black' + ', ' + $
                '500m_0300_5000nm_albedo_black' + ', ' + $
                '500m_0620_0670nm_albedo_white' + ', ' + $
                '500m_0841_0876nm_albedo_white' + ', ' + $
                '500m_0459_0479nm_albedo_white' + ', ' + $
                '500m_0545_0565nm_albedo_white' + ', ' + $
                '500m_1230_1250nm_albedo_white' + ', ' + $
                '500m_1628_1652nm_albedo_white' + ', ' + $
                '500m_2105_2155nm_albedo_white' + ', ' + $
                '500m_0300_0700nm_albedo_white' + ', ' + $
                '500m_0700_5000nm_albedo_white' + ', ' + $
                '500m_0300_5000nm_albedo_white' 
  for yy = 0, n-1 do $
    PRINTF, lun2, line_print[yy]   
      
   
  close, /ALL
  
end

