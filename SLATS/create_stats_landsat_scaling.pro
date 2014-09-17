pro create_stats_Landsat_scaling, make_maps=make_maps, write_stats=write_stats
;  folder = '\\wron\Working\work\Juan_Pablo\PV_NPV_BS\New_Validation\fractional_landsat_subsets\TIFS\'
  folder = 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\fractional_landsat_subsets\atmosph_corrected\'
  folder_out = 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\fractional_landsat_subsets\atmosph_corrected\pngs\'
  CD, folder
  
  tifFiles = File_Search('*.tif')

;  fname = '\\wron\Working\work\Juan_Pablo\PV_NPV_BS\New_Validation\fractional_landsat_subsets\out_b3_3pixSorted.csv'
  fname = 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\fractional_landsat_subsets\outSorted20130627.csv'
  LANDSAT_Qld = READ_ASCII_FILE(fname, /SURPRESS_MSG)

;  files = FILE_SEARCH('*.tif*', COUNT=nFiles )
  
  
  reflGains = [ 670.0, 325.0, 345.0, 290.0, 425.0, 275.0 ]
  reflOffsets = [-30.0, 0.0, 0.0, 5.0, 5.0, 5.0 ]
  AusCoastline=auscoastline()
  
  if Keyword_Set(write_stats) then begin
    ; open file for output and write header
    fname = 'outSorted20130627_scaling_new.csv'
    CD, folder 
    OpenW, lun, fname, /Get_Lun
    PrintF, lun, 'obs_key,obs_time,site,image_name,' + $ 
                 'SAM_9x9,SAM_17x17,SAM_20x20,SAM_25x25,SAM_33x33,SAM_40x40,SAM_42x42,SAM_80x80,SAM_200x200,' + $ 
                 'ED_9x9,ED_17x17,ED_20x20,ED_25x25,ED_33x33,ED_40x40,ED_42x42,ED_80x80,ED_200x200,' + $ 
                 'B1_3x3,B2_3x3,B3_3x3,B4_3x3,B5_3x3,B6_3x3,' + $ 
                 'B1_9x9,B2_9x9,B3_9x9,B4_9x9,B5_9x9,B6_9x9,' + $ 
                 'B1_17x17,B2_17x17,B3_17x17,B4_17x17,B5_17x17,B6_17x17,' + $ 
                 'B1_20x20,B2_20x20,B3_20x20,B4_20x20,B5_20x20,B6_20x20,' + $ 
                 'B1_25x25,B2_25x25,B3_25x25,B4_25x25,B5_25x25,B6_25x25,' + $ 
                 'B1_33x33,B2_33x33,B3_33x33,B4_33x33,B5_33x33,B6_33x33,' + $ 
                 'B1_40x40,B2_40x40,B3_40x40,B4_40x40,B5_40x40,B6_40x40,' + $ 
                 'B1_42x42,B2_42x42,B3_42x42,B4_42x42,B5_42x42,B6_42x42,' + $ 
                 'B1_80x80,B2_80x80,B3_80x80,B4_80x80,B5_80x80,B6_80x80,' + $ 
                 'B1_200x200,B2_200x200,B3_200x200,B4_200x200,B5_200x200,B6_200x200,' + $ 
  ;               'cloud,' + $ 
  ;               'B1_StdDev_40x40,B2_StdDev_40x40,B3_StdDev_40x40,B4_StdDev_40x40,B5_StdDev_40x40,B6_StdDev_40x40,' + $
                 'Timelag'
  endif
  
  for i=0, n_elements(Landsat_Qld.obs_key)-1 do begin
    print, i+1, ' of ', n_elements(Landsat_Qld.obs_key) 
    CD, folder
    
    image_names = STRSPLIT((LANDSAT_Qld.image)[i], '_.', count=count, /Extract)
    Result = STRMATCH(TifFiles, image_names[0]+'_'+image_names[1]+'_'+image_names[2]+'*'+(LANDSAT_Qld.site)[i]+'_500pix.tif', $
              /Fold_Case) 
    if total(result) ne 1 then stop
    
    date_image_str = image_names[2]
    date_image = JULDAy(STRMID(date_image_str, 4, 2) * 1,STRMID(date_image_str, 6, 2) * 1,STRMID(date_image_str, 0, 4) * 1)

    date_obs_str = STRSPLIT((LANDSAT_Qld.obs_time)[i], '-', /Extract)
    date_obs = JULDAy(date_obs_str[1],date_obs_str[2],date_obs_str[0])
    
    timelag = date_image-date_obs
    
