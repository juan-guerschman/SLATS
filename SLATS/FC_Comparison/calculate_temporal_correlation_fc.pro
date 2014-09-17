pro calculate_temporal_correlation_FC 

  ; first open all images
    Landsat=get_Landsat_all_dates()
    CSIRO_V22=get_CSIRO_V22_all_Dates()
    CSIRO_V30=get_CSIRO_V30_all_Dates()
    SMA=get_SMA_all_dates()
    MESMA=get_MESMA_all_dates()
    RSMA=get_RSMA_all_dates()
    LCI=get_LCI_all_dates()

  ; strart looping  
  var_a = ['Landsat','CSIRO_V22','CSIRO_V30','SMA','MESMA','RSMA','LCI']
  var_b=var_a
  
  for i=0,5 do begin
  for j=i+1, 6 do begin
  
    A = var_a[i]
    B = var_b[j]

    CASE A of
      'Landsat': x=Landsat
      'CSIRO_V22': x=CSIRO_V22
      'CSIRO_V30': x=CSIRO_V30
      'SMA': x=SMA
      'MESMA': x=MESMA
      'RSMA': x=RSMA
      'LCI': x=LCI
    ELSE: Message, 'A not valid product' 
    ENDCASE
  
    CASE B of
      'Landsat': y=Landsat
      'CSIRO_V22': y=CSIRO_V22
      'CSIRO_V30': y=CSIRO_V30
      'SMA': y=SMA
      'MESMA': y=MESMA
      'RSMA': y=RSMA
      'LCI': y=LCI
    ELSE: Message, 'B not valid product' 
    ENDCASE
   
    where_less8_pv = where(total(finite(x.pv+y.pv), 3) lt 8)
    where_less8_npv = where(total(finite(x.npv+y.npv), 3) lt 8)
    where_less8_bs = where(total(finite(x.bs+y.bs), 3) lt 8)
  
    cd, 'Z:\work\Juan_Pablo\ACEAS\comparison\correlations\'
  
    r_pv = correl_data_cube(x.pv, y.pv)
    r_pv[where_less8_pv] = !Values.f_nan
    fname = a+'_'+b+'.PV.correlation.img' 
    if (FILE_INFO(fname)).exists eq 0 then ENVI_WRITE_ENVI_FILE, r_pv, OUT_Name=fname
    
    r_npv = correl_data_cube(x.npv, y.npv)
    r_npv[where_less8_npv] = !Values.f_nan
    fname = a+'_'+b+'.NPV.correlation.img' 
    if (FILE_INFO(fname)).exists eq 0 then ENVI_WRITE_ENVI_FILE, r_npv, OUT_Name=fname
  
    r_bs = correl_data_cube(x.bs, y.bs)
    r_bs[where_less8_bs] = !Values.f_nan
    fname = a+'_'+b+'.bs.correlation.img' 
    if (FILE_INFO(fname)).exists eq 0 then ENVI_WRITE_ENVI_FILE, r_bs, OUT_Name=fname
    
    fname_plot = 'tempCorrel.'+A+'-'+B+'.MAP.PV.ps'
    if (FILE_INFO(fname_plot)).exists eq 0 then begin
        PS_Start, fname_plot
          !P.Multi=0
          cgDisplay, 500, 500
          cgLoadCT, 24, /brewer
          TVLCT, cgColor('grey', /Triple), 0
            cgImage, BytScl(rotate(r_PV,7), Min=-1, Max=1), Title='PV',$;, Palette=palette, $
              Position=[0.05, 0.0, 0.95, 0.8], /keep_aspect_ratio, /SAVE
            cgColorbar, charsize = 2.5, position=[0.05,0.8,0.95,0.85], $ 
               Range=[-1, 1], NColors=254, Bottom=1, $
               TLocation='Bottom',  oob_high=255b, oob_low=1b, /top ;, /fit,
         PS_End 
     Endif          
  
    fname_plot = 'tempCorrel.'+A+'-'+B+'.MAP.NPV.ps'
    if (FILE_INFO(fname_plot)).exists eq 0 then begin
        PS_Start, fname_plot
          !P.Multi=0
          cgDisplay, 500, 500
          cgLoadCT, 24, /brewer
          TVLCT, cgColor('grey', /Triple), 0
            cgImage, BytScl(rotate(r_NPV,7), Min=-1, Max=1), Title='NPV',$;, Palette=palette, $
              Position=[0.05, 0.0, 0.95, 0.8], /keep_aspect_ratio, /SAVE
            cgColorbar, charsize = 2.5, position=[0.05,0.8,0.95,0.85], $ 
               Range=[-1, 1], NColors=254, Bottom=1, $
               TLocation='Bottom',  oob_high=255b, oob_low=1b, /top ;, /fit,
         PS_End 
     Endif          

    fname_plot = 'tempCorrel.'+A+'-'+B+'.MAP.BS.ps'
    if (FILE_INFO(fname_plot)).exists eq 0 then begin
        PS_Start, fname_plot
          !P.Multi=0
          cgDisplay, 500, 500
          cgLoadCT, 24, /brewer
          TVLCT, cgColor('grey', /Triple), 0
            cgImage, BytScl(rotate(r_BS,7), Min=-1, Max=1), Title='BS',$;, Palette=palette, $
              Position=[0.05, 0.0, 0.95, 0.8], /keep_aspect_ratio, /SAVE
            cgColorbar, charsize = 2.5, position=[0.05,0.8,0.95,0.85], $ 
               Range=[-1, 1], NColors=254, Bottom=1, $
               TLocation='Bottom',  oob_high=255b, oob_low=1b, /top ;, /fit,
         PS_End 
     Endif          

    fname_plot = 'tempCorrel.'+A+'-'+B+'.histogram.PV.ps'
    n = total(finite(r_pv))
    if (FILE_INFO(fname_plot)).exists eq 0 then begin
        PS_Start, fname_plot
          !P.Multi=0
          cgDisplay, 500, 500
           if n ge 3 then cgHistoplot, r_pv, XTitle='PV', mininput=-1, maxinput=1, /NaN, polycolor='black', datacolorname='black', color='black',  /fillpolygon
         PS_End
     Endif          

    fname_plot = 'tempCorrel.'+A+'-'+B+'.histogram.NPV.ps'
    n = total(finite(r_NPV))
    if (FILE_INFO(fname_plot)).exists eq 0 then begin
        PS_Start, fname_plot
          !P.Multi=0
          cgDisplay, 500, 500
           if n ge 3 then cgHistoplot, r_NPV, XTitle='NPV', mininput=-1, maxinput=1, /NaN, polycolor='black', datacolorname='black', color='black',  /fillpolygon
         PS_End
     Endif          

    fname_plot = 'tempCorrel.'+A+'-'+B+'.histogram.BS.ps'
    n = total(finite(r_BS))
    if (FILE_INFO(fname_plot)).exists eq 0 then begin
        PS_Start, fname_plot
          !P.Multi=0
          cgDisplay, 500, 500
           if n ge 3 then cgHistoplot, r_BS, XTitle='BS', mininput=-1, maxinput=1, /NaN, polycolor='black', datacolorname='black', color='black',  /fillpolygon
         PS_End
     Endif          

  endfor
  endfor
end

