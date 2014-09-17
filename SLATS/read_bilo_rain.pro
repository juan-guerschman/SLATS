Function fname_BILO, data, day, month, year
  if month le 9 then month_app='0' else  month_app=''
  if day le 9 then day_app='0' else  day_app=''

      folder = STRCOMPRESS('\\wron\TimeSeries\Climate\ubilo\'+data+'\'+STRING(Year)+'\' , /REMOVE_ALL)  
      
      file_name_starts_with = STRCOMPRESS( $
                STRING(year) + $
                month_app + STRING(month) + $
                day_app + STRING(day) + $
                '_'+data+'_', /REMOVE_ALL)  
                
      last_bit = '*.flt'
      
      
    
   result = folder + file_name_starts_with + last_bit  
   return, result
end



function READ_BILO_rain, day, month, year, lat, lon
  compile_opt idl2
  
  ; rain
  data = 'rain' 
  fname=fname_Bilo(data, day, month, year)
  file = FILE_SEARCH(fname)
   
  if n_elements(file) eq 1 and file[0] ne '' then begin
  
    rain = READ_BINARY(file[0] , DATA_DIMS=[841, 681], DATA_TYPE=4)
    
    ; determine sample and line of SILO 
    LatLonSILO= latlon_SILO()
    
    sample = where(LatLonSILO.lon - lon eq min(LatLonSILO.lon - lon, /absolute))
    line   = where(LatLonSILO.lat - lat eq min(LatLonSILO.lat - lat, /absolute))
    
    result= rain[sample, line]
  
  ;  ; rad
  ;  data = 'rad' 
  ;  fname=fname_silo(data, day, month, year)
  ;  rad = READ_BINARY(fname , DATA_DIMS=[841, 681], DATA_TYPE=4)
  ;
  ;  ; tmax
  ;  data = 'tmax' 
  ;  fname=fname_silo(data, day, month, year)
  ;  tmax = READ_BINARY(fname , DATA_DIMS=[841, 681], DATA_TYPE=4)
  ;
  ;  ; tmin
  ;  data = 'tmin' 
  ;  fname=fname_silo(data, day, month, year)
  ;  tmin = READ_BINARY(fname , DATA_DIMS=[841, 681], DATA_TYPE=4)


    endif Else begin
      result = -1
    endElse
            
   return, result         

end
