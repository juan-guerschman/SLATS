

pro unmix_image_SAGEmethod_Landsat
  compile_opt idl2

 
  CD, 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\fractional_landsat_subsets\atmosph_corrected\comparisonwithmodis\'

  files = FILE_SEARCH('*.tif')
  
  restore, 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\SAGE\plots\subset_data\TransformedReflectance_Landsat_3x3_WeightEQ_-1_no_crypto_subsetData.SAV'

  for i=0, n_elements(files)-1 do begin
    
    fname = files[i]
    
    out_fname = (STRSPLIT(fname, '.', /EXTRACT))[0]
    out_fname='FC_'+out_fname+'.img'
    print, out_fname
    
    if (File_Info(out_fname)).exists eq 0 then begin 
    
      ENVI_OPEN_FILE, fname, R_FID=FID
      ENVI_FILE_QUERY, FID, DIMS=DIMS
      MAP_INFO = ENVI_GET_MAP_INFO(FID=FID)
      
    
      image = float(READ_TIFF(fname)) 
      image_copy = image
      
      size_image = SIZE(image)
      n_pixels_image= size_image[2]*size_image[3]
      ;for band=0,size_image[1]-1 do image[band,*,*] = (image[band,*,*] - reflOffsets[band]) / reflGains[band]
      image/=10000.
    
      B1 = REFORM(image[0,*,*], size_image[2]*size_image[3])
      B2 = REFORM(image[1,*,*], size_image[2]*size_image[3])
      B3 = REFORM(image[2,*,*], size_image[2]*size_image[3])
      B4 = REFORM(image[3,*,*], size_image[2]*size_image[3])
      B5 = REFORM(image[4,*,*], size_image[2]*size_image[3])
      B6 = REFORM(image[5,*,*], size_image[2]*size_image[3])
      
      t = Systime(1) 
        satelliteReflectanceTransformed = $
           [[b1],[b2],[b3],[b4],[b5],[b6], $
           [alog(b1)],[alog(b2)],[alog(b3)],[alog(b4)],[alog(b5)],[alog(b6)], $
           [alog(b1)*b1],[alog(b2)*b2],[alog(b3)*b3],[alog(b4)*b4],[alog(b5)*b5],[alog(b6)*b6], $
            [b1*b2],[b1*b3],[b1*b4],[b1*b5],[b1*b6],  $
                    [b2*b3],[b2*b4],[b2*b5],[b2*b6],  $
                            [b3*b4],[b3*b5],[b3*b6],  $
                                    [b4*b5],[b4*b6],  $
                                            [b5*b6],  $
           [alog(b1)*alog(b2)],[alog(b1)*alog(b3)],[alog(b1)*alog(b4)],[alog(b1)*alog(b5)],[alog(b1)*alog(b6)], $
                    [alog(b2)*alog(b3)],[alog(b2)*alog(b4)],[alog(b2)*alog(b5)],[alog(b2)*alog(b6)], $
                            [alog(b3)*alog(b4)],[alog(b3)*alog(b5)],[alog(b3)*alog(b6)], $
                                    [alog(b4)*alog(b5)],[alog(b4)*alog(b6)], $
                                            [alog(b5)*alog(b6)], $
            [(b2-b1)/(b2+b1)],[(b3-b1)/(b3+b1)],[(b4-b1)/(b4+b1)],[(b5-b1)/(b5+b1)],[(b6-b1)/(b6+b1)], $
                              [(b3-b2)/(b3+b2)],[(b4-b2)/(b4+b2)],[(b5-b2)/(b5+b2)],[(b6-b2)/(b6+b2)], $
                                                [(b4-b3)/(b4+b3)],[(b5-b3)/(b5+b3)],[(b6-b3)/(b6+b3)], $
                                                                  [(b5-b4)/(b5+b4)],[(b6-b4)/(b6+b4)], $
                                                                                    [(b6-b5)/(b6+b5)]] 
         help, satelliteReflectanceTransformed                                                                           
      
      print, systime(1)-t, ' seconds for computing satelliteReflectanceTransformed'
      
      
      
      t = Systime(1) 
    ;  sum2oneWeight=0.02
      sum2oneWeight=0.02
      lower_bound=-0.0 
      upper_bound=1.0 
      retrievedCoverFractions = Transpose(unmix_3_fractions_bvls(transpose(satelliteReflectanceTransformed), endmembersWeighted, $
          lower_bound=lower_bound, upper_bound=upper_bound, sum2oneWeight=sum2oneWeight))
      tt = Systime(1)
      elapsed = tt-t
      print, elapsed, ' seconds for unmix', n_pixels_image, ' pixels' 
  ;    print, ((elapsed)*(n_pixels_image/n_pixels*1.0))/3600, ' hours for the whole thing'
  ;   print, (elapsed) / n_pixels * 1000.0, ' seconds every 1000 pixels'
    
      ; reconstruct array
    
      Green = fltarr(size_image[2],size_image[3])
      NonGreen = fltarr(size_image[2],size_image[3])
      Bare = fltarr(size_image[2],size_image[3])
    ;  OverstoreyGreen = fltarr(size_image[2],size_image[3])
      
       
      Green[*] = retrievedCoverFractions[0,*]
      NonGreen[*] = retrievedCoverFractions[1,*]
      Bare[*] = retrievedCoverFractions[2,*]
      ;find Nans and mask them 
      where_nan = Where(B1+B2+B3+B4+B5+B6 EQ 0, COUNT)
      if count ge 1 then Green[where_nan]= !Values.f_nan
      if count ge 1 then NonGreen[where_nan]= !Values.f_nan
      if count ge 1 then Bare[where_nan]= !Values.f_nan
      
    ;  overstoreyGreen[*] = retrievedCoverFractions[3,*]
       
    ;  SAVE, Green, NonGreen, Bare, elapsed, $
    ;    filename = 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\SAGE\images\unmixed_Landsat_test.SAV'
    
      FC=[[[green]],[[nongreen]],[[bare]]]  
      
      DEF_STRETCH =ENVI_DEFAULT_STRETCH_CREATE(/LINEAR, VAL1=0, VAL2=1)
      ENVI_WRITE_ENVI_FILE, FC, BNAMES=['PV','NPV','B'], DEF_BANDS=[1,0,2], DEF_STRETCH=DEF_STRETCH, $
        OUT_NAME=out_fname, MAP_INFO=MAP_INFO
 
    endif
  endfor
 
 

end
