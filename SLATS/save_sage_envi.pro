pro save_sage_envi

  envi, /restore_base_save_files
  envi_batch_init

  ;open the following image and extract header info (particularly MAP_INFO )
  fname = '\\wron\Working\work\Juan_Pablo\MOD09A1.005\header_issue\MOD09A1.2009.001.aust.005.b01.500m_0620_0670nm_refl.img'
  ENVI_OPEN_FILE , fname , R_FID = FID_dummy, /NO_REALIZE
  ENVI_FILE_QUERY, FID_dummy, DATA_IGNORE_VALUE=DATA_IGNORE_VALUE, XSTART=XSTART, YSTART=YSTART, DEF_STRETCH=DEF_STRETCH, ns=ns, nl=nl
  projection = ENVI_GET_PROJECTION(FID=FID_dummy)
  MAP_INFO = ENVI_GET_MAP_INFO(FID=FID_dummy)


  restore, 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\SAGE\images\unmixed_test.SAV'


  fname= 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\SAGE\images\MCD43A4_3Endmembers_green.img'
  ENVI_WRITE_ENVI_FILE, green, OUT_NAME = fname, MAP_INFO = MAP_INFO, R_FID=FID_PV   
  
  fname= 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\SAGE\images\MCD43A4_3Endmembers_nonGreen.img'
  ENVI_WRITE_ENVI_FILE, nongreen, OUT_NAME = fname, MAP_INFO = MAP_INFO, R_FID=FID_PV   

  fname= 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\SAGE\images\MCD43A4_3Endmembers_bare.img'
  ENVI_WRITE_ENVI_FILE, bare, OUT_NAME = fname, MAP_INFO = MAP_INFO, R_FID=FID_PV   

  fname= 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\SAGE\images\MCD43A4_3Endmembers_total.img'
  ENVI_WRITE_ENVI_FILE, green+nongreen+bare, OUT_NAME = fname, MAP_INFO = MAP_INFO, R_FID=FID_PV   


  EXIT, /NO_CONFIRM

end


