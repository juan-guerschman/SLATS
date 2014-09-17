pro plot_LandsatVSModis_SAGE_unmix

cd, 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\fractional_landsat_subsets\atmosph_corrected\comparisonwithmodis'

fname_Landsat=strarr(6)
fname_MCD43A4=strarr(6)

fname_Landsat[0]='MODIS_res.FC_l5tmre_p094r083_20090522_tmpm5_mulurulu26_500pix.subset.meta'
fname_Landsat[1]='MODIS_res.FC_500m.l5tmre_p091r085_20101229_tmpm5_corr004_500pix.subset.meta'
fname_Landsat[2]='MODIS_res.FC_500m.l5tmre_p113r075_20110906_tmpm0_WA_Pilb_021_500pix.subset.meta'
fname_Landsat[3]='MODIS_res.FC_500m.l7tmre_p091r080_20121023_tmpm5_NSW052_500pix.subset.meta'
fname_Landsat[4]='MODIS_res.FC_500m.l7tmre_p091r089_20121124_tmpm5_TAS018_500pix.subset.meta'
fname_Landsat[5]='MODIS_res.FC_500m.l7tmre_p102r078_20120208_tmpm3_UMB11_500pix.subset.meta'

fname_MCD43A4[0]='MODIS_res.FC_l5tmre_p094r083_20090522_tmpm5_mulurulu26_500pix.subset.MCD43A4.meta'
fname_MCD43A4[1]='MODIS_res.FC_500m.l5tmre_p091r085_20101229_tmpm5_corr004_500pix.subset.MCD43A4.meta'
fname_MCD43A4[2]='MODIS_res.FC_500m.l5tmre_p113r075_20110906_tmpm0_WA_Pilb_021_500pix.subset.MCD43A4.meta'
fname_MCD43A4[3]='MODIS_res.FC_500m.l7tmre_p091r080_20121023_tmpm5_NSW052_500pix.subset.MCD43A4.meta'
fname_MCD43A4[4]='MODIS_res.FC_500m.l7tmre_p091r089_20121124_tmpm5_TAS018_500pix.subset.MCD43A4.meta'
fname_MCD43A4[5]='MODIS_res.FC_500m.l7tmre_p102r078_20120208_tmpm3_UMB11_500pix.subset.MCD43A4.meta'

site_name=strarr(6)
site_name[0]='mulurulu26'
site_name[1]='corr004'
site_name[2]='WA_Pilb_021'
site_name[3]='NSW052'
site_name[4]='TAS018'
site_name[5]='UMB11'

lat_lon_date=strarr(2,6)
lat_lon_date[*,0]=['143.42E, 33.33S','22 May 2009']
lat_lon_date[*,1]=['148.17E, 35.66S','13 Oct 2011']
lat_lon_date[*,2]=['117.12E, 21.61S','23 Aug 2011']
lat_lon_date[*,3]=['149.78E, 29.35S',' 9 Oct 2012']
lat_lon_date[*,4]=['146.56E, 41.62S','12 Dec 2012']
lat_lon_date[*,5]=['133.54E, 25.89S',' 5 Feb 2012']


i=0
xRange=[-0.05, 1.05]
yRange=[-0.05, 1.05]
xTitle='Landsat'
yTitle='MCD43A4'
color=['lime green','red','blue']

 ;cgDisplay, 1300, 800
 ;!P.Multi=[0,3,2]
 FOR i=0, 5 do begin
    ENVI_OPEN_FILE, fname_Landsat[i], R_FID=FID, /NO_REALIZE
    ENVI_FILE_QUERY, FID, DATA_IGNORE_VALUE=DATA_IGNORE_VALUE, XSTART=XSTART, YSTART=YSTART, DEF_STRETCH=DEF_STRETCH, ns=ns, nl=nl, nb=nb, DIMS=DIMS
    Landsat=fltarr(ns, nl, nb)
    for j=0,nb-1 do Landsat[*,*,j]=ENVI_GET_DATA(FID=FID, DIMS=DIMS, POS=j)
    ENVI_FILE_MNG, ID=FID, /REMOVE
  
    ENVI_OPEN_FILE, fname_MCD43A4[i], R_FID=FID, /NO_REALIZE
    ENVI_FILE_QUERY, FID, DATA_IGNORE_VALUE=DATA_IGNORE_VALUE, XSTART=XSTART, YSTART=YSTART, DEF_STRETCH=DEF_STRETCH, ns=ns, nl=nl, nb=nb, DIMS=DIMS
    MCD43A4=fltarr(ns, nl, nb)
    for j=0,nb-1 do MCD43A4[*,*,j]=ENVI_GET_DATA(FID=FID, DIMS=DIMS, POS=j)
    ENVI_FILE_MNG, ID=FID, /REMOVE
  
    where_ok=Where(total(Landsat, 3) ge 0.01 AND total(MCD43A4, 3) ge 0.01 , count)
    Landsat_ok=fltarr(count, 3)
    MCD43A4_ok=fltarr(count, 3)
    if count ge 1 then for j=0,2 do Landsat_ok[*,j]=(Landsat[*,*,j])[where_ok]
    if count ge 1 then for j=0,2 do MCD43A4_ok[*,j]=(MCD43A4[*,*,j])[where_ok]
  
  
  
  fname = 'scatter_Landsat_MCD43A4_'+site_name[i]+'.png'
  PS_Start, fname  
    cgDisplay, 500, 500
    cgPlot, Landsat_ok, MCD43A4_ok, psym=16, symsize=0.25, xRange=xRange, yRange=yRange, $
      xStyle=1, yStyle=1, /NoData, xTitle=xTitle, yTitle=yTitle, Title=site_name[i], $
      charsize=2, pos=[0.15,0.15,0.95,0.90]
    for j=0,2 do cgPlot, Landsat_ok[*,j], MCD43A4_ok[*,j], psym=16, symsize=0.5, color=color[j], /overplot
    cgPlot, [-1,2], [-1,2], psym=-3, /overplot
    cgText, 0,0.98, lat_lon_date[0,i], charsize=2
    cgText, 0,0.92, lat_lon_date[1,i], charsize=2
  
  PS_End, resize=100, /png
  
  endfor
  
end
  