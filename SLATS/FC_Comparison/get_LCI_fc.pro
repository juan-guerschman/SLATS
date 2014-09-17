function get_LCI_FC, year, composite
  compile_opt idl2

    envi, /restore_base_save_files
    envi_batch_init
  
    ;open land mask 
    fname = '\\wron\Working\work\Juan_Pablo\auxiliary\land_mask_australia_MCD43'
    DIMS = [9580, 7451]
    LAND = READ_Binary(fname, DATA_dims=dims, data_type=1) 
    
    fname ='Z:\work\Juan_Pablo\ACEAS\comparison\LCI\'+ 'LCI_' + $
                year+composite+'.TIF'  
      ENVI_OPEN_FILE, fname, R_FID=FID, /NO_REALIZE
      ENVI_FILE_QUERY, FID, DATA_IGNORE_VALUE=DATA_IGNORE_VALUE, XSTART=XSTART, $
        YSTART=YSTART, DEF_STRETCH=DEF_STRETCH, ns=ns, nl=nl, nb=nb, DIMS=DIMS
      LCI=ENVI_GET_DATA(FID=FID, DIMS=DIMS, POS=0) 
      
      mask_NaN = Land eq 0 OR LCI lt -100
      where_NAN = Where(mask_NaN eq 1, count, COMPLEMENT=Where_OK)
    if count ge 1 then LCI[where_NaN]=!Values.F_NAN
  
    output = CREATE_STRUCT( $
      'PV', -1, $
      'NPV', -1, $
      'BS', LCI, $
      'NaNs', mask_NaN, $
      'where_NAN', where_NAN, $
      'where_OK',  Where_OK  $
      )
    
    return, output
end      