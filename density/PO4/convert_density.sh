protein=ug
main_factory=1 #100

ls .. | grep density | grep xvg | cut -d "_" -f1 | sort -n > 111
ls .. | grep density | grep xvg | cut -d "_" -f2 | sort -n > 222
paste 111 222 > 333
sed "s/$(echo '\t')//g" 333 | sed "s/y/y_/g" > list_density
rm 111 222 333

lines=$(wc -l list_density | cut -d " " -f 1)

p=1
while [ $p -le 3 ]

do

e=1

for ((l=1 ; l <= $lines ; l+=1)) do

	
	file_den=$(head -n $l list_density | tail -n1)
	echo protein $protein production $p $file_den 
	
	if [ $p -eq 1 ]; then
		more ../$file_den > density_con1.xvg	
	fi

	if [ $p -eq 2 ]; then
		more ../../../${protein}_dimer.replica2/DENSITY/$file_den > density_con1.xvg	
	fi

	if [ $p -eq 3 ]; then
		more ../../../${protein}_dimer.replica3/DENSITY/$file_den > density_con1.xvg	
	fi

	control=$(ls .. | grep density | grep xvg | cut -d "_" -f2 | sort -n | cut -d "." -f1 | head -n$l | tail -n1)
	
	ex_con=$(head -n$e exclude_group.dat | tail -n1)

	# We just apply transformation for residues
	if [ $control -ne $ex_con ]; then

		factory=$main_factory
		sed s'/##factory##/'${factory}'/'g convert_density.py > convert.py
		python convert.py
		mv density_con2.xvg pro${p}_${file_den}
		rm convert.py

	else

		factory=1
		sed s'/##factory##/'${factory}'/'g convert_density.py > convert.py
		python convert.py
		mv density_con2.xvg pro${p}_${file_den}
		e=$[ $e + 1 ]
		rm convert.py

	fi

done

p=$[ $p + 1 ]

done

rm density_con1.xvg
chmod +x average_density.sh figures*.sh
echo 'Calculating average!'
./average_density.sh
echo 'Generating figures!'
./figures1.sh
./figures2.sh
./figures3.sh
./figures4.sh



