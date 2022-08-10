num=1
replica=R${num}

date 

module load gromacs/2020.2/single 
source $GMXRC

for ((var=11 ; var <= 44; var += 1)) do

echo -e $var | gmx density -s ../../Init_MD.tpr -f ../pm_Total_${replica}_0to20_nojump_fittrans_mol.xtc -n ../../index_density_ug.ndx -o density_$var.xvg -d Z -b 0 -e 20000000

done
