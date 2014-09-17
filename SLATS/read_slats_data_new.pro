function read_SLATS_data_new
  compile_opt idl2

  t=SysTime(1)
  
  ; LOAD DATA 
;  fname = '\\wron\working\work\Juan_Pablo\PV_NPV_BS\New_Validation\field_data\merged\fractional_all.csv'
  fname = '\\wron\working\work\Juan_Pablo\PV_NPV_BS\New_Validation\field_data\merged\fractional_all_jpgFixed.csv'
  FIELD_ALL = READ_ASCII_FILE(fname, /SURPRESS_MSG)
  n=n_elements(FIELD_ALL)
  JULDAY_Field_ALL = JULDAY(FIELD_ALL.month, FIELD_ALL.day, FIELD_ALL.year)

;  ; LOAD DATA 
;  fname = 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\fractional_landsat_subsets\out_b3_3pixSorted.csv'
;  fname = 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\fractional_landsat_subsets\outSorted_20130502.csv'
  ;fname = 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\fractional_landsat_subsets\outSorted20130627.csv'
  fname = 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\fractional_landsat_subsets\outSorted_20130729.csv'
  LANDSAT_Qld = READ_ASCII_FILE(fname, /SURPRESS_MSG)
  
;  fname = 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\fractional_landsat_subsets\pngs_spectra\out_b3_3pixSorted_scaling.csv'
  fname = 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\fractional_landsat_subsets\atmosph_corrected\outSorted20130627_scaling.csv'
  LANDSAT_Scaling = READ_ASCII_FILE(fname, /SURPRESS_MSG)
  
  fname = 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\GC_MCD43A4_Landsat_2013_04_29.csv'
  MCD43A4 = READ_ASCII_FILE(fname, /SURPRESS_MSG)

  fname = 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\GC_MOD09A1_Landsat_2013_04_29.csv'
  MOD09A1 = READ_ASCII_FILE(fname, /SURPRESS_MSG)

  fname = 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\GC_MCD43A3_Landsat_2014_08_18.csv'
  MCD43A3 = READ_ASCII_FILE(fname, /SURPRESS_MSG)

  FNAME = 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\GC_BAWAP_rain_MAY2013.csv'
;  Rain = READ_ASCII_FILE(fname, /SURPRESS_MSG)

  FNAME = 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\GC_AWRA_Wsat_JUN2013.csv'
  Wsat = READ_ASCII_FILE(fname, /SURPRESS_MSG)
  
  FNAME = 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\GC_ASCAT_JUN2013.csv'
  ASCAT = READ_ASCII_FILE(fname, /SURPRESS_MSG)
  
  ;FNAME = 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\GC_soil_colour_May2013.csv'
  FNAME = 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\GC_soil_colour_Aug2013.csv'  
  SoilColor = READ_ASCII_FILE(fname, /SURPRESS_MSG)

  fname = 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\GC_DLCDv1_Jul2013.csv'
  DLCDv1 = READ_ASCII_FILE(fname, /SURPRESS_MSG)


;  output_folder = 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\plots\'
;  n = n_elements(LANDSAT_Qld.Obs_key)
;  cd, output_folder
  
  ;Some Defaults for saving: 
