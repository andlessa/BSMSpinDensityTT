# This file was automatically created by FeynRules 2.3.49
# Mathematica version: 14.1.0 for Linux x86 (64-bit) (July 16, 2024)
# Date: Mon 5 May 2025 17:07:37


from object_library import all_vertices, all_CTvertices, Vertex, CTVertex
import particles as P
import CT_couplings as C
import lorentz as L


V_1 = CTVertex(name = 'V_1',
               type = 'R2',
               particles = [ P.g, P.g, P.g ],
               color = [ 'f(1,2,3)' ],
               lorentz = [ L.VVV2 ],
               loop_particles = [ [ [P.b], [P.c], [P.d], [P.s], [P.t], [P.u] ], [ [P.g] ] ],
               couplings = {(0,0,0):C.R2GC_131_23,(0,0,1):C.R2GC_131_24})

V_2 = CTVertex(name = 'V_2',
               type = 'R2',
               particles = [ P.g, P.g, P.g, P.g ],
               color = [ 'd(-1,1,3)*d(-1,2,4)', 'd(-1,1,3)*f(-1,2,4)', 'd(-1,1,4)*d(-1,2,3)', 'd(-1,1,4)*f(-1,2,3)', 'd(-1,2,3)*f(-1,1,4)', 'd(-1,2,4)*f(-1,1,3)', 'f(-1,1,2)*f(-1,3,4)', 'f(-1,1,3)*f(-1,2,4)', 'f(-1,1,4)*f(-1,2,3)', 'Identity(1,2)*Identity(3,4)', 'Identity(1,3)*Identity(2,4)', 'Identity(1,4)*Identity(2,3)' ],
               lorentz = [ L.VVVV1, L.VVVV2, L.VVVV4, L.VVVV8 ],
               loop_particles = [ [ [P.b], [P.c], [P.d], [P.s], [P.t], [P.u] ], [ [P.g] ] ],
               couplings = {(2,0,0):C.R2GC_111_7,(2,0,1):C.R2GC_111_8,(0,0,0):C.R2GC_111_7,(0,0,1):C.R2GC_111_8,(4,0,0):C.R2GC_109_3,(4,0,1):C.R2GC_109_4,(3,0,0):C.R2GC_109_3,(3,0,1):C.R2GC_109_4,(8,0,0):C.R2GC_110_5,(8,0,1):C.R2GC_110_6,(6,0,0):C.R2GC_114_12,(6,0,1):C.R2GC_141_30,(7,0,0):C.R2GC_115_14,(7,0,1):C.R2GC_140_29,(5,0,0):C.R2GC_109_3,(5,0,1):C.R2GC_109_4,(1,0,0):C.R2GC_109_3,(1,0,1):C.R2GC_109_4,(11,3,0):C.R2GC_113_10,(11,3,1):C.R2GC_113_11,(10,3,0):C.R2GC_113_10,(10,3,1):C.R2GC_113_11,(9,3,1):C.R2GC_112_9,(2,1,0):C.R2GC_111_7,(2,1,1):C.R2GC_111_8,(0,1,0):C.R2GC_111_7,(0,1,1):C.R2GC_111_8,(4,1,0):C.R2GC_109_3,(4,1,1):C.R2GC_109_4,(3,1,0):C.R2GC_109_3,(3,1,1):C.R2GC_109_4,(8,1,0):C.R2GC_110_5,(8,1,1):C.R2GC_142_31,(6,1,0):C.R2GC_138_26,(6,1,1):C.R2GC_138_27,(7,1,0):C.R2GC_115_14,(7,1,1):C.R2GC_115_15,(5,1,0):C.R2GC_109_3,(5,1,1):C.R2GC_109_4,(1,1,0):C.R2GC_109_3,(1,1,1):C.R2GC_109_4,(0,2,0):C.R2GC_111_7,(0,2,1):C.R2GC_111_8,(2,2,0):C.R2GC_111_7,(2,2,1):C.R2GC_111_8,(5,2,0):C.R2GC_109_3,(5,2,1):C.R2GC_109_4,(1,2,0):C.R2GC_109_3,(1,2,1):C.R2GC_109_4,(7,2,0):C.R2GC_137_25,(7,2,1):C.R2GC_111_8,(4,2,0):C.R2GC_109_3,(4,2,1):C.R2GC_109_4,(3,2,0):C.R2GC_109_3,(3,2,1):C.R2GC_109_4,(8,2,0):C.R2GC_110_5,(8,2,1):C.R2GC_139_28,(6,2,0):C.R2GC_114_12,(6,2,1):C.R2GC_114_13})

