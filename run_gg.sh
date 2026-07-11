#!/bin/sh

cd MG5/bin
./mg5_aMC -f ../../gg2tt_proc.dat
cd ../..
./fixForCollier.sh gg2tt_interference_Self_test/
#cp Cards/run_card_NewFormFactors.dat gg2tt_interference_v1/Cards/run_card.dat
cp run_card.dat gg2tt_interference_Self_test/Cards/run_card.dat
cd gg2tt_interference_Self_test/bin
./generate_events
