; This program extracts the soil colour from a series of points.
; uses Soil colour map from Viscarra-Rossell et al 2010
; 
pro extract_soil_colour
  
  folder_images= '\\wron\working\work\Juan_Pablo\soils\Viscarra\colour\LatLon\'
  
  ; first open SLATS spreadsheet, need lat, lon and dates from there
;  Data = read_SLATS_data_new()
  fname = 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\fractional_landsat_subsets\outSorted_20130729.csv' 
  Data = READ_ASCII_FILE(fname, /SURPRESS_MSG)
  
  ; open the images
  CD, folder_images
  DIMS = [460, 375]
  fname = 'munsell_hue.LatLon.img'
  HUE = READ_BINARY(fname , DATA_DIMS=DIMS, DATA_TYPE=4)
  fname = 'munsell_value.LatLon.img'
  VALUE = READ_BINARY(fname , DATA_DIMS=DIMS, DATA_TYPE=4)
  fname = 'munsell_chroma.LatLon.img'
  CHROMA = READ_BINARY(fname , DATA_DIMS=DIMS, DATA_TYPE=4)
  
  HUE[Where(HUE lt -9000)] = !VALUES.F_NAN
  VALUE[Where(VALUE lt -9000)] = !VALUES.F_NAN
  CHROMA[Where(CHROMA lt -9000)] = !VALUES.F_NAN
  
  fname = 'R.LatLon.img'
  RED = READ_BINARY(fname , DATA_DIMS=DIMS, DATA_TYPE=1) * 1.0
  fname = 'G.LatLon.img'
  GREEN = READ_BINARY(fname , DATA_DIMS=DIMS, DATA_TYPE=1) * 1.0
  fname = 'B.LatLon.img'
  BLUE = READ_BINARY(fname , DATA_DIMS=DIMS, DATA_TYPE=1) * 1.0
  
  Where_255 = Where(RED eq 255 AND GREEN eq 255 and Blue eq 255)
  RED[Where_255] = !VALUES.F_NAN
  GREEN[Where_255] = !VALUES.F_NAN
  BLUE[Where_255] = !VALUES.F_NAN

  
;  Field_data = sat_fpar_anal_get_FC_field_data(N_MODELS=1)
  Field_data = DATA 
  n= n_elements(Field_data.obs_key)
  
  ; outputs to be written in fname
  fname = '\\wron\working\work\Juan_Pablo\PV_NPV_BS\New_Validation\GC_soil_colour_20130729.csv'
  OPENW, lun, fname, /GET_LUN
  header = 'OBJECTID,site_name,latitude,longitude,' + $
           ;'YEAR_OBS,MONTH_OBS,DAY_OBS,' + $
           'Hue,Value,Chroma,' + $
           'RED,GREEN,BLUE'  
  PRINTF, lun, header
  
      ; determine sample and line of SILO 
    latlon_soil_color= latlon_soil_color()
    
  HUE_site=fltarr(n)
  VALUE_site=fltarr(n)
  CHROMA_site=fltarr(n)
  RED_site=fltarr(n)
  GREEN_site=fltarr(n)
  BLUE_site=fltarr(n)
  
  for site = 0, n-1 do begin
;  for site = 0, 1 do begin
;    OBJECTID = (Field_data.OBJECTID)[site]
;    site_name = (Field_data.site_name)[site]
;    lat = (Field_data.latitude)[site]
;    lon = (Field_data.longitude)[site]
;    JULDATE = (Field_data.JULDATE)[site]
    OBJECTID = (Field_data.obs_key)[site]
    site_name = (Field_data.site)[site]
    lat = (Field_data.latitude)[site]
    lon = (Field_data.longitude)[site]

      sample = where(latlon_soil_color.lon - lon eq min(latlon_soil_color.lon - lon, /absolute))
      line   = where(latlon_soil_color.lat - lat eq min(latlon_soil_color.lat - lat, /absolute))
         
         HUE_site[site]= HUE[sample, line]
         VALUE_site[site]= VALUE[sample, line]
         CHROMA_site[site]= CHROMA[sample, line]
         RED_site[site]= RED[sample, line]
         GREEN_site[site]= GREEN[sample, line]
         BLUE_site[site]= BLUE[sample, line]
 
    
    FORMATLON   = '(10(I8, :, ", "))'  
    FORMATFLOAT = '(10(f8.1, :, ", "))'  
    line_print = STRCOMPRESS( $
                  STRING(OBJECTID) + ',' + $
                  STRING(site_name) + ',' + $
                  STRING(lat) + ',' + $
                  STRING(lon) + ',' + $
                  STRING(HUE_site[site], format=FORMATFLOAT) + ',' + $
                  STRING(VALUE_site[site], format=FORMATFLOAT) + ',' + $
                  STRING(CHROMA_site[site], format=FORMATFLOAT) + ',' + $
                  STRING(RED_site[site], format=FORMATFLOAT) + ',' + $
                  STRING(GREEN_site[site], format=FORMATFLOAT) + ',' + $
                  STRING(BLUE_site[site], format=FORMATFLOAT) , $
                  /REMOVE_ALL)                  
     
     PRINTF, lun, line_print              
     PRINT ,      line_print              
    
  endfor
   
  close, lun
  
  cd, 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\plots\May_2013\'
  
  ; make a few plots
  fname = 'soil_Color_scatterplots.png'
  if (FILE_INFO(fname)).exists eq 0 then begin
    PS_Start, fname
      ;cgWindow, Wmulti=[0,3,2], wxsize=1000, wYsize=300
      !P.Multi = [0,3,2]
      cgDisplay, 1000, 500 
      cgPlot, value, hue, psym=9, symsize=0.2, xTitle='VALUE', yTitle='HUE', /addcmd
      cgPlot, value_site, hue_site, psym=9, symsize=0.2, color='red', /addcmd, /overplot
      cgPlot, value, chroma, psym=9, symsize=0.2, xTitle='VALUE', yTitle='CHROMA', /addcmd
      cgPlot, value_site, chroma_site, psym=9, symsize=0.2, color='red', /addcmd, /overplot
      cgPlot, hue, chroma, psym=9, symsize=0.2, xTitle='HUE', yTitle='CHROMA', /addcmd
      cgPlot, hue_site, chroma_site, psym=9, symsize=0.2, color='red', /addcmd, /overplot
    
      cgPlot, RED, GREEN, psym=9, symsize=0.2, xTitle='RED', yTitle='GREEN', /addcmd
      cgPlot, RED_site, GREEN_site, psym=9, symsize=0.2, color='red', /addcmd, /overplot
      cgPlot, RED, BLUE, psym=9, symsize=0.2, xTitle='RED', yTitle='BLUE', /addcmd
      cgPlot, RED_site, BLUE_site, psym=9, symsize=0.2, color='red', /addcmd, /overplot
      cgPlot, GREEN, BLUE, psym=9, symsize=0.2, xTitle='GREEN', yTitle='BLUE', /addcmd
      cgPlot, GREEN_site, BLUE_site, psym=9, symsize=0.2, color='red', /addcmd, /overplot
    PS_End, /PNG, resize=100
  endif
  
end

