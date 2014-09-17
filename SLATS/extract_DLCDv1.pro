; This program extracts the soil colour from a series of points.
; uses Soil colour map from Viscarra-Rossell et al 2010

function latlon_DLCDv1

  longitudes= dindgen(19161) * ((155.00801389d - 110.00117500d) / (19161 - 1d)) + 110.00117500d
  latitudes = dindgen(14902) * ((-45.00362222d + 10.00117500d) / (14902 - 1d)) - 10.00117500d
  
  result= {  $
            lat: latitudes, $
            lon: longitudes $
           }
  return, result
  
end


 
pro extract_DLCDv1, data=data
  
  folder_images= 'Z:\work\Juan_Pablo\DLCD\New Folder'
  
  if Keyword_Set(data) eq 0 then $
    Data = read_SLATS_data_new()
    
  fname='Z:\work\Juan_Pablo\DLCD\New Folder\DLCD_Colours_Labels.csv'
  labels=READ_ASCII_FILE(fname, /SURPRESS_MSG)
  
  ; open the images
  CD, folder_images
  DIMS = [19161, 14902]
  fname = 'DLCDv1_Class.envi.img'
  DLCDv1 = READ_BINARY(fname , DATA_DIMS=DIMS, DATA_TYPE=1)
  
 
  
;  Field_data = sat_fpar_anal_get_FC_field_data(N_MODELS=1)
  Field_data = DATA.Field_all
  n= n_elements(Field_data.obs_key)
  
  ; outputs to be written in fname
  fname = '\\wron\working\work\Juan_Pablo\PV_NPV_BS\New_Validation\GC_DLCDv1_Jul2013.csv'
  OPENW, lun, fname, /GET_LUN
  header = 'OBJECTID,site_name,latitude,longitude,' + $
           ;'YEAR_OBS,MONTH_OBS,DAY_OBS,' + $
           'class,label,class2,label2'   
  PRINTF, lun, header
  
      ; determine sample and line of SILO 
    latlon= latlon_DLCDv1()
    
;  DLCDv1_site=bytarr(n)
  
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

      sample = where(latlon.lon - lon eq min(latlon.lon - lon, /absolute))
      line   = where(latlon.lat - lat eq min(latlon.lat - lat, /absolute))
         
         DLCDv1_site = fix(median(DLCDv1[sample-1:sample+1, line-1:line+1]))
         label_site = (labels.label)[where(labels.class_ eq DLCDv1_site)]
         class2_site= (labels.class2)[where(labels.class_ eq DLCDv1_site)]
         label2_site= (labels.label2)[where(labels.class_ eq DLCDv1_site)]
    
    FORMATLON   = '(10(I8, :, ", "))'  
    FORMATFLOAT = '(10(f8.1, :, ", "))'  
    line_print = STRCOMPRESS( $
                  STRING(OBJECTID) + ',' + $
                  STRING(site_name) + ',' + $
                  STRING(lat) + ',' + $
                  STRING(lon) + ',' + $
                  STRtrim(DLCDv1_site, 2) + ',' + $
                  label_site + ',' + $
                  STRtrim(class2_site, 2) + ',' + $
                  label2_site, $
                  /REMOVE_ALL)                  
     
     PRINTF, lun, line_print              
     PRINT ,      line_print              
    
  endfor
   
  close, lun
  
  
end