V_3 = CTVertex(name = 'V_3',
               type = 'R2',
               particles = [ P.P__tilde__chi, P.t, P.P__tilde__ST__tilde__ ],
               color = [ 'Identity(2,3)' ],
               lorentz = [ L.FFS1 ],
               loop_particles = [ [ [P.g, P.P__tilde__ST, P.t] ] ],
               couplings = {(0,0,0):C.R2GC_152_42})

V_4 = CTVertex(name = 'V_4',
               type = 'R2',
               particles = [ P.t__tilde__, P.P__tilde__chi, P.P__tilde__ST ],
               color = [ 'Identity(1,3)' ],
               lorentz = [ L.FFS3 ],
               loop_particles = [ [ [P.g, P.P__tilde__ST, P.t] ] ],
               couplings = {(0,0,0):C.R2GC_152_42})

V_5 = CTVertex(name = 'V_5',
               type = 'R2',
               particles = [ P.g, P.P__tilde__ST__tilde__, P.P__tilde__ST ],
               color = [ 'T(1,3,2)' ],
               lorentz = [ L.VSS2 ],
               loop_particles = [ [ [P.g, P.P__tilde__ST] ], [ [P.P__tilde__chi, P.t] ] ],
               couplings = {(0,0,1):C.R2GC_149_35,(0,0,0):C.R2GC_149_36})

V_6 = CTVertex(name = 'V_6',
               type = 'R2',
               particles = [ P.g, P.g, P.P__tilde__ST__tilde__, P.P__tilde__ST ],
               color = [ 'Identity(1,2)*Identity(3,4)', 'T(1,-1,3)*T(2,4,-1)', 'T(1,4,-1)*T(2,-1,3)' ],
               lorentz = [ L.VVSS1 ],
               loop_particles = [ [ [P.g] ], [ [P.g, P.P__tilde__ST] ], [ [P.P__tilde__chi, P.t] ] ],
               couplings = {(2,0,0):C.R2GC_150_37,(2,0,2):C.R2GC_150_38,(2,0,1):C.R2GC_150_39,(1,0,0):C.R2GC_150_37,(1,0,2):C.R2GC_150_38,(1,0,1):C.R2GC_150_39,(0,0,0):C.R2GC_113_11,(0,0,1):C.R2GC_122_19})

V_7 = CTVertex(name = 'V_7',
               type = 'R2',
               particles = [ P.u__tilde__, P.u, P.g ],
               color = [ 'T(3,2,1)' ],
               lorentz = [ L.FFV1 ],
               loop_particles = [ [ [P.g, P.u] ] ],
               couplings = {(0,0,0):C.R2GC_116_16})

V_8 = CTVertex(name = 'V_8',
               type = 'R2',
               particles = [ P.c__tilde__, P.c, P.g ],
               color = [ 'T(3,2,1)' ],
               lorentz = [ L.FFV1 ],
               loop_particles = [ [ [P.c, P.g] ] ],
               couplings = {(0,0,0):C.R2GC_116_16})

V_9 = CTVertex(name = 'V_9',
               type = 'R2',
               particles = [ P.t__tilde__, P.t, P.g ],
               color = [ 'T(3,2,1)' ],
               lorentz = [ L.FFV1 ],
               loop_particles = [ [ [P.g, P.t] ] ],
               couplings = {(0,0,0):C.R2GC_116_16})

V_10 = CTVertex(name = 'V_10',
                type = 'R2',
                particles = [ P.d__tilde__, P.d, P.g ],
                color = [ 'T(3,2,1)' ],
                lorentz = [ L.FFV1 ],
                loop_particles = [ [ [P.d, P.g] ] ],
                couplings = {(0,0,0):C.R2GC_116_16})

V_11 = CTVertex(name = 'V_11',
                type = 'R2',
                particles = [ P.s__tilde__, P.s, P.g ],
                color = [ 'T(3,2,1)' ],
                lorentz = [ L.FFV1 ],
                loop_particles = [ [ [P.g, P.s] ] ],
                couplings = {(0,0,0):C.R2GC_116_16})

V_12 = CTVertex(name = 'V_12',
                type = 'R2',
                particles = [ P.b__tilde__, P.b, P.g ],
                color = [ 'T(3,2,1)' ],
                lorentz = [ L.FFV1 ],
                loop_particles = [ [ [P.b, P.g] ] ],
                couplings = {(0,0,0):C.R2GC_116_16})

