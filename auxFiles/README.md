# AuxFiles

Files used for adapting MG5 process folders to run with model functions depending on the
Collier library and using the invariant mass bias.

## Folders and files

  * [mtt_bias](./mtt_bias/): this folder should be copied to MG5/Template/LO/Source/BIAS/mtt_bias
    * [makefile](./mtt_bias/makefile): Makefile for compiling the mtt_bias.
    * [mtt_bias.f](./mtt_bias/mtt_bias.f): Fortran code for computing the mtt dependent bias

  * [Source/makefile](./Source/makefile): adapted Makefile to include the Collier library when compiling the MG5 generated process folder. It should be copied to <process_folder>/Source/makefile

* [SubProcesses/makefile](./SubProcesses/makefile): adapted Makefile to include the Collier library when compiling the MG5 generated process folder. It should be copied to <process_folder>/SubProcesses/makefile

* [MG5_aMC_v3.4.2_fix.tar.gz](./MG5_aMC_v3.4.2_fix.tar.gz): version of MG5 with minor fixes used for the event generation

* [packageX.tar.gz](./packageX.tar.gz): version of Package-X used for computing the loop integrals. Since Package-X is no longer maintained we store it
