(* ::Package:: *)

(* ============================================================ *)
(*  UFOFormFactorExport                                          *)
(*                                                                *)
(*  Given a list of FeynCalc-style coefficients (couplings,       *)
(*  color structures, and form-factor Lorentz pieces), appends    *)
(*  new Coupling / Lorentz / Vertex definitions to a copy of an   *)
(*  existing UFO model.                                           *)
(*                                                                *)
(*  Depends on an external "alohaTranslator" package (not         *)
(*  included here) that turns a FeynCalc expression into the      *)
(*  string syntax expected in UFO .py files.                    *)
(* ============================================================ *)

BeginPackage["UFOFormFactorExport`",{"alohaTranslator`"}]

ExportUFOVertexFormFactors::usage =
  "ExportUFOVertexFormFactors[coefficients, originalModelDir, newModelDir] \
copies couplings.py, lorentz.py and vertices.py from originalModelDir into \
newModelDir, and appends new Coupling, Lorentz and Vertex definitions built \
from coefficients. coefficients must be a list of 4-element lists \
{coupling, color, factor1, factor2}. Returns the name of the new vertex \
(e.g. \"V_124\"). Requires the option \"CouplingOrders\" to be set.";

ExportUFOVertexFormFactors::noorders =
  "The option \"CouplingOrders\" must be set to an association mapping each \
coupling symbol appearing in `coefficients` to its UFO order string, e.g. \
<|yDM -> \"'NP'\", gs -> \"'QCD'\"|>.";

Begin["`Private`"]

Options[ExportUFOVertexFormFactors] = {
  "CouplingOrders" -> None,
  "Particles" -> {"t__tilde__", "t", "g"},
  "Spins" -> {2, 2, 3},
  "FormFactorTag" -> "FFVNP",
  "LorentzTag" -> "FFV",
  "AlohaOptions" -> {}
};