V_13 = CTVertex(name = 'V_13',
                type = 'R2',
                particles = [ P.t__tilde__, P.t ],
                color = [ 'Identity(1,2)' ],
                lorentz = [ L.FF2, L.FF3, L.FF4, L.FF5 ],
                loop_particles = [ [ [P.g, P.t] ] ],
                couplings = {(0,0,0):C.R2GC_145_32,(0,2,0):C.R2GC_145_32,(0,3,0):C.R2GC_118_18,(0,1,0):C.R2GC_118_18})

V_14 = CTVertex(name = 'V_14',
                type = 'R2',
                particles = [ P.u__tilde__, P.u ],
                color = [ 'Identity(1,2)' ],
                lorentz = [ L.FF1 ],
                loop_particles = [ [ [P.g, P.u] ] ],
                couplings = {(0,0,0):C.R2GC_118_18})

V_15 = CTVertex(name = 'V_15',
                type = 'R2',
                particles = [ P.c__tilde__, P.c ],
                color = [ 'Identity(1,2)' ],
                lorentz = [ L.FF1 ],
                loop_particles = [ [ [P.c, P.g] ] ],
                couplings = {(0,0,0):C.R2GC_118_18})

V_16 = CTVertex(name = 'V_16',
                type = 'R2',
                particles = [ P.d__tilde__, P.d ],
                color = [ 'Identity(1,2)' ],
                lorentz = [ L.FF1 ],
                loop_particles = [ [ [P.d, P.g] ] ],
                couplings = {(0,0,0):C.R2GC_118_18})

V_17 = CTVertex(name = 'V_17',
                type = 'R2',
                particles = [ P.s__tilde__, P.s ],
                color = [ 'Identity(1,2)' ],
                lorentz = [ L.FF1 ],
                loop_particles = [ [ [P.g, P.s] ] ],
                couplings = {(0,0,0):C.R2GC_118_18})

V_18 = CTVertex(name = 'V_18',
                type = 'R2',
                particles = [ P.b__tilde__, P.b ],
                color = [ 'Identity(1,2)' ],
                lorentz = [ L.FF2, L.FF3, L.FF4, L.FF5 ],
                loop_particles = [ [ [P.b, P.g] ] ],
                couplings = {(0,0,0):C.R2GC_117_17,(0,2,0):C.R2GC_117_17,(0,1,0):C.R2GC_118_18,(0,3,0):C.R2GC_118_18})

V_19 = CTVertex(name = 'V_19',
                type = 'R2',
                particles = [ P.P__tilde__ST__tilde__, P.P__tilde__ST ],
                color = [ 'Identity(1,2)' ],
                lorentz = [ L.SS1, L.SS2 ],
                loop_particles = [ [ [P.g, P.P__tilde__ST] ], [ [P.P__tilde__chi, P.t] ] ],
                couplings = {(0,0,1):C.R2GC_151_40,(0,0,0):C.R2GC_151_41,(0,1,1):C.R2GC_148_33,(0,1,0):C.R2GC_148_34})

V_20 = CTVertex(name = 'V_20',
                type = 'R2',
                particles = [ P.g, P.g ],
                color = [ 'Identity(1,2)' ],
                lorentz = [ L.VV1, L.VV2, L.VV3 ],
                loop_particles = [ [ [P.b] ], [ [P.b], [P.c], [P.d], [P.s], [P.t], [P.u] ], [ [P.g] ], [ [P.t] ] ],
                couplings = {(0,0,2):C.R2GC_130_22,(0,1,0):C.R2GC_100_1,(0,1,3):C.R2GC_100_2,(0,2,1):C.R2GC_129_20,(0,2,2):C.R2GC_129_21})

V_21 = CTVertex(name = 'V_21',
                type = 'UV',
                particles = [ P.g, P.g, P.g ],
                color = [ 'f(1,2,3)' ],
                lorentz = [ L.VVV1, L.VVV2, L.VVV3, L.VVV4 ],
                loop_particles = [ [ [P.b] ], [ [P.c], [P.d], [P.s], [P.u] ], [ [P.g] ], [ [P.ghG] ], [ [P.P__tilde__ST] ], [ [P.t] ] ],
                couplings = {(0,1,0):C.UVGC_131_33,(0,1,1):C.UVGC_131_34,(0,1,4):C.UVGC_131_35,(0,1,5):C.UVGC_131_36,(0,3,2):C.UVGC_101_1,(0,0,3):C.UVGC_102_2,(0,2,4):C.UVGC_103_3})

