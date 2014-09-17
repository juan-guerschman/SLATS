pro extract_SLATS_SILO
  
  ; first open SLATS spreadsheet, need lat, lon and dates from there
  Field_data = sat_fpar_anal_get_FC_field_data(N_MODELS=1)
  
  ; outputs to be written in fname
  fname = '\\wron\working\work\Juan_Pablo\PV_NPV_BS\New_Validation\GC_SILO_2012Nov14.csv'
  OPENW, lun, fname, /GET_LUN
  PRINTF, lun, 'OBJECTID,site_name,latitude,longitude,year,month,day,RAIN_DayMinus1,RAIN_DayMinus2,RAIN_DayMinus3,RAIN_DayMinus4,RAIN_DayMinus5,RAIN_DayMinus6,RAIN_DayMinus7'
  
  
  for site = 0, n_elements(Field_data.latitude)-1 do begin
;  for site = 0, 1 do begin
    OBJECTID = (Field_data.OBJECTID)[site]
    site_name = (Field_data.site_name)[site]
    lat = (Field_data.latitude)[site]
    lon = (Field_data.longitude)[site]
    JULDATE = (Field_data.JULDATE)[site]
        
    CALDAT, JULDATE, MONTH, DAY, YEAR
    DOY = JULDATE - JULDAY(1, 1, YEAR) + 1
    
    
;    composite = DOY / 8
;    JULDATE_composite = JULDAY(1, 1, YEAR_obs) + composite * 8 
;    CALDAT, JULDATE_composite, MONTH, DAY, YEAR
    
    pixVal = fltarr(7)
    
    for day=0, 6 do begin
      CALDAT, JULDATE - day, MONTH_obs, DAY_obs, YEAR_obs
      rainfall = READ_SILO_Rain(DAY_obs, MONTH_obs, YEAR_obs, lat, lon)
      
      ;pixVal is the center pixel of the 3x3 array returned
      pixVal[day] = rainfall

    endfor
    
    FORMATLON   = '(10(I8, :, ", "))'  
    FORMATFLOAT = '(10(f8.1, :, ", "))'  
    line_print = STRCOMPRESS( $
                  STRING(OBJECTID) + ',' + $
                  STRING(site_name) + ',' + $
                  STRING(lat) + ',' + $
                  STRING(lon) + ',' + $
                  STRING(year) + ',' + $
                  STRING(month) + ',' + $
                  STRING(day) + ',' + $
                  STRING(pixVal, format=FORMATFLOAT) + ',' , $
                  /REMOVE_ALL)                  
     
     PRINTF, lun, line_print              
     PRINT ,      line_print              
    
  endfor
   
  close, lun
  
end

