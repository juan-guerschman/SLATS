pro comparison_A_B_mean, A, B
  compile_opt idl2

  ON_ERROR, 1
  
  years=['2002','2007','2010']
  months=['03','06','09','12']
  composite=['065','161','249','345']

  CASE A of
    'Landsat': A_folder='Z:\work\Juan_Pablo\ACEAS\comparison\Landsat\'
    'CSIRO_V22': A_folder='Z:\work\Juan_Pablo\ACEAS\comparison\csiro_fc\'
    'CSIRO_V30': A_folder='Z:\work\Juan_Pablo\ACEAS\comparison\csiro_fc\'
    'SMA': A_folder='Z:\work\Juan_Pablo\ACEAS\comparison\SMA\'
    'MESMA': A_folder='Z:\work\Juan_Pablo\ACEAS\comparison\MESMA\'
  ELSE: Message, 'A not valid product' 
  ENDCASE

  CASE B of
    'Landsat': B_folder='Z:\work\Juan_Pablo\ACEAS\comparison\Landsat\'
    'CSIRO_V22': B_folder='Z:\work\Juan_Pablo\ACEAS\comparison\csiro_fc\'
    'CSIRO_V30': B_folder='Z:\work\Juan_Pablo\ACEAS\comparison\csiro_fc\'
    'SMA': B_folder='Z:\work\Juan_Pablo\ACEAS\comparison\SMA\'
    'MESMA': B_folder='Z:\work\Juan_Pablo\ACEAS\comparison\MESMA\'
  ELSE: Message, 'B not valid product' 
  ENDCASE

  CASE A of
    'Landsat': A_title='JRSRP'
    'CSIRO_V22': A_title='CSIRO v2.2'
    'CSIRO_V30': A_title='CSIRO v3.0'
    'SMA': A_title='UCLA SMA'
    'MESMA': A_title='UCLA MESMA'
  ENDCASE

  CASE B of
    'Landsat': B_title='JRSRP'
    'CSIRO_V22': B_title='CSIRO v2.2'
    'CSIRO_V30': B_title='CSIRO v3.0'
    'SMA': B_title='UCLA SMA'
    'MESMA': B_title='UCLA MESMA'
  ENDCASE
  
   
;  for y=0,2 do begin
;  for m=0,3 do begin
    DIMS=[9580,7451]

    fname= A_folder + A + '_PV_mean.img'
    A_PV = READ_BINARY(fname, DATA_DIMS=DIMS, Data_Type=4)
    fname= A_folder + A + '_NPV_mean.img'
    A_NPV = READ_BINARY(fname, DATA_DIMS=DIMS, Data_Type=4)
    fname= A_folder + A + '_BS_mean.img'
    A_BS = READ_BINARY(fname, DATA_DIMS=DIMS, Data_Type=4)
 
    fname= B_folder + B + '_PV_mean.img'
    B_PV = READ_BINARY(fname, DATA_DIMS=DIMS, Data_Type=4)
    fname= B_folder + B + '_NPV_mean.img'
    B_NPV = READ_BINARY(fname, DATA_DIMS=DIMS, Data_Type=4)
    fname= B_folder + B + '_BS_mean.img'
    B_BS = READ_BINARY(fname, DATA_DIMS=DIMS, Data_Type=4)
       
          DIFF_PV = A_PV-B_PV
          DIFF_NPV = A_NPV-B_NPV
          DIFF_BS = A_BS-B_BS
          
          where_both_ok = Where(FINITE(DIFF_PV) EQ 1 AND $
                                FINITE(DIFF_NPV) EQ 1 AND $
                                FINITE(DIFF_BS) EQ 1)
                                
                                
    CD,'Z:\work\Juan_Pablo\ACEAS\comparison\plots\spatial\'

