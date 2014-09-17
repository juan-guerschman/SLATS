function latlon_soil_color

  latitudes = dindgen(375) * ((-43.8425750d + 10.09201667d) / (375 - 1d)) - 10.09201667d
  longitudes= dindgen(460) * ((156.39123056d - 109.89871111d) / (460 - 1d)) + 109.89871111d
  
  result= {  $
            lat: latitudes, $
            lon: longitudes $
           }
  return, result
  
end

 