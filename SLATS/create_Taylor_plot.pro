pro create_taylor_plot
  compile_opt idl2

  fname = 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\SAGE\results_sage_Experiments.csv'
  MODELS = READ_ASCII_FILE(fname, /SURPRESS_MSG)

  fname = 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\validation_existing_model\validation_results.csv'
  Validation = READ_ASCII_FILE(fname, /SURPRESS_MSG)
  
 
  ref_std = 1.0                                                
  stddev_max = 1.1                                             

  ;cgWindow, wXsize=1000, wYsize=1000
  PS_Start,  'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\SAGE\results_sage_Taylor_subsetData2.png'
  cgDisplay;, 200, 200
   cgTaylorDiagram, 1, 1, REF_STDDEV=ref_std, $
       STDDEV_MAX=stddev_max, LABELS='', C_SYMBOL='Dark grey', $
       C_CORRELATION='Dark grey', Symbol=3, /addcmd 

  sensorVal=['CSIRO_V2.1','CSIRO_V2.2']
  SYMBOLVal=[1, 7]
  C_SYMBOL=['dark green','goldenrod','brown']

; goto, skipValidation
  for s=0,1 do begin
   w = where(Validation.sensor EQ sensorVal[s] AND Validation.experiment eq 'crypto_EQ_PV') 
   stddev = [(Validation.green_stdev_r)[w]] 
   correlation = [(Validation.green_r)[w]] 
   print, sensorVal[s], w, stddev, correlation
   cgTaylorDiagram, stddev, correlation, REF_STDDEV=ref_std, $
       STDDEV_MAX=stddev_max, LABELS='', C_SYMBOL=C_SYMBOL[0], $
       Symbol=SYMBOLVal[s], /addcmd, /overplot, SymSize=2
   stddev = [(Validation.nongreen_stdev_r)[w]] 
   correlation = [(Validation.nongreen_r)[w]] 
   cgTaylorDiagram, stddev, correlation, REF_STDDEV=ref_std, $
       STDDEV_MAX=stddev_max, LABELS='', C_SYMBOL=C_SYMBOL[1], $
       Symbol=SYMBOLVal[s], /addcmd, /overplot, SymSize=2
   stddev = [(Validation.bare_stdev_r)[w]] 
   correlation = [(Validation.bare_r)[w]] 
   cgTaylorDiagram, stddev, correlation, REF_STDDEV=ref_std, $
       STDDEV_MAX=stddev_max, LABELS='', C_SYMBOL=C_SYMBOL[2], $
       Symbol=SYMBOLVal[s], /addcmd, /overplot, SymSize=2
  endfor 
  skipValidation: print, 'skipped'

;  sensor=['Landsat_QLD','Landsat_3x3','Landsat_40x40', 'MCD43A4', 'MOD09A1']
  sensor=['Landsat_3x3','Landsat_40x40', 'MCD43A4', 'MOD09A1']

;  SYMBOL=[45, 4, 6, 9, 5]
  SYMBOL=[45, 4, 9, 5]
  C_SYMBOL=['dark green','goldenrod','brown']
  
  for s=0,n_elements(sensor)-1 do begin
   w = where(models.sensor EQ sensor[s] AND MODELS.DATA eq 'subsetData') 
   stddev = [(models.green_stdev_r)[w]] 
   correlation = [(models.green_r)[w]] 
   cgTaylorDiagram, stddev, correlation, REF_STDDEV=ref_std, $
       STDDEV_MAX=stddev_max, LABELS='', C_SYMBOL=C_SYMBOL[0], $
       Symbol=Symbol[s], /addcmd, /overplot, SymSize=2
   stddev = [(models.nongreen_stdev_r)[w]] 
   correlation = [(models.nongreen_r)[w]] 
   cgTaylorDiagram, stddev, correlation, REF_STDDEV=ref_std, $
       STDDEV_MAX=stddev_max, LABELS='', C_SYMBOL=C_SYMBOL[1], $
       Symbol=Symbol[s], /addcmd, /overplot, SymSize=2
   stddev = [(models.bare_stdev_r)[w]] 
   correlation = [(models.bare_r)[w]] 
   cgTaylorDiagram, stddev, correlation, REF_STDDEV=ref_std, $
       STDDEV_MAX=stddev_max, LABELS='', C_SYMBOL=C_SYMBOL[2], $
       Symbol=Symbol[s], /addcmd, /overplot, SymSize=2
  endfor     

  al_legend, [sensor, sensorVal], psym=[symbol, SYMBOLVal], box=0, $
    position=[0.7,0.95], /normal;,  /right
  PS_End, resize=100, /png

end
  