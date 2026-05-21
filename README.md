# BSMSpinDensityTT
Code and results for testing BSM effects on ttbar distributions using the spin density matrix


## Form Factors

The 1-loop form factors UFO model can be found [here](./Models/Top-FormFactorsOneLoop-UFO/).


## Folders and files

Below we describe the main files and folders stored in this repository. Additional information about each folder can be found in their README files.

 * [fixForCollier.sh](fixForCollier.sh): script for making changes to a MG5 process folder in order for it to be compiled with Collier
 * [runScanMG5.py](runScanMG5.py): python code for running scans over the parameter space and generating events with MadGraph
 * [setenv.sh](setenv.sh): bash script for setting the environment variables needed for running runScanMG5.py
 * [configParserWrapper.py](configParserWrapper.py): auxiliary parser used by runScanMG5.py
  * [Cards](./Cards): stores several process and parameter cards for generating events with MadGraph
 * [auxFiles](./auxFiles): contain fixes for the MG5 makefiles required when compiling with Collier
 * [feynrules_models](./feynrules_models): stores the FeynRules files for the models
 * [UFO_models](./UFO_models): stores the UFO and FeynArts output for the models
 ---
  * [Top-FormFactorsOneLoop-UFO](./UFO_models/Top-FormFactorsOneLoop-UFO): UFO folder containing the 1-loop form factors implementation for the scalar top model.
  * [SMS_stop_NLO-UFO](./UFO_models/SMS_stop_NLO-UFO): UFO folder used to generate the (BSM) NLO events for the scalar top model.
 
