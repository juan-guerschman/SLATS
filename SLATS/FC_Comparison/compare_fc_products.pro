pro compare_FC_products

  ; LOAD DATA 
  folder = 'Z:\work\Juan_Pablo\ACEAS\comparison\'
  cd, folder
  fname = 'Fractional Cover Comparison.csv'
  FC_comp = READ_ASCII_FILE(fname, /SURPRESS_MSG)
  
  ; print some useful information
  help, FC_comp, /str
  
  ; find sites and identify their locations
  Uniq_Sites = (FC_comp.site_ID)[UNIQ(FC_comp.site_ID, SORT(FC_comp.site_ID))]
  Uniq_Sites_n = n_elements(Uniq_Sites)
  
  ; create vector with dates
  dates = JULDAY(FC_comp.month, FC_comp.day, FC_comp.year)
  
  ; gets rid of nans in several fields
  OBSERVED_PV = FC_comp.OBSERVED_PV 
  where_nans = where(OBSERVED_PV lt 0 OR OBSERVED_PV gt 1, count) & if count ge 1 then OBSERVED_PV[Where_nans] = !VALUES.F_NAN
  OBSERVED_NPV = FC_comp.OBSERVED_NPV 
  where_nans = where(OBSERVED_NPV lt 0 OR OBSERVED_NPV gt 1, count) & if count ge 1 then OBSERVED_NPV[Where_nans] = !VALUES.F_NAN
  OBSERVED_BS = FC_comp.OBSERVED_BS 
  where_nans = where(OBSERVED_BS lt 0 OR OBSERVED_BS gt 1, count) & if count ge 1 then OBSERVED_BS[Where_nans] = !VALUES.F_NAN
  OBSERVED_PV *= 100
  OBSERVED_NPV *= 100
  OBSERVED_BS *= 100
  
  SA = FC_Comp.SPECTRAL_ANGLE_1KM
  where_nans = where(SA eq -999, count) & if count ge 1 then SA[Where_nans] = !VALUES.F_NAN

  CSIRO_V2_2_PV = FC_comp.CSIRO_V2_2_PV
  where_nans = where(CSIRO_V2_2_PV lt 0 OR CSIRO_V2_2_PV gt 100, count) & if count ge 1 then CSIRO_V2_2_PV[Where_nans] = !VALUES.F_NAN
  CSIRO_V2_2_NPV = FC_comp.CSIRO_V2_2_NPV
  where_nans = where(CSIRO_V2_2_NPV lt 0 OR CSIRO_V2_2_NPV gt 100, count) & if count ge 1 then CSIRO_V2_2_NPV[Where_nans] = !VALUES.F_NAN
  CSIRO_V2_2_BS = FC_comp.CSIRO_V2_2_BS
  where_nans = where(CSIRO_V2_2_BS lt 0 OR CSIRO_V2_2_BS gt 100, count) & if count ge 1 then CSIRO_V2_2_BS[Where_nans] = !VALUES.F_NAN

  CSIRO_V3_0_PV = FC_comp.CSIRO_V3_0_PV * 100
  where_nans = where(CSIRO_V3_0_PV lt 0 OR CSIRO_V3_0_PV gt 100, count) & if count ge 1 then CSIRO_V3_0_PV[Where_nans] = !VALUES.F_NAN
  CSIRO_V3_0_NPV = FC_comp.CSIRO_V3_0_NPV * 100
  where_nans = where(CSIRO_V3_0_NPV lt 0 OR CSIRO_V3_0_NPV gt 100, count) & if count ge 1 then CSIRO_V3_0_NPV[Where_nans] = !VALUES.F_NAN
  CSIRO_V3_0_BS = FC_comp.CSIRO_V3_0_BS * 100
  where_nans = where(CSIRO_V3_0_BS lt 0 OR CSIRO_V3_0_BS gt 100, count) & if count ge 1 then CSIRO_V3_0_BS[Where_nans] = !VALUES.F_NAN


  CSIRO_V2_1_PV = FC_comp.CSIRO_V2_1_PV
  where_nans = where(CSIRO_V2_1_PV lt 0 OR CSIRO_V2_1_PV gt 100, count) & if count ge 1 then CSIRO_V2_1_PV[Where_nans] = !VALUES.F_NAN
  CSIRO_V2_1_NPV = FC_comp.CSIRO_V2_1_NPV
  where_nans = where(CSIRO_V2_1_NPV lt 0 OR CSIRO_V2_1_NPV gt 100, count) & if count ge 1 then CSIRO_V2_1_NPV[Where_nans] = !VALUES.F_NAN
  CSIRO_V2_1_BS = FC_comp.CSIRO_V2_1_BS
  where_nans = where(CSIRO_V2_1_BS lt 0 OR CSIRO_V2_1_BS gt 100, count) & if count ge 1 then CSIRO_V2_1_BS[Where_nans] = !VALUES.F_NAN


  SMA_GV = FC_comp.SMA_GV
  where_nans = where(SMA_GV lt 0 OR SMA_GV gt 100, count) & if count ge 1 then SMA_GV[Where_nans] = !VALUES.F_NAN
  SMA_NPV = FC_comp.SMA_NPV
  where_nans = where(SMA_NPV lt 0 OR SMA_NPV gt 100, count) & if count ge 1 then SMA_NPV[Where_nans] = !VALUES.F_NAN
  SMA_SOIL = FC_comp.SMA_SOIL
  where_nans = where(SMA_SOIL lt 0 OR SMA_SOIL gt 100, count) & if count ge 1 then SMA_SOIL[Where_nans] = !VALUES.F_NAN
  SMA_GV *= 100
  SMA_NPV *= 100
  SMA_SOIL *= 100

  MESMA_GV = FC_comp.MESMA_GV
  where_nans = where(MESMA_GV lt 0 OR MESMA_GV gt 100, count) & if count ge 1 then MESMA_GV[Where_nans] = !VALUES.F_NAN
  MESMA_NPV = FC_comp.MESMA_NPV
  where_nans = where(MESMA_NPV lt 0 OR MESMA_NPV gt 100, count) & if count ge 1 then MESMA_NPV[Where_nans] = !VALUES.F_NAN
  MESMA_SOIL = FC_comp.MESMA_SOIL
  where_nans = where(MESMA_SOIL lt 0 OR MESMA_SOIL gt 100, count) & if count ge 1 then MESMA_SOIL[Where_nans] = !VALUES.F_NAN
  MESMA_GV *= 100
  MESMA_NPV *= 100
  MESMA_SOIL *= 100

  RSMA_GV = FC_comp.RSMA_GV
  where_nans = where(RSMA_GV eq -999, count) & if count ge 1 then RSMA_GV[Where_nans] = !VALUES.F_NAN
  RSMA_NPV = FC_comp.RSMA_NPV
  where_nans = where(RSMA_NPV eq -999, count) & if count ge 1 then RSMA_NPV[Where_nans] = !VALUES.F_NAN
  RSMA_SOIL = FC_comp.RSMA_SOIL
  where_nans = where(RSMA_SOIL eq -999, count) & if count ge 1 then RSMA_SOIL[Where_nans] = !VALUES.F_NAN
  ;RSMA_GV *= 100
  ;RSMA_NPV *= 100
  ;RSMA_SOIL *= 100

  LCI = FC_comp.Uni_Adelaide_LCI
  where_nans = where(LCI eq -999, count) & if count ge 1 then LCI[Where_nans] = !VALUES.F_NAN

  
  QLD_JRSP_LANDSAT_TOA_PV = FC_comp.QLD_JRSP_LANDSAT_TOA_PV
  where_nans = where(QLD_JRSP_LANDSAT_TOA_PV lt 0 OR QLD_JRSP_LANDSAT_TOA_PV gt 100, count) & if count ge 1 then QLD_JRSP_LANDSAT_TOA_PV[Where_nans] = !VALUES.F_NAN
  QLD_JRSP_LANDSAT_TOA_NPV = FC_comp.QLD_JRSP_LANDSAT_TOA_NPV
  where_nans = where(QLD_JRSP_LANDSAT_TOA_NPV lt 0 OR QLD_JRSP_LANDSAT_TOA_NPV gt 100, count) & if count ge 1 then QLD_JRSP_LANDSAT_TOA_NPV[Where_nans] = !VALUES.F_NAN
  QLD_JRSP_LANDSAT_TOA_BS = FC_comp.QLD_JRSP_LANDSAT_TOA_BS
  where_nans = where(QLD_JRSP_LANDSAT_TOA_BS lt 0 OR QLD_JRSP_LANDSAT_TOA_BS gt 100, count) & if count ge 1 then QLD_JRSP_LANDSAT_TOA_BS[Where_nans] = !VALUES.F_NAN
  QLD_JRSP_LANDSAT_TOA_PV *= 100
  QLD_JRSP_LANDSAT_TOA_NPV *= 100
  QLD_JRSP_LANDSAT_TOA_BS *= 100



  ; start making plots
  void = Label_Date(Date_Format= '%M %Y')
  init_date = Julday(1,1,2001)
  end_date = Julday(12,31,2012)
  xRange = [init_date, end_date]
  yRange = [-5,105]  
  
  folder = 'Z:\work\Juan_Pablo\ACEAS\comparison\plots\sites\'
  cd, folder
   
 
