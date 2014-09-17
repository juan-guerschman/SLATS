pro MESMA_fc_descriptive_mean
  compile_opt idl2
  
;  years=['2002','2007','2010']
;  months=['03','06','09','12']
;  months=['065','161','249','345']
  
;  for y=0,2 do begin
;  for m=0,3 do begin
    DIMS=[9580,7451]
;    fname_base ='Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\SAGE\images\FractCover.V3.0.1.'+ $
;                years[y]+'.'+months[m]+'.aust.005.'  
    fname= 'Z:\work\Juan_Pablo\auxiliary\land_mask_australia_MCD43'
    LAND = READ_BINARY(fname, DATA_DIMS=DIMS, Data_Type=1)

    fname= 'Z:\work\Juan_Pablo\ACEAS\comparison\MESMA\MESMA_PV_mean.img'
    MESMA_PV = READ_BINARY(fname, DATA_DIMS=DIMS, Data_Type=4)

    fname= 'Z:\work\Juan_Pablo\ACEAS\comparison\MESMA\MESMA_NPV_mean.img'
    MESMA_NPV = READ_BINARY(fname, DATA_DIMS=DIMS, Data_Type=4)

    fname= 'Z:\work\Juan_Pablo\ACEAS\comparison\MESMA\MESMA_BS_mean.img'
    MESMA_BS = READ_BINARY(fname, DATA_DIMS=DIMS, Data_Type=4)
    
;    ; find shit values
     where_nan = Where(finite(MESMA_PV+MESMA_NPV+MESMA_BS) eq 0 OR $
                        LAND eq 0 , $
                             Complement=Where_ok, count)
