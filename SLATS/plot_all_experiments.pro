pro plot_all_experiments
  compile_opt idl2
  
  fname='Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\SAGE\results_sage_Experiments.csv'
  data= READ_ASCII_FILE(fname, /SURPRESS_MSG)
  
  
  !P.multi=0
  pos=[0.2,0.2,0.9,0.9]
  names=[' ','L3x3', 'L9x9','L17x17','L25x25','L33x33', $ 
          'L42x42','MCD43A4', 'MOD09A1',' ']
  names=replicate(' ',10)
  x_axis=indgen(8)+1
  thick=3
  
  cd, 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\SAGE\plots\subset_data\NEW_20130729\'
   
  fname='ALL_models_r.png'
  PS_Start, fname
    cgDisplay, 1000, 1000
    cgPlot, x_axis,(data.PV_r)[0:5], psym=-16, color='lime green', thick=thick, symsize=2, $
            yRange=[0.6,0.95], xRange=[0,9], xstyle=1, XTICKNAME = NAMES, xTICKINTERVAL=1, xTICKLAYOUT=0, $
            yStyle=1, $;yTicks=6, 
            pos=pos, charsize=1.75, yTitle='correlation (r)', XMINOR=1, xGridstyle=1, yGridstyle=1, XTHICK=0.5, yTHICK=0.5, Ticklen=.5
    cgPlot, x_axis,(data.NPV_r)[0:5], psym=-16, color='red', thick=thick, symsize=2, /overplot
    cgPlot, x_axis,(data.BS_r)[0:5], psym=-16, color='blue', thick=thick, symsize=2, /overplot
  
    cgPlot, [7,8],(data.PV_r)[6:7], psym=16, color='lime green', thick=thick, symsize=2, /overplot
    cgPlot, [7,8],(data.NPV_r)[6:7], psym=16, color='red', thick=thick, symsize=2, /overplot
    cgPlot, [7,8],(data.BS_r)[6:7], psym=16, color='blue', thick=thick, symsize=2, /overplot
    
    cgText, 1, 0.6, 'L$\down3x3$', orientation=90, alignment=1.1, charsize=1.75
    cgText, 2, 0.6, 'L$\down9x9$', orientation=90, alignment=1.1, charsize=1.75
    cgText, 3, 0.6, 'L$\down17x17$', orientation=90, alignment=1.1, charsize=1.75
    cgText, 4, 0.6, 'L$\down25x25$', orientation=90, alignment=1.1, charsize=1.75
    cgText, 5, 0.6, 'L$\down33x33$', orientation=90, alignment=1.1, charsize=1.75
    cgText, 6, 0.6, 'L$\down42x42$', orientation=90, alignment=1.1, charsize=1.75
    cgText, 7, 0.6, 'MCD43A4', orientation=90, alignment=1.1, charsize=1.75
    cgText, 8, 0.6, 'MOD09A1', orientation=90, alignment=1.1, charsize=1.75
    
    al_Legend, ['PV', 'NPV', 'BS'], psym=[16, 16, 16], color=['lime green', 'red', 'blue'], symsize=2, $
                /top, /right, box=0, charsize=1.75
  PS_End, resize=100, /png


  fname='ALL_models_rmse.png'
  PS_Start, fname
    cgDisplay, 800, 800
    cgPlot, x_axis,(data.PV_RMSE)[0:5], psym=-16, color='lime green', thick=thick, symsize=2, $
            yRange=[0.10,0.21], xRange=[0,9], xstyle=1, XTICKNAME = NAMES, xTICKINTERVAL=1, xTICKLAYOUT=0, $
            yStyle=1, $;yTicks=6, 
            pos=pos, charsize=1.75, yTitle='RMSE', XMINOR=1, xGridstyle=1, yGridstyle=1, XTHICK=0.5, yTHICK=0.5, Ticklen=.5
    cgPlot, x_axis,(data.NPV_RMSE)[0:5], psym=-16, color='red', thick=thick, symsize=2, /overplot
    cgPlot, x_axis,(data.BS_RMSE)[0:5], psym=-16, color='blue', thick=thick, symsize=2, /overplot
  
    cgPlot, [7,8],(data.PV_RMSE)[6:7], psym=16, color='lime green', thick=thick, symsize=2, /overplot
    cgPlot, [7,8],(data.NPV_RMSE)[6:7], psym=16, color='red', thick=thick, symsize=2, /overplot
    cgPlot, [7,8],(data.BS_RMSE)[6:7], psym=16, color='blue', thick=thick, symsize=2, /overplot
    
    cgText, 1, 0.1, 'L$\down3x3$', orientation=90, alignment=1.1, charsize=1.75
    cgText, 2, 0.1, 'L$\down9x9$', orientation=90, alignment=1.1, charsize=1.75
    cgText, 3, 0.1, 'L$\down17x17$', orientation=90, alignment=1.1, charsize=1.75
    cgText, 4, 0.1, 'L$\down25x25$', orientation=90, alignment=1.1, charsize=1.75
    cgText, 5, 0.1, 'L$\down33x33$', orientation=90, alignment=1.1, charsize=1.75
    cgText, 6, 0.1, 'L$\down42x42$', orientation=90, alignment=1.1, charsize=1.75
    cgText, 7, 0.1, 'MCD43A4', orientation=90, alignment=1.1, charsize=1.75
    cgText, 8, 0.1, 'MOD09A1', orientation=90, alignment=1.1, charsize=1.75

    al_Legend, ['PV', 'NPV', 'BS'], psym=[16, 16, 16], color=['lime green', 'red', 'blue'], symsize=2, $
                /top, /right, box=0, charsize=1.75
  PS_end, resize=100, /png

  fname='ALL_models_new_r.png'
  PS_Start, fname
    subLandsat=[0,2]
    cgDisplay, 1000, 1000
    cgPlot, x_axis,(data.PV_r)[subLandsat], psym=-16, color='lime green', thick=thick, symsize=2, $
      yRange=[0.6,0.95], xRange=[0,5], xstyle=1, XTICKNAME = NAMES, xTICKINTERVAL=1, xTICKLAYOUT=0, $
      yStyle=1, $;yTicks=6,
      pos=pos, charsize=1.75, yTitle='correlation (r)', XMINOR=1, xGridstyle=1, yGridstyle=1, XTHICK=0.5, yTHICK=0.5, Ticklen=.5
    cgPlot, x_axis,(data.NPV_r)[subLandsat], psym=-16, color='red', thick=thick, symsize=2, /overplot
    cgPlot, x_axis,(data.BS_r)[subLandsat], psym=-16, color='blue', thick=thick, symsize=2, /overplot
    
    cgPlot, [3,4],(data.PV_r)[6:7], psym=16, color='lime green', thick=thick, symsize=2, /overplot
    cgPlot, [3,4],(data.NPV_r)[6:7], psym=16, color='red', thick=thick, symsize=2, /overplot
    cgPlot, [3,4],(data.BS_r)[6:7], psym=16, color='blue', thick=thick, symsize=2, /overplot
    
    cgText, 1, 0.6, 'L$\down3x3$', orientation=90, alignment=1.1, charsize=1.75
    ;cgText, 2, 0.6, 'L$\down9x9$', orientation=90, alignment=1.1, charsize=1.75
    cgText, 2, 0.6, 'L$\down17x17$', orientation=90, alignment=1.1, charsize=1.75
    ;cgText, 4, 0.6, 'L$\down25x25$', orientation=90, alignment=1.1, charsize=1.75
    ;cgText, 5, 0.6, 'L$\down33x33$', orientation=90, alignment=1.1, charsize=1.75
    ;cgText, 6, 0.6, 'L$\down42x42$', orientation=90, alignment=1.1, charsize=1.75
    cgText, 3, 0.6, 'MCD43A4', orientation=90, alignment=1.1, charsize=1.75
    cgText, 4, 0.6, 'MOD09A1', orientation=90, alignment=1.1, charsize=1.75
    
    al_Legend, ['PV', 'NPV', 'BS'], psym=[16, 16, 16], color=['lime green', 'red', 'blue'], symsize=2, $
      /top, /right, box=1, charsize=1.75
  PS_End, resize=100, /png
  
  
  fname='ALL_models_new_rmse.png'
  PS_Start, fname
    subLandsat=[0,2]
    cgDisplay, 800, 800
    cgPlot, x_axis,(data.PV_RMSE)[subLandsat], psym=-16, color='lime green', thick=thick, symsize=2, $
      yRange=[0.10,0.21], xRange=[0,5], xstyle=1, XTICKNAME = NAMES, xTICKINTERVAL=1, xTICKLAYOUT=0, $
      yStyle=1, $;yTicks=6,
      pos=pos, charsize=1.75, yTitle='RMSE', XMINOR=1, xGridstyle=1, yGridstyle=1, XTHICK=0.5, yTHICK=0.5, Ticklen=.5
    cgPlot, x_axis,(data.NPV_RMSE)[subLandsat], psym=-16, color='red', thick=thick, symsize=2, /overplot
    cgPlot, x_axis,(data.BS_RMSE)[subLandsat], psym=-16, color='blue', thick=thick, symsize=2, /overplot
    
    cgPlot, [3,4],(data.PV_RMSE)[6:7], psym=16, color='lime green', thick=thick, symsize=2, /overplot
    cgPlot, [3,4],(data.NPV_RMSE)[6:7], psym=16, color='red', thick=thick, symsize=2, /overplot
    cgPlot, [3,4],(data.BS_RMSE)[6:7], psym=16, color='blue', thick=thick, symsize=2, /overplot
    
    cgText, 1, 0.1, 'L$\down3x3$', orientation=90, alignment=1.1, charsize=1.75
    ;cgText, 2, 0.1, 'L$\down9x9$', orientation=90, alignment=1.1, charsize=1.75
    cgText, 2, 0.1, 'L$\down17x17$', orientation=90, alignment=1.1, charsize=1.75
    ;cgText, 4, 0.1, 'L$\down25x25$', orientation=90, alignment=1.1, charsize=1.75
    ;cgText, 5, 0.1, 'L$\down33x33$', orientation=90, alignment=1.1, charsize=1.75
    ;cgText, 6, 0.1, 'L$\down42x42$', orientation=90, alignment=1.1, charsize=1.75
    cgText, 3, 0.1, 'MCD43A4', orientation=90, alignment=1.1, charsize=1.75
    cgText, 4, 0.1, 'MOD09A1', orientation=90, alignment=1.1, charsize=1.75
    
    al_Legend, ['PV', 'NPV', 'BS'], psym=[16, 16, 16], color=['lime green', 'red', 'blue'], symsize=2, $
      /top, /right, box=1, charsize=1.75
  PS_end, resize=100, /png

  
  
end

  