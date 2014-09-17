;Write a routine that retrieves field measurements of ground cover across Australia
;@ /Volumes/CSIRO/CPH_CSIRO_2010/IDL_library/surface_analysis/surf_data_mod_compar__define.pro
;@ /Volumes/CSIRO/CPH_CSIRO_2010/IDL_library/AIRCRAFT_analysis/ac_data__define.pro
;@ /Volumes/CSIRO/CPH_CSIRO_2010/IDL_library/AIRCRAFT_analysis/ac_data_mod_comp__define.pro
;@ /Volumes/CSIRO/CPH_CSIRO_2010/IDL_library/AIRCRAFT_analysis/ac_data_average_ac_data__define.pro
;@ /Volumes/CSIRO/CPH_CSIRO_2010/IDL_library/Default/plotting/plot_general__define.pro
;@ /Volumes/CSIRO/CPH_CSIRO_2010/IDL_library/Default/plotting/plotting_2d.pro
;@ /Volumes/CSIRO/CPH_CSIRO_2010/IDL_library/Flux_analysis/split_flux_grids.pro
;@ /Volumes/CSIRO/CPH_CSIRO_2010/IDL_library/Flux_analysis/flux_grid__apply_moving_avrg.pro
;@ /Volumes/CSIRO/CPH_CSIRO_2010/IDL_library/Flux_analysis/flux_grid__define.pro
;@ /Volumes/CSIRO/CPH_CSIRO_2010/IDL_library/Flux_analysis/plot_grid_methods.pro
;@ /Volumes/CSIRO/CPH_CSIRO_2010/IDL_library/Flux_analysis/satellite_routines/sat_grid__define.pro
;@ /Volumes/CSIRO/CPH_CSIRO_2010/IDL_library/Flux_analysis/satellite_routines/get_sat_file_names.pro
;@ /Volumes/CSIRO/CPH_CSIRO_2010/IDL_library/Flux_analysis/grid_climatology_routines/flux_grid_climatology_methods.pro
;@ /Volumes/CSIRO/CPH_CSIRO_2010/IDL_library/Flux_analysis/flux_analysis_methods.pro
;@ /Volumes/CSIRO/CPH_CSIRO_2010/IDL_library/Flux_analysis/flux_grid__map_algebra.pro
;@ /Volumes/CSIRO/CPH_CSIRO_2010/IDL_library/Flux_analysis/grid_climatology_routines/ac_data_mod_comp__generate_grid_timeseries.pro
;@ /Volumes/CSIRO/CPH_CSIRO_2010/satellite_fpar_analysis/sfa_gen_ts_input_args.pro
;@ /Volumes/CSIRO/CPH_CSIRO_2010/IDL_library/Default/miscellaneous/read_ascii_file.pro
;@ /Volumes/CSIRO/CPH_CSIRO_2010/IDL_library/Default/miscellaneous/get_doy_seasonal_range.pro
;@ /Volumes/CSIRO/CPH_CSIRO_2010/satellite_fpar_analysis/sfa_fpar_consistency_analysis/sfa_analyse_fpar_clim_consistency_input_args.pro
;@ /Volumes/CSIRO/CPH_CSIRO_2010/IDL_library/Flux_analysis/aus_region_classifications.pro

FUNCTION sat_fpar_anal_get_FC_field_data, N_MODELS=N_MODELS

  TRUE   =  1
  FALSE  =  0
  ERROR  = -1
  UNDEF  =  0
  
  NO_DATA      =   -999
  NO_DATA_STR  =  '-999'
  PC_CONV      =   0.01
  
  curr_OS   =  !version.os  ;Get the current operating system (a string name)
  WIN_ID    =  'Win32'
  LINUX_ID  =  'linux'
  OSX_ID    =  'darwin'

  ;Some input arguments
  IF(curr_OS  EQ  OSX_ID)  THEN  input_direc  =  '/Volumes/cbgc$/Data_field_obs_frac_cover/' ;Input directory containing the field data file
  IF(curr_OS  EQ  WIN_ID)  THEN  input_direc  =  '\\wron\working\work\Juan_Pablo\PV_NPV_BS\New_Validation'
  
  ;input_direc     =  '/Volumes/cbgc$/Data_field_obs_frac_cover/' ;Input directory containing the field data file
  input_data_FN   =  'GC_master_2012July10.csv' ;Fractional cover field data file-name
  input_field_FN  =  'GC_field_list.txt' ;List of fields to be extracted from the field data file
  
  ;First check some of the input files/directories
  z = CHECK_FILE_EXISTENCE(input_direc, /DIRECTORY)
  IF(z[0]  EQ  ERROR)  THEN  BEGIN
    print, 'sat_fpar_anal_field_validation: Unknown input directory (directory not found). RETURNING...'
    RETURN, ERROR
  ENDIF
  tmp_var  =  input_direc  +  input_data_FN
  z  =  CHECK_FILE_EXISTENCE(tmp_var)
  IF(z[0]  EQ  ERROR)  THEN  BEGIN
    print, 'sat_fpar_anal_field_validation: Can not find input data file:'
    print, '                                 ', input_data_FN
    print, '                                 RETURNING...'
    RETURN, ERROR
  ENDIF
  tmp_var  =  input_direc  +  input_field_FN
  z  =  CHECK_FILE_EXISTENCE(tmp_var)
  IF(z[0]  EQ  ERROR)  THEN  BEGIN
    print, 'sat_fpar_anal_field_validation: Can not find data field input file:' 
    print, '                                 ', input_field_FN
    print, '                                 RETURNING...'
    RETURN, ERROR
  ENDIF
  
  IF(N_ELEMENTS(output_direc)  EQ  UNDEF)  THEN  output_direc  =  input_direc  +  'field_data_diagnostics'
  z  =  CHECK_FILE_EXISTENCE(output_direc, /DIRECTORY, /CREATE_DIRECTORY)
  IF(z[0]  EQ  ERROR)  THEN  BEGIN
    print, 'sat_fpar_anal_field_validation: Can not create the specified/default output directory:'
    print, '                                 ', output_direc
    print, '                                 RETURN, ERRORING...'
    RETURN, ERROR
  ENDIF
  
  ;First get the list of data fields to be extracted