;    ; check if output exists, if not save plots 
;    site_number = (LANDSAT_Qld.site)[i] * 1.0               ; special case for 3 sites with numeric names
;    if site_number eq 0 then $
;      image_name = image_names[0]+'_'+(LANDSAT_Qld.site)[i]+'_500pix.tif' ELSE $
;      image_name = image_names[0]+'_'+(LANDSAT_Qld.site)[i]+'.0'+'_500pix.tif'

    image_name = TifFiles[where(result eq 1)]

    Filename=image_name+'.png'
    CD, folder_out  
    FileInfo = File_Info(Filename)  
    
    if FileInfo.Exists eq 0 and Keyword_set(make_maps) eq 1 then begin
 

    ;special case for an image which seemed to be corrupt
    if image_name eq 'l7tmre_p094r074_20051010_tmpm5_chat16_500pix.tif' then $
        image_name='noData.tif'
    
    CD, folder
    FileInfo = File_INFO(image_name)
    
    if FileInfo.Exists eq 1 then $
      image = float(READ_TIFF(image_name)) else $
      image = fltarr(6, 500, 500)

    image_copy = image
    size_image = size(image)
    size_x = size_image[2]
    size_y = size_image[3]
    total_image = Total(image, 1)
;    if min(total_image) eq 0 then where_noData = Where(total_image eq 0, count_noData)
    if min(total_image) eq 0 then replicate_total_image = image
    if min(total_image) eq 0 then for band=0, size_image[1]-1 do replicate_total_image[band, *, *] = total_image
    if min(total_image) eq 0 then image[where(replicate_total_image eq 0)] = !VALUES.F_NAN
    
    ; apply gain and bias to get reflectance. Email below from Peter Scarth
;      Hi Juan,
;      The numbers in the images correspond to scaled exoatmospheric
;      reflectance:
;      
;      float reflGains[] = { 670.0, 325.0, 345.0, 290.0, 425.0, 275.0 };
;      float reflOffsets[] = {-30.0, 0.0, 0.0, 5.0, 5.0, 5.0 };
;      
;      To get back to reflectance apply the following transformation:
;      
;      refl = (DN - reflOffsets[band]) / reflGains[band]
;      where DN is the pixel value.
;      Note that no null value was ever explicitly stated, and zero was used,
;      even though it is also a valid value for the scaled reflectance...
;          
;    for band=0,size_image[1]-1 do image[band,*,*] = (image[band,*,*] - reflOffsets[band]) / reflGains[band]
 
;   these images are atmospherically corrected, converted to reflectance by dividing by 10000 
    image /= 10000.

;    if count_noData ge 1 then $
;       for band=0, size_image[1]-1 do (image[band, *, *])[where_noData] = !VALUES.F_NAN
       
    B1 =  reform(image[0,*,*]) 
    B2 =  reform(image[1,*,*])
    B3 =  reform(image[2,*,*])
    B4 =  reform(image[3,*,*])
    B5 =  reform(image[4,*,*])
    B6 =  reform(image[5,*,*])
    
    image_display = [[[rotate(B6, 7)]],[[rotate(B4, 7)]],[[rotate(B3, 7)]]]
    
    Landsat_Wavelenghts = [485, 560, 660, 830, 1650, 2215]
    spectra_3x3 = fltarr(size_image[1])         ; 3x3 window, as used in SLATS
