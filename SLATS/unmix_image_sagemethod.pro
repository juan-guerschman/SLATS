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



pro unmix_image_SAGEmethod, day=day, month=month, year=year;, doy=doy
  compile_opt idl2

  ; open land mask
  fname = '\\wron\Working\work\Juan_Pablo\auxiliary\land_mask_australia_MCD43'
  DIMS = [9580, 7451]
  LAND = READ_Binary(fname, DATA_dims=dims, data_type=1) 
;  ENVI_OPEN_FILE , fname , R_FID = FID_land_mask, /NO_REALIZE
;  ENVI_FILE_QUERY, FID_land_mask, DIMS=DIMS_land_mask
;  Land = ENVI_GET_DATA(fid=FID_land_mask, dims=DIMS_land_mask, pos=0)
  Where_land = Where(Land eq 1, count_land, Complement=Where_water)
  
  ;Dates = MODIS_8d_dates()
  ;For dates_n = 0, n_elements(Dates)-1 do begin
  ;For dates_n = 466, 466 do begin

  ;CALDAT, Dates, Month, Day, Year

;  day = 1
;  month = 1
;  year = 2012

    DOY=JULDAY(Month, Day, Year) - JULDAY(1, 1, Year) + 1   
  
    Input_file = MCD43A4_fname(day, month, year)
    Temp_file  = 'c:\Temp\temp.hdf'
        
    ; get RED band
    fname = Input_file[0]
    B1 = Get_Zipped_Hdf(fname, Temp_file)

    ; get NIR band
    fname = Input_file[1]
    B2 = Get_Zipped_Hdf(fname, Temp_file)

    ; get Blue band
    fname = Input_file[2]
    B3 = Get_Zipped_Hdf(fname, Temp_file)

    ; get Green band
    fname = Input_file[3]
    B4 = Get_Zipped_Hdf(fname, Temp_file)

    ; get SWIR1 band
    fname = Input_file[4]
    B5 = Get_Zipped_Hdf(fname, Temp_file)

    ; get SWIR2 band
    fname = Input_file[5]
    B6 = Get_Zipped_Hdf(fname, Temp_file)

    ; get SWIR3 band
    fname = Input_file[6]
    B7 = Get_Zipped_Hdf(fname, Temp_file)

    SIZE_DATA = Size(RED)

    ; Check if any of the bands returned -1
    If  B1[0] eq -1 or $
      B2[0] eq -1 or $
      B3[0] eq -1 or $
      B4[0] eq -1 or $
      B5[0] eq -1 or $
      B6[0] eq -1 or $
      B7[0] eq -1 $
    then corrupted = 1 else corrupted = 0

  ; get rid of ocean and other stuf we don't want  
  B1 = B1[Where_land] * 0.0001
  B2 = B2[Where_land] * 0.0001
  B3 = B3[Where_land] * 0.0001
  B4 = B4[Where_land] * 0.0001
  B5 = B5[Where_land] * 0.0001
  B6 = B6[Where_land] * 0.0001
  B7 = B7[Where_land] * 0.0001
  
  t = Systime(1) 
    satelliteReflectanceTransformed = $
       [[b1],[b2],[b3],[b4],[b5],[b6],[b7], $
       [alog(b1)],[alog(b2)],[alog(b3)],[alog(b4)],[alog(b5)],[alog(b6)],[alog(b7)], $
       [alog(b1)*b1],[alog(b2)*b2],[alog(b3)*b3],[alog(b4)*b4],[alog(b5)*b5],[alog(b6)*b6],[alog(b7)*b7], $
        [b1*b2],[b1*b3],[b1*b4],[b1*b5],[b1*b6],[b1*b7], $
                [b2*b3],[b2*b4],[b2*b5],[b2*b6],[b2*b7], $
                        [b3*b4],[b3*b5],[b3*b6],[b3*b7], $
                                [b4*b5],[b4*b6],[b4*b7], $
                                        [b5*b6],[b5*b7], $
                                                [b6*b7], $
       [alog(b1)*alog(b2)],[alog(b1)*alog(b3)],[alog(b1)*alog(b4)],[alog(b1)*alog(b5)],[alog(b1)*alog(b6)],[alog(b1)*alog(b7)], $
                [alog(b2)*alog(b3)],[alog(b2)*alog(b4)],[alog(b2)*alog(b5)],[alog(b2)*alog(b6)],[alog(b2)*alog(b7)], $
                        [alog(b3)*alog(b4)],[alog(b3)*alog(b5)],[alog(b3)*alog(b6)],[alog(b3)*alog(b7)], $
                                [alog(b4)*alog(b5)],[alog(b4)*alog(b6)],[alog(b4)*alog(b7)], $
                                        [alog(b5)*alog(b6)],[alog(b5)*alog(b7)], $
                                                [alog(b6)*alog(b7)], $
        [(b2-b1)/(b2+b1)],[(b3-b1)/(b3+b1)],[(b4-b1)/(b4+b1)],[(b5-b1)/(b5+b1)],[(b6-b1)/(b6+b1)],[(b7-b1)/(b7+b1)], $
                          [(b3-b2)/(b3+b2)],[(b4-b2)/(b4+b2)],[(b5-b2)/(b5+b2)],[(b6-b2)/(b6+b2)],[(b7-b2)/(b7+b2)], $
                                            [(b4-b3)/(b4+b3)],[(b5-b3)/(b5+b3)],[(b6-b3)/(b6+b3)],[(b7-b3)/(b7+b3)], $
                                                              [(b5-b4)/(b5+b4)],[(b6-b4)/(b6+b4)],[(b7-b4)/(b7+b4)], $
                                                                                [(b6-b5)/(b6+b5)],[(b7-b5)/(b7+b5)], $
                                                                                                  [(b7-b6)/(b7+b6)]]
  
  print, systime(1)-t, ' seconds for computing satelliteReflectanceTransformed'
  
  restore, 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\SAGE\plots\subset_data\TransformedReflectance_MCD43A4_WeightEQ_-1_no_crypto_subsetData.SAV'

