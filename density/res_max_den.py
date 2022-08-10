import pandas as pd
from shapely.geometry import Point, Polygon

shift = 0
column_names=["Residue", "PO4"]
dfResidues=pd.DataFrame(columns = column_names)
column_names=["Group", "A", "R", "N", "D", "C", "Q", "E", "G", "H", "I", "L", "K", "M", "F", "P", "S", "T", "W", "Y", "V", "charged", "+ charged", "- charged", "aromatic", "aliphatic", "hydroxylic"]
dfCountResidues=pd.DataFrame(columns = column_names)

def sum_residue(oneLetRes, Ac, Rc, Nc, Dc, Cc, Qc, Ec, Gc, Hc, Ic, Lc, Kc, Mc, Fc, Pc, Sc, Tc, Wc, Yc, Vc):

	if oneLetRes == 'A':
		Ac=Ac + 1 

	if oneLetRes == 'R':
		Rc=Rc + 1 

	if oneLetRes == 'N':
		Nc=Nc + 1 

	if oneLetRes == 'D':
		Dc=Dc + 1 

	if oneLetRes == 'C':
		Cc=Cc + 1 

	if oneLetRes == 'Q':
		Qc=Qc + 1 

	if oneLetRes == 'E':
		Ec=Ec + 1 

	if oneLetRes == 'G':
		Gc=Gc + 1 

	if oneLetRes == 'H':
		Hc=Hc + 1 

	if oneLetRes == 'I':
		Ic=Ic + 1 

	if oneLetRes == 'L':
		Lc=Lc + 1 

	if oneLetRes == 'K':
		Kc=Kc + 1 

	if oneLetRes == 'M':
		Mc=Mc + 1 

	if oneLetRes == 'F':
		Fc=Fc + 1 

	if oneLetRes == 'P':
		Pc=Pc + 1 

	if oneLetRes == 'S':
		Sc=Sc + 1 

	if oneLetRes == 'T':
		Tc=Tc + 1 

	if oneLetRes == 'W':
		Wc=Wc + 1 

	if oneLetRes == 'Y':
		Yc=Yc + 1 

	if oneLetRes == 'V':
		Vc=Vc + 1 
	
	return Ac, Rc, Nc, Dc, Cc, Qc, Ec, Gc, Hc, Ic, Lc, Kc, Mc, Fc, Pc, Sc, Tc, Wc, Yc, Vc

# Reading name of residues in list_residues.dat

with open("list_residues.dat", 'r') as f:

	dataResidues = [d for d in f.read().split('\n') if d != '']

list_nures=[]
list_nares=[]

for d in dataResidues:
	num_res, nam_res, = d.split()
	list_nures.append(num_res)
	list_nares.append(nam_res)

# Loop for lipid group

