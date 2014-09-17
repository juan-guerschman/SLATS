pro fract_cover_validation_make_plots, data, model=model, crypto=crypto, sites=sites
  compile_opt  idl2

  report=''  ; this will summarise the results in an output file
  report += SysTime(0)+','
   

  if keyword_set(model) eq 0 then  model = '2.2'
;  model = '2.1'
;  model = '2.2'
  report = report+'CSIRO_V'+model+','
  report = report+' '+','
  report = report+' '+','

  
  folder = 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\validation_existing_model\'
  IF (FILE_INFO(folder)).DIRECTORY eq 0 then FILE_MKDIR, folder  
  cd, folder

;  Data = read_SLATS_data_new()
  n = n_elements(data.fCover.exp_PV)

  ; observed data into array
  if keyword_set(crypto) eq 0 then crypto = 'notUsed'
  experiment = 'crypto_EQ_'+crypto
  report = report+experiment+','
  
  siteDataArray = fltarr(3, n)
  if crypto eq 'PV' then siteDataArray[0,*]=data.FCOVER_QLD.totalPVcover + data.FCOVER_QLD.satGroundCryptoCover $
                    else siteDataArray[0,*]=data.FCOVER_QLD.totalPVcover 
  if crypto eq 'NPV' then siteDataArray[1,*]=data.FCOVER_QLD.totalNPVcover + data.FCOVER_QLD.satGroundCryptoCover $
                    else siteDataArray[1,*]=data.FCOVER_QLD.totalNPVcover 
  if crypto eq 'BS' then siteDataArray[2,*]=data.FCOVER_QLD.totalBAREcover + data.FCOVER_QLD.satGroundCryptoCover $
                    else siteDataArray[2,*]=data.FCOVER_QLD.totalBAREcover 

  SAM_40X40 = data.landsat_scaling.SAM_40x40 

  sites_str = ''
  if keyword_set(sites) eq 1 then begin   
    where_sites=where(stregex(data.field_all.site, sites, /fold_case) eq 0, n_sites, complement=where_NoSites)
    if n_sites ge 1 then siteDataArray[*,where_NoSites]=!VALUES.F_NAN
    sites_str='_SitesEQ'+sites
  endif

  ; plot SAM_40x40
  fname='histogram_spectralAngle_40x40.png'
  if (FILE_INFO(fname)).exists eq 0 then begin
    PS_Start, fname
      cgDisplay, 400, 600
      !P.Multi = [0,1,2]
      cgHistoplot, SAM_40X40, /fill, xTitle='Spectral Angle'
      cgHistoplot, ALOG10(SAM_40X40), /fill, xTitle='LOG(Spectral Angle)'
    PS_End, resize=100, /png
  Endif 

  ED_40X40 = data.landsat_scaling.ED_40x40 
  ; get rid of two high values (wrong)
  where_EDwrong= Where(ED_40x40 ge 0.2, count)
  if count ge 1 then ED_40x40[where_EDwrong]=!VALUES.F_NAN 
  
  ; plot ED_40x40
  fname='histogram_EuclideanDistance_40x40.png'
  if (FILE_INFO(fname)).exists eq 0 then begin
    PS_Start, fname
      cgDisplay, 400, 300
      ;!P.Multi = [0,1,2]
      ;cgHistoplot, ED_40X40, /fill, xTitle='Euclidean Distance'
      cgHistoplot, ALOG10(ED_40X40), /fill, xTitle='LOG10(Euclidean Distance)', $
          ytitle='number of observations', binsize=0.1
    PS_End, resize=100, /png
  Endif 


  ; plot antecedent rainfall
  fname='histogram_rainfall.png'
  if (FILE_INFO(fname)).exists eq 0 then begin
    xData1 = Data.Rain.ObsMinus1 & w=Where(xData1 lt 0, c)  
    if c ge 1 then xData1[w]=!VALUES.F_NAN         
    xData2 = Data.Rain.ObsMinus2 & w=Where(xData2 lt 0, c)  
    if c ge 1 then xData2[w]=!VALUES.F_NAN         
    xData3 = Data.Rain.ObsMinus3 & w=Where(xData3 lt 0, c)  
    if c ge 1 then xData3[w]=!VALUES.F_NAN         
    PS_Start, fname
      cgDisplay, 400, 900
      !P.Multi = [0,1,3]
      cgHistoplot, xData1, /fill, xTitle='Rain 1 day before [mm]', charsize=2
      cgHistoplot, xData2, /fill, xTitle='Rain 2 days before [mm]', charsize=2
      cgHistoplot, xData3, /fill, xTitle='Rain 3 days before [mm]', charsize=2

    PS_End, resize=100, /png
  Endif 


  ; calculate fractions using both versions
  ; turn -32xxx into NaNs
  where_Nans = Where(Data.MCD43A4.B1 lt 0 OR $
                     Data.MCD43A4.B2 lt 0 OR $
                     Data.MCD43A4.B6 lt 0 OR $
                     Data.MCD43A4.B7 lt 0   $
                    , count)
  MCD43A4_NDVI = (Data.MCD43A4.B2 - Data.MCD43A4.B1) / (Data.MCD43A4.B2 + Data.MCD43A4.B1)
  MCD43A4_SR76 = (Data.MCD43A4.B7 / Data.MCD43A4.B6)
  if count ge 1 then MCD43A4_NDVI[where_Nans] = !VALUES.F_NAN
  if count ge 1 then MCD43A4_SR76[where_Nans] = !VALUES.F_NAN
  
  ;-------------------------------------------------------
  ; Perform linear unmixing
  t= Systime (1)
  if model eq '2.2' then fractions = transpose(unmix_nbar_recalibrated(MCD43A4_NDVI, MCD43A4_SR76))
  if model eq '2.1' then fractions = transpose(unmix_nbar(MCD43A4_NDVI, MCD43A4_SR76))
  Threshold = 0.20
  PV_NPV_BS = reform(correct_unmixing(fractions[*,0], fractions[*,1],fractions[*,2],Threshold))
  ; convert 2.54 (flag=2) into NaNs
  where_254 = WHERE(PV_NPV_BS eq 2.54, count)
  if count ge 1 then PV_NPV_BS[where_254]=!VALUES.F_NAN
  PV_v22 =  REFORM(PV_NPV_BS [*,0])
  NPV_v22 = REFORM(PV_NPV_BS [*,1])
  BS_v22 =  REFORM(PV_NPV_BS [*,2])
  FLAG_v22 = Byte(REFORM(PV_NPV_BS [*,2]))
  print, SysTime(1) - t, ' seconds for unmixing'
  ;undefine, PV_NPV_BS, NDVI, SWIR3_SWIR2
  ;-------------------------------------------------------


  retrievedCoverFractions =  Transpose(PV_NPV_BS[*,0:2])
  rmsError = []
  r = []
  n = []
  stdev_po = []
  for i=0,2 do $
    rmsError=[rmsError,sqrt(mean((transpose(retrievedCoverFractions[i,*]) - siteDataArray[i,*])^2, /NaN))]
    rmsErrorAll=sqrt(mean((transpose(retrievedCoverFractions) - siteDataArray)^2, /NaN))
  for i=0,2 do $
    r=[r,correlate_nan(retrievedCoverFractions[i,*], siteDataArray[i,*])]
    r_all=correlate_nan(retrievedCoverFractions, siteDataArray)
  for i=0,2 do $
    n=[n,fix(total(finite(retrievedCoverFractions[i,*] + siteDataArray[i,*])))]
  for i=0,2 do $
    stdev_po=[stdev_po,stddev(retrievedCoverFractions[i,*], /nan)/stddev(siteDataArray[i,*], /nan)]
    stdev_po_all=stddev(retrievedCoverFractions, /nan)/stddev(siteDataArray, /nan)
  print, rmsError,rmsErrorAll
  residuals = retrievedCoverFractions - siteDataArray
 
  report = report+strtrim(rmsError[0],2)+','+strtrim(rmsError[1],2)+','+strtrim(rmsError[2],2)+','+strtrim(rmsErrorAll,2)+','
  report = report+strtrim(r[0],2)+','+strtrim(r[1],2)+','+strtrim(r[2],2)+','+strtrim(r_all,2)+','
  report = report+strtrim(stdev_po[0],2)+','+strtrim(stdev_po[1],2)+','+strtrim(stdev_po[2],2)+','+strtrim(stdev_po_all,2)+','
  report = report+strtrim(n[0],2)+','+strtrim(n[1],2)+','+strtrim(n[2],2)


  fname='V'+model+'_ObservedPredictedFractions_'+experiment+sites_str+'.png'
  if (FILE_INFO(fname)).exists eq 0 then begin
    PS_Start, fname
      color=['dark green','goldenrod','brown']
      title=['GREEN','nonGREEN','BARE']
      !P.Multi=[0,3,3]
      cgDisplay, 1000, 900
      for i=0,2 do begin
        xTitle='predicted'
        yTitle='field'
        cgPlot, retrievedCoverFractions[i,*], siteDataArray[i,*], color=color[i], psym=16, Symsize=.25, $
          xTitle=xTitle, yTitle=yTitle, Ticklen=.5, xGridstyle=1, yGridstyle=1, title=title[i], $
          xRange=[-0.05, 1.05], yRange=[-0.05, 1.05], xStyle=1, yStyle=1, XTHICK=0.5, yTHICK=0.5 
        oplot_regress, retrievedCoverFractions[i,*], siteDataArray[i,*], /NAN, /NO_EQUATION
        cgPlot, [-1,2],[-1,2], /overplot
        al_legend_stats, retrievedCoverFractions[i,*], siteDataArray[i,*], box=0, charsize=0.6
      endfor   
