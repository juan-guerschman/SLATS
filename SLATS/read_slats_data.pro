function read_SLATS_data 
  compile_opt idl2

  ; LOAD DATA 
  fname = 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\fractional_landsat_subsets\out_b3_3pixSorted.csv'
  LANDSAT_Qld = READ_ASCII_FILE(fname, /SURPRESS_MSG)
  
  fname = 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\fractional_landsat_subsets\pngs_spectra\out_b3_3pixSorted_scaling.csv'
  LANDSAT_Scaling = READ_ASCII_FILE(fname, /SURPRESS_MSG)
  
  fname = 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\GC_MCD43A4_Landsat_21Nov2012.csv'
  MCD43A4 = READ_ASCII_FILE(fname, /SURPRESS_MSG)

  fname = 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\GC_MOD09A1_Landsat_21Nov2012.csv'
  MOD09A1 = READ_ASCII_FILE(fname, /SURPRESS_MSG)

  FNAME = 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\GC_BAWAP_rain_Landsat_data_20Nov2012.csv'
  Rain = READ_ASCII_FILE(fname, /SURPRESS_MSG)
  
;  output_folder = 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\plots\'
;  n = n_elements(LANDSAT_Qld.Obs_key)
;  cd, output_folder
  
  ;Some Defaults for saving: 
