function get_CSIRO_v22_FC, year, composite
  compile_opt idl2
  
      fname='\\wron\RemoteSensing\MODIS\products\Guerschman_etal_RSE2009\data\v2.2\'+$
            year+'\FractCover.V2_2.'+$
            year+'.'+composite+'.aust.005.BS.img.gz'
      CSIRO_v22_BS = GET_Zipped_envi(fname, 'c:\temp\temp.img')
      fname='\\wron\RemoteSensing\MODIS\products\Guerschman_etal_RSE2009\data\v2.2\'+$
            year+'\FractCover.V2_2.'+$
            year+'.'+composite+'.aust.005.PV.img.gz'
      CSIRO_v22_PV = GET_Zipped_envi(fname, 'c:\temp\temp.img')
      fname='\\wron\RemoteSensing\MODIS\products\Guerschman_etal_RSE2009\data\v2.2\'+$
            year+'\FractCover.V2_2.'+$
            year+'.'+composite+'.aust.005.NPV.img.gz'
      CSIRO_v22_NPV = GET_Zipped_envi(fname, 'c:\temp\temp.img')
   
      where_NAN = Where(CSIRO_v22_PV gt 200 OR $
                  CSIRO_v22_NPV gt 200 OR $
                  CSIRO_v22_BS gt 200, count, COMPLEMENT=Where_OK)
      
      MASK_NAN = CSIRO_v22_PV gt 200 OR $
                  CSIRO_v22_NPV gt 200 OR $
                  CSIRO_v22_BS gt 200            
      
      CSIRO_v22_PV /= 100.
      CSIRO_v22_NPV /= 100.
      CSIRO_v22_BS /= 100.
      if count ge 1 then CSIRO_v22_PV[where_NaN]=!Values.F_NAN
      if count ge 1 then CSIRO_v22_NPV[where_NaN]=!Values.F_NAN
      if count ge 1 then CSIRO_v22_BS[where_NaN]=!Values.F_NAN

 
    output = CREATE_STRUCT( $
      'PV', CSIRO_v22_PV, $
      'NPV', CSIRO_v22_NPV, $
      'BS', CSIRO_v22_BS, $
      'NaNs', mask_NaN, $
      'where_NAN', where_NAN $    
      )
    
    return, output
end      