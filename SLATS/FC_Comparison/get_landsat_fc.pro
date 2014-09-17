function get_Landsat_FC, year, month
  compile_opt idl2
  
  envi, /restore_base_save_files
  envi_batch_init
  

      fname = 'Z:\work\Juan_Pablo\ACEAS\comparison\Landsat\month_'+$
            year+month+'_EPSG-3577_8bit.geographic.img'
      ENVI_OPEN_FILE, fname, R_FID=FID, /NO_REALIZE
      ENVI_FILE_QUERY, FID, DATA_IGNORE_VALUE=DATA_IGNORE_VALUE, XSTART=XSTART, $
        YSTART=YSTART, DEF_STRETCH=DEF_STRETCH, ns=ns, nl=nl, nb=nb, DIMS=DIMS
      Landsat_PV=ENVI_GET_DATA(FID=FID, DIMS=DIMS, POS=1) * 1L  
      Landsat_NPV=ENVI_GET_DATA(FID=FID, DIMS=DIMS, POS=2) * 1L 
      Landsat_BS=ENVI_GET_DATA(FID=FID, DIMS=DIMS, POS=0) * 1L 
      mask_NaN = Landsat_PV+Landsat_NPV+Landsat_BS eq 0
      where_NAN = Where(Landsat_PV+Landsat_NPV+Landsat_BS eq 0, count, COMPLEMENT=Where_OK)
      
      Landsat_PV /= 255.
      Landsat_NPV /= 255.
      Landsat_BS /= 255.
      if count ge 1 then Landsat_PV[where_NaN]=!Values.F_NAN
      if count ge 1 then Landsat_NPV[where_NaN]=!Values.F_NAN
      if count ge 1 then Landsat_BS[where_NaN]=!Values.F_NAN

    output = CREATE_STRUCT( $
      'PV', Landsat_PV, $
      'NPV', Landsat_NPV, $
      'BS', Landsat_BS, $
      'NaNs', mask_NaN, $
      'where_NAN', where_NAN $    
      )
    
    return, output
end      