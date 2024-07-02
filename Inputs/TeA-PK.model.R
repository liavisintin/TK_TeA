# Tenuazonic acid model

States  = { 
  Q_GI,       # Quantity of mycotoxin in the GI compartment (nmol)
  Qcpt,       # Quantity in central compartment (nmol)
  Qu,     # Quantity of mycotoxin in urine (nmol)
  Qmet,   # Quantity of metabolite central compartment (nmol)
  Qu_met,     # Quantity of metabolite in urine (nmol)
  AUC,         # AUC of central compartment (nmol-hr/L)
};  

Outputs = {
  Ccpt, # Central compartment concentration
  Ctot, # Central compartment metabolite + parent concentration
  Ccpt_out, # Central compartment concentration (truncated at 1e-15)
  Ctot_out, # Central compartment metabolite concentration (truncated at 1e-15)
  Qu_out, # Amount excreted in urine (truncated at 1e-15)
  Qu_tot, #Amount of total TeA excreted in urine
  Qu_tot_out # Amount of total TeA excreted in urine (truncated at 1e-15)
};

#population mean
M_lnkufrac = -1.20; # Fraction of elimination that is urine
M_lnVdist = 0; # Volume of distribution (L/kg)
M_lnVdistmet = 0; # Volume of distribution for metabolite (L/kg)
M_lnkgutabs = 0;
M_lnFgluc = -0.7;
M_lnCltot = 0;
M_lnClmet = 0;

#population variance
SD_lnkufrac = 0.2;
SD_lnVdist = 0.2; 
SD_lnVdistmet = 0.2; 
SD_lnkgutabs = 0.2;
SD_lnFgluc = 0.2;
SD_lnCltot = 0.2;
SD_lnClmet = 0.2;

#individual log transformed, z-score
lnkufrac = 0;
lnVdist = 0; 
lnVdistmet = 0; 
lnkgutabs = 0;
lnFgluc = 0;
lnCltot = 0;
lnClmet =0;

#individual parameters

# Oral input modeling
InitDose    = 100; # ingested input at t=0 (nmol)
ConstDoseRate = 0; # Constant dose rate per hour (nmol/h) 
kgutabs    = 0.35; # Intestinal absorption rate (/h); kgutelim * Fgutabs/(1-Fgutabs)
Fgluc = 0.5;
Cltot = 0.5;
Clmet = 0.5;

# Distribution volumes (L/kg)
Vdist = 1.0;
Vdistmet = 1.0;

# Body weight (kg)
BW = 70;

# Elimination rate constants (/h)
ku       = 0.1;     # Urinary excretion rate constant 
ku_tmp   = 0.1;     # Set it to avoid the value geq ktot
kmet       = 0.2;   # Metabolism rate constant 
kgutelim   = 0.35;     #gut elimination rate

#GSD - Mesidual errors
GSD_Ccpt = 1.1; # Central compartment concentration
GSD_Ctot = 1.1; # Central compartment metabolite concentration
GSD_Qu = 1.1;  # Amount excreted in urine
GSD_Q_fec = 1.1;  # Amount excreted in feces
GSD_Qu_tot = 1.1; # Amount of metabolite excreted in urine

Initialize {
  Q_GI = InitDose;
  kgutabs = exp(M_lnkgutabs + SD_lnkgutabs * lnkgutabs);
  Cltot = exp(M_lnCltot + SD_lnCltot * lnCltot);
  Clmet = exp(M_lnClmet + SD_lnClmet * lnClmet);
  Fgluc = exp(M_lnFgluc + SD_lnFgluc * lnFgluc);
  Vdist = exp(M_lnVdist + SD_lnVdist * lnVdist);
  ku_tmp = (Cltot/Vdist) * exp(M_lnkufrac + SD_lnkufrac * lnkufrac);
  ku = (ku_tmp > (0.99*Cltot/Vdist)) ? (0.99*Cltot/Vdist) : ku_tmp;
  kmet = (Cltot/Vdist) - ku;
  Vdistmet = exp(M_lnVdistmet + SD_lnVdistmet * lnVdistmet);
}

Dynamics { 
  dt (Q_GI)  = ConstDoseRate - Q_GI * kgutabs;
  dt (Qcpt) = Q_GI * kgutabs - Qcpt * (ku + kmet);
  dt (Qu) = Qcpt * ku;
  dt (Qmet) = Qcpt * kmet * Fgluc - Qmet * (Clmet/Vdistmet);
  dt (Qu_met) = Qmet * (Clmet/Vdistmet);
  dt (AUC) = Qcpt/(Vdist*BW);
}

CalcOutputs { # truncate at Q values of 1e-15
  Ccpt = Qcpt / (1000*Vdist*BW);
  Ctot = Ccpt + Qcpt / (1000*Vdistmet*BW);
  Ccpt_out = (Ccpt < 1e-15 ? 1e-15 : Ccpt);
  Ctot_out = (Ctot < 1e-15 ? 1e-15 : Ctot);
  Qu_out = (Qu < 1e-15 ? 1e-15 : Qu);
  Qu_tot = Qu_met + Qu;
  Qu_tot_out = (Qu_tot < 1e-15 ? 1e-15 : Qu_tot);
}

End.