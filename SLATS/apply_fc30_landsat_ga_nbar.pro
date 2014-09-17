pro apply_FC30_landsat_GA_NBAR

  folder= 'Z:\work\Juan_Pablo\LANDSAT\GA_NBAR\Widden\'
  cd, folder
  files = FILE_SEARCH('*.jpg')
  restore, 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\SAGE\plots\subset_data\NEW_20130729\TransformedReflectance_Landsat_3x3_WeightEQ_-1_no_crypto_subsetData.SAV'
  quality=100
  
  for i=0, n_elements(files)-1 do begin
    name = StrSplit(files[i], '_.', /extract)
    
    ;read bands
    folder= 'Z:\work\Juan_Pablo\LANDSAT\GA_NBAR\Widden\tiff\'
    cd, folder
  
    B1 = READ_TIFF('Landsat_B1_'+name[2]+'_'+name[3]+'_'+name[4]+'_'+name[5]+'_'+name[6]+'_'+name[7]+'_'+name[8]+'.TIFF', GEOTIFF=GEOTIFF)
    B2 = READ_TIFF('Landsat_B2_'+name[2]+'_'+name[3]+'_'+name[4]+'_'+name[5]+'_'+name[6]+'_'+name[7]+'_'+name[8]+'.TIFF')
    B3 = READ_TIFF('Landsat_B3_'+name[2]+'_'+name[3]+'_'+name[4]+'_'+name[5]+'_'+name[6]+'_'+name[7]+'_'+name[8]+'.TIFF')
    B4 = READ_TIFF('Landsat_B4_'+name[2]+'_'+name[3]+'_'+name[4]+'_'+name[5]+'_'+name[6]+'_'+name[7]+'_'+name[8]+'.TIFF')
    B5 = READ_TIFF('Landsat_B5_'+name[2]+'_'+name[3]+'_'+name[4]+'_'+name[5]+'_'+name[6]+'_'+name[7]+'_'+name[8]+'.TIFF')
    B7 = READ_TIFF('Landsat_B7_'+name[2]+'_'+name[3]+'_'+name[4]+'_'+name[5]+'_'+name[6]+'_'+name[7]+'_'+name[8]+'.TIFF')
    size_img = size(b1)
  
    where_ok = where(B1 GT 0 AND $
                     B2 GT 0 AND $)
                     B3 GT 0 AND $
                     B4 GT 0 AND $
                     B5 GT 0 AND $
                     B7 GT 0, COUNT_OK)
  
    B1=B1[where_ok] * .0001
    B2=B2[where_ok] * .0001
    B3=B3[where_ok] * .0001
    B4=B4[where_ok] * .0001
    B5=B5[where_ok] * .0001 
    B6=B7[where_ok] * .0001     ; watch out!!  I change b7 to b6 
                     
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
    
    ; save bands
    folder= 'Z:\work\Juan_Pablo\LANDSAT\GA_NBAR\Widden\FC\'
    folder_info= FILE_INFO(folder)
    if folder_info.directory eq 0 then FILE_MKDIR, folder
    cd, folder
    
    fname= 'Landsat_PV_'+name[2]+'_'+name[3]+'_'+name[4]+'_'+name[5]+'_'+name[6]+'_'+name[7]+'_'+name[8]+'.TIFF'
    WRITE_TIFF, fname, PV, GEOTIFF=GEOTIFF
    fname= 'Landsat_NPV_'+name[2]+'_'+name[3]+'_'+name[4]+'_'+name[5]+'_'+name[6]+'_'+name[7]+'_'+name[8]+'.TIFF'
    WRITE_TIFF, fname, NPV, GEOTIFF=GEOTIFF
    fname= 'Landsat_BS_'+name[2]+'_'+name[3]+'_'+name[4]+'_'+name[5]+'_'+name[6]+'_'+name[7]+'_'+name[8]+'.TIFF'
    WRITE_TIFF, fname, BS, GEOTIFF=GEOTIFF
    
    ; write jpg
    img_png = bytarr(3, size_img[1], size_img[2])
    img_png[0,*,*] = bytscl(NPV, min=0, max=100)
    img_png[1,*,*] = bytscl(PV, min=0, max=100)
    img_png[2,*,*] = bytscl(BS, min=0, max=100)
    ;WRITE_PNG, fname, img_png, /order
    fname= 'Landsat_FC_V3.0_'+name[2]+'_'+name[3]+'_'+name[4]+'_'+name[5]+'_'+name[6]+'_'+name[7]+'_'+name[8]+'.jpg'
    WRITE_JPEG, fname, img_png , TRUE=1, quality=quality, /order
    
      
  endfor
  
  exit, /No_Confirm

end

  