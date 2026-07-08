# This file was automatically created by FeynRules 2.3.49
# Mathematica version: 12.1.0 for Linux x86 (64-bit) (March 18, 2020)
# Date: Thu 14 Sep 2023 16:14:46


from object_library import all_decays, Decay
import particles as P


Decay_b = Decay(name = 'Decay_b',
                particle = P.b,
                partial_widths = {(P.W__minus__,P.t):'(((3*ee**2*MB**2)/(2.*sw**2) + (3*ee**2*MT**2)/(2.*sw**2) + (3*ee**2*MB**4)/(2.*MW**2*sw**2) - (3*ee**2*MB**2*MT**2)/(MW**2*sw**2) + (3*ee**2*MT**4)/(2.*MW**2*sw**2) - (3*ee**2*MW**2)/sw**2)*cmath.sqrt(MB**4 - 2*MB**2*MT**2 + MT**4 - 2*MB**2*MW**2 - 2*MT**2*MW**2 + MW**4))/(96.*cmath.pi*abs(MB)**3)'})

Decay_P__tilde__chi = Decay(name = 'Decay_P__tilde__chi',
                            particle = P.P__tilde__chi,
                            partial_widths = {(P.P__tilde__ST__tilde__,P.t):'((3*mChi**2*yDM**2 - 3*mST**2*yDM**2 + 3*MT**2*yDM**2)*cmath.sqrt(mChi**4 - 2*mChi**2*mST**2 + mST**4 - 2*mChi**2*MT**2 - 2*mST**2*MT**2 + MT**4))/(32.*cmath.pi*abs(mChi)**3)',
                                              (P.P__tilde__ST,P.t__tilde__):'((3*mChi**2*yDM**2 - 3*mST**2*yDM**2 + 3*MT**2*yDM**2)*cmath.sqrt(mChi**4 - 2*mChi**2*mST**2 + mST**4 - 2*mChi**2*MT**2 - 2*mST**2*MT**2 + MT**4))/(32.*cmath.pi*abs(mChi)**3)'})

Decay_H = Decay(name = 'Decay_H',
                particle = P.H,
                partial_widths = {(P.b,P.b__tilde__):'((-12*MB**2*yb**2 + 3*MH**2*yb**2)*cmath.sqrt(-4*MB**2*MH**2 + MH**4))/(16.*cmath.pi*abs(MH)**3)',
                                  (P.ta__minus__,P.ta__plus__):'((MH**2*ytau**2 - 4*MTA**2*ytau**2)*cmath.sqrt(MH**4 - 4*MH**2*MTA**2))/(16.*cmath.pi*abs(MH)**3)',
                                  (P.t,P.t__tilde__):'((3*MH**2*yt**2 - 12*MT**2*yt**2)*cmath.sqrt(MH**4 - 4*MH**2*MT**2))/(16.*cmath.pi*abs(MH)**3)',
                                  (P.W__minus__,P.W__plus__):'(((3*ee**4*vev**2)/(4.*sw**4) + (ee**4*MH**4*vev**2)/(16.*MW**4*sw**4) - (ee**4*MH**2*vev**2)/(4.*MW**2*sw**4))*cmath.sqrt(MH**4 - 4*MH**2*MW**2))/(16.*cmath.pi*abs(MH)**3)',
                                  (P.Z,P.Z):'(((9*ee**4*vev**2)/2. + (3*ee**4*MH**4*vev**2)/(8.*MZ**4) - (3*ee**4*MH**2*vev**2)/(2.*MZ**2) + (3*cw**4*ee**4*vev**2)/(4.*sw**4) + (cw**4*ee**4*MH**4*vev**2)/(16.*MZ**4*sw**4) - (cw**4*ee**4*MH**2*vev**2)/(4.*MZ**2*sw**4) + (3*cw**2*ee**4*vev**2)/sw**2 + (cw**2*ee**4*MH**4*vev**2)/(4.*MZ**4*sw**2) - (cw**2*ee**4*MH**2*vev**2)/(MZ**2*sw**2) + (3*ee**4*sw**2*vev**2)/cw**2 + (ee**4*MH**4*sw**2*vev**2)/(4.*cw**2*MZ**4) - (ee**4*MH**2*sw**2*vev**2)/(cw**2*MZ**2) + (3*ee**4*sw**4*vev**2)/(4.*cw**4) + (ee**4*MH**4*sw**4*vev**2)/(16.*cw**4*MZ**4) - (ee**4*MH**2*sw**4*vev**2)/(4.*cw**4*MZ**2))*cmath.sqrt(MH**4 - 4*MH**2*MZ**2))/(32.*cmath.pi*abs(MH)**3)'})

