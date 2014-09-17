function MCD43A4_fname, day, month, year
  compile_opt idl2

  path = '\\wron\RemoteSensing\MODIS\L2\LPDAAC\data\aust\MCD43A4.005\'

  if month le 9 then app_month = '0' else app_month = ' '
  if day le 9 then app_day = '0' else app_day = ' '

  doy = JULDAY (month, day, year)  -  JULDAY (1,1,year) + 1
  if doy le 9 then app_doy = '00'
  if doy gt 9 and doy le 99 then app_doy = '0'
  if doy gt 99 then app_doy = ' '


  fname = strarr(7)


  for i=0, 6 do begin

    Case i of
      0: Band_text= 'aust.005.b01.500m_0620_0670nm_nbar.hdf.gz'
      1: Band_text= 'aust.005.b02.500m_0841_0876nm_nbar.hdf.gz'
      2: Band_text= 'aust.005.b03.500m_0459_0479nm_nbar.hdf.gz'
      3: Band_text= 'aust.005.b04.500m_0545_0565nm_nbar.hdf.gz'
      4: Band_text= 'aust.005.b05.500m_1230_1250nm_nbar.hdf.gz'
      5: Band_text= 'aust.005.b06.500m_1628_1652nm_nbar.hdf.gz'
      6: Band_text= 'aust.005.b07.500m_2105_2155nm_nbar.hdf.gz'

    EndCase

    fname_i = strcompress( $
      path + $
      String (year) + '.' + $
      app_month + String(month) +  '.' + $
      app_day + String(day) +  '\' + $
      'MCD43A4.' + $
      String (year) + '.' + $
      app_doy + String(doy) + '.' + $
      Band_text , $
      /REMOVE_ALL )

    fname[i] = fname_i

  EndFor

    ;fname_search = FILE_SEARCH(fname_case)

    ;if n_elements(Fname_search) ne 1 then stop else $
    ; fname[i*2+j] = Fname_case

  return, fname
end



pro create_spectral_density_areas
  compile_opt idl2
  
  array = lonarr(100, 100, 100) 
  
  fname_mask = 'Z:\work\Juan_Pablo\auxiliary\land_mask_australia_MCD43'
  land_mask = READ_BINARY(fname_mask, DATA_DIMS=[9580, 7451], DATA_TYPE=1)
  
  RED_ge_3000_AND_NIR_ge_4000 = land_mask * 0B
  SWIR3_ge_4500 = land_mask * 0B
  RED_le_1500_AND_NIR_ge_3750 = land_mask * 0B
  NIR_ge_3750_AND_SWIR3_le_2000 = land_mask * 0B
  
  for year = 2008, 2009 do begin 
    for composite= 0, 44 do begin
        
        ; READ the data
        day_of_year = composite * 8 + 1
        Julian_day = JULDAY(1,1,year) + day_of_year - 1
        CALDAT, Julian_day, month, day
        fname = MCD43A4_fname(day, month, year)
        RED = get_zipped_hdf(fname[0], 'c:\temp\temp.gz')
        NIR = get_zipped_hdf(fname[1], 'c:\temp\temp.gz')
        SWIR3 = get_zipped_hdf(fname[6], 'c:\temp\temp.gz')
        
        if RED[0] ne -1 AND NIR[0] ne -1 AND SWIR3[0] ne -1 then begin
       
          RED_ge_3000_AND_NIR_ge_4000 += (RED ge 3000 AND NIR ge 4000)
          SWIR3_ge_4500 += (SWIR3 ge 4500)
          RED_le_1500_AND_NIR_ge_3750 += (RED le 1500 AND NIR ge 3750)
          NIR_ge_3750_AND_SWIR3_le_2000 += (NIR ge 3750 AND SWIR3 le 2000)
        endif
        

    endfor
  endfor  
  
  ALL = RED_ge_3000_AND_NIR_ge_4000 > SWIR3_ge_4500 > RED_le_1500_AND_NIR_ge_3750 > NIR_ge_3750_AND_SWIR3_le_2000

  ; save output as a IDL variable 
  fname_out = 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\Reflectance_density\density_RED_NIR_SWIR_2008_2009_areas.SAV' 
  SAVE, ALL, RED_ge_3000_AND_NIR_ge_4000, SWIR3_ge_4500, RED_le_1500_AND_NIR_ge_3750, NIR_ge_3750_AND_SWIR3_le_2000 , FILENAME=fname_out
  
  
end 