;  field_arr  =  READ_ASCII_FILE(input_field_FN, direc=input_direc, /SURPRESS_MSG)
  
  ;Now retrieve the data fields from the data input file
;  input_data_arr  =  READ_ASCII_FILE(input_data_FN, direc=input_direc, field_arr=field_arr.field_name,           $
;                                  addn_fields=addn_fields, /SURPRESS_MSG)
   input_data_arr  =  READ_ASCII_FILE(input_data_FN, direc=input_direc,                                           $
                                       /SURPRESS_MSG)
                                  
  
  ;We would like to know in what vegetation class and drainage division all field observations lie
  ;Retrieve the NVIS and Aus. Drainage Div. class for each observation
;  NVIS_grid   =  get_NVIS_regions(AUS_reg_arr=NVIS_reg_arr, AUS_reg_names=NVIS_reg_names,               $
;                                  /RETURN_SINGLE_GRID, /SURPRESS_MSG)
;  DrDiv_grid  =  get_AUS_DrainDiv_regions(AUS_reg_arr=AUS_DD_reg_arr, AUS_reg_names=AUS_DD_reg_names,   $
;                                          /RETURN_SINGLE_GRID, /SURPRESS_MSG)
  

  ;Now create a new dataset that will contain the calculated exposed fractional cover (PV, NPV, BS)
  ; I.e. the fractional cover as seen overhead (from an aerial/satellite observing platform)
  model_data_str  =  {model_name:        '',      $; Model name (e.g. MODIS)
                      model_val:        0.0,      $; Model value (e.g. FAPAR, closest grid point)
                      model_mean_val:   0.0,      $; Model mean value (from a small spatial domain surrounding the observation)
                      model_SD:         0.0,      $; Model SD value (From a small spatial domain...)
                      diff_val:         0.0,      $; Difference between the observation value and model value
                      diff_mean_val:    0.0,      $; Difference between the observation value and the model mean value
                      time_diff:          0,      $; Difference in time (days) between the observation and satellite date
                      weighting:        0.0,      $; For interpolation between two different satellite grids, this gives the time-average weighting
                      SND_FILE:           0      $; This indicates if the second closest file to the field obs was used instead of the closest file (due to NO_DATA values)
                     }
  model_data_str  =  REPLICATE(model_data_str, N_MODELS)


  orig_data_str   =  {gnd_PV:                      0.0,            $; Ground PV fractional cover
                      gnd_NPV:                     0.0,            $; Ground NPV fractional cover
                      gnd_BS:                      0.0,            $; Ground BS fractional cover
                      gnd_PV_expos:                0.0,            $;  Exposed ground PV frac. cover
                      gnd_NPV_expos:               0.0,            $;  Exposed ground NPV frac. cover
                      gnd_BS_expos:                0.0,            $;  Exposed ground BS frac. cover
                      mid_PV:                      0.0,            $; Mid-story PV fractional cover
                      mid_NPV:                     0.0,            $; Mid-story NPV fractional cover
                      mid_PV_expos:                0.0,            $;  Exposed mid-story PV
                      mid_NPV_expos:               0.0,            $;  Exposed mid-story NPC
                      over_PV:                     0.0,            $; Over-story PV fractional cover
                      over_NPV:                    0.0,            $; Over-story NPV fractional cover
                      GRN_SUM:                     0.0,            $; Green sum
                      BRWN_SUM:                    0.0,            $; Brown sum
                      BARE_SUM:                    0.0,            $; Bare sum
                      TOT_GCOV:                    0.0,            $; Total ground cover
                      MID_C:                       0.0,            $; Total mid-cover (mid-story cover)
                      OVER_C:                      0.0,            $; Total over cover (canopy cover)
                      calc_gcov:                   0.0,            $; Calculated total ground cover (PV + NPV of the ground)
                      calc_mid_C:                  0.0,            $; Calculated total mid-cover (PV + NPV of mid-story)
                      calc_over_C:                 0.0            $; Calculated total cover-cover (PV + NPV of over-story)
                     }

  FC_data_str  =  {objectID:                     0L,            $; Object (measurement) ID
                   site_name:                    '',            $; Site name
                   state:                        '',            $; State (of Australia)
                   latitude:                    0.0,            $; Latitude
                   longitude:                   0.0,            $; Longitude
                   juldate:                      0L,            $; Julian date
                   dcml_date:                   0.0,            $; Decimal date
                   DOY:                           0,            $; Day of year
                   year:                          0,            $; Year
                   mth:                           0,            $; Month
                   day:                           0,            $; Day
                   hr:                            0,            $; Hr
                   mn:                            0,            $; Minute
                   NVIS_class:                   -1,            $; NVIS vegetation group number
                   NVIS_group_name:              '',            $; NVIS vegetation group name
                   drain_div_class:              -1,            $; Aus. Drainage Division Class (number)
                   drain_div_name:               '',            $; Aus. Drainage Division Name
                   total_PV_FC:                 0.0,            $; Total exposed PV fractional cover (to be calculated)
                   total_NPV_FC:                0.0,            $; Total exposed NPV fractional cover (to be calculated)
                   total_BS_FC:                 0.0,            $; Total exposed BS fractional cover (to be calculated)
                   combin_BC_NPV:               0.0,            $; Combined fractional cover of NPV and BS
                   veg_struct_index:            0.0,            $; The CSC metric (vegetation structure complexity)
                   CHK_SUM:                     0.0,            $; Check that total PV_FC, NPV_FC and BS_FC adds to 1.0 (100%)
                   QA_GND_SUMS_ID:                0,            $; A QA check for ground cover fractions (see a few lines below)
                   QA_MID_SUMS_ID:                0,            $; A QA check for mid-story cover fractions (see a few lines below)
                   QA_OVER_SUMS_ID:               0,            $; A QA check for over-story cover fractions (see a few lines below)
                   MODEL_STATUS:                  0,            $; Status of whether a model data data-structure is present
                   N_MODELS:                      0,            $; Number of models, from which model data is included in this data structure
                   orig_data:         orig_data_str,            $; Structure containing the original data from input_data_arr
                   model_data:       model_data_str           $; Array of structure(s) containing model data
                  }

  ;QA_GND_SUMS_ID:
  ;IF QA_GND_SUMS_ID = 1,  this means that the calc. PV, NPV and BS fractions sum to 1.0
  ;IF QA_GND_SUMS_ID = 0,  this means that the calc. PV, NPV and BS fractions do NOT sum to 1.0 However, the input file variables
  ;                    GREEN_SUM, BROWN_SUM and BARE_SUM DO sum to 1.0. These values are taken as the PV, NPV and BS fractions
  ;IF QA_GND_SUMS_ID = -1, this means that both PV/NPV/BS and GREEN_SUM/BROWN_SUM/BARE_SUM fractions DO NOT sum to 1.0
  
  ;QA_MID_SUMS_ID:
  ;IF QA_MID_SUMS_ID = 1, This means that the calc. SUM(PV & NPV fractions) EQUALS that of MID_C in the input file
  ;IF QA_MID_SUMS_ID = 0, This means that the calc. SUM(PV & NPV fractions) DOES NOT EQUAL that of MID_C in the input file
  ;
  ;QA_OVER_SUMS_ID:
  ;IF QA_OVER_SUMS_ID = 1, This means that the calc. SUM(PV & NPV fractions) EQUALS that of OVER_C in the input file
  ;IF QA_OVER_SUMS_ID = 0, This means that the calc. SUM(PV & NPV fractions) DOES NOT EQUAL that of OVER_C in the input file
  
  IF(N_ELEMENTS(N_MODELS)  NE  UNDEF)  THEN  BEGIN
    IF(N_MODELS EQ FALSE)  THEN  BEGIN
      print, 'sat_fpar_anal_field_validation: N_MODELS set to 0'
      print, '                                 Can not allocate a data structure to contain the model data'
    ENDIF ELSE BEGIN
    
      ;Problem with pointers is we can ONLY access one pointer at a time. We can not treet FC_field_obs[*].model_data[*].model_val
      ; as a 2D array. Instead we have to loop through each pointer (in FC_field_obs[i] at location i)
      ;tmp_str         =  {model_data:     PTRARR(N_MODELS)}
      ;FC_data_str     =  CREATE_STRUCT(FC_data_str, tmp_str)

      ;Problem here is we can not 'add' an array of structures as a field to an existing structure.
      ;Only a single structure/element/scalar
      ;THEREFORE, decided to just add the MODEL_DATA array of structures in FC_DATA_STR definition above (PFFFFFFFF!)
      ;tmp_str      =  REPLICATE({model_data:   model_data_str}, N_MODELS)
      ;FC_data_str  =  CREATE_STRUCT(FC_data_str, tmp_str)
      
      FC_data_str.N_MODELS      =  N_MODELS
      FC_data_str.MODEL_STATUS  =  TRUE
    ENDELSE
  ENDIF
                   
  FC_field_obs  =  REPLICATE(FC_DATA_STR, N_ELEMENTS(input_data_arr))
  
  ;Now we go through each observation and copy across the relevant fields from input_data_arr to FC_field_obs
  ; THEN we calculate the total exposed PV, NPV and BS
  ; First, set some thresholds
  GND_COV_THRSHOLD  =  0.05
  MID_COV_THRSHOLD  =  0.01
  OVER_COV_THRSHOLD =  0.01
  
  print, 'Calculating: TOTAL_PV_FC, TOTAL_NPV_FC, TOTAL_BS_FC'
  FOR i=0, N_ELEMENTS(FC_field_obs) -1 DO BEGIN
  
  ;  IF((i MOD 10)  EQ  FALSE)  THEN  print, i
  
    FC_field_obs[i].objectID      =  input_data_arr[i].OBJECTID
    FC_field_obs[i].site_name     =  input_data_arr[i].site_name
    FC_field_obs[i].state         =  input_data_arr[i].state
    FC_field_obs[i].latitude      =  input_data_arr[i].latitude
    FC_field_obs[i].longitude     =  input_data_arr[i].longitude
    
    date_str  =  STRSPLIT(input_data_arr[i].DATE_COLLECT, '-', /EXTRACT)
    IF(FIX(date_str[0])  NE  NO_DATA)  THEN  BEGIN
      FC_field_obs[i].year          =  FIX(date_str[0])
      FC_field_obs[i].mth           =  FIX(date_str[1])
      FC_field_obs[i].day           =  FIX(date_str[2])
    ENDIF ELSE BEGIN
      FC_field_obs[i].year          =  NO_DATA
      FC_field_obs[i].mth           =  NO_DATA
      FC_field_obs[i].day           =  NO_DATA
    ENDELSE
    time_str  =  STRSPLIT(input_data_arr[i].TIME, ':', /EXTRACT)
    IF(FIX(time_str[0])  NE  NO_DATA)  THEN  BEGIN
      FC_field_obs[i].hr            =  FIX(time_str[0])
      FC_field_obs[i].mn            =  FIX(time_str[1])
    ENDIF ELSE BEGIN
      FC_field_obs[i].hr            =  NO_DATA
      FC_field_obs[i].mn            =  NO_DATA
    ENDELSE
    
    ; Sum of green veg and cryptogamic crust (e.g. moss, lichens, fungi, lichen)
    IF(FIX(input_data_arr[i].GREEN)  NE NO_DATA) THEN FC_field_obs[i].orig_data.gnd_PV   =  FC_field_obs[i].orig_data.gnd_PV + input_data_arr[i].GREEN
    IF(FIX(input_data_arr[i].CRYPTO) NE NO_DATA) THEN FC_field_obs[i].orig_data.gnd_PV   =  FC_field_obs[i].orig_data.gnd_PV + input_data_arr[i].CRYPTO
    
    ; Sum of crust, disturbance and rock
    IF(FIX(input_data_arr[i].CRUST)  NE NO_DATA) THEN FC_field_obs[i].orig_data.gnd_BS   =  FC_field_obs[i].orig_data.gnd_BS + input_data_arr[i].CRUST
    IF(FIX(input_data_arr[i].DIST)   NE NO_DATA) THEN FC_field_obs[i].orig_data.gnd_BS   =  FC_field_obs[i].orig_data.gnd_BS + input_data_arr[i].DIST
    IF(FIX(input_data_arr[i].ROCK)   NE NO_DATA) THEN FC_field_obs[i].orig_data.gnd_BS   =  FC_field_obs[i].orig_data.gnd_BS + input_data_arr[i].ROCK
    
    ; Sum of litter and dry leaves
    IF(FIX(input_data_arr[i].LITTER) NE NO_DATA) THEN FC_field_obs[i].orig_data.gnd_NPV  = FC_field_obs[i].orig_data.gnd_NPV + input_data_arr[i].LITTER
    IF(FIX(input_data_arr[i].DRY)    NE NO_DATA) THEN FC_field_obs[i].orig_data.gnd_NPV  = FC_field_obs[i].orig_data.gnd_NPV + input_data_arr[i].DRY
    
    ; Green vegetation (mid level: < 2m)
    IF(FIX(input_data_arr[i].MID_G)  NE NO_DATA) THEN FC_field_obs[i].orig_data.mid_PV   =  input_data_arr[i].MID_G 
    ; Sum of branches and dry leaves
    IF(FIX(input_data_arr[i].MID_B)  NE NO_DATA) THEN FC_field_obs[i].orig_data.mid_NPV  =  FC_field_obs[i].orig_data.mid_NPV  +  input_data_arr[i].MID_B
    IF(FIX(input_data_arr[i].MID_D)  NE NO_DATA) THEN FC_field_obs[i].orig_data.mid_NPV  =  FC_field_obs[i].orig_data.mid_NPV  +  input_data_arr[i].MID_D
    
    ; Green veg in canopy (overhanging vegetation)
    IF(FIX(input_data_arr[i].OVER_G) NE NO_DATA) THEN FC_field_obs[i].orig_data.over_PV  =  input_data_arr[i].OVER_G
    ; Sum of branches and dry leaves (canopy level: >2m)
    IF(FIX(input_data_arr[i].OVER_B) NE NO_DATA) THEN FC_field_obs[i].orig_data.over_NPV = FC_field_obs[i].orig_data.over_NPV + input_data_arr[i].OVER_B
    IF(FIX(input_data_arr[i].OVER_D) NE NO_DATA) THEN FC_field_obs[i].orig_data.over_NPV = FC_field_obs[i].orig_data.over_NPV + input_data_arr[i].OVER_D
    

    FC_field_obs[i].orig_data.GRN_SUM   =  input_data_arr[i].GREEN_SUM        ;Check sums from input file
    FC_field_obs[i].orig_data.BRWN_SUM  =  input_data_arr[i].BROWN_SUM        ;Check sums from input file
    FC_field_obs[i].orig_data.BARE_SUM  =  input_data_arr[i].BARE_SUM         ;Check sums from input file
    FC_field_obs[i].orig_data.TOT_GCOV  =  input_data_arr[i].TOTAL_GCOV       ;Check sums from input file
    FC_field_obs[i].orig_data.MID_C     =  input_data_arr[i].MID_C            ;Check sums from input file
    FC_field_obs[i].orig_data.OVER_C    =  input_data_arr[i].OVER_C           ;Check sums from input file
    
    ;Check if our calculation of PV (GREEN), NPV (BROWN) and BS (BARE) are equal to those provided in the input file
    TOT_GND_COV  =  PC_CONV*(FC_field_obs[i].orig_data.gnd_PV          +      $
                             FC_field_obs[i].orig_data.gnd_NPV         +      $
                             FC_field_obs[i].orig_data.gnd_BS)
    IF(ABS(TOT_GND_COV - 1.0)  GT  GND_COV_THRSHOLD)  THEN  BEGIN
      
      tmp_var  =  PC_CONV*(FC_field_obs[i].orig_data.GRN_SUM           +      $ 
                           FC_field_obs[i].orig_data.BRWN_SUM          +      $
                           FC_field_obs[i].orig_data.BARE_SUM)
      IF(ABS(tmp_var - 1.0)  LE  GND_COV_THRSHOLD)  THEN  BEGIN
      
        FC_field_obs[i].orig_data.gnd_PV         =  FC_field_obs[i].orig_data.GRN_SUM
        FC_field_obs[i].orig_data.gnd_NPV        =  FC_field_obs[i].orig_data.BRWN_SUM
        FC_field_obs[i].orig_data.gnd_BS         =  FC_field_obs[i].orig_data.BARE_SUM
        FC_field_obs[i].QA_GND_SUMS_ID           =  FALSE; See above for explination of ID meaning
      ENDIF ELSE FC_field_obs[i].QA_GND_SUMS_ID  =  ERROR; See above for explination of ID meaning
      
    ENDIF ELSE FC_field_obs[i].QA_GND_SUMS_ID    =  TRUE; See above for explination of ID meaning
    
    ;Calculate total ground cover (not including bare ground/BS): PV(gnd) + NPV(gnd)
    FC_field_obs[i].orig_data.calc_gcov  =  (FC_field_obs[i].orig_data.gnd_PV  +  FC_field_obs[i].orig_data.gnd_NPV)
    
    ;Now we want to calculate the exposed (effective) veg. cover of PV, NPV and BS
    ;The original data gives the PV, NPV and BS (where appropriate) for each level: Ground level, under-story (<2m) and canopy (>2m)
    ; This is done irrespective of the level of cover of other levels
    ; We need to calculate the effective (exposed) cover from an overhead perspective for each level
    ;  Then we calculate the total exposed (effective) PV, NPV and BS cover.
    ;  E.G. If PV/NPV frac. cover for canopy is 75%, then we only see the remaining 25% of the mid-story and ground level
    ;  Thus the PV/NPV/BS estimates for these lower levels must be scalled down to reflect only the remaining 25% of the area
    ;  where the mid-story and ground level can be seen. If mid-story cover is 40%, then we will only see 15% of the ground
    ;   (0.25*0.60 = 0.15 -> We will only see 0.15 of the entire ground cover (PV, NPV and BS combined)
    ;  Exposed PV is thus 0.75 + 0.15 + 0.1 = 1.0
    ;
    ; Remember that the fractional cover (PV, NPV) of crown level and mid-story DOES NOT have to add to 1.0
    ; But the fractional cover (PV, NPV, BS) of the ground level MUST add to 1.0
    
    over_total_FC  =  (FC_field_obs[i].orig_data.over_PV +  FC_field_obs[i].orig_data.over_NPV)*PC_CONV
    mid_total_FC   =  (FC_field_obs[i].orig_data.mid_PV  +  FC_field_obs[i].orig_data.mid_NPV)*PC_CONV
    
    FC_field_obs[i].orig_data.mid_PV_expos  =  FC_field_obs[i].orig_data.mid_PV*(1 - over_total_FC)
    FC_field_obs[i].orig_data.mid_NPV_expos =  FC_field_obs[i].orig_data.mid_NPV*(1 - over_total_FC)
    
    FC_field_obs[i].orig_data.gnd_PV_expos  =  FC_field_obs[i].orig_data.gnd_PV*((1 - over_total_FC)*(1 - mid_total_FC))
    FC_field_obs[i].orig_data.gnd_NPV_expos =  FC_field_obs[i].orig_data.gnd_NPV*((1 - over_total_FC)*(1 - mid_total_FC))
    FC_field_obs[i].orig_data.gnd_BS_expos  =  FC_field_obs[i].orig_data.gnd_BS*((1 - over_total_FC)*(1 - mid_total_FC))
    
    ;Some QA checks
    tmp_val  =  PC_CONV*(FC_field_obs[i].orig_data.mid_PV + FC_field_obs[i].orig_data.mid_NPV)
    IF(ABS(tmp_val - FC_field_obs[i].orig_data.MID_C)  LE  MID_COV_THRSHOLD) THEN FC_field_obs[i].QA_MID_SUMS_ID = TRUE
    tmp_val  =  PC_CONV*(FC_field_obs[i].orig_data.over_PV + FC_field_obs[i].orig_data.over_NPV)
    IF(ABS(tmp_val - FC_field_obs[i].orig_data.OVER_C) LE  OVER_COV_THRSHOLD) THEN FC_field_obs[i].QA_OVER_SUMS_ID = TRUE
    
    ;Calculate total mid-story and over-story cover: PV(mid/over) + NPV(mid/over)
    FC_field_obs[i].orig_data.calc_mid_C   =  FC_field_obs[i].orig_data.mid_PV   +  FC_field_obs[i].orig_data.mid_NPV
    FC_field_obs[i].orig_data.calc_over_C  =  FC_field_obs[i].orig_data.over_PV  +  FC_field_obs[i].orig_data.over_NPV
        
    ;Now calculate the total exposed (effective) coverage of PV, NPV and BS from the field observations.
    ; Also convert from percentages to fractions
    FC_field_obs[i].total_PV_FC   =  (FC_field_obs[i].orig_data.over_PV              +        $
                                      FC_field_obs[i].orig_data.mid_PV_expos         +        $
                                      FC_field_obs[i].orig_data.gnd_PV_expos)*PC_CONV
    FC_field_obs[i].total_NPV_FC  =  (FC_field_obs[i].orig_data.over_NPV             +        $
                                      FC_field_obs[i].orig_data.mid_NPV_expos        +        $
                                      FC_field_obs[i].orig_data.gnd_NPV_expos)*PC_CONV
    FC_field_obs[i].total_BS_FC   =   (FC_field_obs[i].orig_data.gnd_BS_expos)*PC_CONV
  
    ;Compute a check sum: Check that the total PV, NPV and BS fractions sum to 1.0 (100%)
    FC_field_obs[i].CHK_SUM       =  FC_field_obs[i].total_PV_FC   +                 $
                                     FC_field_obs[i].total_NPV_FC  +                 $
                                     FC_field_obs[i].total_BS_FC
                                     
    FC_field_obs[i].combin_BC_NPV =  FC_field_obs[i].total_NPV_FC  +  FC_field_obs[i].total_BS_FC
    
    ;Now determine the NVIS veg. group and Aus. drainage division in which each field observation lies
    pos_thrshold  =  0.05
    IF(OBJ_VALID(NVIS_grid)  EQ  TRUE)  THEN  BEGIN
      NVIS_grid_val  =  NVIS_grid->return_grid_value(lon_arr=FC_field_obs[i].longitude,               $
                                                     lat_arr=FC_field_obs[i].latitude,                $
                                                     domain_error=domain_error,                       $
                                                     uniq_grid_vals=uniq_grid_vals)
      IF(domain_error[0]  EQ  FALSE)  THEN  BEGIN
      
        z  =  WHERE(uniq_grid_vals  EQ  NVIS_grid_val)
        FC_field_obs[i].NVIS_class       =  NVIS_grid_val
        FC_field_obs[i].NVIS_group_name  =  NVIS_reg_names[z]
      ENDIF; ELSE STOP, 'NVIS grid classification: Domain ERROR...'
    ENDIF

    IF(OBJ_VALID(DrDiv_grid)  EQ  TRUE)  THEN  BEGIN
      DD_grid_val  =  DrDiv_grid->return_grid_value(lon_arr=FC_field_obs[i].longitude,      $
                                                    lat_arr=FC_field_obs[i].latitude,       $
                                                    domain_error=domain_error,              $
                                                    uniq_grid_vals=uniq_grid_vals)
      IF(domain_error[0]  EQ  FALSE)  THEN  BEGIN
      
        z  =  WHERE(uniq_grid_vals  EQ  DD_grid_val)
        FC_field_obs[i].drain_div_class   =  DD_grid_val
        FC_field_obs[i].drain_div_name    =  Aus_DD_reg_names[z]
      ENDIF; ELSE STOP, 'DrDiv grid classification: Domain ERROR...'
    ENDIF
    
    ;Now allocate the memory for the model data if N_MODELS > 0
    ;IF(FC_field_obs[i].MODEL_STATUS  EQ  TRUE)  THEN  BEGIN
    
    ;  FOR j=0, FC_field_obs[i].N_MODELS -1 DO FC_field_obs[i].model_data[j]  =  PTR_NEW(model_data_str)
    ;ENDIF

  ENDFOR
   
  ;Now perform some filtering
  ;First we want to only include data where the CHK_SUM (see data structure) is no more than 0.02 (absolute difference)
  ; from the ideal CHK_SUM value of 1.0 (all fractions sum to 1.0)
  DIFF_THRSHOLD  =  0.02
  tmp_arr  =  FC_field_obs.CHK_SUM  -  1.0
  tmp_ind  =  WHERE(ABS(tmp_arr)  LE  DIFF_THRSHOLD)
  
  ;Remove all occurrences where the CHK_SUM is more than 0.02 (abs difference) from 1.0
  ; commented line below, I don't want to filter data by check sum -  JPG 
  ;IF(tmp_ind[0]  NE  ERROR)  THEN  FC_field_obs  =  FC_field_obs[tmp_ind]
  
   
  ;Now generate some diagnostic output
  ; Generate some frequency histograms of the PV, NPV and BS fractions
  ; Generate some maps of the PV, NPV and BS fractions
  
  IF(KEYWORD_SET(PLOT_DIAGNOATICS)  EQ  TRUE)  THEN  BEGIN
  
    PV_data  =  OBJ_NEW('AC_DATA_MOD_COMP')
    z  =  PV_data->get_data_DIRECT(data_arr=FC_field_obs.total_PV_FC, lat_arr=FC_field_obs.latitude,             $
                                   lon_arr=FC_field_obs.longitude, name='Field Data: PV frac')
    NPV_data  =  OBJ_NEW('AC_DATA_MOD_COMP')
    z  =  NPV_data->get_data_DIRECT(data_arr=FC_field_obs.total_NPV_FC, lat_arr=FC_field_obs.latitude,           $
                                   lon_arr=FC_field_obs.longitude, name='Field Data: NPV frac')
    BS_data  =  OBJ_NEW('AC_DATA_MOD_COMP')
    z  =  BS_data->get_data_DIRECT(data_arr=FC_field_obs.total_BS_FC, lat_arr=FC_field_obs.latitude,             $
                                   lon_arr=FC_field_obs.longitude, name='Field Data: BS frac')
  
    bin_arr    =  FINDGEN(20)
    bin_arr    =  bin_arr/FLOAT(N_ELEMENTS(bin_arr))
    plot_FN  =  output_direc  +  'FC_fld_PC_histogram.ps'
    z  =  PV_data->freq_histogram(bin_arr=bin_arr, plot_FN=plot_FN, y_range=[0, 0.3], /KEEP_DEVICE_OPEN, /NO_LABELS)
    z  =  NPV_data->freq_histogram(bin_arr=bin_arr, plot_FN=plot_FN, y_range=[0, 0.3], /DEVICE_OPEN, /NO_LABELS)
    z  =  BS_data->freq_histogram(bin_arr=bin_arr, plot_FN=plot_FN, y_range=[0, 0.3], /DEVICE_OPEN, /NO_LABELS)
    DEVICE, /CLOSE
    
    ;Now destroy the data objects:
    PV_data->free_all_ptrs
    OBJ_DESTROY, PV_data
    NPV_data->free_all_ptrs
    OBJ_DESTROY, NPV_data
    BS_data->free_all_ptrs
    OBJ_DESTROY, BS_data
    
    ;Now we want to create some maps of the field data
    ;To do this, we need to create a different set of objects :)
    PV_data   =  OBJ_NEW('MAP_2D')
    NPV_data  =  OBJ_NEW('MAP_2D')
    BS_data   =  OBJ_NEW('MAP_2D')
    
    MAP_FN_all  =  output_direc  +  'FC_fld_data_map.ps'
    z  =  PV_data->get_input_data(lat_arr=FC_field_obs.latitude, long_arr=FC_field_obs.longitude,                        $
                                  z_arr=FC_field_obs.total_PV_FC)
    z  =  PV_data->set_map_param(subtitle='PV Fractional Cover', title='SLATS field data', /OUTPUT_PS, z_title='PV_FracCov',   $
                                 colour_table=13)
    z  =  PV_data->set_continents_param(/CONTINENTS)
    ;MAP_FN  =  output_direc  +  'FC_fld_PV_map.ps'
    PV_data->map_data, map_FN=MAP_FN_all, /DEFINE_MAP_EXTENT, /KEEP_DEVICE_OPEN
    
    z  =  NPV_data->get_input_data(lat_arr=FC_field_obs.latitude, long_arr=FC_field_obs.longitude,                       $
                                  z_arr=FC_field_obs.total_NPV_FC)
    z  =  NPV_data->set_map_param(subtitle='NPV Fractional Cover', title='SLATS field data', /OUTPUT_PS, z_title='NPV_FracCov',  $
                                  colour_table=13)
    z  =  NPV_data->set_continents_param(/CONTINENTS)
    ;MAP_FN  =  output_direc  +  'FC_fld_NPV_map.ps'
    MULTIPANEL, /ADVANCE
    NPV_data->map_data, map_FN=map_FN, /DEFINE_MAP_EXTENT, /DEVICE_OPEN
  
  
    z  =  BS_data->get_input_data(lat_arr=FC_field_obs.latitude, long_arr=FC_field_obs.longitude,                        $
                                  z_arr=FC_field_obs.total_BS_FC)
    z  =  BS_data->set_map_param(subtitle='BS Fractional Cover', title='SLATS field data', /OUTPUT_PS, z_title='BS_FracCov',   $
                                 colour_table=13)
    z  =  BS_data->set_continents_param(/CONTINENTS)
    ;MAP_FN  =  output_direc  +  'FC_fld_BS_map.ps'
    MULTIPANEL, /ADVANCE
    BS_data->map_data, map_FN=map_FN, /DEFINE_MAP_EXTENT, /DEVICE_OPEN
    DEVICE, /CLOSE
    
    ;Now distroy the data objects as they are no longer required
    PV_data->free_all_ptrs
    OBJ_DESTROY, PV_data
    NPV_data->free_all_ptrs
    OBJ_DESTROY, NPV_data
    BS_data->free_all_ptrs
    OBJ_DESTROY, BS_data
  ENDIF
  
  IF(OBJ_VALID(NVIS_grid)  EQ  TRUE)  THEN  BEGIN
    NVIS_grid->free_ptr_memory
    OBJ_DESTROY, NVIS_grid
  ENDIF
  IF(OBJ_VALID(DrDiv_grid)  EQ  TRUE)  THEN  BEGIN
    DrDiv_grid->free_ptr_memory
    OBJ_DESTROY, DrDiv_grid
  ENDIF
  
  ;Convert all original data to fractions instead of percentage values
  N_ORIG_TAGS  =  N_TAGS(FC_field_obs[0].orig_data)
  FOR i=0, N_ORIG_TAGS -1 DO BEGIN
    FC_field_obs.orig_data.(i)  =  FC_field_obs.orig_data.(i)*PC_CONV
  ENDFOR
  
  ;Finally, calculate some dates for the observations and make sure they are all in chronological order!
  FC_field_obs.juldate    =  JULDAY(FC_field_obs.mth, FC_field_obs.day, FC_field_obs.year)
;  FC_field_obs.dcml_date  =  decimal_date(FC_field_obs.year, FC_field_obs.mth, FC_field_obs.day,      $
;                                          FC_field_obs.hr, FC_field_obs.mn)

  FC_field_obs.DOY        =  ymd2dn(FC_field_obs.year, FC_field_obs.mth, FC_field_obs.day)
  
  ; commented these two lines below, I don't want data sorted by date - JPG 
;  sort_ind      =  SORT(FC_field_obs.juldate)
;  FC_field_obs  =  FC_field_obs[sort_ind]
  
  help, FC_field_obs, /str
  RETURN, FC_field_obs
END