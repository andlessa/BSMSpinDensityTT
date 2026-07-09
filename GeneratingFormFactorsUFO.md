# Instructions for constructing a UFO model containing Form Factors

1. Generate a FeynArts Model with Counter Terms:

The first step consists in using NLOCT to generate a FeynArts model with counter terms.
An example can be found in [SMS-stop-BSM-CTs.nb](./mathematicaNBs/nlo/SMS-stop-BSM-CTs.nb).
This step allows to compute loop diagrams together with their counter-terms in order
to generate the renormalized form factors.
It is also useful for inspecting the required counter-terms and determining possible relations
between them.

2. Generating the Base UFO model:

A base model is required before the form factors are included.
In principle this should correspond to the model used to compute the counter-terms. 
However, in practice it might be useful to use a reduced/simpler model when computing the counter-terms
in order to speed up the calculation of counter-terms (i.e. a model without electroweak interactions).
The main requirement is that all parameters appearing in the form factors (BSM masses and couplings)
are also present in the base UFO model.

3. Computing the counter-terms

This can be done using the NLOCT results. However these correspond to explicit analytical expressions, what can
be quite lengthy. 
Another possibility is to compute them in terms of loop functions evaluated at specific
external momenta (as specified by the renormalization conditions). An example of how to compute the
wave function and mass counter-terms for the 2-point function can be found in [top-SelfEnergy_CT.nb](mathematicaNBs/formFactors/top-SelfEnergy_CT.nb).

3. Computing the form factors

The form factors can be computed using the FeynArts model generated in the previous steps with the help
of FeynCalc and FeynHelpers.
It might be often desirable to split the calculation into groups of loop diagrams.
Also, form factors for distinct operators (distinct particles) should be computed separately.

The calculation takes place through the following steps:

 * Generation of the relevant Feynman diagrams including the counter-terms (see [ttG_FormFactor.nb](./mathematicaNBs/formFactors/ttG_FormFactor.nb))
 * Possible simplifications and calculation of the loop integrals
 * Check that the UV divergences are indeed cancelled by the counter-terms
 * Group the loop amplitude according to its color and tensor structure
 * Define relevant functions, such as renormalized loop functions (if needed)
 * Use the function `alohaTranslator` from the package [alohaTranslator.wl](./mathematicaNBs/formFactors/alohaTranslator.wl) to translate the results to ALOHA syntax
 * Use the function `ExportUFOVertexFormFactors` from the package [UFOFormFactorExport.wl](./mathematicaNBs/formFactors/UFOFormFactorExport.wl) to format the results and write the new vertices, couplings and lorentz structures to the base UFO model

4. Defining the required loop and renormalized functions

Once the renormalized form factors have been added to the base UFO model, all functions appearing in the
form factors (defined in lorentz.py) need to be defined in the file `Fortran/functions.f` inside the UFO folder.
See [functions.f](auxFiles/Fortran/functions.f) for an example. This example makes use of the COLLIER fortran
library to numerically evaluate the required loop functions and the renormalized functions defined in the previous step.
Since these functions are evaluated many times, it is useful to cache their results.

5. Using the Model

Finally, before the user can generate events (but after the process folder has been generated),
a few changes to the process folder makefiles need to be made. This can be done simply running:

```
./fixForCollier.sh <process-folder>
```