;    fname_plot = 'Comparison.'+A+'-'+B+'.MAP.PV.MEAN.ps'
;    if (FILE_INFO(fname_plot)).exists eq 0 then begin
;        PS_Start, fname_plot
;          !P.Multi=0
;          cgDisplay, 500, 500
;          cgLoadCT, 24, /brewer
;          TVLCT, cgColor('grey', /Triple), 0
;            cgImage, BytScl(rotate(DIFF_PV,7), Min=-0.5, Max=0.5), Title='PV',$;, Palette=palette, $
;              Position=[0.05, 0.0, 0.95, 0.8], /keep_aspect_ratio, /SAVE
;            cgColorbar, charsize = 2.5, position=[0.05,0.8,0.95,0.85], $ 
;               Range=[-0.5, 0.5], NColors=254, Bottom=1, $
;               TLocation='Bottom',  oob_high=255b, oob_low=1b, /top ;, /fit,
;         PS_End 
;     Endif          
; 
;      
;    fname_plot = 'Comparison.'+A+'-'+B+'.MAP.NPV.MEAN.ps'
;    if (FILE_INFO(fname_plot)).exists eq 0 then begin
;        PS_Start, fname_plot
;          !P.Multi=0
;          cgDisplay, 500, 500
;          cgLoadCT, 24, /brewer
;          TVLCT, cgColor('grey', /Triple), 0
;            cgImage, BytScl(rotate(DIFF_NPV,7), Min=-0.5, Max=0.5), Title='PV',$;, Palette=palette, $
;              Position=[0.05, 0.0, 0.95, 0.8], /keep_aspect_ratio, /SAVE
;            cgColorbar, charsize = 2.5, position=[0.05,0.8,0.95,0.85], $ 
;               Range=[-0.5, 0.5], NColors=254, Bottom=1, $
;               TLocation='Bottom',  oob_high=255b, oob_low=1b, /top ;, /fit, 
;         PS_End
;     Endif          
;
;    fname_plot = 'Comparison.'+A+'-'+B+'.MAP.BS.MEAN.ps'
;    if (FILE_INFO(fname_plot)).exists eq 0 then begin
;        PS_Start, fname_plot
;          !P.Multi=0
;          cgDisplay, 500, 500
;          cgLoadCT, 24, /brewer
;          TVLCT, cgColor('grey', /Triple), 0
;            cgImage, BytScl(rotate(DIFF_BS,7), Min=-0.5, Max=0.5), Title='PV',$;, Palette=palette, $
;              Position=[0.05, 0.0, 0.95, 0.8], /keep_aspect_ratio, /SAVE
;            cgColorbar, charsize = 2.5, position=[0.05,0.8,0.95,0.85], $ 
;               Range=[-0.5, 0.5], NColors=254, Bottom=1, $
;               TLocation='Bottom',  oob_high=255b, oob_low=1b, /top ;, /fit,
;         PS_End  
;     Endif          

    fname_plot = 'Comparison.'+A+'-'+B+'.scatterplot.PV.MEAN.ps'
    if (FILE_INFO(fname_plot)).exists eq 0 then begin
        PS_Start, fname_plot
          !P.Multi=0
          cgDisplay, 500, 500
           cgLoadCT, 33
           TVLCT, cgColor('white', /Triple), 0
           TVLCT, red, green, blue, /Get
           palette = [ [red], [green], [blue] ]
          xx = lindgen(101) / 100.
          yy = lindgen(101) / 100.
          xrange = [Min(xx), Max(xx)]
          yrange = [Min(yy), Max(yy)]          
            density = HIST_ND(TRANSPOSE([[A_PV[where_both_ok]],[B_PV[where_both_ok]]]), MIN=0,MAX=1,NBINS=100)         
            cgImage, Density, XRange=xrange, YRange=yrange, /Axes, Palette=palette, $
              XTitle=A_title+' PV', YTitle=B_title+' PV', $
              Position=[0.175, 0.15, 0.95, 0.925], /save, charsize = 2.25  
            cgPlot, [0,1],[0,1], psym=-3, /overplot
            r= correlate_nan(A_PV[where_both_ok],B_PV[where_both_ok])
            cgText, 0.95, 0.05, 'r='+string(r, format='(f5.2)'), alignment=1, charsize=3
         PS_End 
     Endif          
      
  
    fname_plot = 'Comparison.'+A+'-'+B+'.scatterplot.NPV.MEAN.ps'
    if (FILE_INFO(fname_plot)).exists eq 0 then begin
        PS_Start, fname_plot
          !P.Multi=0
          cgDisplay, 500, 500
           cgLoadCT, 33
           TVLCT, cgColor('white', /Triple), 0
           TVLCT, red, green, blue, /Get
           palette = [ [red], [green], [blue] ]
          xx = lindgen(101) / 100.
          yy = lindgen(101) / 100.
          xrange = [Min(xx), Max(xx)]
          yrange = [Min(yy), Max(yy)]          
            density = HIST_ND(TRANSPOSE([[A_NPV[where_both_ok]],[B_NPV[where_both_ok]]]), MIN=0,MAX=1,NBINS=100)         
            cgImage, Density, XRange=xrange, YRange=yrange, /Axes, Palette=palette, $
              XTitle=A_title+' NPV', YTitle=B_title+' NPV', $
              Position=[0.175, 0.15, 0.95, 0.925], /save, charsize = 2.25  
            cgPlot, [0,1],[0,1], psym=-3, /overplot
            r= correlate_nan(A_NPV[where_both_ok],B_NPV[where_both_ok])
            cgText, 0.95, 0.05, 'r='+string(r, format='(f5.2)'), alignment=1, charsize=3
         PS_End
     Endif          

    fname_plot = 'Comparison.'+A+'-'+B+'.scatterplot.BS.MEAN.ps'
    if (FILE_INFO(fname_plot)).exists eq 0 then begin
        PS_Start, fname_plot
          !P.Multi=0
          cgDisplay, 500, 500
           cgLoadCT, 33
           TVLCT, cgColor('white', /Triple), 0
           TVLCT, red, green, blue, /Get
           palette = [ [red], [green], [blue] ]
          xx = lindgen(101) / 100.
          yy = lindgen(101) / 100.
          xrange = [Min(xx), Max(xx)]
          yrange = [Min(yy), Max(yy)]          
            density = HIST_ND(TRANSPOSE([[A_BS[where_both_ok]],[B_BS[where_both_ok]]]), MIN=0,MAX=1,NBINS=100)         
            cgImage, Density, XRange=xrange, YRange=yrange, /Axes, Palette=palette, $
              XTitle=A_title+' BS', YTitle=B_title+' BS', $
              Position=[0.175, 0.15, 0.95, 0.925], /save, charsize = 2.25  
            cgPlot, [0,1],[0,1], psym=-3, /overplot
            r= correlate_nan(A_BS[where_both_ok],B_BS[where_both_ok])
            cgText, 0.95, 0.05, 'r='+string(r, format='(f5.2)'), alignment=1, charsize=3
         PS_End
     Endif          

  
