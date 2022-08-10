#!/usr/bin/Rscript

library(bio3d)
library(igraph)

pdb1BB=read.pdb("UG_CA_domains.pdb")
dcd1BB=read.dcd("holo_protein_simul_combine_skip100_UG.dcd")
indsBB=atom.select(pdb1BB)
xyz1BBfit=fit.xyz(pdb1BB$xyz,mobile=dcd1BB, fixed.inds=indsBB$xyz,mobile.inds=indsBB$xyz)
cij1_BB=dccm(xyz1BBfit)

dcd1BB_apo=read.dcd("apo_protein_simul_combine_skip100_UG.dcd")
xyz1BBfit_apo=fit.xyz(pdb1BB$xyz,mobile=dcd1BB_apo, fixed.inds=indsBB$xyz,mobile.inds=indsBB$xyz)
cij1_BB_apo=dccm(xyz1BBfit_apo)

pdb2BB=read.pdb("BR_CA_domains.pdb")
dcd2BB=read.dcd("holo_protein_simul_combine_skip100_BR.dcd")
inds2BB=atom.select(pdb2BB)
xyz2BBfit=fit.xyz(pdb2BB$xyz,mobile=dcd2BB, fixed.inds=inds2BB$xyz,mobile.inds=inds2BB$xyz)
cij2_BB=dccm(xyz2BBfit)

dcd2BB_apo=read.dcd("apo_protein_simul_combine_skip100_BR.dcd")
xyz2BBfit_apo=fit.xyz(pdb2BB$xyz,mobile=dcd2BB_apo, fixed.inds=inds2BB$xyz,mobile.inds=inds2BB$xyz)
cij2_BB_apo=dccm(xyz2BBfit_apo)

diff=cij1_BB-cij2_BB

ch <- c( rep(c(32),each=29), rep(c(31),each=9), rep(c(25),each=112), rep(c(31),each=30), rep(c(21),each=172) , rep(c(32),each=29), rep(c(31),each=9), rep(c(25),each=112), rep(c(31),each=30), rep(c(21),each=172))

pdf("DCCM_interface_PM_apo_and_holo.pdf")

plot.dccm(cij1_BB_apo, main="Ugandan apo",colorkey=TRUE, segment.min=-10,col.regions=bwr.colors(200), margin.segments=ch, resno=pdb1BB) # DCCM
plot.dccm(cij1_BB, main="Ugandan holo",colorkey=TRUE, segment.min=-10,col.regions=bwr.colors(200), margin.segments=ch, resno=pdb1BB) # DCCM
plot.dccm(cij2_BB_apo, main="Brazilian apo",colorkey=TRUE, segment.min=-10,col.regions=bwr.colors(200), margin.segments=ch, resno=pdb1BB) # DCCM
plot.dccm(cij2_BB, main="Brazilian holo",colorkey=TRUE, segment.min=-10,col.regions=bwr.colors(200), margin.segments=ch, resno=pdb1BB) # DCCM

pdb1BB2=read.pdb("UG_CA_residues_membrane.pdb")

# ABS

cij1_BB_abs=abs(cij1_BB)
cij2_BB_abs=abs(cij2_BB)
cij1_BB_abs_apo=abs(cij1_BB_apo)
cij2_BB_abs_apo=abs(cij2_BB_apo)

# Difference

diff_apo=cij2_BB_abs_apo-cij1_BB_abs_apo
diff_holo=cij2_BB_abs-cij1_BB_abs
diff_ug=cij1_BB_abs_apo-cij1_BB_abs
diff_br=cij2_BB_abs_apo-cij2_BB_abs

plot.dccm(diff_apo, main="apo(Brazilian - Ugandan)",colorkey=TRUE, segment.min=-10,col.regions=bwr.colors(200), resno=pdb1BB, sse=pdb1BB2, margin.segments=ch, helix.col="black", sheet.col="blue") # DCCM
plot.dccm(diff_holo, main="holo(Brazilian - Ugandan)",colorkey=TRUE, segment.min=-10,col.regions=bwr.colors(200), resno=pdb1BB, sse=pdb1BB2, margin.segments=ch, helix.col="black", sheet.col="blue") # DCCM
plot.dccm(diff_ug, main="Ugandan (apo - holo)",colorkey=TRUE, segment.min=-10,col.regions=bwr.colors(200), resno=pdb1BB, margin.segments=ch, helix.col="black", sheet.col="blue") # DCCM Uganda
plot.dccm(diff_br, main="Brazilian (apo - holo)",colorkey=TRUE, segment.min=-10,col.regions=bwr.colors(200), resno=pdb1BB, margin.segments=ch, helix.col="black", sheet.col="blue") # DCCM Brazil

dev.off()

# Counting

sink("output.txt")

for (d in 1:4){
  	
	
	if (d == 1) {
		difference=diff_apo
		name_diff="apo"
	}

	if (d == 2) {
		difference=diff_holo
		name_diff="holo"
	}

	if (d == 3) {
		difference=diff_ug
		name_diff="UG"
	}


	if (d == 4) {
		difference=diff_br
		name_diff="BR"
	}

	pos=0
	neg=0
	for(row in 1:nrow(difference)) {
		for(col in 1:ncol(difference)) {

		    num_ver=(difference[row, col])
			if (num_ver > 0 ) {
			  pos=pos+1
			} 

			else if (num_ver < 0) {
			  neg=neg+1
			}
		}
	}

	total=pos+neg
	pos=(pos/total)*100
	neg=(neg/total)*100

	cat(paste("Difference", name_diff))
	cat("\n")
	cat(paste("Positive", round(pos, digits = 1), "%"))
	cat("\n")
	cat(paste("Negative", round(neg, digits = 1), "%"))
	cat("\n\n")

}

sink()

