# TK_TeA
_TK modelling for determination of the TK parameters of TeA_

The folders "Inputs" and "mycotoxin-pk-model-main" contain an application of the TK modelling algorithm developed by Prof. Weihsueh Chiu (Texas A&M University). The codes contained in the relative repository (https://github.com/wachiuphd/Mycotoxin-PK-model) were modified for the specific application to tenuazonic acid (TeA) case in collaboration with the author. The folder "iTTC" contains the codes and data files used to derive the probabilistic iTTC and apply it for risk assessment using HBM data from 5 different cohorts. The experimental data used were obtained in the context of the ERC project HuMyco (https://cordis.europa.eu/project/id/946192). 

## Files and folders
To differentiate the input files from the rest of the generated files, the input files are included in the "Inputs" folder. Nevertheless, during the computation, it is advisable to keep all files in the working directory "mycotoxin-pk-model-main" that is set in the Mycotoxin_Example.rmd file.
* Mycotoxin-PK.model.R is the Rfile describing the structure of the model. The file specifies all the parameters (including their population mean, variance, mean residual errors), quantities/concentrations, outputs, and interconnections between them. The structure of the model is defined as a system of differential equations that describes the movement of the compound in the different compartments while maintaining the mass balance. This file is converted to C in the "Mycotoxin-PK.model.r.c" file by the gcc compiler.
* Mycotoxin-default-run.in.R is the Rfile used for the deterministic simulation of the model using default parameters. Outputs are in the "Mycotoxin-default-run.out" file.
* Mycotoxin-MCMC-test-calib.in.R and Mycotoxin-MCMC-calib.in are Rfiles for the MCMC simulation. The model is calibrated to fit the experimental data and eventually the outputs are used to obtain the population parameters. A hierarchical Bayesian population approach is utilized. The difference between the two files is that the "test" file is used for faster simulations (generally 1000 iterations) in order to obtain preliminary results to assess the goodness of the model and check for correlation between parameters without having to run an extensive simulation. Results are stored in the .Rdata files.
* Mycotoxin_Example.rmd integrates all the preaviously described files and their generated files providing convergence and diagnostic plots. These files are stored as "DiagnosticPlots_model.calib.pdf" file or in folder "Calibration Plots" as PDF files.
  
### Before starting
The MCMC simulation is carried out using GNU MCSim, which requires Rtools (recommended version 4.0). Make sure that Rtools is correctly installed and linked.

## Mycotoxin-PK.model and modifications from original script
As preaviously mentioned, the current GitHub contains an application of the TK modelling algorithm developed by Prof. Weihsueh Chiu (original GitHub: https://github.com/wachiuphd/Mycotoxin-PK-model) which was adapted specifically to describe the toxicokinetics of TeA.
The original model (on the left) foresaw the introduction of the mycotoxin in the body through the gastrointestinal (GI) tract (_per oral_ administration). The mycotoxin could be absorbed in the central compartement (blood stream) or eliminated via the GI tract (faecal compartment). From the central compartment, the mycotoxin could be eliminated in urine or metabolized and subsequently eliminated in urine as metabolite. A toxicokinetic study conducted on TeA in human demonstrated that TeA is not eliminated via faeces. Therefore, the current model (on the right) was modified deleting the faecal compartment and assuming complete absorption through the GI tract. The model's parameters were re-defined accordingly to avoid undesired correlation between ktot, Vdist, and kgutabs. 

![Repository model](https://github.com/user-attachments/assets/8139ff67-4d38-4e4a-b0ce-dcc7e2f1b02e)

Finally, the original model describes the concentrations/quantities of mycotoxin and metabolites in the different compartments independently. However, the analysis of real samples provides quantification for unmodified TeA and total (modified + unmodified) TeA. Therefore, the model was modified to obtain as outputs the same concentrations/quantities measured experimentally.Additional details about the toxicokinetic trial performed and collection of experimental data can be found in the paper associated with this GitHub (**submitted**).

__Original model__
```
CalcOutputs { 
  Ccpt = Qcpt / (1000*Vdist*BW);
  Cmet = Qmet / (1000*Vdistmet*BW);
  Ccpt_out = (Ccpt < 1e-15 ? 1e-15 : Ccpt);
  Cmet_out = (Cmet < 1e-15 ? 1e-15 : Cmet);
  Qu_out = (Qu < 1e-15 ? 1e-15 : Qu);
  Q_fec_out = (Q_fec < 1e-15 ? 1e-15 : Q_fec);
  Qu_met_out = (Qu_met < 1e-15 ? 1e-15 : Qu_met);
}
```
__TeA model__
```
CalcOutputs { 
  Ccpt = Qcpt / (1000*Vdist*BW);
  Ctot = Ccpt + Qmet / (1000*Vdistmet*BW);
  Ccpt_out = (Ccpt < 1e-15 ? 1e-15 : Ccpt);
  Ctot_out = (Ctot < 1e-15 ? 1e-15 : Ctot);
  Qu_out = (Qu < 1e-15 ? 1e-15 : Qu);
  Qu_tot = Qu_met + Qu;
  Qu_tot_out = (Qu_tot < 1e-15 ? 1e-15 : Qu_tot);
}
```

## Setup Mycotoxin-default-run.in.R
To performed a deterministic simulation, it is necessary to provide intial dose and body weight. The script will provide a simulation for the different outputs over a timeframe of 48 hours with steps of 0.1 hours, as specified by the function PrintStep. At the head of the script, the population mean of the different pharmaco-/toxicokinetic parameters can be specified. If not specified, the model is ran using the parameters set in the model file.

```
Simulation {
    InitDose    = 100;    # ingested dose (ng)
    BW         = 60;      # body weight (kg)

    PrintStep(Ccpt_out, Cmet_out, Qu_out, Qu_met_out, Q_fec_out, 0, 48, 0.1);
  }

```
## Setup Mycotoxin-MCMC-test-calib.in.R and Mycotoxin-MCMC-calib.in
These scripts contain 2 parts:
* MCMC simulation specifics: this part defines the output file, number of iterations, printing frequency, iters to print, and initial random seed.
* population simulation: this part contains other 3 parts
  * Level (population): defines the distributions for population parameters' mean, standard deviation, error, and the likelihood of the outputs.
  * level (individual): defines the distributions of the individual parameters.
  * Simulation: every simulation corresponds to one subject. For each subject, the script needs to be added with the dose, the body weight, and the experimental data obtained for each time point. The last part of the simulation is similar to the one of the deterministic simulation whihc specifies the outputs that are simulated over a timeframe of 48 hours with steps of 0.1 hours.

```
Integrate (Lsodes, 1e-4, 1e-6, 1);

MCMC ("MCMC.default.out","",  # name of output and restart file
      "",                     # name of data file
      11000,0,                 # iterations, print predictions flag,
      10,11000,                 # printing frequency, iters to print
      10101010);              # random seed

Level { #population
# Ditributions M, SD, GSD of model's parameters
# Likelihood outputs

  Level { # individual
  #Distributions individual parameters

       Simulation { # one simulation for each subject
      #Subject 1
      InitDose    = 100;    # ingested dose (ng)
      BW         = 60;      # body weight (kg)
      
      Print(Ccpt_out, 0.25, 0.5, 1, 2, 4, 6, 8); # timepoint of sample collection
      Data(Ccpt_out, 0.22, 0.32, 0.26, 0.26, 0.37, 0.11, 0.024); # experimental blood concentration
      PrintStep(Ccpt, Qu, Qu_met, Q_fec, Cmet, 0, 48, 0.1); # simulation
      Print(AUC, 48);
    }
  }
}
End.
```

## How to run the scripts
The file Mycotoxin_Example.rmd is to be considered as a command console. The codes contained in this file automatically refer to the files described above.

