# TK_TeA
_TK modelling for determination of the TK parameters of TeA_

The folders "Inputs" and "mycotoxin-pk-model-main" contain an application of the TK modelling algorithm developed by Prof. Weihsueh Chiu (Texas A&M University). The codes contained in the relative repository (https://github.com/wachiuphd/Mycotoxin-PK-model) were modified for the specific application to tenuazonic acid (TeA) case in collaboration with the author. The folder "iTTC" contains the codes and data files used to derive the probabilistic iTTC and apply it for risk assessment using HBM data from 5 different cohorts. The experimental data used were obtained in the context of the ERC project HuMyco (https://cordis.europa.eu/project/id/946192). 

## Files and folders
To differentiate the input files from the rest of the generated files, the input files are included in the "Inputs" folder. Nevertheless, during the computation, it is advisable to keep all files in the working directory "mycotoxin-pk-model-main" that is set in the Mycotoxin_Example.rmd file.
* Mycotoxin-PK.model is the Rfile describing the structure of the model. The file specifies all the parameters (including their population mean, variance, mean residual errors), quantities/concentrations, outputs, and interconnections between them. The structure of the model is defined as a system of differential equations that describes the movement of the compound in the different compartments while maintaining the mass balance. This file is converted to C in the "Mycotoxin-PK.model.r.c" file by the gcc compiler.
* Mycotoxin-default-run.in is the Rfile used for the deterministic simulation of the model using default parameters. Outputs are in the "Mycotoxin-default-run.out" file.
* Mycotoxin-MCMC-test-calib.in and Mycotoxin-MCMC-calib.in are Rfiles for the MCMC simulation. The model is calibrated to fit the experimental data and eventually the outputs are used to obtain the population parameters. A hierarchical Bayesian population approach is utilized. The difference between the two files is that the "test" file is used for faster simulations (generally 1000 iterations) in order to obtain preliminary results to assess the goodness of the model and check for correlation between parameters without having to run an extensive simulation. Results are stored in the .Rdata files.
* Mycotoxin_Example.rmd integrates all the preaviously described files and their generated files providing convergence and diagnostic plots. These files are stored as "DiagnosticPlots_model.calib.pdf" file or in folder "Calibration Plots" as PDF files.
  
### Before starting
The MCMC simulation is carried out using GNU MCSim, which requires Rtools (recommended version 4.0). Make sure that Rtools is correctly installed and linked.

## Mycotoxin-PK.model and modifications from original script
As preaviously mentioned, the current GitHub contains an application of the TK modelling algorithm developed by Prof. Weihsueh Chiu (original GitHub: https://github.com/wachiuphd/Mycotoxin-PK-model) which was adapted specifically to describe the toxicokinetics of TeA.
The original model (on the left) foresaw the introduction of the mycotoxin in the body through the gastrointestinal (GI) tract (_per oral_ administration). The mycotoxin could be absorbed in the central compartement (blood stream) or eliminated via the GI tract (faecal compartment). From the central compartment, the mycotoxin could be eliminated in urine or metabolized and subsequently eliminated in urine as metabolite. A toxicokinetic study conducted on TeA in human demonstrated that TeA is not eliminated via faeces. Therefore, the current model (on the right) was modified deleting the faecal compartment and assuming complete absorption through the GI tract. The model's parameters were re-defined accordingly to avoid undesired correlation between ktot, Vdist, and kgutabs. 

![Repository model](https://github.com/user-attachments/assets/8139ff67-4d38-4e4a-b0ce-dcc7e2f1b02e)

Finally, the original model describes the concentrations/quantities of mycotoxin and metabolites in the different compartments independently. However, the analysis of real samples provides quantification for unmodified TeA and total (modified + unmodified) TeA. Therefore, the model was modified to obtain as outputs the same concentrations/quantities measured experimentally.
Additional details about the toxicokinetic trial performed and collection of experimental data can be found in the paper associated with this GitHub (**submitted**).
