pro plot_spectra, data=data
  
  if Keyword_Set(data) eq 0 then $
    Data = read_SLATS_data_new()
    
   folder = 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\validation_existing_model\reflectance_plots\'
   CD, folder 
    
  Landsat_Wavelenghts = [485, 560, 660, 830, 1650, 2215]
  MODIS_Wavelenghts = [(459 + 479)/2., $
                        (545 + 565)/2., $
                        (620 + 670)/2., $
                        (841 + 876)/2., $
                        (1230 + 1250)/2., $
                        (1628 + 1652)/2., $
                        (2105 + 2155)/2.]
                        
  for i=0, n_elements(data.Field_all.obs_key)-1 do begin
    fname = (data.Field_all.obs_key)[i]+'__'+(data.Field_all.site)[i]+'__reflectances.png'
    if (File_Info(fname)).exists eq 0 then begin
      Landsat_3x3 = [(Data.Landsat_scaling.b1_3x3)[i], $
                     (Data.Landsat_scaling.b2_3x3)[i], $
                     (Data.Landsat_scaling.b3_3x3)[i], $
                     (Data.Landsat_scaling.b4_3x3)[i], $
                     (Data.Landsat_scaling.b5_3x3)[i], $
                     (Data.Landsat_scaling.b6_3x3)[i]] 
      Landsat_40x40=[(Data.Landsat_scaling.b1_40x40)[i], $
                     (Data.Landsat_scaling.b2_40x40)[i], $
                     (Data.Landsat_scaling.b3_40x40)[i], $
                     (Data.Landsat_scaling.b4_40x40)[i], $
                     (Data.Landsat_scaling.b5_40x40)[i], $
                     (Data.Landsat_scaling.b6_40x40)[i]] 
      MCD43A4 =     [(Data.MCD43A4.b3)[i], $
                     (Data.MCD43A4.b4)[i], $
                     (Data.MCD43A4.b1)[i], $
                     (Data.MCD43A4.b2)[i], $
                     (Data.MCD43A4.b5)[i], $
                     (Data.MCD43A4.b6)[i], $
                     (Data.MCD43A4.b7)[i]] * 0.0001
      MOD09A1 =     [(Data.MOD09A1.b3)[i], $
                     (Data.MOD09A1.b4)[i], $
                     (Data.MOD09A1.b1)[i], $
                     (Data.MOD09A1.b2)[i], $
                     (Data.MOD09A1.b5)[i], $
                     (Data.MOD09A1.b6)[i], $
                     (Data.MOD09A1.b7)[i]] * 0.0001
      WHERE_nan = Where(MCD43A4 lt 0, count)
      if count ge 1 then MCD43A4[WHERE_nan] = !VALUES.F_NAN
             
      WHERE_nan = Where(MOD09A1 lt 0, count)
      if count ge 1 then MCD43A4[MOD09A1] = !VALUES.F_NAN  
      
      
      
      PS_Start, fname
        xRange=[300,2400]
        yRange=[0, 0.6]
        cgDisplay, 300, 300 
        cgPlot, Landsat_Wavelenghts, [0,0,0,0,0,0], /nodata, xTitle='wavelength [nm]', yTitle='reflectance', $
                xRange=xRange, yRange=yRange, xStyle=1, yStyle=1 
        if Total(finite(Landsat_3x3)) ge 1 then $
           cgPlot, Landsat_Wavelenghts, Landsat_3x3, color='black', thick=4, psym=-16, /overplot
        if Total(finite(Landsat_40x40)) ge 1 then $
           cgPlot, Landsat_Wavelenghts, Landsat_40x40, color='red', thick=2, psym=-16, /overplot
        if Total(finite(MCD43A4)) ge 1 then $
           cgPlot, MODIS_Wavelenghts, MCD43A4, color='blue', thick=2, psym=-16, /overplot
        if Total(finite(MOD09A1)) ge 1 then $
           cgPlot, MODIS_Wavelenghts, MOD09A1, color='dark green', thick=2, psym=-16, /overplot
        al_legend, ['Landsat 90m','Landsat 1000m','MCD43A4','MOD09A1'], colors=['black','red','blue','dark green'], $
                    psym=[-16,-16,-16,-16]
      PS_End, /png, resize=100      
    
    endif
     
  endfor

end
      