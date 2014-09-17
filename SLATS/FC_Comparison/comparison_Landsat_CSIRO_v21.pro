pro comparison_Landsat_CSIRO_v21

  years=['2002','2007','2010']
  months=['03','06','09','12']
  composite=['065','161','249','345']
  
  
  for y=0,2 do begin
  for m=0,3 do begin
    CD,'Z:\work\Juan_Pablo\ACEAS\comparison\Landsat_GA_FC\geographic\plots\'
    fname_plot = 'Comparison.Landsat-CSIRO_v21.'+years[y]+months[m]+'.ps'
    if (FILE_INFO(fname_plot)).exists eq 0 then begin

      fname = 'Z:\work\Juan_Pablo\ACEAS\comparison\Landsat_GA_FC\geographic\month_'+$
            years[y]+months[m]+'_EPSG-3577_8bit.geographic.img'
      ENVI_OPEN_FILE, fname, R_FID=FID, /NO_REALIZE
      ENVI_FILE_QUERY, FID, DATA_IGNORE_VALUE=DATA_IGNORE_VALUE, XSTART=XSTART, $
        YSTART=YSTART, DEF_STRETCH=DEF_STRETCH, ns=ns, nl=nl, nb=nb, DIMS=DIMS
      Landsat_PV=ENVI_GET_DATA(FID=FID, DIMS=DIMS, POS=1) * 1L  
      Landsat_NPV=ENVI_GET_DATA(FID=FID, DIMS=DIMS, POS=2) * 1L 
      Landsat_BS=ENVI_GET_DATA(FID=FID, DIMS=DIMS, POS=0) * 1L 
      where_NAN = Where(Landsat_PV+Landsat_NPV+Landsat_BS eq 0, count, COMPLEMENT=Where_OK)
      
      Landsat_PV /= 255.
      Landsat_NPV /= 255.
      Landsat_BS /= 255.
      if count ge 1 then Landsat_PV[where_NaN]=!Values.F_NAN
      if count ge 1 then Landsat_NPV[where_NaN]=!Values.F_NAN
      if count ge 1 then Landsat_BS[where_NaN]=!Values.F_NAN
  
      fname='\\wron\RemoteSensing\MODIS\products\Guerschman_etal_RSE2009\data\v2.1\'+$
            years[y]+'\FractCover.V2_1.'+$
            years[y]+'.'+composite[m]+'.aust.005.BS.img.gz'
      CSIRO_v21_BS = GET_Zipped_envi(fname, 'c:\temp\temp.img')
      fname='\\wron\RemoteSensing\MODIS\products\Guerschman_etal_RSE2009\data\v2.1\'+$
            years[y]+'\FractCover.V2_1.'+$
            years[y]+'.'+composite[m]+'.aust.005.PV.img.gz'
      CSIRO_v21_PV = GET_Zipped_envi(fname, 'c:\temp\temp.img')
      fname='\\wron\RemoteSensing\MODIS\products\Guerschman_etal_RSE2009\data\v2.1\'+$
            years[y]+'\FractCover.V2_1.'+$
            years[y]+'.'+composite[m]+'.aust.005.NPV.img.gz'
      CSIRO_v21_NPV = GET_Zipped_envi(fname, 'c:\temp\temp.img')
   
      where_NAN = Where(CSIRO_v21_PV gt 200 OR $
                  CSIRO_v21_NPV gt 200 OR $
                  CSIRO_v21_BS gt 200, count, COMPLEMENT=Where_OK)
      
      CSIRO_v21_PV /= 100.
      CSIRO_v21_NPV /= 100.
      CSIRO_v21_BS /= 100.
      if count ge 1 then CSIRO_v21_PV[where_NaN]=!Values.F_NAN
      if count ge 1 then CSIRO_v21_NPV[where_NaN]=!Values.F_NAN
      if count ge 1 then CSIRO_v21_BS[where_NaN]=!Values.F_NAN
      
          DIFF_PV = Landsat_PV-CSIRO_v21_PV
          DIFF_NPV = Landsat_NPV-CSIRO_v21_NPV
          DIFF_BS = Landsat_BS-CSIRO_v21_BS
          
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
            cgColorbar, Title='Landsat_PV-CSIRO_v21_PV', $
               Range=[-0.5, 0.5], NColors=254, Bottom=1, $
               TLocation='Bottom', /fit;, OOB_Low='grey';, Position=[0.2, 0.7, 0.8, 0.85];, OOB_Low='white'
      
            cgImage, BytScl(rotate(DIFF_NPV,7), Min=-0.5, Max=0.5), Title='PV',$;, Palette=palette, $
              Position=[0.1, 0.1, 0.9, 0.9], /keep_aspect_ratio, /SAVE
            cgColorbar, Title='Landsat_NPV-CSIRO_v21_NPV', $
               Range=[-0.5, 0.5], NColors=254, Bottom=1, $
               TLocation='Bottom', /fit;, OOB_Low='grey';, Position=[0.2, 0.7, 0.8, 0.85];, OOB_Low='white'
      
            cgImage, BytScl(rotate(DIFF_BS,7), Min=-0.5, Max=0.5), Title='PV',$;, Palette=palette, $
              Position=[0.1, 0.1, 0.9, 0.9], /keep_aspect_ratio, /SAVE
            cgColorbar, Title='Landsat_BS-CSIRO_v21_BS', $
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
  
            density = HIST_ND(TRANSPOSE([[Landsat_PV[where_both_ok]],[CSIRO_v21_PV[where_both_ok]]]), MIN=0,MAX=1,NBINS=100)         
            cgImage, Density, XRange=xrange, YRange=yrange, /Axes, Palette=palette, $
              XTitle='Landsat PV', YTitle='CSIRO_v21 PV', $
              Position=[0.125, 0.125, 0.9, 0.9], /save
            cgPlot, [0,1],[0,1], psym=-3, /overplot  
  ;          cgColorbar, Range=[0, max(density)], NColors=254, Bottom=0, $
  ;             /fit;, OOB_Low='grey';, Position=[0.2, 0.7, 0.8, 0.85];, OOB_Low='white'
           
            density = HIST_ND(TRANSPOSE([[Landsat_NPV[where_both_ok]],[CSIRO_v21_NPV[where_both_ok]]]), MIN=0,MAX=1,NBINS=100)         
            cgImage, Density, XRange=xrange, YRange=yrange, /Axes, Palette=palette, $
              XTitle='Landsat NPV', YTitle='CSIRO_v21 NPV', $
              Position=[0.125, 0.125, 0.9, 0.9], /save
            cgPlot, [0,1],[0,1], psym=-3, /overplot  
  ;          cgColorbar, Range=[0, max(density)], NColors=254, Bottom=0, $
  ;             /fit;, OOB_Low='grey';, Position=[0.2, 0.7, 0.8, 0.85];, OOB_Low='white'
  
            density = HIST_ND(TRANSPOSE([[Landsat_BS[where_both_ok]],[CSIRO_v21_BS[where_both_ok]]]), MIN=0,MAX=1,NBINS=100)         
            cgImage, Density, XRange=xrange, YRange=yrange, /Axes, Palette=palette, $
              XTitle='Landsat BS', YTitle='CSIRO_v21 BS', $
              Position=[0.125, 0.125, 0.9, 0.9], /save
            cgPlot, [0,1],[0,1], psym=-3, /overplot  
  ;          cgColorbar, Range=[0, max(density)], NColors=254, Bottom=0, $
  ;             /fit;, OOB_Low='grey';, Position=[0.2, 0.7, 0.8, 0.85];, OOB_Low='white'
  
           cgHistoplot, DIFF_PV, xtitle='Landsat_PV-CSIRO_v21_PV'
           cgHistoplot, DIFF_NPV, xtitle='Landsat_NPV-CSIRO_v21_NPV'
           cgHistoplot, DIFF_BS, xtitle='Landsat_BS-CSIRO_v21_BS'
         PS_End
       Endif
      Endfor
     Endfor 
   exit, /no_confirm     
end
           
           
           
           