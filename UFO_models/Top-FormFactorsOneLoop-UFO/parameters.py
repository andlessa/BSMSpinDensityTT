# This file was automatically created by FeynRules 2.3.49
# Mathematica version: 12.1.0 for Linux x86 (64-bit) (March 18, 2020)
# Date: Thu 14 Sep 2023 16:14:46



from object_library import all_parameters, Parameter


from function_library import complexconjugate, re, im, csc, sec, acsc, asec, cot

# This is a default parameter object representing 0.
ZERO = Parameter(name = 'ZERO',
                 nature = 'internal',
                 type = 'real',
                 value = '0.0',
                 texname = '0')

# User-defined parameters.
aEWM1 = Parameter(name = 'aEWM1',
                  nature = 'external',
                  type = 'real',
                  value = 127.9,
                  texname = '\\text{aEWM1}',
                  lhablock = 'SMINPUTS',
                  lhacode = [ 1 ])

Gf = Parameter(name = 'Gf',
               nature = 'external',
               type = 'real',
               value = 0.0000116637,
               texname = 'G_f',
               lhablock = 'SMINPUTS',
               lhacode = [ 2 ])

aS = Parameter(name = 'aS',
               nature = 'external',
               type = 'real',
               value = 0.1184,
               texname = '\\alpha _s',
               lhablock = 'SMINPUTS',
               lhacode = [ 3 ])

ymb = Parameter(name = 'ymb',
                nature = 'external',
                type = 'real',
                value = 4.7,
                texname = '\\text{ymb}',
                lhablock = 'YUKAWA',
                lhacode = [ 5 ])

ymt = Parameter(name = 'ymt',
                nature = 'external',
                type = 'real',
                value = 172,
                texname = '\\text{ymt}',
                lhablock = 'YUKAWA',
                lhacode = [ 6 ])

ymtau = Parameter(name = 'ymtau',
                  nature = 'external',
                  type = 'real',
                  value = 1.777,
                  texname = '\\text{ymtau}',
                  lhablock = 'YUKAWA',
                  lhacode = [ 15 ])

idebug = Parameter(name = 'idebug',
                   nature = 'external',
                   type = 'real',
                   value = 0.,
                   texname = '\\text{idebug}',
                   lhablock = 'FRBlock',
                   lhacode = [ 1 ])

itri = Parameter(name = 'itri',
                 nature = 'external',
                 type = 'real',
                 value = 1.,
                 texname = '\\text{itri}',
                 lhablock = 'FRBlock',
                 lhacode = [ 2 ])

itrib = Parameter(name = 'itrib',
                  nature = 'external',
                  type = 'real',
                  value = 1.,
                  texname = '\\text{itrib}',
                  lhablock = 'FRBlock',
                  lhacode = [ 3 ])
ibox = Parameter(name = 'ibox',
                 nature = 'external',
                 type = 'real',
                 value = 1.,
                 texname = '\\text{ibox}',
                 lhablock = 'FRBlock',
                 lhacode = [ 4 ])

iself = Parameter(name = 'iself',
                  nature = 'external',
                  type = 'real',
                  value = 1.,
                  texname = '\\text{iself}',
                  lhablock = 'FRBlock',
                  lhacode = [ 5 ])

yDM = Parameter(name = 'yDM',
                nature = 'external',
                type = 'real',
                value = 1.,
                texname = 'y_{\\text{DM}}',
                lhablock = 'FRBlock',
                lhacode = [ 6 ])

MZ = Parameter(name = 'MZ',
               nature = 'external',
               type = 'real',
               value = 91.1876,
               texname = '\\text{MZ}',
               lhablock = 'MASS',
               lhacode = [ 23 ])

MTA = Parameter(name = 'MTA',
                nature = 'external',
                type = 'real',
                value = 1.777,
                texname = '\\text{MTA}',
                lhablock = 'MASS',
                lhacode = [ 15 ])

MT = Parameter(name = 'MT',
               nature = 'external',
               type = 'real',
               value = 172,
               texname = '\\text{MT}',
               lhablock = 'MASS',
               lhacode = [ 6 ])

MB = Parameter(name = 'MB',
               nature = 'external',
               type = 'real',
               value = 4.7,
               texname = '\\text{MB}',
               lhablock = 'MASS',
               lhacode = [ 5 ])