V_22 = CTVertex(name = 'V_22',
                type = 'UV',
                particles = [ P.g, P.g, P.g, P.g ],
                color = [ 'd(-1,1,3)*d(-1,2,4)', 'd(-1,1,3)*f(-1,2,4)', 'd(-1,1,4)*d(-1,2,3)', 'd(-1,1,4)*f(-1,2,3)', 'd(-1,2,3)*f(-1,1,4)', 'd(-1,2,4)*f(-1,1,3)', 'f(-1,1,2)*f(-1,3,4)', 'f(-1,1,3)*f(-1,2,4)', 'f(-1,1,4)*f(-1,2,3)', 'Identity(1,2)*Identity(3,4)', 'Identity(1,3)*Identity(2,4)', 'Identity(1,4)*Identity(2,3)' ],
                lorentz = [ L.VVVV1, L.VVVV2, L.VVVV4, L.VVVV8 ],
                loop_particles = [ [ [P.b] ], [ [P.b], [P.c], [P.d], [P.s], [P.P__tilde__ST], [P.t], [P.u] ], [ [P.b], [P.c], [P.d], [P.s], [P.t], [P.u] ], [ [P.c], [P.d], [P.s], [P.u] ], [ [P.g] ], [ [P.ghG] ], [ [P.P__tilde__ST] ], [ [P.t] ] ],
                couplings = {(2,0,4):C.UVGC_110_9,(2,0,5):C.UVGC_110_8,(0,0,4):C.UVGC_110_9,(0,0,5):C.UVGC_110_8,(4,0,4):C.UVGC_109_6,(4,0,5):C.UVGC_109_7,(3,0,4):C.UVGC_109_6,(3,0,5):C.UVGC_109_7,(8,0,4):C.UVGC_110_8,(8,0,5):C.UVGC_110_9,(6,0,0):C.UVGC_140_59,(6,0,3):C.UVGC_140_60,(6,0,4):C.UVGC_141_65,(6,0,5):C.UVGC_141_66,(6,0,6):C.UVGC_140_63,(6,0,7):C.UVGC_140_64,(7,0,0):C.UVGC_140_59,(7,0,3):C.UVGC_140_60,(7,0,4):C.UVGC_140_61,(7,0,5):C.UVGC_140_62,(7,0,6):C.UVGC_140_63,(7,0,7):C.UVGC_140_64,(5,0,4):C.UVGC_109_6,(5,0,5):C.UVGC_109_7,(1,0,4):C.UVGC_109_6,(1,0,5):C.UVGC_109_7,(11,3,4):C.UVGC_113_12,(11,3,5):C.UVGC_113_13,(10,3,4):C.UVGC_113_12,(10,3,5):C.UVGC_113_13,(9,3,4):C.UVGC_112_10,(9,3,5):C.UVGC_112_11,(2,1,4):C.UVGC_110_9,(2,1,5):C.UVGC_110_8,(0,1,4):C.UVGC_110_9,(0,1,5):C.UVGC_110_8,(4,1,4):C.UVGC_109_6,(4,1,5):C.UVGC_109_7,(3,1,4):C.UVGC_109_6,(3,1,5):C.UVGC_109_7,(8,1,0):C.UVGC_142_67,(8,1,3):C.UVGC_142_68,(8,1,4):C.UVGC_142_69,(8,1,5):C.UVGC_142_70,(8,1,6):C.UVGC_142_71,(8,1,7):C.UVGC_142_72,(6,1,0):C.UVGC_137_45,(6,1,4):C.UVGC_138_50,(6,1,5):C.UVGC_138_51,(6,1,6):C.UVGC_138_52,(6,1,7):C.UVGC_137_49,(7,1,1):C.UVGC_114_14,(7,1,4):C.UVGC_115_17,(7,1,5):C.UVGC_115_18,(5,1,4):C.UVGC_109_6,(5,1,5):C.UVGC_109_7,(1,1,4):C.UVGC_109_6,(1,1,5):C.UVGC_109_7,(0,2,4):C.UVGC_110_9,(0,2,5):C.UVGC_110_8,(2,2,4):C.UVGC_110_9,(2,2,5):C.UVGC_110_8,(5,2,4):C.UVGC_109_6,(5,2,5):C.UVGC_109_7,(1,2,4):C.UVGC_109_6,(1,2,5):C.UVGC_109_7,(7,2,0):C.UVGC_137_45,(7,2,4):C.UVGC_137_46,(7,2,5):C.UVGC_137_47,(7,2,6):C.UVGC_137_48,(7,2,7):C.UVGC_137_49,(4,2,4):C.UVGC_109_6,(4,2,5):C.UVGC_109_7,(3,2,4):C.UVGC_109_6,(3,2,5):C.UVGC_109_7,(8,2,0):C.UVGC_139_53,(8,2,3):C.UVGC_139_54,(8,2,4):C.UVGC_139_55,(8,2,5):C.UVGC_139_56,(8,2,6):C.UVGC_139_57,(8,2,7):C.UVGC_139_58,(6,2,2):C.UVGC_114_14,(6,2,4):C.UVGC_114_15,(6,2,5):C.UVGC_112_10,(6,2,6):C.UVGC_114_16})