;  cgwindow_setdefs, IM_Resize=100
  
   ;-------------------------------------------------------------------------- 
   ; fix Landsat_scaling (order is wrong, need to put it back)
   obs_key = strarr(n)
   obs_time = strarr(n)
   site = strarr(n)
   image_name = strarr(n)
   sam_40x40 = fltarr(n) & sam_40x40[*]=!VALUES.F_NAN   
   ED_9x9 = fltarr(n) & ED_9x9[*]=!VALUES.F_NAN   
   ED_17x17 = fltarr(n) & ED_17x17[*]=!VALUES.F_NAN   
   ED_25x25 = fltarr(n) & ED_25x25[*]=!VALUES.F_NAN   
   ED_33x33 = fltarr(n) & ED_33x33[*]=!VALUES.F_NAN   
   ED_40x40 = fltarr(n) & ED_40x40[*]=!VALUES.F_NAN   
   ED_42x42 = fltarr(n) & ED_42x42[*]=!VALUES.F_NAN   
   timelag = fltarr(n) & timelag[*]=!VALUES.F_NAN   
   b1_3x3 = fltarr(n) & b1_3x3[*]=!VALUES.F_NAN   
   b2_3x3 = fltarr(n) & b2_3x3[*]=!VALUES.F_NAN   
   b3_3x3 = fltarr(n) & b3_3x3[*]=!VALUES.F_NAN   
   b4_3x3 = fltarr(n) & b4_3x3[*]=!VALUES.F_NAN   
   b5_3x3 = fltarr(n) & b5_3x3[*]=!VALUES.F_NAN   
   b6_3x3 = fltarr(n) & b6_3x3[*]=!VALUES.F_NAN   
   b1_9x9 = fltarr(n) & b1_9x9[*]=!VALUES.F_NAN   
   b2_9x9 = fltarr(n) & b2_9x9[*]=!VALUES.F_NAN   
   b3_9x9 = fltarr(n) & b3_9x9[*]=!VALUES.F_NAN   
   b4_9x9 = fltarr(n) & b4_9x9[*]=!VALUES.F_NAN   
   b5_9x9 = fltarr(n) & b5_9x9[*]=!VALUES.F_NAN   
   b6_9x9 = fltarr(n) & b6_9x9[*]=!VALUES.F_NAN   
   b1_17x17 = fltarr(n) & b1_17x17[*]=!VALUES.F_NAN   
   b2_17x17 = fltarr(n) & b2_17x17[*]=!VALUES.F_NAN   
   b3_17x17 = fltarr(n) & b3_17x17[*]=!VALUES.F_NAN   
   b4_17x17 = fltarr(n) & b4_17x17[*]=!VALUES.F_NAN   
   b5_17x17 = fltarr(n) & b5_17x17[*]=!VALUES.F_NAN   
   b6_17x17 = fltarr(n) & b6_17x17[*]=!VALUES.F_NAN   
   b1_25x25 = fltarr(n) & b1_25x25[*]=!VALUES.F_NAN   
   b2_25x25 = fltarr(n) & b2_25x25[*]=!VALUES.F_NAN   
   b3_25x25 = fltarr(n) & b3_25x25[*]=!VALUES.F_NAN   
   b4_25x25 = fltarr(n) & b4_25x25[*]=!VALUES.F_NAN   
   b5_25x25 = fltarr(n) & b5_25x25[*]=!VALUES.F_NAN   
   b6_25x25 = fltarr(n) & b6_25x25[*]=!VALUES.F_NAN   
   b1_33x33 = fltarr(n) & b1_33x33[*]=!VALUES.F_NAN   
   b2_33x33 = fltarr(n) & b2_33x33[*]=!VALUES.F_NAN   
   b3_33x33 = fltarr(n) & b3_33x33[*]=!VALUES.F_NAN   
   b4_33x33 = fltarr(n) & b4_33x33[*]=!VALUES.F_NAN   
   b5_33x33 = fltarr(n) & b5_33x33[*]=!VALUES.F_NAN   
   b6_33x33 = fltarr(n) & b6_33x33[*]=!VALUES.F_NAN   
   b1_40x40 = fltarr(n) & b1_40x40[*]=!VALUES.F_NAN   
   b2_40x40 = fltarr(n) & b2_40x40[*]=!VALUES.F_NAN   
   b3_40x40 = fltarr(n) & b3_40x40[*]=!VALUES.F_NAN   
   b4_40x40 = fltarr(n) & b4_40x40[*]=!VALUES.F_NAN   
   b5_40x40 = fltarr(n) & b5_40x40[*]=!VALUES.F_NAN   
   b6_40x40 = fltarr(n) & b6_40x40[*]=!VALUES.F_NAN   
   b1_42x42 = fltarr(n) & b1_42x42[*]=!VALUES.F_NAN   
   b2_42x42 = fltarr(n) & b2_42x42[*]=!VALUES.F_NAN   
   b3_42x42 = fltarr(n) & b3_42x42[*]=!VALUES.F_NAN   
   b4_42x42 = fltarr(n) & b4_42x42[*]=!VALUES.F_NAN   
   b5_42x42 = fltarr(n) & b5_42x42[*]=!VALUES.F_NAN   
   b6_42x42 = fltarr(n) & b6_42x42[*]=!VALUES.F_NAN   
   
   ; fix obs_key to get rid of the last part which was creating problems
   old_obs_key = Landsat_scaling.obs_key 
   new_obs_key = old_obs_key
   Result = STRSPLIT(old_obs_key, '_' , /EXTRACT)
   for i=0, n_elements(new_obs_key)-1 do $
      new_obs_key[i] = (Result[i])[0]+'_'+(Result[i])[1]+'_'+(Result[i])[2]

   for i=0, n-1 do begin
    where_obs = Where(new_obs_key eq (FIELD_ALL.obs_key)[i], count)
    if count gt 1 then where_obs=where_obs[0] ;special case for repeated measurements (pre 2000)
    if count ge 1 then begin
      obs_key[i] = (new_obs_key)[where_obs]
      obs_time[i] = (Landsat_scaling.obs_time)[where_obs]
      site[i] = (Landsat_scaling.site)[where_obs]
      image_name[i] = (Landsat_scaling.image_name)[where_obs]
      sam_40x40[i] = (Landsat_scaling.sam_40x40)[where_obs]
      ED_9x9[i] = (Landsat_scaling.ED_9x9)[where_obs]
      ED_17x17[i] = (Landsat_scaling.ED_17x17)[where_obs]
      ED_25x25[i] = (Landsat_scaling.ED_25x25)[where_obs]
      ED_33x33[i] = (Landsat_scaling.ED_33x33)[where_obs]
      ED_40x40[i] = (Landsat_scaling.ED_40x40)[where_obs]
      ED_42x42[i] = (Landsat_scaling.ED_42x42)[where_obs]
      timelag[i] = (Landsat_scaling.timelag)[where_obs]
      b1_3x3[i] = (Landsat_scaling.b1_3x3)[where_obs]
      b2_3x3[i] = (Landsat_scaling.b2_3x3)[where_obs]
      b3_3x3[i] = (Landsat_scaling.b3_3x3)[where_obs]
      b4_3x3[i] = (Landsat_scaling.b4_3x3)[where_obs]
      b5_3x3[i] = (Landsat_scaling.b5_3x3)[where_obs]
      b6_3x3[i] = (Landsat_scaling.b6_3x3)[where_obs]
      b1_9x9[i] = (Landsat_scaling.b1_9x9)[where_obs]
      b2_9x9[i] = (Landsat_scaling.b2_9x9)[where_obs]
      b3_9x9[i] = (Landsat_scaling.b3_9x9)[where_obs]
      b4_9x9[i] = (Landsat_scaling.b4_9x9)[where_obs]
      b5_9x9[i] = (Landsat_scaling.b5_9x9)[where_obs]
      b6_9x9[i] = (Landsat_scaling.b6_9x9)[where_obs]
      b1_17x17[i] = (Landsat_scaling.b1_17x17)[where_obs]
      b2_17x17[i] = (Landsat_scaling.b2_17x17)[where_obs]
      b3_17x17[i] = (Landsat_scaling.b3_17x17)[where_obs]
      b4_17x17[i] = (Landsat_scaling.b4_17x17)[where_obs]
      b5_17x17[i] = (Landsat_scaling.b5_17x17)[where_obs]
      b6_17x17[i] = (Landsat_scaling.b6_17x17)[where_obs]
      b1_25x25[i] = (Landsat_scaling.b1_25x25)[where_obs]
      b2_25x25[i] = (Landsat_scaling.b2_25x25)[where_obs]
      b3_25x25[i] = (Landsat_scaling.b3_25x25)[where_obs]
      b4_25x25[i] = (Landsat_scaling.b4_25x25)[where_obs]
      b5_25x25[i] = (Landsat_scaling.b5_25x25)[where_obs]
      b6_25x25[i] = (Landsat_scaling.b6_25x25)[where_obs]
      b1_33x33[i] = (Landsat_scaling.b1_33x33)[where_obs]
      b2_33x33[i] = (Landsat_scaling.b2_33x33)[where_obs]
      b3_33x33[i] = (Landsat_scaling.b3_33x33)[where_obs]
      b4_33x33[i] = (Landsat_scaling.b4_33x33)[where_obs]
      b5_33x33[i] = (Landsat_scaling.b5_33x33)[where_obs]
      b6_33x33[i] = (Landsat_scaling.b6_33x33)[where_obs]
      b1_40x40[i] = (Landsat_scaling.b1_40x40)[where_obs]
      b2_40x40[i] = (Landsat_scaling.b2_40x40)[where_obs]
      b3_40x40[i] = (Landsat_scaling.b3_40x40)[where_obs]
      b4_40x40[i] = (Landsat_scaling.b4_40x40)[where_obs]
      b5_40x40[i] = (Landsat_scaling.b5_40x40)[where_obs]
      b6_40x40[i] = (Landsat_scaling.b6_40x40)[where_obs]
      b1_42x42[i] = (Landsat_scaling.b1_42x42)[where_obs]
      b2_42x42[i] = (Landsat_scaling.b2_42x42)[where_obs]
      b3_42x42[i] = (Landsat_scaling.b3_42x42)[where_obs]
      b4_42x42[i] = (Landsat_scaling.b4_42x42)[where_obs]
      b5_42x42[i] = (Landsat_scaling.b5_42x42)[where_obs]
      b6_42x42[i] = (Landsat_scaling.b6_42x42)[where_obs]
    endif