;        cgHistoplot, total(retrievedCoverFractions, 1), xTitle='Sum of Retrieved Covers', yTitle='Number of Sites', $
;          Title='RMSE ALL='+string(rmsErrorAll)

      for i=0,2 do begin
        xTitle='predicted'
        yTitle='residuals'
        cgPlot, retrievedCoverFractions[i,*], residuals[i,*], color=color[i], psym=16, Symsize=.25, $
          xTitle=xTitle, yTitle=yTitle, Ticklen=.5, xGridstyle=1, yGridstyle=1 , XTHICK=0.5, yTHICK=0.5
        oplot_regress, retrievedCoverFractions[i,*], residuals[i,*], /NAN, /NO_EQUATION
        cgPlot, [-1,2],[0,0], /overplot
        al_legend_stats, retrievedCoverFractions[i,*], residuals[i,*], /n, box=0 , charsize=0.6
      endfor    
       
      for i=0,2 do begin
        xTitle='LOG(SAM)'
        yTitle='|residuals|'
        cgPlot, ALOG10(SAM_40X40), ABS(residuals[i,*]), color=color[i], psym=16, Symsize=.25, $
          xTitle=xTitle, yTitle=yTitle, Ticklen=.5, xGridstyle=1, yGridstyle=1 , XTHICK=0.5, yTHICK=0.5
        oplot_regress, ALOG10(SAM_40X40), ABS(residuals[i,*]), /NAN, /NO_EQUATION
        cgPlot, [-10,2],[0,0], /overplot
        al_legend_stats, ALOG10(SAM_40X40), ABS(residuals[i,*]), /n, box=0 , charsize=0.6
      endfor          
    PS_End, resize=100, /PNG
  endif  
 
  fname='V'+model+'_Residuals-Heterogen.SpectralAngle_'+experiment+sites_str+'.png'
  if (FILE_INFO(fname)).exists eq 0 then begin
    PS_Start, fname
      color=['dark green','goldenrod','brown']
      !P.Multi=[0,3,3]
      cgDisplay, 1000, 900
       
      for i=0,2 do begin
        n=fix(Total(finite(SAM_40X40)))
        xTitle='Spectral Angle (n='+STRTRIM(n, 2)+')'
        yTitle='residuals (n='+STRTRIM(n, 2)+')'
        cgPlot, (SAM_40X40), (residuals[i,*]), color=color[i], psym=16, Symsize=.25, $
          xTitle=xTitle, yTitle=yTitle, Ticklen=.5, xGridstyle=1, yGridstyle=1 , XTHICK=0.5, yTHICK=0.5
        oplot_regress, ALOG10(SAM_40X40), (residuals[i,*]), /NAN, /NO_EQUATION
        cgPlot, [-10,2],[0,0], /overplot
      endfor    

      for i=0,2 do begin
        n=fix(Total(finite(SAM_40X40)))
        xTitle='Spectral Angle (n='+STRTRIM(n, 2)+')'
        yTitle='|residuals| (n='+STRTRIM(n, 2)+')'
        cgPlot, (SAM_40X40), ABS(residuals[i,*]), color=color[i], psym=16, Symsize=.25, $
          xTitle=xTitle, yTitle=yTitle, Ticklen=.5, xGridstyle=1, yGridstyle=1 , XTHICK=0.5, yTHICK=0.5
        oplot_regress, (SAM_40X40), ABS(residuals[i,*]), /NAN, /NO_EQUATION
        cgPlot, [-10,2],[0,0], /overplot
      endfor    

      for i=0,2 do begin
        n=fix(Total(finite(SAM_40X40)))
        xTitle='LOG(Spectral Angle) (n='+STRTRIM(n, 2)+')'
        yTitle='|residuals| (n='+STRTRIM(n, 2)+')'
        cgPlot, ALOG10(SAM_40X40), ABS(residuals[i,*]), color=color[i], psym=16, Symsize=.25, $
          xTitle=xTitle, yTitle=yTitle, Ticklen=.5, xGridstyle=1, yGridstyle=1 , XTHICK=0.5, yTHICK=0.5
        oplot_regress, ALOG10(SAM_40X40), ABS(residuals[i,*]), /NAN, /NO_EQUATION
        cgPlot, [-10,2],[0,0], /overplot
      endfor    
      
    PS_End, resize=100, /PNG
  endif  
 
  fname='V'+model+'_Residuals-Heterogen.EuclideanDistance_'+experiment+sites_str+'.png'
  if (FILE_INFO(fname)).exists eq 0 then begin
    PS_Start, fname
      color=['dark green','goldenrod','brown']
      !P.Multi=[0,3,3]
      cgDisplay, 1000, 900
       
      for i=0,2 do begin
        n=fix(Total(finite(ED_40X40)))
        xTitle='Euclidean Distance (n='+STRTRIM(n, 2)+')'
        yTitle='residuals (n='+STRTRIM(n, 2)+')'
        cgPlot, (ED_40X40), (residuals[i,*]), color=color[i], psym=16, Symsize=.25, $
          xTitle=xTitle, yTitle=yTitle, Ticklen=.5, xGridstyle=1, yGridstyle=1 , XTHICK=0.5, yTHICK=0.5
        oplot_regress, ALOG10(ED_40X40), (residuals[i,*]), /NAN, /NO_EQUATION
        cgPlot, [-10,2],[0,0], /overplot
      endfor    

      for i=0,2 do begin
        n=fix(Total(finite(ED_40X40)))
        xTitle='Euclidean Distance (n='+STRTRIM(n, 2)+')'
        yTitle='|residuals| (n='+STRTRIM(n, 2)+')'
        cgPlot, (ED_40X40), ABS(residuals[i,*]), color=color[i], psym=16, Symsize=.25, $
          xTitle=xTitle, yTitle=yTitle, Ticklen=.5, xGridstyle=1, yGridstyle=1 , XTHICK=0.5, yTHICK=0.5
        oplot_regress, (ED_40X40), ABS(residuals[i,*]), /NAN, /NO_EQUATION
        cgPlot, [-10,2],[0,0], /overplot
      endfor    

      for i=0,2 do begin
        n=fix(Total(finite(ED_40X40)))
        xTitle='LOG(Euclidean Distance) (n='+STRTRIM(n, 2)+')'
        yTitle='|residuals| (n='+STRTRIM(n, 2)+')'
        cgPlot, ALOG10(ED_40X40), ABS(residuals[i,*]), color=color[i], psym=16, Symsize=.25, $
          xTitle=xTitle, yTitle=yTitle, Ticklen=.5, xGridstyle=1, yGridstyle=1 , XTHICK=0.5, yTHICK=0.5
        oplot_regress, ALOG10(ED_40X40), ABS(residuals[i,*]), /NAN, /NO_EQUATION
        cgPlot, [-10,2],[0,0], /overplot
      endfor    
      
    PS_End, resize=100, /PNG
  endif  
 
 
  fname='V'+model+'_Residuals-SoilHVC_'+experiment+sites_str+'.png'
  if (FILE_INFO(fname)).exists eq 0 then begin
     PS_Start, fname
      color=['dark green','goldenrod','brown']
      !P.Multi=[0,3,3]
      cgDisplay, 1000, 900
     
      for i=0,2 do begin
        xTitle='Soil Hue'
        yTitle='residuals'
        cgPlot, Data.SoilColor.Hue,  (residuals[i,*]), color=color[i], psym=16, Symsize=.25, $
          xTitle=xTitle, yTitle=yTitle, Ticklen=.5, xGridstyle=1, yGridstyle=1 , XTHICK=0.5, yTHICK=0.5
        oplot_regress, Data.SoilColor.Hue, (residuals[i,*]), /NAN, /NO_EQUATION
        cgPlot, [-100,100],[0,0], /overplot
      endfor    
 
      for i=0,2 do begin
        xTitle='Soil Value'
        yTitle='residuals'
        cgPlot, Data.SoilColor.Value,  (residuals[i,*]), color=color[i], psym=16, Symsize=.25, $
          xTitle=xTitle, yTitle=yTitle, Ticklen=.5, xGridstyle=1, yGridstyle=1 , XTHICK=0.5, yTHICK=0.5
        oplot_regress, Data.SoilColor.Value, (residuals[i,*]), /NAN, /NO_EQUATION
        cgPlot, [-100,100],[0,0], /overplot
      endfor    
      
      for i=0,2 do begin
        xTitle='Soil Chroma'
        yTitle='residuals'
        cgPlot, Data.SoilColor.Chroma,  (residuals[i,*]), color=color[i], psym=16, Symsize=.25, $
          xTitle=xTitle, yTitle=yTitle, Ticklen=.5, xGridstyle=1, yGridstyle=1 , XTHICK=0.5, yTHICK=0.5
        oplot_regress, Data.SoilColor.Chroma, (residuals[i,*]), /NAN, /NO_EQUATION
        cgPlot, [-100,100],[0,0], /overplot
      endfor    
    PS_End, resize=100, /PNG
  endif  


  fname='V'+model+'_Residuals-SoilRGB_'+experiment+sites_str+'.png'
  if (FILE_INFO(fname)).exists eq 0 then begin
     PS_Start, fname
      color=['dark green','goldenrod','brown']
      !P.Multi=[0,3,3]
      cgDisplay, 1000, 900
     
      for i=0,2 do begin
        xTitle='Soil RED'
        yTitle='residuals'
        cgPlot, Data.SoilColor.RED,  (residuals[i,*]), color=color[i], psym=16, Symsize=.25, $
          xTitle=xTitle, yTitle=yTitle, Ticklen=.5, xGridstyle=1, yGridstyle=1 , XTHICK=0.5, yTHICK=0.5
        oplot_regress, Data.SoilColor.RED, (residuals[i,*]), /NAN, /NO_EQUATION
        cgPlot, [-1000,1000],[0,0], /overplot
      endfor    
 
      for i=0,2 do begin
        xTitle='Soil BLUE'
        yTitle='residuals'
        cgPlot, Data.SoilColor.BLUE,  (residuals[i,*]), color=color[i], psym=16, Symsize=.25, $
          xTitle=xTitle, yTitle=yTitle, Ticklen=.5, xGridstyle=1, yGridstyle=1 , XTHICK=0.5, yTHICK=0.5
        oplot_regress, Data.SoilColor.BLUE, (residuals[i,*]), /NAN, /NO_EQUATION
        cgPlot, [-1000,1000],[0,0], /overplot
      endfor    
      
      for i=0,2 do begin
        xTitle='Soil GREEN'
        yTitle='residuals'
        cgPlot, Data.SoilColor.GREEN,  (residuals[i,*]), color=color[i], psym=16, Symsize=.25, $
          xTitle=xTitle, yTitle=yTitle, Ticklen=.5, xGridstyle=1, yGridstyle=1 , XTHICK=0.5, yTHICK=0.5
        oplot_regress, Data.SoilColor.GREEN, (residuals[i,*]), /NAN, /NO_EQUATION
        cgPlot, [-1000,1000],[0,0], /overplot
      endfor    
    PS_End, resize=100, /PNG
  endif  

  fname='V'+model+'_Residuals-Rainfall_'+experiment+sites_str+'.png'
  if (FILE_INFO(fname)).exists eq 0 then begin
     PS_Start, fname
      color=['dark green','goldenrod','brown']
      !P.Multi=[0,3,3]
      cgDisplay, 1000, 900
     
      for i=0,2 do begin
        xTitle='Rain day-1'
        yTitle='residuals'
        xData = Data.Rain.ObsMinus1 & w=Where(xData lt 0, c)  
        if c ge 1 then xData[w]=!VALUES.F_NAN         
        cgPlot, xData,  (residuals[i,*]), color=color[i], psym=16, Symsize=.25, $
          xTitle=xTitle, yTitle=yTitle, Ticklen=.5, xGridstyle=1, yGridstyle=1 , XTHICK=0.5, yTHICK=0.5  
        oplot_regress, xData, (residuals[i,*]), /NAN, /NO_EQUATION
        cgPlot, [-1000,1000],[0,0], /overplot
      endfor    
 
      for i=0,2 do begin
        xTitle='Rain day-2'
        yTitle='residuals'
        xData = Data.Rain.ObsMinus2 & w=Where(xData lt 0, c)
        if c ge 1 then xData[w]=!VALUES.F_NAN
        cgPlot, xData,  (residuals[i,*]), color=color[i], psym=16, Symsize=.25, $
          xTitle=xTitle, yTitle=yTitle, Ticklen=.5, xGridstyle=1, yGridstyle=1 , XTHICK=0.5, yTHICK=0.5
        oplot_regress, xData, (residuals[i,*]), /NAN, /NO_EQUATION
        cgPlot, [-1000,1000],[0,0], /overplot
      endfor    
      
      for i=0,2 do begin
        xTitle='Rain day-3'
        yTitle='residuals'
        xData = Data.Rain.ObsMinus3 & w=Where(xData lt 0, c)
        if c ge 1 then xData[w]=!VALUES.F_NAN
        cgPlot, xData,  (residuals[i,*]), color=color[i], psym=16, Symsize=.25, $
          xTitle=xTitle, yTitle=yTitle, Ticklen=.5, xGridstyle=1, yGridstyle=1 , XTHICK=0.5, yTHICK=0.5
        oplot_regress, xData, (residuals[i,*]), /NAN, /NO_EQUATION
        cgPlot, [-1000,1000],[0,0], /overplot
      endfor    
    PS_End, resize=100, /PNG
  endif  


  fname='V'+model+'_Residuals-SoilMoisture_'+experiment+sites_str+'.png'
  if (FILE_INFO(fname)).exists eq 0 then begin
     Wsat_4days = (Data.Wsat.WsatMinus0+Data.Wsat.WsatMinus1+Data.Wsat.WsatMinus2+Data.Wsat.WsatMinus3)/4
      
     PS_Start, fname
      color=['dark green','goldenrod','brown']
      !P.Multi=[0,3,3]
      cgDisplay, 1000, 900
     
      for i=0,2 do begin
        xTitle='AWRA-Wsat 4 days'
        yTitle='residuals'
        xData = Wsat_4days       
        cgPlot, xData,  (residuals[i,*]), color=color[i], psym=16, Symsize=.25, $
          xTitle=xTitle, yTitle=yTitle, Ticklen=.5, xGridstyle=1, yGridstyle=1 , XTHICK=0.5, yTHICK=0.5  
        oplot_regress, xData, (residuals[i,*]), /NAN, /NO_EQUATION
        cgPlot, [-1000,1000],[0,0], /overplot
        p_value=String(p_value(xData, residuals[i,*]), format='(f8.5)') 
        al_legend, 'p-value='+p_value, box=0, charsize=0.6
      endfor    

      for i=0,2 do begin
        xTitle='LOG(AWRA-Wsat 4 days)'
        yTitle='residuals'
        xData = ALOG10(Wsat_4days) 
        cgPlot, xData,  (residuals[i,*]), color=color[i], psym=16, Symsize=.25, $
          xTitle=xTitle, yTitle=yTitle, Ticklen=.5, xGridstyle=1, yGridstyle=1 , XTHICK=0.5, yTHICK=0.5  
        oplot_regress, xData, (residuals[i,*]), /NAN, /NO_EQUATION
        cgPlot, [-1000,1000],[0,0], /overplot
        p_value=String(p_value(xData, residuals[i,*]), format='(f8.5)') 
        al_legend, 'p-value='+p_value, box=0, charsize=0.6
      endfor    
 
      for i=0,2 do begin
        xTitle='ASCAT soil moisture 6 days'
        yTitle='residuals'
        xData = DATA.ASCAT.ASCAT012345        
        cgPlot, xData,  (residuals[i,*]), color=color[i], psym=16, Symsize=.25, $
          xTitle=xTitle, yTitle=yTitle, Ticklen=.5, xGridstyle=1, yGridstyle=1 , XTHICK=0.5, yTHICK=0.5  
        oplot_regress, xData, (residuals[i,*]), /NAN, /NO_EQUATION
        cgPlot, [-1000,1000],[0,0], /overplot
        p_value=String(p_value(xData, residuals[i,*]), format='(f8.5)') 
        al_legend, 'p-value='+p_value, box=0, charsize=0.6
      endfor     
    PS_End, resize=100, /PNG
  endif  


  ;write report to file
  fname = 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\validation_existing_model\validation_results.csv'
;  if (FILE_INFO(fname)).exists eq 1 then begin ; only do if file exists
    OPENU,lun, fname, /GET_LUN, /APPEND
    PrintF, lun, report
    Print, report
    close, lun
;  endIf


end


pro fract_cover_validation , data=data 
  If Keyword_Set(data) eq 0 then $
    Data = read_SLATS_data_new()

  modelo = ['2.2', '2.1']
  cryptobiotic = ['PV'];, 'NPV', 'BS', 'notUsed']
  
  for c=0,n_elements(cryptobiotic)-1 do begin
    for m=0,n_elements(modelo)-1 do begin
      fract_cover_validation_make_plots, data, model=modelo[m], crypto=cryptobiotic[c]
    endfor
  endfor
  
end
