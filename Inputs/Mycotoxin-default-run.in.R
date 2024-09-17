#Example run with default parameters
Integrate (Lsodes, 1e-4, 1e-6, 1);
OutputFile("Mycotoxin-default-run.out");

#population mean
#M_lnFgutabs = -1.2; #0.30-0.50
#M_lnkgutelim = -0.5; 
M_lnkgutabs = 1.25;
M_lnCltot = -0.98; #0.336 h-1 (-1.09); 0.5 (-0.7) from pigs
M_lnClmet = -0.98;
M_lnkufrac = -0.7; 
M_lnVdist = -1.03; #4.84  L/kg
M_lnVdistmet = -1.03; #9.05 L/kg
M_lnFgluc = -0.7;

 Simulation {
    InitDose    = 100650;    # ingested dose (ng)
    BW         = 67;      # body weight (kg)

    PrintStep(Ccpt_out, Ctot_out, Qu_out, Qu_tot_out, 0, 48, 0.1);
  }

End.