;    if count gt 1 then stop
   endfor  
   
   ; put back in a structure
   Landsat_scaling = CREATE_STRUCT(  $
                'obs_key', obs_key, $
                'obs_time', obs_time, $
                'site', site, $
                'image_name', image_name, $
                'sam_40x40', sam_40x40, $
                'timelag', timelag, $
                'ED_9x9', ED_9x9, $
                'ED_17x17', ED_17x17, $
                'ED_25x25', ED_25x25, $
                'ED_33x33', ED_33x33, $
                'ED_40x40', ED_40x40, $
                'ED_42x42', ED_42x42, $
                'b1_3x3', b1_3x3, $
                'b2_3x3', b2_3x3, $
                'b3_3x3', b3_3x3, $
                'b4_3x3', b4_3x3, $
                'b5_3x3', b5_3x3, $
                'b6_3x3', b6_3x3, $
                'b1_9x9', b1_9x9, $
                'b2_9x9', b2_9x9, $
                'b3_9x9', b3_9x9, $
                'b4_9x9', b4_9x9, $
                'b5_9x9', b5_9x9, $
                'b6_9x9', b6_9x9, $
                'b1_17x17', b1_17x17, $
                'b2_17x17', b2_17x17, $
                'b3_17x17', b3_17x17, $
                'b4_17x17', b4_17x17, $
                'b5_17x17', b5_17x17, $
                'b6_17x17', b6_17x17, $
                'b1_25x25', b1_25x25, $
                'b2_25x25', b2_25x25, $
                'b3_25x25', b3_25x25, $
                'b4_25x25', b4_25x25, $
                'b5_25x25', b5_25x25, $
                'b6_25x25', b6_25x25, $
                'b1_33x33', b1_33x33, $
                'b2_33x33', b2_33x33, $
                'b3_33x33', b3_33x33, $
                'b4_33x33', b4_33x33, $
                'b5_33x33', b5_33x33, $
                'b6_33x33', b6_33x33, $
                'b1_40x40', b1_40x40, $
                'b2_40x40', b2_40x40, $
                'b3_40x40', b3_40x40, $
                'b4_40x40', b4_40x40, $
                'b5_40x40', b5_40x40, $
                'b6_40x40', b6_40x40, $
                'b1_42x42', b1_42x42, $
                'b2_42x42', b2_42x42, $
                'b3_42x42', b3_42x42, $
                'b4_42x42', b4_42x42, $
                'b5_42x42', b5_42x42, $
                'b6_42x42', b6_42x42, $
                'DUMMY', 1 $
                 )      
   ;-------------------------------------------------------------------------- 
 
   ;-------------------------------------------------------------------------- 
   ; fix Landsat_QLD (order is wrong, need to put it back)
   ;Landsat_Qld Dates
   n_Landsat_QLD = n_elements(Landsat_QLD.OBS_TIME)
   DATE_OBS = intarr(n_Landsat_QLD, 3)
   for i=0, n_Landsat_QLD-1 do $
      DATE_OBS[i,*] = STRSPLIT((Landsat_QLD.obs_time)[i], '-', /Extract) * 1 ; this is the date of the observation 
    JULDATE_Landsat_QLD = JULDAY(DATE_OBS[*,1], DATE_OBS[*,2], DATE_OBS[*,0])
   
     obs_key = strarr(n)
     obs_time = strarr(n)
     site = strarr(n)
     image = strarr(n)
     timelag = fltarr(n) & timelag[*]=!VALUES.F_NAN   
    crust = fltarr(n) &   crust [*]=!VALUES.F_NAN   
    dist  = fltarr(n) &   dist  [*]=!VALUES.F_NAN   
    rock  = fltarr(n) &   rock  [*]=!VALUES.F_NAN   
    green = fltarr(n) &   green [*]=!VALUES.F_NAN   
    crypto  = fltarr(n) &   crypto  [*]=!VALUES.F_NAN   
    dead  = fltarr(n) &   dead  [*]=!VALUES.F_NAN   
    litter  = fltarr(n) &   litter  [*]=!VALUES.F_NAN   
    mid_g = fltarr(n) &   mid_g [*]=!VALUES.F_NAN   
    mid_d = fltarr(n) &   mid_d [*]=!VALUES.F_NAN   
    mid_b = fltarr(n) &   mid_b [*]=!VALUES.F_NAN   
    crn = fltarr(n) &   crn [*]=!VALUES.F_NAN   
    over_g  = fltarr(n) &   over_g  [*]=!VALUES.F_NAN   
    over_d  = fltarr(n) &   over_d  [*]=!VALUES.F_NAN   
    over_b  = fltarr(n) &   over_b  [*]=!VALUES.F_NAN   
    persist_gr  = fltarr(n) &   persist_gr  [*]=!VALUES.F_NAN   
    num_points  = fltarr(n) &   num_points  [*]=!VALUES.F_NAN   
    image = strarr(n)   
    timelag = fltarr(n) &   timelag [*]=!VALUES.F_NAN   
    band1_01 = fltarr(n) &   band1_01 [*]=!VALUES.F_NAN   
    band2_01 = fltarr(n) &   band2_01 [*]=!VALUES.F_NAN   
    band3_01 = fltarr(n) &   band3_01 [*]=!VALUES.F_NAN   
    band4_01 = fltarr(n) &   band4_01 [*]=!VALUES.F_NAN   
    band5_01 = fltarr(n) &   band5_01 [*]=!VALUES.F_NAN   
    band6_01 = fltarr(n) &   band6_01 [*]=!VALUES.F_NAN   

   ; fix obs_key to get rid of the last part which was creating problems
