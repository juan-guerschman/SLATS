function fname_ASCAT,Year, Month, Day
  path = '\\wron\working\WIRADA\35\2012_13\data\ASCAT_SSM\v2\obs\' 
  if day le 9 then $
    day_add = '0' $
    Else day_add = ''  
  if month le 9 then $
    month_add = '0' $
    Else month_add = ''  
    
  fname = path + $
          strtrim(year,2) + '\' + $
          'ssm.' + $
          strtrim(year, 2) + $
          month_add + $
          strtrim(month, 2) + $
          day_add + $
          strtrim(day, 2) + $
          '.flt'
   
  return, fname        

end 


pro extract_SLATS_ASCAT 
  
;  ; first open SLATS spreadsheet, need lat, lon and dates from there
;  fname = '\\wron\Working\work\Juan_Pablo\PV_NPV_BS\New_Validation\fractional_landsat_subsets\out_b3_3pixSorted.csv'
;  LANDSAT_Qld = READ_ASCII_FILE(fname, /SURPRESS_MSG)

  ; LOAD SLATS DATA 
  ;if Keyword_Set(data) eq 0 then $
  fname = 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\fractional_landsat_subsets\outSorted_20130729.csv' 
  Data = READ_ASCII_FILE(fname, /SURPRESS_MSG)
   
;  Field_data = sat_fpar_anal_get_FC_field_data(N_MODELS=1)
  Field_data = Data 
  
  ; outputs to be written in fname
  fname = '\\wron\working\work\Juan_Pablo\PV_NPV_BS\New_Validation\GC_ASCAT_20130729.csv'
  if (File_Info(fname)).exists then file_exists = 1 Else file_exists = 0 
  if file_exists then $
    OPENU, lun, fname, /GET_LUN, /APPEND $
  else $  
    OPENW, lun, fname, /GET_LUN
  header = 'Obs_Key,site,latitude,longitude,' + $
           'YEAR_OBS,MONTH_OBS,DAY_OBS,' + $
           ;'YEAR_Landsat,MONTH_Landsat,DAY_Landsat,' + $
           'ASCATMinus0,ASCATMinus1,ASCATMinus2,ASCATMinus3,ASCATMinus4,ASCATMinus5,ASCATMinus6' ;+ $
           ;'LandsatMinus1,LandsatMinus2,LandsatMinus3,LandsatMinus4,LandsatMinus5,LandsatMinus6,LandsatMinus7'  
  if file_exists eq 0 then $
      PRINTF, lun, header
  
  if file_exists then $
    ASCAT_existing = READ_ASCII_FILE(fname, /SURPRESS_MSG)
    
  
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
    DATE_OBS = STRSPLIT((Field_data.obs_time)[site], '-', /Extract) * 1 ; this is the date of the observation 
        DAY_OBS = DATE_OBS[2] 
        MONTH_OBS = DATE_OBS[1]  
        YEAR_OBS = DATE_OBS[0]  
        JULDATE_OBS = JULDAY(MONTH_OBS, DAY_OBS, YEAR_OBS)
        ;DOY_OBS = JULDATE_OBS - JULDAY(1, 1, YEAR_OBS) + 1

        IF File_exists then $
          skip = Where(ASCAT_existing.obs_key eq OBJECTID, count) $
        Else $
          count=-1
         
        IF count le 0 then begin
            
          pixVal_obs = fltarr(7)
  ;        pixVal_Landsat = fltarr(7)
          
  ;        wsat_all = fltarr(7)
          for i=0, 6 do begin
            CALDAT, JULDATE_OBS - i, MONTH_i, DAY_i, YEAR_i
            
              fname=fname_ASCAT(YEAR_i, MONTH_i, DAY_i)
              file = FILE_SEARCH(fname)
               
              if n_elements(file) eq 1 and file[0] ne '' then begin
              
                t_counter=systime(1)
              ;  nCDF_Browser, fname
              ;  NCDF_Id = NCDF_OPEN(fname)
              ;  NCDF_INQUIRE = NCDF_INQUIRE(NCDF_Id)
              ;  name = 'mean'
              ;  NCDF_VARID = NCDF_VARID(NCDF_Id, Name)  
              ;  NCDF_VARGET, NCDF_Id, NCDF_VARID, _mean
              ;  _mean[where(_mean eq -9999)] = !VALUES.F_NAN    
              ;  wsat_da_001_Forecast_mean = _mean[*,*,0,0]
   
                ASCAT = READ_BINARY(fname , DATA_DIMS=[841, 681], DATA_TYPE=4)
;              where_noData = Where(ASCAT eq -999, count_noData)
;              if count_noData ge 1 then ASCAT[where_noData]=!VALUES.F_NAN 
                
                ; determine sample and line of SILO 
                LatLonSILO= latlon_SILO()
                
                sample = where(LatLonSILO.lon - lon eq min(LatLonSILO.lon - lon, /absolute))
                line   = where(LatLonSILO.lat - lat eq min(LatLonSILO.lat - lat, /absolute))
                
                result= ASCAT[sample, line]
                        
            
                endif Else begin
                  result = -999.0
                endElse
            
            pixVal_obs[i] = result
          endfor
       
      FORMATLON   = '(10(I8, :, ", "))'  
      FORMATFLOAT = '(10(f8.2, :, ", "))'  
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
                    STRING(pixVal_obs, format=FORMATFLOAT)   , $
  ;                  STRING(pixVal_Landsat, format=FORMATFLOAT) , $
                    /REMOVE_ALL)                  
       
       PRINTF, lun, line_print              
       PRINT ,      line_print 
     EndIf Else begin
        print, 'data exists, skip to next'
     Endelse
     
  endfor
   
  close, lun
  
  exit;, /NO_CONFIRM
  
end