MH = Parameter(name = 'MH',
               nature = 'external',
               type = 'real',
               value = 125,
               texname = '\\text{MH}',
               lhablock = 'MASS',
               lhacode = [ 25 ])

mChi = Parameter(name = 'mChi',
                 nature = 'external',
                 type = 'real',
                 value = 100.,
                 texname = '\\text{mChi}',
                 lhablock = 'MASS',
                 lhacode = [ 5000012 ])

mST = Parameter(name = 'mST',
                nature = 'external',
                type = 'real',
                value = 400.,
                texname = '\\text{mST}',
                lhablock = 'MASS',
                lhacode = [ 5000002 ])

WZ = Parameter(name = 'WZ',
               nature = 'external',
               type = 'real',
               value = 2.4952,
               texname = '\\text{WZ}',
               lhablock = 'DECAY',
               lhacode = [ 23 ])

WW = Parameter(name = 'WW',
               nature = 'external',
               type = 'real',
               value = 2.085,
               texname = '\\text{WW}',
               lhablock = 'DECAY',
               lhacode = [ 24 ])

WT = Parameter(name = 'WT',
               nature = 'external',
               type = 'real',
               value = 1.50833649,
               texname = '\\text{WT}',
               lhablock = 'DECAY',
               lhacode = [ 6 ])

WH = Parameter(name = 'WH',
               nature = 'external',
               type = 'real',
               value = 0.00407,
               texname = '\\text{WH}',
               lhablock = 'DECAY',
               lhacode = [ 25 ])

wChi = Parameter(name = 'wChi',
                 nature = 'external',
                 type = 'real',
                 value = 0.,
                 texname = '\\text{wChi}',
                 lhablock = 'DECAY',
                 lhacode = [ 5000012 ])

wST = Parameter(name = 'wST',
                nature = 'external',
                type = 'real',
                value = 1.,
                texname = '\\text{wST}',
                lhablock = 'DECAY',
                lhacode = [ 5000002 ])

C00ren = Parameter(name = 'C00ren',
                   nature = 'internal',
                   type = 'real',
                   value = '1.',
                   texname = '\\text{Cren}_0')

C1 = Parameter(name = 'C1',
               nature = 'internal',
               type = 'real',
               value = '1.',
               texname = 'C_1')

C11 = Parameter(name = 'C11',
                nature = 'internal',
                type = 'real',
                value = '1.',
                texname = 'C_{11}')

C12 = Parameter(name = 'C12',
                nature = 'internal',
                type = 'real',
                value = '1.',
                texname = 'C_{12}')

xC = Parameter(name = 'xC',
               nature = 'internal',
               type = 'real',
               value = 'mChi**2/mST**2',
               texname = 'x_C')

xT = Parameter(name = 'xT',
               nature = 'internal',
               type = 'real',
               value = 'MT**2/mST**2',
               texname = 'x_T')

aEW = Parameter(name = 'aEW',
                nature = 'internal',
                type = 'real',
                value = '1/aEWM1',
                texname = '\\alpha _{\\text{EW}}')

G = Parameter(name = 'G',
              nature = 'internal',
              type = 'real',
              value = '2*cmath.sqrt(aS)*cmath.sqrt(cmath.pi)',
              texname = 'G')

lA = Parameter(name = 'lA',
               nature = 'internal',
               type = 'real',
               value = '1 - 2*xC + xC**2 - 2*xT - 2*xC*xT + xT**2',
               texname = 'l_A')

MW = Parameter(name = 'MW',
               nature = 'internal',
               type = 'real',
               value = 'cmath.sqrt(MZ**2/2. + cmath.sqrt(MZ**4/4. - (aEW*cmath.pi*MZ**2)/(Gf*cmath.sqrt(2))))',
               texname = 'M_W')

ee = Parameter(name = 'ee',
               nature = 'internal',
               type = 'real',
               value = '2*cmath.sqrt(aEW)*cmath.sqrt(cmath.pi)',
               texname = 'e')