;    fname_plot = 'Comparison.'+A+'-'+B+'.histogram.PV.MEAN.ps'
;    if (FILE_INFO(fname_plot)).exists eq 0 then begin
;        PS_Start, fname_plot
;          !P.Multi=0
;          cgDisplay, 500, 500
;           cgHistoplot, DIFF_PV, XTitle=A+' PV - '+B+' PV', mininput=-1, maxinput=1, /NaN
;         PS_End
;     Endif          
; 
;    fname_plot = 'Comparison.'+A+'-'+B+'.histogram.NPV.MEAN.ps'
;    if (FILE_INFO(fname_plot)).exists eq 0 then begin
;        PS_Start, fname_plot
;          !P.Multi=0
;          cgDisplay, 500, 500
;           cgHistoplot, DIFF_NPV, XTitle=A+' NPV - '+B+' NPV', mininput=-1, maxinput=1, /NaN
;         PS_End
;     Endif          
;
;    fname_plot = 'Comparison.'+A+'-'+B+'.histogram.BS.MEAN.ps'
;    if (FILE_INFO(fname_plot)).exists eq 0 then begin
;        PS_Start, fname_plot
;          !P.Multi=0
;          cgDisplay, 500, 500
;           cgHistoplot, DIFF_BS, XTitle=A+' BS - '+B+' BS', mininput=-1, maxinput=1, /NaN
;         PS_End
;     Endif          
 
 end
           
           
           
           