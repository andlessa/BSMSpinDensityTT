# This file was automatically created by FeynRules 2.3.49
# Mathematica version: 13.3.1 for Linux x86 (64-bit) (July 24, 2023)
# Date: Mon 6 Jul 2026 14:01:16


from object_library import all_lorentz, Lorentz

from function_library import complexconjugate, re, im, csc, sec, acsc, asec, cot
try:
   import form_factors as ForFac 
except ImportError:
   pass


UUS1 = Lorentz(name = 'UUS1',
               spins = [ -1, -1, 1 ],
               structure = '1')

UUV1 = Lorentz(name = 'UUV1',
               spins = [ -1, -1, 3 ],
               structure = 'P(3,2) + P(3,3)')

SSS1 = Lorentz(name = 'SSS1',
               spins = [ 1, 1, 1 ],
               structure = '1')

FFS1 = Lorentz(name = 'FFS1',
               spins = [ 2, 2, 1 ],
               structure = 'ProjM(2,1)')

FFS2 = Lorentz(name = 'FFS2',
               spins = [ 2, 2, 1 ],
               structure = 'ProjM(2,1) - ProjP(2,1)')

FFS3 = Lorentz(name = 'FFS3',
               spins = [ 2, 2, 1 ],
               structure = 'ProjP(2,1)')

FFS4 = Lorentz(name = 'FFS4',
               spins = [ 2, 2, 1 ],
               structure = 'ProjM(2,1) + ProjP(2,1)')

FFV1 = Lorentz(name = 'FFV1',
               spins = [ 2, 2, 3 ],
               structure = 'Gamma(3,2,1)')

FFV2 = Lorentz(name = 'FFV2',
               spins = [ 2, 2, 3 ],
               structure = 'Gamma(3,2,-1)*ProjM(-1,1)')

FFV3 = Lorentz(name = 'FFV3',
               spins = [ 2, 2, 3 ],
               structure = 'Gamma(3,2,-1)*ProjP(-1,1)')

VSS1 = Lorentz(name = 'VSS1',
               spins = [ 3, 1, 1 ],
               structure = 'P(1,2) - P(1,3)')

VVS1 = Lorentz(name = 'VVS1',
               spins = [ 3, 3, 1 ],
               structure = 'Metric(1,2)')

VVV1 = Lorentz(name = 'VVV1',
               spins = [ 3, 3, 3 ],
               structure = 'P(3,1)*Metric(1,2) - P(3,2)*Metric(1,2) - P(2,1)*Metric(1,3) + P(2,3)*Metric(1,3) + P(1,2)*Metric(2,3) - P(1,3)*Metric(2,3)')

SSSS1 = Lorentz(name = 'SSSS1',
                spins = [ 1, 1, 1, 1 ],
                structure = '1')

VVSS1 = Lorentz(name = 'VVSS1',
                spins = [ 3, 3, 1, 1 ],
                structure = 'Metric(1,2)')

VVVV1 = Lorentz(name = 'VVVV1',
                spins = [ 3, 3, 3, 3 ],
                structure = 'Metric(1,4)*Metric(2,3) - Metric(1,3)*Metric(2,4)')

VVVV2 = Lorentz(name = 'VVVV2',
                spins = [ 3, 3, 3, 3 ],
                structure = 'Metric(1,4)*Metric(2,3) + Metric(1,3)*Metric(2,4) - 2*Metric(1,2)*Metric(3,4)')

VVVV3 = Lorentz(name = 'VVVV3',
                spins = [ 3, 3, 3, 3 ],
                structure = 'Metric(1,4)*Metric(2,3) - Metric(1,2)*Metric(3,4)')

VVVV4 = Lorentz(name = 'VVVV4',
                spins = [ 3, 3, 3, 3 ],
                structure = 'Metric(1,3)*Metric(2,4) - Metric(1,2)*Metric(3,4)')

VVVV5 = Lorentz(name = 'VVVV5',
                spins = [ 3, 3, 3, 3 ],
                structure = 'Metric(1,4)*Metric(2,3) - (Metric(1,3)*Metric(2,4))/2. - (Metric(1,2)*Metric(3,4))/2.')


