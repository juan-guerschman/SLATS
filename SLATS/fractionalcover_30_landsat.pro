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
    
    ; reconstruct arrays - only if original files of 2 dimensions
    if size_img[0] EQ 2 then begin
      PV = bytarr(size_img[1],size_img[2]) & PV[*]=255
      NPV = bytarr(size_img[1],size_img[2]) & NPV[*]=255
      BS = bytarr(size_img[1],size_img[2]) & BS[*]=255
    ENDIF ELSE BEGIN
      PV = bytarr(size_img[1]) & PV[*]=255
      NPV = bytarr(size_img[1]) & NPV[*]=255
      BS = bytarr(size_img[1]) & BS[*]=255
    ENDELSE
  
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
