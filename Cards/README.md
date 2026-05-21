# Cards

MadGraph, Pythia and Delphes cards used for event generation.

## Folders and files

* [sm_tt_lo](./sm_tt_lo/): contains the cards for generating the LO Standard Model  $\bar{t} + t$ events. For consistency, it uses the form factor BSM model, but with the BSM contributions turned off.

 * [SMS-stop](./SMS-stop): contains the cards for generating events for the on-shell production of the colored scalar.

* [Top-EFT](./Top-EFT): contains the cards for generating   $\bar{t} + t$ events assuming the EFT limit ([Top-EFT model](../Models/Top-EFT-UFO))

* [Top-FormFactorsOneLoop](./Top-FormFactorsOneLoop): contains the cards for generating   $\bar{t} + t$ events using the 1-loop form factors ([Top-FormFactorsOneLoop model](../Models/Top-FormFactorsOneLoop-UFO))

* [delphes_card_trimmed](./delphes_card_trimmed.dat): Delphes card used for recasting the CMS-EXO-20-004 search (ISR jets plus MET)

* [delphes_card](./delphes_card.dat): default Delphes card

* [madspin_card](./madspin_card.dat): MadSpin card for decaying one top leptonically and the other hadronically. *Note that the full semi-leptonic BR should include a factor of 2: $BR = (t \to l,\nu,b),(\bar{t} \to q,\bar{q},\bar{b})$ + $(t \to q,\bar{q}+b),(\bar{t} \to l,\nu,\bar{b})$! So the events should be rescaled by this factor.*

* [pythia8_card](./pythia8_card.dat): Pythia 8 card used for recasting the CMS-EXO-20-004 search (ISR jets plus MET)

* [run_card_bias](./run_card_bias.dat): run_card for generating $\bar{t} + t$ events with the [invariant mass bias](../auxFiles/mtt_bias)

* [run_card](./run_card.dat): default run_card