;   old_obs_key = Landsat_QLD.obs_key 
;   new_obs_key = old_obs_key
;   Result = STRSPLIT(old_obs_key, '_' , /EXTRACT)
;   for i=0, n_elements(new_obs_key)-1 do $
;      new_obs_key[i] = (Result[i])[0]+'_'+(Result[i])[1]+'_'+(Result[i])[2]
 
   for i=0, n-1 do begin
    where_obs = Where(JULDATE_Landsat_QLD eq (JULDAY_Field_ALL)[i] AND $
                      Landsat_QLD.site eq (FIELD_ALL.SITE)[i], count)
 
    ;if count eq 0 then print, (FIELD_ALL.SITE)[i]
    ;if count gt 1 then print, 'count = ',count,(FIELD_ALL.SITE)[i]
    if count gt 1 then where_obs=where_obs[0] ;special case for repeated measurements (pre 2000)
    if count ge 1 then begin
      obs_key[i] = (new_obs_key)[where_obs]
      obs_time[i] = (Landsat_QLD.obs_time)[where_obs]
      site[i] = (Landsat_QLD.site)[where_obs]
      image[i] = (Landsat_QLD.image)[where_obs]
      crust[i]=(Landsat_Qld.crust)[where_obs]
      dist[i]=(Landsat_Qld.dist)[where_obs]
      rock[i]=(Landsat_Qld.rock)[where_obs]
      green[i]=(Landsat_Qld.green)[where_obs]
      crypto[i]=(Landsat_Qld.crypto)[where_obs]
      dead[i]=(Landsat_Qld.dead)[where_obs]
      litter[i]=(Landsat_Qld.litter)[where_obs]
      mid_g[i]=(Landsat_Qld.mid_g)[where_obs]
      mid_d[i]=(Landsat_Qld.mid_d)[where_obs]
      mid_b[i]=(Landsat_Qld.mid_b)[where_obs]
      crn[i]=(Landsat_Qld.crn)[where_obs]
      over_g[i]=(Landsat_Qld.over_g)[where_obs]
      over_d[i]=(Landsat_Qld.over_d)[where_obs]
      over_b[i]=(Landsat_Qld.over_b)[where_obs]
      persist_gr[i]=(Landsat_Qld.persist_gr)[where_obs]
      num_points[i]=(Landsat_Qld.num_points)[where_obs]
      image[i]=(Landsat_Qld.image)[where_obs]
      timelag[i]=(Landsat_Qld.timelag)[where_obs]
      band1_01[i]=(Landsat_Qld.band1_01)[where_obs]
      band2_01[i]=(Landsat_Qld.band2_01)[where_obs]
      band3_01[i]=(Landsat_Qld.band3_01)[where_obs]
      band4_01[i]=(Landsat_Qld.band4_01)[where_obs]
      band5_01[i]=(Landsat_Qld.band5_01)[where_obs]
      band6_01[i]=(Landsat_Qld.band6_01)[where_obs]
    endif
     ;if count gt 1 then stop
   endfor  
   
   ; fix NaNs in bands (a couple with 32767)
