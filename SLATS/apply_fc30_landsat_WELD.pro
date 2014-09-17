function FractionalCover_30_Landsat, B1, B2, B3, B4, B5, B7, endmembersWeighted
  compile_opt idl2

    size_img = size(B1)

  ; CHECK WHERE VALUES ARE GOOD 
    where_ok = where(B1 GT 0 AND $
                     B2 GT 0 AND $)
                     B3 GT 0 AND $
                     B4 GT 0 AND $
                     B5 GT 0 AND $
                     B7 GT 0, COUNT_OK)

    B1=B1[where_ok]  
    B2=B2[where_ok]  
    B3=B3[where_ok]  
    B4=B4[where_ok] 
    B5=B5[where_ok]  
    B6=B7[where_ok]  ; watch out!  I call it B6 from here on 
  
    ; create band transforms as per RSE paper
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

    t = Systime(1) 
    sum2oneWeight=0.02
    lower_bound=-0.0 
    upper_bound=1.0 
    retrievedCoverFractions = Transpose(unmix_3_fractions_bvls(transpose(satelliteReflectanceTransformed), endmembersWeighted, $
        lower_bound=lower_bound, upper_bound=upper_bound, sum2oneWeight=sum2oneWeight))
    tt = Systime(1)
    elapsed = tt-t
    print, elapsed, ' seconds for unmix', count_ok, ' pixels' 
    
    ; reconstruct arrays
    PV = bytarr(size_img[1],size_img[2]) & PV[*]=255
    NPV = bytarr(size_img[1],size_img[2]) & NPV[*]=255
    BS = bytarr(size_img[1],size_img[2]) & BS[*]=255
  
    PV[where_ok]=retrievedCoverFractions[0,*] * 100 + 0.5
    NPV[where_ok]=retrievedCoverFractions[1,*] * 100 + 0.5
    BS[where_ok]=retrievedCoverFractions[2,*] * 100 + 0.5

    ; put outputs in a structure and return
    OUTPUT = CREATE_STRUCT(  $
             'PV',  PV, $
             'NPV', NPV, $
             'BS',  BS  $
             )

    RETURN, OUTPUT
end


pro apply_FC30_landsat_WELD, folder
  compile_opt idl2

  if KEYWORD_SET(folder) eq 0 then $
    folder= 'Z:\work\Juan_Pablo\LANDSAT\WELD\GDLvqyzcMONTH062012\conus.month06.2012.lon-102.489016to-102.09803.lat35.718029to36.074063.doy165to181.v1.5'
  cd, folder
  files = FILE_SEARCH('*.TIF')
  restore, 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\SAGE\plots\subset_data\NEW_20130729\TransformedReflectance_Landsat_3x3_WeightEQ_-1_no_crypto_subsetData.SAV'
  quality=100
      
    ;read bands
  
    B1 = READ_TIFF('Band1_TOA_REF.TIF', GEOTIFF=GEOTIFF)
    B2 = READ_TIFF('Band2_TOA_REF.TIF', GEOTIFF=GEOTIFF)
    B3 = READ_TIFF('Band3_TOA_REF.TIF', GEOTIFF=GEOTIFF)
    B4 = READ_TIFF('Band4_TOA_REF.TIF', GEOTIFF=GEOTIFF)
    B5 = READ_TIFF('Band5_TOA_REF.TIF', GEOTIFF=GEOTIFF)
    B7 = READ_TIFF('Band7_TOA_REF.TIF', GEOTIFF=GEOTIFF)
    size_img = size(B1)
    
    ; CONVERT TO REFLECTANCE (FLOAT)   
    B1*=.0001
    B2*=.0001
    B3*=.0001
    B4*=.0001
    B5*=.0001
    B7*=.0001
                       
    unmix = FractionalCover_30_Landsat(B1, B2, B3, B4, B5, B7, ENDMEMBERSWEIGHTED)              
        
    fname= 'Landsat_PV.TIFF'
    WRITE_TIFF, fname, unmix.PV, GEOTIFF=GEOTIFF
    fname= 'Landsat_NPV.TIFF'
    WRITE_TIFF, fname, unmix.NPV, GEOTIFF=GEOTIFF
    fname= 'Landsat_BS.TIFF'
    WRITE_TIFF, fname, unmix.BS, GEOTIFF=GEOTIFF
    
    ; write jpg
    img_png = bytarr(3, size_img[1], size_img[2])
    img_png[0,*,*] = bytscl(unmix.NPV, min=0, max=100)
    img_png[1,*,*] = bytscl(unmix.PV, min=0, max=100)
    img_png[2,*,*] = bytscl(unmix.BS, min=0, max=100)
    ;WRITE_PNG, fname, img_png, /order
    fname= 'Landsat_FC_V3.0.jpg'
    WRITE_JPEG, fname, img_png , TRUE=1, quality=quality, /order
      
end

  