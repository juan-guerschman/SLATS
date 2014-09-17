function where_ALL_data_ok, DATA
  total_ne_1 = where(data.FCOVER.exp_tot lt 0.95 or data.FCOVER.exp_tot gt 1.05, count)
  exp_tot = data.FCOVER.exp_tot
  if count ge 1 then exp_tot[total_ne_1]=!values.F_nan
  big_array = [ $
              [Data.MCD43A4.B1], $
              [Data.MCD43A4.B2], $
              [Data.MCD43A4.B3], $
              [Data.MCD43A4.B4], $
              [Data.MCD43A4.B5], $
              [Data.MCD43A4.B6], $
              [Data.MCD43A4.B7], $
              [Data.MOD09A1.B1], $
              [Data.MOD09A1.B2], $
              [Data.MOD09A1.B3], $
              [Data.MOD09A1.B4], $
              [Data.MOD09A1.B5], $
              [Data.MOD09A1.B6], $
              [Data.MOD09A1.B7], $
              [data.Landsat_scaling.B1_3x3], $
              [data.Landsat_scaling.B2_3x3], $ 
              [data.Landsat_scaling.B3_3x3], $ 
              [data.Landsat_scaling.B4_3x3], $ 
              [data.Landsat_scaling.B5_3x3], $ 
              [data.Landsat_scaling.B6_3x3], $
;              [data.Landsat_QLD.B1],         $
;              [data.Landsat_QLD.B2],         $
;              [data.Landsat_QLD.B3],         $
;              [data.Landsat_QLD.B4],         $
;              [data.Landsat_QLD.B5],         $
;              [data.Landsat_QLD.B6],         $
              [exp_tot],         $   ;ADD THIS TO MAKE SURE NaN ARE DELETED
              [data.Landsat_scaling.SAM_40x40]] 
   negs = where(big_array lt 0, count)           
   if count ge 1 then big_array[negs] = !VALUES.F_NAN     
   total_finite = Total(Finite(big_array), 2)
   where_ok = Where(total_finite eq (SIZE(big_array))[2])
   return, where_ok
end



pro Analise_SLATS_Landsat, data=data
  compile_opt idl2

  ; LOAD DATA 
;  data = read_SLATS_data()
  if Keyword_Set(data) eq 0 then $
    data = read_SLATS_data_new()
  
;  LANDSAT_Qld = data.LANDSAT_Qld
;  LANDSAT_Scaling = data.LANDSAT_Scaling
;  MCD43A4 = data.MCD43A4
;  MOD09A1 = data.MOD09A1
;  Rain = data.Rain
;  Fcover = DATA.Fcover
;  Rain = Data.Rain
  
  output_folder = 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\plots\May_2013\'
  IF (FILE_INFO(output_folder)).DIRECTORY eq 0 then FILE_MKDIR, output_folder
  n = n_elements(data.Field_all.Obs_key)
  cd, output_folder
  
  ABARES = Where(Data.Field_all.source eq 'abares', count_abares)
  RSC = Where(Data.Field_all.source eq 'rsc', count_rsc)
  NSW = Where(Data.Field_all.source eq 'nsw', count_nsw)
  TERN = Where(Data.Field_all.source eq 'tern', count_tern)
  
  Where_ALL = where_ALL_data_ok(DATA)
  
  ;Some Defaults for saving: 
  cgwindow_setdefs, IM_Resize=100
  
   ;-------------------------------------------------------------------------- 
   ;Calculate julian days
;   day = intarr(n)
;   month = intarr(n)
;   year = intarr(n)
;   for i=0, n-1 do day[i]= (strsplit((LANDSAT_Qld.obs_time)[i], '/', /EXTRACT))[0]
;   for i=0, n-1 do month[i]= (strsplit((LANDSAT_Qld.obs_time)[i], '/', /EXTRACT))[1]
;   for i=0, n-1 do year[i]= (strsplit((LANDSAT_Qld.obs_time)[i], '/', /EXTRACT))[2]
   Jul_Day = JULDAY(data.field_all.Month, data.field_all.Day, data.field_all.Year)
   
   ;-------------------------------------------------------------------------- 

;   ; Calculate some Rainfall metrics (accumulated over a week)
;   ; first convert all -1 to NaNs
;   where_nan = Where(Rain.LandsatMinus1 lt 0, count)
;   Rain_1Day = Rain.LandsatMinus1
;   IF count ge 1 then Rain_1Day[where_nan] = !VALUES.F_NAN
;   Rain_2Day = Rain_1Day + Rain.LandsatMinus2
;   Rain_3Day = Rain_2Day + Rain.LandsatMinus3
;   Rain_4Day = Rain_3Day + Rain.LandsatMinus4
;   Rain_5Day = Rain_4Day + Rain.LandsatMinus5
;   Rain_6Day = Rain_5Day + Rain.LandsatMinus6
;   Rain_7Day = Rain_6Day + Rain.LandsatMinus7
    
     
    
  ;; plot map with points
  fname = 'map.png'
  if (FILE_INFO(fname)).Exists eq 0 then begin
  PS_Start, fname
    AusCoastline=auscoastline()
    cgDisplay, 1200, 1200/1.22
    ;cgWindow, wXSize=1200, wYSize=1200/1.22 
    cgPlot, data.field_all.longitude, data.field_all.latitude, $
              psym=9, symsize=0.77, xRange=[112, 155], yRange=[-45, -10], xStyle=1, yStyle=1 
;    cgWindow, 'cgPlot', LANDSAT_Qld.st_X, LANDSAT_Qld.st_Y, $
;              psym=9, symsize=0.5,  color='blue', /addcmd
    cgPlot, AusCoastline.lon, AusCoastline.lat,  $
              color='red', psym=-3, thick=2, /OVERPLOT
  PS_End, resize=100, /png
  endif
  
  ;; plot map with points
  fname = 'map_paper_onlySatellite.png'
  if (FILE_INFO(fname)).Exists eq 0 then begin
  PS_Start, fname
    AusCoastline=auscoastline()
    cgDisplay, 1200, 1200/1.22
    ;cgWindow, wXSize=1200, wYSize=1200/1.22 
;    cgPlot, data.field_all.longitude, data.field_all.latitude, $
;              psym=16, symsize=0.65, xRange=[112, 155], yRange=[-45, -10], xStyle=1, yStyle=1 
    cgPlot, (data.field_all.longitude)[Where_all], (data.field_all.latitude)[where_all], $
              psym=16, symsize=0.65, xRange=[112, 155], yRange=[-45, -10], xStyle=1, yStyle=1 
    cgPlot, (data.field_all.longitude)[Where_all], (data.field_all.latitude)[where_all], $
              psym=16, symsize=0.65, xRange=[112, 155], yRange=[-45, -10], xStyle=1, yStyle=1, color='red', /overplot
