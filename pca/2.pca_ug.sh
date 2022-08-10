#!/bin/bash

reference=ug_proteinBB.pdb
trajectory=UG_apo_and_UG_holo.xtc

gmx covar -s $reference -f $trajectory -xpm
echo -e 1 1 | gmx anaeig -v eigenvec.trr -f $trajectory -s $reference -eig eigenval.xvg -comp -proj -first 1 -last 2 -2d 2dproj_BB.xvg

rm -r PC1-PC2
mkdir PC1-PC2
cd PC1-PC2
echo -e 1 1 | gmx anaeig -v ../eigenvec.trr -f ../$trajectory -s ../$reference -eig ../eigenval.xvg -comp -proj -first 1 -last 2 -2d 2dproj_apo.xvg -tu us -b 0 -e 27 
egrep -v "\#|@|\&" 2dproj_apo.xvg > data_apo
echo -e 1 1 | gmx anaeig -v ../eigenvec.trr -f ../$trajectory -s ../$reference -eig ../eigenval.xvg -comp -proj -first 1 -last 2 -2d 2dproj_holo.xvg -tu us -b 27 -e 84
egrep -v "\#|@|\&" 2dproj_holo.xvg > data_holo
cd ..

rm -r PC1-PC3
mkdir PC1-PC3
cd PC1-PC3
echo -e 1 1 | gmx anaeig -v ../eigenvec.trr -f ../$trajectory -s ../$reference -eig ../eigenval.xvg -comp -proj -first 1 -last 3 -2d 2dproj_apo.xvg -tu us -b 0 -e 27 
egrep -v "\#|@|\&" 2dproj_apo.xvg > data_apo
echo -e 1 1 | gmx anaeig -v ../eigenvec.trr -f ../$trajectory -s ../$reference -eig ../eigenval.xvg -comp -proj -first 1 -last 3 -2d 2dproj_holo.xvg -tu us -b 27 -e 84
egrep -v "\#|@|\&" 2dproj_holo.xvg > data_holo
cd ..

rm -r PC2-PC3
mkdir PC2-PC3
cd PC2-PC3
echo -e 1 1 | gmx anaeig -v ../eigenvec.trr -f ../$trajectory -s ../$reference -eig ../eigenval.xvg -comp -proj -first 2 -last 3 -2d 2dproj_apo.xvg -tu us -b 0 -e 27 
egrep -v "\#|@|\&" 2dproj_apo.xvg > data_apo
echo -e 1 1 | gmx anaeig -v ../eigenvec.trr -f ../$trajectory -s ../$reference -eig ../eigenval.xvg -comp -proj -first 2 -last 3 -2d 2dproj_holo.xvg -tu us -b 27 -e 84
egrep -v "\#|@|\&" 2dproj_holo.xvg > data_holo
cd ..