; start plots
;------------------------------------------------------------------------

    fname = 'scatterplots_observations_ALL_sites.png'
    fileInfo = FILE_INFO(fname)
    if fileInfo.exists eq 0 then begin
      yRange = [-5,105]  
      xRange = [-5,105]  
      PS_Start, fname   
        !P.Multi = [0, 2, 4]
        title = ''  
        ;SymSize = Scale_Vector(-ALOG10(SA), 0.2, 1.0)
        SymSize = 0.5
        CharSize_text = 0.5
        cgDisplay, 1200, 2000

        cgPlot, OBSERVED_PV, QLD_JRSP_LANDSAT_TOA_PV, psym=7, color='dark green', SymSize=0.5, charsize=2.0, $
          xRange=xRange, yRange=yRange, xStyle=1, yStyle=1, /ISOTROPIC, xTitle='observed', yTitle='JRSRP', title=title, /noData
        cgPlot, OBSERVED_PV, QLD_JRSP_LANDSAT_TOA_PV, psym=9, color='dark green', SymSize=SymSize, /overplot
        cgPlot, OBSERVED_NPV, QLD_JRSP_LANDSAT_TOA_NPV, psym=9, color='red', SymSize=SymSize, /overplot
        cgPlot, OBSERVED_BS, QLD_JRSP_LANDSAT_TOA_BS, psym=9, color='blue', SymSize=SymSize, /overplot
        cgPlot, [-10,110], [-10,110], psym=-3, /OVERPLOT
        cgText, 0, 98, 'r='+string(correlate_nan(OBSERVED_PV, QLD_JRSP_LANDSAT_TOA_PV), format='(f4.2)')+ $
          ' | RMSE='+string(RMSE(OBSERVED_PV, QLD_JRSP_LANDSAT_TOA_PV), format='(f4.1)')+$
          ' | n='+string(common_n(OBSERVED_PV, QLD_JRSP_LANDSAT_TOA_PV), format='(I3)'), $
          alignment=0, color='dark green', charsize=CharSize_text
        cgText, 0, 92, 'r='+string(correlate_nan(OBSERVED_NPV, QLD_JRSP_LANDSAT_TOA_NPV), format='(f4.2)')+ $
          ' | RMSE='+string(RMSE(OBSERVED_NPV, QLD_JRSP_LANDSAT_TOA_NPV), format='(f4.1)')+$
          ' | n='+string(common_n(OBSERVED_NPV, QLD_JRSP_LANDSAT_TOA_NPV), format='(I3)'), $
          alignment=0, color='red', charsize=CharSize_text
        cgText, 0, 86, 'r='+string(correlate_nan(OBSERVED_BS, QLD_JRSP_LANDSAT_TOA_BS), format='(f4.2)')+ $
          ' | RMSE='+string(RMSE(OBSERVED_BS, QLD_JRSP_LANDSAT_TOA_BS), format='(f4.1)')+$
          ' | n='+string(common_n(OBSERVED_BS, QLD_JRSP_LANDSAT_TOA_BS), format='(I3)'), $
          alignment=0, color='blue', charsize=CharSize_text
              