;  cgwindow_setdefs, IM_Resize=100
  
   ;-------------------------------------------------------------------------- 
   ; calculate "exposed" fractions (and convert to proportions)
    Exp_Over_PV = LANDSAT_Qld.over_g * 0.01
    Exp_Over_NPV = (LANDSAT_Qld.over_d + LANDSAT_Qld.over_b) * 0.01
    Exp_Over_Tot = Exp_Over_PV + Exp_Over_NPV
    Non_Exp_Over_Tot = (LANDSAT_Qld.over_g + LANDSAT_Qld.over_d + LANDSAT_Qld.over_b) * 0.01
   
    Exp_Mid_PV  =  LANDSAT_Qld.mid_g * 0.01 * (1.0 - Exp_Over_Tot)
    Exp_Mid_NPV = (LANDSAT_Qld.mid_d + LANDSAT_Qld.mid_b) * 0.01 * (1.0 - Exp_Over_Tot)
    Exp_Mid_Tot =  Exp_Mid_PV + Exp_Mid_NPV
    Non_Exp_Mid_Tot = (LANDSAT_Qld.mid_g + LANDSAT_Qld.mid_d + LANDSAT_Qld.mid_b) * 0.01
  
    Exp_Und_PV  =  (LANDSAT_Qld.green + LANDSAT_Qld.crypto) * 0.01 * (1.0 - Exp_Mid_Tot) * (1.0 - Exp_Over_Tot)
    Exp_Und_NPV = (LANDSAT_Qld.dead + LANDSAT_Qld.litter) * 0.01 * (1.0 - Exp_Mid_Tot) * (1.0 - Exp_Over_Tot)
    Exp_Und_BS = (LANDSAT_Qld.crust + LANDSAT_Qld.dist + LANDSAT_Qld.rock) * 0.01 * (1.0 - Exp_Mid_Tot) * (1.0 - Exp_Over_Tot)
    Exp_Und_Tot =  Exp_Und_PV + Exp_Und_NPV + Exp_Und_BS
    Non_Exp_Und_Tot = (LANDSAT_Qld.green + LANDSAT_Qld.crypto + LANDSAT_Qld.dead + LANDSAT_Qld.litter + LANDSAT_Qld.crust + LANDSAT_Qld.dist + LANDSAT_Qld.rock) * 0.01
    
    Exp_PV  = Exp_Over_PV + Exp_Mid_PV + Exp_Und_PV
    Exp_NPV = Exp_Over_NPV + Exp_Mid_NPV + Exp_Und_NPV
    Exp_BS  = Exp_Und_BS  
    Exp_Tot = Exp_PV +  Exp_NPV +  Exp_BS
    
    ; put all in structure
    Fcover = CREATE_STRUCT(  $
                'Exp_PV', Exp_PV, $
                'Exp_NPV', Exp_NPV, $
                'Exp_BS', Exp_BS, $
                'Exp_Tot', Exp_Tot, $
                'Exp_Over_Tot', Exp_Over_Tot, $
                'Exp_Mid_Tot', Exp_Mid_Tot, $
                'Exp_Und_Tot', Exp_Und_Tot, $
                'Exp_Over_PV', Exp_Over_PV, $
                'Exp_Mid_PV', Exp_Mid_PV, $
                'Exp_Und_PV', Exp_Und_PV, $
                'Exp_Over_NPV', Exp_Over_NPV, $
                'Exp_Mid_NPV', Exp_Mid_NPV, $
                'Exp_Und_NPV', Exp_Und_NPV, $
                'DUMMY', 1 $
               )   
               
   ;-------------------------------------------------------------------------- 
   ; calculate "exposed" fractions as per Peter Scarth!! (and convert to proportions)
    
    nTotal=LANDSAT_Qld.num_points

    nCanopyGreen=LANDSAT_Qld.over_g*nTotal/100
    nCanopyDead=LANDSAT_Qld.over_d*nTotal/100
    nCanopyBranch=LANDSAT_Qld.over_b*nTotal/100
    
    nMidGreen=LANDSAT_Qld.mid_g*nTotal/100
    nMidDead=LANDSAT_Qld.mid_d*nTotal/100
    nMidBranch=LANDSAT_Qld.mid_b*nTotal/100
    
    nGroundCrustDistRock=(LANDSAT_Qld.crust+LANDSAT_Qld.dist+LANDSAT_Qld.rock)*nTotal/100
    nGroundGreen=LANDSAT_Qld.green*nTotal/100
    nGroundDeadLitter=(LANDSAT_Qld.dead+LANDSAT_Qld.litter)*nTotal/100
    nGroundCrypto=LANDSAT_Qld.crypto*nTotal/100
    
    canopyFoliageProjectiveCover=nCanopyGreen/(nTotal-nCanopyBranch)
    canopyDeadProjectiveCover=nCanopyDead/(nTotal-nCanopyBranch)
    canopyBranchProjectiveCover=nCanopyBranch/nTotal*(1-canopyFoliageProjectiveCover-canopyDeadProjectiveCover)
    canopyPlantProjectiveCover=(nCanopyGreen+nCanopyDead+nCanopyBranch)/nTotal
    
    midFoliageProjectiveCover=nMidGreen/nTotal
    midDeadProjectiveCover=nMidDead/nTotal
    midBranchProjectiveCover=nMidBranch/nTotal
    midPlantProjectiveCover=(nMidGreen+nMidDead+nMidBranch)/nTotal
    
    satMidFoliageProjectiveCover=midFoliageProjectiveCover*(1-canopyPlantProjectiveCover)
    satMidDeadProjectiveCover=midDeadProjectiveCover*(1-canopyPlantProjectiveCover)
    satMidBranchProjectiveCover=midBranchProjectiveCover*(1-canopyPlantProjectiveCover)
    satMidPlantProjectiveCover=midPlantProjectiveCover*(1-canopyPlantProjectiveCover)
    
    groundPVCover=nGroundGreen/nTotal
    groundNPVCover=nGroundDeadLitter/nTotal
    groundBareCover=nGroundCrustDistRock/nTotal
    groundCryptoCover=nGroundCrypto/nTotal
    groundTotalCover=(nGroundGreen+nGroundDeadLitter+nGroundCrustDistRock)/nTotal
    
    satGroundPVCover=groundPVCover*(1-midPlantProjectiveCover)*(1-canopyPlantProjectiveCover)
    satGroundNPVCover=groundNPVCover*(1-midPlantProjectiveCover)*(1-canopyPlantProjectiveCover)
    satGroundBareCover=groundBareCover*(1-midPlantProjectiveCover)*(1-canopyPlantProjectiveCover)
    satGroundCryptoCover=groundCryptoCover*(1-midPlantProjectiveCover)*(1-canopyPlantProjectiveCover)
    satGroundTotalCover=groundTotalCover*(1-midPlantProjectiveCover)*(1-canopyPlantProjectiveCover)
    
    totalPVCover=canopyFoliageProjectiveCover+satMidFoliageProjectiveCover+satGroundPVCover
    totalNPVCover=canopyDeadProjectiveCover+canopyBranchProjectiveCover+satMidDeadProjectiveCover+satMidBranchProjectiveCover+satGroundNPVCover
    totalBareCover=satGroundBareCover
   
    ; put all in structure
    Fcover_QLD = CREATE_STRUCT(  $
                'totalPVCover', totalPVCover, $
                'totalNPVCover', totalNPVCover, $
                'totalBareCover', totalBareCover, $
                'satGroundPVCover', satGroundPVCover, $
                'satGroundNPVCover', satGroundNPVCover, $
                'satGroundBareCover', satGroundBareCover, $
                'satGroundCryptoCover', satGroundCryptoCover, $
                'satGroundTotalCover', satGroundTotalCover, $
                'DUMMY', 1 $
               )   
   ;-------------------------------------------------------------------------- 
   
   
               
   ;-------------------------------------------------------------------------- 
   ;Calculate julian days
   n = n_elements(Exp_Over_PV)
   day = intarr(n)
   month = intarr(n)
   year = intarr(n)
   for i=0, n-1 do day[i]= (strsplit((LANDSAT_Qld.obs_time)[i], '/', /EXTRACT))[0]
   for i=0, n-1 do month[i]= (strsplit((LANDSAT_Qld.obs_time)[i], '/', /EXTRACT))[1]
   for i=0, n-1 do year[i]= (strsplit((LANDSAT_Qld.obs_time)[i], '/', /EXTRACT))[2]
   Jul_Day = JULDAY(Month, Day, Year)
   
   ; put all in structure and return
   output = CREATE_STRUCT(  $
            'LANDSAT_Qld',      LANDSAT_Qld,         $
            'LANDSAT_Scaling',  LANDSAT_Scaling,     $
            'MCD43A4',          MCD43A4,             $
            'MOD09A1',          MOD09A1,             $
            'Rain',             Rain,                $
            'Fcover',           Fcover,              $
            'Fcover_QLD',       Fcover_QLD,          $
            'dummy',            1                    $   
            )
            
    return, output
end
            
