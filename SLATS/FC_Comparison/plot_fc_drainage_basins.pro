pro plot_FC_drainage_basins

  ; open drainage basin mask 
  fname= 'Z:\work\Juan_Pablo\ACEAS\comparison\drainage_basins.img'
  DIMS=[9580,7451]  
  DRAINAGE = READ_BINARY(fname, DATA_DIMS=DIMS, Data_Type=1)
  
  fname = 'Z:\work\Juan_Pablo\ACEAS\comparison\drainage_basins.csv'
  data = READ_ASCII_FILE(fname, /SURPRESS_MSG)
  
  source=['Landsat','CSIRO_v22','CSIRO_v30','SMA','MESMA']
  color=['red','blue','dark green','magenta','maroon']
  fraction=['PV','NPV','BS']
  basin_name=['AUSTRALIA', $
    'BULLOO-BANCANNIA', $
    'GULF OF CARPENTARIA', $
    'INDIAN OCEAN', $
    'LAKE EYRE', $
    'MURRAY-DARLING', $
    'NORTH-EAST COAST', $
    'SOUTH-EAST COAST', $
    'SOUTH-WEST COAST', $
    'SOUTH AUSTRALIAN GULF', $
    'TASMANIA', $
    'TIMOR SEA', $
    'WESTERN PLATEAU']
  
  
  fake_data = findgen(15) / 11.
  
  cd, 'Z:\work\Juan_Pablo\ACEAS\comparison\plots\spatial\'
  
  for basin = 0, 12 do begin
    if basin lt 10 then e='0' else e=''
    fname = 'summary.basin.'+e+strtrim(basin,2)+'.png'
    PS_Start, fname
      cgDisplay, 1700, 250
      if basin eq 0 then title=fraction else title=['','','']
      if basin eq 0 then $ 
        img = (Drainage eq 0) * 255 $
        else $
        img = (Drainage eq 0) * 255 + (Drainage ne basin) * 240 
      img = congrid(img,958,745)    
      cgImage, Rotate(img,7), position=[0,0,0.15,1], /keep_aspect_ratio
          cgText, 0.09, 0.9, basin_name[basin], alignment=0.5, charsize=0.75, /normal
      for f=0,2 do begin
        if f eq 0 then begin
          cgPlot, fake_data, /nodata, position=[0.20,0.2,0.43,.95], charsize=0.9, $
            /noerase, yRange=[-0.05,1.05], yStyle=1, xCharsize=0.01 
          cgText, 7.5, 0.9, 'PV', alignment=0.5, charsize=1
          cgText, 2.5, -0.3, '2002', alignment=0.5, charsize=1
          cgText, 7.5, -0.3, '2007', alignment=0.5, charsize=1
          cgText, 12.5, -0.3, '2010', alignment=0.5, charsize=1
          cgText, 1, -0.15, 'M', alignment=0.5, charsize=0.75
          cgText, 2, -0.15, 'J', alignment=0.5, charsize=0.75
          cgText, 3, -0.15, 'S', alignment=0.5, charsize=0.75
          cgText, 4, -0.15, 'D', alignment=0.5, charsize=0.75
          cgText, 6, -0.15, 'M', alignment=0.5, charsize=0.75
          cgText, 7, -0.15, 'J', alignment=0.5, charsize=0.75
          cgText, 8, -0.15, 'S', alignment=0.5, charsize=0.75
          cgText, 9, -0.15, 'D', alignment=0.5, charsize=0.75
          cgText, 11, -0.15, 'M', alignment=0.5, charsize=0.75
          cgText, 12, -0.15, 'J', alignment=0.5, charsize=0.75
          cgText, 13, -0.15, 'S', alignment=0.5, charsize=0.75
          cgText, 14, -0.15, 'D', alignment=0.5, charsize=0.75
        endif  
        if f eq 1 then begin
          cgPlot, fake_data, /nodata, position=[0.43,0.2,0.66,.95], charsize=1, $
            /noerase, yCharsize=0.01, yRange=[-0.05,1.05], yStyle=1, xCharsize=0.01 
          cgText, 7.5, 0.9, 'NPV', alignment=0.5, charsize=1
          cgText, 2.5, -0.3, '2002', alignment=0.5, charsize=1
          cgText, 7.5, -0.3, '2007', alignment=0.5, charsize=1
          cgText, 12.5, -0.3, '2010', alignment=0.5, charsize=1
          cgText, 1, -0.15, 'M', alignment=0.5, charsize=0.75
          cgText, 2, -0.15, 'J', alignment=0.5, charsize=0.75
          cgText, 3, -0.15, 'S', alignment=0.5, charsize=0.75
          cgText, 4, -0.15, 'D', alignment=0.5, charsize=0.75
          cgText, 6, -0.15, 'M', alignment=0.5, charsize=0.75
          cgText, 7, -0.15, 'J', alignment=0.5, charsize=0.75
          cgText, 8, -0.15, 'S', alignment=0.5, charsize=0.75
          cgText, 9, -0.15, 'D', alignment=0.5, charsize=0.75
          cgText, 11, -0.15, 'M', alignment=0.5, charsize=0.75
          cgText, 12, -0.15, 'J', alignment=0.5, charsize=0.75
          cgText, 13, -0.15, 'S', alignment=0.5, charsize=0.75
          cgText, 14, -0.15, 'D', alignment=0.5, charsize=0.75
        endif  
        if f eq 2 then begin
          cgPlot, fake_data, /nodata, position=[0.66,0.2,.9,.95], charsize=1, $
            /noerase, yCharsize=0.01, yRange=[-0.05,1.05], yStyle=1, xCharsize=0.01 
          cgText, 7.5, 0.9, 'BS', alignment=0.5, charsize=1
          cgText, 2.5, -0.3, '2002', alignment=0.5, charsize=1
          cgText, 7.5, -0.3, '2007', alignment=0.5, charsize=1
          cgText, 12.5, -0.3, '2010', alignment=0.5, charsize=1
          cgText, 1, -0.15, 'M', alignment=0.5, charsize=0.75
          cgText, 2, -0.15, 'J', alignment=0.5, charsize=0.75
          cgText, 3, -0.15, 'S', alignment=0.5, charsize=0.75
          cgText, 4, -0.15, 'D', alignment=0.5, charsize=0.75
          cgText, 6, -0.15, 'M', alignment=0.5, charsize=0.75
          cgText, 7, -0.15, 'J', alignment=0.5, charsize=0.75
          cgText, 8, -0.15, 'S', alignment=0.5, charsize=0.75
          cgText, 9, -0.15, 'D', alignment=0.5, charsize=0.75
          cgText, 11, -0.15, 'M', alignment=0.5, charsize=0.75
          cgText, 12, -0.15, 'J', alignment=0.5, charsize=0.75
          cgText, 13, -0.15, 'S', alignment=0.5, charsize=0.75
          cgText, 14, -0.15, 'D', alignment=0.5, charsize=0.75
        endif  
        for s=0, 4 do begin
          where_data = WHERE(data.basin eq basin and data.source eq source[s] and data.fraction eq fraction[f], count)
          ; convert data to include NaNs and then break lines
          d = (Data.mean)[where_data]
          MyData=fltarr(15)/0
          MyData[1:4] = d[0:3]
          MyData[6:9] = d[4:7]
          MyData[11:14] = d[8:11]
          cgPlot, MyData, psym=-9, /overplot, color=color[s]
      endfor ;s 
          cgText, 0.91, 0.8, 'JRSRP', color=color[0], charsize=0.75, /normal
          cgText, 0.91, 0.65, 'CSIRO v2.2', color=color[1], charsize=0.75, /normal
          cgText, 0.91, 0.5, 'CSIRO v3.0', color=color[2], charsize=0.75, /normal
          cgText, 0.91, 0.35, 'UCLA SMA', color=color[3], charsize=0.75, /normal
          cgText, 0.91, 0.2, 'UCLA MESMA', color=color[4], charsize=0.75, /normal
    endfor ;f   
    PS_End, resize=100, /png
       
  endfor  ;basin
  
  
end
  