;   w=where(b1 gt 1, count) & if count ge 1 then b1[w]=!VALUES.F_NAN 
;   w=where(b2 gt 1, count) & if count ge 1 then b2[w]=!VALUES.F_NAN 
;   w=where(b3 gt 1, count) & if count ge 1 then b3[w]=!VALUES.F_NAN 
;   w=where(b4 gt 1, count) & if count ge 1 then b4[w]=!VALUES.F_NAN 
;   w=where(b5 gt 1, count) & if count ge 1 then b5[w]=!VALUES.F_NAN 
;   w=where(b6 gt 1, count) & if count ge 1 then b6[w]=!VALUES.F_NAN 
   
   ; put back in a structure
   Landsat_QLD = CREATE_STRUCT(  $
                    'obs_key',obs_key,$
                    'obs_time',obs_time,$
                    'site',site,$
                    'crust',crust,$
                    'dist',dist,$
                    'rock',rock,$
                    'green',green,$
                    'crypto',crypto,$
                    'dead',dead,$
                    'litter',litter,$
                    'mid_g',mid_g,$
                    'mid_d',mid_d,$
                    'mid_b',mid_b,$
                    'crn',crn,$
                    'over_g',over_g,$
                    'over_d',over_d,$
                    'over_b',over_b,$
                    'persist_gr',persist_gr,$
                    'num_points',num_points,$
                    'image',image,$
                    'timelag',timelag,$
                    'band1_01',band1_01,$
                    'band2_01',band2_01,$
                    'band3_01',band3_01,$
                    'band4_01',band4_01,$
                    'band5_01',band5_01,$
                    'band6_01',band6_01 $
                 )      
   ;-------------------------------------------------------------------------- 
 
  
   ;-------------------------------------------------------------------------- 
   ; calculate "exposed" fractions (and convert to proportions)
   ; Warning!!  now doing all this based on the Landsat_Qld data 
    Exp_Over_PV = Landsat_Qld.over_g * 0.01
    Exp_Over_NPV = (Landsat_Qld.over_d + Landsat_Qld.over_b) * 0.01
    Exp_Over_Tot = Exp_Over_PV + Exp_Over_NPV
    Non_Exp_Over_Tot = (Landsat_Qld.over_g + Landsat_Qld.over_d + Landsat_Qld.over_b) * 0.01
   
    Exp_Mid_PV  =  Landsat_Qld.mid_g * 0.01 * (1.0 - Exp_Over_Tot)
    Exp_Mid_NPV = (Landsat_Qld.mid_d + Landsat_Qld.mid_b) * 0.01 * (1.0 - Exp_Over_Tot)
    Exp_Mid_Tot =  Exp_Mid_PV + Exp_Mid_NPV
    Non_Exp_Mid_Tot = (Landsat_Qld.mid_g + Landsat_Qld.mid_d + Landsat_Qld.mid_b) * 0.01
  
    Exp_Und_PV  =  (Landsat_Qld.green + Landsat_Qld.crypto) * 0.01 * (1.0 - Exp_Mid_Tot) * (1.0 - Exp_Over_Tot)
    Exp_Und_NPV = (Landsat_Qld.dead + Landsat_Qld.litter) * 0.01 * (1.0 - Exp_Mid_Tot) * (1.0 - Exp_Over_Tot)
    Exp_Und_BS = (Landsat_Qld.crust + Landsat_Qld.dist + Landsat_Qld.rock) * 0.01 * (1.0 - Exp_Mid_Tot) * (1.0 - Exp_Over_Tot)
    Exp_Und_Tot =  Exp_Und_PV + Exp_Und_NPV + Exp_Und_BS
    Non_Exp_Und_Tot = (Landsat_Qld.green + Landsat_Qld.crypto + Landsat_Qld.dead + Landsat_Qld.litter + Landsat_Qld.crust + Landsat_Qld.dist + Landsat_Qld.rock) * 0.01
    
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
    
    nTotal=Landsat_Qld.num_points

    nCanopyGreen=Landsat_Qld.over_g*nTotal/100
    nCanopyDead=Landsat_Qld.over_d*nTotal/100
    nCanopyBranch=Landsat_Qld.over_b*nTotal/100
    
    nMidGreen=Landsat_Qld.mid_g*nTotal/100
    nMidDead=Landsat_Qld.mid_d*nTotal/100
    nMidBranch=Landsat_Qld.mid_b*nTotal/100
    
    nGroundCrustDistRock=(Landsat_Qld.crust+Landsat_Qld.dist+Landsat_Qld.rock)*nTotal/100
    nGroundGreen=Landsat_Qld.green*nTotal/100
    nGroundDeadLitter=(Landsat_Qld.dead+Landsat_Qld.litter)*nTotal/100
    nGroundCrypto=Landsat_Qld.crypto*nTotal/100
    
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
                'canopyFoliageProjectiveCover', canopyFoliageProjectiveCover, $
                'DUMMY', 1 $
               )   
   ;-------------------------------------------------------------------------- 
   
