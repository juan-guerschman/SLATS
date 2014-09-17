pro extract_SLATS_FractCover_repeat_sites
  
  ; first open SLATS spreadsheet, need lat, lon and dates from there
  ;Field_data = sat_fpar_anal_get_FC_field_data(N_MODELS=1)
  fname = '\\wron\Working\work\Juan_Pablo\PV_NPV_BS\New_Validation\fractional_landsat_subsets\out_b3_3pixSorted.csv'
  Field_data = READ_ASCII_FILE(fname, /SURPRESS_MSG)

  ; sites with revisits 
  Uniq_Sites = (Field_data.site)[UNIQ(Field_data.site, SORT(Field_data.site))]
  Uniq_Sites_n = intarr(n_elements(Uniq_Sites))
  Uniq_Sites_names = Strarr(n_elements(Uniq_Sites))
  for i=0, n_elements(Uniq_Sites)-1 do Uniq_Sites_n[i] = n_elements(Where(Field_data.site eq Uniq_Sites[i]))
;  cgWindow, WMulti=[0,2,0], wysize=200, wxsize=600
;  cgWindow, 'cgHistoPlot',  Uniq_Sites_n, xTitle='number of visits',  yTitle='sites', /fillpolygon, /addcmd
;  cgWindow, 'cgHistoPlot',  Uniq_Sites_n, max_value=50, xTitle='number of visits',  yTitle='sites', /fillpolygon, /addcmd
  
  where_ge5 = Where(Uniq_Sites_n ge 5, count_ge5)
  Uniq_Sites_names = Uniq_Sites[where_ge5]
  

;    site = Uniq_Sites[where_ge5[n]]
;    where_site = where(LANDSAT_Qld.site eq site)
;    sort_date=Sort(Jul_Day[where_site])
;    void = Label_Date(Date_Format= '%M %Y')
  
  ; outputs to be written in fname
  fname = '\\wron\working\work\Juan_Pablo\PV_NPV_BS\New_Validation\SLATS_sites_FractCover_repeat_sites_v2.1_2011_2013.csv'
  OPENW, lun, fname, /GET_LUN
  PRINTF, lun, 'obs_key,site_name,latitude,longitude,year,month,day,vesrion,FractCover_BAND,value'
  
  for version = 1,1  do begin
  case version of 
    1: v = 'v2.1'
    2: v = 'v2.2'
  endcase  
  for year= 2011, 2013 do begin
    for composite= 0, 45 do begin
      DOY = composite * 8 + 1  
      JUL_DAY = JULDAY(1,1,year) + DOY - 1 
      CALDAT, JUL_DAY, month, day
      
      for band=0, 3 do begin
        case band of
          0: B = 'PV'
          1: B = 'NPV'
          2: B = 'BS' 
          3: B = 'FLAG'
        endcase
        for sitio=0, count_ge5-1 do begin
          site = (Where(Field_data.site eq Uniq_Sites_names[sitio]))[0]
          
        ;  for site = 0, 1 do begin
          obs_key = (Field_data.obs_key)[site]
          site_name = (Field_data.site)[site]
          lat = (Field_data.st_y)[site]
          lon = (Field_data.st_x)[site]
            
          UL_lat = lat
          UL_lon = lon
          LR_Lat = lat
          LR_Lon = lon
            
        url= Fract_cover_thredds_name(v, day, month, year)
        
        ; get MODIS values 3x3 window
  ;      print, 'getting', site, band, day, month, year, lat, lon
;        array = get_data_from_thredds_3x3(url[band], lat, lon)
        array = get_data_from_thredds_UL_LR(url[band], UL_lat, UL_lon, LR_Lat, LR_Lon)
        ;print, array
        
        ; Convert Array to long Integers
        if array eq '' then $
          array = -1 else $
          array = LONG(array)
        
        ;pixVal is the center pixel of the 3x3 array returned
        pixVal  = array
  
    FORMATLON   = '(10(I8, :, ", "))'  
    FORMATFLOAT = '(10(f8.1, :, ", "))'  
    line_print = STRCOMPRESS( $
                  STRING(obs_key) + ',' + $
                  STRING(site_name) + ',' + $
                  STRING(lat) + ',' + $
                  STRING(lon) + ',' + $
                  STRING(year) + ',' + $
                  STRING(month) + ',' + $
                  STRING(day) + ',' + $
                  v + ',' + $
                  b + ',' + $
                  STRING(pixVal, format=FORMATLON),   $
                  /REMOVE_ALL)                  
     
     PRINTF, lun, line_print              
     PRINT ,      line_print              
    
  endfor 
  endfor
  endfor
  endfor
  endfor 
  close, lun
  
end

