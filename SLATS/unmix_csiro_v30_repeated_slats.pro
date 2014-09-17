pro unmix_CSIRO_V30_repeated_SLATS
  compile_opt idl2 
  
  fname = '\\wron\working\work\Juan_Pablo\PV_NPV_BS\New_Validation\SLATS_sites_MCD43A4_repeat_sites_2.csv'
  MCD43A4 = READ_ASCII_FILE(fname, /SURPRESS_MSG)
  
  B1 = MCD43A4.B1 * 0.0001
  B2 = MCD43A4.B2 * 0.0001
  B3 = MCD43A4.B3 * 0.0001
  B4 = MCD43A4.B4 * 0.0001
  B5 = MCD43A4.B5 * 0.0001
  B6 = MCD43A4.B6 * 0.0001
  B7 = MCD43A4.B7 * 0.0001

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
  
  restore, 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\SAGE\plots\subset_data\NEW_20130729\TransformedReflectance_MCD43A4_WeightEQ_-1_no_crypto_subsetData.SAV'

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
  ;print, ((elapsed)*(count_land/n_pixels*1.0))/3600, ' hours for the whole thing'
  ;print, (elapsed) / n_pixels * 1000.0, ' seconds every 1000 pixels'

  ;write outputs
  fname = 'Z:\work\Juan_Pablo\ACEAS\comparison\SLATS_sites_CSIRO_v30.csv'
  OPENW, lun, fname, /GET_LUN
  PRINTF, lun, 'obs_key,site_name,latitude,longitude,year,month,day,PV,NPV,BS'
      
      FORMATLON   = '(10(I8, :, ", "))'  
      FORMATFLOAT = '(10(f8.4, :, ", "))'  
  
  for i=0, n_elements(b1)-1 do begin
       
      line_print = STRCOMPRESS( $
                    STRING((MCD43A4.obs_key)[i]) + ',' + $
                    STRING((MCD43A4.site_name)[i]) + ',' + $
                    STRING((MCD43A4.latitude)[i]) + ',' + $
                    STRING((MCD43A4.longitude)[i]) + ',' + $
                    STRING((MCD43A4.year)[i]) + ',' + $
                    STRING((MCD43A4.month)[i]) + ',' + $
                    STRING((MCD43A4.day)[i]) + ',' + $
;                    STRING(band) + ',' + $
                    STRING(retrievedCoverFractions[*,i], format=FORMATFLOAT),   $
                    /REMOVE_ALL)                  
       
       PRINTF, lun, line_print              
       ;PRINT ,      line_print              
        
  endfor
  
  close, /all
  
  ;exit, /NO_CONFIRM
end  


