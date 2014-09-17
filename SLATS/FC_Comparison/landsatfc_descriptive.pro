pro LandsatFC_descriptive
  compile_opt idl2
  
  years=['2002','2007','2010']
  months=['03','06','09','12']
  
  for y=0,2 do begin
  for m=0,3 do begin
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
    
    CD,'Z:\work\Juan_Pablo\ACEAS\comparison\Landsat_GA_FC\geographic\plots\'
    fname_plot = 'Descriptive.month_'+years[y]+months[m]+'_EPSG-3577_8bit.geographic.ps'
    if (FILE_INFO(fname_plot)).exists eq 0 then begin
      PS_Start, fname_plot
        !P.Multi=[0,4,2]
        cgDisplay, 1300, 600
 
        cgLoadCT, 14, /brewer
        TVLCT, cgColor('grey', /Triple), 0
          cgImage, BytScl(rotate(Landsat_PV,7), Min=0, Max=1), Title='PV',$;, Palette=palette, $
            Position=[0.1, 0.1, 0.9, 0.9], /keep_aspect_ratio, /SAVE
          cgColorbar, Title='PV', $
             Range=[0, 1], NColors=254, Bottom=0, $
             TLocation='Bottom', /fit;, Position=[0.2, 0.7, 0.8, 0.85];, OOB_Low='white'
            
             
        cgLoadCT, 16, /brewer
       TVLCT, cgColor('grey', /Triple), 0
          cgImage, BytScl(rotate(Landsat_NPV,7), Min=0, Max=1), Title='PV',$;, Palette=palette, $
            Position=[0.1, 0.1, 0.9, 0.9], /keep_aspect_ratio, /SAVE
          cgColorbar, Title='NPV', $
             Range=[0, 1], NColors=254, Bottom=0, $
              TLocation='Bottom', /fit;, Position=[0.2, 0.7, 0.8, 0.85];, OOB_Low='white'
   
         cgLoadCT, 13, /brewer
       TVLCT, cgColor('grey', /Triple), 0
          cgImage, BytScl(rotate(Landsat_BS,7), Min=0, Max=1), Title='PV',$;, Palette=palette, $
            Position=[0.1, 0.1, 0.9, 0.9], /keep_aspect_ratio, /SAVE
          cgColorbar, Title='Bare', $
             Range=[0, 1], NColors=254, Bottom=0, $
              TLocation='Bottom', /fit;, Position=[0.2, 0.7, 0.8, 0.85];, OOB_Low='white'
        
        !P.Multi[0]=4      
   
        cgHistoplot, Landsat_PV[where_OK], color='dark green', xtitle='PV'
        cgHistoplot, Landsat_NPV[where_OK], color='red', xtitle='NPV'
        cgHistoplot, Landsat_BS[where_OK], color='blue', xtitle='B'
    
        density = HIST_ND(TRANSPOSE([[Landsat_PV[where_OK]],[Landsat_NPV[where_OK]]]), MIN=0,MAX=1,NBINS=100)  
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
