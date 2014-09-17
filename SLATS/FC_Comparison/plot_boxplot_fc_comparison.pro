pro plot_boxPlot_FC_comparison

    folder = 'Z:\work\Juan_Pablo\ACEAS\comparison\stats\'
    cd, folder
    
    fname = 'statistics.csv'
    stats = READ_ASCII_FILE(fname, /SURPRESS_MSG)

    ; arrange array for boxplot
    r_array = fltarr(25, 38)  
    
    r_array[0,*] = (stats.pearson_r_PV)[where(stats.site ne 'ALL' and stats.model eq 'QLD_JRSP_LANDSAT_TOA')]
    r_array[1,*] = (stats.pearson_r_NPV)[where(stats.site ne 'ALL' and stats.model eq 'QLD_JRSP_LANDSAT_TOA')]
    r_array[2,*] = (stats.pearson_r_BS)[where(stats.site ne 'ALL' and stats.model eq 'QLD_JRSP_LANDSAT_TOA')]
    r_array[3,*] = 10
    r_array[4,*] = (stats.pearson_r_PV)[where(stats.site ne 'ALL' and stats.model eq 'CSIRO_V2_2')]
    r_array[5,*] = (stats.pearson_r_NPV)[where(stats.site ne 'ALL' and stats.model eq 'CSIRO_V2_2')]
    r_array[6,*] = (stats.pearson_r_BS)[where(stats.site ne 'ALL' and stats.model eq 'CSIRO_V2_2')]
    r_array[7,*] = 10
    r_array[8,*] = (stats.pearson_r_PV)[where(stats.site ne 'ALL' and stats.model eq 'CSIRO_V3_0')]
    r_array[9,*] = (stats.pearson_r_NPV)[where(stats.site ne 'ALL' and stats.model eq 'CSIRO_V3_0')]
    r_array[10,*] = (stats.pearson_r_BS)[where(stats.site ne 'ALL' and stats.model eq 'CSIRO_V3_0')]
    r_array[11,*] = 10
    r_array[12,*] = (stats.pearson_r_PV)[where(stats.site ne 'ALL' and stats.model eq 'OKIN_SMA')]
    r_array[13,*] = (stats.pearson_r_NPV)[where(stats.site ne 'ALL' and stats.model eq 'OKIN_SMA')]
    r_array[14,*] = (stats.pearson_r_BS)[where(stats.site ne 'ALL' and stats.model eq 'OKIN_SMA')]
    r_array[15,*] = 10
    r_array[16,*] = (stats.pearson_r_PV)[where(stats.site ne 'ALL' and stats.model eq 'OKIN_MESMA')]
    r_array[17,*] = (stats.pearson_r_NPV)[where(stats.site ne 'ALL' and stats.model eq 'OKIN_MESMA')]
    r_array[18,*] = (stats.pearson_r_BS)[where(stats.site ne 'ALL' and stats.model eq 'OKIN_MESMA')]
    r_array[19,*] = 10
    r_array[20,*] = (stats.pearson_r_PV)[where(stats.site ne 'ALL' and stats.model eq 'OKIN_RSMA')]
    r_array[21,*] = (stats.pearson_r_NPV)[where(stats.site ne 'ALL' and stats.model eq 'OKIN_RSMA')]
    r_array[22,*] = (stats.pearson_r_BS)[where(stats.site ne 'ALL' and stats.model eq 'OKIN_RSMA')]
    r_array[23,*] = 10
    r_array[24,*] = ((stats.pearson_r_BS)[where(stats.site ne 'ALL' and stats.model eq 'Uni_Ade_LCI')]) * (-1)

    where_PV=[0,4,8,12,16,20]
    r_array_PV = r_array * 0 & r_array_PV[where_PV, *]=1  
    where_NPV=where_PV+1
    r_array_NPV = r_array * 0 & r_array_NPV[where_NPV, *]=1
    where_BS=[where_NPV+1,24]
    r_array_BS = r_array * 0 & r_array_BS[where_BS, *]=1

    ; arrange array for boxplot
    rmse_array = fltarr(25, 38)  
    
    rmse_array[0,*] = (stats.RMSE_PV)[where(stats.site ne 'ALL' and stats.model eq 'QLD_JRSP_LANDSAT_TOA')]
    rmse_array[1,*] = (stats.RMSE_NPV)[where(stats.site ne 'ALL' and stats.model eq 'QLD_JRSP_LANDSAT_TOA')]
    rmse_array[2,*] = (stats.RMSE_BS)[where(stats.site ne 'ALL' and stats.model eq 'QLD_JRSP_LANDSAT_TOA')]
    rmse_array[3,*] = 1000
    rmse_array[4,*] = (stats.RMSE_PV)[where(stats.site ne 'ALL' and stats.model eq 'CSIRO_V2_2')]
    rmse_array[5,*] = (stats.RMSE_NPV)[where(stats.site ne 'ALL' and stats.model eq 'CSIRO_V2_2')]
    rmse_array[6,*] = (stats.RMSE_BS)[where(stats.site ne 'ALL' and stats.model eq 'CSIRO_V2_2')]
    rmse_array[7,*] = 1000
    rmse_array[8,*] = (stats.RMSE_PV)[where(stats.site ne 'ALL' and stats.model eq 'CSIRO_V3_0')]
    rmse_array[9,*] = (stats.RMSE_NPV)[where(stats.site ne 'ALL' and stats.model eq 'CSIRO_V3_0')]
    rmse_array[10,*] = (stats.RMSE_BS)[where(stats.site ne 'ALL' and stats.model eq 'CSIRO_V3_0')]
    rmse_array[11,*] = 1000
    rmse_array[12,*] = (stats.RMSE_PV)[where(stats.site ne 'ALL' and stats.model eq 'OKIN_SMA')]
    rmse_array[13,*] = (stats.RMSE_NPV)[where(stats.site ne 'ALL' and stats.model eq 'OKIN_SMA')]
    rmse_array[14,*] = (stats.RMSE_BS)[where(stats.site ne 'ALL' and stats.model eq 'OKIN_SMA')]
    rmse_array[15,*] = 1000
    rmse_array[16,*] = (stats.RMSE_PV)[where(stats.site ne 'ALL' and stats.model eq 'OKIN_MESMA')]
    rmse_array[17,*] = (stats.RMSE_NPV)[where(stats.site ne 'ALL' and stats.model eq 'OKIN_MESMA')]
    rmse_array[18,*] = (stats.RMSE_BS)[where(stats.site ne 'ALL' and stats.model eq 'OKIN_MESMA')]
    rmse_array[19:24,*] = 1000