;  test = satelliteReflectanceTransformed[0:n_pixels-1,*]
;  test = satelliteReflectanceTransformed[0:9999,*] 
  test = satelliteReflectanceTransformed
  n_pixels = n_elements(test[*,0])

  
  t = Systime(1) 
  sum2oneWeight=0.02
  lower_bound=-0.0 
  upper_bound=1.0 
  print, 'start running unmixing'
  retrievedCoverFractions = Transpose(unmix_3_fractions_bvls(transpose(test), endmembersWeighted, $
      lower_bound=lower_bound, upper_bound=upper_bound, sum2oneWeight=sum2oneWeight))
  tt = Systime(1)
  elapsed = tt-t
  print, elapsed, ' seconds for unmix', n_pixels, ' pixels' 
  print, ((elapsed)*(count_land/n_pixels*1.0))/3600, ' hours for the whole thing'
  print, (elapsed) / n_pixels * 1000.0, ' seconds every 1000 pixels'

  ; reconstruct array

  UnderGreen = LAND * 1L
  NonGreen = LAND * 1L
  Bare = LAND * 1L
;  OverGreen = LAND * 0.0
  
  UnderGreen[*] = -999
  NonGreen[*] = -999
  Bare[*] = -999
;  OverGreen[*] = !VALUES.F_NAN
  
  UnderGreen[Where_land] = FIX(retrievedCoverFractions[0,*] * 10000)
  NonGreen[Where_land] = FIX(retrievedCoverFractions[1,*] * 10000)
  Bare[Where_land] = FIX(retrievedCoverFractions[2,*] * 10000)
;  OverGreen[Where_land] = retrievedCoverFractions[3,*]
   
;  SAVE, Green, NonGreen, Bare, elapsed, $
;    filename = 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\SAGE\images\unmixed_test.SAV'
  
  envi, /restore_base_save_files
  envi_batch_init

  ;open the following image and extract header info (particularly MAP_INFO )
  fname = '\\wron\Working\work\Juan_Pablo\MOD09A1.005\header_issue\MOD09A1.2009.001.aust.005.b01.500m_0620_0670nm_refl.img'
  ENVI_OPEN_FILE , fname , R_FID = FID_dummy, /NO_REALIZE
  ENVI_FILE_QUERY, FID_dummy, DATA_IGNORE_VALUE=DATA_IGNORE_VALUE, XSTART=XSTART, YSTART=YSTART, DEF_STRETCH=DEF_STRETCH, ns=ns, nl=nl
  projection = ENVI_GET_PROJECTION(FID=FID_dummy)
  MAP_INFO = ENVI_GET_MAP_INFO(FID=FID_dummy)
  

  if doy lt 10 then doy_str='00'
  if doy ge 10 and doy lt 100 then doy_str='0'
  if doy ge 100 then doy_str=''
  fname_base ='Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\SAGE\images\FractCover.V3.0.1.'+ $
              strtrim(year,2)+'.'+doy_str+strtrim(doy,2)+'.aust.005.'  
   
  fname= fname_base+'PV.img'
  ENVI_WRITE_ENVI_FILE, UnderGreen, OUT_NAME = fname, MAP_INFO = MAP_INFO, R_FID=FID_PV   
  
  fname= fname_base+'NPV.img'
  ENVI_WRITE_ENVI_FILE, nongreen, OUT_NAME = fname, MAP_INFO = MAP_INFO, R_FID=FID_PV   

  fname= fname_base+'BS.img'
  ENVI_WRITE_ENVI_FILE, bare, OUT_NAME = fname, MAP_INFO = MAP_INFO, R_FID=FID_PV   

;  fname= 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\SAGE\images\MCD43A4_4Endmembers_Overgreen.img'
;  ENVI_WRITE_ENVI_FILE, OverGreen, OUT_NAME = fname, MAP_INFO = MAP_INFO, R_FID=FID_PV   
;
;  fname= 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\SAGE\images\MCD43A4_4Endmembers_green.img'
;  ENVI_WRITE_ENVI_FILE, UnderGreen+OverGreen, OUT_NAME = fname, MAP_INFO = MAP_INFO, R_FID=FID_PV   

  fname= fname_base+'TOT.img'
  ENVI_WRITE_ENVI_FILE, UnderGreen+nongreen+bare, OUT_NAME = fname, MAP_INFO = MAP_INFO, R_FID=FID_PV   


  EXIT, /NO_CONFIRM
  

end
