#!/bin/sh

homeDIR="$( pwd )"


cd $homeDIR

madgraph="MG5_aMC_v3.7.1.tar.gz"
URL=https://launchpad.net/mg5amcnlo/3.0/3.7.x/+download/$madgraph
#madgraph="MG5_aMC_v3.4.2_fix.tar.gz"
echo -n "Install MadGraph (y/n)? "
read answer
if echo "$answer" | grep -iq "^y" ;then
	mkdir MG5;
	echo "[installer] getting MadGraph5"; wget $URL 2>/dev/null || curl -O $URL; 
	tar -zxf $madgraph -C MG5 --strip-components 1;
	cd ./MG5;
	echo "[installer] installing HepMC under MadGraph5"
        echo "install hepmc\ninstall lhapdf6\ninstall pythia8\ninstall Delphes\ninstall collier\nexit\n" > mad_install.txt;
	./bin/mg5_aMC -f mad_install.txt

	rm mad_install.txt;
	cd $homeDIR;
	echo "[installer] copying bias folder"
	cp -r auxFiles/mtt_bias ./MG5/Template/LO/Source/BIAS
#    rm $madgraph;
fi



cd $homeDIR
