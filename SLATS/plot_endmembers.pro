pro plot_endmembers, data=data, threshold=threshold

  folder = 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\plots\'
  cd, folder

  if Keyword_Set(data) eq 0 then $
    Data = read_SLATS_data_new()
    
  n = n_elements(data.field_all.obs_key)  

  ; plot spectra
  MODIS_W = [MODIS_NBAR_WAVELENGHTS(), !VALUES.F_NAN]
  for i=0, n-2 do MODIS_Wavelengths = [[MODIS_NBAR_WAVELENGHTS(), !VALUES.F_NAN],[MODIS_W]]
  Landsat_W = [Landsat_WAVELENGHTS(), !VALUES.F_NAN]
  for i=0, n-2 do Landsat_W = [[Landsat_WAVELENGHTS(), !VALUES.F_NAN],[Landsat_W]]

  MOD09A1_spectra = float(Transpose([[data.MOD09A1.b3], [data.MOD09A1.b4], [data.MOD09A1.b1], $
    [data.MOD09A1.b2], [data.MOD09A1.b5], [data.MOD09A1.b6], [data.MOD09A1.b7], [data.MOD09A1.b7*!VALUES.F_NAN]]))*0.0001
  where_nan=where(MOD09A1_spectra lt 0, count)
  if count ge 1 then MOD09A1_spectra[where_nan] = !VALUES.F_NAN
 
  MCD43A4_spectra = float(Transpose([[data.MCD43A4.b3], [data.MCD43A4.b4], [data.MCD43A4.b1], $
    [data.MCD43A4.b2], [data.MCD43A4.b5], [data.MCD43A4.b6], [data.MCD43A4.b7], [data.MCD43A4.b7*!VALUES.F_NAN]]))*0.0001
  where_nan=where(MCD43A4_spectra lt 0, count)
  if count ge 1 then MCD43A4_spectra[where_nan] = !VALUES.F_NAN

  MOD09A1_spectra = float(Transpose([[data.MOD09A1.b3], [data.MOD09A1.b4], [data.MOD09A1.b1], $
    [data.MOD09A1.b2], [data.MOD09A1.b5], [data.MOD09A1.b6], [data.MOD09A1.b7], [data.MOD09A1.b7*!VALUES.F_NAN]]))*0.0001
  where_nan=where(MOD09A1_spectra lt 0, count)
  if count ge 1 then MOD09A1_spectra[where_nan] = !VALUES.F_NAN
 
  Landsat_3x3_spectra = float(Transpose([[data.Landsat_scaling.b1_3x3], [data.Landsat_scaling.b2_3x3], [data.Landsat_scaling.b3_3x3], $
    [data.Landsat_scaling.b4_3x3], [data.Landsat_scaling.b5_3x3], [data.Landsat_scaling.b6_3x3], [data.Landsat_scaling.b1_3x3*!VALUES.F_NAN]]))
  where_nan=where(Landsat_3x3_spectra lt 0, count)
  if count ge 1 then Landsat_3x3_spectra[where_nan] = !VALUES.F_NAN

  Landsat_40x40_spectra = float(Transpose([[data.Landsat_scaling.b1_40x40], [data.Landsat_scaling.b2_40x40], [data.Landsat_scaling.b3_40x40], $
    [data.Landsat_scaling.b4_40x40], [data.Landsat_scaling.b5_40x40], [data.Landsat_scaling.b6_40x40], [data.Landsat_scaling.b1_40x40*!VALUES.F_NAN]]))
  where_nan=where(Landsat_40x40_spectra lt 0, count)
  if count ge 1 then Landsat_40x40_spectra[where_nan] = !VALUES.F_NAN

  Landsat_BRDF_spectra = float(Transpose([[data.Landsat_QLD.b1], [data.Landsat_QLD.b2], [data.Landsat_QLD.b3], $
    [data.Landsat_QLD.b4], [data.Landsat_QLD.b5], [data.Landsat_QLD.b6], [data.Landsat_QLD.b1*!VALUES.F_NAN]]))
  where_nan=where(Landsat_BRDF_spectra lt 0, count)
  if count ge 1 then Landsat_BRDF_spectra[where_nan] = !VALUES.F_NAN

  ; plot spectra for sites with >threshold cover of a given type
  if Keyword_Set(threshold) eq 0 then $
    threshold = 0.90 
  if Keyword_Set(N_Clusters) eq 0 then $
    N_Clusters = 2 
    
  fname = 'sites_FG_ge_'+StrTrim(threshold, 2)+'.png'
  if (FILE_INFO(fname)).exists eq 0 then begin 
    PS_Start, fname
    FORMAT='(1(F4.2,:,","))'
    cgDisplay, 1500,800
    !P.Multi=[0,5,3] 
    where_spectra = Where(data.Fcover.EXP_PV ge threshold, count_spectra)
    Title = 'PV > ' + String(threshold, FORMAT=FORMAT)
    Subtitle='n='+StrTrim(count_spectra,2)
    xTitle = 'wavelength [um]'
    yTitle='reflectance'
        if count_spectra ge 1 then begin
           cgplot, $
              Landsat_W[*,where_spectra], $
              Landsat_BRDF_spectra[*,where_spectra], $
              psym=-16, symSize=0.5, yRange = [0,0.6], color='Dark Green', $
              title=title+' - Landsat_BRDF', xTitle=xTitle, yTitle=yTitle, subtitle=subtitle
           cgplot, $
              Landsat_W[*,where_spectra], $
              Landsat_3x3_spectra[*,where_spectra], $
              psym=-16, symSize=0.5, yRange = [0,0.6], color='Dark Green', $
              title=title+' - Landsat_3x3', xTitle=xTitle, yTitle=yTitle, subtitle=subtitle
           cgplot, $
              Landsat_W[*,where_spectra], $
              Landsat_40x40_spectra[*,where_spectra], $
              psym=-16, symSize=0.5, yRange = [0,0.6], color='Dark Green', $
              title=title+' - Landsat_40x40', xTitle=xTitle, yTitle=yTitle, subtitle=subtitle
           cgplot, $
              MODIS_W[*,where_spectra], $
              MOD09A1_spectra[*,where_spectra], $
              psym=-16, symSize=0.5, yRange = [0,0.6], color='Dark Green', $
              title=title+' - MOD09A1', xTitle=xTitle, yTitle=yTitle, subtitle=subtitle
           cgplot, $
              MODIS_W[*,where_spectra], $
              MCD43A4_spectra[*,where_spectra], $
              psym=-16, symSize=0.5, yRange = [0,0.6], color='Dark Green', $
              title=title+' - MCD43A4', xTitle=xTitle, yTitle=yTitle, subtitle=subtitle
        EndIf     
    where_spectra = Where(data.Fcover.EXP_NPV ge threshold, count_spectra)
    Title = 'NPV > ' + String(threshold, FORMAT=FORMAT)
    Subtitle='n='+StrTrim(count_spectra,2)
    xTitle = 'wavelength [um]'
    yTitle='reflectance'
        if count_spectra ge 1 then begin
           cgplot, $
              Landsat_W[*,where_spectra], $
              Landsat_BRDF_spectra[*,where_spectra], $
              psym=-16, symSize=0.5, yRange = [0,0.6], color='Goldenrod', $
              title=title+' - Landsat_BRDF', xTitle=xTitle, yTitle=yTitle, subtitle=subtitle
           cgplot, $
              Landsat_W[*,where_spectra], $
              Landsat_3x3_spectra[*,where_spectra], $
              psym=-16, symSize=0.5, yRange = [0,0.6], color='Goldenrod', $
              title=title+' - Landsat_3x3', xTitle=xTitle, yTitle=yTitle, subtitle=subtitle
           cgplot, $
              Landsat_W[*,where_spectra], $
              Landsat_40x40_spectra[*,where_spectra], $
              psym=-16, symSize=0.5, yRange = [0,0.6], color='Goldenrod', $
              title=title+' - Landsat_40x40', xTitle=xTitle, yTitle=yTitle, subtitle=subtitle
           cgplot, $
              MODIS_W[*,where_spectra], $
              MOD09A1_spectra[*,where_spectra], $
              psym=-16, symSize=0.5, yRange = [0,0.6], color='Goldenrod', $
              title=title+' - MOD09A1', xTitle=xTitle, yTitle=yTitle, subtitle=subtitle
           cgplot, $
              MODIS_W[*,where_spectra], $
              MCD43A4_spectra[*,where_spectra], $
              psym=-16, symSize=0.5, yRange = [0,0.6], color='Goldenrod', $
              title=title+' - MCD43A4', xTitle=xTitle, yTitle=yTitle, subtitle=subtitle
        EndIf     
    where_spectra = Where(data.Fcover.EXP_BS ge threshold, count_spectra)
    Title = 'BS > ' + String(threshold, FORMAT=FORMAT)
    Subtitle='n='+StrTrim(count_spectra,2)
    xTitle = 'wavelength [um]'
    yTitle='reflectance'
        if count_spectra ge 1 then begin
           cgplot, $
              Landsat_W[*,where_spectra], $
              Landsat_BRDF_spectra[*,where_spectra], $
              psym=-16, symSize=0.5, yRange = [0,0.6], color='Brown', $
              title=title+' - Landsat_BRDF', xTitle=xTitle, yTitle=yTitle, subtitle=subtitle
           cgplot, $
              Landsat_W[*,where_spectra], $
              Landsat_3x3_spectra[*,where_spectra], $
              psym=-16, symSize=0.5, yRange = [0,0.6], color='Brown', $
              title=title+' - Landsat_3x3', xTitle=xTitle, yTitle=yTitle, subtitle=subtitle
           cgplot, $
              Landsat_W[*,where_spectra], $
              Landsat_40x40_spectra[*,where_spectra], $
              psym=-16, symSize=0.5, yRange = [0,0.6], color='Brown', $
              title=title+' - Landsat_40x40', xTitle=xTitle, yTitle=yTitle, subtitle=subtitle
           cgplot, $
              MODIS_W[*,where_spectra], $
              MOD09A1_spectra[*,where_spectra], $
              psym=-16, symSize=0.5, yRange = [0,0.6], color='Brown', $
              title=title+' - MOD09A1', xTitle=xTitle, yTitle=yTitle, subtitle=subtitle
           cgplot, $
              MODIS_W[*,where_spectra], $
              MCD43A4_spectra[*,where_spectra], $
              psym=-16, symSize=0.5, yRange = [0,0.6], color='Brown', $
              title=title+' - MCD43A4', xTitle=xTitle, yTitle=yTitle, subtitle=subtitle
        EndIf     
    PS_End, /png, resize=100    
  endif

end
  