;    cgWindow, 'cgPlot', LANDSAT_Qld.st_X, LANDSAT_Qld.st_Y, $
;              psym=9, symsize=0.5,  color='blue', /addcmd
    cgPlot, AusCoastline.lon, AusCoastline.lat,  $
              color='black', psym=-3, thick=2, /OVERPLOT
  PS_End, resize=100, /png
  endif 


  ;; plot map with points
  fname = 'map_paper_onlySatellite_withColors.png'
  if (FILE_INFO(fname)).Exists eq 0 then begin
  PS_Start, fname
    AusCoastline=auscoastline()
    cgDisplay, 1200, 1200/1.22
    ;cgWindow, wXSize=1200, wYSize=1200/1.22 
;    cgPlot, data.field_all.longitude, data.field_all.latitude, $
;              psym=16, symsize=0.65, xRange=[112, 155], yRange=[-45, -10], xStyle=1, yStyle=1 
    cgPlot, (data.field_all.longitude)[Where_all], (data.field_all.latitude)[where_all], $
              psym=16, symsize=0.01, xRange=[112, 155], yRange=[-45, -10], xStyle=1, yStyle=1, $
              pos=[0.05,0.05,0.98,0.98]
    cgPlot, (data.field_all.longitude)[Where_all], (data.field_all.latitude)[where_all], $
              psym=16, symsize=0.01, xRange=[112, 155], yRange=[-45, -10], xStyle=1, yStyle=1, color='red', /overplot
;    cgWindow, 'cgPlot', LANDSAT_Qld.st_X, LANDSAT_Qld.st_Y, $
;              psym=9, symsize=0.5,  color='blue', /addcmd
    cgPlot, AusCoastline.lon, AusCoastline.lat,  $
              color='black', psym=-3, thick=2, /OVERPLOT
    for j=0, n_elements(Where_all)-1 do $          
      cgPlot, (data.field_all.longitude)[Where_all[j]], (data.field_all.latitude)[Where_all[j]], $    
              psym=16, symsize=1, xRange=[112, 155], yRange=[-45, -10], xStyle=1, yStyle=1, /overplot, $
              color= cgCOLOR(fix([data.FCOVER.exp_npv[Where_all[j]]*255,$
                                  data.FCOVER.exp_pv[Where_all[j]]*255,$
                                  data.FCOVER.exp_bs[Where_all[j]]*255]))
  PS_End, resize=100, /png
  endif 

  ;; plot map with points
  fname = 'map_paper_AllSites_withColors_changedRGB.png'
  if (FILE_INFO(fname)).Exists eq 0 then begin
  PS_Start, fname
    AusCoastline=auscoastline()
    cgDisplay, 1200, 1200/1.22
    ;cgWindow, wXSize=1200, wYSize=1200/1.22 
;    cgPlot, data.field_all.longitude, data.field_all.latitude, $
;              psym=16, symsize=0.65, xRange=[112, 155], yRange=[-45, -10], xStyle=1, yStyle=1 
    cgPlot, (data.field_all.longitude), (data.field_all.latitude), $
              psym=16, symsize=0.01, xRange=[112, 155], yRange=[-45, -10], xStyle=1, yStyle=1, $
              pos=[0.05,0.05,0.98,0.98]
    cgPlot, (data.field_all.longitude), (data.field_all.latitude), $
              psym=16, symsize=0.01, xRange=[112, 155], yRange=[-45, -10], xStyle=1, yStyle=1, color='red', /overplot
;    cgWindow, 'cgPlot', LANDSAT_Qld.st_X, LANDSAT_Qld.st_Y, $
;              psym=9, symsize=0.5,  color='blue', /addcmd
    cgPlot, AusCoastline.lon, AusCoastline.lat,  $
              color='black', psym=-3, thick=2, /OVERPLOT
    for j=0, n-1 do $          
      cgPlot, (data.field_all.longitude)[j], (data.field_all.latitude)[j], $    
              psym=16, symsize=1, xRange=[112, 155], yRange=[-45, -10], xStyle=1, yStyle=1, /overplot, $
              color= cgCOLOR(fix([data.FCOVER.exp_bs[j]*255,$
                                  data.FCOVER.exp_pv[j]*255,$
                                  data.FCOVER.exp_npv[j]*255]))
  PS_End, resize=100, /png
  endif 


   ;--------------------------------------------------------------------------
   ; obs time
;   Obs_Time = intarr(3, n)
;   for i=0, n-1 do Obs_Time[*,i]=STRSPLIT((Landsat_Qld.Obs_Time)[i], '/', /Extract)
;   day = Obs_Time[0,*] & month=Obs_Time[1,*] & year=Obs_Time[2,*]
  fname = 'histogram_when.png'
  if (FILE_INFO(fname)).Exists eq 0 then begin
  PS_Start, fname
   ;cgWindow, WMulti=[0,2,0], wysize=200, wxsize=600
   cgDisplay, 300, 600
   !P.Multi=[0,1,2]
   cgHistoPlot,  data.field_all.year, xTitle='year',  yTitle='observations', /fillpolygon 
   cgHistoPlot,  data.field_all.month, xTitle='month',  yTitle=' ',  /fillpolygon 
  PS_End, resize=100, /png
  endif 
   
  fname = 'histogram_when_paper_onlySatellite.png'
  if (FILE_INFO(fname)).Exists eq 0 then begin
  PS_Start, fname
   XTICKNAMES=['jan','mar','may','jul','sep','nov'] 
   ;cgWindow, WMulti=[0,2,0], wysize=200, wxsize=600
   cgDisplay, 600, 800
   !P.Multi=[0,1,2]
;   cgHistoPlot, data.field_all.year, xTitle='year', yTitle='observations', $
;                /fillpolygon, POLYCOLOR='black', DATACOLORNAME='black'
   cgHistoPlot, (data.field_all.year)[where_all], xTitle='year', yTitle='observations', $
                /fillpolygon, POLYCOLOR='black', DATACOLORNAME='black', charsize=1.75;, XTicks=7
   cgHistoPlot, (data.field_all.year)[where_all], xTitle='year',  yTitle='observations', $
                /fillpolygon , /oplot, POLYCOLOR='red', DATACOLORNAME='black'
   
