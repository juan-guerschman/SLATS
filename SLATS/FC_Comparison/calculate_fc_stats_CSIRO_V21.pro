pro calculate_fc_stats_CSIRO_V21
  compile_opt idl2
  
  year = ['2002','2007','2010']
  month=['03','06','09','12']
  composite=['065','161','249','345']
  
  print, 'start making big arrays'
  PV = fltarr(9580,7451,12)
  NPV = fltarr(9580,7451,12)
  BS = fltarr(9580,7451,12)
  print, 'finished making big arrays'
  
  for year_n = 0,2 do begin
    for month_n = 0,3 do begin
      n= year_n*4+month_n
      print, year_n, month_n, n 

      img = get_CSIRO_v21_FC(year[year_n], composite[month_n])
      PV_n = img.PV & PV_n[img.where_nan]=!Values.f_nan & PV[*,*,n] = PV_n
      NPV_n = img.NPV & NPV_n[img.where_nan]=!Values.f_nan & NPV[*,*,n] = NPV_n
      BS_n = img.BS & BS_n[img.where_nan]=!Values.f_nan & BS[*,*,n] = BS_n
    
    endfor 
  endfor  
  
  PV_mean = MEAN(PV, DIMENSION=3, /NAN)
  NPV_mean = MEAN(NPV, DIMENSION=3, /NAN)
  BS_mean = MEAN(BS, DIMENSION=3, /NAN)
  
  envi, /restore_base_save_files
  envi_batch_init
  
  fname = 'Z:\work\Juan_Pablo\ACEAS\comparison\csiro_fc\CSIRO_V21_PV_mean.img'
  ENVI_WRITE_ENVI_FILE, PV_mean, OUT_Name=fname
  
  fname = 'Z:\work\Juan_Pablo\ACEAS\comparison\csiro_fc\CSIRO_V21_NPV_mean.img'
  ENVI_WRITE_ENVI_FILE, NPV_mean, OUT_Name=fname

  fname = 'Z:\work\Juan_Pablo\ACEAS\comparison\csiro_fc\CSIRO_V21_BS_mean.img'
  ENVI_WRITE_ENVI_FILE, BS_mean, OUT_Name=fname
  

end 

