pro save_SLATS_data_for_sage

  data = read_SLATS_data()
  
  fname = 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\SAGE\reflectance_MODIS.csv'
  OPENW, lun, fname, /get_lun
  
  field = data.landsat_qld
  MCD43A4 = data.MCD43A4
  
  where_valid = Where(MCD43A4.b1 ge 0 and $
                      MCD43A4.b2 ge 0 and $
                      MCD43A4.b3 ge 0 and $
                      MCD43A4.b4 ge 0 and $
                      MCD43A4.b5 ge 0 and $
                      MCD43A4.b6 ge 0 and $
                      MCD43A4.b7 ge 0 , count)
  
  for j=0, count-1 do begin
    i=where_valid[j]
    
    Format='(100(A25,:, ","))'
    text = string($
           ((field.st_x)[i]) , $
           ((field.st_y)[i]) , $
           ((field.easting)[i]) , $    
           ((field.northing)[i]) , $    
           ((field.zone)[i]) , $    
           ((field.crust)[i]) , $    
           ((field.dist)[i]) , $    
           ((field.rock)[i]) , $    
           ((field.green)[i]) , $    
           ((field.crypto)[i]) , $    
           ((field.dead)[i]) , $    
           ((field.litter)[i]) , $    
           ((field.mid_g)[i]) , $    
           ((field.mid_d)[i]) , $    
           ((field.mid_b)[i]) , $    
           ((field.crn)[i]) , $    
           ((field.over_g)[i]) , $    
           ((field.over_d)[i]) , $    
           ((field.over_b)[i]) , $    
           ((field.num_points)[i]) , $    
           0  , $                       ; this was landsat 5 or 7 in the original, I don't need it    
           0  , $                       ; this was the timelag used for weighting, not used for now
           ((MCD43A4.b1)[i]) , $    
           ((MCD43A4.b2)[i]) , $    
           ((MCD43A4.b3)[i]) , $    
           ((MCD43A4.b4)[i]) , $    
           ((MCD43A4.b5)[i]) , $    
           ((MCD43A4.b6)[i]) , $    
           ((MCD43A4.b7)[i]) , format=format)   
           
           print, strcompress(text, /REMOVE_ALL)
           
           printF, lun, strcompress(text, /REMOVE_ALL)
  endfor  
  
  close, /all
end
  