;   cgHistoPlot,  data.field_all.month, xTitle='month',  yTitle='observations',  $
;                /fillpolygon, POLYCOLOR='black', DATACOLORNAME='black'
   cgHistoPlot,  (data.field_all.month)[where_all], xTitle='month',  yTitle='observations',  $
                /fillpolygon, POLYCOLOR='black', DATACOLORNAME='black', charsize=1.75;, XTICKNAMES=XTICKNAMES
   cgHistoPlot,  (data.field_all.month)[where_all], xTitle='month',  yTitle=' ',$
                /fillpolygon , /oplot, POLYCOLOR='red', DATACOLORNAME='black'
  PS_End, resize=100, /png
  endif 

  fname = 'histogram_timelag_paper_onlySatellite.png'
  if (FILE_INFO(fname)).Exists eq 0 then begin
  PS_Start, fname
   cgDisplay, 400, 300
   !P.Multi=[0]
;   cgHistoPlot, data.field_all.year, xTitle='year', yTitle='observations', $
;                /fillpolygon, POLYCOLOR='black', DATACOLORNAME='black'
   cgHistoPlot, (data.landsat_scaling.timelag)[where_all], xTitle='days', yTitle='observations', $
                /fillpolygon, POLYCOLOR='gray', DATACOLORNAME='black', binsize=1, charsize=2, $
                pos=[0.15,0.15,0.95,0.95]
   legend = ['mean='+string(mean((data.landsat_scaling.timelag)[where_all]), format='(f4.1)'), $
             'median='+string(median((data.landsat_scaling.timelag)[where_all]), format='(f4.1)'), $]
             'std='+string(stddev((data.landsat_scaling.timelag)[where_all]), format='(f4.1)'), $
             'max='+string(max((data.landsat_scaling.timelag)[where_all]), format='(i2)'),  $
             'min='+string(min((data.landsat_scaling.timelag)[where_all]), format='(i3)')]
   al_legend, legend, /top, /right, box=0, charsize=2 ;, pos=[1.1,310]          
   
  PS_End, resize=100, /png
  endif 

  ;data1 = randomn(seed, 1000)          ;create data array to be tested
  norm_data = ((data.landsat_scaling.timelag)[where_all] - MEAN((data.landsat_scaling.timelag)[where_all])) / stddev((data.landsat_scaling.timelag)[where_all])
  KSTWO, norm_data, randomn(seed, n_elements(norm_data)), D, prob    ;Use K-S test
  print, d, prob


  fname = 'histogram_ED_17x17_paper_onlySatellite.png'
  if (FILE_INFO(fname)).Exists eq 0 then begin
  PS_Start, fname
   cgDisplay, 600, 300
   !P.Multi=[0]
