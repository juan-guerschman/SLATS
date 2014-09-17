pro create_Google_img_SLATS

  ; LOAD DATA 
  fname = 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\fractional_landsat_subsets\out_b3_3pixSorted.csv'
  LANDSAT_Qld = READ_ASCII_FILE(fname, /SURPRESS_MSG)

  fname = 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\field_data\GC_state_2013March28b.csv'
  ABARES = READ_ASCII_FILE(fname, /SURPRESS_MSG)
  
  CD, 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\Google_earth_subsets\'   ; save outputs there
  
  help, LANDSAT_Qld.OBS_KEY 
  help, ABARES.UNIQUE_OBS 
  
  ; check where points overlap (won't use)
  ABARES_has_Qld = intarr(n_elements(ABARES.UNIQUE_OBS))
  Qld_has_ABARES = intarr(n_elements(LANDSAT_Qld.OBS_KEY))
  
  for i=0, n_elements(ABARES.UNIQUE_OBS)-1 do $
    ABARES_has_Qld[i]=  where((ABARES.UNIQUE_OBS)[i] eq LANDSAT_Qld.OBS_KEY)   
  print, total(Qld_has_ABARES ge 0)  
  
  for i=0, n_elements(LANDSAT_Qld.OBS_KEY)-1 do $
    Qld_has_ABARES[i]=  where((LANDSAT_Qld.OBS_KEY)[i] eq ABARES.UNIQUE_OBS)   
  print, total(ABARES_has_Qld ge 0)    
  
  ;concatenate variables 
  UNIQUE_OBS = [ABARES.UNIQUE_OBS, LANDSAT_Qld.OBS_KEY]
  latitude = [ABARES.LATITUDE, LANDSAT_Qld.ST_Y]
  longitude = [ABARES.LONGITUDE, LANDSAT_Qld.ST_X]
  SITE_NAME = [ABARES.SITE_NAME, LANDSAT_Qld.SITE]
  
  ; do ABARES first (all of them)
  for i=0, n_elements(UNIQUE_OBS)-1 do begin
   out_name =  UNIQUE_OBS[i] +'_'+ SITE_NAME[i] + '_GE.png'
   
   ; don't do anything if image exists
   if (FILE_INFO(out_name)).exists eq 0 then begin
      print, out_name + ' processing' 
     ; Set up variables for the plot. Normally, these values would be
     ; passed into the program as positional and keyword parameters.
     centerLat = LATITUDE[i]
     centerLon = LONGITUDE[i]
     zoom = 16
     scale = cgGoogle_MetersPerPixel(zoom)
     
     
     ; Gather the Google Map using the Google Static Map API.
     googleStr = "http://maps.googleapis.com/maps/api/staticmap?" + $
        "center=" + StrTrim(centerLat,2) + ',' + StrTrim(centerLon,2) + $
        "&zoom=" + StrTrim(zoom,2) + "&size=600x600" + '&scale=2' + $
        "&maptype=satellite&sensor=false&format=png32"
     netObject = Obj_New('IDLnetURL')
     void = netObject -> Get(URL=googleStr, FILENAME=out_name)
     Obj_Destroy, netObject
     
;    dont do any plotting yet (will do later with calculations) 
;       
;      googleImage = Read_Image(out_name) 
;     
;     ; Set up the map projection information to be able to draw on top
;     ; of the Google map.
;     map = Obj_New('cgMap', 'Mercator', ELLIPSOID='WGS 84', /OnImage)
;     uv = map -> Forward(centerLon, centerLat)
;     uv_xcenter = uv[0,0]
;     uv_ycenter = uv[1,0]
;     xrange = [uv_xcenter - (300*scale), uv_xcenter + (300*scale)]
;     yrange = [uv_ycenter - (300*scale), uv_ycenter + (300*scale)]
;     map -> SetProperty, XRANGE=xrange, YRANGE=yrange
;     
;     ; Open a window and display the Google Image with a map grid and
;     ; location of Coyote's favorite prairie dog restaurant. 
;     cgDisplay, 1200, 1200 
;     cgImage, googleImage[0:2,*,*];, Position=[.1, .1, .9, .9]  
;     cgMap_Grid, MAP=map, /BOX_AXES, /cgGRID
;     ;cgMap_Grid, MAP=map, /BOX_AXES, /cgGRID
;  
;     ; plot star  
;     cgPlotS, uv_xcenter, uv_ycenter, PSYM='filledstar', SYMSIZE=2.0, COLOR='red'
;      
;     ;plot boxes around center: 100, 500 and 1000 meters
;     box_100_x = [uv_xcenter-50, uv_xcenter+50, uv_xcenter+50, uv_xcenter-50, uv_xcenter-50]
;     box_100_y = [uv_ycenter-50, uv_ycenter-50, uv_ycenter+50, uv_ycenter+50, uv_ycenter-50]
;     box_500_x = [uv_xcenter-250, uv_xcenter+250, uv_xcenter+250, uv_xcenter-250, uv_xcenter-250]
;     box_500_y = [uv_ycenter-250, uv_ycenter-250, uv_ycenter+250, uv_ycenter+250, uv_ycenter-250]
;     box_1000_x = [uv_xcenter-500, uv_xcenter+500, uv_xcenter+500, uv_xcenter-500, uv_xcenter-500]
;     box_1000_y = [uv_ycenter-500, uv_ycenter-500, uv_ycenter+500, uv_ycenter+500, uv_ycenter-500]
;  
;  
;     cgPlotS, box_100_x, box_100_y, psym=-3, color='black'
;     cgPlotS, box_500_x, box_500_y, psym=-3, color='red'
;     cgPlotS, box_1000_x, box_1000_y, psym=-3, color='blue'
;      
   endif Else Begin
    print, out_name + ' exists, skip'
   EndElse
    
  endfor
  
end
  
  