pro SLATS_Soil_color

  fname = '\\wron\working\work\Juan_Pablo\soils\Viscarra\colour\munsell_value_hue_chroma.meta' 
  ENVI_OPEN_FILE, fname, r_fid=Fid_munsell
  envi_file_query, Fid_munsell, dims=dims, ns=ns, nl=nl, nb=nb
  munsell_AUS=fltarr(ns,nl,nb)
  for i=0, nb-1 do munsell_AUS[*,*,i]=ENVI_GET_DATA(fid=Fid_munsell, dims=dims, pos=i)
  where_noData=Where(munsell_AUS eq -9999, count)
  if Count ge 1 then munsell_AUS[where_noData]=!VALUES.F_NAN
  
  fname = '\\wron\working\work\Juan_Pablo\soils\Viscarra\colour\RGB_geotiff.tif' 
  ENVI_OPEN_FILE, fname, r_fid=Fid_RGB
  envi_file_query, Fid_RGB, dims=dims, ns=ns, nl=nl, nb=nb
  rgb_AUS=fltarr(ns,nl,nb)
  for i=0, nb-1 do rgb_AUS[*,*,i]=ENVI_GET_DATA(fid=Fid_RGB, dims=dims, pos=i)
  where_noData=Where(rgb_AUS eq 255, count)
  if Count ge 1 then rgb_AUS[where_noData]=!VALUES.F_NAN
  
  
  ROI_IDS = ENVI_GET_ROI_IDS(fid=Fid_RGB)
  ENVI_GET_ROI_INFORMATION, ROI_IDS, NPTS=npts
  munsell_SLATS=fltarr(NPTS, nb)
  rgb_SLATS=fltarr(NPTS, nb)
  for i=0, nb-1 do munsell_SLATS[*,i]= ENVI_GET_ROI_DATA(ROI_IDS[0], fid=Fid_munsell, pos=i)
  for i=0, nb-1 do rgb_SLATS[*,i]= ENVI_GET_ROI_DATA(ROI_IDS[0], fid=Fid_rgb, pos=i)
  
  !P.charsize=2
  cgWindow, WMULTI=[0,3,2], WXSize=1500, WYSize=1000
  cgplot, munsell_AUS[*,*,0],munsell_AUS[*,*,1], psym=1, symsize=0.5, xtitle='value', ytitle='hue', /addcmd
  cgplot, munsell_SLATS[*,0],munsell_SLATS[*,1], psym=1, symsize=0.5, color='red', /overplot, /addcmd
  
  cgplot, munsell_AUS[*,*,0],munsell_AUS[*,*,2], psym=1, symsize=0.5, xtitle='value', ytitle='chroma', /addcmd
  cgplot, munsell_SLATS[*,0],munsell_SLATS[*,2], psym=1, symsize=0.5, color='red', /overplot, /addcmd
  
  cgplot, munsell_AUS[*,*,1],munsell_AUS[*,*,2], psym=1, symsize=0.5, xtitle='hue', ytitle='chroma', /addcmd
  cgplot, munsell_SLATS[*,1],munsell_SLATS[*,2], psym=1, symsize=0.5, color='red', /overplot, /addcmd
   
   
  cgplot, rgb_AUS[*,*,0],rgb_AUS[*,*,1], psym=1, symsize=0.5, xtitle='RED', ytitle='GREEN', /addcmd
  cgplot, rgb_SLATS[*,0],rgb_SLATS[*,1], psym=1, symsize=0.5, color='red', /overplot, /addcmd
  
  cgplot, rgb_AUS[*,*,0],rgb_AUS[*,*,2], psym=1, symsize=0.5, xtitle='RED', ytitle='BLUE', /addcmd
  cgplot, rgb_SLATS[*,0],rgb_SLATS[*,2], psym=1, symsize=0.5, color='red', /overplot, /addcmd
  
  cgplot, rgb_AUS[*,*,1],rgb_AUS[*,*,2], psym=1, symsize=0.5, xtitle='GREEN', ytitle='BLUE', /addcmd
  cgplot, rgb_SLATS[*,1],rgb_SLATS[*,2], psym=1, symsize=0.5, color='red', /overplot, /addcmd
   
end
 
  