;   cgHistoPlot, data.field_all.year, xTitle='year', yTitle='observations', $
;                /fillpolygon, POLYCOLOR='black', DATACOLORNAME='black'
   cgHistoPlot, alog10((data.landsat_scaling.ED_17x17)[where_all]), xTitle='Log$\sub10$(ED)', yTitle='observations', $
                /fillpolygon, POLYCOLOR='gray', DATACOLORNAME='black',  charsize=2, pos=[0.15,0.2,0.9,0.9], maxinput=-1, $
                BINSIZE=0.05
   
  PS_End, resize=100, /png
  endif 

  ;data1 = randomn(seed, 1000)          ;create data array to be tested
  norm_data = (alog10((data.landsat_scaling.ED_17x17)[where_all]) - mean(alog10((data.landsat_scaling.ED_17x17)[where_all]))) / stddev(alog10((data.landsat_scaling.ED_17x17)[where_all]))
  KSTWO, norm_data, randomn(seed, n_elements(norm_data)*100), D, prob    ;Use K-S test
  print, d, prob

 

  fname = 'histogram_fractions_paper.png'
  if (FILE_INFO(fname)).Exists eq 0 then begin
  PS_Start, fname
   ;cgWindow, WMulti=[0,2,0], wysize=200, wxsize=600
   cgDisplay, 300, 600
   !P.Multi=[0,1,3]
   cgHistoPlot, data.FCOVER.Exp_PV, xTitle='PV', yTitle='observations', $
                /fillpolygon, POLYCOLOR='black', DATACOLORNAME='black', maxinput=1, mininput=0, binsize=0.05, charsize=2
   cgHistoPlot, (data.FCOVER.Exp_PV)[where_all],  $
                /fillpolygon , /oplot, POLYCOLOR='red', DATACOLORNAME='black', maxinput=1, mininput=0, binsize=0.05
   
   cgHistoPlot, data.FCOVER.Exp_NPV, xTitle='NPV', yTitle='observations', $
                /fillpolygon, POLYCOLOR='black', DATACOLORNAME='black', maxinput=1, mininput=0, binsize=0.05, charsize=2
   cgHistoPlot, (data.FCOVER.Exp_NPV)[where_all],  $
                /fillpolygon , /oplot, POLYCOLOR='red', DATACOLORNAME='black', maxinput=1, mininput=0, binsize=0.05, charsize=2

   cgHistoPlot, data.FCOVER.Exp_BS, xTitle='BS', yTitle='observations', $
                /fillpolygon, POLYCOLOR='black', DATACOLORNAME='black', maxinput=1, mininput=0, binsize=0.05, charsize=2
   cgHistoPlot, (data.FCOVER.Exp_BS)[where_all],  $
                /fillpolygon , /oplot, POLYCOLOR='red', DATACOLORNAME='black', maxinput=1, mininput=0, binsize=0.05, charsize=2
  PS_End, resize=100, /png
  endif
   
  fname = 'histogram_fractions_paper_onlySatellite.png'
  if (FILE_INFO(fname)).Exists eq 0 then begin
  PS_Start, fname
   ;cgWindow, WMulti=[0,2,0], wysize=200, wxsize=600
   cgDisplay, 500, 1000
   !P.Multi=[0,1,3]
   cgHistoPlot, (data.FCOVER.Exp_PV)[where_all], xTitle='PV', yTitle='observations', $
                /fillpolygon, POLYCOLOR='black', DATACOLORNAME='black', maxinput=1, mininput=0, binsize=0.05, charsize=2.5
   cgHistoPlot, (data.FCOVER.Exp_PV)[where_all],  $
                /fillpolygon , /oplot, POLYCOLOR='green', DATACOLORNAME='black', maxinput=1, mininput=0, binsize=0.05
   legend = ['mean='+string(mean((data.FCOVER.Exp_PV)[where_all]), format='(f4.2)'), $
             'median='+string(median((data.FCOVER.Exp_PV)[where_all]), format='(f4.2)'), $]
             'std='+string(stddev((data.FCOVER.Exp_PV)[where_all]), format='(f4.2)')]
   al_legend, legend, /top, /right, box=0, pos=[1.1,310]          
   
   cgHistoPlot, (data.FCOVER.Exp_NPV)[where_all], xTitle='NPV', yTitle='observations', $
                /fillpolygon, POLYCOLOR='black', DATACOLORNAME='black', maxinput=1, mininput=0, binsize=0.05, charsize=2.5
   cgHistoPlot, (data.FCOVER.Exp_NPV)[where_all],  $
                /fillpolygon , /oplot, POLYCOLOR='red', DATACOLORNAME='black', maxinput=1, mininput=0, binsize=0.05, charsize=2
   legend = ['mean='+string(mean((data.FCOVER.Exp_NPV)[where_all]), format='(f4.2)'), $
             'median='+string(median((data.FCOVER.Exp_NPV)[where_all]), format='(f4.2)'), $]
             'std='+string(stddev((data.FCOVER.Exp_NPV)[where_all]), format='(f4.2)')]
   al_legend, legend, /top, /right, box=0, pos=[1.1,105]         

   cgHistoPlot, (data.FCOVER.Exp_BS)[where_all], xTitle='BS', yTitle='observations', $
                /fillpolygon, POLYCOLOR='black', DATACOLORNAME='black', maxinput=1, mininput=0, binsize=0.05, charsize=2.5
   cgHistoPlot, (data.FCOVER.Exp_BS)[where_all],  $
                /fillpolygon , /oplot, POLYCOLOR='blue', DATACOLORNAME='black', maxinput=1, mininput=0, binsize=0.05, charsize=2
   legend = ['mean='+string(mean((data.FCOVER.Exp_BS)[where_all]), format='(f4.2)'), $
             'median='+string(median((data.FCOVER.Exp_BS)[where_all]), format='(f4.2)'), $]
             'std='+string(stddev((data.FCOVER.Exp_BS)[where_all]), format='(f4.2)')]
   al_legend, legend, /top, /right, box=0 , pos=[1.1,250]     
  PS_End, resize=100, /png
  endif


  ; plot observations
  fname = 'field_triangle.png'
  if (FILE_INFO(fname)).Exists eq 0 then begin
  PS_Start, fname  
   cg_mg_ternaryplot, data.Fcover.Exp_NPV, data.Fcover.Exp_PV, data.Fcover.Exp_BS, $
                     atitle='non-green veg %', ctitle='green veg %', btitle='bare soil %', color='black', psym=16, $
                     background='lavender', /nodata, CHARSIZE=cgDefCharSize()
   cg_mg_ternaryplot, data.Fcover.Exp_NPV[rsc], data.Fcover.Exp_PV[rsc], data.Fcover.Exp_BS[rsc], $
                     color='green', psym=16, /overplot, symsize=0.75
   cg_mg_ternaryplot, data.Fcover.Exp_NPV[abares], data.Fcover.Exp_PV[abares], data.Fcover.Exp_BS[abares], $
                     color='yellow', psym=16, /overplot, symsize=0.75
   cg_mg_ternaryplot, data.Fcover.Exp_NPV[nsw], data.Fcover.Exp_PV[nsw], data.Fcover.Exp_BS[nsw], $
                     color='royal blue', psym=16, /overplot, symsize=0.75
   cg_mg_ternaryplot, data.Fcover.Exp_NPV[tern], data.Fcover.Exp_PV[tern], data.Fcover.Exp_BS[tern], $
                     color='red', psym=16, /overplot, symsize=0.75
   colors=['green','yellow', 'royal blue', 'red']                  
   
   items = ['RSC', 'ABARES', 'NSW', 'TERN']
   Al_Legend, items, /FILL, PSYM=Replicate(15,4), COLORS=colors, SYMSIZE=Replicate(1.75,4), $
      POSITION=[0.60, 0.70], /NORMAL, CHARSIZE=cgDefCharSize()
  PS_End, resize=100, /png
  endif
   
  ; plot observations
  fname = 'field_triangle_paper.png'
  if (FILE_INFO(fname)).Exists eq 0 then begin
  PS_Start, fname  
   cg_mg_ternaryplot, data.Fcover.Exp_NPV, data.Fcover.Exp_PV, data.Fcover.Exp_BS, $
                     atitle='NPV veg %', ctitle='PV %', btitle='B %', color='black', psym=16, $
                     background='white', /nodata, CHARSIZE=cgDefCharSize()
   cg_mg_ternaryplot, data.Fcover.Exp_NPV, data.Fcover.Exp_PV, data.Fcover.Exp_BS, $
                     color='black', psym=16, /overplot, symsize=0.75
   cg_mg_ternaryplot, data.Fcover.Exp_NPV[Where_ALL], data.Fcover.Exp_PV[Where_ALL], data.Fcover.Exp_BS[Where_ALL], $
                     color='red', psym=16, /overplot, symsize=0.75
;   colors=['green','yellow', 'royal blue', 'red']                  
;   
;   items = ['RSC', 'ABARES', 'NSW', 'TERN']
;   Al_Legend, items, /FILL, PSYM=Replicate(15,4), COLORS=colors, SYMSIZE=Replicate(1.75,4), $
;      POSITION=[0.60, 0.70], /NORMAL, CHARSIZE=cgDefCharSize()
  PS_End, resize=100, /png
  endif

  ; plot observations
  fname = 'field_triangle_paper2.png'
  if (FILE_INFO(fname)).Exists eq 0 then begin
  PS_Start, fname  
   jpgTernaryDiagram, data.Fcover.Exp_NPV, data.Fcover.Exp_PV, data.Fcover.Exp_BS, $
                     atitle='NPV', ctitle='PV', btitle='Bare', color='black', psym=16, symsize=0.01 
   jpgTernaryDiagram, data.Fcover.Exp_NPV, data.Fcover.Exp_PV, data.Fcover.Exp_BS, $
                     color='black', psym=16, /overplot, symsize=0.75
   jpgTernaryDiagram, data.Fcover.Exp_NPV[Where_ALL], data.Fcover.Exp_PV[Where_ALL], data.Fcover.Exp_BS[Where_ALL], $
                     color='red', psym=16, /overplot, symsize=0.75