;    spectra_3x3DN = fltarr(size_image[1])         ; 3x3 window, as used in SLATS
    spectra_9x9 = fltarr(size_image[1])         ; 9x9 window,  270 metres
    spectra_17x17 = fltarr(size_image[1])       ; 17x17 window,  510 metres
    spectra_20x20 = fltarr(size_image[1])       ; 20x20 window,  500 metres - OLD!! 
    spectra_25x25 = fltarr(size_image[1])       ; 25x25 window,  750 metres
    spectra_33x33 = fltarr(size_image[1])       ; 33x33 window,  990 metres
    spectra_40x40 = fltarr(size_image[1])       ; 40x40 window, 1000 metres - OLD!! 
    spectra_42x42 = fltarr(size_image[1])       ; 42x42 window, 1260 metres
    spectra_80x80 = fltarr(size_image[1])       ; 80x80 window, 2000 metres 
    spectra_200x200 = fltarr(size_image[1])       ; 200x200 window, 5000 metres 
    for band=0, size_image[1]-1 do $
      spectra_3x3[band] = MEAN(image[band, size_x/2-1:size_x/2+1, size_y/2-1:size_y/2+1], /NaN)
;    for band=0, size_image[1]-1 do $
;      spectra_3x3DN[band] = MEAN(image_copy[band, size_x/2-1:size_x/2+1, size_y/2-1:size_y/2+1], /NaN)
    for band=0, size_image[1]-1 do $
      spectra_9x9[band] = MEAN(image[band, size_x/2-4:size_x/2+4, size_y/2-4:size_y/2+4], /NaN)
    for band=0, size_image[1]-1 do $
      spectra_17x17[band] = MEAN(image[band, size_x/2-8:size_x/2+8, size_y/2-8:size_y/2+8], /NaN)
    for band=0, size_image[1]-1 do $
      spectra_20x20[band] = MEAN(image[band, size_x/2-9:size_x/2+9, size_y/2-9:size_y/2+9], /NaN)
    for band=0, size_image[1]-1 do $
      spectra_25x25[band] = MEAN(image[band, size_x/2-12:size_x/2+12, size_y/2-12:size_y/2+12], /NaN)
    for band=0, size_image[1]-1 do $
      spectra_33x33[band] = MEAN(image[band, size_x/2-16:size_x/2+16, size_y/2-16:size_y/2+16], /NaN)
    for band=0, size_image[1]-1 do $
      spectra_40x40[band] = MEAN(image[band, size_image[2]/2-19:size_image[2]/2+19, size_image[3]/2-19:size_image[3]/2+19], /NaN)
    for band=0, size_image[1]-1 do $
      spectra_42x42[band] = MEAN(image[band, size_image[2]/2-21:size_image[2]/2+21, size_image[3]/2-21:size_image[3]/2+21], /NaN)
    for band=0, size_image[1]-1 do $
      spectra_80x80[band] = MEAN(image[band, size_image[2]/2-39:size_image[2]/2+39, size_image[3]/2-39:size_image[3]/2+39], /NaN)
    for band=0, size_image[1]-1 do $
      spectra_200x200[band] = MEAN(image[band, size_image[2]/2-99:size_image[2]/2+99, size_image[3]/2-99:size_image[3]/2+99], /NaN)

    ; Calculate metrics of difference between center and bigger areas
    SAM_9x9 = Spectral_Angle(spectra_3x3, spectra_9x9)
    SAM_17x17 = Spectral_Angle(spectra_3x3, spectra_17x17)
    SAM_20x20 = Spectral_Angle(spectra_3x3, spectra_20x20)
    SAM_25x25 = Spectral_Angle(spectra_3x3, spectra_25x25)
    SAM_33x33 = Spectral_Angle(spectra_3x3, spectra_33x33)
    SAM_40x40 = Spectral_Angle(spectra_3x3, spectra_40x40)
    SAM_42x42 = Spectral_Angle(spectra_3x3, spectra_42x42)
    SAM_80x80 = Spectral_Angle(spectra_3x3, spectra_80x80)
    SAM_200x200 = Spectral_Angle(spectra_3x3, spectra_200x200)
    
    ED_9x9 = RMSE(spectra_3x3, spectra_9x9)
    ED_17x17 = RMSE(spectra_3x3, spectra_17x17)
    ED_20x20 = RMSE(spectra_3x3, spectra_20x20)
    ED_25x25 = RMSE(spectra_3x3, spectra_25x25)
    ED_33x33 = RMSE(spectra_3x3, spectra_33x33)
    ED_40x40 = RMSE(spectra_3x3, spectra_40x40)
    ED_42x42 = RMSE(spectra_3x3, spectra_42x42)
    ED_80x80 = RMSE(spectra_3x3, spectra_80x80)
    ED_200x200 = RMSE(spectra_3x3, spectra_200x200)
  
    ; calculate cloud flag
    ; information provided by Rebecca Trevnick, b1/b6 > 2 AND b1 > 80 (DN)