;   ;-------------------------------------------------------------------------- 
;   ; convert all -999 in ASCAT to NaNs and create multi-day averages
    ASCAT0 = ASCAT.ASCATMinus0
    ASCAT1 = ASCAT.ASCATMinus1
    ASCAT2 = ASCAT.ASCATMinus2
    ASCAT3 = ASCAT.ASCATMinus3
    ASCAT4 = ASCAT.ASCATMinus4
    ASCAT5 = ASCAT.ASCATMinus5
    ASCAT6 = ASCAT.ASCATMinus6
    
    ASCAT0[where(ASCAT0 eq -999)]=!Values.F_nan
    ASCAT1[where(ASCAT1 eq -999)]=!Values.F_nan
    ASCAT2[where(ASCAT2 eq -999)]=!Values.F_nan
    ASCAT3[where(ASCAT3 eq -999)]=!Values.F_nan
    ASCAT4[where(ASCAT4 eq -999)]=!Values.F_nan
    ASCAT5[where(ASCAT5 eq -999)]=!Values.F_nan
    ASCAT6[where(ASCAT6 eq -999)]=!Values.F_nan
    
    ASCAT01 = MEAN([[ASCAT0],[ASCAT1]], DIMENSION=2, /NAN)
    ASCAT012 = MEAN([[ASCAT0],[ASCAT1],[ASCAT2]], DIMENSION=2, /NAN)
    ASCAT0123 = MEAN([[ASCAT0],[ASCAT1],[ASCAT2],[ASCAT3]], DIMENSION=2, /NAN)
    ASCAT01234 = MEAN([[ASCAT0],[ASCAT1],[ASCAT2],[ASCAT3],[ASCAT4]], DIMENSION=2, /NAN)
    ASCAT012345 = MEAN([[ASCAT0],[ASCAT1],[ASCAT2],[ASCAT3],[ASCAT4],[ASCAT5]], DIMENSION=2, /NAN)
    ASCAT0123456 = MEAN([[ASCAT0],[ASCAT1],[ASCAT2],[ASCAT3],[ASCAT4],[ASCAT5],[ASCAT6]], DIMENSION=2, /NAN)

       ASCAT = CREATE_STRUCT(  $
            'ASCAT0',      ASCAT0,         $
            'ASCAT1',      ASCAT1,         $
            'ASCAT2',      ASCAT2,         $
            'ASCAT3',      ASCAT3,         $
            'ASCAT4',      ASCAT4,         $
            'ASCAT5',      ASCAT5,         $
            'ASCAT6',      ASCAT6,         $
            'ASCAT01',      ASCAT01,         $
            'ASCAT012',      ASCAT012,         $
            'ASCAT0123',      ASCAT0123,         $
            'ASCAT01234',      ASCAT01234,         $
            'ASCAT012345',      ASCAT012345,         $
            'ASCAT0123456',      ASCAT0123456,         $
            'dummy',            1                    $   
            )
    