# ----------- New entries for t-t-G coupling --------
ff_FFV1 = Lorentz(name = 'ff_FFV1',
                 spins = [ 2, 2, 3 ],
                 structure = '(Gamma(3,2,-1)*ProjP(-1,1)) * (2*C00h( P(-1,1)*P(-1,1), P(-2,3)*P(-2,3), P(-3,2)*P(-3,2) ) + P(-4,1)*P(-4,1)*pB1h( P(-5,1)*P(-5,1) ) + P(-6,2)*P(-6,2)*pB1h( P(-7,2)*P(-7,2) ) + -1*(MT)**2*reDB1( (MT)**2 ))')
ff_FFV2 = Lorentz(name = 'ff_FFV2',
                 spins = [ 2, 2, 3 ],
                 structure = '(Gamma(3,2,-1)*ProjM(-1,1)) * (-1*(MT)**2*reDB1( (MT)**2 ))')
ff_FFV3 = Lorentz(name = 'ff_FFV3',
                 spins = [ 2, 2, 3 ],
                 structure = '(P(-2,1)*Gamma(-2,2,-1)*ProjP(-1,1)*P(3,1)) * (Ccoll( 0, 1, 0, P(-1,1)*P(-1,1), P(-2,3)*P(-2,3), P(-3,2)*P(-3,2) ) + 2*Ccoll( 0, 2, 0, P(-4,1)*P(-4,1), P(-5,3)*P(-5,3), P(-6,2)*P(-6,2) ))')
ff_FFV4 = Lorentz(name = 'ff_FFV4',
                 spins = [ 2, 2, 3 ],
                 structure = '(P(-2,1)*Gamma(-2,2,-1)*ProjP(-1,1)*P(3,2)) * (-1*Ccoll( 0, 1, 0, P(-1,1)*P(-1,1), P(-2,3)*P(-2,3), P(-3,2)*P(-3,2) ) + -2*Ccoll( 0, 1, 1, P(-4,1)*P(-4,1), P(-5,3)*P(-5,3), P(-6,2)*P(-6,2) ))')
ff_FFV5 = Lorentz(name = 'ff_FFV5',
                 spins = [ 2, 2, 3 ],
                 structure = '(P(-2,2)*Gamma(-2,2,-1)*ProjP(-1,1)*P(3,1)) * (-1*Ccoll( 0, 0, 1, P(-1,1)*P(-1,1), P(-2,3)*P(-2,3), P(-3,2)*P(-3,2) ) + -2*Ccoll( 0, 1, 1, P(-4,1)*P(-4,1), P(-5,3)*P(-5,3), P(-6,2)*P(-6,2) ))')
ff_FFV6 = Lorentz(name = 'ff_FFV6',
                 spins = [ 2, 2, 3 ],
                 structure = '(P(-2,2)*Gamma(-2,2,-1)*ProjP(-1,1)*P(3,2)) * (Ccoll( 0, 0, 1, P(-1,1)*P(-1,1), P(-2,3)*P(-2,3), P(-3,2)*P(-3,2) ) + 2*Ccoll( 0, 0, 2, P(-4,1)*P(-4,1), P(-5,3)*P(-5,3), P(-6,2)*P(-6,2) ))')
ff_FFV7 = Lorentz(name = 'ff_FFV7',
                 spins = [ 2, 2, 3 ],
                 structure = '(Gamma(3,2,-1)*P(-3,1)*Gamma(-3,-1,-2)*ProjP(-2,1)) * (-1*MT*pB1h( P(-1,1)*P(-1,1) ))')
ff_FFV8 = Lorentz(name = 'ff_FFV8',
                 spins = [ 2, 2, 3 ],
                 structure = '(P(-3,2)*Gamma(-3,2,-1)*Gamma(3,-1,-2)*ProjM(-2,1)) * (MT*pB1h( P(-1,2)*P(-1,2) ))')
