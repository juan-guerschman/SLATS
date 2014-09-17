pro RSMA_fc_descriptive
  compile_opt idl2
  
  years=['2002','2007','2010']
;  months=['03','06','09','12']
  months=['065','161','249','345']
  
  for y=0,2 do begin
  for m=0,3 do begin
    
    RSMA = get_RSMA_FC(years[y], months[m])
    
    CD,'Z:\work\Juan_Pablo\ACEAS\comparison\Landsat_GA_FC\geographic\plots\'
    fname_plot = 'Descriptive.RSMA_month_'+years[y]+months[m]+'.ps'
    if (FILE_INFO(fname_plot)).exists eq 0 then begin
      PS_Start, fname_plot
        !P.Multi=[0,4,2]
        cgDisplay, 1300, 600
 
        cgLoadCT, 14, /brewer
        TVLCT, cgColor('grey', /Triple), 0
          range_PV=cgPercentiles(RSMA.PV[RSMA.where_ok], percentiles=[.02, .98])
          cgImage, BytScl(rotate(RSMA.PV,7), min=range_PV[0], max=range_PV[1]), Title='PV',$;, Palette=palette, $
            Position=[0.1, 0.1, 0.9, 0.9], /keep_aspect_ratio, /SAVE
          cgColorbar, Title='PV', $
             Range=range_PV, NColors=254, Bottom=0, $
             TLocation='Bottom', /fit;, Position=[0.2, 0.7, 0.8, 0.85];, OOB_Low='white'
            
             
        cgLoadCT, 16, /brewer
       TVLCT, cgColor('grey', /Triple), 0
          range_NPV=cgPercentiles(RSMA.NPV[RSMA.where_ok], percentiles=[.02, .98])
          cgImage, BytScl(rotate(RSMA.NPV,7), min=range_NPV[0], max=range_NPV[1]), Title='NPV',$;, Palette=palette, $
            Position=[0.1, 0.1, 0.9, 0.9], /keep_aspect_ratio, /SAVE
          cgColorbar, Title='NPV', $
             Range=range_NPV, NColors=254, Bottom=0, $
              TLocation='Bottom', /fit;, Position=[0.2, 0.7, 0.8, 0.85];, OOB_Low='white'
   
         cgLoadCT, 13, /brewer
       TVLCT, cgColor('grey', /Triple), 0
          range_BS=cgPercentiles(RSMA.BS[RSMA.where_ok], percentiles=[.02, .98])
          cgImage, BytScl(rotate(RSMA.BS,7), min=range_BS[0], max=range_BS[1]), Title='BS',$;, Palette=palette, $
            Position=[0.1, 0.1, 0.9, 0.9], /keep_aspect_ratio, /SAVE
          cgColorbar, Title='Bare', $
             Range=range_BS, NColors=254, Bottom=0, $
              TLocation='Bottom', /fit;, Position=[0.2, 0.7, 0.8, 0.85];, OOB_Low='white'
        
        !P.Multi[0]=4      
   
        cgHistoplot, RSMA.PV[RSMA.where_OK], color='dark green', xtitle='PV', mininput=range_PV[0], maxinput=range_PV[1]
        cgHistoplot, RSMA.NPV[RSMA.where_OK], color='red', xtitle='NPV', mininput=range_NPV[0], maxinput=range_NPV[1]
        cgHistoplot, RSMA.BS[RSMA.where_OK], color='blue', xtitle='B', mininput=range_BS[0], maxinput=range_BS[1]
    
        density = HIST_ND(TRANSPOSE([[RSMA.PV[RSMA.where_OK]],[RSMA.NPV[RSMA.where_OK]]]), $
                  MIN=min([range_PV,range_NPV]),MAX=max([range_PV,range_NPV]),NBINS=100)  
        scaledDensity = BytScl(density, Min=2, Max=maxDensity)
         ; Load the color table for the display. All zero values will be gray.
        xx = lindgen(101) / 100.
        yy = lindgen(101) / 100.
        xrange = [min([range_PV,range_NPV]), mAX([range_PV,range_NPV])]
        yrange = [min([range_PV,range_NPV]), mAX([range_PV,range_NPV])]
       
       cgLoadCT, 33
       TVLCT, cgColor('white', /Triple), 0
       TVLCT, r, g, b, /Get
       palette = [ [r], [g], [b] ]
           ; Display the density plot.
  ;    fname_plot = 'DensityScatterplot.month_'+years[y]+months[m]+'_EPSG-3577_8bit.geographic.ps'
  ;    if (FILE_INFO(fname_plot)).exists eq 0 then begin
  ;      PS_Start, fname_plot
  ;        cgDisplay, 1000, 1000
          cgImage, scaledDensity, XRange=xrange, YRange=yrange, /Axes, Palette=palette, $
            XTitle='PV fraction', YTitle='NPV fraction', $
            Position=[0.125, 0.125, 0.9, 0.9]
;          cgColorbar, Title='Density', $
;             Range=[0, Max(density)], NColors=254, Bottom=0, , /Top$
;             TLocation='bottom', Position=[0.8, 0.875, 0.95, 0.925];, OOB_Low='white'
      PS_End 
    endif
      
  endfor
  endfor
  
end  
