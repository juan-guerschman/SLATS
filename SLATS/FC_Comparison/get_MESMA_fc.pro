function get_MESMA_FC, year, composite
  compile_opt idl2
  
    DIMS=[9580,7451]
    fname_base ='Z:\work\Juan_Pablo\ACEAS\comparison\MESMA\'+ 'MCD43A4.' +$
                year+'.'+composite + '_' 
    fname= fname_base+'sma_gv.bsq'
    SMA_PV = READ_BINARY(fname, DATA_DIMS=DIMS, Data_Type=2)

    fname= fname_base+'sma_NPV.bsq'
    SMA_NPV = READ_BINARY(fname, DATA_DIMS=DIMS, Data_Type=2)

    fname= fname_base+'sma_soil.bsq'
    SMA_BS = READ_BINARY(fname, DATA_DIMS=DIMS, Data_Type=2)
    
    ; find shit values
    where_nan = Where(SMA_PV gt 32760 or $
                      SMA_NPV gt 32760 or $
                      SMA_BS gt 32760, $
                       Complement=Where_ok, count)
                       
    MASK_NAN = SMA_PV gt 32760 or $
                      SMA_NPV gt 32760 or $
                      SMA_BS gt 32760                
 
    SMA_PV /= 10000.
    SMA_NPV /= 10000.
    SMA_BS /= 10000.
    if count ge 1 then SMA_PV[where_NaN]=!Values.F_NAN
    if count ge 1 then SMA_NPV[where_NaN]=!Values.F_NAN
    if count ge 1 then SMA_BS[where_NaN]=!Values.F_NAN
 
    output = CREATE_STRUCT( $
      'PV', SMA_PV, $
      'NPV', SMA_NPV, $
      'BS', SMA_BS, $
      'NaNs', mask_NaN, $
      'where_NAN', where_NAN, $    
      'where_OK', where_OK $    
      )
    
    return, output
end      