;    rmse_array[16,*] = (stats.RMSE_PV)[where(stats.site ne 'ALL' and stats.model eq 'OKIN_RSMA')]
;    rmse_array[17,*] = (stats.RMSE_NPV)[where(stats.site ne 'ALL' and stats.model eq 'OKIN_RSMA')]
;    rmse_array[18,*] = (stats.RMSE_BS)[where(stats.site ne 'ALL' and stats.model eq 'OKIN_RSMA')]
;    rmse_array[19,*] = 10
;    rmse_array[20,*] = ((stats.RMSE_BS)[where(stats.site ne 'ALL' and stats.model eq 'Uni_Ade_LCI')]) * (-1)
    rmse_array /= 100
    
    where_PV=[0,4,8,12,16,20]
    rmse_array_PV = rmse_array * 0 & rmse_array_PV[where_PV, *]=1  
    where_NPV=where_PV+1
    rmse_array_NPV = rmse_array * 0 & rmse_array_NPV[where_NPV, *]=1
    where_BS=[where_NPV+1,24]
    rmse_array_BS = rmse_array * 0 & rmse_array_BS[where_BS, *]=1



    fname= 'Z:\work\Juan_Pablo\ACEAS\comparison\plots\sites\boxplot.png'
    PS_Start, fname  
    cgDisplay, 1200, 800
    !P.Multi=0
    cgPlot, 1-findgen(26)/10, xrange=[0,26], yrange=[-1.1,1.1], xstyle=1, ystyle=1, /nodata, $
      xcharsize=0.0001, yTitle="Pearson's correlation (r)", charsize = 1, position=[0.1,0.5,0.97,.90], $
      yTICKLEN=1, yGRIDSTYLE=1, yThick=0.75, xThick=0.75
    ;cgBoxPlot, r_array , thick=2, xcharsize=0.001
    cgBoxPlot, r_array*r_array_PV + ((r_array_PV eq 0) * 10.0), BOXCOLOR='green', /overplot, /fillboxes, color='black'
    cgBoxPlot, r_array*r_array_NPV + ((r_array_NPV eq 0) * 10.0), BOXCOLOR='red', /overplot, /fillboxes
    cgBoxPlot, r_array*r_array_BS + ((r_array_BS eq 0) * 10.0), BOXCOLOR='blue', /overplot, /fillboxes, thick=2
    cgBoxPlot, r_array, /overplot, thick=3
    cgPlot, [4,4],[-2,2], /overplot, psym=-3
    cgPlot, [8,8],[-2,2], /overplot, psym=-3
    cgPlot, [12,12],[-2,2], /overplot, psym=-3
    cgPlot, [16,16],[-2,2], /overplot, psym=-3
    cgPlot, [20,20],[-2,2], /overplot, psym=-3
    cgPlot, [24,24],[-2,2], /overplot, psym=-3