;   colors=['green','yellow', 'royal blue', 'red']                  
;   
;   items = ['RSC', 'ABARES', 'NSW', 'TERN']
;   Al_Legend, items, /FILL, PSYM=Replicate(15,4), COLORS=colors, SYMSIZE=Replicate(1.75,4), $
;      POSITION=[0.60, 0.70], /NORMAL, CHARSIZE=cgDefCharSize()
  PS_End, resize=100, /png
  endif

  ; plot observations
  fname = 'field_triangle_paper2_onlySatellite_withColors.png'
  if (FILE_INFO(fname)).Exists eq 0 then begin
  PS_Start, fname  
   cgDisplay,800,800 
   jpgTernaryDiagram, data.Fcover.Exp_NPV[Where_ALL], data.Fcover.Exp_BS[Where_ALL], data.Fcover.Exp_PV[Where_ALL], $
                     atitle='NPV', ctitle='PV', btitle='BS', color='black', psym=16, symsize=0.01 
   ;jpgTernaryDiagram, data.Fcover.Exp_NPV[Where_ALL], data.Fcover.Exp_PV[Where_ALL], data.Fcover.Exp_BS[Where_ALL], $
   ;                  color='red', psym=16, /overplot, symsize=0.75
                     
    for j=0, n_elements(Where_all)-1 do $          
       jpgTernaryDiagram, data.Fcover.Exp_NPV[Where_all[j]], data.Fcover.Exp_BS[Where_all[j]], data.Fcover.Exp_PV[Where_all[j]], $
              color= cgCOLOR(fix([data.FCOVER.exp_npv[Where_all[j]]*255,$
                                  data.FCOVER.exp_pv[Where_all[j]]*255,$
                                  data.FCOVER.exp_bs[Where_all[j]]*255])), $
                                  psym=16, /overplot, symsize=0.75
  PS_End, resize=100, /png
  endif


  fname = 'field_triangle_AllSites_withColors_RGBinverted.png'
  if (FILE_INFO(fname)).Exists eq 0 then begin
  PS_Start, fname  
   cgDisplay,800,800 
   jpgTernaryDiagram, data.Fcover.Exp_PV, data.Fcover.Exp_NPV, data.Fcover.Exp_BS, $
                     atitle='Green', ctitle='Bare', btitle='Dry', color='black', psym=16, symsize=0.01
                     
   ;jpgTernaryDiagram, data.Fcover.Exp_NPV[Where_ALL], data.Fcover.Exp_PV[Where_ALL], data.Fcover.Exp_BS[Where_ALL], $
   ;                  color='red', psym=16, /overplot, symsize=0.75
                     
    for j=0, n-1 do $          
       jpgTernaryDiagram, data.Fcover.Exp_PV[j], data.Fcover.Exp_NPV[[j]], data.Fcover.Exp_BS[[j]], $
              color= cgCOLOR(fix([data.FCOVER.exp_bs[[j]]*255,$
                                  data.FCOVER.exp_pv[[j]]*255,$
                                  data.FCOVER.exp_npv[[j]]*255])), $
                                  psym=16, /overplot, symsize=0.75
  PS_End, resize=100, /png
  endif


  fname = 'field_triangle_AllSites_withColors_RGBinverted_enhanced.png'
  if (FILE_INFO(fname)).Exists eq 0 then begin
  PS_Start, fname  
   cgDisplay,800,800 ;, color='lavender'
   jpgTernaryDiagram, data.Fcover.Exp_PV, data.Fcover.Exp_NPV, data.Fcover.Exp_BS, $
                     atitle='Green', ctitle='Bare', btitle='Dry', color='black', psym=16, symsize=0.01
                     
   ;jpgTernaryDiagram, data.Fcover.Exp_NPV[Where_ALL], data.Fcover.Exp_PV[Where_ALL], data.Fcover.Exp_BS[Where_ALL], $
   ;                  color='red', psym=16, /overplot, symsize=0.75

   max = data.FCOVER.exp_bs > data.FCOVER.exp_pv > data.FCOVER.exp_npv   
   R = fix((data.FCOVER.exp_bs > 0) / max * 220)
   G = fix((data.FCOVER.exp_PV > 0) / max * 220)
   B = fix((data.FCOVER.exp_npv > 0) / max * 220)
                  
    for j=0, n-1 do $          
       jpgTernaryDiagram, data.Fcover.Exp_PV[j], data.Fcover.Exp_NPV[[j]], data.Fcover.Exp_BS[[j]], $
              color= cgCOLOR([R[j], G[j], B[j]]), psym=16, /overplot, symsize=0.75
  PS_End, resize=100, /png
  endif

   
;    cgWindow, 'cgPlot', data.Fcover.Exp_PV, data.Fcover.Exp_NPV, psym=1, xTitle='exposed PV', yTitle='exposed NPV', /isotropic 
;    cgWindow, 'cgPlot', [1,0],[0,1], psym=-3, /addcmd, /overplot
;    
;    cgWindow, 'cgPlot', data.Fcover.Exp_PV, data.Fcover.Exp_NPV, psym=1, xTitle='exposed PV', yTitle='exposed NPV', /isotropic 
;    cgWindow, 'cgPlot', [1,0],[0,1], psym=-3, /addcmd, /overplot
    
   
              
;;    Ps_Start, 'histograms_rainfall_PS_Start.png'    
;;      !P.Multi = [0,3,2]          
;      cgWindow, WMulti=[0,3,2], wxsize=800, wysize=400 
;      cgHistoplot, Rain_1Day, color='dark green', /FillPolygon, /oprobability, $
;                xTitle='Rain previous 1 day [mm]', yTitle='Density', Charsize=2, /addcmd
;      cgHistoplot, Rain_2Day, color='dark green', /FillPolygon, /oprobability, $
;                xTitle='Rain previous 2 day [mm]', yTitle='Density', Charsize=2, /addcmd
;      cgHistoplot, Rain_3Day, color='dark green', /FillPolygon, /oprobability, $
;                xTitle='Rain previous 3 day [mm]', yTitle='Density', Charsize=2, /addcmd
;      cgHistoplot, Rain_4Day, color='dark green', /FillPolygon, /oprobability, $
;                xTitle='Rain previous 4 day [mm]', yTitle='Density', Charsize=2, /addcmd
;      cgHistoplot, Rain_5Day, color='dark green', /FillPolygon, /oprobability, $
;                xTitle='Rain previous 5 day [mm]', yTitle='Density', Charsize=2, /addcmd
;      cgHistoplot, Rain_6Day, color='dark green', /FillPolygon, /oprobability, $
;                xTitle='Rain previous 6 day [mm]', yTitle='Density', Charsize=2, /addcmd
;;    PS_End, /PNG, Resize=100
              
         
;    ; Histograms with rainfall in previous days 
;      cgWindow, WMulti=[0,3,1], wxsize=800, wysize=200 
;      cgHistoplot, Fcover.Exp_PV, color='dark green', /FillPolygon,  $
;                xTitle='exposed PV', yTitle='Density', /oprobability,  /addcmd
;      cgHistoplot, Fcover.Exp_NPV, color='red', /FillPolygon ,   $
;                xTitle='exposed NPV', yTitle='Density', /oprobability,  /addcmd
;      cgHistoplot, Fcover.Exp_BS, color='blue', /FillPolygon,  $
;                xTitle='exposed BS', yTitle='Density', /oprobability,  /addcmd              
    