V_23 = CTVertex(name = 'V_23',
                type = 'UV',
                particles = [ P.P__tilde__chi, P.t, P.P__tilde__ST__tilde__ ],
                color = [ 'Identity(2,3)' ],
                lorentz = [ L.FFS1 ],
                loop_particles = [ [ [P.g, P.P__tilde__ST], [P.g, P.P__tilde__ST, P.t] ], [ [P.g, P.t] ], [ [P.P__tilde__chi, P.P__tilde__ST] ], [ [P.P__tilde__chi, P.t] ], [ [P.P__tilde__ST, P.t] ] ],
                couplings = {(0,0,2):C.UVGC_152_99,(0,0,3):C.UVGC_152_100,(0,0,0):C.UVGC_152_101,(0,0,1):C.UVGC_152_102,(0,0,4):C.UVGC_155_105})

V_24 = CTVertex(name = 'V_24',
                type = 'UV',
                particles = [ P.t__tilde__, P.P__tilde__chi, P.P__tilde__ST ],
                color = [ 'Identity(1,3)' ],
                lorentz = [ L.FFS3 ],
                loop_particles = [ [ [P.g, P.P__tilde__ST], [P.g, P.P__tilde__ST, P.t] ], [ [P.g, P.t] ], [ [P.P__tilde__chi, P.P__tilde__ST] ], [ [P.P__tilde__chi, P.t] ] ],
                couplings = {(0,0,2):C.UVGC_152_99,(0,0,3):C.UVGC_152_100,(0,0,0):C.UVGC_152_101,(0,0,1):C.UVGC_152_102})

V_25 = CTVertex(name = 'V_25',
                type = 'UV',
                particles = [ P.g, P.P__tilde__ST__tilde__, P.P__tilde__ST ],
                color = [ 'T(1,3,2)' ],
                lorentz = [ L.VSS2 ],
                loop_particles = [ [ [P.b] ], [ [P.c], [P.d], [P.s], [P.u] ], [ [P.g] ], [ [P.ghG] ], [ [P.g, P.P__tilde__ST] ], [ [P.P__tilde__chi, P.t] ], [ [P.P__tilde__ST] ], [ [P.t] ] ],
                couplings = {(0,0,0):C.UVGC_149_82,(0,0,1):C.UVGC_149_83,(0,0,2):C.UVGC_149_84,(0,0,3):C.UVGC_149_85,(0,0,6):C.UVGC_149_86,(0,0,7):C.UVGC_149_87,(0,0,5):C.UVGC_149_88,(0,0,4):C.UVGC_149_89})

V_26 = CTVertex(name = 'V_26',
                type = 'UV',
                particles = [ P.g, P.g, P.P__tilde__ST__tilde__, P.P__tilde__ST ],
                color = [ 'Identity(1,2)*Identity(3,4)', 'T(1,-1,3)*T(2,4,-1)', 'T(1,4,-1)*T(2,-1,3)' ],
                lorentz = [ L.VVSS1 ],
                loop_particles = [ [ [P.b] ], [ [P.c], [P.d], [P.s], [P.u] ], [ [P.g] ], [ [P.ghG] ], [ [P.g, P.P__tilde__ST] ], [ [P.P__tilde__chi, P.t] ], [ [P.P__tilde__ST] ], [ [P.t] ] ],
                couplings = {(2,0,0):C.UVGC_150_90,(2,0,1):C.UVGC_140_60,(2,0,2):C.UVGC_150_91,(2,0,3):C.UVGC_150_92,(2,0,6):C.UVGC_150_93,(2,0,7):C.UVGC_150_94,(2,0,5):C.UVGC_150_95,(2,0,4):C.UVGC_150_96,(1,0,0):C.UVGC_150_90,(1,0,1):C.UVGC_140_60,(1,0,2):C.UVGC_150_91,(1,0,3):C.UVGC_150_92,(1,0,6):C.UVGC_150_93,(1,0,7):C.UVGC_150_94,(1,0,5):C.UVGC_150_95,(1,0,4):C.UVGC_150_96,(0,0,2):C.UVGC_122_22,(0,0,4):C.UVGC_122_23})

