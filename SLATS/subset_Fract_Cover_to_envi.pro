function UNMIX_OUTPUT_FNAME, day, month, year
  compile_opt idl2

  path = '\\wron\RemoteSensing\MODIS\products\Guerschman_etal_RSE2009\data\v2.2\'

  if month le 9 then app_month = '0' else app_month = ' '
  if day le 9 then app_day = '0' else app_day = ' '

  doy = JULDAY (month, day, year)  -  JULDAY (1,1,year) + 1
  if doy le 9 then app_doy = '00'
  if doy gt 9 and doy le 99 then app_doy = '0'
  if doy gt 99 then app_doy = ' '


  fname = strarr(4)


  for i=0, 3 do begin

    Case i of
      0: Band_text= 'aust.005.PV.img'
      1: Band_text= 'aust.005.NPV.img'
      2: Band_text= 'aust.005.BS.img'
      3: band_text= 'aust.005.FLAG.img'
    EndCase

    fname_i = strcompress( $
      path + $
      String (year) + '\' + $
    ; app_month + String(month) +  '.' + $
    ; app_day + String(day) +  '\' + $
      'FractCover.V2_2.' + $
      String (year) + '.' + $
      app_doy + String(doy) + '.' + $
      Band_text , $
      /REMOVE_ALL )

    fname[i] = fname_i

  EndFor

  return, fname
end

function fc_OUTPUT, day, month, year
  compile_opt idl2

  path = 'Z:\work\Juan_Pablo\PV_NPV_BS\bfast\CT_properties\ct_imgs\'

  if month le 9 then app_month = '0' else app_month = ' '
  if day le 9 then app_day = '0' else app_day = ' '

  doy = JULDAY (month, day, year)  -  JULDAY (1,1,year) + 1
  if doy le 9 then app_doy = '00'
  if doy gt 9 and doy le 99 then app_doy = '0'
  if doy gt 99 then app_doy = ' '


  fname = strarr(4)


  for i=0, 3 do begin

    Case i of
      0: Band_text= 'CT.005.PV.img'
      1: Band_text= 'CT.005.NPV.img'
      2: Band_text= 'CT.005.BS.img'
      3: band_text= 'CT.005.FLAG.img'
    EndCase

    fname_i = strcompress( $
      path + $
    ;  String (year) + '\' + $
    ; app_month + String(month) +  '.' + $
    ; app_day + String(day) +  '\' + $
      'FractCover.V2_2.' + $
      String (year) + '.' + $
      app_doy + String(doy) + '.' + $
      Band_text , $
      /REMOVE_ALL )

    fname[i] = fname_i

  EndFor

  return, fname
end


pro subset_Fract_Cover_to_envi
	compile_opt idl2

	t_elapsed = SysTime(1)
	
	envi, /restore_base_save_files
  envi_batch_init
	

	;open the following image and extract header info (particularly MAP_INFO )
	fname = 'Z:\work\Juan_Pablo\PV_NPV_BS\bfast\CT_properties\subset.img'
	ENVI_OPEN_DATA_FILE , fname , R_FID = FID
	ENVI_FILE_QUERY, FID, DATA_IGNORE_VALUE=DATA_IGNORE_VALUE, XSTART=XSTART, YSTART=YSTART, DEF_STRETCH=DEF_STRETCH, ns=ns, nl=nl
	projection = ENVI_GET_PROJECTION (FID= FID)
	MAP_INFO = ENVI_GET_MAP_INFO  ( FID=FID)


	Dates = MODIS_8d_dates()

;  date_begin = JULDAY(1,1,2009)
;  date_begin = JULDAY(1,1,2008)
  date_begin = JULDAY(1,1,2000)
  date_end = JULDAY(12,31,2012)

  where_dates = where(Dates ge date_begin and Dates le date_end, count_dates)

;	For dates_n = 6, n_elements(Dates)-1 do begin		; Starts in 6 because composites 0 to 5  don't exist
	For dates_i = 0, count_dates - 1 do begin		; update

	  dates_n=where_dates[dates_i]

		t_loop = SysTime (1)
		CALDAT, Dates[dates_n], Month, Day, Year
		print, year, month, day

		Input_file = UNMIX_OUTPUT_FNAME(day, month, year) + '.gz'
		Output_file = fc_output(day, month, year)
		Temp_file = 'C:\temp\FC_temp.img'

    for band=0,1 do begin 
      CASE band of
        0: fraction=0
        1: fraction=2
      EndCase  
      
      IF (FILE_INFO(Output_file[fraction])).exists eq 0 then begin ; don't do this if file exists
         ; get  band
        fname = Input_file[fraction]
        DATA = Get_Zipped_envi(fname, Temp_file)
    
    
          IF n_elements(DATA) eq 1 then $
          		DATA=BYTarr(ns, nl) + 255b  else $
              DATA = DATA[XSTART:XSTART+ns-1, YSTART:YSTART+NL-1]
      
        			; Saves as ENVI
        			ENVI_WRITE_ENVI_FILE, DATA, OUT_NAME = Output_file[fraction], $
        			    MAP_INFO=MAP_INFO, DATA_IGNORE_VALUE=DATA_IGNORE_VALUE, $
        			    XSTART=XSTART, YSTART=YSTART, DEF_STRETCH=DEF_STRETCH, /No_Open
      endif  			    
    endfor
  

		Print, SysTime (1) - t_loop, ' Seconds for composite ', dates_n, ' of ', count_Dates




	endfor

  ENVI_BATCH_EXIT, /no_confirm 

end