Decay_P__tilde__ST = Decay(name = 'Decay_P__tilde__ST',
                           particle = P.P__tilde__ST,
                           partial_widths = {(P.t,P.P__tilde__chi):'((-3*mChi**2*yDM**2 + 3*mST**2*yDM**2 - 3*MT**2*yDM**2)*cmath.sqrt(mChi**4 - 2*mChi**2*mST**2 + mST**4 - 2*mChi**2*MT**2 - 2*mST**2*MT**2 + MT**4))/(48.*cmath.pi*abs(mST)**3)'})

Decay_t = Decay(name = 'Decay_t',
                particle = P.t,
                partial_widths = {(P.P__tilde__ST,P.P__tilde__chi):'((3*mChi**2*yDM**2 - 3*mST**2*yDM**2 + 3*MT**2*yDM**2)*cmath.sqrt(mChi**4 - 2*mChi**2*mST**2 + mST**4 - 2*mChi**2*MT**2 - 2*mST**2*MT**2 + MT**4))/(96.*cmath.pi*abs(MT)**3)',
                                  (P.W__plus__,P.b):'(((3*ee**2*MB**2)/(2.*sw**2) + (3*ee**2*MT**2)/(2.*sw**2) + (3*ee**2*MB**4)/(2.*MW**2*sw**2) - (3*ee**2*MB**2*MT**2)/(MW**2*sw**2) + (3*ee**2*MT**4)/(2.*MW**2*sw**2) - (3*ee**2*MW**2)/sw**2)*cmath.sqrt(MB**4 - 2*MB**2*MT**2 + MT**4 - 2*MB**2*MW**2 - 2*MT**2*MW**2 + MW**4))/(96.*cmath.pi*abs(MT)**3)'})

Decay_ta__minus__ = Decay(name = 'Decay_ta__minus__',
                          particle = P.ta__minus__,
                          partial_widths = {(P.W__minus__,P.vt):'((MTA**2 - MW**2)*((ee**2*MTA**2)/(2.*sw**2) + (ee**2*MTA**4)/(2.*MW**2*sw**2) - (ee**2*MW**2)/sw**2))/(32.*cmath.pi*abs(MTA)**3)'})

Decay_W__plus__ = Decay(name = 'Decay_W__plus__',
                        particle = P.W__plus__,
                        partial_widths = {(P.c,P.s__tilde__):'(ee**2*MW**4)/(16.*cmath.pi*sw**2*abs(MW)**3)',
                                          (P.t,P.b__tilde__):'(((-3*ee**2*MB**2)/(2.*sw**2) - (3*ee**2*MT**2)/(2.*sw**2) - (3*ee**2*MB**4)/(2.*MW**2*sw**2) + (3*ee**2*MB**2*MT**2)/(MW**2*sw**2) - (3*ee**2*MT**4)/(2.*MW**2*sw**2) + (3*ee**2*MW**2)/sw**2)*cmath.sqrt(MB**4 - 2*MB**2*MT**2 + MT**4 - 2*MB**2*MW**2 - 2*MT**2*MW**2 + MW**4))/(48.*cmath.pi*abs(MW)**3)',
                                          (P.u,P.d__tilde__):'(ee**2*MW**4)/(16.*cmath.pi*sw**2*abs(MW)**3)',
                                          (P.ve,P.e__plus__):'(ee**2*MW**4)/(48.*cmath.pi*sw**2*abs(MW)**3)',
                                          (P.vm,P.mu__plus__):'(ee**2*MW**4)/(48.*cmath.pi*sw**2*abs(MW)**3)',
                                          (P.vt,P.ta__plus__):'((-MTA**2 + MW**2)*(-(ee**2*MTA**2)/(2.*sw**2) - (ee**2*MTA**4)/(2.*MW**2*sw**2) + (ee**2*MW**2)/sw**2))/(48.*cmath.pi*abs(MW)**3)'})

