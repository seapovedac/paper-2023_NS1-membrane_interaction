# PROTEIN
target=protein
module load gromacs/2020.2/single
echo 1 | gmx densmap -f ../pm_Total_R3_0to20_nojump_fittrans_mol.xtc -s ../../Init_MD.tpr -aver z -bin 0.1 -dmin 0 -dmax 20 -unit nm-2 -o $target.xpm 
module load gromacs/5.1.1/single
gmx xpm2ps -rainbow blue -f $target.xpm -o $target.eps

# POPC
target=popc
module load gromacs/2020.2/single
echo 13 | gmx densmap -f ../pm_Total_R3_0to20_nojump_fittrans_mol.xtc -s ../../Init_MD.tpr -aver z -bin 0.1 -dmin 0 -dmax 25 -unit nm-2 -o ${target}.xpm 
module load gromacs/5.1.1/single
gmx xpm2ps -rainbow blue -f $target.xpm -o $target.eps

# POPS
target=pops
module load gromacs/2020.2/single
echo 14 | gmx densmap -f ../pm_Total_R3_0to20_nojump_fittrans_mol.xtc -s ../../Init_MD.tpr -aver z -bin 0.1 -dmin 0 -dmax 2 -unit nm-2 -o $target.xpm
module load gromacs/5.1.1/single
gmx xpm2ps -rainbow blue -f $target.xpm -o $target.eps

# POPE
target=pope
module load gromacs/2020.2/single
echo 15 | gmx densmap -f ../pm_Total_R3_0to20_nojump_fittrans_mol.xtc -s ../../Init_MD.tpr -aver z -bin 0.1 -dmin 0 -dmax 15 -unit nm-2 -o $target.xpm
module load gromacs/5.1.1/single
gmx xpm2ps -rainbow blue -f $target.xpm -o $target.eps

# POPI
target=popi
module load gromacs/2020.2/single
echo 16 | gmx densmap -f ../pm_Total_R3_0to20_nojump_fittrans_mol.xtc -s ../../Init_MD.tpr -aver z -bin 0.1 -dmin 0 -dmax 2 -unit nm-2 -o $target.xpm
module load gromacs/5.1.1/single
gmx xpm2ps -rainbow blue -f $target.xpm -o $target.eps

# POSM
target=posm
module load gromacs/2020.2/single
echo 17 | gmx densmap -f ../pm_Total_R3_0to20_nojump_fittrans_mol.xtc -s ../../Init_MD.tpr -aver z -bin 0.1 -dmin 0 -dmax 1 -unit nm-2 -o $target.xpm
module load gromacs/5.1.1/single
gmx xpm2ps -rainbow blue -f $target.xpm -o $target.eps