for g in range (7):

	if g == 0:
		group = "1.PO4"
		ind_lipid = 37

	if g == 1:
		group = "2.GL"
		ind_lipid = 38

	if g == 2:
		group = "3.NC3"
		ind_lipid = 39

	if g == 3:
		group = "4.NH3"
		ind_lipid = 40

	if g == 4:
		group = "5.Inositol"
		ind_lipid = 41

	if g == 5:
		group = "6.CNO"
		ind_lipid = 42

	if g == 6:
		group = "7.AM"
		ind_lipid = 43

	dir_group = group + "/density/"
	densityFileLip = dir_group + "0.average_curve_" + str(ind_lipid) + ".dat"

	# Defining polygon with coordinates of lipids densities

	with open(densityFileLip, 'r') as f:

		dataLipidsDen = [d for d in f.read().split('\n') if d != '']

	list_pol=[]
	for lip in dataLipidsDen:

		xL, yL, = lip.split()

		if float(yL) != 0 and float(xL) < 0:
			tupLip=(float(xL), float(yL))
			list_pol.append(tupLip)
		
	poly = Polygon(list_pol)

	# Reading files with residues

	Ac=0
	Rc=0
	Nc=0
	Dc=0
	Cc=0
	Qc=0
	Ec=0
	Gc=0
	Hc=0
	Ic=0
	Lc=0
	Kc=0
	Mc=0
	Fc=0
	Pc=0
	Sc=0
	Tc=0
	Wc=0
	Yc=0
	Vc=0

	for f in range(1,37):

		nameRes = dataResidues[f].split()[1]
		
		oneLetRes = nameRes[0]

		densityFileRes = dir_group + "0.average_curve_" + str(f) + ".dat"

		with open(densityFileRes, 'r') as f1:

			dataResiduesDen = [d for d in f1.read().split('\n') if d != '']

	# Detecting maximum value in Y for densities

		list_resX=[]
		list_resY=[]
		for res in dataResiduesDen:

			xR, yR, = res.split()

			list_resX.append(float(xR))
			list_resY.append(float(yR))

		pos_max= list_resY.index(max(list_resY)) 

		# Maximum in Y
		max_point = Point(list_resX[pos_max], list_resY[pos_max])

		# Checking if is inside of polygon
		ck_point = max_point.within(poly)
		
		if ck_point:

			ck_point = int(1)

		else:

			ck_point = int(0)

		if shift == 0:

			dfResidues = dfResidues.append({'Residue' : nameRes, group.split('.')[1] : ck_point } , ignore_index=True)

			if ck_point == 1:

				Ac, Rc, Nc, Dc, Cc, Qc, Ec, Gc, Hc, Ic, Lc, Kc, Mc, Fc, Pc, Sc, Tc, Wc, Yc, Vc = sum_residue(oneLetRes, Ac, Rc, Nc, Dc, Cc, Qc, Ec, Gc, Hc, Ic, Lc, Kc, Mc, Fc, Pc, Sc, Tc, Wc, Yc, Vc)
			if f == 36:
	
				shift = 1

				groupLipid =	group.split('.')[1]

				charged=Rc + Dc + Ec + Hc + Kc + Yc 
				charged_pos=Rc + Hc + Kc + Yc
				charged_neg=Dc + Ec
				aromatic=Fc + Wc
				aliphatic=Ac + Gc + Ic + Lc + Vc
				hydroxylic=Tc + Sc

				dfCountResidues = dfCountResidues.append({"Group": groupLipid, "A": Ac, "R": Rc, "N": Nc, "D": Dc, "C": Cc, "Q": Qc, "E": Ec, "G": Gc, "H": Hc, "I": Ic, "L": Lc, "K": Kc, "M": Mc, "F": Fc, "P": Pc, "S": Sc, "T": Tc, "W": Wc, "Y": Yc, "V": Vc, "charged": charged, "+ charged": charged_pos, "- charged": charged_neg, "aromatic": aromatic, "aliphatic":aliphatic, "hydroxylic": hydroxylic} , ignore_index=True)

		else:

			if f <= 36:
				
				rowIndex = dfResidues.index[f-1]
				dfResidues.loc[rowIndex, group.split('.')[1]] = ck_point

				if ck_point == 1:

					Ac, Rc, Nc, Dc, Cc, Qc, Ec, Gc, Hc, Ic, Lc, Kc, Mc, Fc, Pc, Sc, Tc, Wc, Yc, Vc = sum_residue(oneLetRes, Ac, Rc, Nc, Dc, Cc, Qc, Ec, Gc, Hc, Ic, Lc, Kc, Mc, Fc, Pc, Sc, Tc, Wc, Yc, Vc)

				if f == 36:

					groupLipid =	group.split('.')[1]

					charged=Rc + Dc + Ec + Hc + Kc + Yc 
					charged_pos=Rc + Hc + Kc + Yc
					charged_neg=Dc + Ec
					aromatic=Fc + Wc
					aliphatic=Ac + Gc + Ic + Lc + Vc
					hydroxylic=Tc + Sc

					dfCountResidues = dfCountResidues.append({"Group": groupLipid, "A": Ac, "R": Rc, "N": Nc, "D": Dc, "C": Cc, "Q": Qc, "E": Ec, "G": Gc, "H": Hc, "I": Ic, "L": Lc, "K": Kc, "M": Mc, "F": Fc, "P": Pc, "S": Sc, "T": Tc, "W": Wc, "Y": Yc, "V": Vc, "charged": charged, "+ charged": charged_pos, "- charged": charged_neg, "aromatic": aromatic, "aliphatic":aliphatic, "hydroxylic": hydroxylic} , ignore_index=True)

dfResidues.to_csv(r'match_density.csv', index = False)
dfCountResidues.to_csv(r'count_residues_density.csv', index = False)






