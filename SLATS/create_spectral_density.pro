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



pro create_spectral_density 
  compile_opt idl2
  
  array = lonarr(100, 100, 100) 
  
  fname_mask = 'Z:\work\Juan_Pablo\auxiliary\land_mask_australia_MCD43'
  land_mask = READ_BINARY(fname_mask, DATA_DIMS=[9580, 7451], DATA_TYPE=1)
  
  high_red_high_nir = []
  
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

        high_red_high_nir += (RED ge 3000 AND NIR ge 4000)
        
        ; get rid of all ocean and nans 
        where_OK = Where(land_mask eq 1 AND RED ge 0 AND SWIR3 ge 0, count)
        if count ge 1 then RED = RED[where_OK]
        if count ge 1 then NIR = NIR[where_OK]
        if count ge 1 then SWIR3 = SWIR3[where_OK]
         
        histo_ND = HIST_ND(TRANSPOSE([[RED],[NIR],[SWIR3]]), MIN=0,MAX=10000,NBINS=100)  
        
        array += histo_ND

    endfor
  endfor  

  ; save output as a IDL variable 
  fname_out = 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\Reflectance_density\density_RED_NIR_SWIR_2008_2009.SAV' 
  SAVE, array, FILENAME=fname_out
  
  
end 
