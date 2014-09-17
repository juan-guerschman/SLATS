; docformat = 'rst'
;+
; this is built on Density_plot from David Fanning
;
;-
PRO Density_Plot_reflectances, data=data
 
    CD, 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\Reflectance_density\' 
    fname = 'density_RED_NIR_SWIR_2008_2009.SAV' 
    RESTORE, fname
    
    ; get rid of all points with less than 100 pixels
    array *= array ge 100
 
  ; LOAD SLATS DATA 
  if Keyword_Set(data) eq 0 then $
    Data = read_SLATS_data_new()
  
  MCD43A4 = data.MCD43A4
  abares = Where(data.Field_All.source eq 'abares', complement=notAbares)
 
   ; Set up variables for the plot. Normally, these values would be 
   ; passed into the program as positional and keyword parameters.
   x = lindgen(101)
   y = lindgen(101)
   xrange = [Min(x), Max(x)]
   yrange = [Min(y), Max(y)]
   xbinsize = 0.01
   ybinsize = 0.01
   
   fname = 'density_RED_NIR_SWIR_2008_2009_SLATS_points.png' 
   PS_Start, fname
     ; Open a display window.
     cgDisplay, 1200, 500
     !P.multi=[0,3,1]
     
     ; Create the density plot by binning the data into a 2D histogram.
     DIMENSION=3
     density = ALOG10(Total(array, dimension)+1)                        
  ;   density = Total(array, dimension)                        
                             
     maxDensity = Ceil(Max(density))
     print, maxDensity
     scaledDensity = BytScl(density, Min=2, Max=maxDensity)
                             
     ; Load the color table for the display. All zero values will be gray.
     cgLoadCT, 33
     TVLCT, cgColor('gray', /Triple), 0
     TVLCT, r, g, b, /Get
     palette = [ [r], [g], [b] ]
     
     ; Display the density plot.
     cgImage, scaledDensity, XRange=xrange, YRange=yrange, /Axes, Palette=palette, $
        XTitle='reflectance RED [%]', YTitle='reflectance NIR [%]', $
        Position=[0.125, 0.125, 0.9, 0.8]
        
;     thick = (!D.Name EQ 'PS') ? 6 : 2
     thick = 1
     cgContour, density, LEVELS=[2,4,6], /OnImage, $
         C_Colors=['white','white', 'white'],   $
         C_Thick=thick, C_CharThick=thick
        
     ; Display a color bar.
     cgColorbar, Position=[0.125, 0.875, 0.9, 0.925], Title='Logarithm of Density', $
         Range=[2, maxDensity], NColors=254, Bottom=1, OOB_Low='gray', $
         TLocation='Top'
         
     ; display dots on top 
     cgPlot, (MCD43A4.b1)*0.01, (MCD43A4.b2)*0.01 , psym=1, symsize=0.25, color='black', /overplot
     cgPlot, (MCD43A4.b1)[abares]*0.01, (MCD43A4.b2)[abares]*0.01 , psym=1, symsize=0.25, color='black', /overplot
  
  
     ; Create the density plot by binning the data into a 2D histogram.
     DIMENSION = 2                        
     density = ALOG10(Total(array, dimension)+1)                        
  ;   density = Total(array, dimension)                        
                             
     maxDensity = Ceil(Max(density))
     print, maxDensity
     scaledDensity = BytScl(density, Min=2, Max=maxDensity)
                             
     ; Load the color table for the display. All zero values will be gray.
     cgLoadCT, 33
     TVLCT, cgColor('gray', /Triple), 0
     TVLCT, r, g, b, /Get
     palette = [ [r], [g], [b] ]
     
     ; Display the density plot.
     cgImage, scaledDensity, XRange=xrange, YRange=yrange, /Axes, Palette=palette, $
        XTitle='reflectance RED [%]', YTitle='reflectance SWIR [%]', $
        Position=[0.125, 0.125, 0.9, 0.8]
        
;     thick = (!D.Name EQ 'PS') ? 6 : 2
     cgContour, density, LEVELS=[2,4,6], /OnImage, $
         C_Colors=['white','white', 'white'],   $
         C_Thick=thick, C_CharThick=thick
        
     ; Display a color bar.
     cgColorbar, Position=[0.125, 0.875, 0.9, 0.925], Title='Logarithm of Density', $
         Range=[2, maxDensity], NColors=254, Bottom=1, OOB_Low='gray', $
         TLocation='Top'
         
     ; display dots on top 
     cgPlot, (MCD43A4.b1)*0.01, (MCD43A4.b7)*0.01 , psym=1, symsize=0.25, color='black', /overplot
     cgPlot, (MCD43A4.b1)[abares]*0.01, (MCD43A4.b7)[abares]*0.01 , psym=1, symsize=0.25, color='black', /overplot
  
  
     ; Create the density plot by binning the data into a 2D histogram.
     DIMENSION = 1                        
     density = ALOG10(Total(array, dimension)+1)                        
  ;   density = Total(array, dimension)                        
                             
     maxDensity = Ceil(Max(density))
     print, maxDensity
     scaledDensity = BytScl(density, Min=2, Max=maxDensity)
                             
     ; Load the color table for the display. All zero values will be gray.
     cgLoadCT, 33
     TVLCT, cgColor('gray', /Triple), 0
     TVLCT, r, g, b, /Get
     palette = [ [r], [g], [b] ]
     
     ; Display the density plot.
     cgImage, scaledDensity, XRange=xrange, YRange=yrange, /Axes, Palette=palette, $
        XTitle='reflectance NIR [%]', YTitle='reflectance SWIR [%]', $
        Position=[0.125, 0.125, 0.9, 0.8]
        
;     thick = (!D.Name EQ 'PS') ? 6 : 2
     cgContour, density, LEVELS=[2,4,6], /OnImage, $
         C_Colors=['white','white', 'white'],   $
         C_Thick=thick, C_CharThick=thick
        
     ; Display a color bar.
     cgColorbar, Position=[0.125, 0.875, 0.9, 0.925], Title='Logarithm of Density', $
         Range=[2, maxDensity], NColors=254, Bottom=1, OOB_Low='gray', $
         TLocation='Top'
         
     ; display dots on top 
     cgPlot, (MCD43A4.b2)*0.01, (MCD43A4.b7)*0.01 , psym=1, symsize=0.25, color='black', /overplot
     cgPlot, (MCD43A4.b2)[abares]*0.01, (MCD43A4.b7)[abares]*0.01 , psym=1, symsize=0.25, color='black', /overplot
   PS_End, resize=100, /PNG  
       
END ;*****************************************************************

; This main program shows how to call the program and produce
; various types of output.

  ; Display the plot in a graphics window.
  Density_Plot
  
  ; Display the plot in a resizeable graphics window.
  cgWindow, 'Density_Plot', Background='White', $
     WTitle='Density Plot in a Resizeable Graphics Window'
  
  ; Create a PostScript file.
  PS_Start, 'density_plot.ps'
  Density_Plot
  PS_End
  
  ; Create a PNG file with a width of 600 pixels.
  cgPS2Raster, 'density_plot.ps', /PNG, Width=600

END