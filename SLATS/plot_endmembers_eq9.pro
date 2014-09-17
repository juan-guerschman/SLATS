pro plot_endmembers_eq9
  compile_opt idl2
  
  Landsat_Wavelenghts = [485, 560, 660, 830, 1650, 2215]
  MODIS_Wavelenghts = [(459 + 479)/2., $
    (545 + 565)/2., $
    (620 + 670)/2., $
    (841 + 876)/2., $
    (1230 + 1250)/2., $
    (1628 + 1652)/2., $
    (2105 + 2155)/2.]

  cd, 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\SAGE\plots\subset_data\NEW_20130729'
  fname='endmembers_Eq9_Landsat_3x3_WeightEQ_-1_no_crypto_subsetData.csv'
  Landsat_3x3=READ_ASCII_FILE(fname, /SURPRESS_MSG)
  fname='endmembers_Eq9_Landsat_17x17_WeightEQ_-1_no_crypto_subsetData.csv'
  Landsat_17x17=READ_ASCII_FILE(fname, /SURPRESS_MSG)
  fname='endmembers_Eq9_MCD43A4_WeightEQ_-1_no_crypto_subsetData.csv'
  MCD43A4=READ_ASCII_FILE(fname, /SURPRESS_MSG)
  fname='endmembers_Eq9_MOD09A1_WeightEQ_-1_no_crypto_subsetData.csv'
  MOD09A1=READ_ASCII_FILE(fname, /SURPRESS_MSG)
 
  psym=[-6,-9,-17,-14]
  linestyle=[0,0,0,0]
  titles=['Landsat 3x3', 'Landsat 17x17', 'MCD43A4', 'MOD09A1']
  color=['lime green', 'red', 'blue']

  fname='endmembers_Eq9_ALL.png'
  if (FILE_INFO(fname)).exists eq 0 then begin
    cgPS_Open, fname
    cgDisplay, 400, 300
      cgPlot, Landsat_Wavelenghts, Landsat_3x3.PV, Ticklen=0.02, xGridstyle=2, yGridstyle=2, color=color[0], psym=psym[0], thick=2, linestyle=linestyle[0], $
        xTitle='wavelength [nm]', yTitle='Reflectance', yrange=[0,0.45], xrange=[420, 2300]
      cgPlot, Landsat_Wavelenghts, Landsat_17x17.PV, Ticklen=1, xGridstyle=1, yGridstyle=1, color=color[0], psym=psym[1], thick=2, linestyle=linestyle[1], /overplot
      cgPlot, MODIS_Wavelenghts, MCD43A4.PV, Ticklen=1, xGridstyle=1, yGridstyle=1, color=color[0], psym=psym[2], thick=2,linestyle=linestyle[2], /overplot
      cgPlot, MODIS_Wavelenghts, MOD09A1.PV, Ticklen=1, xGridstyle=1, yGridstyle=1, color=color[0], psym=psym[3], thick=2, linestyle=linestyle[3],/overplot
        
      cgPlot, Landsat_Wavelenghts, Landsat_3x3.NPV, Ticklen=1, xGridstyle=1, yGridstyle=1, color=color[1], psym=psym[0], thick=2, linestyle=linestyle[0], /overplot
      cgPlot, Landsat_Wavelenghts, Landsat_17x17.NPV, Ticklen=1, xGridstyle=1, yGridstyle=1, color=color[1], psym=psym[1], thick=2, linestyle=linestyle[1], /overplot
      cgPlot, MODIS_Wavelenghts, MCD43A4.NPV, Ticklen=1, xGridstyle=1, yGridstyle=1, color=color[1], psym=psym[2], thick=2, linestyle=linestyle[2], /overplot
      cgPlot, MODIS_Wavelenghts, MOD09A1.NPV, Ticklen=1, xGridstyle=1, yGridstyle=1, color=color[1], psym=psym[3], thick=2, linestyle=linestyle[3], /overplot


      cgPlot, Landsat_Wavelenghts, Landsat_3x3.BS, Ticklen=1, xGridstyle=1, yGridstyle=1, color=color[2], psym=psym[0], thick=2, linestyle=linestyle[0], /overplot
      cgPlot, Landsat_Wavelenghts, Landsat_17x17.BS, Ticklen=1, xGridstyle=1, yGridstyle=1, color=color[2], psym=psym[1], thick=2, linestyle=linestyle[1], /overplot
      cgPlot, MODIS_Wavelenghts, MCD43A4.BS, Ticklen=1, xGridstyle=1, yGridstyle=1, color=color[2], psym=psym[2], thick=2, linestyle=linestyle[2], /overplot
      cgPlot, MODIS_Wavelenghts, MOD09A1.BS, Ticklen=1, xGridstyle=1, yGridstyle=1, color=color[2], psym=psym[3], thick=2, linestyle=linestyle[3], /overplot

      cgLegend, psyms=psym, titles=titles, LINESTYLES=LINESTYLE, /center_sym, location=[500,0.42], /data
      
     
    cgPS_Close, resize=100;, /PNG
  EndIf

  cd, 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\SAGE\plots\subset_data\NEW_20130729'
  fname='TransformedReflectance_Landsat_3x3_WeightEQ_-1_no_crypto_subsetData.csv'
  Landsat_3x3=READ_ASCII_FILE(fname, /SURPRESS_MSG)
  fname='TransformedReflectance_Landsat_17x17_WeightEQ_-1_no_crypto_subsetData.csv'
  Landsat_17x17=READ_ASCII_FILE(fname, /SURPRESS_MSG)
  fname='TransformedReflectance_MCD43A4_WeightEQ_-1_no_crypto_subsetData.csv'
  MCD43A4=READ_ASCII_FILE(fname, /SURPRESS_MSG)
  fname='TransformedReflectance_MOD09A1_WeightEQ_-1_no_crypto_subsetData.csv'
  MOD09A1=READ_ASCII_FILE(fname, /SURPRESS_MSG)
  
  psym=[6,9,17,14]

  fname='transformed_reflectance_ALL.png'
  if (FILE_INFO(fname)).exists eq 0 then begin
    cgPS_Open, fname
      cgDisplay, 800, 600
      cgPlot, Landsat_3x3.PV, Ticklen=0.02, xGridstyle=2, yGridstyle=2, color=color[0], psym=psym[0], thick=2, linestyle=linestyle[0], $
        xTitle='', yTitle=' ', yrange=[-1,1], xrange=[0, 87]
      cgPlot, Landsat_17x17.PV, Ticklen=1, xGridstyle=1, yGridstyle=1, color=color[0], psym=psym[1], thick=2, linestyle=linestyle[1], /overplot
      cgPlot, MCD43A4.PV, Ticklen=1, xGridstyle=1, yGridstyle=1, color=color[0], psym=psym[2], thick=2,linestyle=linestyle[2], /overplot
      cgPlot, MOD09A1.PV, Ticklen=1, xGridstyle=1, yGridstyle=1, color=color[0], psym=psym[3], thick=2, linestyle=linestyle[3],/overplot
      
      cgPlot, Landsat_3x3.NPV, Ticklen=1, xGridstyle=1, yGridstyle=1, color=color[1], psym=psym[0], thick=2, linestyle=linestyle[0], /overplot
      cgPlot, Landsat_17x17.NPV, Ticklen=1, xGridstyle=1, yGridstyle=1, color=color[1], psym=psym[1], thick=2, linestyle=linestyle[1], /overplot
      cgPlot, MCD43A4.NPV, Ticklen=1, xGridstyle=1, yGridstyle=1, color=color[1], psym=psym[2], thick=2, linestyle=linestyle[2], /overplot
      cgPlot, MOD09A1.NPV, Ticklen=1, xGridstyle=1, yGridstyle=1, color=color[1], psym=psym[3], thick=2, linestyle=linestyle[3], /overplot
      
      
      cgPlot, Landsat_3x3.BS, Ticklen=1, xGridstyle=1, yGridstyle=1, color=color[2], psym=psym[0], thick=2, linestyle=linestyle[0], /overplot
      cgPlot, Landsat_17x17.BS, Ticklen=1, xGridstyle=1, yGridstyle=1, color=color[2], psym=psym[1], thick=2, linestyle=linestyle[1], /overplot
      cgPlot, MCD43A4.BS, Ticklen=1, xGridstyle=1, yGridstyle=1, color=color[2], psym=psym[2], thick=2, linestyle=linestyle[2], /overplot
      cgPlot, MOD09A1.BS, Ticklen=1, xGridstyle=1, yGridstyle=1, color=color[2], psym=psym[3], thick=2, linestyle=linestyle[3], /overplot
      
      cgLegend, psyms=psym, titles=titles, LINESTYLES=LINESTYLE, /center_sym, location=[1,0.9], /data
      
    
    cgPS_Close, resize=100;, /PNG
  EndIf


end
