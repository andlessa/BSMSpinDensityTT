(* ::Package:: *)

BeginPackage["alohaTranslator`",{"FeynCalc`"}]


alohaTranslator::usage = "Converts FeynCalc expressions to ALOHA strings.";
alohaTranslator::badindex = "The value `1` given for `2` must be a positive integer.";
alohaTranslator::badmap = "The map `1` contains values that are not positive integers: `2`.";
alohaDispatch::usage = "Helper Function defined over each type of object";

Options[alohaTranslator] = {
   MomentumMap -> <|$p1->1, $p2->2, $p3->3|>,
   LorentzMap  -> <|$mu->3,$nu->4|>,
   ColorMap    -> <|$c1->1,$c2->2,$c3->3|>,
   LeftIndex -> 2,
   RightIndex -> 1
};

Begin["`Private`"]
(* Helper functions for converting know indices and dummy indices *)

momentumIndex[p_]:=Lookup[$maps["MomentumMap"],p,p];
lorentzIndex[LorentzDummy[mu_]]:=mu;
lorentzIndex[mu_]:=Lookup[$maps["LorentzMap"],mu,mu];
colorIndex[c_]:=Lookup[$maps["ColorMap"],c,c];

(* Helper function for keeping track of dummy indices *)
(* inside a translator call all dummy indices are unique (even if appearing in distinct sum terms) *)
newDummyIndex[]:=Module[{mu},mu=$currentDummyIndex; $currentDummyIndex--;mu];
resetDummyIndex[]:=Module[{},$currentDummyIndex=$initDummyIndex;];

(* Define the external indices for the Dirac chains *)
spinIndices[n_]:=Module[{i},
					firstIndex = {$leftIndex};
					lastIndex = {$rightIndex};
					dummyIndices = Table[newDummyIndex[],{i,1,n-1}];
					Join[firstIndex,dummyIndices,lastIndex]];


(* Define conversion for the main objects*)

alohaDispatch[I]:="complex(0,1)";

alohaDispatch[Sqrt[x_]]:="cmath.sqrt("<>alohaDispatch[x]<>")";

alohaDispatch[Log[x_]]:="cmath.dlog("<>alohaDispatch[x]<>")";

alohaDispatch[n_Integer]:=ToString[n];

alohaDispatch[n_Real]:=ToString[n,InputForm];

alohaDispatch[s_Symbol]:=SymbolName[Unevaluated[s]];

alohaDispatch[expr_Times]:= StringRiffle[alohaDispatch /@ (List @@ Expand[expr]), "*"];

alohaDispatch[expr_Plus]:= StringRiffle[alohaDispatch /@ (List @@ Expand[expr]), " + "];

alohaDispatch[Power[x_,n_]]:="("<>alohaDispatch[x]<>")**"<>alohaDispatch[n];

alohaDispatch[Rational[a_,b_]]:="("<>ToString[a]<>"/"<>ToString[b]<>")";

alohaDispatch[SUNFIndex[i_]]:=colorIndex[i];

alohaDispatch[SUNIndex[i_]]:=colorIndex[i];

