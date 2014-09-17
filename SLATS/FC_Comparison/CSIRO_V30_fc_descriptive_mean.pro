pro CSIRO_V30_fc_descriptive_mean
  compile_opt idl2
  
;  years=['2002','2007','2010']
;  months=['03','06','09','12']
;  months=['065','161','249','345']
  
;  for y=0,2 do begin
;  for m=0,3 do begin
    DIMS=[9580,7451]
;    fname_base ='Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\SAGE\images\FractCover.V3.0.1.'+ $
;                years[y]+'.'+months[m]+'.aust.005.'  
    fname= 'Z:\work\Juan_Pablo\ACEAS\comparison\csiro_fc\CSIRO_V30_PV_mean.img'
    CSIRO_V30_PV = READ_BINARY(fname, DATA_DIMS=DIMS, Data_Type=4)

    fname= 'Z:\work\Juan_Pablo\ACEAS\comparison\csiro_fc\CSIRO_V30_NPV_mean.img'
    CSIRO_V30_NPV = READ_BINARY(fname, DATA_DIMS=DIMS, Data_Type=4)

    fname= 'Z:\work\Juan_Pablo\ACEAS\comparison\csiro_fc\CSIRO_V30_BS_mean.img'
    CSIRO_V30_BS = READ_BINARY(fname, DATA_DIMS=DIMS, Data_Type=4)
    
;    ; find shit values
     where_nan = Where(finite(CSIRO_V30_PV+CSIRO_V30_NPV+CSIRO_V30_BS) eq 0, $
                             Complement=Where_ok, count)
; 
;    CSIRO_v30_PV /= 10000.
;    CSIRO_v30_NPV /= 10000.
;    CSIRO_v30_BS /= 10000.
;    if count ge 1 then CSIRO_v30_PV[where_NaN]=!Values.F_NAN
;    if count ge 1 then CSIRO_v30_NPV[where_NaN]=!Values.F_NAN
;    if count ge 1 then CSIRO_v30_BS[where_NaN]=!Values.F_NAN
    
    CD,'Z:\work\Juan_Pablo\ACEAS\comparison\plots\spatial\'
    fname_plot = 'Descriptive.MEAN.CSIRO_v30.ps.png'
    if (FILE_INFO(fname_plot)).exists eq 0 then begin
      PS_Start, fname_plot
        !P.Multi=[0,4,2]
        cgDisplay, 1300, 600
 
        cgLoadCT, 14, /brewer
        TVLCT, cgColor('grey', /Triple), 0
          cgImage, BytScl(rotate(CSIRO_v30_PV,7), Min=0, Max=1),  $;, Palette=palette, $
            Position=[0.05, 0.0, 0.95, 0.8], /keep_aspect_ratio, /SAVE
          cgColorbar, charsize=2.5, position=[0.05,0.85,0.95,0.9], $
             Range=[0, 1], NColors=254, Bottom=0, $
             TLocation='Bottom';, /fit;, Position=[0.2, 0.7, 0.8, 0.85];, OOB_Low='white'
            
             
        cgLoadCT, 16, /brewer
       TVLCT, cgColor('grey', /Triple), 0
          cgImage, BytScl(rotate(CSIRO_v30_NPV,7), Min=0, Max=1), Title=' ',$;, Palette=palette, $
            Position=[0.05, 0.0, 0.95, 0.8], /keep_aspect_ratio, /SAVE
          cgColorbar, charsize=2.5, position=[0.05,0.85,0.95,0.9], $
             Range=[0, 1], NColors=254, Bottom=0, $
              TLocation='Bottom';, /fit;, Position=[0.2, 0.7, 0.8, 0.85];, OOB_Low='white'
   
         cgLoadCT, 13, /brewer
       TVLCT, cgColor('grey', /Triple), 0
          cgImage, BytScl(rotate(CSIRO_v30_BS,7), Min=0, Max=1), Title=' ',$;, Palette=palette, $
            Position=[0.05, 0.0, 0.95, 0.8], /keep_aspect_ratio, /SAVE
          cgColorbar, charsize=2.5, position=[0.05,0.85,0.95,0.9], $
             Range=[0, 1], NColors=254, Bottom=0, $
              TLocation='Bottom';, /fit;, Position=[0.2, 0.7, 0.8, 0.85];, OOB_Low='white'
        
        !P.Multi[0]=4      
   
        cgHistoplot, charsize=2.5, position=[0.2,0.175,0.9,0.9], yTitle='', CSIRO_v30_PV, color='black', xtitle='PV'
        cgHistoplot, charsize=2.5, position=[0.2,0.175,0.9,0.9], yTitle='', CSIRO_v30_NPV, color='black', xtitle='NPV'
        cgHistoplot, charsize=2.5, position=[0.2,0.175,0.9,0.9], yTitle='', CSIRO_v30_BS, color='black', xtitle='BS'
    
        density = HIST_ND(TRANSPOSE([[CSIRO_v30_PV[Where_ok]],[CSIRO_v30_NPV[Where_ok]]]), MIN=0,MAX=1,NBINS=100)  
        scaledDensity = BytScl(density, Min=2, Max=maxDensity)
         ; Load the color table for the display. All zero values will be gray.
        xx = lindgen(101) / 100.
        yy = lindgen(101) / 100.
        xrange = [Min(xx), Max(xx)]
        yrange = [Min(yy), Max(yy)]
       
       cgLoadCT, 33
       TVLCT, cgColor('white', /Triple), 0
       TVLCT, r, g, b, /Get
       palette = [ [r], [g], [b] ]
           ; Display the density plot.
  ;    fname_plot = 'DensityScatterplot.month_'+years[y]+months[m]+'_EPSG-3577_8bit.geographic.ps.png'
  ;    if (FILE_INFO(fname_plot)).exists eq 0 then begin
  ;      PS_Start, fname_plot
  ;        cgDisplay, 1000, 1000
          cgImage, scaledDensity, XRange=xrange, YRange=yrange, /Axes, Palette=palette, $
            XTitle='PV fraction', YTitle='NPV fraction', $
            Position=[0.175, 0.15, 0.95, 0.95], /save, charsize = 2.25 
