pro CSIRO_V22_fc_descriptive
  compile_opt idl2
  
  years=['2002','2007','2010']
;  months=['03','06','09','12']
  months=['065','161','249','345']
  
  for y=0,2 do begin
  for m=0,3 do begin
    fname='\\wron\RemoteSensing\MODIS\products\Guerschman_etal_RSE2009\data\v2.2\'+$
          years[y]+'\FractCover.V2_2.'+$
          years[y]+'.'+months[m]+'.aust.005.BS.img.gz'
    CSIRO_v22_BS = GET_Zipped_envi(fname, 'c:\temp\temp.img')
    fname='\\wron\RemoteSensing\MODIS\products\Guerschman_etal_RSE2009\data\v2.2\'+$
          years[y]+'\FractCover.V2_2.'+$
          years[y]+'.'+months[m]+'.aust.005.PV.img.gz'
    CSIRO_v22_PV = GET_Zipped_envi(fname, 'c:\temp\temp.img')
    fname='\\wron\RemoteSensing\MODIS\products\Guerschman_etal_RSE2009\data\v2.2\'+$
          years[y]+'\FractCover.V2_2.'+$
          years[y]+'.'+months[m]+'.aust.005.NPV.img.gz'
    CSIRO_v22_NPV = GET_Zipped_envi(fname, 'c:\temp\temp.img')
 
    where_NAN = Where(CSIRO_v22_PV gt 200 OR $
                CSIRO_v22_NPV gt 200 OR $
                CSIRO_v22_BS gt 200, count, COMPLEMENT=Where_OK)
    
    CSIRO_v22_PV /= 100.
    CSIRO_v22_NPV /= 100.
    CSIRO_v22_BS /= 100.
    if count ge 1 then CSIRO_v22_PV[where_NaN]=!Values.F_NAN
    if count ge 1 then CSIRO_v22_NPV[where_NaN]=!Values.F_NAN
    if count ge 1 then CSIRO_v22_BS[where_NaN]=!Values.F_NAN
    
    CD,'Z:\work\Juan_Pablo\ACEAS\comparison\Landsat_GA_FC\geographic\plots\'
    fname_plot = 'Descriptive.CSIRO_v22_month_'+years[y]+months[m]+'.ps'
    if (FILE_INFO(fname_plot)).exists eq 0 then begin
      PS_Start, fname_plot
        !P.Multi=[0,4,2]
        cgDisplay, 1300, 600
 
        cgLoadCT, 14, /brewer
        TVLCT, cgColor('grey', /Triple), 0
          cgImage, BytScl(rotate(CSIRO_v22_PV,7), Min=0, Max=1), Title='PV',$;, Palette=palette, $
            Position=[0.1, 0.1, 0.9, 0.9], /keep_aspect_ratio, /SAVE
          cgColorbar, Title='PV', $
             Range=[0, 1], NColors=254, Bottom=0, $
             TLocation='Bottom', /fit;, Position=[0.2, 0.7, 0.8, 0.85];, OOB_Low='white'
            
             
        cgLoadCT, 16, /brewer
       TVLCT, cgColor('grey', /Triple), 0
          cgImage, BytScl(rotate(CSIRO_v22_NPV,7), Min=0, Max=1), Title='PV',$;, Palette=palette, $
            Position=[0.1, 0.1, 0.9, 0.9], /keep_aspect_ratio, /SAVE
          cgColorbar, Title='NPV', $
             Range=[0, 1], NColors=254, Bottom=0, $
              TLocation='Bottom', /fit;, Position=[0.2, 0.7, 0.8, 0.85];, OOB_Low='white'
   
         cgLoadCT, 13, /brewer
       TVLCT, cgColor('grey', /Triple), 0
          cgImage, BytScl(rotate(CSIRO_v22_BS,7), Min=0, Max=1), Title='PV',$;, Palette=palette, $
            Position=[0.1, 0.1, 0.9, 0.9], /keep_aspect_ratio, /SAVE
          cgColorbar, Title='Bare', $
             Range=[0, 1], NColors=254, Bottom=0, $
              TLocation='Bottom', /fit;, Position=[0.2, 0.7, 0.8, 0.85];, OOB_Low='white'
        
        !P.Multi[0]=4      
   
        cgHistoplot, CSIRO_v22_PV[where_OK], color='dark green', xtitle='PV'
        cgHistoplot, CSIRO_v22_NPV[where_OK], color='red', xtitle='NPV'
        cgHistoplot, CSIRO_v22_BS[where_OK], color='blue', xtitle='B'
    
        density = HIST_ND(TRANSPOSE([[CSIRO_v22_PV[where_OK]],[CSIRO_v22_NPV[where_OK]]]), MIN=0,MAX=1,NBINS=100)  
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