alohaDispatch[SUNTF[{a_},i_,j_]]:="T("<>StringRiffle[alohaDispatch[#]&/@{a,i,j},","]<>")";
alohaDispatch[SUNTF[{a_,b_},i_,j_]]:=Module[{dummyIndex,t1,t2},
											dummyIndex = newDummyIndex[];
											t1 = alohaDispatch[SUNTF[{a},i,dummyIndex]];
											t2 = alohaDispatch[SUNTF[{b},dummyIndex,j]];
											t1<>"*"<>t2];
											
alohaDispatch[DiracGamma[LorentzIndex[mu_,___],___],i_:$leftIndex,j_:$rightIndex]:="Gamma("<>StringRiffle[{ToString[lorentzIndex[mu]],ToString[i],ToString[j]},","]<>")";
alohaDispatch[DiracGamma[5],i_:$leftIndex,j_:$rightIndex]:= "Gamma5("<>ToString[i]<>","<>ToString[j]<>")";				
alohaDispatch[DiracGamma[6],i_:$leftIndex,j_:$rightIndex]:= "ProjP("<>ToString[i]<>","<>ToString[j]<>")";
alohaDispatch[DiracGamma[7],i_:$leftIndex,j_:$rightIndex]:= "ProjM("<>ToString[i]<>","<>ToString[j]<>")";
alohaDispatch[DiracGamma[Momentum[p_,___],___],i_:$leftIndex,j_:$rightIndex]:= Module[{lIndex,momentum,gamma},
										lIndex=LorentzDummy[newDummyIndex[]];
										momentum=Pair[Momentum[p],LorentzIndex[lIndex]];
										gamma=DiracGamma[LorentzIndex[lIndex]];
										alohaDispatch[momentum]<>"*"<>alohaDispatch[gamma,i,j]
										];

alohaDispatch[Pair[LorentzIndex[a_,___],LorentzIndex[b_,___]]]:="Metric("<>ToString[lorentzIndex[a]]<>","<>ToString[lorentzIndex[b]]<>")";
alohaDispatch[Pair[Momentum[p_,___],LorentzIndex[mu_,___]]]:= "P("<>ToString[lorentzIndex[mu]]<>","<>ToString[momentumIndex[p]]<>")";
alohaDispatch[Pair[Momentum[p1_,___],Momentum[p2_,___]]]:= Module[{dummyIndex,mom1,mom2},
																dummyIndex=newDummyIndex[];
																mom1=alohaDispatch[Pair[Momentum[p1],LorentzIndex[LorentzDummy[dummyIndex]]]];
																mom2=alohaDispatch[Pair[Momentum[p2],LorentzIndex[LorentzDummy[dummyIndex]]]];
																mom1<>"*"<>mom2];
alohaDispatch[expr_Dot]:=Module[{factors,spins,gProduct},
								factors=List@@expr;
								spins=spinIndices[Length[factors]];
								gProduct=MapThread[alohaDispatch[#1,#2,#3]&,{factors,Most[spins],Rest[spins]}];
								StringRiffle[gProduct,"*"]
								];

							    
alohaDispatch[expr_[x__]] := ToString[expr]<>"( "<>StringRiffle[Map[alohaDispatch,{x}],", "]<>" )";

(* External function to be used as the main translator *)
							
alohaTranslator[expr_,OptionsPattern[]]:=Block[{$maps,$initDummyIndex,$currentDummyIndex,$leftIndex,$rightIndex,
											   leftVal,rightVal,momMap,lorMap,colMap,positiveIntegerQ},
	    
    leftVal  = OptionValue[LeftIndex];
    rightVal = OptionValue[RightIndex];
    momMap   = OptionValue[MomentumMap];
    lorMap   = OptionValue[LorentzMap];
    colMap   = OptionValue[ColorMap];
    positiveIntegerQ[x_]:=IntegerQ[x]&&Positive[x];

    If[!positiveIntegerQ[leftVal],
        Message[alohaTranslator::badindex, leftVal, "LeftIndex"]; Return[$Failed]];
    If[!positiveIntegerQ[rightVal],
        Message[alohaTranslator::badindex, rightVal, "RightIndex"]; Return[$Failed]];

    Catch[
        Do[
            If[!AllTrue[Values[maps], positiveIntegerQ],
                Message[alohaTranslator::badmap, names, Select[Values[maps], !positiveIntegerQ[#]&]];
                Throw[$Failed]
            ],
            {maps, {momMap, lorMap, colMap}}, {names, {"MomentumMap","LorentzMap","ColorMap"}}
        ]
    ];
    
    $maps = <|
    "MomentumMap" -> OptionValue[MomentumMap],
    "LorentzMap"  -> OptionValue[LorentzMap],
    "ColorMap"    -> OptionValue[ColorMap]
    |>;
    
    $leftIndex = OptionValue[LeftIndex];
    $rightIndex = OptionValue[RightIndex];

    $initDummyIndex = -1;
    $currentDummyIndex = $initDummyIndex;
	alohaDispatch[expr]								
]	
												
																																				
End[]
EndPackage[]
