pro convert_all_PS2Raster, folder=folder, portrait=portrait, resize=resize

  if Keyword_Set(folder) then $
    cd, folder ;$
  if Keyword_Set(resize) eq 0 then resize=100
;  Else $
;    CD, 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\SAGE\plots\'
  
  ps_filename = FILE_SEARCH('*.ps')
  raster_filename =  ps_filename+'.png'
  
  for i=0, n_elements(ps_filename)-1 do begin
    if (FILE_INFO(raster_filename[i])).exists eq 0 then $
      cgPS2Raster, ps_filename[i], raster_filename[i], /PNG, resize=resize, portrait=portrait
  endfor
      
end

