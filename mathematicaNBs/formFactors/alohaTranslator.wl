(* ::Package:: *)

BeginPackage["alohaTranslator`",{"FeynCalc`"}]


alohaTranslator::usage = "Converts FeynCalc expressions to ALOHA strings.";

Options[alohaTranslator] = {
   MomentumMap -> <||>,
   LorentzMap  -> <||>,
   ColorMap    -> <||>,
   LeftIndex->1,
   RightIndex->1
};

alohaDispatch::usage = "Convertion function. Takes a map with options and a FeynCalc object as basic inputs"

Begin["`Private`"]


(* Helper functions for converting know indices and dummy indices *)

momentumIndex[p_,maps_]:=Lookup[maps["MomentumMap"],p,p]
lorentzIndex[LorentzDummy[mu_],maps_]:=mu
lorentzIndex[mu_,maps_]:=Lookup[maps["LorentzMap"],mu,mu]
colorIndex[c_,maps_]:=Lookup[maps["ColorMap"],c,c]

(* Define the external indices for the Dirac chains *)

spinIndices[n_,maps_]:=Join[{maps["LeftIndex"]},-Range[n-1],{maps["RightIndex"]}]

(* Define conversion for the main objects*)

alohaDispatch[n_Integer,maps_:<||>]:=ToString[n]

alohaDispatch[n_Real,maps_:<||>]:=ToString[n,InputForm]

alohaDispatch[s_Symbol,maps_:<||>]:=SymbolName[Unevaluated[s]]

alohaDispatch[Plus[x__],maps_:<||>]:=StringRiffle[alohaDispatch[#,maps]&/@{x}," + "]

alohaDispatch[Times[x__],maps_:<||>]:=StringRiffle[alohaDispatch[#,maps]&/@{x}," * "]

alohaDispatch[Power[x_,n_],maps_:<||>]:="("<>alohaDispatch[x,maps]<>")**"<>alohaDispatch[n,maps]

alohaDispatch[Rational[a_,b_],maps_:<||>]:="("<>ToString[a]<>"/"<>ToString[b]<>")"

alohaDispatch[SUNFIndex[i_],maps_]:=colorIndex[i,maps]

alohaDispatch[SUNIndex[i_],maps_]:=colorIndex[i,maps]

alohaDispatch[SUNTF[{g_},i_,j_],maps_]:="T("<>StringRiffle[alohaDispatch[#,maps]&/@{g,i,j},","]<>")"

alohaDispatch[DiracGamma[LorentzIndex[mu_,D],D],i_Integer,j_Integer,maps_]:= Module[{i1,i2},
				i1=i;
				i2=j;				
				"Gamma("<>StringRiffle[{ToString[lorentzIndex[mu,maps]],ToString[i1],ToString[i2]},","]<>")"
];

alohaDispatch[DiracGamma[LorentzIndex[mu_,D],D],maps_]:= Module[{i1,i2},
				i1=maps["LeftIndex"];
				i2=maps["RightIndex"];				
				"Gamma("<>StringRiffle[{ToString[lorentzIndex[mu,maps]],ToString[i1],ToString[i2]},","]<>")"
];
(* Helper function for creating dummy indices *)


alohaDispatch[DiracGamma[6],i_Integer,j_Integer,maps_]:= Module[{i1,i2},
				i1=i;
				i2=j;	
				"ProjP("<>ToString[i1]<>","<>ToString[i2]<>")"
				];
alohaDispatch[DiracGamma[6],maps_]:= Module[{i1,i2},
				i1=maps["LeftIndex"];
				i2=maps["RightIndex"];	
				"ProjP("<>ToString[i1]<>","<>ToString[i2]<>")"
				];

alohaDispatch[DiracGamma[7],i_Integer,j_Integer,maps_]:= Module[{i1,i2},
				i1=i;
				i2=j;	
				"ProjM("<>ToString[i1]<>","<>ToString[i2]<>")"
				];
alohaDispatch[DiracGamma[7],maps_]:= Module[{i1,i2},
				i1=maps["LeftIndex"];
				i2=maps["RightIndex"];	
				"ProjM("<>ToString[i1]<>","<>ToString[i2]<>")"
				];

alohaDispatch[Pair[Momentum[p_,D],LorentzIndex[mu_,D]],maps_]:= "P("<>ToString[lorentzIndex[mu,maps]]<>","<>ToString[momentumIndex[p,maps]]<>")";


alohaDispatch[expr_Dot,maps_:<||>]:=Module[{gProduct,pProduct,momenta,gammas,factors,spins,initDummyIndex},
								initDummyIndex = Max[Join[Values[maps["MomentumMap"]],Values[maps["LorentzMap"]],Values[maps["ColorMap"]]]]+1;
								factors=expandChain[expr,initDummyIndex];
								gammas=Cases[factors,_DiracGamma];
								momenta=Cases[factors,_Pair];
								spins=spinIndices[Length[gammas],maps];
								gProduct=MapThread[alohaDispatch[#1,#2,#3,maps]&,{gammas,Most[spins],Rest[spins]}];
								pProduct=Map[alohaDispatch[#,maps]&,momenta];
								StringRiffle[Join[pProduct,gProduct],"*"]
								];


expandChain[expr_Dot,initIndex_]:= Flatten[MapIndexed[expandPSlash[#1,First[#2]+initIndex]&,List@@expr]];

expandPSlash[DiracGamma[Momentum[p_,D],D],dummyIndex_]:=Module[{lIndex},
													lIndex=LorentzDummy[dummyIndex];
													{Pair[Momentum[p,D],LorentzIndex[lIndex,D]],DiracGamma[LorentzIndex[lIndex,D],D]}
												  ];

expandPSlash[x_,dummyIndex_]:={x};
expandChain[x_,initIndex_]:=expandPSlash[x,initIndex];

(* External function to be used as the main translator *)
							
alohaTranslator[expr_,OptionsPattern[]]:=Module[{},
	maps = <|
    "MomentumMap" -> OptionValue[MomentumMap],
    "LorentzMap"  -> OptionValue[LorentzMap],
    "ColorMap"    -> OptionValue[ColorMap],
    "LeftIndex"   -> OptionValue[LeftIndex],
    "RightIndex"  -> OptionValue[RightIndex]
    |>;
	alohaDispatch[expr,maps=maps]								
]	
												
																																				
End[]

EndPackage[]



