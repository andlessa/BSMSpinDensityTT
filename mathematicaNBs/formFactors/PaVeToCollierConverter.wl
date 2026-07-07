(* ::Package:: *)

(* ============================================================ *)
(*  PaVeToCollierConverter                                       *)
(*                                                                *)
(*  Converts the PaVe,A0,B0,B1,C0,D0 functions from FeynCalc     *)
(*  to the notation used in Collier                              *)
(* Here is a list of the main functions                          *)
(*       C0 = Ccoll(0,0,0)      *)
(*       C00 = Ccoll(1,0,0)     *)
(*       C1 = Ccoll(0,1,0)      *)
(*       C2 = Ccoll(0,0,1)      *)
(*       C11 = Ccoll(0,2,0)     *)
(*       C22 = Ccoll(0,0,2)     *)
(*       C12 = Ccoll(0,1,1)     *)
(*       D0 = Dcoll(0,0,0,0)    *)
(*       D1 = Dcoll(0,1,0,0)    *)
(*       D2 = Dcoll(0,0,1,0)    *)
(*       D3 = Dcoll(0,0,0,1)    *)
(*       D00 = Dcoll(1,0,0,0)    *)
(*       D11 = Dcoll(0,2,0,0)    *)
(*       D12 = Dcoll(0,1,1,0)    *)
(*       D13 = Dcoll(0,1,0,1)    *)
(*       D22 = Dcoll(0,0,2,0)    *)
(*       D23 = Dcoll(0,0,1,1)    *)
(*       D33 = Dcoll(0,0,0,2)    *)
(*       D001 = Dcoll(1,1,0,0)    *)
(*       D002 = Dcoll(1,0,1,0)    *)
(*       D003 = Dcoll(1,0,0,1)    *)
(*       D111 = Dcoll(0,3,0,0)    *)
(*       D112 = Dcoll(0,2,1,0)    *)
(*       D113 = Dcoll(0,2,0,1)    *)
(*       D122 = Dcoll(0,1,2,0)    *)
(*       D123 = Dcoll(0,1,1,1)    *)
(*       D133 = Dcoll(0,1,0,2)    *)
(*       D222 = Dcoll(0,0,3,0)    *)
(*       D223 = Dcoll(0,0,2,1)    *)
(*       D233 = Dcoll(0,0,1,2)    *)
(*       D333 = Dcoll(0,0,0,3)    *)

(*  Depends on an external "alohaTranslator" package (not         *)
(*  included here) that turns a FeynCalc expression into the      *)
(*  string syntax expected in UFO .py files.                    *)
(* ============================================================ *)

BeginPackage["PaVeToCollierConverter`",{"FeynCalc`"}]

PaVeToCollier::usage =
  "PaVeToCollier[PaVe] \
returns a new function following the Collier numbering convention";

convertScalarInt::usage =
  "convertScalarInt[PaVe] \
convert a scalar integral to a PaVe object";

PaVeToCollier::badmass =
  "The option \"MassList\" must be match the masses appearing in the PaVe functions,
  i.e. {mChi^2,mST^2,mST^} for C-functions.";


Options[PaVeToCollier] = {
  MassList -> {}
};

Begin["`Private`"]

convertScalarInt[A0[m1_]]:=PaVe[0,{},{m1}];
convertScalarInt[B0[p1_,m1_,m2_]]:=PaVe[0,{p1},{m1,m2}];
convertScalarInt[B1[p1_,m1_,m2_]]:=PaVe[1,{p1},{m1,m2}];
convertScalarInt[C0[p1_,p2_,p3_,m1_,m2_,m3_]]:=PaVe[0,{p1,p2,p3},{m1,m2,m3}];
convertScalarInt[D0[p1_,p2_,p3_,p4_,p5_,p6_,m1_,m2_,m3_,m4_]]:=PaVe[0,{p1,p2,p3,p4,p5,p6},{m1,m2,m3,m4}];
convertScalarInt[x_]:=x;

getPaVeIndices[PaVe[inds___,kin_List,masses_List,opt___]]:={inds};
getPaVeType[PaVe[inds___,kin_List,masses_List,opt___]]:=Which[Length[kin]==0,"A",Length[kin]==1,"B",Length[kin]==3,"C",Length[kin]==6,"D"];
getPaVeOrder[x_]:=Module[{type},
					type=getPaVeType[x];
					Which[type=="A",0,type=="B",1,type=="C",2,type=="D",3]];
getPaVeMasses[PaVe[inds___,kin_List,masses_List,opt___]]:=masses;
getPaVeMomenta[PaVe[inds___,kin_List,masses_List,opt___]]:=kin;

					
PaVeToCollier[loopIntegral_, OptionsPattern[]] :=Module[{masses,momenta,collMom,inputMasses,pave,n0,ns,order,indices,type,collFunc,collIndices},
		inputMasses = OptionValue[MassList];
		pave = convertScalarInt[loopIntegral];
		masses=getPaVeMasses[pave];
		momenta=getPaVeMomenta[pave];
		If[inputMasses[[-Length[masses];;]] =!= masses,
				Message[PaVeToCollier::badmass, inputMasses, masses];
                Throw[$Failed]
           ];
		
		order=getPaVeOrder[pave];
		indices= getPaVeIndices[pave];
		type=getPaVeType[pave];
		(*drop the leading A/B/C/D letter*)
		If[indices==={0},
			(*scalar function,e.g."D0"->all zeros*)
			collIndices=StringRiffle[Table[0,{order+1}],","],
			n0=Count[indices,0]/2;
			ns=Table[Count[indices,k],{k,1,order}];
			collIndices=StringRiffle[Prepend[ns,n0],","]];
		collMom=StringRiffle[Table[ToString[mom],{mom,momenta}],","];
		collFunc=ToExpression[type<>"coll["<>collIndices<>","<>collMom<>"]"]
]

End[]

EndPackage[]
