from ctypes import CDLL, RTLD_GLOBAL
from pathlib import Path
import os


def load_collier_library():
    """Load COLLIER globally so the f2py extension can resolve its symbols."""
    env_path = os.environ.get('COLLIER_LIBRARY')
    candidates = []

    if env_path:
        candidates.append(Path(env_path))

    base = Path(__file__).resolve().parent
    for parent in [base, *base.parents]:
        candidates.append(parent / 'MG5' / 'HEPTools' / 'lib' / 'libcollier.so')
        candidates.append(parent / 'MG5' / 'bin' / 'HEPTools' / 'lib' / 'libcollier.so')

    for candidate in candidates:
        if candidate.is_file():
            CDLL(str(candidate), mode=RTLD_GLOBAL)
            return

    raise ImportError(
        'Could not load libcollier.so. Set COLLIER_LIBRARY to the shared library path.'
    )


load_collier_library()

import all_matrix2py
all_matrix2py.initialise('../Cards/param_card.dat')

def invert_momenta(p):
        """ fortran/C-python do not order table in the same order"""
        new_p = []
        for i in range(len(p[0])):  new_p.append([0]*len(p))
        for i, onep in enumerate(p):
            for j, x in enumerate(onep):
                new_p[j][i] = x
        return new_p
p =[[  0.5000000E+03,  0.0000000E+00,  0.0000000E+00,  0.5000000E+03],
    [0.5000000E+03,  0.0000000E+00,  0.0000000E+00, -0.5000000E+03],
    [ 0.5000000E+03,  0.1040730E+03,  0.4173556E+03, -0.1872274E+03],
    [ 0.5000000E+03, -0.1040730E+03, -0.4173556E+03,  0.1872274E+03]
    ]

p =invert_momenta(p)
print(p)
proc_id = -1 # if you use the syntax "@X" (with X>0), you can set proc_id to that value (this allows to distinguish process with identical initial/final state.) 
nhel = -1 # means sum over all helicity
pdgs = [2,-2,6,-6] #which pdg is requested
scale2 = 0.  #only used for loop matrix element. should be set to 0 for tree-level
alphas=0.13

ans = all_matrix2py.smatrixhel(pdgs,proc_id, p,alphas,scale2,nhel)
print(ans)
