# FeynRules Model Files

Hold the FeynRules files for distinct model implementations


## Models Description

### UV Simplified Model (SMS-stop)

 * The model is defined in [modelFiles/SMS-stop.fr](./modelFiles/SMS-stop.fr)

We consider the simple case of a scalar top partner ($\phi_T$), singlet under $SU(2)_L$, and a singlet fermion ($\chi$),
which is a Dark Matter candidate. In addition we impose a $\mathcal{Z}_2$ symmetry, under which the BSM fields are odd and the SM are even. Under this assumptions the renormalizable (UV) BSM lagrangian is:

```math
    \mathcal{L}_{SMS} = \bar{\chi}\left( i \gamma^\mu \partial_\mu -\frac{1}{2} m_{\chi} \right) \chi + |D_\mu \phi_T|^2 - m_{T}^2 |\phi_T|^2 - y_{\mathrm{DM}} \phi_T^\dagger \bar{\chi} t_R + G_\mu^A \bar{t} \gamma^\mu T^A \left( P_L \delta_{CT,L} + P_R \delta_{CT,R} \right) t
```

where the terms $\delta_{CT,a}$ correspond to the counter-terms (in the on-shell renormalization scheme) for the $t-t-g$ coupling (computed using [NLOCT](https://arxiv.org/abs/1406.3030)) needed for the loop calculations and are functions of $m_T,m_{\chi},m_t$. Note that this is the only divergence which needs to be taken care of at 1-loop.
In addition we assume $m_T > m_{\chi}$, so the DM candidate is stable.

### Top Couplings with Form Factors (Top-FormFactors)

 * The model is defined in [modelFiles/Top-FormFactors.fr](./modelFiles/Top-FormFactors.fr)


The model includes the dim-6 EFT operators in the *off-shell* (Green) basis relevant for $q q \to t \bar{t}$ production.  and corresponds to the lagrangian:

```math
    \begin{aligned}
      \mathcal{L}_{FF} = \mathcal{L}_{SMS} + & i A_1\ \bar{t}_R \gamma^\mu D_\mu t_R\\
     + & \frac{i}{2} A_2\ \bar{t}_R \gamma^\mu \left( D^\nu D_\nu D_\mu + D_\mu D^\nu D_\nu \right)  t_R \\
     + &A_3\ D^\nu G_{\mu \nu}^A \bar{t}_R T^A \gamma^\mu t_R \\
     + & G_\mu^A \bar{t} \gamma^\mu T^A \left( P_L \delta_{CT,L} + P_R \delta_{CT,R} \right) t
    \end{aligned}
```

The operator coefficients ($A_i$) are supposed to be replaced by form factors, so the full one loop calculation is reproduced.
The UFO version of this implementation can be found [here](./Models/Top-FormFactors-UFO/lorentz_oneloop.py), where the tops in the $t-t-g$ vertex are assumed to be off-shell and the $t-t-g-g$ vertex is given by the 1-loop diagrams (with on-shell tops ang gluons). It provides the full 1-loop results for $q \bar{q} \to t \bar{t}$ and  $g g \to t \bar{t}$ production.


### Top EFT (Top-EFT)

 * The model is defined in [modelFiles/Top-EFT.fr](./modelFiles/Top-EFT.fr)

The model includes the dim-6 EFT operators in the *physical* (on-shell) basis relevant for $q q \to t \bar{t}$ production. The model lagrangian is:

```math
    \mathcal{L}_{ttG} = \mathcal{L}_{SMS} + i A_0\ G_{\mu\nu} \bar{t} \Gamma^{\mu\nu} t + 6 B_0 \left( \bar{t}_R T^A \gamma^\mu t_R \bar{q} T^A \gamma_\mu q \right)
```

where $\Gamma^{\mu\nu} = \frac{1}{2} \left[ \gamma^\mu, \gamma^\nu \right]$ The coefficients $A_0$ and $B_0$ are defined as a function of the heavy BSM masses ($m_T,m_{\chi}$) in the EFT limit: $m_T,m_{\chi} \gg m_t,\hat{s}$.

## Files

* [DiagonalCKM](./DiagonalCKM.rst): restriction file for a diagonal CKM matrix

* [LorentzTadpole](./LorentzTadpole.gen): generic model file for FeynArts needed for NLO calculations

* [Massless](./Massless.rst): restriction file for massless quarks

* [Massless](./Massless.rst): restriction file for massless quarks

* [SM](./SM.fr): full SM model file

* [SMQCD](./SMQCD.fr): simplified SM model file containing only QCD and quarks

* [SMS-stop](./SMS-stop.fr): UV BSM model with a scalar top partner and a fermionic DM candidate

* [Top-EFT](./Top-EFT.fr): model file with the relevant EFT operators and the coefficient values.

* [Top-FormFactors](./Top-EFT.fr): model file with relevant counter-terms and some dim6 operators. This model is supposed to be used to generate a basic UFO model, which then can be modified to include form factors.