ExportUFOVertexFormFactors[coefficients_List, originalModelDir_String,
   newModelDir_String, opts : OptionsPattern[]] := Module[
  {couplingOrders, particles, spins, formFactorTag, lorentzTag, translator, alohaOpts,
   ufoMap, couplingsFile, newCouplingsFile, text, couplingDefs, maxGCvar,
   maxGCname, newGCcounter, couplingTemplate, outF, name, order, value,
   blockValues, lorentzFile, newLorentzFile, lorentzDefs, maxFvar,
   maxFname, newFcounter, lorentzTemplate, vertexFile, newVertexFile,
   vertexDefs, maxVvar, maxVname, newVcounter, vertexName, colorList,
   couplingsList, lorentzList, vertexList, coupling, color, formFactor,
   indexColor, indexLorentz, colorListStr, lorentzListStr, vertexListStr,
   vertexTemplate},

  couplingOrders = OptionValue["CouplingOrders"];
  If[couplingOrders === None,
    Message[ExportUFOVertexFormFactors::noorders];
    Return[$Failed]
  ];

  particles = OptionValue["Particles"];
  spins = OptionValue["Spins"];
  formFactorTag = OptionValue["FormFactorTag"];
  lorentzTag = OptionValue["LorentzTag"];
  alohaOpts = OptionValue["AlohaOptions"];

  translator = alohaTranslator`alohaTranslator;

  ufoMap = <|"couplings" -> <||>, "lorentz" -> <||>, "color" -> <||>|>;

  (* ---------------- Couplings ---------------- *)
  couplingsFile = FileNameJoin[{originalModelDir, "couplings.py"}];
  newCouplingsFile = FileNameJoin[{newModelDir, "couplings.py"}];
  CopyFile[couplingsFile, newCouplingsFile, OverwriteTarget -> True];
  text = Import[couplingsFile, "Text"];
  couplingDefs = StringCases[text,
     RegularExpression[
       "(GC_\\d+)\\s*=\\s*Coupling\\(\\s*name\\s*=\\s*'([^']*)'"] :> {"$1",
       "$2"}];
  maxGCvar = Max[ToExpression@StringDrop[#, 3] & /@ couplingDefs[[All, 1]]];
  maxGCname = Max[ToExpression@StringDrop[#, 3] & /@ couplingDefs[[All, 2]]];
  newGCcounter = Max[maxGCname, maxGCvar] + 1;

  couplingTemplate = StringTemplate[
    "`name` = Coupling(name = '`name`',\n                 value = \
'`value`',\n                 order = `order`)\n"];

  outF = OpenAppend[newCouplingsFile, PageWidth -> Infinity];
  WriteString[outF, "\n#----------- New Couplings --------\n"];
  Do[
    name = "GC_" <> ToString[newGCcounter];
    AssociateTo[ufoMap["couplings"], ToString[couplingTerm] -> name];
    newGCcounter++;
    order = "{" <> StringRiffle[
        Table[
          couplingOrders[coupling] <> ":" <>
           ToString[Exponent[couplingTerm, coupling]],
          {coupling, Keys[couplingOrders]}], ","] <> "}";
    value = translator[couplingTerm, alohaOpts];
    blockValues = <|"name" -> name, "value" -> value, "order" -> order|>;
    WriteString[outF, couplingTemplate[blockValues]];
    , {couplingTerm, DeleteDuplicates[coefficients[[All, 1]]]}
  ];
  Close[outF];

  (* ---------------- Lorentz ---------------- *)
  lorentzFile = FileNameJoin[{originalModelDir, "lorentz.py"}];
  newLorentzFile = FileNameJoin[{newModelDir, "lorentz.py"}];
  CopyFile[lorentzFile, newLorentzFile, OverwriteTarget -> True];
  text = Import[lorentzFile, "Text"];
  lorentzDefs = StringCases[text,
     RegularExpression[
       "("<>lorentzTag<>"\\d+)\\s*=\\s*Lorentz\\(\\s*name\\s*=\\s*'([^']*)'"] :> {"$1",
       "$2"}];
  maxFvar = Max[ToExpression@StringDrop[#, 3] & /@ lorentzDefs[[All, 1]]];
  maxFname = Max[ToExpression@StringDrop[#, 3] & /@ lorentzDefs[[All, 2]]];
  newFcounter = Max[maxFname, maxFvar] + 1;

  lorentzTemplate = StringTemplate[
    "`name` = Lorentz(name = '`name`',\n                 spins = [ " <>
     StringRiffle[ToString /@ spins, ", "] <>
     " ],\n                 structure = '`value`')\n"];

  outF = OpenAppend[newLorentzFile, PageWidth -> Infinity];
  WriteString[outF, "\n#----------- New Lorentz Structures --------\n"];
  Do[
    name = formFactorTag <> ToString[newFcounter];
    AssociateTo[ufoMap["lorentz"], ToString[c[[3]]*c[[4]]] -> name];
    newFcounter++;
    (* Translate each piece individually instead of expanding the product,
       to keep the resulting expression shorter *)
    value = "(" <> translator[c[[3]], alohaOpts] <> ") * (" <>
      translator[c[[4]], alohaOpts] <> ")";
    blockValues = <|"name" -> name, "value" -> value|>;
    WriteString[outF, lorentzTemplate[blockValues]];
    , {c, coefficients}
  ];
  Close[outF];

  (* ---------------- Vertex ---------------- *)
  vertexFile = FileNameJoin[{originalModelDir, "vertices.py"}];
  newVertexFile = FileNameJoin[{newModelDir, "vertices.py"}];
  CopyFile[vertexFile, newVertexFile, OverwriteTarget -> True];
  text = Import[vertexFile, "Text"];
  vertexDefs = StringCases[text,
     RegularExpression[
       "(V_\\d+)\\s*=\\s*Vertex\\(\\s*name\\s*=\\s*'([^']*)'"] :> {"$1",
       "$2"}];
  maxVvar = Max[ToExpression@StringDrop[#, 2] & /@ vertexDefs[[All, 1]]];
  maxVname = Max[ToExpression@StringDrop[#, 2] & /@ vertexDefs[[All, 2]]];
  newVcounter = Max[maxVvar, maxVname] + 1;
  vertexName = "V_" <> ToString[newVcounter];

  Do[
    value = translator[color, alohaOpts];
    AssociateTo[ufoMap["color"], ToString[color] -> value],
    {color, coefficients[[All, 2]]}
  ];

  colorList = DeleteDuplicates[Values[ufoMap["color"]]];
  couplingsList = DeleteDuplicates[Values[ufoMap["couplings"]]];
  lorentzList = DeleteDuplicates[Values[ufoMap["lorentz"]]];
  vertexList = {};
  Do[
    coupling = ufoMap["couplings"][ToString[c[[1]]]];
    color = ToString[c[[2]]];
    formFactor = ToString[c[[3]]*c[[4]]];
    indexColor = Position[colorList, ufoMap["color"][color]][[1, 1]] - 1;
    indexLorentz =
     Position[lorentzList, ufoMap["lorentz"][formFactor]][[1, 1]] - 1;
    AppendTo[vertexList,
     "(" <> ToString[indexColor] <> "," <> ToString[indexLorentz] <>
      "):C." <> coupling];
    , {c, coefficients}
  ];

  colorListStr =
   StringRiffle[Table["'" <> color <> "'", {color, colorList}], ", "];
  lorentzListStr = StringRiffle[Table["L." <> l, {l, lorentzList}], ", "];
  vertexListStr = StringRiffle[vertexList, ", "];

  blockValues = <|
    "name" -> vertexName,
    "colorList" -> colorListStr,
    "lorentzList" -> lorentzListStr,
    "couplingsList" -> vertexListStr
  |>;

  vertexTemplate = StringTemplate[
    "`name` = Vertex(name = '`name`',\n               particles=[" <>
     StringRiffle["P." <> # & /@ particles, ","] <>
     "],\n               color = [ `colorList` ],\n               \
lorentz = [ `lorentzList` ],\n               couplings = \
{`couplingsList`})\n"];

  outF = OpenAppend[newVertexFile, PageWidth -> Infinity];
  WriteString[outF, "\n#----------- New Vertices --------\n"];
  WriteString[outF, vertexTemplate[blockValues]];
  Close[outF];

  vertexName
]

End[]

EndPackage[]
