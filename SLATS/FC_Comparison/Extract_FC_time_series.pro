pro Extract_FC_time_series 
  compile_opt idl2

  ON_ERROR, 1
  
  years=['2002','2007','2010']
  months=['03','06','09','12']
  composite=['065','161','249','345']

  ; open Land mask 
  DIMS=[9580,7451]
  fname= 'Z:\work\Juan_Pablo\auxiliary\land_mask_australia_MCD43'
  LAND = READ_BINARY(fname, DATA_DIMS=DIMS, Data_Type=1)
  
  ; open drainage basin mask 
  fname= 'Z:\work\Juan_Pablo\ACEAS\comparison\drainage_basins.img'
  DRAINAGE = READ_BINARY(fname, DATA_DIMS=DIMS, Data_Type=1)
  
  fname = 'Z:\work\Juan_Pablo\ACEAS\comparison\drainage_basins.csv'
  OPENW, lun, fname, /GET_LUN
  print, 'source,fraction,year,month,basin,mean' 
  printf, lun, 'source,fraction,year,month,basin,mean' 

  for y = 0,2 do begin
    for m = 0,3 do begin
      
      Landsat = get_Landsat_fc(years[y], months[m])      
      CSIRO_V22 = get_CSIRO_V22_fc(years[y], composite[m])      
      CSIRO_V30 = get_CSIRO_V30_fc(years[y], composite[m])      
      SMA = get_SMA_fc(years[y], composite[m])      
      MESMA = get_MESMA_fc(years[y], composite[m])      

      for d=0, 12 do begin
        IF d eq 0 then $
          where_Drain=WHERE(DRAINAGE NE 0, count) $
        Else $
          where_Drain=WHERE(DRAINAGE eq d, count) 
        
        print, 'Landsat,PV,'+years[y]+','+months[m]+','+strtrim(d,2)+','+strtrim(MEAN(Landsat.pv[where_drain], /nan), 2)
        print, 'Landsat,NPV,'+years[y]+','+months[m]+','+strtrim(d,2)+','+strtrim(MEAN(Landsat.npv[where_drain], /nan), 2)
        print, 'Landsat,BS,'+years[y]+','+months[m]+','+strtrim(d,2)+','+strtrim(MEAN(Landsat.bs[where_drain], /nan), 2)
        print, 'CSIRO_v22,PV,'+years[y]+','+months[m]+','+strtrim(d,2)+','+strtrim(MEAN(CSIRO_v22.pv[where_drain], /nan), 2)
        print, 'CSIRO_v22,NPV,'+years[y]+','+months[m]+','+strtrim(d,2)+','+strtrim(MEAN(CSIRO_v22.npv[where_drain], /nan), 2)
        print, 'CSIRO_v22,BS,'+years[y]+','+months[m]+','+strtrim(d,2)+','+strtrim(MEAN(CSIRO_v22.bs[where_drain], /nan), 2)
        print, 'CSIRO_v30,PV,'+years[y]+','+months[m]+','+strtrim(d,2)+','+strtrim(MEAN(CSIRO_v30.pv[where_drain], /nan), 2)
        print, 'CSIRO_v30,NPV,'+years[y]+','+months[m]+','+strtrim(d,2)+','+strtrim(MEAN(CSIRO_v30.npv[where_drain], /nan), 2)
        print, 'CSIRO_v30,BS,'+years[y]+','+months[m]+','+strtrim(d,2)+','+strtrim(MEAN(CSIRO_v30.bs[where_drain], /nan), 2)
        print, 'SMA,PV,'+years[y]+','+months[m]+','+strtrim(d,2)+','+strtrim(MEAN(SMA.pv[where_drain], /nan), 2)
        print, 'SMA,NPV,'+years[y]+','+months[m]+','+strtrim(d,2)+','+strtrim(MEAN(SMA.npv[where_drain], /nan), 2)
        print, 'SMA,BS,'+years[y]+','+months[m]+','+strtrim(d,2)+','+strtrim(MEAN(SMA.bs[where_drain], /nan), 2)
        print, 'MESMA,PV,'+years[y]+','+months[m]+','+strtrim(d,2)+','+strtrim(MEAN(MESMA.pv[where_drain], /nan), 2)
        print, 'MESMA,NPV,'+years[y]+','+months[m]+','+strtrim(d,2)+','+strtrim(MEAN(MESMA.npv[where_drain], /nan), 2)
        print, 'MESMA,BS,'+years[y]+','+months[m]+','+strtrim(d,2)+','+strtrim(MEAN(MESMA.bs[where_drain], /nan), 2)

        printF, lun, 'Landsat,PV,'+years[y]+','+months[m]+','+strtrim(d,2)+','+strtrim(MEAN(Landsat.pv[where_drain], /nan), 2)
        printF, lun, 'Landsat,NPV,'+years[y]+','+months[m]+','+strtrim(d,2)+','+strtrim(MEAN(Landsat.npv[where_drain], /nan), 2)
        printF, lun, 'Landsat,BS,'+years[y]+','+months[m]+','+strtrim(d,2)+','+strtrim(MEAN(Landsat.bs[where_drain], /nan), 2)
        printF, lun, 'CSIRO_v22,PV,'+years[y]+','+months[m]+','+strtrim(d,2)+','+strtrim(MEAN(CSIRO_v22.pv[where_drain], /nan), 2)
        printF, lun, 'CSIRO_v22,NPV,'+years[y]+','+months[m]+','+strtrim(d,2)+','+strtrim(MEAN(CSIRO_v22.npv[where_drain], /nan), 2)
        printF, lun, 'CSIRO_v22,BS,'+years[y]+','+months[m]+','+strtrim(d,2)+','+strtrim(MEAN(CSIRO_v22.bs[where_drain], /nan), 2)
        printF, lun, 'CSIRO_v30,PV,'+years[y]+','+months[m]+','+strtrim(d,2)+','+strtrim(MEAN(CSIRO_v30.pv[where_drain], /nan), 2)
        printF, lun, 'CSIRO_v30,NPV,'+years[y]+','+months[m]+','+strtrim(d,2)+','+strtrim(MEAN(CSIRO_v30.npv[where_drain], /nan), 2)
        printF, lun, 'CSIRO_v30,BS,'+years[y]+','+months[m]+','+strtrim(d,2)+','+strtrim(MEAN(CSIRO_v30.bs[where_drain], /nan), 2)
        printF, lun, 'SMA,PV,'+years[y]+','+months[m]+','+strtrim(d,2)+','+strtrim(MEAN(SMA.pv[where_drain], /nan), 2)
        printF, lun, 'SMA,NPV,'+years[y]+','+months[m]+','+strtrim(d,2)+','+strtrim(MEAN(SMA.npv[where_drain], /nan), 2)
        printF, lun, 'SMA,BS,'+years[y]+','+months[m]+','+strtrim(d,2)+','+strtrim(MEAN(SMA.bs[where_drain], /nan), 2)
        printF, lun, 'MESMA,PV,'+years[y]+','+months[m]+','+strtrim(d,2)+','+strtrim(MEAN(MESMA.pv[where_drain], /nan), 2)
        printF, lun, 'MESMA,NPV,'+years[y]+','+months[m]+','+strtrim(d,2)+','+strtrim(MEAN(MESMA.npv[where_drain], /nan), 2)
        printF, lun, 'MESMA,BS,'+years[y]+','+months[m]+','+strtrim(d,2)+','+strtrim(MEAN(MESMA.bs[where_drain], /nan), 2)
      
      endfor

    endfor ; m
  endfor   ; y

  close, /all
  
  exit, /no_confirm
 
 end
           
           
           
           