;        cgPlot, OBSERVED_PV, CSIRO_V2_1_PV, psym=7, color='dark green', SymSize=0.5, charsize=2.0, $
;          xRange=xRange, yRange=yRange, xStyle=1, yStyle=1, /ISOTROPIC, xTitle='OBSERVED', yTitle='CSIRO v2.1', title=title, /noData
;        cgPlotS, OBSERVED_PV, CSIRO_V2_1_PV, psym=9, color='dark green', SymSize=SymSize
;        cgPlotS, OBSERVED_NPV, CSIRO_V2_1_NPV, psym=9, color='red', SymSize=SymSize
;        cgPlotS, OBSERVED_BS, CSIRO_V2_1_BS, psym=9, color='blue', SymSize=SymSize
;        cgPlot, [-10,110], [-10,110], psym=-3, /OVERPLOT
          
        cgPlot, OBSERVED_PV, CSIRO_V2_2_PV, psym=7, color='dark green', SymSize=0.5, charsize=2.0, $
          xRange=xRange, yRange=yRange, xStyle=1, yStyle=1, /ISOTROPIC, xTitle='observed', yTitle='CSIRO v2.2', title=title, /noData
        cgPlot, OBSERVED_PV, CSIRO_V2_2_PV, psym=9, color='dark green', SymSize=SymSize, /overplot
        cgPlot, OBSERVED_NPV, CSIRO_V2_2_NPV, psym=9, color='red', SymSize=SymSize, /overplot
        cgPlot, OBSERVED_BS, CSIRO_V2_2_BS, psym=9, color='blue', SymSize=SymSize, /overplot
        cgPlot, [-10,110], [-10,110], psym=-3, /OVERPLOT
        cgText, 0, 98, 'r='+string(correlate_nan(OBSERVED_PV, CSIRO_V2_2_PV), format='(f4.2)')+ $
          ' | RMSE='+string(RMSE(OBSERVED_PV, CSIRO_V2_2_PV), format='(f4.1)')+$
          ' | n='+string(common_n(OBSERVED_PV, CSIRO_V2_2_PV), format='(I3)'), $
          alignment=0, color='dark green', charsize=CharSize_text
        cgText, 0, 92, 'r='+string(correlate_nan(OBSERVED_NPV, CSIRO_V2_2_NPV), format='(f4.2)')+ $
          ' | RMSE='+string(RMSE(OBSERVED_NPV, CSIRO_V2_2_NPV), format='(f4.1)')+$
          ' | n='+string(common_n(OBSERVED_BS, CSIRO_V2_2_NPV), format='(I3)'), $
          alignment=0, color='red', charsize=CharSize_text
        cgText, 0, 86, 'r='+string(correlate_nan(OBSERVED_BS, CSIRO_V2_2_BS), format='(f4.2)')+ $
          ' | RMSE='+string(RMSE(OBSERVED_BS, CSIRO_V2_2_BS), format='(f4.1)')+$
          ' | n='+string(common_n(OBSERVED_BS, CSIRO_V2_2_BS), format='(I3)'), $
          alignment=0, color='blue', charsize=CharSize_text

        cgPlot, OBSERVED_PV, CSIRO_V3_0_PV, psym=7, color='dark green', SymSize=0.5, charsize=2.0, $
          xRange=xRange, yRange=yRange, xStyle=1, yStyle=1, /ISOTROPIC, xTitle='observed', yTitle='CSIRO v3.0', title=title, /noData
        cgPlot, OBSERVED_PV, CSIRO_V3_0_PV, psym=9, color='dark green', SymSize=SymSize, /overplot
        cgPlot, OBSERVED_NPV, CSIRO_V3_0_NPV, psym=9, color='red', SymSize=SymSize, /overplot
        cgPlot, OBSERVED_BS, CSIRO_V3_0_BS, psym=9, color='blue', SymSize=SymSize, /overplot
        cgPlot, [-10,110], [-10,110], psym=-3, /OVERPLOT
        cgText, 0, 98, 'r='+string(correlate_nan(OBSERVED_PV, CSIRO_V3_0_PV), format='(f4.2)')+ $
          ' | RMSE='+string(RMSE(OBSERVED_PV, CSIRO_V3_0_PV), format='(f4.1)')+$
          ' | n='+string(common_n(OBSERVED_PV, CSIRO_V3_0_PV), format='(I3)'), $
          alignment=0, color='dark green', charsize=CharSize_text
        cgText, 0, 92, 'r='+string(correlate_nan(OBSERVED_NPV, CSIRO_V3_0_NPV), format='(f4.2)')+ $
          ' | RMSE='+string(RMSE(OBSERVED_NPV, CSIRO_V3_0_NPV), format='(f4.1)')+$
          ' | n='+string(common_n(OBSERVED_NPV, CSIRO_V3_0_NPV), format='(I3)'), $
          alignment=0, color='red', charsize=CharSize_text
        cgText, 0, 86, 'r='+string(correlate_nan(OBSERVED_BS, CSIRO_V3_0_BS), format='(f4.2)')+ $
          ' | RMSE='+string(RMSE(OBSERVED_BS, CSIRO_V3_0_BS), format='(f4.1)')+$
          ' | n='+string(common_n(OBSERVED_BS, CSIRO_V3_0_BS), format='(I3)'), $
          alignment=0, color='blue', charsize=CharSize_text

        cgPlot, OBSERVED_PV, SMA_GV, psym=7, color='dark green', SymSize=0.5, charsize=2.0, $
          xRange=xRange, yRange=yRange, xStyle=1, yStyle=1, /ISOTROPIC, xTitle='observed', yTitle='UCLA SMA', title=title, /noData
        cgPlot, OBSERVED_PV, SMA_GV, psym=9, color='dark green', SymSize=SymSize, /overplot
        cgPlot, OBSERVED_NPV, SMA_NPV, psym=9, color='red', SymSize=SymSize, /overplot
        cgPlot, OBSERVED_BS, SMA_SOIL, psym=9, color='blue', SymSize=SymSize, /overplot
        cgPlot, [-10,110], [-10,110], psym=-3, /OVERPLOT
        cgText, 0, 98, 'r='+string(correlate_nan(OBSERVED_PV, SMA_GV), format='(f4.2)')+ $
          ' | RMSE='+string(RMSE(OBSERVED_PV, SMA_GV), format='(f4.1)')+$
          ' | n='+string(common_n(OBSERVED_PV, SMA_GV), format='(I3)'), $
          alignment=0, color='dark green', charsize=CharSize_text
        cgText, 0, 92, 'r='+string(correlate_nan(OBSERVED_NPV, SMA_NPV), format='(f4.2)')+ $
          ' | RMSE='+string(RMSE(OBSERVED_NPV, SMA_NPV), format='(f4.1)')+$
          ' | n='+string(common_n(OBSERVED_NPV, SMA_NPV), format='(I3)'), $
          alignment=0, color='red', charsize=CharSize_text
        cgText, 0, 86, 'r='+string(correlate_nan(OBSERVED_BS, SMA_SOIL), format='(f4.2)')+ $
          ' | RMSE='+string(RMSE(OBSERVED_BS, SMA_SOIL), format='(f4.1)')+$
          ' | n='+string(common_n(OBSERVED_BS, SMA_SOIL), format='(I3)'), $
          alignment=0, color='blue', charsize=CharSize_text

        cgPlot, OBSERVED_PV, MESMA_GV, psym=7, color='dark green', SymSize=0.5, charsize=2.0, $
          xRange=xRange, yRange=yRange, xStyle=1, yStyle=1, /ISOTROPIC, xTitle='observed', yTitle='UCLA MESMA', title=title, /noData
        cgPlot, OBSERVED_PV, MESMA_GV, psym=9, color='dark green', SymSize=SymSize, /overplot
        cgPlot, OBSERVED_NPV, MESMA_NPV, psym=9, color='red', SymSize=SymSize, /overplot
        cgPlot, OBSERVED_BS, MESMA_SOIL, psym=9, color='blue', SymSize=SymSize, /overplot
        cgPlot, [-10,110], [-10,110], psym=-3, /OVERPLOT
        cgText, 0, 98, 'r='+string(correlate_nan(OBSERVED_PV, MESMA_GV), format='(f4.2)')+ $
          ' | RMSE='+string(RMSE(OBSERVED_PV, MESMA_GV), format='(f4.1)')+$
          ' | n='+string(common_n(OBSERVED_PV, MESMA_GV), format='(I3)'), $
          alignment=0, color='dark green', charsize=CharSize_text
        cgText, 0, 92, 'r='+string(correlate_nan(OBSERVED_NPV, MESMA_NPV), format='(f4.2)')+ $
          ' | RMSE='+string(RMSE(OBSERVED_NPV, MESMA_NPV), format='(f4.1)')+$
          ' | n='+string(common_n(OBSERVED_NPV, MESMA_NPV), format='(I3)'), $
          alignment=0, color='red', charsize=CharSize_text
        cgText, 0, 86, 'r='+string(correlate_nan(OBSERVED_BS, MESMA_SOIL), format='(f4.2)')+ $
          ' | RMSE='+string(RMSE(OBSERVED_BS, MESMA_SOIL), format='(f4.1)')+$
          ' | n='+string(common_n(OBSERVED_BS, MESMA_SOIL), format='(I3)'), $
          alignment=0, color='blue', charsize=CharSize_text
      
        cgPlot, OBSERVED_PV, RSMA_GV, psym=7, color='dark green', SymSize=0.5, charsize=2.0, $
          xRange=xRange, yRange=[-.85, 0.75],       xStyle=1,            /ISOTROPIC, xTitle='observed', yTitle='UCLA RSMA', title=title, /NoData
        cgPlot, OBSERVED_PV, RSMA_GV, psym=9, color='dark green', SymSize=SymSize, /overplot
        cgPlot, OBSERVED_NPV, RSMA_NPV, psym=9, color='red', SymSize=SymSize, /overplot
        cgPlot, OBSERVED_BS, RSMA_SOIL, psym=9, color='BLUE', SymSize=SymSize, /overplot
        ;cgPlot, [-10,110], [-10,110], psym=-3, /OVERPLOT
        cgText, 100, -.6, 'r='+string(correlate_nan(OBSERVED_PV, RSMA_GV), format='(f4.2)')+$
          ' | n='+string(common_n(OBSERVED_PV, RSMA_GV), format='(I3)'), $
          alignment=1, color='dark green', charsize=CharSize_text
        cgText, 100, -.7, 'r='+string(correlate_nan(OBSERVED_NPV, RSMA_NPV), format='(f4.2)')+$
          ' | n='+string(common_n(OBSERVED_PV, RSMA_GV), format='(I3)'), $
          alignment=1, color='red', charsize=CharSize_text
        cgText, 100, -.8, 'r='+string(correlate_nan(OBSERVED_BS, RSMA_SOIL), format='(f4.2)')+$
          ' | n='+string(common_n(OBSERVED_PV, RSMA_GV), format='(I3)'), $
          alignment=1, color='blue', charsize=CharSize_text
        
        cgPlot, OBSERVED_PV+OBSERVED_NPV, LCI, psym=7, color='brown', SymSize=0.5, charsize=2.0, $
          xRange=xRange, yRange=[0, 0.68],       xStyle=1,          /ISOTROPIC, xTitle='observed (PV+NPV)', yTitle='Uni Adelaide LCI', title=title, /NoData
        cgPlot, OBSERVED_PV+OBSERVED_NPV, LCI, psym=9, color='brown', SymSize=SymSize, /overplot
        ;cgPlot, OBSERVED_NPV[where_site], RSMA_NPV[where_site], psym=9, color='red', /OVERPLOT, SymSize=2 
        ;cgPlot, OBSERVED_BS[where_site], RSMA_SOIL[where_site], psym=9, color='BLUE', /OVERPLOT, SymSize=2 
        ;cgPlot, [-10,110], [-10,110], psym=-3, /OVERPLOT
        cgText, 0, 0.6, 'r='+string(correlate_nan(OBSERVED_PV+OBSERVED_NPV, LCI), format='(f4.2)')+$
          ' | n='+string(common_n(OBSERVED_PV+OBSERVED_NPV, LCI), format='(I3)'), $
          alignment=0, color='BROWN', charsize=CharSize_text
 
      PS_End,  /PNG, Resize=100
    ENDIF
 
  
  for i=0, Uniq_Sites_n-1 do begin
    site = Uniq_Sites[i]
  
    where_site = Where(FC_comp.site_ID eq site, count_site)

    fname = 'CSIRO_V2.1_time_series_'+site+'.png'
    fileInfo = FILE_INFO(fname)
    if fileInfo.exists eq 0 then begin
      PS_Start, fname   
        !P.Multi = 0 
        cgDisplay, 1000, 300 
        title = site + ' | CSIRO_V2.1'
        cgPlot, dates[where_site], CSIRO_V2_1_PV[where_site], XTickFormat='Label_Date', color='Dark Green', psym=-1, title=title, xRange=xRange, yRange=yRange, xStyle=1, yStyle=1
        cgPlot, dates[where_site], CSIRO_V2_1_NPV[where_site], color='Red',psym=-1, /overplot
        cgPlot, dates[where_site], CSIRO_V2_1_BS[where_site], color='Blue',psym=-1, /overplot
        cgPlot, dates[where_site], OBSERVED_PV[where_site], color='DARK GREEN',psym=16, symsize=2, /overplot
        cgPlot, dates[where_site], OBSERVED_NPV[where_site], color='red',psym=16, symsize=2, /overplot
        cgPlot, dates[where_site], OBSERVED_BS[where_site], color='blue',psym=16, symsize=2, /overplot
      PS_End,  /PNG, Resize=100   
    ENDIF
          
    fname = 'CSIRO_V2.2_time_series_'+site+'.png'
    fileInfo = FILE_INFO(fname)
    if fileInfo.exists eq 0 then begin
      PS_Start, fname   
        !P.Multi = 0 
        cgDisplay, 1000, 300 
        title = site + ' | CSIRO_V2.2'
        cgPlot, dates[where_site], CSIRO_V2_2_PV[where_site], XTickFormat='Label_Date', color='Dark Green', psym=-1, title=title, xRange=xRange, yRange=yRange, xStyle=1, yStyle=1
        cgPlot, dates[where_site], CSIRO_V2_2_NPV[where_site], color='Red',psym=-1, /overplot
        cgPlot, dates[where_site], CSIRO_V2_2_BS[where_site], color='Blue',psym=-1, /overplot
        cgPlot, dates[where_site], OBSERVED_PV[where_site], color='DARK GREEN',psym=16, symsize=2, /overplot
        cgPlot, dates[where_site], OBSERVED_NPV[where_site], color='red',psym=16, symsize=2, /overplot
        cgPlot, dates[where_site], OBSERVED_BS[where_site], color='blue',psym=16, symsize=2, /overplot
      PS_End,  /PNG, Resize=100   
    ENDIF
          
    fname = 'CSIRO_V3.0_time_series_'+site+'.png'
    fileInfo = FILE_INFO(fname)
    if fileInfo.exists eq 0 then begin
      PS_Start, fname   
        !P.Multi = 0 
        cgDisplay, 1000, 300 
        title = site + ' | CSIRO_V3.0'
        cgPlot, dates[where_site], CSIRO_V3_0_PV[where_site], XTickFormat='Label_Date', color='Dark Green', psym=-1, title=title, xRange=xRange, yRange=yRange, xStyle=1, yStyle=1
        cgPlot, dates[where_site], CSIRO_V3_0_NPV[where_site], color='Red',psym=-1, /overplot
        cgPlot, dates[where_site], CSIRO_V3_0_BS[where_site], color='Blue',psym=-1, /overplot
        cgPlot, dates[where_site], OBSERVED_PV[where_site], color='DARK GREEN',psym=16, symsize=2, /overplot
        cgPlot, dates[where_site], OBSERVED_NPV[where_site], color='red',psym=16, symsize=2, /overplot
        cgPlot, dates[where_site], OBSERVED_BS[where_site], color='blue',psym=16, symsize=2, /overplot
      PS_End,  /PNG, Resize=100   
    ENDIF

          
    fname = 'SMA_time_series_'+site+'.png'
    fileInfo = FILE_INFO(fname)
    if fileInfo.exists eq 0 then begin
      PS_Start, fname   
        !P.Multi = 0 
        title = site + ' | Okin SMA'
        cgDisplay, 1000, 300 
        cgPlot, dates[where_site], SMA_GV[where_site], XTickFormat='Label_Date', color='Dark Green', psym=-1, title=title, xRange=xRange, yRange=yRange, xStyle=1, yStyle=1
        cgPlot, dates[where_site], SMA_NPV[where_site], color='Red',psym=-1, /overplot
        cgPlot, dates[where_site], SMA_SOIL[where_site], color='Blue',psym=-1, /overplot
        cgPlot, dates[where_site], OBSERVED_PV[where_site], color='DARK GREEN',psym=16, symsize=2, /overplot
        cgPlot, dates[where_site], OBSERVED_NPV[where_site], color='red',psym=16, symsize=2, /overplot
        cgPlot, dates[where_site], OBSERVED_BS[where_site], color='blue',psym=16, symsize=2, /overplot
      PS_End,  /PNG, Resize=100   
    ENDIF

    fname = 'QLD_JRSP_LANDSAT_TOA_time_series_'+site+'.png'
    fileInfo = FILE_INFO(fname)
    if fileInfo.exists eq 0 then begin
      PS_Start, fname   
        !P.Multi = 0 
        title = site + ' | QLD_JRSP_LANDSAT_TOA'
        cgDisplay, 1000, 300 
        cgPlot, dates[where_site], QLD_JRSP_LANDSAT_TOA_PV[where_site], XTickFormat='Label_Date', color='Dark Green', psym=-1, title=title, xRange=xRange, yRange=yRange, xStyle=1, yStyle=1
        cgPlot, dates[where_site], QLD_JRSP_LANDSAT_TOA_NPV[where_site], color='Red',psym=-1, /overplot
        cgPlot, dates[where_site], QLD_JRSP_LANDSAT_TOA_BS[where_site], color='Blue',psym=-1, /overplot
        cgPlot, dates[where_site], OBSERVED_PV[where_site], color='DARK GREEN',psym=16, symsize=2, /overplot
        cgPlot, dates[where_site], OBSERVED_NPV[where_site], color='red',psym=16, symsize=2, /overplot
        cgPlot, dates[where_site], OBSERVED_BS[where_site], color='blue',psym=16, symsize=2, /overplot
      PS_End,  /PNG, Resize=100   
    ENDIF



    fname = 'ALL_time_series_'+site+'.png'
    fileInfo = FILE_INFO(fname)
    if fileInfo.exists eq 0 then begin
      yRange = [-5,115]  
      PS_Start, fname   
        !P.Multi = [0, 1, 3]
        legend_title = ['CSIRO V2.1','CSIRO V2.2','OKIN SMA','QLD_JRSP_LANDSAT_TOA', 'observed']
        legend_sym = [-1, -1, -1, -3, 16]
        legend_color = ['magenta','red','dark green','blue', 'black']
        legend_charsize = 0.6
        title = 'site: ' + site + ' | photosyntetic vegetation'
        cgDisplay, 1200, 1000
        cgPlot, dates[where_site], CSIRO_V2_1_PV[where_site], XTickFormat='Label_Date', color='magenta', $
                psym=-1, title=title, xRange=xRange, yRange=yRange, xStyle=1, yStyle=1, symsize=0.5
        cgPlot, dates[where_site], CSIRO_V2_2_PV[where_site], color='red', psym=-1, symsize=0.5, /overplot
        cgPlot, dates[where_site], SMA_GV[where_site], color='dark green', psym=-1, symsize=0.5, /overplot
        cgPlot, dates[where_site], QLD_JRSP_LANDSAT_TOA_PV[where_site], color='blue', psym=-3, /overplot
       ;cgPlot   THE OTHER METHODS   
        cgPlot, dates[where_site], OBSERVED_PV[where_site], color='black',psym=16, symsize=1, /overplot
        al_Legend, legend_title, Psym=legend_sym, color=legend_color, charsize=legend_charsize, /right
        

        title = 'site: ' + site + ' | non-photosyntetic vegetation'
        cgPlot, dates[where_site], CSIRO_V2_1_NPV[where_site], XTickFormat='Label_Date', color='magenta', $
                psym=-1, title=title, xRange=xRange, yRange=yRange, xStyle=1, yStyle=1, symsize=0.5
        cgPlot, dates[where_site], CSIRO_V2_2_NPV[where_site], color='red', psym=-1, symsize=0.5, /overplot
        cgPlot, dates[where_site], SMA_NPV[where_site], color='dark green', psym=-1, symsize=0.5, /overplot
        cgPlot, dates[where_site], QLD_JRSP_LANDSAT_TOA_NPV[where_site], color='blue', psym=-3, /overplot
       ;cgPlot   THE OTHER METHODS   
        cgPlot, dates[where_site], OBSERVED_NPV[where_site], color='black',psym=16, symsize=1, /overplot
        al_Legend, legend_title, Psym=legend_sym, color=legend_color, charsize=legend_charsize, /right
        

        title = 'site: ' + site + ' | bare ground'
        cgPlot, dates[where_site], CSIRO_V2_1_BS[where_site], XTickFormat='Label_Date', color='magenta', $
                psym=-1, title=title, xRange=xRange, yRange=yRange, xStyle=1, yStyle=1, symsize=0.5
        cgPlot, dates[where_site], CSIRO_V2_2_BS[where_site], color='red', psym=-1, symsize=0.5, /overplot
        cgPlot, dates[where_site], SMA_SOIL[where_site], color='dark green', psym=-1, symsize=0.5, /overplot
        cgPlot, dates[where_site], QLD_JRSP_LANDSAT_TOA_BS[where_site], color='blue', psym=-3, /overplot
       ;cgPlot   THE OTHER METHODS   
        cgPlot, dates[where_site], OBSERVED_BS[where_site], color='black',psym=16, symsize=1, /overplot
        al_Legend, legend_title, Psym=legend_sym, color=legend_color, charsize=legend_charsize, /right
        
      PS_End,  /PNG, Resize=100
    ENDIF

 


    fname = 'scatterplots_observations_'+site+'.png'
    fileInfo = FILE_INFO(fname)
    if fileInfo.exists eq 0 then begin
      yRange = [-5,105]  
      xRange = [-5,105]  
      PS_Start, fname   
        !P.Multi = [0, 3, 3]
        ;SymSize = Scale_Vector(-ALOG10(SA[where_site]), 0.5, 2.0)
        SymSize = 1.5
        title = site  
        cgDisplay, 1500, 1500
      
        cgPlot, OBSERVED_PV[where_site], QLD_JRSP_LANDSAT_TOA_PV[where_site], psym=7, color='dark green', SymSize=0.5, $
          xRange=xRange, yRange=yRange, xStyle=1, yStyle=1, /ISOTROPIC, xTitle='OBSERVED', yTitle='QLD_JRSP_LANDSAT_TOA', title=title, /noData
        cgPlotS, OBSERVED_PV[where_site], QLD_JRSP_LANDSAT_TOA_PV[where_site], psym=9, color='dark green', SymSize=SymSize
        cgPlotS, OBSERVED_NPV[where_site], QLD_JRSP_LANDSAT_TOA_NPV[where_site], psym=9, color='red', SymSize=SymSize
        cgPlotS, OBSERVED_BS[where_site], QLD_JRSP_LANDSAT_TOA_BS[where_site], psym=9, color='blue', SymSize=SymSize
        cgPlot, [-10,110], [-10,110], psym=-3, /OVERPLOT
        cgText, 100, 20, 'r='+string(correlate_nan(OBSERVED_PV[where_site], QLD_JRSP_LANDSAT_TOA_PV[where_site]), format='(f5.2)'), alignment=1, color='dark green'
        cgText, 100, 10, 'r='+string(correlate_nan(OBSERVED_NPV[where_site], QLD_JRSP_LANDSAT_TOA_NPV[where_site]), format='(f5.2)'), alignment=1, color='red'
        cgText, 100, 0, 'r='+string(correlate_nan(OBSERVED_BS[where_site], QLD_JRSP_LANDSAT_TOA_BS[where_site]), format='(f5.2)'), alignment=1, color='blue'

        cgPlot, OBSERVED_PV[where_site], CSIRO_V2_1_PV[where_site], psym=7, color='dark green', SymSize=0.5, $
          xRange=xRange, yRange=yRange, xStyle=1, yStyle=1, /ISOTROPIC, xTitle='OBSERVED', yTitle='CSIRO v2.1', title=title, /noData
        cgPlotS, OBSERVED_PV[where_site], CSIRO_V2_1_PV[where_site], psym=9, color='dark green', SymSize=SymSize
        cgPlotS, OBSERVED_NPV[where_site], CSIRO_V2_1_NPV[where_site], psym=9, color='red', SymSize=SymSize
        cgPlotS, OBSERVED_BS[where_site], CSIRO_V2_1_BS[where_site], psym=9, color='blue', SymSize=SymSize
        cgPlot, [-10,110], [-10,110], psym=-3, /OVERPLOT
        cgText, 100, 20, 'r='+string(correlate_nan(OBSERVED_PV[where_site], CSIRO_V2_1_PV[where_site]), format='(f5.2)'), alignment=1, color='dark green'
        cgText, 100, 10, 'r='+string(correlate_nan(OBSERVED_NPV[where_site], CSIRO_V2_1_NPV[where_site]), format='(f5.2)'), alignment=1, color='red'
        cgText, 100, 0, 'r='+string(correlate_nan(OBSERVED_BS[where_site], CSIRO_V2_1_BS[where_site]), format='(f5.2)'), alignment=1, color='blue'
          
        cgPlot, OBSERVED_PV[where_site], CSIRO_V2_2_PV[where_site], psym=7, color='dark green', SymSize=0.5, $
          xRange=xRange, yRange=yRange, xStyle=1, yStyle=1, /ISOTROPIC, xTitle='OBSERVED', yTitle='CSIRO v2.2', title=title, /noData
        cgPlotS, OBSERVED_PV[where_site], CSIRO_V2_2_PV[where_site], psym=9, color='dark green', SymSize=SymSize
        cgPlotS, OBSERVED_NPV[where_site], CSIRO_V2_2_NPV[where_site], psym=9, color='red', SymSize=SymSize
        cgPlotS, OBSERVED_BS[where_site], CSIRO_V2_2_BS[where_site], psym=9, color='blue', SymSize=SymSize
        cgPlot, [-10,110], [-10,110], psym=-3, /OVERPLOT
        cgText, 100, 20, 'r='+string(correlate_nan(OBSERVED_PV[where_site], CSIRO_V2_2_PV[where_site]), format='(f5.2)'), alignment=1, color='dark green'
        cgText, 100, 10, 'r='+string(correlate_nan(OBSERVED_NPV[where_site], CSIRO_V2_2_NPV[where_site]), format='(f5.2)'), alignment=1, color='red'
        cgText, 100, 0, 'r='+string(correlate_nan(OBSERVED_BS[where_site], CSIRO_V2_2_BS[where_site]), format='(f5.2)'), alignment=1, color='blue'

        cgPlot, OBSERVED_PV[where_site], CSIRO_V3_0_PV[where_site], psym=7, color='dark green', SymSize=0.5, $
          xRange=xRange, yRange=yRange, xStyle=1, yStyle=1, /ISOTROPIC, xTitle='OBSERVED', yTitle='CSIRO v2.2', title=title, /noData
        cgPlotS, OBSERVED_PV[where_site], CSIRO_V3_0_PV[where_site], psym=9, color='dark green', SymSize=SymSize
        cgPlotS, OBSERVED_NPV[where_site], CSIRO_V3_0_NPV[where_site], psym=9, color='red', SymSize=SymSize
        cgPlotS, OBSERVED_BS[where_site], CSIRO_V3_0_BS[where_site], psym=9, color='blue', SymSize=SymSize
        cgPlot, [-10,110], [-10,110], psym=-3, /OVERPLOT
        cgText, 100, 20, 'r='+string(correlate_nan(OBSERVED_PV[where_site], CSIRO_V3_0_PV[where_site]), format='(f5.2)'), alignment=1, color='dark green'
        cgText, 100, 10, 'r='+string(correlate_nan(OBSERVED_NPV[where_site], CSIRO_V3_0_NPV[where_site]), format='(f5.2)'), alignment=1, color='red'
        cgText, 100, 0, 'r='+string(correlate_nan(OBSERVED_BS[where_site], CSIRO_V3_0_BS[where_site]), format='(f5.2)'), alignment=1, color='blue'

        cgPlot, OBSERVED_PV[where_site], SMA_GV[where_site], psym=7, color='dark green', SymSize=0.5, $
          xRange=xRange, yRange=yRange, xStyle=1, yStyle=1, /ISOTROPIC, xTitle='OBSERVED', yTitle='OKIN SMA', title=title, /noData
        cgPlotS, OBSERVED_PV[where_site], SMA_GV[where_site], psym=9, color='dark green', SymSize=SymSize
        cgPlotS, OBSERVED_NPV[where_site], SMA_NPV[where_site], psym=9, color='red', SymSize=SymSize
        cgPlotS, OBSERVED_BS[where_site], SMA_SOIL[where_site], psym=9, color='blue', SymSize=SymSize
        cgPlot, [-10,110], [-10,110], psym=-3, /OVERPLOT
        cgText, 100, 20, 'r='+string(correlate_nan(OBSERVED_PV[where_site], SMA_GV[where_site]), format='(f5.2)'), alignment=1, color='dark green'
        cgText, 100, 10, 'r='+string(correlate_nan(OBSERVED_NPV[where_site], SMA_NPV[where_site]), format='(f5.2)'), alignment=1, color='red'
        cgText, 100, 0, 'r='+string(correlate_nan(OBSERVED_BS[where_site], SMA_SOIL[where_site]), format='(f5.2)'), alignment=1, color='blue'
              
        yRange=[MIN([RSMA_GV,RSMA_NPV,RSMA_SOIL], /nan), MAx([RSMA_GV,RSMA_NPV,RSMA_SOIL], /nan)]
        cgPlot, OBSERVED_PV[where_site], RSMA_GV[where_site], psym=7, color='dark green', SymSize=0.5, $
          xRange=xRange, yRange=yRange, xStyle=1, /ISOTROPIC, xTitle='OBSERVED', yTitle='OKIN RSMA', title=title, /NoData
        cgPlotS, OBSERVED_PV[where_site], RSMA_GV[where_site], psym=9, color='dark green', SymSize=SymSize
        cgPlotS, OBSERVED_NPV[where_site], RSMA_NPV[where_site], psym=9, color='red', SymSize=SymSize
        cgPlotS, OBSERVED_BS[where_site], RSMA_SOIL[where_site], psym=9, color='BLUE', SymSize=SymSize
        ;cgPlot, [-10,110], [-10,110], psym=-3, /OVERPLOT
        cgText, 100, -0.5, 'r='+string(correlate_nan(OBSERVED_PV[where_site], RSMA_GV[where_site]), format='(f5.2)'), alignment=1, color='dark green'
        cgText, 100, -0.75, 'r='+string(correlate_nan(OBSERVED_NPV[where_site], RSMA_NPV[where_site]), format='(f5.2)'), alignment=1, color='red'
        cgText, 100, -1, 'r='+string(correlate_nan(OBSERVED_BS[where_site], RSMA_SOIL[where_site]), format='(f5.2)'), alignment=1, color='blue'
        
        yRange=[MIN(LCI, /nan), MAX(LCI, /nan)]
        cgPlot, (OBSERVED_PV+OBSERVED_NPV)[where_site], LCI[where_site], psym=7, color='brown', SymSize=0.5, $
          xRange=xRange, yRange=yRange, xStyle=1,          /ISOTROPIC, xTitle='OBSERVED (PV+NPV)', yTitle='Uni Adelaide LCI', title=title, /NoData
        cgPlotS, (OBSERVED_PV+OBSERVED_NPV)[where_site], LCI[where_site], psym=9, color='brown', SymSize=SymSize
        ;cgPlot, OBSERVED_NPV[where_site], RSMA_NPV[where_site], psym=9, color='red', /OVERPLOT, SymSize=2 
        ;cgPlot, OBSERVED_BS[where_site], RSMA_SOIL[where_site], psym=9, color='BLUE', /OVERPLOT, SymSize=2 
        ;cgPlot, [-10,110], [-10,110], psym=-3, /OVERPLOT
        cgText, 100, -0.1, 'r='+string(correlate_nan(OBSERVED_BS[where_site], LCI[where_site]), format='(f5.2)'), alignment=1, color='brown'

      PS_End,  /PNG, Resize=100
    ENDIF

    fname = 'scatterplots_models_'+site+'.png'
    fileInfo = FILE_INFO(fname)
    if fileInfo.exists eq 0 then begin
      yRange = [-5,105]  
      xRange = [-5,105]  
      PS_Start, fname   
        !P.Multi = [0, 3, 2]
        title = site
        cgDisplay, 1800, 1000
        
        cgPlot, CSIRO_V2_1_PV[where_site], CSIRO_V2_2_PV[where_site], psym=1, symsize=0.5, color='dark green', $
          xRange=xRange, yRange=yRange, xStyle=1, yStyle=1, /ISOTROPIC, xTitle='CSIRO V2.1', yTitle='CSIRO V2.2', title=title 
        cgPlot, CSIRO_V2_1_NPV[where_site], CSIRO_V2_2_NPV[where_site], psym=1, symsize=0.5, color='red', /OVERPLOT
        cgPlot, CSIRO_V2_1_BS[where_site], CSIRO_V2_2_BS[where_site], psym=1, symsize=0.5, color='BLUE', /OVERPLOT
        cgPlot, [-10,110], [-10,110], psym=-3, /OVERPLOT

        
        cgPlot, CSIRO_V2_1_PV[where_site], SMA_GV[where_site], psym=1, symsize=0.5, color='dark green', $
          xRange=xRange, yRange=yRange, xStyle=1, yStyle=1, /ISOTROPIC, xTitle='CSIRO V2.1', yTitle='OKIN SMA', title=title 
        cgPlot, CSIRO_V2_1_NPV[where_site], SMA_NPV[where_site], psym=1, symsize=0.5, color='red', /OVERPLOT
        cgPlot, CSIRO_V2_1_BS[where_site], SMA_SOIL[where_site], psym=1, symsize=0.5, color='BLUE', /OVERPLOT
        cgPlot, [-10,110], [-10,110], psym=-3, /OVERPLOT

        cgPlot, CSIRO_V2_1_PV[where_site], QLD_JRSP_LANDSAT_TOA_PV[where_site], psym=1, symsize=0.5, color='dark green', $
          xRange=xRange, yRange=yRange, xStyle=1, yStyle=1, /ISOTROPIC, xTitle='CSIRO V2.1', yTitle='QLD_JRSP_LANDSAT_TOA', title=title 
        cgPlot, CSIRO_V2_1_NPV[where_site], QLD_JRSP_LANDSAT_TOA_NPV[where_site], psym=1, symsize=0.5, color='red', /OVERPLOT
        cgPlot, CSIRO_V2_1_BS[where_site], QLD_JRSP_LANDSAT_TOA_BS[where_site], psym=1, symsize=0.5, color='BLUE', /OVERPLOT
        cgPlot, [-10,110], [-10,110], psym=-3, /OVERPLOT

        cgPlot, CSIRO_V2_2_PV[where_site], SMA_GV[where_site], psym=1, symsize=0.5, color='dark green', $
          xRange=xRange, yRange=yRange, xStyle=1, yStyle=1, /ISOTROPIC, xTitle='CSIRO V2.2', yTitle='OKIN SMA', title=title 
        cgPlot, CSIRO_V2_2_NPV[where_site], SMA_NPV[where_site], psym=1, symsize=0.5, color='red', /OVERPLOT
        cgPlot, CSIRO_V2_2_BS[where_site], SMA_SOIL[where_site], psym=1, symsize=0.5, color='BLUE', /OVERPLOT
        cgPlot, [-10,110], [-10,110], psym=-3, /OVERPLOT

        cgPlot, CSIRO_V2_2_PV[where_site], QLD_JRSP_LANDSAT_TOA_PV[where_site], psym=1, symsize=0.5, color='dark green', $
          xRange=xRange, yRange=yRange, xStyle=1, yStyle=1, /ISOTROPIC, xTitle='CSIRO V2.2', yTitle='QLD_JRSP_LANDSAT_TOA', title=title 
        cgPlot, CSIRO_V2_2_NPV[where_site], QLD_JRSP_LANDSAT_TOA_NPV[where_site], psym=1, symsize=0.5, color='red', /OVERPLOT
        cgPlot, CSIRO_V2_2_BS[where_site], QLD_JRSP_LANDSAT_TOA_BS[where_site], psym=1, symsize=0.5, color='BLUE', /OVERPLOT
        cgPlot, [-10,110], [-10,110], psym=-3, /OVERPLOT

        cgPlot, SMA_GV[where_site], QLD_JRSP_LANDSAT_TOA_PV[where_site], psym=1, symsize=0.5, color='dark green', $
          xRange=xRange, yRange=yRange, xStyle=1, yStyle=1, /ISOTROPIC, xTitle='OKIN SMA', yTitle='QLD_JRSP_LANDSAT_TOA', title=title 
        cgPlot, SMA_NPV[where_site], QLD_JRSP_LANDSAT_TOA_NPV[where_site], psym=1, symsize=0.5, color='red', /OVERPLOT
        cgPlot, SMA_SOIL[where_site], QLD_JRSP_LANDSAT_TOA_BS[where_site], psym=1, symsize=0.5, color='BLUE', /OVERPLOT
        cgPlot, [-10,110], [-10,110], psym=-3, /OVERPLOT

      PS_End,  /PNG, Resize=100
    endif  

    fname = 'scatterplots_models_ALL_sites.png'
    fileInfo = FILE_INFO(fname)
    if fileInfo.exists eq 0 then begin
      yRange = [-5,105]  
      xRange = [-5,105]  
      PS_Start, fname   
        !P.Multi = [0, 3, 2]
        title = 'ALL sites'  
        cgDisplay, 1800, 1000
        
        cgPlot, CSIRO_V2_1_PV, CSIRO_V2_2_PV, psym=3, color='dark green', $
          xRange=xRange, yRange=yRange, xStyle=1, yStyle=1, /ISOTROPIC, xTitle='CSIRO V2.1', yTitle='CSIRO V2.2', title=title 
        cgPlot, CSIRO_V2_1_NPV, CSIRO_V2_2_NPV, psym=3, color='red', /OVERPLOT
        cgPlot, CSIRO_V2_1_BS, CSIRO_V2_2_BS, psym=3, color='BLUE', /OVERPLOT
        cgPlot, [-10,110], [-10,110], psym=-3, /OVERPLOT

        
        cgPlot, CSIRO_V2_1_PV, SMA_GV, psym=3, color='dark green', $
          xRange=xRange, yRange=yRange, xStyle=1, yStyle=1, /ISOTROPIC, xTitle='CSIRO V2.1', yTitle='OKIN SMA', title=title 
        cgPlot, CSIRO_V2_1_NPV, SMA_NPV, psym=3, color='red', /OVERPLOT
        cgPlot, CSIRO_V2_1_BS, SMA_SOIL, psym=3, color='BLUE', /OVERPLOT
        cgPlot, [-10,110], [-10,110], psym=-3, /OVERPLOT

        cgPlot, CSIRO_V2_1_PV, QLD_JRSP_LANDSAT_TOA_PV, psym=3, color='dark green', $
          xRange=xRange, yRange=yRange, xStyle=1, yStyle=1, /ISOTROPIC, xTitle='CSIRO V2.1', yTitle='QLD_JRSP_LANDSAT_TOA', title=title 
        cgPlot, CSIRO_V2_1_NPV, QLD_JRSP_LANDSAT_TOA_NPV, psym=3, color='red', /OVERPLOT
        cgPlot, CSIRO_V2_1_BS, QLD_JRSP_LANDSAT_TOA_BS, psym=3, color='BLUE', /OVERPLOT
        cgPlot, [-10,110], [-10,110], psym=-3, /OVERPLOT

        cgPlot, CSIRO_V2_2_PV, SMA_GV, psym=3, color='dark green', $
          xRange=xRange, yRange=yRange, xStyle=1, yStyle=1, /ISOTROPIC, xTitle='CSIRO V2.2', yTitle='OKIN SMA', title=title 
        cgPlot, CSIRO_V2_2_NPV, SMA_NPV, psym=3, color='red', /OVERPLOT
        cgPlot, CSIRO_V2_2_BS, SMA_SOIL, psym=3, color='BLUE', /OVERPLOT
        cgPlot, [-10,110], [-10,110], psym=-3, /OVERPLOT

        cgPlot, CSIRO_V2_2_PV, QLD_JRSP_LANDSAT_TOA_PV, psym=3, color='dark green', $
          xRange=xRange, yRange=yRange, xStyle=1, yStyle=1, /ISOTROPIC, xTitle='CSIRO V2.2', yTitle='QLD_JRSP_LANDSAT_TOA', title=title 
        cgPlot, CSIRO_V2_2_NPV, QLD_JRSP_LANDSAT_TOA_NPV, psym=3, color='red', /OVERPLOT
        cgPlot, CSIRO_V2_2_BS, QLD_JRSP_LANDSAT_TOA_BS, psym=3, color='BLUE', /OVERPLOT
        cgPlot, [-10,110], [-10,110], psym=-3, /OVERPLOT

        cgPlot, SMA_GV, QLD_JRSP_LANDSAT_TOA_PV, psym=3, color='dark green', $
          xRange=xRange, yRange=yRange, xStyle=1, yStyle=1, /ISOTROPIC, xTitle='OKIN SMA', yTitle='QLD_JRSP_LANDSAT_TOA', title=title 
        cgPlot, SMA_NPV, QLD_JRSP_LANDSAT_TOA_NPV, psym=3, color='red', /OVERPLOT
        cgPlot, SMA_SOIL, QLD_JRSP_LANDSAT_TOA_BS, psym=3, color='BLUE', /OVERPLOT
        cgPlot, [-10,110], [-10,110], psym=-3, /OVERPLOT

      PS_End,  /PNG, Resize=100
      ENDIF
      
    endfor  