V_27 = CTVertex(name = 'V_27',
                type = 'UV',
                particles = [ P.u__tilde__, P.u, P.g ],
                color = [ 'T(3,2,1)' ],
                lorentz = [ L.FFV1, L.FFV2, L.FFV3 ],
                loop_particles = [ [ [P.b] ], [ [P.c], [P.d], [P.s], [P.u] ], [ [P.g] ], [ [P.ghG] ], [ [P.g, P.u] ], [ [P.P__tilde__ST] ], [ [P.t] ] ],
                couplings = {(0,0,4):C.UVGC_116_19,(0,1,0):C.UVGC_132_37,(0,1,1):C.UVGC_132_38,(0,1,2):C.UVGC_132_39,(0,1,3):C.UVGC_132_40,(0,1,5):C.UVGC_132_41,(0,1,6):C.UVGC_132_42,(0,1,4):C.UVGC_132_43,(0,2,0):C.UVGC_132_37,(0,2,1):C.UVGC_132_38,(0,2,2):C.UVGC_132_39,(0,2,3):C.UVGC_132_40,(0,2,5):C.UVGC_132_41,(0,2,6):C.UVGC_132_42,(0,2,4):C.UVGC_132_43})

V_28 = CTVertex(name = 'V_28',
                type = 'UV',
                particles = [ P.c__tilde__, P.c, P.g ],
                color = [ 'T(3,2,1)' ],
                lorentz = [ L.FFV1, L.FFV2, L.FFV3 ],
                loop_particles = [ [ [P.b] ], [ [P.c], [P.d], [P.s], [P.u] ], [ [P.c, P.g] ], [ [P.g] ], [ [P.ghG] ], [ [P.P__tilde__ST] ], [ [P.t] ] ],
                couplings = {(0,0,2):C.UVGC_116_19,(0,1,0):C.UVGC_132_37,(0,1,1):C.UVGC_132_38,(0,1,3):C.UVGC_132_39,(0,1,4):C.UVGC_132_40,(0,1,5):C.UVGC_132_41,(0,1,6):C.UVGC_132_42,(0,1,2):C.UVGC_132_43,(0,2,0):C.UVGC_132_37,(0,2,1):C.UVGC_132_38,(0,2,3):C.UVGC_132_39,(0,2,4):C.UVGC_132_40,(0,2,5):C.UVGC_132_41,(0,2,6):C.UVGC_132_42,(0,2,2):C.UVGC_132_43})

V_29 = CTVertex(name = 'V_29',
                type = 'UV',
                particles = [ P.t__tilde__, P.t, P.g ],
                color = [ 'T(3,2,1)' ],
                lorentz = [ L.FFV1, L.FFV2, L.FFV3 ],
                loop_particles = [ [ [P.b] ], [ [P.c], [P.d], [P.s], [P.u] ], [ [P.g] ], [ [P.ghG] ], [ [P.g, P.t] ], [ [P.P__tilde__chi, P.P__tilde__ST] ], [ [P.P__tilde__ST] ], [ [P.t] ] ],
                couplings = {(0,0,4):C.UVGC_116_19,(0,1,0):C.UVGC_132_37,(0,1,1):C.UVGC_132_38,(0,1,2):C.UVGC_132_39,(0,1,3):C.UVGC_132_40,(0,1,6):C.UVGC_132_41,(0,1,7):C.UVGC_132_42,(0,1,5):C.UVGC_144_75,(0,1,4):C.UVGC_144_76,(0,2,0):C.UVGC_132_37,(0,2,1):C.UVGC_132_38,(0,2,2):C.UVGC_132_39,(0,2,3):C.UVGC_132_40,(0,2,6):C.UVGC_132_41,(0,2,7):C.UVGC_132_42,(0,2,5):C.UVGC_147_80,(0,2,4):C.UVGC_144_76})

