function get_CSIRO_v30_FC, year, composite
  compile_opt idl2
  
    DIMS=[9580,7451]
    fname_base ='Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\SAGE\images\FractCover.V3.0.1.'+ $
                year+'.'+composite+'.aust.005.'  
    fname= fname_base+'PV.img'
    CSIRO_V30_PV = READ_BINARY(fname, DATA_DIMS=DIMS, Data_Type=3)

    fname= fname_base+'NPV.img'
    CSIRO_V30_NPV = READ_BINARY(fname, DATA_DIMS=DIMS, Data_Type=3)

    fname= fname_base+'BS.img'
    CSIRO_V30_BS = READ_BINARY(fname, DATA_DIMS=DIMS, Data_Type=3)
    
    ; find shit values
    where_nan = Where(CSIRO_V30_PV+CSIRO_V30_NPV+CSIRO_V30_BS lt 8000 or $
                       CSIRO_V30_PV+CSIRO_V30_NPV+CSIRO_V30_BS gt 12000, $
                       Complement=Where_ok, count)
    MASK_NAN = CSIRO_V30_PV+CSIRO_V30_NPV+CSIRO_V30_BS lt 8000 or $
               CSIRO_V30_PV+CSIRO_V30_NPV+CSIRO_V30_BS gt 12000                   
 
    CSIRO_v30_PV /= 10000.
    CSIRO_v30_NPV /= 10000.
    CSIRO_v30_BS /= 10000.
    if count ge 1 then CSIRO_v30_PV[where_NaN]=!Values.F_NAN
    if count ge 1 then CSIRO_v30_NPV[where_NaN]=!Values.F_NAN
    if count ge 1 then CSIRO_v30_BS[where_NaN]=!Values.F_NAN
 
    output = CREATE_STRUCT( $
      'PV', CSIRO_v30_PV, $
      'NPV', CSIRO_v30_NPV, $
      'BS', CSIRO_v30_BS, $
      'NaNs', mask_NaN, $
      'where_NAN', where_NAN $    
      )
    
    return, output
end      