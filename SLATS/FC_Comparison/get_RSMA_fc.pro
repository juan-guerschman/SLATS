function get_RSMA_FC, year, composite
  compile_opt idl2
  
    DIMS=[9580,7451]
    fname_base ='Z:\work\Juan_Pablo\ACEAS\comparison\RSMA\'+ 'MCD43A4.' +$
                year+'.'+composite + '_' 
    fname= fname_base+'gv.bsq'
    RSMA_PV = READ_BINARY(fname, DATA_DIMS=DIMS, Data_Type=2)

    fname= fname_base+'NPV.bsq'
    RSMA_NPV = READ_BINARY(fname, DATA_DIMS=DIMS, Data_Type=2)

    fname= fname_base+'soil.bsq'
    RSMA_BS = READ_BINARY(fname, DATA_DIMS=DIMS, Data_Type=2)
    
    ; find shit values
    where_nan = Where(RSMA_PV gt 32760 or $
                      RSMA_NPV gt 32760 or $
                      RSMA_BS gt 32760, $
                       Complement=Where_ok, count)
                       
    MASK_NAN = RSMA_PV gt 32760 or $
                      RSMA_NPV gt 32760 or $
                      RSMA_BS gt 32760                
 
    RSMA_PV /= 1.
    RSMA_NPV /= 1.
    RSMA_BS /= 1.
    if count ge 1 then RSMA_PV[where_NaN]=!Values.F_NAN
    if count ge 1 then RSMA_NPV[where_NaN]=!Values.F_NAN
    if count ge 1 then RSMA_BS[where_NaN]=!Values.F_NAN
 
    output = CREATE_STRUCT( $
      'PV', RSMA_PV, $
      'NPV', RSMA_NPV, $
      'BS', RSMA_BS, $
      'NaNs', mask_NaN, $
      'where_NAN', where_NAN, $    
      'where_OK', where_OK $    
      )
    
    return, output
end      