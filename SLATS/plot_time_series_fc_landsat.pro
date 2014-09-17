pro plot_time_series_FC_Landsat

  nan=!Values.F_nan
  folder= 'Z:\work\Juan_Pablo\LANDSAT\GA_NBAR\bylong2\'
  cd, folder
  files = FILE_SEARCH('*.jpg')
  n=n_elements(files)
  
  day= intarr(n)
  month= intarr(n)
  year= intarr(n)
  sensor=strarr(n)
  PV_fname=strarr(n)
  NPV_fname=strarr(n)
  BS_fname=strarr(n)
  
  for i=0, n-1 do begin
    jpg_fname=StrSplit(files[i], '_.', /extract)
    year[i]=jpg_fname[3]
    month[i]=jpg_fname[4]
    day[i]=jpg_fname[5]
    sensor[i]=jpg_fname[6]
    PV_fname[i]='Landsat_PV_'+jpg_fname[2]+'_'+jpg_fname[3]+'_'+jpg_fname[4]+'_'+jpg_fname[5]+'_'+jpg_fname[6]+'_'+jpg_fname[7]+'_'+jpg_fname[8]+'.TIFF' 
    NPV_fname[i]='Landsat_NPV_'+jpg_fname[2]+'_'+jpg_fname[3]+'_'+jpg_fname[4]+'_'+jpg_fname[5]+'_'+jpg_fname[6]+'_'+jpg_fname[7]+'_'+jpg_fname[8]+'.TIFF' 
    BS_fname[i]='Landsat_BS_'+jpg_fname[2]+'_'+jpg_fname[3]+'_'+jpg_fname[4]+'_'+jpg_fname[5]+'_'+jpg_fname[6]+'_'+jpg_fname[7]+'_'+jpg_fname[8]+'.TIFF' 
  endfor  
   
  dates = julday(month, day, year)  
  cgDisplay, 1400, 500
  cgplot, dates[where(sensor eq 'L7')], (indgen(n))[where(sensor eq 'L7')], psym=9, color='red', xrange=[min(dates)-30, max(dates)+30]
  cgplot, dates[where(sensor eq 'L5')], (indgen(n))[where(sensor eq 'L5')], psym=9, color='blue', /overplot
  
  ; get the FC data
  folder= 'Z:\work\Juan_Pablo\LANDSAT\GA_NBAR\bylong2\FC\'
  cd, folder
  ;get the first image so I know the dimensions
  xx = READ_TIFF(PV_fname[0], GEOTIFF=GEOTIFF)
  dims=size(xx)
  PV=MAKE_ARRAY(dims[1]+1,dims[2]+1,n, type=dims[3]) ; make it one col and one line bigger (some imgs are diff size)
  NPV=MAKE_ARRAY(dims[1]+1,dims[2]+1,n, type=dims[3]) ; make it one col and one line bigger (some imgs are diff size)
  BS=MAKE_ARRAY(dims[1]+1,dims[2]+1,n, type=dims[3]) ; make it one col and one line bigger (some imgs are diff size)
  for i=0,n-1 do begin
    img=READ_TIFF(PV_fname[i])
    size_img=SIZE(img)
    PV[0:size_img[1]-1,0:size_img[2]-1,i]=img

    img=READ_TIFF(NPV_fname[i])
    size_img=SIZE(img)
    NPV[0:size_img[1]-1,0:size_img[2]-1,i]=img

    img=READ_TIFF(BS_fname[i])
    size_img=SIZE(img)
    BS[0:size_img[1]-1,0:size_img[2]-1,i]=img
  endfor
  
  ; fix some crap data
  TOT = PV*1l+NPV*1l+BS*1l
  where_bad = where(tot lt 90 or tot gt 110, count)
   
  ; convert to float and fill with nans
  PV *= 1.0 & PV[where_bad]=NaN
  NPV *= 1.0 & NPV[where_bad]=NaN
  BS *= 1.0 & BS[where_bad]=NaN
  
  mean_PV=mean(mean(PV, dimension=1, /nan), dimension=1, /nan)
  mean_NPV=mean(mean(NPV, dimension=1, /nan), dimension=1, /nan)
  mean_BS=mean(mean(BS, dimension=1, /nan), dimension=1, /nan)
stop  
  cgDisplay, 1400, 500
  cgplot, dates, mean_PV, psym=-9, color='dark green', xrange=[min(dates)-30, max(dates)+30], XTICKUNITS='Time'
  cgplot, dates, mean_NPV, psym=-9, color='red', /overplot
  cgplot, dates, mean_BS, psym=-9, color='blue', /overplot
  
 
end
    
    