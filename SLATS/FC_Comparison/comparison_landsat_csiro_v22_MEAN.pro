pro comparison_Landsat_CSIRO_v22_mean
  compile_opt idl2

  years=['2002','2007','2010']
  months=['03','06','09','12']
  composite=['065','161','249','345']

;  envi, /restore_base_save_files
;  envi_batch_init
  
  
;  for y=0,2 do begin
;  for m=0,3 do begin
    CD,'Z:\work\Juan_Pablo\ACEAS\comparison\Landsat_GA_FC\geographic\plots\'
    fname_plot = 'Comparison.Landsat-CSIRO_v22.MEAN.ps'
    if (FILE_INFO(fname_plot)).exists eq 0 then begin
    DIMS=[9580,7451]

    fname= 'Z:\work\Juan_Pablo\ACEAS\comparison\csiro_fc\Landsat_PV_mean.img'
    Landsat_PV = READ_BINARY(fname, DATA_DIMS=DIMS, Data_Type=4)
    fname= 'Z:\work\Juan_Pablo\ACEAS\comparison\csiro_fc\Landsat_NPV_mean.img'
    Landsat_NPV = READ_BINARY(fname, DATA_DIMS=DIMS, Data_Type=4)
    fname= 'Z:\work\Juan_Pablo\ACEAS\comparison\csiro_fc\Landsat_BS_mean.img'
    Landsat_BS = READ_BINARY(fname, DATA_DIMS=DIMS, Data_Type=4)
 
    fname= 'Z:\work\Juan_Pablo\ACEAS\comparison\csiro_fc\CSIRO_v22_PV_mean.img'
    CSIRO_v22_PV = READ_BINARY(fname, DATA_DIMS=DIMS, Data_Type=4)
    fname= 'Z:\work\Juan_Pablo\ACEAS\comparison\csiro_fc\CSIRO_v22_NPV_mean.img'
    CSIRO_v22_NPV = READ_BINARY(fname, DATA_DIMS=DIMS, Data_Type=4)
    fname= 'Z:\work\Juan_Pablo\ACEAS\comparison\csiro_fc\CSIRO_v22_BS_mean.img'
    CSIRO_v22_BS = READ_BINARY(fname, DATA_DIMS=DIMS, Data_Type=4)
       
          DIFF_PV = Landsat_PV-CSIRO_v22_PV
          DIFF_NPV = Landsat_NPV-CSIRO_v22_NPV
          DIFF_BS = Landsat_BS-CSIRO_v22_BS
          
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
            cgColorbar, $; Title='Landsat.PV-CSIRO_v22.PV', $
               Range=[-0.5, 0.5], NColors=254, Bottom=1, $
               TLocation='Bottom', /fit;, OOB_Low='grey';, Position=[0.2, 0.7, 0.8, 0.85];, OOB_Low='white'
      
            cgImage, BytScl(rotate(DIFF_NPV,7), Min=-0.5, Max=0.5), Title='PV',$;, Palette=palette, $
              Position=[0.1, 0.1, 0.9, 0.9], /keep_aspect_ratio, /SAVE
            cgColorbar, $; Title='Landsat.NPV-CSIRO_v22.NPV', $
               Range=[-0.5, 0.5], NColors=254, Bottom=1, $
               TLocation='Bottom', /fit;, OOB_Low='grey';, Position=[0.2, 0.7, 0.8, 0.85];, OOB_Low='white'
      
            cgImage, BytScl(rotate(DIFF_BS,7), Min=-0.5, Max=0.5), Title='PV',$;, Palette=palette, $
              Position=[0.1, 0.1, 0.9, 0.9], /keep_aspect_ratio, /SAVE
            cgColorbar, $; Title='Landsat.BS-CSIRO_v22.BS', $
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
  
            density = HIST_ND(TRANSPOSE([[Landsat_PV[where_both_ok]],[CSIRO_v22_PV[where_both_ok]]]), MIN=0,MAX=1,NBINS=100)         
            cgImage, Density, XRange=xrange, YRange=yrange, /Axes, Palette=palette, $
              XTitle='Landsat PV', YTitle='CSIRO_v22 PV', $
              Position=[0.125, 0.125, 0.9, 0.9], /save
            cgPlot, [0,1],[0,1], psym=-3, /overplot  
  ;          cgColorbar, Range=[0, max(density)], NColors=254, Bottom=0, $
  ;             /fit;, OOB_Low='grey';, Position=[0.2, 0.7, 0.8, 0.85];, OOB_Low='white'
           
            density = HIST_ND(TRANSPOSE([[Landsat_NPV[where_both_ok]],[CSIRO_v22_NPV[where_both_ok]]]), MIN=0,MAX=1,NBINS=100)         
            cgImage, Density, XRange=xrange, YRange=yrange, /Axes, Palette=palette, $
              XTitle='Landsat NPV', YTitle='CSIRO_v22 NPV', $
              Position=[0.125, 0.125, 0.9, 0.9], /save
            cgPlot, [0,1],[0,1], psym=-3, /overplot  
  ;          cgColorbar, Range=[0, max(density)], NColors=254, Bottom=0, $
  ;             /fit;, OOB_Low='grey';, Position=[0.2, 0.7, 0.8, 0.85];, OOB_Low='white'
  
            density = HIST_ND(TRANSPOSE([[Landsat_BS[where_both_ok]],[CSIRO_v22_BS[where_both_ok]]]), MIN=0,MAX=1,NBINS=100)         
            cgImage, Density, XRange=xrange, YRange=yrange, /Axes, Palette=palette, $
              XTitle='Landsat BS', YTitle='CSIRO_v22 BS', $
              Position=[0.125, 0.125, 0.9, 0.9], /save
            cgPlot, [0,1],[0,1], psym=-3, /overplot  
  ;          cgColorbar, Range=[0, max(density)], NColors=254, Bottom=0, $
  ;             /fit;, OOB_Low='grey';, Position=[0.2, 0.7, 0.8, 0.85];, OOB_Low='white'
  
           cgHistoplot, DIFF_PV, xtitle='Landsat_PV-CSIRO_v22_PV'
           cgHistoplot, DIFF_NPV, xtitle='Landsat_NPV-CSIRO_v22_NPV'
           cgHistoplot, DIFF_BS, xtitle='Landsat_BS-CSIRO_v22_BS'
         PS_End
       Endif

;      Endfor
;     Endfor 
;   exit, /no_confirm     
end
           
           
           
           