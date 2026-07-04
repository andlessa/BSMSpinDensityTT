(* ::Package:: *)

BeginPackage["alohaTranslator`",{"FeynCalc`"}]
alohaTranslator::usage = "Converts FeynCalc expressions to ALOHA strings.";

Options[alohaTranslator] = {
   MomentumMap -> <|$p1->1, $p2->2, $p3->3|>,
   LorentzMap  -> <|$mu->3,$nu->4|>,
   ColorMap    -> <|$c1->1,$c2->2,$c3->3|>,
   LeftIndex -> 1,
   RightIndex -> 1
};

alohaDispatch::usage = "Convertion function. Takes a map with options and a FeynCalc object as basic inputs"

Begin["`Private`"]
(* Helper functions for converting know indices and dummy indices *)

(* module-level variable, not passed around *)
$maps = <||>;
$initDummyIndex = 1;
$currentDummyIndex = $initDummyIndex;

momentumIndex[p_]:=Lookup[$maps["MomentumMap"],p,p]
lorentzIndex[LorentzDummy[mu_]]:=mu
lorentzIndex[mu_]:=Lookup[$maps["LorentzMap"],mu,mu]
colorIndex[c_]:=Lookup[$maps["ColorMap"],c,c]
$leftIndex = 2;
$rightIndex =1;

(* Define the external indices for the Dirac chains *)

spinIndices[n_]:=Join[{$leftIndex},-Range[n-1],{$rightIndex}]

(* Helper function for creating dummy indices *)
newDummyLorentz[]:=Module[{mu},mu=LorentzDummy[$currentDummyIndex]; $currentDummyIndex++;mu]
resetLorentz[]:=Module[{},$currentDummyIndex=$initDummyIndex;]

(* Define conversion for the main objects*)

alohaDispatch[n_Integer]:=ToString[n];

alohaDispatch[n_Real]:=ToString[n,InputForm];

alohaDispatch[s_Symbol]:=SymbolName[Unevaluated[s]];

alohaDispatch[Plus[x__]]:=StringRiffle[alohaDispatch[#]&/@{x}," + "];

alohaDispatch[Times[x__]]:=StringRiffle[alohaDispatch[#]&/@{x}," * "];

alohaDispatch[Power[x1_,n_]]:="("<>alohaDispatch[x]<>")**"<>alohaDispatch[n];

alohaDispatch[Rational[a_,b_]]:="("<>ToString[a]<>"/"<>ToString[b]<>")"

alohaDispatch[SUNFIndex[i_]]:=colorIndex[i];

alohaDispatch[SUNIndex[i_]]:=colorIndex[i];

alohaDispatch[SUNTF[{g_},i_,j_]]:="T("<>StringRiffle[alohaDispatch[#]&/@{g,i,j},","]<>")";

alohaDispatch[DiracGamma[LorentzIndex[mu_,___],___],i_:$leftIndex,j_:$rightIndex]:= "Gamma("<>StringRiffle[{ToString[lorentzIndex[mu]],ToString[i],ToString[j]},","]<>")";
alohaDispatch[DiracGamma[5],i_:$leftIndex,j_:$rightIndex]:= "Gamma5("<>ToString[i]<>","<>ToString[j]<>")";				
alohaDispatch[DiracGamma[6],i_:$leftIndex,j_:$rightIndex]:= "ProjP("<>ToString[i]<>","<>ToString[j]<>")";
alohaDispatch[DiracGamma[7],i_:$leftIndex,j_:$rightIndex]:= "ProjM("<>ToString[i]<>","<>ToString[j]<>")";
alohaDispatch[Pair[Momentum[p_,___],LorentzIndex[mu_,___]]]:= "P("<>ToString[lorentzIndex[mu]]<>","<>ToString[momentumIndex[p]]<>")";

alohaDispatch[expr_Dot]:=Module[{gProduct,pProduct,momenta,gammas,factors,spins},
								factors=expandChain[expr];
								gammas=Cases[factors,_DiracGamma];
								momenta=Cases[factors,_Pair];
								spins=spinIndices[Length[gammas]];
								gProduct=MapThread[alohaDispatch[#1,#2,#3]&,{gammas,Most[spins],Rest[spins]}];
								pProduct=Map[alohaDispatch[#]&,momenta];
								StringRiffle[Join[pProduct,gProduct],"*"]
								];
expandChain[expr_Dot]:= Flatten[Map[expandPSlash,List@@expr]];

expandPSlash[DiracGamma[Momentum[p_,___],___]]:=Module[{lIndex},
													lIndex=newDummyLorentz[];
													{Pair[Momentum[p,___],LorentzIndex[lIndex,___]],DiracGamma[LorentzIndex[lIndex,___],___]}
												  ];

expandPSlash[x_]:={x};
expandChain[x_]:=expandPSlash[x];

(* External function to be used as the main translator *)
							
alohaTranslator[expr_,OptionsPattern[]]:=Block[{$maps,$initDummyIndex,$currentDummyIndex,$leftIndex,$rightIndex},
	$maps = <|
    "MomentumMap" -> OptionValue[MomentumMap],
    "LorentzMap"  -> OptionValue[LorentzMap],
    "ColorMap"    -> OptionValue[ColorMap]
    |>;
    
    
    $leftIndex = OptionValue[LeftIndex];
    $rightIndex = OptionValue[RightIndex];
    $currentDummyIndex=Max[Join[{$leftIndex,$rightIndex},Values[$maps["MomentumMap"]],Values[$maps["LorentzMap"]],Values[$maps["ColorMap"]]]]+1;
    $currentDummyIndex = $currentDummyIndex;
	alohaDispatch[expr]								
]	
												
																																				
End[]
EndPackage[]