V_30 = CTVertex(name = 'V_30',
                type = 'UV',
                particles = [ P.d__tilde__, P.d, P.g ],
                color = [ 'T(3,2,1)' ],
                lorentz = [ L.FFV1, L.FFV2, L.FFV3 ],
                loop_particles = [ [ [P.b] ], [ [P.c], [P.d], [P.s], [P.u] ], [ [P.d, P.g] ], [ [P.g] ], [ [P.ghG] ], [ [P.P__tilde__ST] ], [ [P.t] ] ],
                couplings = {(0,0,2):C.UVGC_116_19,(0,1,0):C.UVGC_132_37,(0,1,1):C.UVGC_132_38,(0,1,3):C.UVGC_132_39,(0,1,4):C.UVGC_132_40,(0,1,5):C.UVGC_132_41,(0,1,6):C.UVGC_132_42,(0,1,2):C.UVGC_132_43,(0,2,0):C.UVGC_132_37,(0,2,1):C.UVGC_132_38,(0,2,3):C.UVGC_132_39,(0,2,4):C.UVGC_132_40,(0,2,5):C.UVGC_132_41,(0,2,6):C.UVGC_132_42,(0,2,2):C.UVGC_132_43})

V_31 = CTVertex(name = 'V_31',
                type = 'UV',
                particles = [ P.s__tilde__, P.s, P.g ],
                color = [ 'T(3,2,1)' ],
                lorentz = [ L.FFV1, L.FFV2, L.FFV3 ],
                loop_particles = [ [ [P.b] ], [ [P.c], [P.d], [P.s], [P.u] ], [ [P.g] ], [ [P.ghG] ], [ [P.g, P.s] ], [ [P.P__tilde__ST] ], [ [P.t] ] ],
                couplings = {(0,0,4):C.UVGC_116_19,(0,1,0):C.UVGC_132_37,(0,1,1):C.UVGC_132_38,(0,1,2):C.UVGC_132_39,(0,1,3):C.UVGC_132_40,(0,1,5):C.UVGC_132_41,(0,1,6):C.UVGC_132_42,(0,1,4):C.UVGC_132_43,(0,2,0):C.UVGC_132_37,(0,2,1):C.UVGC_132_38,(0,2,2):C.UVGC_132_39,(0,2,3):C.UVGC_132_40,(0,2,5):C.UVGC_132_41,(0,2,6):C.UVGC_132_42,(0,2,4):C.UVGC_132_43})

V_32 = CTVertex(name = 'V_32',
                type = 'UV',
                particles = [ P.b__tilde__, P.b, P.g ],
                color = [ 'T(3,2,1)' ],
                lorentz = [ L.FFV1, L.FFV2, L.FFV3 ],
                loop_particles = [ [ [P.b] ], [ [P.b, P.g] ], [ [P.c], [P.d], [P.s], [P.u] ], [ [P.g] ], [ [P.ghG] ], [ [P.P__tilde__ST] ], [ [P.t] ] ],
                couplings = {(0,0,1):C.UVGC_116_19,(0,1,0):C.UVGC_132_37,(0,1,2):C.UVGC_132_38,(0,1,3):C.UVGC_132_39,(0,1,4):C.UVGC_132_40,(0,1,5):C.UVGC_132_41,(0,1,6):C.UVGC_132_42,(0,1,1):C.UVGC_136_44,(0,2,0):C.UVGC_132_37,(0,2,2):C.UVGC_132_38,(0,2,3):C.UVGC_132_39,(0,2,4):C.UVGC_132_40,(0,2,5):C.UVGC_132_41,(0,2,6):C.UVGC_132_42,(0,2,1):C.UVGC_136_44})

V_33 = CTVertex(name = 'V_33',
                type = 'UV',
                particles = [ P.t__tilde__, P.t ],
                color = [ 'Identity(1,2)' ],
                lorentz = [ L.FF2, L.FF3, L.FF4, L.FF5 ],
                loop_particles = [ [ [P.g, P.t] ], [ [P.P__tilde__chi, P.P__tilde__ST] ] ],
                couplings = {(0,0,1):C.UVGC_145_77,(0,0,0):C.UVGC_145_78,(0,2,1):C.UVGC_145_77,(0,2,0):C.UVGC_145_78,(0,3,1):C.UVGC_146_79,(0,3,0):C.UVGC_143_74,(0,1,1):C.UVGC_143_73,(0,1,0):C.UVGC_143_74})