deltaCT1L = Parameter(name = 'deltaCT1L',
                      nature = 'internal',
                      type = 'real',
                      value = '(2*cmath.sqrt(lA)*(xT*(-2 + 2*xC + xT) + (-(-1 + xC)**2 + xT)*cmath.log(xC)) - 4*(-(-1 + xC)**3 + (-2 + xC + xC**2)*xT + xT**2)*cmath.log((1 + xC - xT + cmath.sqrt(lA))/(2.*cmath.sqrt(xC))))/(128.*cmath.pi**4*xT**2*cmath.sqrt(lA))',
                      texname = '\\text{deltaCT1L}')

deltaCT1R = Parameter(name = 'deltaCT1R',
                      nature = 'internal',
                      type = 'real',
                      value = '((-1 + xC - xT)*(cmath.sqrt(lA)*(2*xT - (-1 + xC + xT)*cmath.log(xC)) + 2*((-2 + xC)*xC + (-1 + xT)**2)*cmath.log((1 + xC - xT + cmath.sqrt(lA))/(2.*cmath.sqrt(xC)))))/(128.*cmath.pi**4*xT**2*cmath.sqrt(lA))',
                      texname = '\\text{deltaCT1R}')

deltaS1 = Parameter(name = 'deltaS1',
                    nature = 'internal',
                    type = 'real',
                    value = '-(mST*(xT*(-2 + 2*xC + xT) + (-1 + 2*xC - xC**2 + xT)*cmath.log(xC) - (2*(-xC**3 + xC*(-3 + xT) + (-1 + xT)**2 + xC**2*(3 + xT))*cmath.log((1 + xC - xT + cmath.sqrt(lA))/(2.*cmath.sqrt(xC))))/cmath.sqrt(lA)))/(32.*cmath.pi**4*xT**1.5)',
                    texname = '\\text{deltaS1}')

deltaSp1 = Parameter(name = 'deltaSp1',
                     nature = 'internal',
                     type = 'real',
                     value = '(2*(-1 + xC - xT)*xT + (-1 + 2*xC - xC**2 + xT**2)*cmath.log(xC) + (2*(xC**3 - (-1 + xT)**2*(1 + xT) - xC**2*(3 + xT) + xC*(3 + xT**2))*cmath.log((1 + xC - xT + cmath.sqrt(lA))/(2.*cmath.sqrt(xC))))/cmath.sqrt(lA))/(64.*cmath.pi**4*xT**2)',
                     texname = '\\text{deltaSp1}')

lB = Parameter(name = 'lB',
               nature = 'internal',
               type = 'real',
               value = '-lA',
               texname = 'l_B')

sw2 = Parameter(name = 'sw2',
                nature = 'internal',
                type = 'real',
                value = '1 - MW**2/MZ**2',
                texname = '\\text{sw2}')

cw = Parameter(name = 'cw',
               nature = 'internal',
               type = 'real',
               value = 'cmath.sqrt(1 - sw2)',
               texname = 'c_w')

deltaCT2L = Parameter(name = 'deltaCT2L',
                      nature = 'internal',
                      type = 'complex',
                      value = '(xT*(-2 + 2*xC + xT) - ((lB*(-1 + xC) - (-1 + xC)**3 + 2*(-1 + xC)*xT + (1 + xC)*xT**2)*cmath.atan(cmath.sqrt(lB)/(1 + xC - xT)))/cmath.sqrt(lB) + (-(-1 + xC)**2 + xT)*cmath.log(xC))/(64.*cmath.pi**4*xT**2)',
                      texname = '\\text{deltaCT2L}')

deltaCT2R = Parameter(name = 'deltaCT2R',
                      nature = 'internal',
                      type = 'complex',
                      value = '((-2*(-(-1 + xC)**3 - (2 + lB - 2*xC)*xT + (1 + xC)*xT**2)*cmath.atan(cmath.sqrt(lB)/(1 + xC - xT)))/cmath.sqrt(lB) + (1 - xC + xT)*(-2*xT + (-1 + xC + xT)*cmath.log(xC)))/(128.*cmath.pi**4*xT**2)',
                      texname = '\\text{deltaCT2R}')