;          cgColorbar, Title='Density', $
;             Range=[0, Max(density)], NColors=254, Bottom=0, , /Top$
;             TLocation='bottom', Position=[0.8, 0.875, 0.95, 0.925];, OOB_Low='white'
      PS_End 
    endif
      
    fname_plot = 'MEAN.CSIRO_v30.PV.MAP.ps.png'
    if (FILE_INFO(fname_plot)).exists eq 0 then begin
      PS_Start, fname_plot
        !P.Multi=0
        cgDisplay, 500, 500
        cgLoadCT, 14, /brewer
        TVLCT, cgColor('grey', /Triple), 0
          cgImage, BytScl(rotate(CSIRO_v30_PV,7), Min=0, Max=1),  $;, Palette=palette, $
            Position=[0.05, 0.0, 0.95, 0.8], /keep_aspect_ratio, /SAVE
          cgColorbar, charsize=2.5, position=[0.05,0.85,0.95,0.9], $
             Range=[0, 1], NColors=254, Bottom=0, $
             TLocation='Bottom';, /fit;, Position=[0.2, 0.7, 0.8, 0.85];, OOB_Low='white'
      PS_End 
    endif

    fname_plot = 'MEAN.CSIRO_v30.NPV.MAP.ps.png'
    if (FILE_INFO(fname_plot)).exists eq 0 then begin
      PS_Start, fname_plot
        !P.Multi=0
        cgDisplay, 500, 500
        cgLoadCT, 16, /brewer
       TVLCT, cgColor('grey', /Triple), 0
          cgImage, BytScl(rotate(CSIRO_v30_NPV,7), Min=0, Max=1), Title=' ',$;, Palette=palette, $
            Position=[0.05, 0.0, 0.95, 0.8], /keep_aspect_ratio, /SAVE
          cgColorbar, charsize=2.5, position=[0.05,0.85,0.95,0.9], $
             Range=[0, 1], NColors=254, Bottom=0, $
              TLocation='Bottom';, /fit;, Position=[0.2, 0.7, 0.8, 0.85];, OOB_Low='white'
      PS_End 
    endif

    fname_plot = 'MEAN.CSIRO_v30.BS.MAP.ps.png'
    if (FILE_INFO(fname_plot)).exists eq 0 then begin
      PS_Start, fname_plot
        !P.Multi=0
        cgDisplay, 500, 500
         cgLoadCT, 13, /brewer
       TVLCT, cgColor('grey', /Triple), 0
          cgImage, BytScl(rotate(CSIRO_v30_BS,7), Min=0, Max=1), Title=' ',$;, Palette=palette, $
            Position=[0.05, 0.0, 0.95, 0.8], /keep_aspect_ratio, /SAVE
          cgColorbar, charsize=2.5, position=[0.05,0.85,0.95,0.9], $
             Range=[0, 1], NColors=254, Bottom=0, $
              TLocation='Bottom';, /fit;, Position=[0.2, 0.7, 0.8, 0.85];, OOB_Low='white'
      PS_End 
    endif

    fname_plot = 'MEAN.CSIRO_v30.PV.Histogram.ps'
    if (FILE_INFO(fname_plot)).exists eq 0 then begin
      PS_Start, fname_plot
        !P.Multi=0
        cgDisplay, 500, 500
        cgHistoplot, charsize=2.5, position=[0.2,0.175,0.9,0.9], yTitle='', CSIRO_v30_PV, color='black', xtitle='PV'
