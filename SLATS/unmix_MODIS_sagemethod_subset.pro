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



pro unmix_MODIS_sagemethod_subset
  compile_opt idl2

  ;envi, /restore_base_save_files
  ;envi_batch_init

  fname = 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\fractional_landsat_subsets\atmosph_corrected\comparisonwithmodis\MODIS_res.FC_500m.l5tmre_p091r085_20101229_tmpm5_corr004_500pix.img'
  fname_output='\\wron\working\work\Juan_Pablo\PV_NPV_BS\New_Validation\SAGE\images\MCD43A4.005\MCD43A4.unmixed.2012.12.26.img'
  day = 26
  month = 12
  year = 2012

  fname = 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\fractional_landsat_subsets\atmosph_corrected\comparisonwithmodis\MODIS_res.FC_500m.l5tmre_p113r075_20110906_tmpm0_WA_Pilb_021_500pix.img'
  fname_output='\\wron\working\work\Juan_Pablo\PV_NPV_BS\New_Validation\SAGE\images\MCD43A4.005\MCD43A4.unmixed.2011.08.29.img'
  day = 29
  month = 08
  year = 2011

  fname = 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\fractional_landsat_subsets\atmosph_corrected\comparisonwithmodis\MODIS_res.FC_l5tmre_p094r083_20090522_tmpm5_mulurulu26_500pix.img'
  fname_output='\\wron\working\work\Juan_Pablo\PV_NPV_BS\New_Validation\SAGE\images\MCD43A4.005\MCD43A4.unmixed.2009.05.17.img'
  day = 17
  month = 05
  year = 2009

  fname = 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\fractional_landsat_subsets\atmosph_corrected\comparisonwithmodis\MODIS_res.FC_500m.l7tmre_p091r089_20121124_tmpm5_TAS018_500pix.img'
  fname_output='\\wron\working\work\Juan_Pablo\PV_NPV_BS\New_Validation\SAGE\images\MCD43A4.005\MCD43A4.unmixed.2012.11.16.img'
  day = 16
  month = 11
  year = 2012

  fname = 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\fractional_landsat_subsets\atmosph_corrected\comparisonwithmodis\MODIS_res.FC_500m.l7tmre_p091r080_20121023_tmpm5_NSW052_500pix.img'
  fname_output='\\wron\working\work\Juan_Pablo\PV_NPV_BS\New_Validation\SAGE\images\MCD43A4.005\MCD43A4.unmixed.2012.10.15.img'
  day = 15
  month = 10
  year = 2012

  fname = 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\fractional_landsat_subsets\atmosph_corrected\comparisonwithmodis\MODIS_res.FC_500m.l7tmre_p102r078_20120208_tmpm3_UMB11_500pix.img'
  fname_output='\\wron\working\work\Juan_Pablo\PV_NPV_BS\New_Validation\SAGE\images\MCD43A4.005\MCD43A4.unmixed.2012.02.02.img'
  day = 02
  month = 02
  year = 2012

;  ; open land mask
;  fname = '\\wron\Working\work\Juan_Pablo\auxiliary\land_mask_australia_MCD43'
;  DIMS = [9580, 7451]
;  LAND = READ_Binary(fname, DATA_dims=dims, data_type=1) 
;;  ENVI_OPEN_FILE , fname , R_FID = FID_land_mask, /NO_REALIZE
;;  ENVI_FILE_QUERY, FID_land_mask, DIMS=DIMS_land_mask
;;  Land = ENVI_GET_DATA(fid=FID_land_mask, dims=DIMS_land_mask, pos=0)
;  Where_land = Where(Land eq 1, count_land)
  
  ; open classifed image (coming from Landsat) 