deltaS2 = Parameter(name = 'deltaS2',
                    nature = 'internal',
                    type = 'complex',
                    value = '-(mST*((-1 + xC)*xT + xT*(-1 + xC + xT) + ((-1 + xC + xT)*(1 + xC**2 - xT - xC*(2 + xT))*cmath.atan(cmath.sqrt(lB)/(1 + xC - xT)))/cmath.sqrt(lB) - (-1 + xC)*cmath.atan(cmath.sqrt(lB)/(1 + xC - xT))*cmath.sqrt(lB) - (1 - 2*xC + xC**2 - xT)*cmath.log(xC)))/(32.*cmath.pi**4*xT**1.5)',
                    texname = '\\text{deltaS2}')

deltaSp2 = Parameter(name = 'deltaSp2',
                     nature = 'internal',
                     type = 'complex',
                     value = '(-2*xT**2 + xT*(-1 + xC + xT) + ((-1 + xC + xT)*(1 + xC**2 - xT - xC*(2 + xT))*cmath.atan(cmath.sqrt(lB)/(1 + xC - xT)))/cmath.sqrt(lB) + xT*cmath.atan(cmath.sqrt(lB)/(1 + xC - xT))*cmath.sqrt(lB) - ((1 - 2*xC + xC**2 - xT**2)*cmath.log(xC))/2.)/(32.*cmath.pi**4*xT**2)',
                     texname = '\\text{deltaSp2}')

sw = Parameter(name = 'sw',
               nature = 'internal',
               type = 'real',
               value = 'cmath.sqrt(sw2)',
               texname = 's_w')

deltaCTL = Parameter(name = 'deltaCTL',
                     nature = 'internal',
                     type = 'real',
                     value = '( deltaCT1L if mST>mChi + MT else deltaCT2L )',
                     texname = '\\delta _L')

deltaCTR = Parameter(name = 'deltaCTR',
                     nature = 'internal',
                     type = 'real',
                     value = '( deltaCT1R if mST>mChi + MT else deltaCT2R )',
                     texname = '\\delta _R')

deltaS = Parameter(name = 'deltaS',
                   nature = 'internal',
                   type = 'real',
                   value = '( deltaS1 if mST>mChi + MT else deltaS2 )',
                   texname = '\\delta _S')

deltaSp = Parameter(name = 'deltaSp',
                    nature = 'internal',
                    type = 'real',
                    value = '( deltaSp1 if mST>mChi + MT else deltaSp2 )',
                    texname = '\\delta _{\\text{Sp}}')

g1 = Parameter(name = 'g1',
               nature = 'internal',
               type = 'real',
               value = 'ee/cw',
               texname = 'g_1')

gw = Parameter(name = 'gw',
               nature = 'internal',
               type = 'real',
               value = 'ee/sw',
               texname = 'g_w')

vev = Parameter(name = 'vev',
                nature = 'internal',
                type = 'real',
                value = '(2*MW*sw)/ee',
                texname = '\\text{vev}')

lam = Parameter(name = 'lam',
                nature = 'internal',
                type = 'real',
                value = 'MH**2/(2.*vev**2)',
                texname = '\\text{lam}')

yb = Parameter(name = 'yb',
               nature = 'internal',
               type = 'real',
               value = '(ymb*cmath.sqrt(2))/vev',
               texname = '\\text{yb}')

yt = Parameter(name = 'yt',
               nature = 'internal',
               type = 'real',
               value = '(ymt*cmath.sqrt(2))/vev',
               texname = '\\text{yt}')

ytau = Parameter(name = 'ytau',
                 nature = 'internal',
                 type = 'real',
                 value = '(ymtau*cmath.sqrt(2))/vev',
                 texname = '\\text{ytau}')

muH = Parameter(name = 'muH',
                nature = 'internal',
                type = 'real',
                value = 'cmath.sqrt(lam*vev**2)',
                texname = '\\mu')

I1a33 = Parameter(name = 'I1a33',
                  nature = 'internal',
                  type = 'complex',
                  value = 'yb',
                  texname = '\\text{I1a33}')

I2a33 = Parameter(name = 'I2a33',
                  nature = 'internal',
                  type = 'complex',
                  value = 'yt',
                  texname = '\\text{I2a33}')

I3a33 = Parameter(name = 'I3a33',
                  nature = 'internal',
                  type = 'complex',
                  value = 'yt',
                  texname = '\\text{I3a33}')

I4a33 = Parameter(name = 'I4a33',
                  nature = 'internal',
                  type = 'complex',
                  value = 'yb',
                  texname = '\\text{I4a33}')

