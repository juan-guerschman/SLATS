pro plot_reflectances, data=data

  if Keyword_Set(data) eq 0 then $
    Data = read_SLATS_data_new()
  
  MCD43A4_B1 = DATA.MCD43A4.B1 * .0001
  MCD43A4_B2 = DATA.MCD43A4.B2 * .0001
  MCD43A4_B3 = DATA.MCD43A4.B3 * .0001
  MCD43A4_B4 = DATA.MCD43A4.B4 * .0001
  MCD43A4_B5 = DATA.MCD43A4.B5 * .0001
  MCD43A4_B6 = DATA.MCD43A4.B6 * .0001
  MCD43A4_B7 = DATA.MCD43A4.B7 * .0001
  MCD43A4_B1[Where(MCD43A4_B1 lt 0)]=!VALUES.F_NAN
  MCD43A4_B2[Where(MCD43A4_B2 lt 0)]=!VALUES.F_NAN
  MCD43A4_B3[Where(MCD43A4_B3 lt 0)]=!VALUES.F_NAN
  MCD43A4_B4[Where(MCD43A4_B4 lt 0)]=!VALUES.F_NAN
  MCD43A4_B5[Where(MCD43A4_B5 lt 0)]=!VALUES.F_NAN
  MCD43A4_B6[Where(MCD43A4_B6 lt 0)]=!VALUES.F_NAN
  MCD43A4_B7[Where(MCD43A4_B7 lt 0)]=!VALUES.F_NAN

  MOD09A1_B1 = DATA.MOD09A1.B1 * .0001
  MOD09A1_B2 = DATA.MOD09A1.B2 * .0001
  MOD09A1_B3 = DATA.MOD09A1.B3 * .0001
  MOD09A1_B4 = DATA.MOD09A1.B4 * .0001
  MOD09A1_B5 = DATA.MOD09A1.B5 * .0001
  MOD09A1_B6 = DATA.MOD09A1.B6 * .0001
  MOD09A1_B7 = DATA.MOD09A1.B7 * .0001
  MOD09A1_B1[Where(MOD09A1_B1 lt 0)]=!VALUES.F_NAN
  MOD09A1_B2[Where(MOD09A1_B2 lt 0)]=!VALUES.F_NAN
  MOD09A1_B3[Where(MOD09A1_B3 lt 0)]=!VALUES.F_NAN
  MOD09A1_B4[Where(MOD09A1_B4 lt 0)]=!VALUES.F_NAN
  MOD09A1_B5[Where(MOD09A1_B5 lt 0)]=!VALUES.F_NAN
  MOD09A1_B6[Where(MOD09A1_B6 lt 0)]=!VALUES.F_NAN
  MOD09A1_B7[Where(MOD09A1_B7 lt 0)]=!VALUES.F_NAN

  Landsat_3x3_B1 = DATA.Landsat_Scaling.B1_3x3  
  Landsat_3x3_B2 = DATA.Landsat_Scaling.B2_3x3  
  Landsat_3x3_B3 = DATA.Landsat_Scaling.B3_3x3  
  Landsat_3x3_B4 = DATA.Landsat_Scaling.B4_3x3 
  Landsat_3x3_B5 = DATA.Landsat_Scaling.B5_3x3 
  Landsat_3x3_B6 = DATA.Landsat_Scaling.B6_3x3  

  Landsat_40x40_B1 = DATA.Landsat_Scaling.B1_40x40  
  Landsat_40x40_B2 = DATA.Landsat_Scaling.B2_40x40  
  Landsat_40x40_B3 = DATA.Landsat_Scaling.B3_40x40  
  Landsat_40x40_B4 = DATA.Landsat_Scaling.B4_40x40 
  Landsat_40x40_B5 = DATA.Landsat_Scaling.B5_40x40 
  Landsat_40x40_B6 = DATA.Landsat_Scaling.B6_40x40  

  cgDisplay, 1500,1000
  !P.Multi=[0,7,6]
  xtitle='MCD43A4' & yTitle='MOD09A1'
  cgPlot, MCD43A4_B1, MOD09A1_B1, psym=16, symsize=0.2, xTitle=xTitle, yTitle=yTitle
    cgPlot, [-1,2],[-1,2], /overplot
    oplot_regress, MCD43A4_B1, MOD09A1_B1, /NAN, /NO_EQUATION
  cgPlot, MCD43A4_B2, MOD09A1_B2, psym=16, symsize=0.2, xTitle=xTitle, yTitle=yTitle
    cgPlot, [-1,2],[-1,2], /overplot
    oplot_regress, MCD43A4_B2, MOD09A1_B2, /NAN, /NO_EQUATION
  cgPlot, MCD43A4_B3, MOD09A1_B3, psym=16, symsize=0.2, xTitle=xTitle, yTitle=yTitle
    cgPlot, [-1,2],[-1,2], /overplot
    oplot_regress, MCD43A4_B3, MOD09A1_B3, /NAN, /NO_EQUATION
  cgPlot, MCD43A4_B4, MOD09A1_B4, psym=16, symsize=0.2, xTitle=xTitle, yTitle=yTitle
    cgPlot, [-1,2],[-1,2], /overplot
    oplot_regress, MCD43A4_B4, MOD09A1_B4, /NAN, /NO_EQUATION
  cgPlot, MCD43A4_B5, MOD09A1_B5, psym=16, symsize=0.2, xTitle=xTitle, yTitle=yTitle
    cgPlot, [-1,2],[-1,2], /overplot
    oplot_regress, MCD43A4_B5, MOD09A1_B5, /NAN, /NO_EQUATION
  cgPlot, MCD43A4_B6, MOD09A1_B6, psym=16, symsize=0.2, xTitle=xTitle, yTitle=yTitle
    cgPlot, [-1,2],[-1,2], /overplot
    oplot_regress, MCD43A4_B6, MOD09A1_B6, /NAN, /NO_EQUATION
  cgPlot, MCD43A4_B7, MOD09A1_B7, psym=16, symsize=0.2, xTitle=xTitle, yTitle=yTitle
    cgPlot, [-1,2],[-1,2], /overplot
    oplot_regress, MCD43A4_B7, MOD09A1_B7, /NAN, /NO_EQUATION
    
    
  cgPlot, MCD43A4_B1, Landsat_40x40_B3, psym=16, symsize=0.2
  cgPlot, MCD43A4_B2, Landsat_40x40_B4, psym=16, symsize=0.2
  cgPlot, MCD43A4_B3, Landsat_40x40_B1, psym=16, symsize=0.2
  cgPlot, MCD43A4_B4, Landsat_40x40_B2, psym=16, symsize=0.2
  cgPlot, MCD43A4_B6, Landsat_40x40_B5, psym=16, symsize=0.2
  cgPlot, MCD43A4_B7, Landsat_40x40_B6, psym=16, symsize=0.2


end