;    B1_B7 = spectra_3x3DN[0] / spectra_3x3DN[5]
;    cloud = B1_B7 ge 2 and spectra_3x3DN[0] ge 80   

;    spectra_40x40_Stdev = fltarr(size_image[1])       ; 40x40 window, 1000 metres
;    ;calculate coefficient of variation for all bands (only 40x40 pixs)
;    for band=0, size_image[1]-1 do $
;      spectra_40x40_Stdev[band] = Stddev(image[band, size_image[2]/2-19:size_image[2]/2+19, size_image[3]/2-19:size_image[3]/2+19], /NaN)
    
    ; start plots
    ;first define vectors to be plotted showing areas
    line_3x3_x = [size_x/2-1, size_x/2-1, size_x/2+1,size_x/2+1, size_x/2-1]
    line_3x3_y = [size_y/2-2, size_y/2+2, size_y/2+2,size_y/2-2, size_y/2-2 ]
    line_20x20_x = [size_x/2-9, size_x/2-9, size_x/2+9,size_x/2+9, size_x/2-9 ]
    line_20x20_y = [size_y/2-9, size_y/2+9, size_y/2+9,size_y/2-9, size_y/2-9 ]
    line_40x40_x = [size_x/2-19, size_x/2-19, size_x/2+19,size_x/2+19, size_x/2-19 ]
    line_40x40_y = [size_y/2-19, size_y/2+19, size_y/2+19,size_y/2-19, size_y/2-19 ]
    line_80x80_x = [size_x/2-39, size_x/2-39, size_x/2+39,size_x/2+39, size_x/2-39 ]
    line_80x80_y = [size_y/2-39, size_y/2+39, size_y/2+39,size_y/2-39, size_y/2-39 ]
    line_200x200_x = [size_x/2-99, size_x/2-99, size_x/2+99,size_x/2+99, size_x/2-99 ]
    line_200x200_y = [size_y/2-99, size_y/2+99, size_y/2+99,size_y/2-99, size_y/2-99 ]
       
    ; file name for the output. 
    ; will add the SA in the begginning so when sorted they can be shown from min to max - NO 
;    SA_String = string(RMSE40x40, FORMAT='(F9.7)') 
;    if site_number eq 0 then $
;      Filename =  SA_String+'_'+image_names[0]+'_'+(LANDSAT_Qld.site)[i]+'_500pix_scaling.png' Else $ 
;      Filename =  SA_String+'_'+image_names[0]+'_'+(LANDSAT_Qld.site)[i]+'.0'+'_500pix_scaling.png'
;    CD, folder_out  
;    FileInfo = File_Info(Filename)  

    ; file name for the output. 
