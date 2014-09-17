pro extract_SLATS_BILO, data=data
  
;  ; first open SLATS spreadsheet, need lat, lon and dates from there
;  fname = '\\wron\Working\work\Juan_Pablo\PV_NPV_BS\New_Validation\fractional_landsat_subsets\out_b3_3pixSorted.csv'
;  LANDSAT_Qld = READ_ASCII_FILE(fname, /SURPRESS_MSG)

  ; LOAD SLATS DATA 
  if Keyword_Set(data) eq 0 then $
    Data = read_SLATS_data_new()
  
;  Field_data = sat_fpar_anal_get_FC_field_data(N_MODELS=1)
  Field_data = Data.Field_all
  
  ; outputs to be written in fname
  fname = '\\wron\working\work\Juan_Pablo\PV_NPV_BS\New_Validation\GC_BAWAP_rain_MAY2013.csv'
  OPENW, lun, fname, /GET_LUN
  header = 'Obs_Key,site,latitude,longitude,' + $
           'YEAR_OBS,MONTH_OBS,DAY_OBS,' + $
           ;'YEAR_Landsat,MONTH_Landsat,DAY_Landsat,' + $
           'ObsMinus1,ObsMinus2,ObsMinus3,ObsMinus4,ObsMinus5,ObsMinus6,ObsMinus7' ;+ $
           ;'LandsatMinus1,LandsatMinus2,LandsatMinus3,LandsatMinus4,LandsatMinus5,LandsatMinus6,LandsatMinus7'  
  PRINTF, lun, header
  
  
  for site = 0, n_elements(Field_data.obs_key)-1 do begin
;  for site = 0, 1 do begin
;    OBJECTID = (Field_data.OBJECTID)[site]
;    site_name = (Field_data.site_name)[site]
;    lat = (Field_data.latitude)[site]
;    lon = (Field_data.longitude)[site]
;    JULDATE = (Field_data.JULDATE)[site]
    OBJECTID = (Field_data.obs_key)[site]
    site_name = (Field_data.site)[site]
    lat = (Field_data.latitude)[site]
    lon = (Field_data.longitude)[site]
    ;DATE_OBS = STRSPLIT((Field_data.obs_time)[site], '/', /Extract) ; this is the date of the observation 
        DAY_OBS = (Field_data.DAY)[site]   
        MONTH_OBS = (Field_data.MONTH)[site]   
        YEAR_OBS = (Field_data.YEAR)[site]   
        JULDATE_OBS = JULDAY(MONTH_OBS, DAY_OBS, YEAR_OBS)
        ;DOY_OBS = JULDATE_OBS - JULDAY(1, 1, YEAR_OBS) + 1

;    DATE_Landsat = STRSPLIT((Field_data.image)[site], '_', /Extract) ; this is the date of the Landsat image
;        YEAR_Landsat = STRMID(DATE_Landsat[2], 0, 4) * 1
;        MONTH_Landsat = STRMID(DATE_Landsat[2], 4, 2) * 1
;        DAY_Landsat = STRMID(DATE_Landsat[2], 6, 2) * 1
;        JULDATE_Landsat = JULDAY(MONTH_Landsat, DAY_Landsat, YEAR_Landsat)
;        DOY_Landsat = JULDATE_Landsat - JULDAY(1, 1, YEAR_Landsat) + 1
         
        pixVal_obs = fltarr(7)
;        pixVal_Landsat = fltarr(7)
        
        rainfall_all = fltarr(7)
        for i=0, 6 do begin
          CALDAT, JULDATE_OBS - i, MONTH_i, DAY_i, YEAR_i
          rainfall_all[i] = READ_BILO_Rain(day_i, MONTH_i, YEAR_i, lat, lon)
          if rainfall_all[i] lt 0 then rainfall_all[i]=!VALUES.F_NAN
          ;pixVal is the center pixel of the 3x3 array returned
          rain_acum = Total(rainfall_all)   ; this is the accumulated rainfall to that day 
          pixVal_obs[i] = rain_acum
        endfor

;        for i=0, 6 do begin
;          CALDAT, JULDATE_Landsat - i, MONTH_i, DAY_i, YEAR_i
;          rainfall = READ_BILO_Rain(DAY_i, MONTH_i, YEAR_i, lat, lon)
;          ;pixVal is the center pixel of the 3x3 array returned
;          pixVal_Landsat[i] = rainfall
;        endfor
     
    FORMATLON   = '(10(I8, :, ", "))'  
    FORMATFLOAT = '(10(f8.1, :, ", "))'  
    line_print = STRCOMPRESS( $
                  STRING(OBJECTID) + ',' + $
                  STRING(site_name) + ',' + $
                  STRING(lat) + ',' + $
                  STRING(lon) + ',' + $
                  STRING(YEAR_OBS) + ',' + $
                  STRING(month_OBS) + ',' + $
                  STRING(day_obs) + ',' + $
;                  STRING(YEAR_Landsat) + ',' + $
;                  STRING(month_Landsat) + ',' + $
;                  STRING(day_Landsat) + ',' + $
                  STRING(pixVal_Obs, format=FORMATFLOAT) + ',' , $
;                  STRING(pixVal_Landsat, format=FORMATFLOAT) , $
                  /REMOVE_ALL)                  
     
     PRINTF, lun, line_print              
     PRINT ,      line_print              
    
  endfor
   
  close, lun
  
end

