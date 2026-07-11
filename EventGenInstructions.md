# MC Event Generation Instructions

The following steps are needed to generate $p p \to t(\to l^+ + \nu + b) \bar{t}(\to l^- \bar{\nu} + \bar{b})$ events with
MadGraph5 and the UFO models:

 1. [UFO_models/SMS-stop_FormFactors-UFO](./UFO_models/SMS-stop_FormFactors-UFO): model containing form factors parametrizing the BSM NLO effects in $p p \to t \bar{t}$ production (including the possibility of off-shell tops)
 2. [UFO_models/SMS-stop_NLO-UFO](./UFO_models/SMS-stop_NLO-UFO): model containing NLO counter-terms for the QCD and the BSM NLO effects in $p p \to t \bar{t}$ production.
 
## Event Generation with Form Factors

The form factors (FF) model allows to generate "leading-order" events which already include the loop corrections.
In order to include only the born and interference term ($`|\mathcal{M}_{\rm SM}|^2 + 2 Re(\mathcal{M}_{\rm SM} \mathcal{M}_{\rm BSM}^*)`$)
one must use:

```
import model UFO_models/SMS-stop_FormFactors-UFO
generate p p > t t~  NP^2<=2 QCD^2<=4 QED^2==0
```

**Every time a process folder is created, before compiling and generating events one must first run**:
```
./fixForCollier.sh <path-to-process-folder>
```
in order to replace the required files for compilation with Collier (for the evaluation of loop integrals).

### Including decays

It is possible to generate the diagrams using:

```
generate p p >  l+ vl b l- vl~ b~ / a Z b  u u~ c c~ s s~ b~ d d~ NP^2<=2 QCD^2<=4
```
or 

```
generate p p > t t~ QCD<=2 NP<=2, (t > l+ vl b), (t~ > l- vl~ b~)
```

When generating events, the following options must be set in the run_card (see [Cards/run_card_FormFactors.dat](Cards/run_card_FormFactors.dat))
```
1	= nhel
False	= hel_splitamp
```
in order to generate off-shell events using the full Form Factor expressions.



## Event Generation at NLO

The NLO model allows to generate up to the interference term correction.
In this case one must use:

```
import model UFO_models/Top-FormFactorsOneLoop-UFO
generate p p > t t~  [QCD NP] NP^2<=2 QCD^2<=4 QED^2<=0
```

When generating events one must set fixed_order = ON and edit the `SelectedCouplingOrders` entry in the FKS_params.dat card to select the desired order:

 * Born plus interference:
 ```
 #SelectedCouplingOrders (2 4 0 = born*BSM-loop, 0 4 0 = born*born)
 2
 2 4 0
 0 4 0
 ```

* Born only:
 ```
 #SelectedCouplingOrders (2 4 0 = born*BSM-loop, 0 4 0 = born*born)
 1
 0 4 0
 ```

* Interference only:
 ```
 #SelectedCouplingOrders (2 4 0 = born*BSM-loop, 0 4 0 = born*born)
 1
 2 4 0
 ```

In addition in order to generate LHE events, the FO_analyse_card must be replaced by [./Cards/FO_analyse_card_LHE.dat](./Cards/FO_analyse_card_LHE.dat)


 ### Including decays

 In this case it is not possible to generate a NLO process including the top decays directly.
 Both:
 * `generate p p >  t t~ [QCD NP], (t > l+ vl b), (t~ > l- vl~ b~)` and
 * `generate p p >  l+ vl b l- vl~ b~ / a Z b  u u~ c c~ s s~ b~ d d~ [QCD NP]`

fail when generating the process.
Therefore the only option is to use MadSpin.
