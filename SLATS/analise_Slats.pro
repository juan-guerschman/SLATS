pro Analise_SLATS
  compile_opt idl2

  ; read field data and MODIS 
  Field_data = sat_fpar_anal_get_FC_field_data(N_MODELS=1)
  Orig_data  = READ_ASCII_FILE('\\wron\working\work\Juan_Pablo\PV_NPV_BS\New_Validation\GC_master_2012July10.csv', /SURPRESS_MSG)
  fname = '\\wron\Working\work\Juan_Pablo\PV_NPV_BS\New_Validation\fractional_landsat_subsets\landsat_subsets_500pix_summary.csv'
  LANDSAT_Qld = READ_ASCII_FILE(fname, /SURPRESS_MSG)
  MCD43A4_data= READ_ASCII_FILE('\\wron\working\work\Juan_Pablo\PV_NPV_BS\New_Validation\GC_MCD43A4_2012July10.csv', /SURPRESS_MSG)
  MOD09A1_data= READ_ASCII_FILE('\\wron\working\work\Juan_Pablo\PV_NPV_BS\New_Validation\GC_MOD09A1_Landsat_21Nov20122.csv', /SURPRESS_MSG)
  BILO_rain  = READ_ASCII_FILE('\\wron\working\work\Juan_Pablo\PV_NPV_BS\New_Validation\GC_BILO_rain_2012Nov14.csv', /SURPRESS_MSG)
  
  output_folder = '\\wron\working\work\Juan_Pablo\PV_NPV_BS\New_Validation\plots\'
  
  plot_map=                 1
  PV_NPV_scatterplot=       0
  PV_NPV_BS_Histograms=     0
  plot_rainfall=            0
  obs_estim=                0
  plot_triangle=            0
  plot_spectra_PV_NPV=      0 
  plot_spectra_endmembers=  0
  plot_MCD43A4_MOD09A1=     0
  ;---------------------------------------------------------------------------------------
  ; some descriptive stats
  ;; plot map with points
  if plot_map eq 1 then begin
    AusCoastline=auscoastline()
    cgWindow, 'cgPlot', field_data.longitude, field_data.latitude, $
              psym=9, symsize=0.5, xRange=[112, 155], yRange=[-45, -10], xStyle=1, yStyle=1 
    cgWindow, 'cgPlot', Landsat_Qld.st_X, Landsat_Qld.st_Y, $
              psym=9, symsize=0.5, /overplot, color='blue', /addcmd
    cgWindow, 'cgPlot', AusCoastline.lon, AusCoastline.lat,  $
              color='red', psym=-3, thick=2, /OVERPLOT, /addcmd
    Filename = output_folder+'field_location_map.png'
    WID=cgQuery(/CURRENT)        
    dummy = cgSnapshot(Filename = Filename, wid=wid,/PNG, /NODIALOG)
  endif   
  
  ; plot observations
  if PV_NPV_scatterplot eq 1 then begin
    cgWindow, 'cgPlot', Field_data.TOTAL_PV_FC, Field_data.TOTAL_NPV_FC, psym=1, xTitle='exposed PV', yTitle='exposed NPV', /isotropic 
    Filename = output_folder+'PV_NPV_scatterplot.png'
    WID=cgQuery(/CURRENT)        
    dummy = cgSnapshot(Filename = Filename, wid=wid,/PNG, /NODIALOG)
  endif 
  
  if PV_NPV_BS_Histograms eq 1 then begin
    cgWindow, WMulti=[0,3,1], wxsize=800, wysize=400 
    cgWindow, 'cgHistoplot', Field_data.TOTAL_PV_FC, color='dark green', /FillPolygon,  $
              xTitle='exposed PV', yTitle='Density', Charsize=2, /addcmd
    cgWindow, 'cgHistoplot', Field_data.TOTAL_NPV_FC, color='red', /FillPolygon , $
              xTitle='exposed NPV', yTitle='Density', Charsize=2, /addcmd
    cgWindow, 'cgHistoplot', Field_data.TOTAL_BS_FC, color='blue', /FillPolygon,  $
              xTitle='exposed BS', yTitle='Density', Charsize=2, /addcmd
    Filename = output_folder+'PV_NPV_BS_Histograms.png'
    WID=cgQuery(/CURRENT)        
    dummy = cgSnapshot(Filename = Filename, wid=wid,/PNG, /NODIALOG)
  ENDIF
    
  ; plot some graphs showing rainfall and spectra
  if plot_rainfall eq 1 then begin
    rain1 = bilo_rain.dayminus1
    rain2 = bilo_rain.dayminus1+bilo_rain.dayminus2
    rain3 = bilo_rain.dayminus1+bilo_rain.dayminus2+bilo_rain.dayminus3
    rain4 = bilo_rain.dayminus1+bilo_rain.dayminus2+bilo_rain.dayminus3+bilo_rain.dayminus4
    rain5 = bilo_rain.dayminus1+bilo_rain.dayminus2+bilo_rain.dayminus3+bilo_rain.dayminus4+bilo_rain.dayminus5
    rain6 = bilo_rain.dayminus1+bilo_rain.dayminus2+bilo_rain.dayminus3+bilo_rain.dayminus4+bilo_rain.dayminus5+bilo_rain.dayminus6
    cgWindow, wmulti=[0,3,2]
    cgwindow, 'cgplot', rain1, MCD43A4_data.b5, psym=1, yrange = [0,6000], /addcmd, color='black'
    cgwindow, 'cgplot', rain1, MCD43A4_data.b6, psym=1, yrange = [0,6000], /addcmd, color='blue', /overplot
    cgwindow, 'cgplot', rain1, MCD43A4_data.b7, psym=1, yrange = [0,6000], /addcmd, color='red', /overplot
  
    cgwindow, 'cgplot', rain2, MCD43A4_data.b5, psym=1, yrange = [0,6000], /addcmd, color='black'
    cgwindow, 'cgplot', rain2, MCD43A4_data.b6, psym=1, yrange = [0,6000], /addcmd, color='blue', /overplot
    cgwindow, 'cgplot', rain2, MCD43A4_data.b7, psym=1, yrange = [0,6000], /addcmd, color='red', /overplot
  
    cgwindow, 'cgplot', rain3, MCD43A4_data.b5, psym=1, yrange = [0,6000], /addcmd, color='black'
    cgwindow, 'cgplot', rain3, MCD43A4_data.b6, psym=1, yrange = [0,6000], /addcmd, color='blue', /overplot
    cgwindow, 'cgplot', rain3, MCD43A4_data.b7, psym=1, yrange = [0,6000], /addcmd, color='red', /overplot
  
    cgwindow, 'cgplot', rain4, MCD43A4_data.b5, psym=1, yrange = [0,6000], /addcmd, color='black'
    cgwindow, 'cgplot', rain4, MCD43A4_data.b6, psym=1, yrange = [0,6000], /addcmd, color='blue', /overplot
    cgwindow, 'cgplot', rain4, MCD43A4_data.b7, psym=1, yrange = [0,6000], /addcmd, color='red', /overplot
    
    cgwindow, 'cgplot', rain5, MCD43A4_data.b5, psym=1, yrange = [0,6000], /addcmd, color='black'
    cgwindow, 'cgplot', rain5, MCD43A4_data.b6, psym=1, yrange = [0,6000], /addcmd, color='blue', /overplot
    cgwindow, 'cgplot', rain5, MCD43A4_data.b7, psym=1, yrange = [0,6000], /addcmd, color='red', /overplot
    
    cgwindow, 'cgplot', rain6, MCD43A4_data.b5, psym=1, yrange = [0,6000], /addcmd, color='black'
    cgwindow, 'cgplot', rain6, MCD43A4_data.b6, psym=1, yrange = [0,6000], /addcmd, color='blue', /overplot
    cgwindow, 'cgplot', rain6, MCD43A4_data.b7, psym=1, yrange = [0,6000], /addcmd, color='red', /overplot
  endif  
  
  
  ; apply fractional cover method to the NBAR data and keep in structure
  MOD09A1_data.b2 *= 1.0
  NDVI = ((MOD09A1_data.b2 - MOD09A1_data.b1 * 1.0) / (MOD09A1_data.b2 + MOD09A1_data.b1))  
  SR76 = MOD09A1_data.b7 * 1.0 / MOD09A1_data.b6  
  where_bad_data = where(MOD09A1_data.b1 le 0 $
                    OR MOD09A1_data.b2 le 0 $
                    OR MOD09A1_data.b3 le 0 $
                    OR MOD09A1_data.b4 le 0 $
                    OR MOD09A1_data.b5 le 0 $
                    OR MOD09A1_data.b6 le 0 $
                    OR MOD09A1_data.b7 le 0, count_bad_data)
  print, count_bad_data,' observations with at least one band le 0'     
               
  unmix = unmix_nbar(NDVI, SR76)
  unmix_recal = unmix_nbar_recalibrated(NDVI, SR76)
  
  if count_bad_data ge 1 then NDVI[where_bad_data] = !VALUES.F_NAN
  if count_bad_data ge 1 then SR76[where_bad_data] = !VALUES.F_NAN
  if count_bad_data ge 1 then unmix[*,where_bad_data] = !VALUES.F_NAN
  if count_bad_data ge 1 then unmix_recal[*,where_bad_data] = !VALUES.F_NAN
  
  PV    = unmix[0,*]
  NPV   = unmix[1,*]
  BS    = unmix[2,*]
  PV_recal    = unmix_recal[0,*]
  NPV_recal   = unmix_recal[1,*]
  BS_recal    = unmix_recal[2,*]
   
  ; plot triangle
  if plot_triangle eq 1 then begin
    triangle_01 = [[ 0.8014 , 0.297 , 0.17, 0.8014],[ 0.3176 , 0.49 , 1.02, 0.3176]] 
    triangle_02 = [[0.900326082, 0.091675384, 0.156659779, 0.900326082],[0.4, 0.671454581, 1.099804103, 0.4]]
    one_one = [-10, 10]
    cgWindow, 'cgPlot', triangle_01[*,0], triangle_01[*,1], /nodata, xTitle='NDVI MCD43A4', yTITLE='band 7/6 MCD43A4'
    cgWindow, 'cgPlot', ndvi, sr76, psym = 9, /addcmd, /overplot
    cgWindow, 'cgPlot', triangle_01[*,0], triangle_01[*,1], psym = -6, color='red', /addcmd, /overplot
    cgWindow, 'cgPlot', triangle_02[*,0], triangle_02[*,1], psym = -6, color='blue', /addcmd, /overplot
    Filename = output_folder+'MOD09A1_NDVI_SR76.Scatterplot.png'
    WID=cgQuery(/CURRENT)        
    dummy = cgSnapshot(Filename = Filename, wid=wid,/PNG, /NODIALOG)
  endif
  
  ; plot observed and estimated fractions
  if obs_estim eq 1 then begin
    cgWindow, Wmulti = [0,3,2]
    cgWindow, 'cgPlot', Field_data.TOTAL_PV_FC, PV, xTitle='PV Observed', yTITLE='PV Model', color='dark green', psym = 9, /addcmd, CharSize=2 
    cgWindow, 'cgPlot', one_one, one_one, psym = -3, /overplot, /addcmd
    cgWindow, 'cgPlot', Field_data.TOTAL_NPV_FC, NPV, xTitle='NPV Observed', yTITLE='NPV Model', color='red', psym = 9, /addcmd, CharSize=2 
    cgWindow, 'cgPlot', one_one, one_one, psym = -3, /overplot, /addcmd
    cgWindow, 'cgPlot', Field_data.TOTAL_BS_FC, BS, xTitle='BS Observed', yTITLE='BS Model', color='blue', psym=9, /addcmd, CharSize=2 
    cgWindow, 'cgPlot', one_one, one_one, psym=-3, /overplot, /addcmd
    
    ; plot observed and estimated fractions - Recalibrated model
    ;cgWindow, Wmulti = [0,3,1]
    cgWindow, 'cgPlot', Field_data.TOTAL_PV_FC, PV_recal, xTitle='PV Observed', yTITLE='PV Model recal', color='dark green', psym=9, /addcmd, CharSize=2 
    cgWindow, 'cgPlot', one_one, one_one, psym=-3, /overplot, /addcmd
    cgWindow, 'cgPlot', Field_data.TOTAL_NPV_FC, NPV_recal, xTitle='NPV Observed', yTITLE='NPV Model recal', color='red', psym=9, /addcmd, CharSize=2 
    cgWindow, 'cgPlot', one_one, one_one, psym=-3, /overplot, /addcmd
    cgWindow, 'cgPlot', Field_data.TOTAL_BS_FC, BS_recal, xTitle='BS Observed', yTITLE='BS Model recal', color='blue', psym=9, /addcmd, CharSize=2 
    cgWindow, 'cgPlot', one_one, one_one, psym=-3, /overplot, /addcmd
    Filename = output_folder+'MOD09A1_Validation_two_models.png'
    WID=cgQuery(/CURRENT)        
    dummy = cgSnapshot(Filename = Filename, wid=wid,/PNG, /NODIALOG)
  endif
  
  
  ; plot spectra
  MODIS_Wavelengths = [MODIS_NBAR_WAVELENGHTS(), !VALUES.F_NAN]
  for i=0, 895 do MODIS_Wavelengths = [[MODIS_NBAR_WAVELENGHTS(), !VALUES.F_NAN],[MODIS_Wavelengths]]
  ;MODIS_Wavelengths = Transpose(MODIS_Wavelengths)
  MOD09A1_spectra = [[MOD09A1_data.b3], [MOD09A1_data.b4], [MOD09A1_data.b1], [MOD09A1_data.b2], [MOD09A1_data.b5], [MOD09A1_data.b6], [MOD09A1_data.b7], [MOD09A1_data.b7*!VALUES.F_NAN]]
  MOD09A1_spectra = float(Transpose(MOD09A1_spectra))
  MOD09A1_spectra[*,where_bad_data] = !VALUES.F_NAN
  MCD43A4_spectra = [[MCD43A4_data.b3], [MCD43A4_data.b4], [MCD43A4_data.b1], [MCD43A4_data.b2], [MCD43A4_data.b5], [MCD43A4_data.b6], [MCD43A4_data.b7], [MCD43A4_data.b7*!VALUES.F_NAN]]
  MCD43A4_spectra = float(Transpose(MCD43A4_spectra))
  MCD43A4_spectra[*,where_bad_data] = !VALUES.F_NAN

  ; plot spectra for sites with >threshold cover of a given type
  threshold = 0.90 
  if plot_spectra_endmembers eq 1 then begin 
    FORMAT='(1(F3.1,:,","))'
    cgWindow, wMulti=[0,2,3],wxsize=1200, wysize= 800
    where_spectra = Where(Field_data.TOTAL_PV_FC ge threshold, count_spectra)
    Title = 'PV > ' + String(threshold, FORMAT=FORMAT)
    xTitle = 'wavelength'
        if count_spectra ge 1 then begin
           cgWindow, 'cgplot', $
              MODIS_Wavelengths[*,where_spectra], $
              MOD09A1_spectra[*,where_spectra], $
              psym = -8, symSize=0.5, yRange = [0, 6000] , CharSize=2, color='Dark Green', $
              title=title+' - MOD09A1', xTitle=xTitle , /addcmd 
           cgWindow, 'cgplot', $
              MODIS_Wavelengths[*,where_spectra], $
              MCD43A4_spectra[*,where_spectra], $
              psym = -8, symSize=0.5, yRange = [0, 6000] , CharSize=2, color='Dark Green', $
              title=title+' - MCD43A4', xTitle=xTitle , /addcmd 
        EndIf     
    where_spectra = Where(Field_data.TOTAL_NPV_FC ge threshold, count_spectra)
    Title = 'NPV > ' + String(threshold, FORMAT=FORMAT)
    xTitle = 'wavelength'
        if count_spectra ge 1 then begin
           cgWindow, 'cgplot', $
              MODIS_Wavelengths[*,where_spectra], $
              MOD09A1_spectra[*,where_spectra], $
              psym = -8, symSize=0.5, yRange = [0, 6000] , CharSize=2, color='Red', $
              title=title+' - MOD09A1', xTitle=xTitle , /addcmd 
           cgWindow, 'cgplot', $
              MODIS_Wavelengths[*,where_spectra], $
              MCD43A4_spectra[*,where_spectra], $
              psym = -8, symSize=0.5, yRange = [0, 6000] , CharSize=2, color='Red', $
              title=title+' - MCD43A4', xTitle=xTitle , /addcmd 
        EndIf     
    where_spectra = Where(Field_data.TOTAL_BS_FC ge threshold, count_spectra)
    Title = 'BS > ' + String(threshold, FORMAT=FORMAT)
    xTitle = 'wavelength'
        if count_spectra ge 1 then begin
           cgWindow, 'cgplot', $
              MODIS_Wavelengths[*,where_spectra], $
              MOD09A1_spectra[*,where_spectra], $
              psym = -8, symSize=0.5, yRange = [0, 6000] , CharSize=2, color='Blue', $
              title=title+' - MOD09A1', xTitle=xTitle , /addcmd 
           cgWindow, 'cgplot', $
              MODIS_Wavelengths[*,where_spectra], $
              MCD43A4_spectra[*,where_spectra], $
              psym = -8, symSize=0.5, yRange = [0, 6000] , CharSize=2, color='Blue', $
              title=title+' - MCD43A4', xTitle=xTitle , /addcmd 
        EndIf        
  endif
  
  
  
  if plot_spectra_PV_NPV eq 1 then begin 
    FORMAT='(1(F3.1,:,","))'
    cgWindow, wMulti=[0,10,10],wxsize=1600, wysize= 1000
    for NPV=9, 0, -1 do begin
      for PV=0,9,1 do begin
    ;    cgWindow 
        j= NPV * 0.1
        i= PV  * 0.1
        where_spectra = Where(Field_data.TOTAL_PV_FC ge i AND Field_data.TOTAL_PV_FC le i+0.1 AND $
                              Field_data.TOTAL_NPV_FC ge j AND Field_data.TOTAL_NPV_FC le j+0.1, count_spectra)
        title= String(i, FORMAT=FORMAT)+'<PV<'+String(i+0.1, FORMAT=FORMAT) + ' & '+ $
               String(j, FORMAT=FORMAT)+'<NPV<'+String(j+0.1, FORMAT=FORMAT)
        xTitle = 'n='+String(count_spectra, FORMAT='(1(I3))')       
        if count_spectra ge 1 then $
           cgWindow, 'cgplot', $
              MODIS_Wavelengths[*,where_spectra], $
              MOD09A1_spectra[*,where_spectra], $
              psym = -8, symSize=0.5, yRange = [0, 6000] , CharSize=1.2 , $
              title=title, xTitle=xTitle , /addcmd $
        else $
           cgWindow, 'cgplot', $
              MODIS_Wavelengths, $
              MOD09A1_spectra, $
              psym = -8, symSize=0.5, yRange = [0, 6000] , CharSize=1.2 , $
              title=title,xTitle=xTitle, /NoData, /addcmd
      endfor & endfor
    Filename = output_folder+'MOD09A1_spectra_PV_NPV.png'
    WID=cgQuery(/CURRENT)        
    dummy = cgSnapshot(Filename = Filename, wid=wid,/PNG, /NODIALOG)
  ENDIF          


  if plot_MCD43A4_MOD09A1 eq 1 then begin 
    cgWindow, wmulti=[0,3,3]
    one_one = [-10, 10000]
    where_ok = Where(MOD09A1_data.b1 gt 0 and MCD43A4_data.b1 gt 0, count)
    cgWindow, 'cgPlot', (MOD09A1_data.b1)[where_ok], (MCD43A4_data.b1)[where_ok], psym=9, $
      symsize=0.4, xRange=[0,6000],  yRange=[0,6000], xtitle='MOD09A1.b1', ytitle='MCD43A4.b1', /addcmd, charsize=2
    cgWindow, 'cgPlot', one_one, one_one, psym=-3, /overplot, /addcmd
  
    where_ok = Where(MOD09A1_data.b2 gt 0 and MCD43A4_data.b2 gt 0, count)
    cgWindow, 'cgPlot', (MOD09A1_data.b2)[where_ok], (MCD43A4_data.b2)[where_ok], psym=9, $
      symsize=0.4, xRange=[0,6000],  yRange=[0,6000], xtitle='MOD09A1.b2', ytitle='MCD43A4.b2', /addcmd, charsize=2
    cgWindow, 'cgPlot', one_one, one_one, psym=-3, /overplot, /addcmd

    where_ok = Where(MOD09A1_data.b3 gt 0 and MCD43A4_data.b3 gt 0, count)
    cgWindow, 'cgPlot', (MOD09A1_data.b3)[where_ok], (MCD43A4_data.b3)[where_ok], psym=9, $
      symsize=0.4, xRange=[0,6000],  yRange=[0,6000], xtitle='MOD09A1.b3', ytitle='MCD43A4.b3', /addcmd, charsize=2
    cgWindow, 'cgPlot', one_one, one_one, psym=-3, /overplot, /addcmd

    where_ok = Where(MOD09A1_data.b4 gt 0 and MCD43A4_data.b4 gt 0, count)
    cgWindow, 'cgPlot', (MOD09A1_data.b4)[where_ok], (MCD43A4_data.b4)[where_ok], psym=9, $
      symsize=0.4, xRange=[0,6000],  yRange=[0,6000], xtitle='MOD09A1.b4', ytitle='MCD43A4.b4', /addcmd, charsize=2
    cgWindow, 'cgPlot', one_one, one_one, psym=-3, /overplot, /addcmd

    where_ok = Where(MOD09A1_data.b5 gt 0 and MCD43A4_data.b5 gt 0, count)
    cgWindow, 'cgPlot', (MOD09A1_data.b5)[where_ok], (MCD43A4_data.b5)[where_ok], psym=9, $
      symsize=0.4, xRange=[0,6000],  yRange=[0,6000], xtitle='MOD09A1.b5', ytitle='MCD43A4.b5', /addcmd, charsize=2
    cgWindow, 'cgPlot', one_one, one_one, psym=-3, /overplot, /addcmd

    where_ok = Where(MOD09A1_data.b6 gt 0 and MCD43A4_data.b6 gt 0, count)
    cgWindow, 'cgPlot', (MOD09A1_data.b6)[where_ok], (MCD43A4_data.b6)[where_ok], psym=9, $
      symsize=0.4, xRange=[0,6000],  yRange=[0,6000], xtitle='MOD09A1.b6', ytitle='MCD43A4.b6', /addcmd, charsize=2
    cgWindow, 'cgPlot', one_one, one_one, psym=-3, /overplot, /addcmd

    where_ok = Where(MOD09A1_data.b7 gt 0 and MCD43A4_data.b7 gt 0, count)
    cgWindow, 'cgPlot', (MOD09A1_data.b7)[where_ok], (MCD43A4_data.b7)[where_ok], psym=9, $
      symsize=0.4, xRange=[0,6000],  yRange=[0,6000], xtitle='MOD09A1.b7', ytitle='MCD43A4.b7', /addcmd, charsize=2
    cgWindow, 'cgPlot', one_one, one_one, psym=-3, /overplot, /addcmd
    
    NDVI_MOD09A1 = ((MOD09A1_data.b2 - MOD09A1_data.b1 * 1.0) / (MOD09A1_data.b2 + MOD09A1_data.b1))  
    SR76_MOD09A1 = MOD09A1_data.b7 * 1.0 / MOD09A1_data.b6  
    NDVI_MCD43A4 = ((MCD43A4_data.b2 - MCD43A4_data.b1 * 1.0) / (MCD43A4_data.b2 + MCD43A4_data.b1))  
    SR76_MCD43A4 = MCD43A4_data.b7 * 1.0 / MCD43A4_data.b6  
    
    where_ok = Where(NDVI_MOD09A1 gt 0 and NDVI_MCD43A4 gt 0, count)
    cgWindow, 'cgPlot', (NDVI_MOD09A1)[where_ok], (NDVI_MCD43A4)[where_ok], psym=9, $
      symsize=0.4, xRange=[0,1],  yRange=[0,1], xtitle='NDVI_MOD09A1', ytitle='NDVI_MCD43A4', /addcmd, charsize=2
    cgWindow, 'cgPlot', one_one, one_one, psym=-3, /overplot, /addcmd

    where_ok = Where(SR76_MOD09A1 gt 0 and SR76_MCD43A4 gt 0, count)
    cgWindow, 'cgPlot', (SR76_MOD09A1)[where_ok], (SR76_MCD43A4)[where_ok], psym=9, $
      symsize=0.4, xRange=[0,1],  yRange=[0,1], xtitle='SR76_MOD09A1', ytitle='SR76_MCD43A4', /addcmd, charsize=2
    cgWindow, 'cgPlot', one_one, one_one, psym=-3, /overplot, /addcmd
  endif  

stop

  

end

 