;    ; midstorey and overstorey 
;      cgWindow, WMulti=[0,3,2], wxsize=800, wysize=400 
;      cgHistoplot, Data.Fcover.Exp_Mid_PV, color='dark green', /FillPolygon,  $
;                xTitle='exposed MidStorey PV', yTitle='Density', /oprobability,  /addcmd
;      cgHistoplot, Data.Fcover.Exp_Mid_NPV, color='red', /FillPolygon,  $
;                xTitle='exposed MidStorey NPV', yTitle='Density', /oprobability,  /addcmd
;      cgHistoplot, Data.Fcover.Exp_Mid_Tot, color='black', /FillPolygon,  $
;                xTitle='exposed MidStorey Total', yTitle='Density', /oprobability,  /addcmd
;      cgHistoplot, Data.Fcover.Exp_Over_PV, color='dark green', /FillPolygon,  $
;                xTitle='exposed OverStorey PV', yTitle='Density', /oprobability,  /addcmd
;      cgHistoplot, Data.Fcover.Exp_Over_NPV, color='red', /FillPolygon,  $
;                xTitle='exposed Over NPV', yTitle='Density', /oprobability,  /addcmd
;      cgHistoplot, Data.Fcover.Exp_Over_Tot, color='Black', /FillPolygon,  $
;                xTitle='exposed OverStorey Total', yTitle='Density', /oprobability, /addcmd

    ; relationship between exposed overstorey and crown cover 
;    cgWindow, 'cgPlot', Fcover.Exp_Over_Tot, LANDSAT_Qld.crn * 0.01, psym=9, xTitle='exposed OverStorey Total', yTitle='Overstorey Crown'
   
  ; sites with revisits 
  Uniq_Sites = (data.field_all.site)[UNIQ(data.field_all.site, SORT(data.field_all.site))]
  Uniq_Sites_n = intarr(n_elements(Uniq_Sites))
  for i=0, n_elements(Uniq_Sites)-1 do Uniq_Sites_n[i] = n_elements(Where(data.field_all.site eq Uniq_Sites[i]))
  fname = 'histogram_number_visits.png'
  if (FILE_INFO(fname)).Exists eq 0 then begin
  PS_Start, fname  
    !P.Multi=[0,1,2]
    cgDisplay, 300, 400   
    cgHistoPlot, Uniq_Sites_n, xTitle='number of visits',  yTitle='sites', /fillpolygon, /log 
    cgHistoPlot,  Uniq_Sites_n, max_value=50, xTitle='number of visits (zoom)',  yTitle='sites', /fillpolygon
  PS_End, resize=100, /png
  endif
  
  where_ge5 = Where(Uniq_Sites_n ge 5, count_ge5)
  where_sites_ge5=[]
  for i=0, count_ge5-1 do where_sites_ge5 = [where_sites_ge5,where((data.field_all.site) eq Uniq_Sites[where_ge5[i]])] 
    cgWindow, WMulti=[0, 4, count_ge5/4 ]
  for n=0, count_ge5-1 do begin
    site = Uniq_Sites[where_ge5[n]]
    where_site = where(LANDSAT_Qld.site eq site)
    sort_date=Sort(Jul_Day[where_site])
    void = Label_Date(Date_Format= '%M %Y')
    cgWindow, 'cgPlot', (Jul_Day[where_site])[sort_date], (Fcover.Exp_PV[where_site])[sort_date], psym=-2, color='dark green', $
              yRange=[0,1], XTickFormat='Label_Date', Title=site, /addcmd 
    cgWindow, 'cgPlot', (Jul_Day[where_site])[sort_date], (Fcover.Exp_NPV[where_site])[sort_date], psym=-2, color='red', /addcmd, /overplot
    cgWindow, 'cgPlot', (Jul_Day[where_site])[sort_date], (Fcover.Exp_BS[where_site])[sort_date], psym=-2, color='blue', /addcmd, /overplot
  endfor 
  
  ;; plot map sites with 5 or more visits (for comparison paper)
  fname = 'Z:\work\Juan_Pablo\ACEAS\comparison\plots\sites\map_comparison_paper_visitsGE5.png'
  if (FILE_INFO(fname)).Exists eq 0 then begin
  PS_Start, fname
    AusCoastline=auscoastline()
    cgDisplay, 1200, 1200/1.22
    ;cgWindow, wXSize=1200, wYSize=1200/1.22 
;    cgPlot, data.field_all.longitude, data.field_all.latitude, $
;              psym=16, symsize=0.65, xRange=[112, 155], yRange=[-45, -10], xStyle=1, yStyle=1 
    cgPlot, (data.field_all.longitude)[where_sites_ge5], (data.field_all.latitude)[where_sites_ge5], $
              psym=9, symsize=0.9, xRange=[112, 155], yRange=[-45, -10], xStyle=1, yStyle=1, color='red', charsize=2