;        cgHistoplot, charsize=2.5, position=[0.2,0.175,0.9,0.9], yTitle='', CSIRO_v30_NPV, color='black', xtitle='NPV'
;        cgHistoplot, charsize=2.5, position=[0.2,0.175,0.9,0.9], yTitle='', CSIRO_v30_BS, color='black', xtitle='BS'
        cgText, 0.89, 0.85, 'mean='+string(mean(CSIRO_v30_PV, /nan), format='(f4.2)'), /normal, alignment=1, charsize=2.5
        cgText, 0.89, 0.80, 'median='+string(median(CSIRO_v30_PV), format='(f4.2)'), /normal, alignment=1, charsize=2.5
        cgText, 0.89, 0.75, 'stdev='+string(stddev(CSIRO_v30_PV, /nan), format='(f4.2)'), /normal, alignment=1, charsize=2.5
       PS_End 
    endif

    fname_plot = 'MEAN.CSIRO_v30.NPV.Histogram.ps'
    if (FILE_INFO(fname_plot)).exists eq 0 then begin
      PS_Start, fname_plot
        !P.Multi=0
        cgDisplay, 500, 500
;        cgHistoplot, charsize=2.5, position=[0.2,0.175,0.9,0.9], yTitle='', CSIRO_v30_PV, color='black', xtitle='PV'
        cgHistoplot, charsize=2.5, position=[0.2,0.175,0.9,0.9], yTitle='', CSIRO_v30_NPV, color='black', xtitle='NPV'
;        cgHistoplot, charsize=2.5, position=[0.2,0.175,0.9,0.9], yTitle='', CSIRO_v30_BS, color='black', xtitle='BS'
        cgText, 0.89, 0.85, 'mean='+string(mean(CSIRO_v30_NPV, /nan), format='(f4.2)'), /normal, alignment=1, charsize=2.5
        cgText, 0.89, 0.80, 'median='+string(median(CSIRO_v30_NPV), format='(f4.2)'), /normal, alignment=1, charsize=2.5
        cgText, 0.89, 0.75, 'stdev='+string(stddev(CSIRO_v30_NPV, /nan), format='(f4.2)'), /normal, alignment=1, charsize=2.5
      PS_End 
    endif

    fname_plot = 'MEAN.CSIRO_v30.BS.Histogram.ps'
    if (FILE_INFO(fname_plot)).exists eq 0 then begin
      PS_Start, fname_plot
        !P.Multi=0
        cgDisplay, 500, 500
;        cgHistoplot, charsize=2.5, position=[0.2,0.175,0.9,0.9], yTitle='', CSIRO_v30_PV, color='black', xtitle='PV'
;        cgHistoplot, charsize=2.5, position=[0.2,0.175,0.9,0.9], yTitle='', CSIRO_v30_NPV, color='black', xtitle='NPV'
        cgHistoplot, charsize=2.5, position=[0.2,0.175,0.9,0.9], yTitle='', CSIRO_v30_BS, color='black', xtitle='BS'
        cgText, 0.89, 0.85, 'mean='+string(mean(CSIRO_v30_BS, /nan), format='(f4.2)'), /normal, alignment=1, charsize=2.5
        cgText, 0.89, 0.80, 'median='+string(median(CSIRO_v30_BS), format='(f4.2)'), /normal, alignment=1, charsize=2.5
        cgText, 0.89, 0.75, 'stdev='+string(stddev(CSIRO_v30_BS, /nan), format='(f4.2)'), /normal, alignment=1, charsize=2.5
      PS_End 
    endif

    fname_plot = 'MEAN.CSIRO_v30.Scatterplot.PV_NPV.ps.png'
    if (FILE_INFO(fname_plot)).exists eq 0 then begin
      PS_Start, fname_plot
        !P.Multi=0
        cgDisplay, 500, 500
        density = HIST_ND(TRANSPOSE([[CSIRO_v30_PV[Where_ok]],[CSIRO_v30_NPV[Where_ok]]]), MIN=0,MAX=1,NBINS=100)  
        scaledDensity = BytScl(density, Min=2, Max=maxDensity)
         ; Load the color table for the display. All zero values will be gray.
        xx = lindgen(101) / 100.
        yy = lindgen(101) / 100.
        xrange = [Min(xx), Max(xx)]
        yrange = [Min(yy), Max(yy)]
       
       cgLoadCT, 33
       TVLCT, cgColor('white', /Triple), 0
       TVLCT, r, g, b, /Get
       palette = [ [r], [g], [b] ]
           ; Display the density plot.
  ;    fname_plot = 'DensityScatterplot.month_'+years[y]+months[m]+'_EPSG-3577_8bit.geographic.ps.png'
  ;    if (FILE_INFO(fname_plot)).exists eq 0 then begin
  ;      PS_Start, fname_plot
  ;        cgDisplay, 1000, 1000
          cgImage, scaledDensity, XRange=xrange, YRange=yrange, /Axes, Palette=palette, $
            XTitle='PV fraction', YTitle='NPV fraction', $
            Position=[0.175, 0.15, 0.95, 0.95], /save, charsize = 2.25 
;          cgColorbar, Title='Density', $
;             Range=[0, Max(density)], NColors=254, Bottom=0, , /Top$
;             TLocation='bottom', Position=[0.8, 0.875, 0.95, 0.925];, OOB_Low='white'
      PS_End 
    endif

  
end  
