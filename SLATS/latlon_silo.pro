function latlon_SILO

  latitudes = dindgen(681) * ((-44d + 10d) / (681d - 1d)) - 10d
  longitudes= dindgen(841) * ((154.0d - 112d) / (841d - 1d)) + 112d
  
  result= {  $
            lat: latitudes, $
            lon: longitudes $
           }
  return, result
  
end

 