; 
;    MESMA_PV /= 10000.
;    MESMA_NPV /= 10000.
;    MESMA_BS /= 10000.
    if count ge 1 then MESMA_PV[where_NaN]=!Values.F_NAN
    if count ge 1 then MESMA_NPV[where_NaN]=!Values.F_NAN
    if count ge 1 then MESMA_BS[where_NaN]=!Values.F_NAN
    
    CD,'Z:\work\Juan_Pablo\ACEAS\comparison\plots\spatial\'
    fname_plot = 'Descriptive.MEAN.MESMA.ps.png'
    if (FILE_INFO(fname_plot)).exists eq 0 then begin
      PS_Start, fname_plot
        !P.Multi=[0,4,2]
        cgDisplay, 1300, 600
 
        cgLoadCT, 14, /brewer
        TVLCT, cgColor('grey', /Triple), 0
          cgImage, BytScl(rotate(MESMA_PV,7), Min=0, Max=1),  $;, Palette=palette, $
            Position=[0.05, 0.0, 0.95, 0.8], /keep_aspect_ratio, /SAVE
          cgColorbar, charsize=2.5, position=[0.05,0.85,0.95,0.9], $
             Range=[0, 1], NColors=254, Bottom=0, $
             TLocation='Bottom';, /fit;, Position=[0.2, 0.7, 0.8, 0.85];, OOB_Low='white'
            
             
        cgLoadCT, 16, /brewer
       TVLCT, cgColor('grey', /Triple), 0
          cgImage, BytScl(rotate(MESMA_NPV,7), Min=0, Max=1), Title=' ',$;, Palette=palette, $
            Position=[0.05, 0.0, 0.95, 0.8], /keep_aspect_ratio, /SAVE
          cgColorbar, charsize=2.5, position=[0.05,0.85,0.95,0.9], $
             Range=[0, 1], NColors=254, Bottom=0, $
              TLocation='Bottom';, /fit;, Position=[0.2, 0.7, 0.8, 0.85];, OOB_Low='white'
   
         cgLoadCT, 13, /brewer
       TVLCT, cgColor('grey', /Triple), 0
          cgImage, BytScl(rotate(MESMA_BS,7), Min=0, Max=1), Title=' ',$;, Palette=palette, $
            Position=[0.05, 0.0, 0.95, 0.8], /keep_aspect_ratio, /SAVE
          cgColorbar, charsize=2.5, position=[0.05,0.85,0.95,0.9], $
             Range=[0, 1], NColors=254, Bottom=0, $
              TLocation='Bottom';, /fit;, Position=[0.2, 0.7, 0.8, 0.85];, OOB_Low='white'
        
        !P.Multi[0]=4      
   
        cgHistoplot, charsize=2.5, position=[0.2,0.175,0.9,0.9], yTitle='', MESMA_PV, color='black', xtitle='PV'
        cgHistoplot, charsize=2.5, position=[0.2,0.175,0.9,0.9], yTitle='', MESMA_NPV, color='black', xtitle='NPV'
        cgHistoplot, charsize=2.5, position=[0.2,0.175,0.9,0.9], yTitle='', MESMA_BS, color='black', xtitle='BS'
    
        density = HIST_ND(TRANSPOSE([[MESMA_PV[Where_ok]],[MESMA_NPV[Where_ok]]]), MIN=0,MAX=1,NBINS=100)  
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

    fname_plot = 'MEAN.MESMA.PV.MAP.ps.png'
    if (FILE_INFO(fname_plot)).exists eq 0 then begin
      PS_Start, fname_plot
        !P.Multi=0
        cgDisplay, 500, 500
        cgLoadCT, 14, /brewer
        TVLCT, cgColor('grey', /Triple), 0
          cgImage, BytScl(rotate(MESMA_PV,7), Min=0, Max=1),  $;, Palette=palette, $
            Position=[0.05, 0.0, 0.95, 0.8], /keep_aspect_ratio, /SAVE
          cgColorbar, charsize=2.5, position=[0.05,0.85,0.95,0.9], $
             Range=[0, 1], NColors=254, Bottom=0, $
             TLocation='Bottom';, /fit;, Position=[0.2, 0.7, 0.8, 0.85];, OOB_Low='white'
      PS_End 
    endif

    fname_plot = 'MEAN.MESMA.NPV.MAP.ps.png'
    if (FILE_INFO(fname_plot)).exists eq 0 then begin
      PS_Start, fname_plot
        !P.Multi=0
        cgDisplay, 500, 500
        cgLoadCT, 16, /brewer
       TVLCT, cgColor('grey', /Triple), 0
          cgImage, BytScl(rotate(MESMA_NPV,7), Min=0, Max=1), Title=' ',$;, Palette=palette, $
            Position=[0.05, 0.0, 0.95, 0.8], /keep_aspect_ratio, /SAVE
          cgColorbar, charsize=2.5, position=[0.05,0.85,0.95,0.9], $
             Range=[0, 1], NColors=254, Bottom=0, $
              TLocation='Bottom';, /fit;, Position=[0.2, 0.7, 0.8, 0.85];, OOB_Low='white'
      PS_End 
    endif

    fname_plot = 'MEAN.MESMA.BS.MAP.ps.png'
    if (FILE_INFO(fname_plot)).exists eq 0 then begin
      PS_Start, fname_plot
        !P.Multi=0
        cgDisplay, 500, 500
         cgLoadCT, 13, /brewer
       TVLCT, cgColor('grey', /Triple), 0
          cgImage, BytScl(rotate(MESMA_BS,7), Min=0, Max=1), Title=' ',$;, Palette=palette, $
            Position=[0.05, 0.0, 0.95, 0.8], /keep_aspect_ratio, /SAVE
          cgColorbar, charsize=2.5, position=[0.05,0.85,0.95,0.9], $
             Range=[0, 1], NColors=254, Bottom=0, $
              TLocation='Bottom';, /fit;, Position=[0.2, 0.7, 0.8, 0.85];, OOB_Low='white'
      PS_End 
    endif

    fname_plot = 'MEAN.MESMA.PV.Histogram.ps'
    if (FILE_INFO(fname_plot)).exists eq 0 then begin
      PS_Start, fname_plot
        !P.Multi=0
        cgDisplay, 500, 500
        cgHistoplot, charsize=2.5, position=[0.2,0.175,0.9,0.9], yTitle='', MESMA_PV, color='black', xtitle='PV'