V_34 = CTVertex(name = 'V_34',
                type = 'UV',
                particles = [ P.u__tilde__, P.u ],
                color = [ 'Identity(1,2)' ],
                lorentz = [ L.FF1, L.FF3, L.FF5 ],
                loop_particles = [ [ [P.g, P.u] ] ],
                couplings = {(0,0,0):C.UVGC_118_21,(0,1,0):C.UVGC_104_4,(0,2,0):C.UVGC_104_4})

V_35 = CTVertex(name = 'V_35',
                type = 'UV',
                particles = [ P.c__tilde__, P.c ],
                color = [ 'Identity(1,2)' ],
                lorentz = [ L.FF1, L.FF3, L.FF5 ],
                loop_particles = [ [ [P.c, P.g] ] ],
                couplings = {(0,0,0):C.UVGC_118_21,(0,1,0):C.UVGC_104_4,(0,2,0):C.UVGC_104_4})

V_36 = CTVertex(name = 'V_36',
                type = 'UV',
                particles = [ P.d__tilde__, P.d ],
                color = [ 'Identity(1,2)' ],
                lorentz = [ L.FF1, L.FF3, L.FF5 ],
                loop_particles = [ [ [P.d, P.g] ] ],
                couplings = {(0,0,0):C.UVGC_118_21,(0,1,0):C.UVGC_104_4,(0,2,0):C.UVGC_104_4})

V_37 = CTVertex(name = 'V_37',
                type = 'UV',
                particles = [ P.s__tilde__, P.s ],
                color = [ 'Identity(1,2)' ],
                lorentz = [ L.FF1, L.FF3, L.FF5 ],
                loop_particles = [ [ [P.g, P.s] ] ],
                couplings = {(0,0,0):C.UVGC_118_21,(0,1,0):C.UVGC_104_4,(0,2,0):C.UVGC_104_4})

V_38 = CTVertex(name = 'V_38',
                type = 'UV',
                particles = [ P.b__tilde__, P.b ],
                color = [ 'Identity(1,2)' ],
                lorentz = [ L.FF2, L.FF3, L.FF4, L.FF5 ],
                loop_particles = [ [ [P.b, P.g] ] ],
                couplings = {(0,0,0):C.UVGC_117_20,(0,2,0):C.UVGC_117_20,(0,1,0):C.UVGC_128_24,(0,3,0):C.UVGC_128_24})

V_39 = CTVertex(name = 'V_39',
                type = 'UV',
                particles = [ P.P__tilde__ST__tilde__, P.P__tilde__ST ],
                color = [ 'Identity(1,2)' ],
                lorentz = [ L.SS1, L.SS2 ],
                loop_particles = [ [ [P.g, P.P__tilde__ST] ], [ [P.P__tilde__chi, P.t] ] ],
                couplings = {(0,0,1):C.UVGC_151_97,(0,0,0):C.UVGC_151_98,(0,1,1):C.UVGC_148_81})

V_40 = CTVertex(name = 'V_40',
                type = 'UV',
                particles = [ P.g, P.g ],
                color = [ 'Identity(1,2)' ],
                lorentz = [ L.VV1, L.VV3 ],
                loop_particles = [ [ [P.b] ], [ [P.g] ], [ [P.ghG] ], [ [P.P__tilde__ST] ], [ [P.t] ] ],
                couplings = {(0,0,0):C.UVGC_130_28,(0,0,1):C.UVGC_130_29,(0,0,2):C.UVGC_130_30,(0,0,3):C.UVGC_130_31,(0,0,4):C.UVGC_130_32,(0,1,0):C.UVGC_129_25,(0,1,3):C.UVGC_129_26,(0,1,4):C.UVGC_129_27})

V_41 = CTVertex(name = 'V_41',
                type = 'UV',
                particles = [ P.P__tilde__chi, P.P__tilde__chi ],
                color = [ '1' ],
                lorentz = [ L.FF1, L.FF2, L.FF3, L.FF4, L.FF5 ],
                loop_particles = [ [ [P.P__tilde__ST, P.t] ] ],
                couplings = {(0,1,0):C.UVGC_154_104,(0,3,0):C.UVGC_154_104,(0,2,0):C.UVGC_153_103,(0,4,0):C.UVGC_153_103,(0,0,0):C.UVGC_107_5})

