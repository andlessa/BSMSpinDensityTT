(* ::Package:: *)

(* ============================================================
   FC2ALOHA.wl
   Translates FeynCalc tensor/Dirac expressions into ALOHA-style
   Lorentz-structure strings (as used by MadGraph/UFO's aloha
   library).

   Design: two-stage pipeline.
     Stage 1: FeynCalc expr  ->  intermediate Aloha* symbolic tree
     Stage 2: Aloha* tree    ->  ALOHA string

   Requires: FeynCalc loaded in the kernel.
   ============================================================ *)

BeginPackage["FC2ALOHA`", {"FeynCalc`"}]

FCToALOHA::usage =
  "FCToALOHA[expr, legs] converts a FeynCalc vertex/amplitude \
expr (with open Lorentz/Dirac structure) into an ALOHA object \
string. legs is an Association mapping each external momentum \
symbol to its ALOHA leg number, e.g. <|p1->1, p2->2, p3->3|>.

For expressions containing fermion lines, also supply \
fermionChains -> {{firstLeg, lastLeg}, ...} as an option, giving \
the leg numbers at the two ends of each open Dirac chain, in the \
order the chain is written (left multiplication = closer to \
outgoing spinor, per your FeynCalc convention).";

FCToALOHA::noleg = "No leg number assigned to momentum/index `1`. \
Add it to the `legs` association.";

Options[FCToALOHA] = {"FermionChains" -> {}};

Begin["`Private`"]

(* ---------------------------------------------------------------
   1. Index / leg bookkeeping (mutable state, reset per call)
   --------------------------------------------------------------- *)