;   ;-------------------------------------------------------------------------- 
   
               
   ;-------------------------------------------------------------------------- 
   ;Calculate julian days
;   n = n_elements(Exp_Over_PV)
;   day = intarr(n)
;   month = intarr(n)
;   year = intarr(n)
;   for i=0, n-1 do day[i]= (strsplit((FIELD_ALL.obs_time)[i], '/', /EXTRACT))[0]
;   for i=0, n-1 do month[i]= (strsplit((FIELD_ALL.obs_time)[i], '/', /EXTRACT))[1]
;   for i=0, n-1 do year[i]= (strsplit((FIELD_ALL.obs_time)[i], '/', /EXTRACT))[2]
;   Jul_Day = JULDAY(Month, Day, Year)
   
   ; put all in structure and return
   output = CREATE_STRUCT(  $
            'FIELD_ALL',      FIELD_ALL,         $
            'LANDSAT_Scaling',  LANDSAT_Scaling,     $
            'LANDSAT_QLD',      LANDSAT_QLD,         $
            'MCD43A4',          MCD43A4,             $
            'MOD09A1',          MOD09A1,             $
            'MCD43A3',          MCD43A3,             $
;            'Rain',             Rain,                $
            'Wsat',             Wsat,                $
            'ASCAT',            ASCAT,               $
            'Fcover',           Fcover,              $
            'Fcover_QLD',       Fcover_QLD,          $
            'SoilColor',        SoilColor,           $
            'DLCDv1',           DLCDv1,              $
            'dummy',            1                    $   
            )
            
    print, systime(1)-t, ' seconds for reading data' 
    
    return, output
    
end
            
