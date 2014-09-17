pro plots_field_data_JPg_vs_PS

  data = read_SLATS_data()

  fname = 'Z:\work\Juan_Pablo\PV_NPV_BS\New_Validation\plots\field_data_JPg_vs_PS.png'
  PS_Start, fname
    cgDisplay, 1500, 800
    !P.Multi=[0,4,2]
    cgPlot, data.fcover.Exp_PV, data.fcover_qld.totalPVcover, psym=1, color='green', xTitle='Juan method', yTitle='Peter method', Title='PV'
    cgPlot, data.fcover.Exp_NPV, data.fcover_qld.totalNPVcover, psym=1, color='red', xTitle='Juan method', yTitle='Peter method', Title='NPV'
    cgPlot, data.fcover.Exp_BS, data.fcover_qld.totalBarecover, psym=1, color='blue', xTitle='Juan method', yTitle='Peter method', Title='bare'
    cgPlot, data.fcover.Exp_PV+data.fcover.Exp_NPV+data.fcover.Exp_BS, $
            data.fcover_qld.totalPVcover+data.fcover_qld.totalNPVcover+data.fcover_qld.totalBarecover, $
            psym=1, color='black', xTitle='Juan method', yTitle='Peter method', title='PV+NPV+bare'
    
    cgPlot, data.fcover.Exp_PV, data.fcover_qld.totalPVcover+data.fcover_qld.satGroundCryptoCover, psym=1, color='green', xTitle='Juan method', yTitle='Peter method (incl crypto)'
    cgPlot, data.fcover.Exp_NPV, data.fcover_qld.totalNPVcover, psym=1, color='red', xTitle='Juan method', yTitle='Peter method'
    cgPlot, data.fcover.Exp_BS, data.fcover_qld.totalBarecover, psym=1, color='blue', xTitle='Juan method', yTitle='Peter method'
    cgPlot, data.fcover.Exp_PV+data.fcover.Exp_NPV+data.fcover.Exp_BS, $
            data.fcover_qld.totalPVcover+data.fcover_qld.totalNPVcover+data.fcover_qld.totalBarecover+data.fcover_qld.satGroundCryptoCover, $
            psym=1, color='black', xTitle='Juan method', yTitle='Peter method (incl crypto)'
  PS_End, resize=100, /png
  
end
  