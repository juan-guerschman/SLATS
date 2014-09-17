pro ACEAS_comparison_X_Y_plot_runner, xProd=xProd, yProd=yProd, year=year, month=month
  compile_opt idl2

  if xProd ne 'Landsat' AND $
     xProd ne 'CSIRO_V21' AND $
     xProd ne 'CSIRO_V22' AND $
     xProd ne 'CSIRO_V30' $
     then MESSAGE, 'x must be a FC product to compare'

  if yProd ne 'Landsat' AND $
     yProd ne 'CSIRO_V21' AND $
     yProd ne 'CSIRO_V22' AND $
     yProd ne 'CSIRO_V30' $
     then MESSAGE, 'x must be a FC product to compare'

  if year ne '2002' AND $
     year ne '2007' AND $
     year ne '2010' $
     then MESSAGE, 'year must be 2002, 2007 or 2010'

  if month ne '03' AND $
     month ne '06' AND $
     month ne '09' AND $
     month ne '12' $
     then MESSAGE, 'month must be 03, 06, 09 or 12'

  CD,'Z:\work\Juan_Pablo\ACEAS\comparison\Landsat_GA_FC\geographic\plots\'
  
  fname_plot = 'Comparison.'+xProd+'-'+yProd+'.'+year+month+'.ps'
  
  if (FILE_INFO(fname_plot)).exists eq 0 then begin
    case month of 
      '03': composite = '065'
      '06': composite = '161'
      '09': composite = '249'
      '12': composite = '345'
    endCase
  
    if xProd eq 'Landsat' then xVar = get_Landsat_FC(year, month)
    if xProd eq 'CSIRO_V21' then xVar = get_CSIRO_V21_FC(year, composite)
    if xProd eq 'CSIRO_V22' then xVar = get_CSIRO_V22_FC(year, composite)
    if xProd eq 'CSIRO_V30' then xVar = get_CSIRO_V30_FC(year, composite)
  
    if yProd eq 'Landsat' then yVar = get_Landsat_FC(year, month)
    if yProd eq 'CSIRO_V21' then yVar = get_CSIRO_V21_FC(year, composite)
    if yProd eq 'CSIRO_V22' then yVar = get_CSIRO_V22_FC(year, composite)
    if yProd eq 'CSIRO_V30' then yVar = get_CSIRO_V30_FC(year, composite)
  
    DIFF_PV = xVar.PV-yVar.PV
    DIFF_NPV = xVar.NPV-yVar.NPV
    DIFF_BS = xVar.BS-yVar.BS
    
    where_both_ok = Where(FINITE(DIFF_PV) EQ 1 AND $
                          FINITE(DIFF_NPV) EQ 1 AND $
                          FINITE(DIFF_BS) EQ 1)
      
    PS_Start, fname_plot
      !P.Multi=[0,3,3]
      cgDisplay, 1000, 900
        
      cgLoadCT, 24, /brewer
      TVLCT, cgColor('grey', /Triple), 0
        cgImage, BytScl(rotate(DIFF_PV,7), Min=-0.5, Max=0.5), Title='PV',$;, Palette=palette, $
          Position=[0.1, 0.1, 0.9, 0.9], /keep_aspect_ratio, /SAVE
        cgColorbar, Title=xProd+'.PV-'+yProd+'.PV', $
         Range=[-0.5, 0.5], NColors=254, Bottom=1, $
         TLocation='Bottom', /fit;, OOB_Low='grey';, Position=[0.2, 0.7, 0.8, 0.85];, OOB_Low='white'
  
        cgImage, BytScl(rotate(DIFF_NPV,7), Min=-0.5, Max=0.5), Title='PV',$;, Palette=palette, $
          Position=[0.1, 0.1, 0.9, 0.9], /keep_aspect_ratio, /SAVE
        cgColorbar, Title=xProd+'.NPV-'+yProd+'.NPV', $
           Range=[-0.5, 0.5], NColors=254, Bottom=1, $
           TLocation='Bottom', /fit;, OOB_Low='grey';, Position=[0.2, 0.7, 0.8, 0.85];, OOB_Low='white'
    
        cgImage, BytScl(rotate(DIFF_BS,7), Min=-0.5, Max=0.5), Title='PV',$;, Palette=palette, $
          Position=[0.1, 0.1, 0.9, 0.9], /keep_aspect_ratio, /SAVE
        cgColorbar, Title=xProd+'.BS-'+yProd+'.BS', $
           Range=[-0.5, 0.5], NColors=254, Bottom=1, $
           TLocation='Bottom', /fit;, OOB_Low='grey';, Position=[0.2, 0.7, 0.8, 0.85];, OOB_Low='white'
    
         cgLoadCT, 33
         TVLCT, cgColor('white', /Triple), 0
         TVLCT, r, g, b, /Get
         palette = [ [r], [g], [b] ]
          xx = lindgen(101) / 100.
          yy = lindgen(101) / 100.
          xrange = [Min(xx), Max(xx)]
          yrange = [Min(yy), Max(yy)]          

          density = HIST_ND(TRANSPOSE([[xVar.PV[where_both_ok]],[yVar.PV[where_both_ok]]]), MIN=0,MAX=1,NBINS=100)         
          cgImage, Density, XRange=xrange, YRange=yrange, /Axes, Palette=palette, $
            XTitle=xProd+' PV', YTitle=yProd+' PV', $
            Position=[0.125, 0.125, 0.9, 0.9], /save
          cgPlot, [0,1],[0,1], psym=-3, /overplot  