$LegNumber = <||>;          (* momentum symbol -> leg # (given) *)
$LorentzIndexNumber = <||>; (* Lorentz index symbol -> integer label *)
$SpinorIndexNumber = <||>;  (* internal spinor index symbol -> integer label *)
$NextFreeIndex = 101;       (* internal contracted indices start above leg range *)

ResetALOHAState[legs_Association] := (
  $LegNumber = legs;
  $LorentzIndexNumber = <||>;
  $SpinorIndexNumber = <||>;
  $NextFreeIndex = 101;
)

LorentzIndexLabel[mu_] := (
  If[!KeyExistsQ[$LorentzIndexNumber, mu],
    $LorentzIndexNumber[mu] = $NextFreeIndex; $NextFreeIndex += 1];
  $LorentzIndexNumber[mu]
)

SpinorIndexLabel[i_] := (
  If[!KeyExistsQ[$SpinorIndexNumber, i],
    $SpinorIndexNumber[i] = $NextFreeIndex; $NextFreeIndex += 1];
  $SpinorIndexNumber[i]
)

LegLabel[p_] :=
  If[KeyExistsQ[$LegNumber, p],
    $LegNumber[p],
    Message[FCToALOHA::noleg, p]; -1
  ]

(* ---------------------------------------------------------------
   2. Stage 1: FeynCalc -> intermediate Aloha* tree
   --------------------------------------------------------------- *)

(* Sums and products of Lorentz-scalar pieces *)
ToAloha[expr_Plus] := AlohaPlus @@ (ToAloha /@ (List @@ expr))

ToAloha[expr_Times] := Module[{parts, isTensorPiece},
  parts = List @@ expr;
  isTensorPiece[x_] := !FreeQ[x, DiracGamma | DiracSigma | Pair | LorentzIndex | Momentum | DOT];
  AlohaTimes @@ (ToAloha /@ SortBy[parts, isTensorPiece])
]

(* Plain numeric/symbolic coefficients pass through untouched *)
ToAloha[x_?NumericQ] := x
ToAloha[I] := I
ToAloha[x_Symbol] := x

(* Metric: g^{mu nu} <-> Pair[LorentzIndex[mu], LorentzIndex[nu]] *)
ToAloha[Pair[LorentzIndex[mu_, ___], LorentzIndex[nu_, ___]]] :=
  AlohaMetric[LorentzIndexLabel[mu], LorentzIndexLabel[nu]]

(* Momentum dotted into an index: p^mu *)
ToAloha[Pair[LorentzIndex[mu_, ___], Momentum[p_, ___]]] :=
  AlohaP[LorentzIndexLabel[mu], LegLabel[p]]
ToAloha[Pair[Momentum[p_, ___], LorentzIndex[mu_, ___]]] :=
  ToAloha[Pair[LorentzIndex[mu], Momentum[p]]]

(* Two contracted momenta (rare in a vertex Lorentz structure, but
   can appear, e.g. p1.p2 as a scalar coefficient) *)
ToAloha[Pair[Momentum[p_, ___], Momentum[q_, ___]]] :=
  AlohaDot[LegLabel[p], LegLabel[q]]

(* Levi-Civita tensor *)
ToAloha[Eps[LorentzIndex[a_, ___], LorentzIndex[b_, ___],
           LorentzIndex[c_, ___], LorentzIndex[d_, ___]]] :=
  AlohaEpsilon @@ (LorentzIndexLabel /@ {a, b, c, d})

(* ---- Fermion chains -------------------------------------------
   A chain is a DOT (noncommutative product) of DiracGamma /
   DiracSigma objects sandwiched between two external spinor legs.
   You tell the translator which leg numbers bound each chain via
   the "FermionChains" option; ChainToAloha threads through the
   interior with freshly minted indices. *)

ChainToAloha[chain : (DOT[objs__]), {iLeg_, jLeg_}] := Module[
  {objList = {objs}, n, indices, terms},
  n = Length[objList];
  indices = Join[{iLeg}, Table[SpinorIndexLabel[Unique["fc"]], {n - 1}], {jLeg}];
  terms = MapThread[
    DiracObjToAloha[#1, #2, #3] &,
    {objList, Most[indices], Rest[indices]}
  ];
  AlohaTimes @@ terms
]

(* single gamma matrix with no chain (n=1 case handled by the
   MapThread above too, but kept explicit for clarity) *)
DiracObjToAloha[DiracGamma[LorentzIndex[mu_, ___], ___], i_, j_] :=
  AlohaGamma[LorentzIndexLabel[mu], i, j]

DiracObjToAloha[DiracGamma[5], i_, j_] := AlohaGamma5[i, j]

(* NOTE: verify against your FeynCalc version which chirality
   convention DiracGamma[6]/[7] follow -- (1+gamma5)/2 vs
   (1-gamma5)/2 -- and match to ALOHA's ProjP/ProjM accordingly.
   Flip these two lines if a test vertex comes out with swapped
   chirality. *)
DiracObjToAloha[DiracGamma[6], i_, j_] := AlohaProjP[i, j]
DiracObjToAloha[DiracGamma[7], i_, j_] := AlohaProjM[i, j]

DiracObjToAloha[DiracSigma[DiracGamma[LorentzIndex[mu_, ___]],
                            DiracGamma[LorentzIndex[nu_, ___]]], i_, j_] :=
  AlohaSigma[LorentzIndexLabel[mu], LorentzIndexLabel[nu], i, j]

DiracObjToAloha[1, i_, j_] := AlohaIdentity[i, j]

(* Hook: a bare DOT chain gets matched here and dispatched to the
   appropriate leg pair, consumed in order from the option list. *)
ToAloha[chain_DOT] := Module[{pair},
  If[$RemainingChains === {},
    Message[FCToALOHA::noleg, chain]; $Failed,
    pair = First[$RemainingChains];
    $RemainingChains = Rest[$RemainingChains];
    ChainToAloha[chain, pair]
  ]
]

(* ---------------------------------------------------------------
   3. Stage 2: Aloha* tree -> ALOHA string
   --------------------------------------------------------------- *)

joinArgs[args_List] := StringRiffle[ToString /@ args, ","]

AlohaToString[AlohaGamma[mu_, i_, j_]]      := "Gamma(" <> joinArgs[{mu, i, j}] <> ")"
AlohaToString[AlohaGamma5[i_, j_]]          := "Gamma5(" <> joinArgs[{i, j}] <> ")"
AlohaToString[AlohaProjM[i_, j_]]           := "ProjM(" <> joinArgs[{i, j}] <> ")"
AlohaToString[AlohaProjP[i_, j_]]           := "ProjP(" <> joinArgs[{i, j}] <> ")"
AlohaToString[AlohaSigma[mu_, nu_, i_, j_]] := "Sigma(" <> joinArgs[{mu, nu, i, j}] <> ")"
AlohaToString[AlohaIdentity[i_, j_]]        := "Identity(" <> joinArgs[{i, j}] <> ")"
AlohaToString[AlohaMetric[mu_, nu_]]        := "Metric(" <> joinArgs[{mu, nu}] <> ")"
AlohaToString[AlohaP[mu_, n_]]              := "P(" <> joinArgs[{mu, n}] <> ")"
AlohaToString[AlohaEpsilon[a_, b_, c_, d_]] := "Epsilon(" <> joinArgs[{a, b, c, d}] <> ")"
AlohaToString[AlohaDot[m_, n_]]             := "P(-1," <> ToString[m] <> ")*P(-1," <> ToString[n] <> ")"

AlohaToString[AlohaTimes[args__]] := StringRiffle[AlohaToString /@ {args}, "*"]
AlohaToString[AlohaPlus[args__]]  := "(" <> StringRiffle[AlohaToString /@ {args}, " + "] <> ")"

AlohaToString[c_?NumericQ] := ToString[c]
AlohaToString[I]           := "complex(0,1)"
AlohaToString[x_Symbol]    := SymbolName[x]

(* ---------------------------------------------------------------
   4. Top-level entry point
   --------------------------------------------------------------- *)

FCToALOHA[expr_, legs_Association, OptionsPattern[]] := Module[
  {fcExpr, tree},
  ResetALOHAState[legs];
  $RemainingChains = OptionValue["FermionChains"];
  fcExpr = FCI[expr]; (* normalize to FeynCalc's internal representation *)
  tree = ToAloha[fcExpr];
  AlohaToString[tree]
]

End[]
EndPackage[]
