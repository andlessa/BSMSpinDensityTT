# mathematicaNBs

Contains Mathematica notebooks with the form factors and amplitude calculations,  generation of the UFO models and more.

## Folders and files

* [amplitudes](./amplitudes/): notebooks for computing the 1-loop diagrams for $t \bar{t}$ production and the top self-energy diagram used for renormalization. It also includes he calculation of the amplitude $q \bar{q} \to t \bar{t}$ using the EFT approximation and the 1-loop diagram.

* [formFactors](./formFactors/): notebooks for computing the $t-\bar{t}-g$ and $t-\bar{t}-g-g$ 1-loop form factors. The notebooks are divided into types of diagrams (triangle, boxes,...). The notebooks automatically convert the form factors to a "UFO-like" format.

* [loadModels](./loadModels/): notebooks for loading the FeynRules models and generating the FeynArts and UFO outputs.

* [matching](./matching/): notebooks for loading the FeynRules models and generating the FeynArts and UFO outputs.

* [nlo](./nlo/): notebook for obtaining the counter-terms induced by BSM loops (ignores SM-only counter-terms). It makes use of a [simplified SM version](../modelFiles/SMQCD.fr), which includes only QCD (for better performance).

* [topEFT](./topEFT/): notebook for computing the EFT coefficients using Matchete.