;    cgText, 2, -1.25, 'JRSRP', alignment=0.5, charsize=1
;    cgText, 6, -1.25, 'CSIRO v2.2', alignment=0.5, charsize=1
;    cgText, 10, -1.25, 'CSIRO v3.0', alignment=0.5, charsize=1
;    cgText, 14, -1.25, 'UCLA SMA', alignment=0.5, charsize=1
;    cgText, 18, -1.25, 'UCLA RSMA', alignment=0.5, charsize=1
;    cgText, 21, -1.25, 'UAde LCI', alignment=0.5, charsize=1


    cgPlot, 1-findgen(26)/10, xrange=[0,26], yrange=[-0.01,0.62], xstyle=1, ystyle=1, /nodata, /noerase, $
      xcharsize=0.0001, yTitle="root mean square error (RMSE)", charsize = 1, position= [0.1,0.1,0.97,.5], $
      yTICKLEN=1, yGRIDSTYLE=1, yThick=0.75, xThick=0.75
    ;cgBoxPlot, rmse_array , thick=2, xcharsize=0.001
    cgBoxPlot, rmse_array*rmse_array_PV + ((rmse_array_PV eq 0) * 10.0), BOXCOLOR='green', /overplot, /fillboxes, color='black'
    cgBoxPlot, rmse_array*rmse_array_NPV + ((rmse_array_NPV eq 0) * 10.0), BOXCOLOR='red', /overplot, /fillboxes
    cgBoxPlot, rmse_array*rmse_array_BS + ((rmse_array_BS eq 0) * 10.0), BOXCOLOR='blue', /overplot, /fillboxes, thick=2
    cgBoxPlot, rmse_array, /overplot, thick=3
    cgPlot, [4,4],[-2,2], /overplot, psym=-3
    cgPlot, [8,8],[-2,2], /overplot, psym=-3
    cgPlot, [12,12],[-2,2], /overplot, psym=-3
    cgPlot, [16,16],[-2,2], /overplot, psym=-3
    cgPlot, [20,20],[-2,2], /overplot, psym=-3
    cgPlot, [24,24],[-2,2], /overplot, psym=-3
    cgText, 2, -0.05, 'JRSRP', alignment=0.5, charsize=1
    cgText, 6, -0.05, 'CSIRO v2.2', alignment=0.5, charsize=1
    cgText, 10, -0.05, 'CSIRO v3.0', alignment=0.5, charsize=1
    cgText, 14, -0.05, 'UCLA SMA', alignment=0.5, charsize=1
    cgText, 18, -0.05, 'UCLA MESMA', alignment=0.5, charsize=1
    cgText, 22, -0.05, 'UCLA RSMA', alignment=0.5, charsize=1
    cgText, 25, -0.05, 'U.Ade LCI', alignment=0.5, charsize=1
    PS_End, resize=100, /png
    
end
    