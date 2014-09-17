pro plot_RMSE_cross_calibration

  fname = 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\SAGE\plots\subset_data\MeanRMSerror_MCD43A4_WeightEQ_-1_no_crypto_subsetData.csv'
  MCD43A4= READ_ASCII_FILE(fname, /SURPRESS_MSG)
  
  fname = 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\SAGE\plots\subset_data\MeanRMSerror_MOD09A1_WeightEQ_-1_no_crypto_subsetData.csv'
  MOD09A1= READ_ASCII_FILE(fname, /SURPRESS_MSG)
  
  fname = 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\SAGE\plots\subset_data\MeanRMSerror_Landsat_3x3_WeightEQ_-1_no_crypto_subsetData.csv'
  Landsat_3x3= READ_ASCII_FILE(fname, /SURPRESS_MSG)
  
  fname = 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\SAGE\plots\subset_data\MeanRMSerror_Landsat_40x40_WeightEQ_-1_no_crypto_subsetData.csv'
  Landsat_40x40= READ_ASCII_FILE(fname, /SURPRESS_MSG)
  
  x_mod = indgen(84)+1
  x_Lan = indgen(63)+1
  
  legend = ['Landsat_3x3','Landsat_40x40','MCD43A4','MOD09A1']
  color=['red','blue','magenta','dark green']
  
  print, min(Landsat_3x3.meanrmserror), where(Landsat_3x3.meanrmserror eq min(Landsat_3x3.meanrmserror))
  print, min(Landsat_40x40.meanrmserror), where(Landsat_40x40.meanrmserror eq min(Landsat_40x40.meanrmserror))
  print, min(MCD43A4.meanrmserror), where(MCD43A4.meanrmserror eq min(MCD43A4.meanrmserror))
  print, min(MOD09A1.meanrmserror), where(MOD09A1.meanrmserror eq min(MOD09A1.meanrmserror))

  fname = 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\SAGE\plots\subset_data\MeanRMSError_Xlog.png'
  PS_Start, fname
    cgDisplay, 300, 300 
    cgPlot, x_mod,  Landsat_3x3.meanrmserror, xTitle='number of singular values', yTitle='RMSE', color=color[0], /xlog
    cgPlot, x_mod,  Landsat_40x40.meanrmserror, /overplot, color=color[1], /xlog
    cgPlot, x_Lan,  MCD43A4.meanrmserror, /overplot, color=color[2], /xlog
    cgPlot, x_Lan,  MOD09A1.meanrmserror, /overplot, color=color[3], /xlog
    al_legend, legend, colors=color, psym=[-3,-3,-3,-3], /bottom, /left, box=0
  PS_End, resize=100, /png

  fname = 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\SAGE\plots\subset_data\MeanRMSError.png'
  PS_Start, fname
    cgDisplay, 300, 300 
    cgPlot, x_mod,  Landsat_3x3.meanrmserror, xTitle='number of singular values', yTitle='RMSE', color=color[0] 
    cgPlot, x_mod,  Landsat_40x40.meanrmserror, /overplot, color=color[1] 
    cgPlot, x_Lan,  MCD43A4.meanrmserror, /overplot, color=color[2] 
    cgPlot, x_Lan,  MOD09A1.meanrmserror, /overplot, color=color[3] 
    al_legend, legend, colors=color, psym=[-3,-3,-3,-3], /bottom, /left, box=0
  PS_End, resize=100, /png

end