;    if site_number eq 0 then $
;      Filename =  image_names[0]+'_'+(LANDSAT_Qld.site)[i]+'_500pix_scaling.png' Else $ 
;      Filename =  image_names[0]+'_'+(LANDSAT_Qld.site)[i]+'.0'+'_500pix_scaling.png'
    ;if  Keyword_set(make_maps) eq 1 then begin   
      ;PS_Start, Filename
        cgWindow, WxSize=500, WySize=500 , Wmulti=[0,1,1]
        ; !P.Multi=[0,2,1]
    
        ; draw image
        cgImage, image_display, /keep_aspect_ratio, stretch=1, /addcmd 
    
        ; now draw squares around site (center)
        cfx = !x.crange[1]/size_x &  cfy = !y.crange[1]/size_y
        cgPlot, line_3x3_x*cfx, line_3x3_y*cfy, color='black', psym=-3,  /overplot , /addcmd 
        cgPlot, line_20x20_x*cfx, line_20x20_y*cfy, color='red', psym=-3,  /overplot , /addcmd 
        ;cgPlot, line_40x40_x*cfx, line_40x40_y*cfy, color='blue', psym=-3, /addcmd, /overplot  
        ;cgPlot, line_80x80_x*cfx, line_80x80_y*cfy, color='cyan', psym=-3, /addcmd, /overplot 
        ;cgPlot, line_200x200_x*cfx, line_200x200_y*cfy, color='magenta', psym=-3, /addcmd, /overplot 
        
        WID=cgQuery(/CURRENT)
        CD, folder_out    
        dummy = cgSnapshot(Filename = Filename, wid=wid,/PNG, /NODIALOG)
        cgDelete, WID

        ; now plot spectra
        
        CD, folder_out  
        PS_Start, 'spectra_'+image_name+'.ps.png'
        cgDisplay, 300, 300
        ; write image name
        ;cgWindow, 'cgText', 0.1,0.1, image_name, charthick=2, color='red', /addcmd
         
        ; now plot spectra
        cgPlot, Landsat_Wavelenghts, spectra_40x40, psym= -16 , /nodata, yrange=[0,0.6] ,  $
                  xrange=[400,2300],xstyle=1, xTitle='wavelength [nm]', yTitle='reflectance', charsize=2.75, $
                  position=[0.2,0.18,0.95,0.95]
        cgPlot, Landsat_Wavelenghts, spectra_3x3, psym= -16 , color='black', thick=4, symsize=2, /overplot
        cgPlot, Landsat_Wavelenghts, spectra_20x20, psym= -16 , color='red', thick=4, symsize=2,  /overplot
        ;cgWindow, 'cgPlot', Landsat_Wavelenghts, spectra_40x40, psym= -2 , color='red', /overplot, /addcmd,thick=2
        ;cgWindow, 'cgPlot', Landsat_Wavelenghts, spectra_80x80, psym= -2 , color='cyan', /overplot, /addcmd
        ;cgWindow, 'cgPlot', Landsat_Wavelenghts, spectra_200x200, psym= -2 , color='magenta', /overplot, /addcmd
        ;cgWindow, 'al_legend', ['3x3', '20x20', '40x40', '80x80', '200x200'], PSym=[-2,-2, -2, -2, -2], $
        ;           Color=['black','red', 'blue', 'cyan', 'magenta'], /top_legend, /left_legend, /addcmd
        al_legend, ['3x3', '17x17'], PSym=[16,16], symsize=[2,2], $
                   Color=['black','red'],Thick=[2,2], /top, /left, charsize=2.5, box=0