Decay_Z = Decay(name = 'Decay_Z',
                particle = P.Z,
                partial_widths = {(P.b,P.b__tilde__):'((-7*ee**2*MB**2 + ee**2*MZ**2 - (3*cw**2*ee**2*MB**2)/(2.*sw**2) + (3*cw**2*ee**2*MZ**2)/(2.*sw**2) - (17*ee**2*MB**2*sw**2)/(6.*cw**2) + (5*ee**2*MZ**2*sw**2)/(6.*cw**2))*cmath.sqrt(-4*MB**2*MZ**2 + MZ**4))/(48.*cmath.pi*abs(MZ)**3)',
                                  (P.c,P.c__tilde__):'(MZ**2*(-(ee**2*MZ**2) + (3*cw**2*ee**2*MZ**2)/(2.*sw**2) + (17*ee**2*MZ**2*sw**2)/(6.*cw**2)))/(48.*cmath.pi*abs(MZ)**3)',
                                  (P.d,P.d__tilde__):'(MZ**2*(ee**2*MZ**2 + (3*cw**2*ee**2*MZ**2)/(2.*sw**2) + (5*ee**2*MZ**2*sw**2)/(6.*cw**2)))/(48.*cmath.pi*abs(MZ)**3)',
                                  (P.e__minus__,P.e__plus__):'(MZ**2*(-(ee**2*MZ**2) + (cw**2*ee**2*MZ**2)/(2.*sw**2) + (5*ee**2*MZ**2*sw**2)/(2.*cw**2)))/(48.*cmath.pi*abs(MZ)**3)',
                                  (P.mu__minus__,P.mu__plus__):'(MZ**2*(-(ee**2*MZ**2) + (cw**2*ee**2*MZ**2)/(2.*sw**2) + (5*ee**2*MZ**2*sw**2)/(2.*cw**2)))/(48.*cmath.pi*abs(MZ)**3)',
                                  (P.s,P.s__tilde__):'(MZ**2*(ee**2*MZ**2 + (3*cw**2*ee**2*MZ**2)/(2.*sw**2) + (5*ee**2*MZ**2*sw**2)/(6.*cw**2)))/(48.*cmath.pi*abs(MZ)**3)',
                                  (P.ta__minus__,P.ta__plus__):'((-5*ee**2*MTA**2 - ee**2*MZ**2 - (cw**2*ee**2*MTA**2)/(2.*sw**2) + (cw**2*ee**2*MZ**2)/(2.*sw**2) + (7*ee**2*MTA**2*sw**2)/(2.*cw**2) + (5*ee**2*MZ**2*sw**2)/(2.*cw**2))*cmath.sqrt(-4*MTA**2*MZ**2 + MZ**4))/(48.*cmath.pi*abs(MZ)**3)',
                                  (P.t,P.t__tilde__):'((-11*ee**2*MT**2 - ee**2*MZ**2 - (3*cw**2*ee**2*MT**2)/(2.*sw**2) + (3*cw**2*ee**2*MZ**2)/(2.*sw**2) + (7*ee**2*MT**2*sw**2)/(6.*cw**2) + (17*ee**2*MZ**2*sw**2)/(6.*cw**2) - 24*C00ren*ee**2*cmath.pi**2*itri*MT**2*yDM**2 - 40*C1*ee**2*cmath.pi**2*itri*MT**4*yDM**2 - 40*C11*ee**2*cmath.pi**2*itri*MT**4*yDM**2 - 40*C12*ee**2*cmath.pi**2*itri*MT**4*yDM**2 - 20*C1*ee**2*cmath.pi**2*itri*MT**2*MZ**2*yDM**2 - 20*C11*ee**2*cmath.pi**2*itri*MT**2*MZ**2*yDM**2 - 20*C12*ee**2*cmath.pi**2*itri*MT**2*MZ**2*yDM**2 - (8*C00ren*ee**2*cmath.pi**2*itri*MT**2*sw**2*yDM**2)/(3.*cw**2) + (24*C1*ee**2*cmath.pi**2*itri*MT**4*sw**2*yDM**2)/cw**2 + (24*C11*ee**2*cmath.pi**2*itri*MT**4*sw**2*yDM**2)/cw**2 + (24*C12*ee**2*cmath.pi**2*itri*MT**4*sw**2*yDM**2)/cw**2 + (32*C00ren*ee**2*cmath.pi**2*itri*MZ**2*sw**2*yDM**2)/(3.*cw**2) + (4*C1*ee**2*cmath.pi**2*itri*MT**2*MZ**2*sw**2*yDM**2)/(3.*cw**2) + (4*C11*ee**2*cmath.pi**2*itri*MT**2*MZ**2*sw**2*yDM**2)/(3.*cw**2) + (4*C12*ee**2*cmath.pi**2*itri*MT**2*MZ**2*sw**2*yDM**2)/(3.*cw**2) + (32*C1*ee**2*cmath.pi**2*itri*MZ**4*sw**2*yDM**2)/(3.*cw**2) + (32*C11*ee**2*cmath.pi**2*itri*MZ**4*sw**2*yDM**2)/(3.*cw**2) + (32*C12*ee**2*cmath.pi**2*itri*MZ**4*sw**2*yDM**2)/(3.*cw**2) - (32*C00ren**2*ee**2*cmath.pi**4*itri**2*MT**2*sw**2*yDM**4)/(3.*cw**2) + (64*C00ren*C1*ee**2*cmath.pi**4*itri**2*MT**4*sw**2*yDM**4)/(3.*cw**2) + (64*C00ren*C11*ee**2*cmath.pi**4*itri**2*MT**4*sw**2*yDM**4)/(3.*cw**2) + (64*C00ren*C12*ee**2*cmath.pi**4*itri**2*MT**4*sw**2*yDM**4)/(3.*cw**2) + (224*C1**2*ee**2*cmath.pi**4*itri**2*MT**6*sw**2*yDM**4)/(3.*cw**2) + (448*C1*C11*ee**2*cmath.pi**4*itri**2*MT**6*sw**2*yDM**4)/(3.*cw**2) + (224*C11**2*ee**2*cmath.pi**4*itri**2*MT**6*sw**2*yDM**4)/(3.*cw**2) + (448*C1*C12*ee**2*cmath.pi**4*itri**2*MT**6*sw**2*yDM**4)/(3.*cw**2) + (448*C11*C12*ee**2*cmath.pi**4*itri**2*MT**6*sw**2*yDM**4)/(3.*cw**2) + (224*C12**2*ee**2*cmath.pi**4*itri**2*MT**6*sw**2*yDM**4)/(3.*cw**2) + (32*C00ren**2*ee**2*cmath.pi**4*itri**2*MZ**2*sw**2*yDM**4)/(3.*cw**2) - (32*C00ren*C1*ee**2*cmath.pi**4*itri**2*MT**2*MZ**2*sw**2*yDM**4)/(3.*cw**2) - (32*C00ren*C11*ee**2*cmath.pi**4*itri**2*MT**2*MZ**2*sw**2*yDM**4)/(3.*cw**2) - (32*C00ren*C12*ee**2*cmath.pi**4*itri**2*MT**2*MZ**2*sw**2*yDM**4)/(3.*cw**2) + (64*C00ren*C1*ee**2*cmath.pi**4*itri**2*MZ**4*sw**2*yDM**4)/(3.*cw**2) + (64*C00ren*C11*ee**2*cmath.pi**4*itri**2*MZ**4*sw**2*yDM**4)/(3.*cw**2) + (64*C00ren*C12*ee**2*cmath.pi**4*itri**2*MZ**4*sw**2*yDM**4)/(3.*cw**2) + (8*C1**2*ee**2*cmath.pi**4*itri**2*MT**2*MZ**4*sw**2*yDM**4)/(3.*cw**2) + (16*C1*C11*ee**2*cmath.pi**4*itri**2*MT**2*MZ**4*sw**2*yDM**4)/(3.*cw**2) + (8*C11**2*ee**2*cmath.pi**4*itri**2*MT**2*MZ**4*sw**2*yDM**4)/(3.*cw**2) + (16*C1*C12*ee**2*cmath.pi**4*itri**2*MT**2*MZ**4*sw**2*yDM**4)/(3.*cw**2) + (16*C11*C12*ee**2*cmath.pi**4*itri**2*MT**2*MZ**4*sw**2*yDM**4)/(3.*cw**2) + (8*C12**2*ee**2*cmath.pi**4*itri**2*MT**2*MZ**4*sw**2*yDM**4)/(3.*cw**2) + (32*C1**2*ee**2*cmath.pi**4*itri**2*MZ**6*sw**2*yDM**4)/(3.*cw**2) + (64*C1*C11*ee**2*cmath.pi**4*itri**2*MZ**6*sw**2*yDM**4)/(3.*cw**2) + (32*C11**2*ee**2*cmath.pi**4*itri**2*MZ**6*sw**2*yDM**4)/(3.*cw**2) + (64*C1*C12*ee**2*cmath.pi**4*itri**2*MZ**6*sw**2*yDM**4)/(3.*cw**2) + (64*C11*C12*ee**2*cmath.pi**4*itri**2*MZ**6*sw**2*yDM**4)/(3.*cw**2) + (32*C12**2*ee**2*cmath.pi**4*itri**2*MZ**6*sw**2*yDM**4)/(3.*cw**2))*cmath.sqrt(-4*MT**2*MZ**2 + MZ**4))/(48.*cmath.pi*abs(MZ)**3)',
                                  (P.u,P.u__tilde__):'(MZ**2*(-(ee**2*MZ**2) + (3*cw**2*ee**2*MZ**2)/(2.*sw**2) + (17*ee**2*MZ**2*sw**2)/(6.*cw**2)))/(48.*cmath.pi*abs(MZ)**3)',
                                  (P.ve,P.ve__tilde__):'(MZ**2*(ee**2*MZ**2 + (cw**2*ee**2*MZ**2)/(2.*sw**2) + (ee**2*MZ**2*sw**2)/(2.*cw**2)))/(48.*cmath.pi*abs(MZ)**3)',
                                  (P.vm,P.vm__tilde__):'(MZ**2*(ee**2*MZ**2 + (cw**2*ee**2*MZ**2)/(2.*sw**2) + (ee**2*MZ**2*sw**2)/(2.*cw**2)))/(48.*cmath.pi*abs(MZ)**3)',
                                  (P.vt,P.vt__tilde__):'(MZ**2*(ee**2*MZ**2 + (cw**2*ee**2*MZ**2)/(2.*sw**2) + (ee**2*MZ**2*sw**2)/(2.*cw**2)))/(48.*cmath.pi*abs(MZ)**3)',
                                  (P.W__minus__,P.W__plus__):'(((-12*cw**2*ee**2*MW**2)/sw**2 - (17*cw**2*ee**2*MZ**2)/sw**2 + (4*cw**2*ee**2*MZ**4)/(MW**2*sw**2) + (cw**2*ee**2*MZ**6)/(4.*MW**4*sw**2))*cmath.sqrt(-4*MW**2*MZ**2 + MZ**4))/(48.*cmath.pi*abs(MZ)**3)'})

