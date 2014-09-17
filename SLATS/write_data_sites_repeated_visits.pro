pro write_data_sites_repeated_visits

  ; LOAD DATA 
  data = read_SLATS_data()
  
  LANDSAT_Qld = data.LANDSAT_Qld
  LANDSAT_Scaling = data.LANDSAT_Scaling
  MCD43A4 = data.MCD43A4
  MOD09A1 = data.MOD09A1
  Rain = data.Rain
  Fcover = DATA.Fcover
  Rain = Data.Rain
  
  output_folder = 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\'
  n = n_elements(LANDSAT_Qld.Obs_key)
  cd, output_folder
  ; sites with revisits 
  Uniq_Sites = (LANDSAT_Qld.site)[UNIQ(LANDSAT_Qld.site, SORT(LANDSAT_Qld.site))]
  Uniq_Sites_n = intarr(n_elements(Uniq_Sites))
  for i=0, n_elements(Uniq_Sites)-1 do Uniq_Sites_n[i] = n_elements(Where(LANDSAT_Qld.site eq Uniq_Sites[i]))
  
  where_ge5 = Where(Uniq_Sites_n ge 5, count_ge5)

  fname = 'data_sites_repeated_visits.csv' 
  OPENW, lun, fname, /GET_LUN
  
  PrintF, lun, 'site, date, EXP_PV, EXP_NPV, EXP_BS'

  for n=0, count_ge5-1 do begin
    site = Uniq_Sites[where_ge5[n]]
    where_site_ = where(LANDSAT_Qld.site eq site, count_site)
      for ii=0, count_site-1 do begin
        where_site = where_site_[ii]
        print, $
            site, +',', $
            (Landsat_Qld.obs_time)[where_site],  +',',   $
            (FCover.EXP_PV)[where_site],   +',',  $
            (FCover.EXP_NPV)[where_site],  +',',   $
            (FCover.EXP_BS)[where_site]
        printF, lun, $
            site, +',', $
            (Landsat_Qld.obs_time)[where_site],  +',',   $
            (FCover.EXP_PV)[where_site],   +',',  $
            (FCover.EXP_NPV)[where_site],  +',',   $
            (FCover.EXP_BS)[where_site]
      endfor
   endfor         
              
   close, lun
end
