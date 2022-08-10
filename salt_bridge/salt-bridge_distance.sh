module load gromacs/2020.2/single

protein=../Init_MD.tpr
trajectory=pm_Total_R1_0to20_nojump_fittrans_mol.xtc

# ASP1A - LYS189B
gmx distance -f ../$trajectory -s ../$protein -n index_salt-bridges.ndx -oav distance_salt-bridge1_AB.xvg -select 'cog of group 10 plus cog of group 23' -tu us

# ASP1B - LYS189A
gmx distance -f ../$trajectory -s ../$protein -n index_salt-bridges.ndx -oav distance_salt-bridge1_BA.xvg -select 'cog of group 11 plus cog of group 22' -tu us

# ASP7A - LYS10B
gmx distance -f ../$trajectory -s ../$protein -n index_salt-bridges.ndx -oav distance_salt-bridge2_AB.xvg -select 'cog of group 12 plus cog of group 15' -tu us

# ASP7B - LYS10A
gmx distance -f ../$trajectory -s ../$protein -n index_salt-bridges.ndx -oav distance_salt-bridge2_BA.xvg -select 'cog of group 13 plus cog of group 14' -tu us

# GLU12A - ARG29B
gmx distance -f ../$trajectory -s ../$protein -n index_salt-bridges.ndx -oav distance_salt-bridge3_AB.xvg -select 'cog of group 16 plus cog of group 19' -tu us

# GLU12B - ARG29A
gmx distance -f ../$trajectory -s ../$protein -n index_salt-bridges.ndx -oav distance_salt-bridge3_BA.xvg -select 'cog of group 17 plus cog of group 18' -tu us

# ASP157A - ARG191B
gmx distance -f ../$trajectory -s ../$protein -n index_salt-bridges.ndx -oav distance_salt-bridge4_AB.xvg -select 'cog of group 20 plus cog of group 25' -tu us

# ASP157B - ARG191A
gmx distance -f ../$trajectory -s ../$protein -n index_salt-bridges.ndx -oav distance_salt-bridge4_BA.xvg -select 'cog of group 21 plus cog of group 24' -tu us

