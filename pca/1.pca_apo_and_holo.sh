#!/bin/bash

reference=ug_proteinBB.pdb
trajectory=trajUG_no-mem_trajBR_no-mem_and_trajUG_yes-mem_trajBR_yes.xtc

gmx covar -s $reference -f $trajectory -xpm

echo -e 1 1 | gmx anaeig -v eigenvec.trr -f $trajectory -s $reference -eig eigenval.xvg -comp -proj -first 1 -last 2 -2d

for ((i=1; i<=1 ; i+=1)) do

	if [ $i -eq 1 ];then
		first_pc=1
		second_pc=2
	fi
	
	if [ $i -eq 2 ];then
		first_pc=1
		second_pc=3
	fi
	
	if [ $i -eq 3 ];then
		first_pc=2
		second_pc=3
	fi

	rm -r PC${first_pc}-PC${second_pc}
	mkdir PC${first_pc}-PC${second_pc}
	cd PC${first_pc}-PC${second_pc}

	mkdir ug_without_mem
	cd ug_without_mem
	echo -e 1 1 | gmx anaeig -v ../../eigenvec.trr -f ../../$trajectory -s ../../$reference -eig ../../eigenval.xvg -comp -proj -first ${first_pc} -last ${second_pc} -2d 2dproj_BB_UG.xvg -b 0 -e 27 -tu us
	egrep -v "\#|@|\&" 2dproj_BB_UG.xvg > data
	cd ..

	mkdir br_without_mem
	cd br_without_mem
	echo -e 1 1 | gmx anaeig -v ../../eigenvec.trr -f ../../$trajectory -s ../../$reference -eig ../../eigenval.xvg -comp -proj -first ${first_pc} -last ${second_pc} -2d 2dproj_BB_BR.xvg -b 27 -e 54 -tu us
	egrep -v "\#|@|\&" 2dproj_BB_BR.xvg > data
	cd ..

	mkdir ug_with_mem
	cd ug_with_mem
	echo -e 1 1 | gmx anaeig -v ../../eigenvec.trr -f ../../$trajectory -s ../../$reference -eig ../../eigenval.xvg -comp -proj -first ${first_pc} -last ${second_pc} -2d 2dproj_BB_UG.xvg -b 54 -e 111 -tu us
	egrep -v "\#|@|\&" 2dproj_BB_UG.xvg > data
	cd ..

	mkdir br_with_mem
	cd br_with_mem
	echo -e 1 1 | gmx anaeig -v ../../eigenvec.trr -f ../../$trajectory -s ../../$reference -eig ../../eigenval.xvg -comp -proj -first ${first_pc} -last ${second_pc} -2d 2dproj_BB_BR.xvg -b 111 -e 168 -tu us
	egrep -v "\#|@|\&" 2dproj_BB_BR.xvg > data
	cd ..
	
cd ..

done
