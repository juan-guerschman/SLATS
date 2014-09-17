pro create_png_Landsat_SLATS
  compile_opt idl2
  envi, /restore_base_save_files
  envi_batch_init
  
  path = 'C:\Juan_Pablo\CSIRO\PV_NPV_BS\filesForJuan\filesForJuan\less250k_pixels\'
  
  search = FILE_SEARCH(path, '*.img')
  
  for i=0, n_elements(search)-1 do begin
    fname=search[i]
  
    ENVI_OPEN_FILE , fname, R_FID = FID
    ENVI_FILE_QUERY, FID, DATA_IGNORE_VALUE=DATA_IGNORE_VALUE, XSTART=XSTART, YSTART=YSTART, DEF_STRETCH=DEF_STRETCH, ns=ns, nl=nl, DIMS=DIMS
    
    RGB = INTARR(ns, nl, 3)
    RGB[*,*,0] = Rotate(ENVI_GET_DATA(fid=fid, DIMS=DIMS, POS=5), 7)
    RGB[*,*,1] = Rotate(ENVI_GET_DATA(fid=fid, DIMS=DIMS, POS=3), 7)
    RGB[*,*,2] = Rotate(ENVI_GET_DATA(fid=fid, DIMS=DIMS, POS=2), 7)
  
    cgWindow, wxsize=ns, wysize=nl
    cgImage, RGB, /scale, /KEEP_ASPECT, /addcmd,  /NORMAL
    WID=cgQuery(/CURRENT)
    FILENAME= STRCOMPRESS(fname+'.png')
    image = cgSnapshot(FILENAME=FILENAME, wid=WID, /PNG, /NODIALOG)
    cgDelete, WID
  
  endFor
  
end

