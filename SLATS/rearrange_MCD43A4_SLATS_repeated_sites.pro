pro rearrange_MCD43A4_SLATS_repeated_sites
  compile_opt idl2 
  
  fname = '\\wron\working\work\Juan_Pablo\PV_NPV_BS\New_Validation\SLATS_sites_MCD43A4_repeat_sites.csv'
  MCD43A4 = READ_ASCII_FILE(fname, /SURPRESS_MSG)
  
  ;rearrange data
  Uniq_Sites = (MCD43A4.site_name)[UNIQ(MCD43A4.site_name, SORT(MCD43A4.site_name))]
  dates = JULDAY(MCD43A4.month, MCD43A4.day, MCD43A4.year)
  Uniq_dates = (dates)[UNIQ(dates, SORT(dates))]

  fname = '\\wron\working\work\Juan_Pablo\PV_NPV_BS\New_Validation\SLATS_sites_MCD43A4_repeat_sites_2.csv'
  OPENW, lun, fname, /GET_LUN
  PRINTF, lun, 'obs_key,site_name,latitude,longitude,year,month,day,B1,B2,B3,B4,B5,B6,B7'
      
      FORMATLON   = '(10(I8, :, ", "))'  
      FORMATFLOAT = '(10(f8.1, :, ", "))'  
  
  for site = 0, n_elements(Uniq_Sites)-1 do begin 
    where_site = WHERE(MCD43A4.site_name eq Uniq_Sites[site])
    for date = 0, n_elements(Uniq_dates)-1 do begin
      CALDAT, Uniq_dates[date], M, D, Y
      where_date_site = WHERE(dates eq Uniq_dates[date] AND MCD43A4.site_name eq Uniq_Sites[site])
      
      output = intarr(7)
      for band = 1, 7 do begin
        whereInDate_site = where((MCD43A4.band)[where_date_site] eq band, count)
        whereIam = where_date_site[whereInDate_site]
      
        if count ne 1 then stop        
        output[band-1] = (MCD43A4.value)[whereIam]
      endfor
       
      line_print = STRCOMPRESS( $
                    STRING((MCD43A4.obs_key)[whereIam]) + ',' + $
                    STRING((MCD43A4.site_name)[whereIam]) + ',' + $
                    STRING((MCD43A4.latitude)[whereIam]) + ',' + $
                    STRING((MCD43A4.longitude)[whereIam]) + ',' + $
                    STRING((MCD43A4.year)[whereIam]) + ',' + $
                    STRING((MCD43A4.month)[whereIam]) + ',' + $
                    STRING((MCD43A4.day)[whereIam]) + ',' + $
;                    STRING(band) + ',' + $
                    STRING(output, format=FORMATLON),   $
                    /REMOVE_ALL)                  
       
       PRINTF, lun, line_print              
       PRINT ,      line_print              
      
    endfor    
  endfor
  
  close, /all
  
  exit, /NO_CONFIRM
end  


