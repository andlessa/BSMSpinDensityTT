#!/bin/sh

currentDIR="$( pwd )"

[ ! -d "$1" ] && echo "Directory $1 DOES NOT exists.\n Please, pass a valid process folder as the first argument" && exit


procDIR="$(cd "$(dirname "$1")" >/dev/null; pwd -P)/$(basename "$1")"

for f in ./MG5/HEPTools/collier/COLLIER*; do
    coolDIR=$f
done


cp auxFiles/SubProcesses/makefile $procDIR/SubProcesses/
cp auxFiles/Source/makefile $procDIR/Source/
cp $coolDIR/modules/collier.mod $procDIR/Source/MODEL/
cp $coolDIR/libcollier.a $procDIR/lib

echo "Fixes for $procDIR done."