;    cgWindow, 'cgPlot', LANDSAT_Qld.st_X, LANDSAT_Qld.st_Y, $
;              psym=9, symsize=0.5,  color='blue', /addcmd
    cgPlot, AusCoastline.lon, AusCoastline.lat,  $
              color='black', psym=-3, thick=2, /OVERPLOT
  PS_End, resize=100, /png
  endif 

 
   
   
  ; plot spectra
  MODIS_W = [MODIS_NBAR_WAVELENGHTS(), !VALUES.F_NAN]
  Landsat_W = [Landsat_WAVELENGHTS(), !VALUES.F_NAN]
  
  for i=0, n-1 do MODIS_W = [[MODIS_NBAR_WAVELENGHTS(), !VALUES.F_NAN],[MODIS_W]]
  for i=0, n-1 do Landsat_W = [[Landsat_WAVELENGHTS(), !VALUES.F_NAN],[Landsat_W]]
  ;MODIS_Wavelengths = Transpose(MODIS_Wavelengths)
  Landsat_spectra_3x3 = [[LANDSAT_Scaling.b1_3x3], [LANDSAT_Scaling.b2_3x3], [LANDSAT_Scaling.b3_3x3], [LANDSAT_Scaling.b4_3x3], [LANDSAT_Scaling.b5_3x3], [LANDSAT_Scaling.b6_3x3], [LANDSAT_Scaling.b1_3x3*!VALUES.F_NAN]]
  Landsat_spectra_3x3 = float(Transpose(Landsat_spectra_3x3))
  Landsat_spectra_40x40 = [[LANDSAT_Scaling.b1_40x40], [LANDSAT_Scaling.b2_40x40], [LANDSAT_Scaling.b3_40x40], [LANDSAT_Scaling.b4_40x40], [LANDSAT_Scaling.b5_40x40], [LANDSAT_Scaling.b6_40x40], [LANDSAT_Scaling.b1_40x40*!VALUES.F_NAN]]
  Landsat_spectra_40x40 = float(Transpose(Landsat_spectra_40x40))
  MOD09A1_spectra = [[MOD09A1.b3], [MOD09A1.b4], [MOD09A1.b1], [MOD09A1.b2], [MOD09A1.b5], [MOD09A1.b6], [MOD09A1.b7], [MOD09A1.b7*!VALUES.F_NAN]]
  MOD09A1_spectra = float(Transpose(MOD09A1_spectra)) * 0.0001   ; convert to reflectance 0-1
  where_bad = Where(MOD09A1_spectra le 0, count) & if count ge 1 then MOD09A1_spectra[where_bad]= !VALUES.F_NAN
  MCD43A4_spectra = [[MCD43A4.b3], [MCD43A4.b4], [MCD43A4.b1], [MCD43A4.b2], [MCD43A4.b5], [MCD43A4.b6], [MCD43A4.b7], [MCD43A4.b7*!VALUES.F_NAN]]
  MCD43A4_spectra = float(Transpose(MCD43A4_spectra))* 0.0001   ; convert to reflectance 0-1
  where_bad = Where(MCD43A4_spectra le 0, count) & if count ge 1 then MCD43A4_spectra[where_bad]= !VALUES.F_NAN

  ; plot spectra for sites with >threshold cover of a given type
  threshold = 0.90 
