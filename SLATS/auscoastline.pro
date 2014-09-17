function AusCoastline 
  fname='\\wron\working\work\Juan_Pablo\shapes\Australia.ASCII\Aus_coastline_1.5000000.dat'
  Aus_coast=read_ascii_file(fname, fields_are_flt = 1, delim_char = ',', SURPRESS_MSG=1)
  
  ;cgPlot, Aus_coast.lon, Aus_coast.lat, _REF_EXTRA= x 
  return, Aus_coast
end

