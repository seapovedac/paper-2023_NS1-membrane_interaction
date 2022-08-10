# This script create figures for density calculations
# 12/04/2021

fig_directory=figure_b-roll
rm -r $fig_directory
mkdir $fig_directory

protein='UG'
domain='\\xb\\f{}-roll'
group='PO4'
lipid_group=37
fill_color=15 # Color for lipid group

x1=-6
x2=6
x_maj=2

y1=0
y2=2.5 #2.5
y_maj=0.5 #0.5

index_res_begin=1
index_res_end=11
max_res=6	# Maximum residue per figure
cc_res=1	
cc_col=1	# Count grace color
cc_fig=1

sed 's/##fill_color##/'${fill_color}'/g' density_figure.par | sed 's/##protein##/'${protein}'/g' | sed 's/##domain##/'${domain}'/g' | sed 's/##group##/'${group}'/g' | sed 's/##x1##/'${x1}'/g' | sed 's/##x2##/'${x2}'/g' | sed 's/##y1##/'${y1}'/g' | sed 's/##y2##/'${y2}'/g' | sed 's/##x_maj##/'${x_maj}'/g' | sed 's/##y_maj##/'${y_maj}'/g' > main_head

for (( r=${index_res_begin}; r<=${index_res_end}; r+=1 )) do

	#echo $r $cc_res asdasd

	if [ ${cc_res} -eq 1 ]; then
		echo -n "gracebat " > hola
		echo -n "density/0.average_curve_${lipid_group}.dat " >> hola
	fi
	
	if [ ${cc_col} -eq 5 ]; then
		cc_col=$[ $cc_col + 4 ]
	fi

	if [ ${cc_col} -eq 10 ]; then
		cc_col=$[ $cc_col + 1 ]
	fi

	residue=$(grep -w "$r" list_residues.dat | cut -f2)

	echo "	s${cc_res} symbol 1
	s${cc_res} symbol size 0.5
	s${cc_res} symbol color ${cc_col}
	s${cc_res} symbol pattern 1
	s${cc_res} symbol fill color ${cc_col}
	s${cc_res} symbol fill pattern 1
	s${cc_res} symbol linewidth 1.0
	s${cc_res} symbol linestyle 1
	s${cc_res} symbol char 65
	s${cc_res} symbol char font 0
	s${cc_res} symbol skip 0
	s${cc_res} line type 1
	s${cc_res} line linestyle 1
	s${cc_res} line linewidth 1
	s${cc_res} line color ${cc_col}
	s${cc_res} legend  \"${residue}\"" >> head_grace
	
	echo -n "density/0.average_curve_${r}.dat " >> hola

	if [ $cc_res -ge $max_res ] || [ $r -eq $index_res_end ]; then

		# Negative control
		final_res=36
		cc_res_f=$[ $cc_res + 1 ]
		residue_f=$(grep -w "${final_res}" list_residues.dat | cut -f2)

	echo "	s${cc_res_f} symbol 1
	s${cc_res_f} symbol size 0.5
	s${cc_res_f} symbol color 6
	s${cc_res_f} symbol pattern 1
	s${cc_res_f} symbol fill color 6
	s${cc_res_f} symbol fill pattern 1
	s${cc_res_f} symbol linewidth 1.0
	s${cc_res_f} symbol linestyle 1
	s${cc_res_f} symbol char 65
	s${cc_res_f} symbol char font 0
	s${cc_res_f} symbol skip 0
	s${cc_res_f} line type 1
	s${cc_res_f} line linestyle 1
	s${cc_res_f} line linewidth 1
	s${cc_res_f} line color 6
	s${cc_res_f} legend  \"${residue_f}\"" >> head_grace

	cc_res_f1=$[ $cc_res_f + 1 ]
	echo "	s${cc_res_f1} line type 1
	s${cc_res_f1} line linestyle 3
	s${cc_res_f1} line linewidth 2
	s${cc_res_f1} line color ${fill_color}
	s${cc_res_f1} legend  \"\"" >> head_grace
	cc_res_f1=$[ $cc_res_f1 + 1 ]
	echo "	s${cc_res_f1} line type 1
	s${cc_res_f1} line linestyle 3
	s${cc_res_f1} line linewidth 2
	s${cc_res_f1} line color ${fill_color}
	s${cc_res_f1} legend  \"\"" >> head_grace

		cat head_grace >> main_head 
		cp main_head new_density$cc_fig.par 

		cat hola >> script1_fig.sh
		cat hola >> script2_fig.sh
		echo -n "density/0.average_curve_${final_res}.dat dashed_line_lipid.dat -p new_density$cc_fig.par -saveall figure_$cc_fig.xvg" >> script1_fig.sh
		echo -n "density/0.average_curve_${final_res}.dat dashed_line_lipid.dat -p new_density$cc_fig.par -hdevice PNG -saveall figure_$cc_fig.png" >> script2_fig.sh
		echo "" >> script1_fig.sh
		echo "" >> script2_fig.sh

		cc_res=0
		cc_col=0
		cc_fig=$[ $cc_fig + 1 ]
	fi

	cc_res=$[ $cc_res + 1 ]	
	cc_col=$[ $cc_col + 1 ]		

done

chmod +x script1_fig.sh
chmod +x script2_fig.sh
./script1_fig.sh
./script2_fig.sh

mv script*_fig* $fig_directory/
mv new_density*par $fig_directory/
mv figure_*.xvg $fig_directory/
mv figure_*.png $fig_directory/
mv figure_*.ps $fig_directory/

rm hola head_grace main_head