; end plots
;------------------------------------------------------------------------
    
     
; start stats
;------------------------------------------------------------------------
    ; calculate stats and save to table
    folder = 'Z:\work\Juan_Pablo\ACEAS\comparison\stats\'
    cd, folder
    
    fname = 'statistics.csv'
    fileInfo = FILE_INFO(fname)
;    if fileInfo.exists eq 0 then begin
    OpenW, lun, fname, /get_Lun    
    PrintF, lun, 'site, model, Pearson_R_ALL, Spearman_R_ALL, RMSE_ALL, n_ALL, Pearson_R_PV, Spearman_R_PV, RMSE_PV, n_PV, Pearson_R_NPV, Spearman_R_NPV, RMSE_NPV, n_NPV, Pearson_R_BS, Spearman_R_BS, RMSE_BS, n_BS'
    for i=-1, Uniq_Sites_n-1 do begin
      if i eq -1 then $
        site = 'ALL' Else $
        site = Uniq_Sites[i]  
      if i eq -1 then $
        where_site = lindgen(n_elements(FC_comp.site_ID)) else $ 
        where_site = Where(FC_comp.site_ID eq site, count_site)
      OBS_PV = OBSERVED_PV[where_site]
      OBS_NPV = OBSERVED_NPV[where_site]
      OBS_BS = OBSERVED_BS[where_site]
      OBS_ALL = [OBS_PV,OBS_NPV,OBS_BS]
  
      model = 'CSIRO_V2_1'
      MOD_PV = CSIRO_V2_1_PV[where_site]
      MOD_NPV = CSIRO_V2_1_NPV[where_site]
      MOD_BS = CSIRO_V2_1_BS[where_site]
      MOD_ALL = [MOD_PV,MOD_NPV,MOD_BS]
  
      Pearson_R_ALL = pearson_r(OBS_all, MOD_ALL)
      Spearman_R_ALL = (r_correlate(OBS_all, MOD_ALL))[0]
      RMSE_ALL = RMSE(OBS_all, MOD_ALL)
      n_ALL = common_n(OBS_all, MOD_ALL)
  
      Pearson_R_PV = pearson_r(OBS_PV, MOD_PV)
      Spearman_R_PV = (r_correlate(OBS_PV, MOD_PV))[0]
      RMSE_PV = RMSE(OBS_PV, MOD_PV)
      n_PV = common_n(OBS_PV, MOD_PV)
  
      Pearson_R_NPV = pearson_r(OBS_NPV, MOD_NPV)
      Spearman_R_NPV = (r_correlate(OBS_NPV, MOD_NPV))[0]
      RMSE_NPV = RMSE(OBS_NPV, MOD_NPV)
      n_NPV = common_n(OBS_NPV, MOD_NPV)
  
      Pearson_R_BS = pearson_r(OBS_BS, MOD_BS)
      Spearman_R_BS = (r_correlate(OBS_BS, MOD_BS))[0]
      RMSE_BS = RMSE(OBS_BS, MOD_BS)
      n_BS = common_n(OBS_BS, MOD_BS)
      
      text_out=STRCOMPRESS(string(site, model, Pearson_R_ALL, Spearman_R_ALL, RMSE_ALL, n_ALL, Pearson_R_PV,  $ 
            Spearman_R_PV, RMSE_PV, n_PV, Pearson_R_NPV, Spearman_R_NPV, RMSE_NPV, n_NPV, Pearson_R_BS, Spearman_R_BS, RMSE_BS, n_BS, $
            Format='(100(A25,:, ","))'), /remove_all)
       PrintF, lun, text_out
  
      model = 'CSIRO_V2_2'
      MOD_PV = CSIRO_V2_2_PV[where_site]
      MOD_NPV = CSIRO_V2_2_NPV[where_site]
      MOD_BS = CSIRO_V2_2_BS[where_site]
      MOD_ALL = [MOD_PV,MOD_NPV,MOD_BS]
  
      Pearson_R_ALL = pearson_r(OBS_all, MOD_ALL)
      Spearman_R_ALL = (r_correlate(OBS_all, MOD_ALL))[0]
      RMSE_ALL = RMSE(OBS_all, MOD_ALL)
      n_ALL = common_n(OBS_all, MOD_ALL)
  
      Pearson_R_PV = pearson_r(OBS_PV, MOD_PV)
      Spearman_R_PV = (r_correlate(OBS_PV, MOD_PV))[0]
      RMSE_PV = RMSE(OBS_PV, MOD_PV)
      n_PV = common_n(OBS_PV, MOD_PV)
  
      Pearson_R_NPV = pearson_r(OBS_NPV, MOD_NPV)
      Spearman_R_NPV = (r_correlate(OBS_NPV, MOD_NPV))[0]
      RMSE_NPV = RMSE(OBS_NPV, MOD_NPV)
      n_NPV = common_n(OBS_NPV, MOD_NPV)
  
      Pearson_R_BS = pearson_r(OBS_BS, MOD_BS)
      Spearman_R_BS = (r_correlate(OBS_BS, MOD_BS))[0]
      RMSE_BS = RMSE(OBS_BS, MOD_BS)
      n_BS = common_n(OBS_BS, MOD_BS)
      
      text_out=STRCOMPRESS(string(site, model, Pearson_R_ALL, Spearman_R_ALL, RMSE_ALL, n_ALL, Pearson_R_PV,  $ 
            Spearman_R_PV, RMSE_PV, n_PV, Pearson_R_NPV, Spearman_R_NPV, RMSE_NPV, n_NPV, Pearson_R_BS, Spearman_R_BS, RMSE_BS, n_BS, $
            Format='(100(A25,:, ","))'), /remove_all)
      PrintF, lun, text_out
  
      model = 'CSIRO_V3_0'
      MOD_PV = CSIRO_V3_0_PV[where_site]
      MOD_NPV = CSIRO_V3_0_NPV[where_site]
      MOD_BS = CSIRO_V3_0_BS[where_site]
      MOD_ALL = [MOD_PV,MOD_NPV,MOD_BS]
  
      Pearson_R_ALL = pearson_r(OBS_all, MOD_ALL)
      Spearman_R_ALL = (r_correlate(OBS_all, MOD_ALL))[0]
      RMSE_ALL = RMSE(OBS_all, MOD_ALL)
      n_ALL = common_n(OBS_all, MOD_ALL)
  
      Pearson_R_PV = pearson_r(OBS_PV, MOD_PV)
      Spearman_R_PV = (r_correlate(OBS_PV, MOD_PV))[0]
      RMSE_PV = RMSE(OBS_PV, MOD_PV)
      n_PV = common_n(OBS_PV, MOD_PV)
  
      Pearson_R_NPV = pearson_r(OBS_NPV, MOD_NPV)
      Spearman_R_NPV = (r_correlate(OBS_NPV, MOD_NPV))[0]
      RMSE_NPV = RMSE(OBS_NPV, MOD_NPV)
      n_NPV = common_n(OBS_NPV, MOD_NPV)
  
      Pearson_R_BS = pearson_r(OBS_BS, MOD_BS)
      Spearman_R_BS = (r_correlate(OBS_BS, MOD_BS))[0]
      RMSE_BS = RMSE(OBS_BS, MOD_BS)
      n_BS = common_n(OBS_BS, MOD_BS)
      
      text_out=STRCOMPRESS(string(site, model, Pearson_R_ALL, Spearman_R_ALL, RMSE_ALL, n_ALL, Pearson_R_PV,  $ 
            Spearman_R_PV, RMSE_PV, n_PV, Pearson_R_NPV, Spearman_R_NPV, RMSE_NPV, n_NPV, Pearson_R_BS, Spearman_R_BS, RMSE_BS, n_BS, $
            Format='(100(A25,:, ","))'), /remove_all)
      PrintF, lun, text_out

      model = 'OKIN_SMA'
      MOD_PV = SMA_GV[where_site]
      MOD_NPV = SMA_NPV[where_site]
      MOD_BS = SMA_SOIL[where_site]
      MOD_ALL = [MOD_PV,MOD_NPV,MOD_BS]
  
      Pearson_R_ALL = pearson_r(OBS_all, MOD_ALL)
      Spearman_R_ALL = (r_correlate(OBS_all, MOD_ALL))[0]
      RMSE_ALL = RMSE(OBS_all, MOD_ALL)
      n_ALL = common_n(OBS_all, MOD_ALL)
  
      Pearson_R_PV = pearson_r(OBS_PV, MOD_PV)
      Spearman_R_PV = (r_correlate(OBS_PV, MOD_PV))[0]
      RMSE_PV = RMSE(OBS_PV, MOD_PV)
      n_PV = common_n(OBS_PV, MOD_PV)
  
      Pearson_R_NPV = pearson_r(OBS_NPV, MOD_NPV)
      Spearman_R_NPV = (r_correlate(OBS_NPV, MOD_NPV))[0]
      RMSE_NPV = RMSE(OBS_NPV, MOD_NPV)
      n_NPV = common_n(OBS_NPV, MOD_NPV)
  
      Pearson_R_BS = pearson_r(OBS_BS, MOD_BS)
      Spearman_R_BS = (r_correlate(OBS_BS, MOD_BS))[0]
      RMSE_BS = RMSE(OBS_BS, MOD_BS)
      n_BS = common_n(OBS_BS, MOD_BS)
      
      text_out=STRCOMPRESS(string(site, model, Pearson_R_ALL, Spearman_R_ALL, RMSE_ALL, n_ALL, Pearson_R_PV,  $ 
            Spearman_R_PV, RMSE_PV, n_PV, Pearson_R_NPV, Spearman_R_NPV, RMSE_NPV, n_NPV, Pearson_R_BS, Spearman_R_BS, RMSE_BS, n_BS, $
            Format='(100(A25,:, ","))'), /remove_all)
       PrintF, lun, text_out
       

      model = 'OKIN_MESMA'
      MOD_PV = MESMA_GV[where_site]
      MOD_NPV = MESMA_NPV[where_site]
      MOD_BS = MESMA_SOIL[where_site]
      MOD_ALL = [MOD_PV,MOD_NPV,MOD_BS]
  
      Pearson_R_ALL = pearson_r(OBS_all, MOD_ALL)
      Spearman_R_ALL = (r_correlate(OBS_all, MOD_ALL))[0]
      RMSE_ALL = RMSE(OBS_all, MOD_ALL)
      n_ALL = common_n(OBS_all, MOD_ALL)
  
      Pearson_R_PV = pearson_r(OBS_PV, MOD_PV)
      Spearman_R_PV = (r_correlate(OBS_PV, MOD_PV))[0]
      RMSE_PV = RMSE(OBS_PV, MOD_PV)
      n_PV = common_n(OBS_PV, MOD_PV)
  
      Pearson_R_NPV = pearson_r(OBS_NPV, MOD_NPV)
      Spearman_R_NPV = (r_correlate(OBS_NPV, MOD_NPV))[0]
      RMSE_NPV = RMSE(OBS_NPV, MOD_NPV)
      n_NPV = common_n(OBS_NPV, MOD_NPV)
  
      Pearson_R_BS = pearson_r(OBS_BS, MOD_BS)
      Spearman_R_BS = (r_correlate(OBS_BS, MOD_BS))[0]
      RMSE_BS = RMSE(OBS_BS, MOD_BS)
      n_BS = common_n(OBS_BS, MOD_BS)
      
      text_out=STRCOMPRESS(string(site, model, Pearson_R_ALL, Spearman_R_ALL, RMSE_ALL, n_ALL, Pearson_R_PV,  $ 
            Spearman_R_PV, RMSE_PV, n_PV, Pearson_R_NPV, Spearman_R_NPV, RMSE_NPV, n_NPV, Pearson_R_BS, Spearman_R_BS, RMSE_BS, n_BS, $
            Format='(100(A25,:, ","))'), /remove_all)
       PrintF, lun, text_out


      model = 'QLD_JRSP_LANDSAT_TOA'
      MOD_PV = QLD_JRSP_LANDSAT_TOA_PV[where_site]
      MOD_NPV = QLD_JRSP_LANDSAT_TOA_NPV[where_site]
      MOD_BS = QLD_JRSP_LANDSAT_TOA_BS[where_site]
      MOD_ALL = [MOD_PV,MOD_NPV,MOD_BS]
  
      Pearson_R_ALL = pearson_r(OBS_all, MOD_ALL)
      Spearman_R_ALL = (r_correlate(OBS_all, MOD_ALL))[0]
      RMSE_ALL = RMSE(OBS_all, MOD_ALL)
      n_ALL = common_n(OBS_all, MOD_ALL)
  
      Pearson_R_PV = pearson_r(OBS_PV, MOD_PV)
      Spearman_R_PV = (r_correlate(OBS_PV, MOD_PV))[0]
      RMSE_PV = RMSE(OBS_PV, MOD_PV)
      n_PV = common_n(OBS_PV, MOD_PV)
  
      Pearson_R_NPV = pearson_r(OBS_NPV, MOD_NPV)
      Spearman_R_NPV = (r_correlate(OBS_NPV, MOD_NPV))[0]
      RMSE_NPV = RMSE(OBS_NPV, MOD_NPV)
      n_NPV = common_n(OBS_NPV, MOD_NPV)
  
      Pearson_R_BS = pearson_r(OBS_BS, MOD_BS)
      Spearman_R_BS = (r_correlate(OBS_BS, MOD_BS))[0]
      RMSE_BS = RMSE(OBS_BS, MOD_BS)
      n_BS = common_n(OBS_BS, MOD_BS)
      
      text_out=STRCOMPRESS(string(site, model, Pearson_R_ALL, Spearman_R_ALL, RMSE_ALL, n_ALL, Pearson_R_PV,  $ 
            Spearman_R_PV, RMSE_PV, n_PV, Pearson_R_NPV, Spearman_R_NPV, RMSE_NPV, n_NPV, Pearson_R_BS, Spearman_R_BS, RMSE_BS, n_BS, $
            Format='(100(A25,:, ","))'), /remove_all)
      PrintF, lun, text_out
  
      model = 'OKIN_RSMA'
      MOD_PV = RSMA_GV[where_site]
      MOD_NPV = RSMA_NPV[where_site]
      MOD_BS = RSMA_SOIL[where_site]
      MOD_ALL = [MOD_PV,MOD_NPV,MOD_BS]
  
      Pearson_R_ALL = pearson_r(OBS_all, MOD_ALL)
      Spearman_R_ALL = (r_correlate(OBS_all, MOD_ALL))[0]
      RMSE_ALL = RMSE(OBS_all, MOD_ALL)
      n_ALL = common_n(OBS_all, MOD_ALL)
  
      Pearson_R_PV = pearson_r(OBS_PV, MOD_PV)
      Spearman_R_PV = (r_correlate(OBS_PV, MOD_PV))[0]
      RMSE_PV = RMSE(OBS_PV, MOD_PV)
      n_PV = common_n(OBS_PV, MOD_PV)
  
      Pearson_R_NPV = pearson_r(OBS_NPV, MOD_NPV)
      Spearman_R_NPV = (r_correlate(OBS_NPV, MOD_NPV))[0]
      RMSE_NPV = RMSE(OBS_NPV, MOD_NPV)
      n_NPV = common_n(OBS_NPV, MOD_NPV)
  
      Pearson_R_BS = pearson_r(OBS_BS, MOD_BS)
      Spearman_R_BS = (r_correlate(OBS_BS, MOD_BS))[0]
      RMSE_BS = RMSE(OBS_BS, MOD_BS)
      n_BS = common_n(OBS_BS, MOD_BS)
      
      text_out=STRCOMPRESS(string(site, model, Pearson_R_ALL, Spearman_R_ALL, RMSE_ALL, n_ALL, Pearson_R_PV,  $ 
            Spearman_R_PV, RMSE_PV, n_PV, Pearson_R_NPV, Spearman_R_NPV, RMSE_NPV, n_NPV, Pearson_R_BS, Spearman_R_BS, RMSE_BS, n_BS, $
            Format='(100(A25,:, ","))'), /remove_all)
       PrintF, lun, text_out
       
      model = 'Uni_Ade_LCI'
      MOD_PV = LCI[where_site]
      MOD_NPV = LCI[where_site]
      MOD_BS = LCI[where_site]
      MOD_ALL = [MOD_PV,MOD_NPV,MOD_BS]
  
      Pearson_R_ALL = pearson_r(OBS_all, MOD_ALL)
      Spearman_R_ALL = (r_correlate(OBS_all, MOD_ALL))[0]
      RMSE_ALL = RMSE(OBS_all, MOD_ALL)
      n_ALL = common_n(OBS_all, MOD_ALL)
  
      Pearson_R_PV = pearson_r(OBS_PV, MOD_PV)
      Spearman_R_PV = (r_correlate(OBS_PV, MOD_PV))[0]
      RMSE_PV = RMSE(OBS_PV, MOD_PV)
      n_PV = common_n(OBS_PV, MOD_PV)
  
      Pearson_R_NPV = pearson_r(OBS_NPV, MOD_NPV)
      Spearman_R_NPV = (r_correlate(OBS_NPV, MOD_NPV))[0]
      RMSE_NPV = RMSE(OBS_NPV, MOD_NPV)
      n_NPV = common_n(OBS_NPV, MOD_NPV)
  
      Pearson_R_BS = pearson_r(OBS_BS, MOD_BS)
      Spearman_R_BS = (r_correlate(OBS_BS, MOD_BS))[0]
      RMSE_BS = RMSE(OBS_BS, MOD_BS)
      n_BS = common_n(OBS_BS, MOD_BS)
      
      text_out=STRCOMPRESS(string(site, model, Pearson_R_ALL, Spearman_R_ALL, RMSE_ALL, n_ALL, Pearson_R_PV,  $ 
            Spearman_R_PV, RMSE_PV, n_PV, Pearson_R_NPV, Spearman_R_NPV, RMSE_NPV, n_NPV, Pearson_R_BS, Spearman_R_BS, RMSE_BS, n_BS, $
            Format='(100(A25,:, ","))'), /remove_all)
       PrintF, lun, text_out
       
  
    endfor
    close, /all
;   EndIf

; end stats
;------------------------------------------------------------------------

    
end


  