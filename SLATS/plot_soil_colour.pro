; This program extracts the soil colour from a series of points.
; uses Soil colour map from Viscarra-Rossell et al 2010
; 
pro plot_soil_colour, data=data
  
  folder_images= '\\wron\working\work\Juan_Pablo\soils\Viscarra\colour\LatLon\'
  
  ; first open SLATS spreadsheet, need lat, lon and dates from there
  if Keyword_Set(data) eq 0 then $
    Data = read_SLATS_data_new()
  
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
  Field_data = DATA.Field_all
  n= n_elements(Field_data.obs_key)
  
;  ; outputs to be written in fname
;  fname = '\\wron\working\work\Juan_Pablo\PV_NPV_BS\New_Validation\GC_soil_colour_May2013.csv'
;  OPENW, lun, fname, /GET_LUN
;  header = 'OBJECTID,site_name,latitude,longitude,' + $
;           ;'YEAR_OBS,MONTH_OBS,DAY_OBS,' + $
;           'Hue,Value,Chroma,' + $
;           'RED,GREEN,BLUE'  
;  PRINTF, lun, header
;  
;      ; determine sample and line of SILO 
;    latlon_soil_color= latlon_soil_color()
    
  HUE_site=Data.SoilColor.hue
  VALUE_site=Data.SoilColor.value
  CHROMA_site=Data.SoilColor.chroma
  RED_site=Data.SoilColor.red
  GREEN_site=Data.SoilColor.green
  BLUE_site=Data.SoilColor.blue
  
     
  cd, 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\plots\May_2013\'
  

  ; make a few plots
  fname = 'soil_Color_scatterplots.png'
  if (FILE_INFO(fname)).exists eq 0 then begin
    abares = Where(data.Field_All.source eq 'abares', complement=notAbares)
    PS_Start, fname
      ;cgWindow, Wmulti=[0,3,2], wxsize=1000, wYsize=300
      !P.Multi = [0,3,2]
      cgDisplay, 1000, 600 
      cgPlot, value, hue, psym=9, symsize=0.2, xTitle='VALUE', yTitle='HUE', color='RED4' 
      cgPlot, value_site, hue_site, psym=9, symsize=0.2, color='black',  /overplot
      cgPlot, value_site[abares], hue_site[abares], psym=9, symsize=0.2, color='yellow',  /overplot
      cgPlot, value, chroma, psym=9, symsize=0.2, xTitle='VALUE', yTitle='CHROMA',color='RED4' 
      cgPlot, value_site, chroma_site, psym=9, symsize=0.2, color='black',  /overplot
      cgPlot, value_site[abares], chroma_site[abares], psym=9, symsize=0.2, color='yellow',  /overplot
      cgPlot, hue, chroma, psym=9, symsize=0.2, xTitle='HUE', yTitle='CHROMA',color='RED4' 
      cgPlot, hue_site, chroma_site, psym=9, symsize=0.2, color='black',  /overplot
      cgPlot, hue_site[abares], chroma_site[abares], psym=9, symsize=0.2, color='yellow',  /overplot
    
      cgPlot, RED, GREEN, psym=9, symsize=0.2, xTitle='RED', yTitle='GREEN', color='RED4' 
      cgPlot, RED_site, GREEN_site, psym=9, symsize=0.2, color='black',  /overplot
      cgPlot, RED_site[abares], GREEN_site[abares], psym=9, symsize=0.2, color='yellow',  /overplot
      cgPlot, RED, BLUE, psym=9, symsize=0.2, xTitle='RED', yTitle='BLUE', color='RED4' 
      cgPlot, RED_site, BLUE_site, psym=9, symsize=0.2, color='black',  /overplot
      cgPlot, RED_site[abares], BLUE_site[abares], psym=9, symsize=0.2, color='yellow',  /overplot
      cgPlot, GREEN, BLUE, psym=9, symsize=0.2, xTitle='GREEN', yTitle='BLUE', color='RED4' 
      cgPlot, GREEN_site, BLUE_site, psym=9, symsize=0.2, color='black',  /overplot
      cgPlot, GREEN_site[abares], BLUE_site[abares], psym=9, symsize=0.2, color='yellow',  /overplot
    PS_End, /PNG, resize=100
  endif
  
  ; make a few plots
  fname = 'soil_Color_valueVSchroma.png'
  if (FILE_INFO(fname)).exists eq 0 then begin
    PS_Start, fname
      ;cgWindow, Wmulti=[0,3,2], wxsize=1000, wYsize=300
      cgDisplay, 400, 500 
      cgPlot, chroma, value, psym=16, symsize=0.2, xTitle='CHROMA', yTitle='VALUE', $
        xRange=[0,9], yRange=[1,9]
      cgPlot, chroma_site, value_site, psym=16, symsize=0.2, color='red',  /overplot
    PS_End, /PNG, resize=100
  endif
  
  
  ; make a map
  fname = 'soil_Color_RGB_Map_withPoints.png'
  if (FILE_INFO(fname)).exists eq 0 then begin  
    abares = Where(data.Field_All.source eq 'abares', complement=notAbares)
    AusCoastline=auscoastline()
    xrange=[109.89871111,156.39123056]
    ;yRange=[-10.09201667, -43.84257500]
    yRange=[ -43.84257500, -10.09201667]
    !X.RANGE=xrange
    !Y.RANGE=yrange
    img = [[[rotate(RED,7)]],[[rotate(GREEN,7)]],[[rotate(BLUE,7)]]]
    img[Where(finite(img) eq 0)] = 255
    PS_Start, fname
      cgDisplay, (size(img))[1]*2 , (size(img))[2]*2
      cgImage, img , XRange=xrange, YRange=yrange
      cgPlot, data.Field_All.longitude, data.Field_All.latitude, psym=16, symsize=0.75, /overplot, color='black'  
      cgPlot, (data.Field_All.longitude)[abares], (data.Field_All.latitude)[abares], psym=16, symsize=0.75, /overplot, color='yellow'  
      cgPlot, AusCoastline.lon, AusCoastline.lat, psym=-3, /overplot
      
     PS_End, /PNG, resize=100
  endif
  
  
end

