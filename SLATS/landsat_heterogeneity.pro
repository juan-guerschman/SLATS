pro Landsat_heterogeneity
  folder = '\\wron\Working\work\Juan_Pablo\PV_NPV_BS\New_Validation\fractional_landsat_subsets\'
  folder_out = '\\wron\Working\work\Juan_Pablo\PV_NPV_BS\New_Validation\fractional_landsat_subsets\SA_heterog'
  CD, folder

  fname = '\\wron\Working\work\Juan_Pablo\PV_NPV_BS\New_Validation\fractional_landsat_subsets\out_b3_3pixSorted.csv'
  LANDSAT_Qld = READ_ASCII_FILE(fname, /SURPRESS_MSG)

;  files = FILE_SEARCH('*.tif*', COUNT=nFiles )

  ;Some Defaults for saving: 
  cgwindow_setdefs, IM_Resize=100
   
  make_maps =       1
  
  reflGains = [ 670.0, 325.0, 345.0, 290.0, 425.0, 275.0 ]
  reflOffsets = [-30.0, 0.0, 0.0, 5.0, 5.0, 5.0 ]
  
  ; open file for output and write header
  fname = 'out_b3_3pixSorted_scaling.csv'
  CD, folder_out
  
  cgLoadct, 33
  
  for i=0, n_elements(Landsat_Qld.obs_key)-1 do begin
    print, i+1, ' of ', n_elements(Landsat_Qld.obs_key) 
    
    image_names = STRSPLIT((LANDSAT_Qld.image)[i], '.', count=count, /Extract)

    ; check if output exists, if not save plots 
    site_number = (LANDSAT_Qld.site)[i] * 1.0               ; special case for 3 sites with numeric names

    if site_number eq 0 then $
      output_image_name =  image_names[0]+'_'+(LANDSAT_Qld.site)[i]+'_500pix_SA40x40.png' Else $ 
      output_image_name =  image_names[0]+'_'+(LANDSAT_Qld.site)[i]+'.0'+'_500pix_SA40x40.png'
    CD, folder_out  
    FileInfo_output = File_Info(output_image_name)  

    IF FileInfo_output.Exists eq 0 then begin     ; skip all if output exists

      if site_number eq 0 then $
        input_image_name = image_names[0]+'_'+(LANDSAT_Qld.site)[i]+'_500pix.tif' ELSE $
        input_image_name = image_names[0]+'_'+(LANDSAT_Qld.site)[i]+'.0'+'_500pix.tif'
  
      CD, folder
      FileInfo_input = File_INFO(input_image_name)
      
      if FileInfo_input.Exists eq 1 then $
        image = float(READ_TIFF(input_image_name)) else $
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
      for band=0,size_image[1]-1 do image[band,*,*] = (image[band,*,*] - reflOffsets[band]) / reflGains[band]
      
  
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
  
      ; output will be image of size_x, size_y
      SA_40x40_out = fltarr(size_x, size_y) * !VALUES.F_NAN
      
      t=Systime(1)
      for sample=19, size_x-20 do begin
        for line=19, size_y-20 do begin
          spectra_3x3 = fltarr(size_image[1])         ; 3x3 window, as used in SLATS
          spectra_40x40 = fltarr(size_image[1])       ; 40x40 window, 1000 metres
          
          for band=0, size_image[1]-1 do $
             spectra_3x3[band] = MEAN(image[band, sample-1:sample+1, line-1:line+1], /NaN)
          for band=0, size_image[1]-1 do $
            spectra_40x40[band] = MEAN(image[band, sample-19:sample+19, line-19:line+19], /NaN)
       
  ;          spectra_3x3 = fltarr(size_image[1])         ; 3x3 window, as used in SLATS
  ;          spectra_3x3DN = fltarr(size_image[1])         ; 3x3 window, as used in SLATS
  ;          spectra_20x20 = fltarr(size_image[1])       ; 20x20 window,  500 metres
  ;          spectra_40x40 = fltarr(size_image[1])       ; 40x40 window, 1000 metres
  ;          spectra_80x80 = fltarr(size_image[1])       ; 80x80 window, 2000 metres 
  ;          for band=0, size_image[1]-1 do $
  ;            spectra_3x3[band] = MEAN(image[band, size_x/2-1:size_x/2+1, size_y/2-1:size_y/2+1], /NaN)
  ;          for band=0, size_image[1]-1 do $
  ;            spectra_3x3DN[band] = MEAN(image_copy[band, size_x/2-1:size_x/2+1, size_y/2-1:size_y/2+1], /NaN)
  ;          for band=0, size_image[1]-1 do $
  ;            spectra_20x20[band] = MEAN(image[band, size_x/2-9:size_x/2+9, size_y/2-9:size_y/2+9], /NaN)
  ;          for band=0, size_image[1]-1 do $
  ;            spectra_40x40[band] = MEAN(image[band, size_image[2]/2-19:size_image[2]/2+19, size_image[3]/2-19:size_image[3]/2+19], /NaN)
  ;          for band=0, size_image[1]-1 do $
  ;            spectra_80x80[band] = MEAN(image[band, size_image[2]/2-39:size_image[2]/2+39, size_image[3]/2-39:size_image[3]/2+39], /NaN)
  
            ; Calculate metrics of difference between center and bigger areas
            ;SAM_20x20 = Spectral_Angle(spectra_3x3, spectra_20x20)
            SAM_40x40 = Spectral_Angle(spectra_3x3, spectra_40x40)
            ;SAM_80x80 = Spectral_Angle(spectra_3x3, spectra_80x80)
            SA_40x40_out[sample, line] = SAM_40x40
            
          endfor
        endfor
        print, Systime(1)-t, ' seconds for processing image'
         
        ; save output image
         
          CD, folder_out  
          
          cgWindow,  wxsize=1000, wysize=500, wmulti=[0,2,1]
      
          ; draw image
          cgWindow, 'cgImage', image_display, /keep_aspect_ratio, stretch=1 , /addcmd
              
          ; write image name
          cgWindow, 'cgText', 0.1,0.1, input_image_name, charthick=2, color='red', /addcmd
          
          ; now plot SA image 
          cgWindow, 'cgImage', rotate(SA_40x40_out, 7), /keep_aspect_ratio, MINVALUE=0, MAXVALUE=0.2,PALETTE=palette,  /addcmd
          
          cgWindow, 'cgColorbar', RANGE=[0,0.2] ,/FIT, /VERTICAL, OOB_HIGH='white',OOB_LOW='black' , /addcmd, charsize=1
            
          ; now save plot to file
          Filename = output_image_name
          WID=cgQuery(/CURRENT)
          CD, folder_out    
          dummy = cgSnapshot(Filename = Filename, wid=wid,/PNG, /NODIALOG)
          cgDelete, WID
    EndIf    

  endfor
  close, /all
  
  EXIT, /no_confirm
 
end
