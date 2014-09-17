pro plot_meanRMSerror

cd, 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\SAGE\plots\subset_data\NEW_20130729\'
fname = 'MeanRMSerror_Landsat_3x3_WeightEQ_-1_no_crypto_subsetData.csv'
L_3x3 = READ_ASCII_FILE(fname, /SURPRESS_MSG)

fname = 'MeanRMSerror_Landsat_9x9_WeightEQ_-1_no_crypto_subsetData.csv'
L_9x9 = READ_ASCII_FILE(fname, /SURPRESS_MSG)

fname = 'MeanRMSerror_Landsat_17x17_WeightEQ_-1_no_crypto_subsetData.csv'
L_17x17 = READ_ASCII_FILE(fname, /SURPRESS_MSG)

fname = 'MeanRMSerror_Landsat_25x25_WeightEQ_-1_no_crypto_subsetData.csv'
L_25x25 = READ_ASCII_FILE(fname, /SURPRESS_MSG)

fname = 'MeanRMSerror_Landsat_33x33_WeightEQ_-1_no_crypto_subsetData.csv'
L_33x33 = READ_ASCII_FILE(fname, /SURPRESS_MSG)

fname = 'MeanRMSerror_Landsat_42x42_WeightEQ_-1_no_crypto_subsetData.csv'
L_42x42 = READ_ASCII_FILE(fname, /SURPRESS_MSG)

fname = 'MeanRMSerror_MCD43A4_WeightEQ_-1_no_crypto_subsetData.csv'
MCD43A4 = READ_ASCII_FILE(fname, /SURPRESS_MSG)

fname = 'MeanRMSerror_MOD09A1_WeightEQ_-1_no_crypto_subsetData.csv'
MOD09A1 = READ_ASCII_FILE(fname, /SURPRESS_MSG)

MODIS_axis= indgen(84)+1
L_axis= indgen(84)+1

fname = 'RMSE_crossValidation.png'
PS_Start, fname
  cgDisplay, 1000,1000
  cgPlot, MODIS_axis, MCD43A4.meanrmserror, thick=2, /xlog, xrange=[1,99], psym=-16, symsize=1, color='red', $
          xtitle='number of singular values', yTitle='RMSE', charsize=1.75, yrange=[0.1,1], ystyle=1, linestyle=1
  cgPlot, MODIS_axis, MOD09A1.meanrmserror, thick=2, /overplot, psym=-16, symsize=1, color='blue', linestyle=1
  cgPlot, MODIS_axis, L_3x3.meanrmserror, thick=2, /overplot, psym=-17, symsize=1, color='dark green'
  ;cgPlot, MODIS_axis, L_9x9.meanrmserror, thick=2, /overplot, psym=-4, symsize=1, color='magenta'
  cgPlot, MODIS_axis, L_17x17.meanrmserror, thick=2, /overplot, psym=-21, symsize=1, color='cyan'
  ;cgPlot, MODIS_axis, L_25x25.meanrmserror, thick=2, /overplot, psym=-1, symsize=1, color='grn5'
  cgPlot, MODIS_axis, L_33x33.meanrmserror, thick=2, /overplot, psym=-37, symsize=1, color='magenta'
  cgPlot, MODIS_axis, L_42x42.meanrmserror, thick=2, /overplot, psym=-16, symsize=1, color='black'
  al_legend, ['Landsat 3x3','Landsat 17x17','Landsat 33x33','Landsat 42x42','MCD43A4','MOD09A1'], $
              psym=[-17, -21, -37, -16, -16, -15], $
              color=['dark green','cyan','magenta','black','red','blue'], $
              linestyle=[0,0,0,0,1,1], $
              /top, /left, box=0, $
              charsize=1.5
PS_End, resize=100, /png            
            

fname = 'RMSE_crossValidation_new.png'
PS_Start, fname
cgDisplay, 1000,1000
cgPlot, MODIS_axis, MCD43A4.meanrmserror, thick=2, /xlog, xrange=[0.9,100], psym=-16, symsize=1, color='red', $
  xtitle='number of singular values', yTitle='RMSE', charsize=1.75, yrange=[0.1,0.8], ystyle=1, linestyle=1
cgPlot, MODIS_axis, MOD09A1.meanrmserror, thick=2, /overplot, psym=-16, symsize=1, color='blue', linestyle=1
cgPlot, MODIS_axis, L_3x3.meanrmserror, thick=2, /overplot, psym=-17, symsize=1, color='dark green'
;cgPlot, MODIS_axis, L_9x9.meanrmserror, thick=2, /overplot, psym=-4, symsize=1, color='magenta'
cgPlot, MODIS_axis, L_17x17.meanrmserror, thick=2, /overplot, psym=-21, symsize=1, color='magenta'
;cgPlot, MODIS_axis, L_25x25.meanrmserror, thick=2, /overplot, psym=-1, symsize=1, color='grn5'
;cgPlot, MODIS_axis, L_33x33.meanrmserror, thick=2, /overplot, psym=-37, symsize=1, color='magenta'
;cgPlot, MODIS_axis, L_42x42.meanrmserror, thick=2, /overplot, psym=-16, symsize=1, color='black'
cglegend, titles=['Landsat 3x3','Landsat 17x17','MCD43A4','MOD09A1'], $
  psyms=[-17, -21, -16, -15], $
  colors=['dark green','magenta','red','blue'], $
  linestyles=[0,0,1,1], $
  alignment=8, box=0, location=[0.5,0.8], $
  charsize=1.5, /center_sym
PS_End, resize=100, /png

            
end
            