;  fname = 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\fractional_landsat_subsets\atmosph_corrected\comparisonwithmodis\MODIS_res.FC_500m.l5tmre_p091r085_20101229_tmpm5_corr004_500pix.img'
  ENVI_OPEN_FILE, fname, R_FID=FID
  ENVI_FILE_QUERY, FID, DATA_IGNORE_VALUE=DATA_IGNORE_VALUE, XSTART=XSTART, YSTART=YSTART, DEF_STRETCH=DEF_STRETCH, ns=ns, nl=nl, nb=nb, DIMS=DIMS
  projection = ENVI_GET_PROJECTION(FID=FID)
  MAP_INFO = ENVI_GET_MAP_INFO(FID=FID)
  ;DIMS=[ns, nl]
  Existing=fltarr(ns, nl, nb)
  for i=0,nb-1 do Existing[*,*,i]=ENVI_GET_DATA(FID=FID, DIMS=DIMS, POS=i)
  
  where_existing = Where(Total(Existing, 3) ne 0, count)
  Existing_green=(Existing[*,*,0])[where_existing]
  Existing_nonGreen=(Existing[*,*,1])[where_existing]
  Existing_bare=(Existing[*,*,2])[where_existing]
  
  ;Dates = MODIS_8d_dates()
  ;For dates_n = 0, n_elements(Dates)-1 do begin
  ;For dates_n = 466, 466 do begin

  ;CALDAT, Dates, Month, Day, Year
  
    Input_file = MCD43A4_fname(day, month, year)
    Temp_file  = 'c:\Temp\temp2.hdf'
        
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
  B1 = B1[where_existing] * 0.0001
  B2 = B2[where_existing] * 0.0001
  B3 = B3[where_existing] * 0.0001
  B4 = B4[where_existing] * 0.0001
  B5 = B5[where_existing] * 0.0001
  B6 = B6[where_existing] * 0.0001
  B7 = B7[where_existing] * 0.0001
  
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
  
  restore, 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\SAGE\plots\Subset_Data\TransformedReflectance_MCD43A4_WeightEQ_-1_no_crypto_subsetData.SAV'

  n_pixels = count
;  test = satelliteReflectanceTransformed[0:n_pixels-1,*]
  test = satelliteReflectanceTransformed 

  
  t = Systime(1) 
  sum2oneWeight=0.02
  lower_bound=-0.0 
  upper_bound=1.0 
  print, 'start running unmixing'
  retrievedCoverFractions = unmix_3_fractions_bvls(transpose(test), endmembersWeighted, $
      lower_bound=lower_bound, upper_bound=upper_bound, sum2oneWeight=sum2oneWeight)
  tt = Systime(1)
  elapsed = tt-t
  print, elapsed, ' seconds for unmix', n_pixels, ' pixels' 
;  print, ((elapsed)*(count_land/n_pixels*1.0))/3600, ' hours for the whole thing'
;  print, (elapsed) / n_pixels * 1000.0, ' seconds every 1000 pixels'

  ; reconstruct array

  Green = fltarr(ns, nl)
  NonGreen = fltarr(ns, nl)
  Bare = fltarr(ns, nl)
  ;OverGreen = LAND * 0.0
  
  Green[*] = !VALUES.F_NAN
  NonGreen[*] = !VALUES.F_NAN
  Bare[*] = !VALUES.F_NAN
  ;OverGreen[*] = !VALUES.F_NAN
  
  Green[where_existing] = retrievedCoverFractions[*, 0]
  NonGreen[where_existing] = retrievedCoverFractions[*, 1]
  Bare[where_existing] = retrievedCoverFractions[*, 2]
  ;OverGreen[Where_land] = retrievedCoverFractions[3,*]
   
;  SAVE, Green, NonGreen, Bare, elapsed, $
;    filename = 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\SAGE\images\unmixed_test.SAV'
  

;  ;open the following image and extract header info (particularly MAP_INFO )
;  fname = '\\wron\Working\work\Juan_Pablo\MOD09A1.005\header_issue\MOD09A1.2009.001.aust.005.b01.500m_0620_0670nm_refl.img'
;  ENVI_OPEN_FILE , fname , R_FID = FID_dummy, /NO_REALIZE
;  ENVI_FILE_QUERY, FID_dummy, DATA_IGNORE_VALUE=DATA_IGNORE_VALUE, XSTART=XSTART, YSTART=YSTART, DEF_STRETCH=DEF_STRETCH, ns=ns, nl=nl
;  projection = ENVI_GET_PROJECTION(FID=FID_dummy)
;  MAP_INFO = ENVI_GET_MAP_INFO(FID=FID_dummy)
  

   ENVI_WRITE_ENVI_FILE, [[[Green]],[[nonGreen]],[[bare]]], OUT_NAME=fname_output, MAP_INFO=MAP_INFO  
  

  ;EXIT, /NO_CONFIRM
  

end
