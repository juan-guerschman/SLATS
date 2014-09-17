

pro create_false_color_landsat_WELD, folder
  compile_opt idl2

  if KEYWORD_SET(folder) eq 0 then $
    folder= 'Z:\work\Juan_Pablo\LANDSAT\WELD\GDLvqyzcMONTH062012\conus.month06.2012.lon-102.489016to-102.09803.lat35.718029to36.074063.doy165to181.v1.5'
  cd, folder
  quality=100
      
    ;read bands
  
;    B1 = READ_TIFF('Band1_TOA_REF.TIF', GEOTIFF=GEOTIFF)
;    B2 = READ_TIFF('Band2_TOA_REF.TIF', GEOTIFF=GEOTIFF)
    B3 = READ_TIFF('Band3_TOA_REF.TIF', GEOTIFF=GEOTIFF)
    B4 = READ_TIFF('Band4_TOA_REF.TIF', GEOTIFF=GEOTIFF)
;    B5 = READ_TIFF('Band5_TOA_REF.TIF', GEOTIFF=GEOTIFF)
    B7 = READ_TIFF('Band7_TOA_REF.TIF', GEOTIFF=GEOTIFF)
    size_img = size(B3)
    
        
    ; write jpg
    img_png = bytarr(3, size_img[1], size_img[2])
    img_png[0,*,*] = bytscl(B7, min=0, max=5000)
    img_png[1,*,*] = bytscl(B4, min=0, max=5000)
    img_png[2,*,*] = bytscl(B3, min=0, max=5000)
    ;WRITE_PNG, fname, img_png, /order
    fname= 'Landsat_falseColor743.jpg'
    WRITE_JPEG, fname, img_png , TRUE=1, quality=quality, /order
      
end

  