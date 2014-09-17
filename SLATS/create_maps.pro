
cd, 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\Reflectance_density\'
  fname = 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\Reflectance_density\density_RED_NIR_SWIR_2008_2009_areas.SAV'
  restore, fname
  
  fname_mask = 'Z:\work\Juan_Pablo\auxiliary\land_mask_australia_MCD43'
  land_mask = READ_BINARY(fname_mask, DATA_DIMS=[9580, 7451], DATA_TYPE=1)

  Data = read_SLATS_data()
  AusCoastline=auscoastline()
  
  
  LatLonMODIS= latlon_MODIS500m()
  xrange=[MIN(LatLonMODIS.lon), MAX(LatLonMODIS.lon)]
  yRange=[MIN(LatLonMODIS.lat), MAX(LatLonMODIS.lat)]
  !X.RANGE=xrange
  !Y.RANGE=yrange

;  RED_ge_3000_AND_NIR_ge_4000 = land_mask * 0B
;  SWIR3_ge_4500 = land_mask * 0B
;  RED_le_1500_AND_NIR_ge_3750 = land_mask * 0B
;  NIR_ge_3750_AND_SWIR3_le_2000 = land_mask * 0B

     ; Load the color table for the display. All zero values will be gray.
     cgLoadCT, 11, /brewer
     TVLCT, cgColor('white', /Triple), 0
     TVLCT, cgColor('gray', /Triple), 1
     TVLCT, r, g, b, /Get
     palette = [ [r], [g], [b] ]
     
     


img = Rotate(all*land_mask + land_mask, 7)
;img[where(img eq 0)] = !VALUES.F_NAN
fname_out='ALL.png'
PS_START, fname_out
  cgDisplay, (size(img))[1]/10 , (size(img))[2]/10 
  cgImage, img, /keep_aspect_ratio, maxvalue=max(img), minvalue=0, Palette=palette, XRange=xrange, YRange=yrange;, /Axes, $
      position=[0.05, 0.05, 0.95, 0.95]
  cgcolorbar, range=[0, max(img)], POSITION=[0.15, 0.10, 0.60, 0.15], $
    title='frequency', charsize=1;, NColors=254, Bottom=1, OOB_Low='white'
  cgPlot, data.landsat_qld.st_X, data.landsat_qld.st_Y, psym=1, symsize=0.75, /overplot, color='black'  
  cgPlot, AusCoastline.lon, AusCoastline.lat, psym=-3, /overplot
PS_End, resize=100, /png
   
   
img = Rotate(RED_ge_3000_AND_NIR_ge_4000*land_mask + land_mask*3, 7)
fname_out='RED_ge_3000_AND_NIR_ge_4000.png'
PS_START, fname_out
  cgDisplay, (size(img))[1]/10 , (size(img))[2]/10 
  cgImage, img, /keep_aspect_ratio, maxvalue=max(img), minvalue=0, Palette=palette, XRange=xrange, YRange=yrange;, /Axes, $
      position=[0.05, 0.05, 0.95, 0.95]
  cgcolorbar, range=[0, max(img)], POSITION=[0.15, 0.10, 0.60, 0.15], $
    title='frequency', charsize=1;, NColors=254, Bottom=1, OOB_Low='white'
  cgPlot, data.landsat_qld.st_X, data.landsat_qld.st_Y, psym=1, symsize=0.75, /overplot, color='black'  
  cgPlot, AusCoastline.lon, AusCoastline.lat, psym=-3, /overplot
PS_End, resize=100, /png
   
   
img = Rotate(SWIR3_ge_4500*land_mask + land_mask*3, 7)
fname_out='SWIR3_ge_4500.png'
PS_START, fname_out
  cgDisplay, (size(img))[1]/10 , (size(img))[2]/10 
  cgImage, img, /keep_aspect_ratio, maxvalue=max(img), minvalue=0, Palette=palette, XRange=xrange, YRange=yrange;, /Axes, $
      position=[0.05, 0.05, 0.95, 0.95]
  cgcolorbar, range=[0, max(img)], POSITION=[0.15, 0.10, 0.60, 0.15], $
    title='frequency', charsize=1;, NColors=254, Bottom=1, OOB_Low='white'
  cgPlot, data.landsat_qld.st_X, data.landsat_qld.st_Y, psym=1, symsize=0.75, /overplot, color='black'  
  cgPlot, AusCoastline.lon, AusCoastline.lat, psym=-3, /overplot
PS_End, resize=100, /png
 
 
img = Rotate(RED_le_1500_AND_NIR_ge_3750*land_mask + land_mask*3, 7)
fname_out='RED_le_1500_AND_NIR_ge_3750.png'
PS_START, fname_out
  cgDisplay, (size(img))[1]/10 , (size(img))[2]/10 
  cgImage, img, /keep_aspect_ratio, maxvalue=max(img), minvalue=0, Palette=palette, XRange=xrange, YRange=yrange;, /Axes, $
      position=[0.05, 0.05, 0.95, 0.95]
  cgcolorbar, range=[0, max(img)], POSITION=[0.15, 0.10, 0.60, 0.15], $
    title='frequency', charsize=1;, NColors=254, Bottom=1, OOB_Low='white'
  cgPlot, data.landsat_qld.st_X, data.landsat_qld.st_Y, psym=1, symsize=0.75, /overplot, color='black'  
  cgPlot, AusCoastline.lon, AusCoastline.lat, psym=-3, /overplot
PS_End, resize=100, /png
 
 
img = Rotate(NIR_ge_3750_AND_SWIR3_le_2000*land_mask + land_mask*3, 7)
fname_out='NIR_ge_3750_AND_SWIR3_le_2000.png'
PS_START, fname_out
  cgDisplay, (size(img))[1]/10 , (size(img))[2]/10 
  cgImage, img, /keep_aspect_ratio, maxvalue=max(img), minvalue=0, Palette=palette, XRange=xrange, YRange=yrange;, /Axes, $
      position=[0.05, 0.05, 0.95, 0.95]
  cgcolorbar, range=[0, max(img)], POSITION=[0.15, 0.10, 0.60, 0.15], $
    title='frequency', charsize=1;, NColors=254, Bottom=1, OOB_Low='white'
  cgPlot, data.landsat_qld.st_X, data.landsat_qld.st_Y, psym=1, symsize=0.75, /overplot, color='black'  
  cgPlot, AusCoastline.lon, AusCoastline.lat, psym=-3, /overplot
PS_End, resize=100, /png
      