;        cgHistoplot, charsize=2.5, position=[0.2,0.175,0.9,0.9], yTitle='', MESMA_NPV, color='black', xtitle='NPV'
;        cgHistoplot, charsize=2.5, position=[0.2,0.175,0.9,0.9], yTitle='', MESMA_BS, color='black', xtitle='BS'
        cgText, 0.89, 0.85, 'mean='+string(mean(MESMA_PV, /nan), format='(f4.2)'), /normal, alignment=1, charsize=2.5
        cgText, 0.89, 0.80, 'median='+string(median(MESMA_PV), format='(f4.2)'), /normal, alignment=1, charsize=2.5
        cgText, 0.89, 0.75, 'stdev='+string(stddev(MESMA_PV, /nan), format='(f4.2)'), /normal, alignment=1, charsize=2.5
      PS_End 
    endif

    fname_plot = 'MEAN.MESMA.NPV.Histogram.ps'
    if (FILE_INFO(fname_plot)).exists eq 0 then begin
      PS_Start, fname_plot
        !P.Multi=0
        cgDisplay, 500, 500
;        cgHistoplot, charsize=2.5, position=[0.2,0.175,0.9,0.9], yTitle='', MESMA_PV, color='black', xtitle='PV'
        cgHistoplot, charsize=2.5, position=[0.2,0.175,0.9,0.9], yTitle='', MESMA_NPV, color='black', xtitle='NPV'
;        cgHistoplot, charsize=2.5, position=[0.2,0.175,0.9,0.9], yTitle='', MESMA_BS, color='black', xtitle='BS'
        cgText, 0.89, 0.85, 'mean='+string(mean(MESMA_NPV, /nan), format='(f4.2)'), /normal, alignment=1, charsize=2.5
        cgText, 0.89, 0.80, 'median='+string(median(MESMA_NPV), format='(f4.2)'), /normal, alignment=1, charsize=2.5
        cgText, 0.89, 0.75, 'stdev='+string(stddev(MESMA_NPV, /nan), format='(f4.2)'), /normal, alignment=1, charsize=2.5
      PS_End 
    endif

    fname_plot = 'MEAN.MESMA.BS.Histogram.ps'
    if (FILE_INFO(fname_plot)).exists eq 0 then begin
      PS_Start, fname_plot
        !P.Multi=0
        cgDisplay, 500, 500
;        cgHistoplot, charsize=2.5, position=[0.2,0.175,0.9,0.9], yTitle='', MESMA_PV, color='black', xtitle='PV'
;        cgHistoplot, charsize=2.5, position=[0.2,0.175,0.9,0.9], yTitle='', MESMA_NPV, color='black', xtitle='NPV'
        cgHistoplot, charsize=2.5, position=[0.2,0.175,0.9,0.9], yTitle='', MESMA_BS, color='black', xtitle='BS'
        cgText, 0.89, 0.85, 'mean='+string(mean(MESMA_BS, /nan), format='(f4.2)'), /normal, alignment=1, charsize=2.5
        cgText, 0.89, 0.80, 'median='+string(median(MESMA_BS), format='(f4.2)'), /normal, alignment=1, charsize=2.5
        cgText, 0.89, 0.75, 'stdev='+string(stddev(MESMA_BS, /nan), format='(f4.2)'), /normal, alignment=1, charsize=2.5
      PS_End 
    endif

    fname_plot = 'MEAN.MESMA.Scatterplot.PV_NPV.ps.png'
    if (FILE_INFO(fname_plot)).exists eq 0 then begin
      PS_Start, fname_plot
        !P.Multi=0
        cgDisplay, 500, 500
        density = HIST_ND(TRANSPOSE([[MESMA_PV[Where_ok]],[MESMA_NPV[Where_ok]]]), MIN=0,MAX=1,NBINS=100)  
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

      
;  endfor
;  endfor
  
end  