;  if plot_spectra_endmembers eq 1 then begin 
    FORMAT='(1(F4.2,:,","))'
    cgWindow, wMulti=[0,4,3],wxsize=1200, wysize= 800
    where_spectra = Where(Fcover.Exp_PV ge threshold, count_spectra)
    Title = 'PV>' + String(threshold, FORMAT=FORMAT)
    xTitle = 'wavelength'
        if count_spectra ge 1 then $
           cgWindow, 'cgplot', $
              Landsat_W[*,where_spectra], $
              Landsat_spectra_3x3[*,where_spectra], $
              psym = -8, symSize=0.5, yRange = [0, 0.6000] , CharSize=1.25, color='Dark Green', $
              title=title+' - LANDSAT 3x3 pix', xTitle=xTitle , /addcmd 
           cgWindow, 'cgplot', $
              Landsat_W[*,where_spectra], $
              Landsat_spectra_40x40[*,where_spectra], $
              psym = -8, symSize=0.5, yRange = [0, 0.6000] , CharSize=1.25, color='Dark Green', $
              title=title+' - LANDSAT 40x40 pix', xTitle=xTitle , /addcmd 
           cgWindow, 'cgplot', $
              MODIS_W[*,where_spectra], $
              MOD09A1_spectra[*,where_spectra], $
              psym = -8, symSize=0.5, yRange = [0, 0.6000] , CharSize=1.25, color='Dark Green', $
              title=title+' - MOD09A1', xTitle=xTitle , /addcmd 
           cgWindow, 'cgplot', $
              MODIS_W[*,where_spectra], $
              MCD43A4_spectra[*,where_spectra], $
              psym = -8, symSize=0.5, yRange = [0, 0.6000] , CharSize=1.25, color='Dark Green', $
              title=title+' - MCD43A4', xTitle=xTitle , /addcmd 
    where_spectra = Where(Fcover.Exp_NPV ge threshold, count_spectra)
    Title = 'NPV>' + String(threshold, FORMAT=FORMAT)
    xTitle = 'wavelength'
        if count_spectra ge 1 then $
           cgWindow, 'cgplot', $
              Landsat_W[*,where_spectra], $
              Landsat_spectra_3x3[*,where_spectra], $
              psym = -8, symSize=0.5, yRange = [0, 0.6000] , CharSize=1.25, color='Red', $
              title=title+' - LANDSAT 3x3 pix', xTitle=xTitle , /addcmd 
           cgWindow, 'cgplot', $
              Landsat_W[*,where_spectra], $
              Landsat_spectra_40x40[*,where_spectra], $
              psym = -8, symSize=0.5, yRange = [0, 0.6000] , CharSize=1.25, color='Red', $
              title=title+' - LANDSAT 40x40 pix', xTitle=xTitle , /addcmd 
           cgWindow, 'cgplot', $
              MODIS_W[*,where_spectra], $
              MOD09A1_spectra[*,where_spectra], $
              psym = -8, symSize=0.5, yRange = [0, 0.6000] , CharSize=1.25, color='Red', $
              title=title+' - MOD09A1', xTitle=xTitle , /addcmd 
           cgWindow, 'cgplot', $
              MODIS_W[*,where_spectra], $
              MCD43A4_spectra[*,where_spectra], $
              psym = -8, symSize=0.5, yRange = [0, 0.6000] , CharSize=1.25, color='Red', $
              title=title+' - MCD43A4', xTitle=xTitle , /addcmd 
    where_spectra = Where(Fcover.Exp_BS ge threshold, count_spectra)
    Title = 'BS>' + String(threshold, FORMAT=FORMAT)
    xTitle = 'wavelength'
        if count_spectra ge 1 then $
           cgWindow, 'cgplot', $
              Landsat_W[*,where_spectra], $
              Landsat_spectra_3x3[*,where_spectra], $
              psym = -8, symSize=0.5, yRange = [0, 0.6000] , CharSize=1.25, color='Blue', $
              title=title+' - LANDSAT 3x3 pix', xTitle=xTitle , /addcmd 
           cgWindow, 'cgplot', $
              Landsat_W[*,where_spectra], $
              Landsat_spectra_40x40[*,where_spectra], $
              psym = -8, symSize=0.5, yRange = [0, 0.6000] , CharSize=1.25, color='Blue', $
              title=title+' - LANDSAT 40x40 pix', xTitle=xTitle , /addcmd 
           cgWindow, 'cgplot', $
              MODIS_W[*,where_spectra], $
              MOD09A1_spectra[*,where_spectra], $
              psym = -8, symSize=0.5, yRange = [0, 0.6000] , CharSize=1.25, color='Blue', $
              title=title+' - MOD09A1', xTitle=xTitle , /addcmd 
           cgWindow, 'cgplot', $
              MODIS_W[*,where_spectra], $
              MCD43A4_spectra[*,where_spectra], $
              psym = -8, symSize=0.5, yRange = [0, 0.6000] , CharSize=1.25, color='Blue', $
              title=title+' - MCD43A4', xTitle=xTitle , /addcmd 
    ;new window for mixtures           
    cgWindow, wMulti=[0,4,3],wxsize=1200, wysize= 800
    where_spectra = Where(Fcover.Exp_PV ge threshold/2 AND Fcover.Exp_NPV ge threshold/2, count_spectra)
    Title = 'PV>' + String(threshold/2, FORMAT=FORMAT)+' & '+'NPV>' + String(threshold/2, FORMAT=FORMAT)
    xTitle = 'wavelength'
        if count_spectra ge 1 then $
           cgWindow, 'cgplot', $
              Landsat_W[*,where_spectra], $
              Landsat_spectra_3x3[*,where_spectra], $
              psym = -8, symSize=0.5, yRange = [0, 0.6000] , CharSize=1.25, color='olive', $
              title=title+' - LANDSAT 3x3 pix', xTitle=xTitle , /addcmd 
           cgWindow, 'cgplot', $
              Landsat_W[*,where_spectra], $
              Landsat_spectra_40x40[*,where_spectra], $
              psym = -8, symSize=0.5, yRange = [0, 0.6000] , CharSize=1.25, color='olive', $
              title=title+' - LANDSAT 40x40 pix', xTitle=xTitle , /addcmd 
           cgWindow, 'cgplot', $
              MODIS_W[*,where_spectra], $
              MOD09A1_spectra[*,where_spectra], $
              psym = -8, symSize=0.5, yRange = [0, 0.6000] , CharSize=1.25, color='olive', $
              title=title+' - MOD09A1', xTitle=xTitle , /addcmd 
           cgWindow, 'cgplot', $
              MODIS_W[*,where_spectra], $
              MCD43A4_spectra[*,where_spectra], $
              psym = -8, symSize=0.5, yRange = [0, 0.6000] , CharSize=1.25, color='olive', $
              title=title+' - MCD43A4', xTitle=xTitle , /addcmd 
    where_spectra = Where(Fcover.Exp_PV ge threshold/2 AND Fcover.Exp_BS ge threshold/2, count_spectra)
    Title = 'PV>' + String(threshold/2, FORMAT=FORMAT)+' & '+'BS>' + String(threshold/2, FORMAT=FORMAT)
    xTitle = 'wavelength'
        if count_spectra ge 1 then $
           cgWindow, 'cgplot', $
              Landsat_W[*,where_spectra], $
              Landsat_spectra_3x3[*,where_spectra], $
              psym = -8, symSize=0.5, yRange = [0, 0.6000] , CharSize=1.25, color='Teal', $
              title=title+' - LANDSAT 3x3 pix', xTitle=xTitle , /addcmd 
           cgWindow, 'cgplot', $
              Landsat_W[*,where_spectra], $
              Landsat_spectra_40x40[*,where_spectra], $
              psym = -8, symSize=0.5, yRange = [0, 0.6000] , CharSize=1.25, color='Teal', $
              title=title+' - LANDSAT 40x40 pix', xTitle=xTitle , /addcmd 
           cgWindow, 'cgplot', $
              MODIS_W[*,where_spectra], $
              MOD09A1_spectra[*,where_spectra], $
              psym = -8, symSize=0.5, yRange = [0, 0.6000] , CharSize=1.25, color='Teal', $
              title=title+' - MOD09A1', xTitle=xTitle , /addcmd 
           cgWindow, 'cgplot', $
              MODIS_W[*,where_spectra], $
              MCD43A4_spectra[*,where_spectra], $
              psym = -8, symSize=0.5, yRange = [0, 0.6000] , CharSize=1.25, color='Teal', $
              title=title+' - MCD43A4', xTitle=xTitle , /addcmd 
    where_spectra = Where(Fcover.Exp_NPV ge threshold/2 AND Fcover.Exp_BS ge threshold/2, count_spectra)
    Title = 'NPV>' + String(threshold/2, FORMAT=FORMAT)+' & '+'BS>' + String(threshold/2, FORMAT=FORMAT)
    xTitle = 'wavelength'
        if count_spectra ge 1 then $
           cgWindow, 'cgplot', $
              Landsat_W[*,where_spectra], $
              Landsat_spectra_3x3[*,where_spectra], $
              psym = -8, symSize=0.5, yRange = [0, 0.6000] , CharSize=1.25, color='Purple', $
              title=title+' - LANDSAT 3x3 pix', xTitle=xTitle , /addcmd 
           cgWindow, 'cgplot', $
              Landsat_W[*,where_spectra], $
              Landsat_spectra_40x40[*,where_spectra], $
              psym = -8, symSize=0.5, yRange = [0, 0.6000] , CharSize=1.25, color='Purple', $
              title=title+' - LANDSAT 40x40 pix', xTitle=xTitle , /addcmd 
           cgWindow, 'cgplot', $
              MODIS_W[*,where_spectra], $
              MOD09A1_spectra[*,where_spectra], $
              psym = -8, symSize=0.5, yRange = [0, 0.6000] , CharSize=1.25, color='Purple', $
              title=title+' - MOD09A1', xTitle=xTitle , /addcmd 
           cgWindow, 'cgplot', $
              MODIS_W[*,where_spectra], $
              MCD43A4_spectra[*,where_spectra], $
              psym = -8, symSize=0.5, yRange = [0, 0.6000] , CharSize=1.25, color='Purple', $
              title=title+' - MCD43A4', xTitle=xTitle , /addcmd 
   
  
  
 
   
end