;        cgWindow, 'al_legend', ['3x3',  '40x40'], PSym=[-2, -2], $
;                   Color=['black', 'blue'], /top_legend, /left_legend, /addcmd
     
        ; now add some additional information about spectral differences
        ;cgWindow, 'cgText', 100,0.48,  'Spectral Angle:', charthick=1, color='black',   /addcmd
        ;cgWindow, 'cgText', 100,0.45,  String(SAM_20x20), charthick=1, color='red',   /addcmd
        ;cgWindow, 'cgText', 100,0.43,  String(SAM_40x40), charthick=1, color='blue',   /addcmd
        ;cgWindow, 'cgText', 100,0.41,  String(SAM_80x80), charthick=1, color='cyan',   /addcmd
        ;cgWindow, 'cgText', 100,0.39,  String(SAM_200x200), charthick=1, color='magenta',   /addcmd
        
          ;; plot map with points
        ;cgWindow, 'cgPlot', LANDSAT_Qld.st_x, LANDSAT_Qld.st_Y, $
        ;          psym=9, symsize=0.1, xRange=[112, 155], yRange=[-45, -10], xStyle=1, yStyle=1 , /addcmd
        ;cgWindow, 'cgPlot', AusCoastline.lon, AusCoastline.lat,  $
        ;          color='blue', psym=-3, thick=2, /OVERPLOT, /addcmd
        ;cgWindow, 'cgPlot', (LANDSAT_Qld.st_X)[i], (LANDSAT_Qld.st_Y)[i], $
        ;          psym=16, symsize=1,  color='red', /addcmd, /overplot
        
      
       ; now save plot to file
       
       PS_End, Resize=100, /png
;        Filename = Filename
;        WID=cgQuery(/CURRENT)
;        CD, folder_out    
;        dummy = cgSnapshot(Filename = Filename, wid=wid,/PNG, /NODIALOG)
;        cgDelete, WID
    EndIf
        
        ; write output to file
        FORMAT='(4(A,:,","),1000(F9.5,:,","))'
        if Keyword_Set(write_stats) then $
        printF, lun,  $
                (LANDSAT_Qld.obs_key)[i], $
                (LANDSAT_Qld.obs_time)[i], $                
                (LANDSAT_Qld.site)[i], $                
                Filename, $
                SAM_9x9, $
                SAM_17x17, $
                SAM_20x20, $
                SAM_25x25, $
                SAM_33x33, $
                SAM_40x40, $
                SAM_42x42, $
                SAM_80x80, $
                SAM_200x200, $
                ED_9x9, $
                ED_17x17, $
                ED_20x20, $
                ED_25x25, $
                ED_33x33, $
                ED_40x40, $
                ED_42x42, $
                ED_80x80, $
                ED_200x200, $
                spectra_3x3, $
                spectra_9x9, $
                spectra_17x17, $
                spectra_20x20, $
                spectra_25x25, $
                spectra_33x33, $
                spectra_40x40, $
                spectra_42x42, $
                spectra_80x80, $
                spectra_200x200, $
;                cloud, $
;                spectra_40x40_Stdev, $
                timelag, $
                format=format
                 
        if Keyword_Set(write_stats) then $
        print,  $
               (LANDSAT_Qld.obs_key)[i], $
                (LANDSAT_Qld.obs_time)[i], $                
                (LANDSAT_Qld.site)[i], $                
                Filename, $
                SAM_9x9, $
                SAM_17x17, $
                SAM_20x20, $
                SAM_25x25, $
                SAM_33x33, $
                SAM_40x40, $
                SAM_42x42, $
                SAM_80x80, $
                SAM_200x200, $
                ED_9x9, $
                ED_17x17, $
                ED_20x20, $
                ED_25x25, $
                ED_33x33, $
                ED_40x40, $
                ED_42x42, $
                ED_80x80, $
                ED_200x200, $
                spectra_3x3, $
                spectra_9x9, $
                spectra_17x17, $
                spectra_20x20, $
                spectra_25x25, $
                spectra_33x33, $
                spectra_40x40, $
                spectra_42x42, $
                spectra_80x80, $
                spectra_200x200, $
;                cloud, $
;                spectra_40x40_Stdev, $
                timelag, $
                format=format

        
  endfor
;  close, /all
  
;  EXIT, /no_confirm
 
end
