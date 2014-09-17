

obs = randomU(systime(1), 140)
pred = obs*1.1+.05 + randomN(systime(1)+1, 140) * 0.1
pred_all = pred
pred[100:*] = obs[100:*]*0.9-.05 + randomN(systime(1)+1, 40) * 0.1

linfit_0_99 = linfit(obs[0:99], pred[0:99])
linfit_all = linfit(obs, pred)


fname = 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\SAGE\plots\sensitivity\example_regression.png'
PS_Start, fname
  !P.multi=[0,3,1]
  cgDisplay, 1300, 400
  cgPlot, obs[0:99], pred[0:99], psym=16, color='blue', ytitle='Y', xTitle='X'
  oplot_regress, obs[0:99], pred[0:99], color='blue', thick=2, /NAN, /NO_EQUATION
  ;cgPlot, obs[100:*], pred[100:*], psym=16, color='red', /overplot
  ;oplot_regress, obs, pred, color='black', thick=2, /NAN, /NO_EQUATION
  oplot_regress, obs[0:99], pred[0:99], color='blue', thick=2, /NAN, /NO_EQUATION
  ;al_legend_stats, obs, pred, box=0, charsize=1
  al_legend_stats, obs[0:99], pred[0:99], box=0, charsize=1 
  
  cgPlot, obs[0:99], pred[0:99], psym=16, color='blue', ytitle='Y', xTitle='X'
  oplot_regress, obs[0:99], pred[0:99], color='blue', thick=2, /NAN, /NO_EQUATION
  cgPlot, obs[100:*], pred[100:*], psym=16, color='red', /overplot
  ;oplot_regress, obs, pred, color='black', thick=2, /NAN, /NO_EQUATION
  oplot_regress, obs[0:99], pred[0:99], color='blue', thick=2, /NAN, /NO_EQUATION
  ;al_legend_stats, obs, pred, box=0, charsize=1
  al_legend_stats, obs[0:99], pred[0:99], box=0, charsize=1 
  al_legend_stats, obs[100:139], pred[100:139], box=0, charsize=1, /bottom, /right
  
  cgPlot, obs[0:99], pred[0:99], psym=16, color='blue', ytitle='Y', xTitle='X'
  ;oplot_regress, obs[0:99], pred[0:99], color='blue', thick=2, /NAN, /NO_EQUATION
  cgPlot, obs[100:*], pred[100:*], psym=16, color='red', /overplot
  oplot_regress, obs, pred, color='black', thick=2, /NAN, /NO_EQUATION
  ;oplot_regress, obs[0:99], pred[0:99], color='blue', thick=2, /NAN, /NO_EQUATION
  al_legend_stats, obs, pred, box=0, charsize=1 
  ;al_legend_stats, obs[0:99], pred[0:99], box=0, charsize=1, /bottom, /right 
  al_legend_stats, obs[100:139], pred_all[100:139], box=0, charsize=1, /bottom, /right
PS_End, resize=100, /png


end 