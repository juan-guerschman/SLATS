pro write_endmembers_csv
    
    Data = read_SLATS_data_new()
    
    fname = 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\plots\sites_cover_gt_90pc.csv'
    OPENW, lun, fname, /get_lun
    
    header = 'fract_green,fract_nonGreen,fract_bare,Landsat_B1,Landsat_B2,Landsat_B3,Landsat_B4,Landsat_B5,Landsat_B6'
    printF, lun, header
    
    for i=0, n_elements(data.fCover.EXP_PV)-1 do begin
      IF  data.FCover.EXP_PV[i] GE 0.9 OR $
          data.FCover.EXP_NPV[i] GE 0.9 OR $
          data.FCover.EXP_BS[i] GE 0.9 then begin
             text=STRTRIM(data.FCover.EXP_PV[i], 2)+',' + $
                STRTRIM(data.FCover.EXP_NPV[i], 2)+',' + $
                STRTRIM(data.FCover.EXP_BS[i], 2)+',' + $
                STRTRIM(data.Landsat_QLD.B1[i], 2)+',' + $
                STRTRIM(data.Landsat_QLD.B2[i], 2)+',' + $ 
                STRTRIM(data.Landsat_QLD.B3[i], 2)+',' + $
                STRTRIM(data.Landsat_QLD.B4[i], 2)+',' + $
                STRTRIM(data.Landsat_QLD.B5[i], 2)+',' + $
                STRTRIM(data.Landsat_QLD.B6[i], 2)  
          printF, lun, text
       EndIf   
    endfor
    close, /all
end
       