;          cgColorbar, Range=[0, max(density)], NColors=254, Bottom=0, $
;             /fit;, OOB_Low='grey';, Position=[0.2, 0.7, 0.8, 0.85];, OOB_Low='white'
         
          density = HIST_ND(TRANSPOSE([[xVar.NPV[where_both_ok]],[yVar.NPV[where_both_ok]]]), MIN=0,MAX=1,NBINS=100)         
          cgImage, Density, XRange=xrange, YRange=yrange, /Axes, Palette=palette, $
            XTitle=xProd+' NPV', YTitle=yProd+' NPV', $
            Position=[0.125, 0.125, 0.9, 0.9], /save
          cgPlot, [0,1],[0,1], psym=-3, /overplot  
;          cgColorbar, Range=[0, max(density)], NColors=254, Bottom=0, $
;             /fit;, OOB_Low='grey';, Position=[0.2, 0.7, 0.8, 0.85];, OOB_Low='white'

          density = HIST_ND(TRANSPOSE([[xVar.BS[where_both_ok]],[yVar.BS[where_both_ok]]]), MIN=0,MAX=1,NBINS=100)         
          cgImage, Density, XRange=xrange, YRange=yrange, /Axes, Palette=palette, $
            XTitle=xProd+' BS', YTitle=yProd+' BS', $
            Position=[0.125, 0.125, 0.9, 0.9], /save
          cgPlot, [0,1],[0,1], psym=-3, /overplot  
;          cgColorbar, Range=[0, max(density)], NColors=254, Bottom=0, $
;             /fit;, OOB_Low='grey';, Position=[0.2, 0.7, 0.8, 0.85];, OOB_Low='white'

         cgHistoplot, DIFF_PV, xtitle=xProd+' PV- '+yProd+'.PV'
         cgHistoplot, DIFF_NPV, xtitle=xProd+' NPV- '+yProd+'.NPV'
         cgHistoplot, DIFF_BS, xtitle=xProd+' BS- '+yProd+'.BS'
       PS_End
     Endif
  
end 

pro ACEAS_comparison_X_Y_plot
  
  xProd=['CSIRO_V21','CSIRO_V22']
  yProd=['CSIRO_V22','CSIRO_V30']
  years=['2002','2007','2010']
  months=['03','06','09','12']
  
  for prod=0,1 do $
    for m=0,3 do $
      for y=0,2 do $
        ACEAS_comparison_X_Y_plot_runner, xProd=xProd[prod], yProd=yProd[prod], year=years[y], month=months[m]
 
end 

