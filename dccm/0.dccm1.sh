#!/usr/bin/Rscript

library(bio3d)
library(igraph)

pdb1BB=read.pdb("UG_CA_domains.pdb")
dcd1BB=read.dcd("protein_simul_combine_skip100_UG.dcd")
indsBB=atom.select(pdb1BB)
xyz1BBfit=fit.xyz(pdb1BB$xyz,mobile=dcd1BB, fixed.inds=indsBB$xyz,mobile.inds=indsBB$xyz)
cij1_BB=dccm(xyz1BBfit)

pdb2BB=read.pdb("BR_CA_domains.pdb")
dcd2BB=read.dcd("protein_simul_combine_skip100_BR.dcd")
inds2BB=atom.select(pdb2BB)
xyz2BBfit=fit.xyz(pdb2BB$xyz,mobile=dcd2BB, fixed.inds=inds2BB$xyz,mobile.inds=inds2BB$xyz)
cij2_BB=dccm(xyz2BBfit)

diff=cij1_BB-cij2_BB

ch <- c( rep(c(32),each=29), rep(c(31),each=9), rep(c(25),each=112), rep(c(31),each=30), rep(c(21),each=172) , rep(c(32),each=29), rep(c(31),each=9), rep(c(25),each=112), rep(c(31),each=30), rep(c(21),each=172))

pdf("DCCM_interface_PM_holo.pdf")

plot.dccm(cij1_BB, main="Ugandan",colorkey=TRUE, segment.min=-10,col.regions=bwr.colors(200), margin.segments=ch, resno=pdb1BB) # DCCM
plot.dccm(cij2_BB, main="Brazilian",colorkey=TRUE, segment.min=-10,col.regions=bwr.colors(200), margin.segments=ch, resno=pdb1BB) # DCCM
plot.dccm(diff, main="Ugandan - Brazilian",colorkey=TRUE, segment.min=-10,col.regions=bwr.colors(200), margin.segments=ch, resno=pdb1BB) # DCCM

# Difference
pdb1BB2=read.pdb("UG_CA_residues_membrane.pdb")
plot.dccm(diff, main="Ugandan - Brazilian",colorkey=TRUE, segment.min=-10,col.regions=bwr.colors(200), resno=pdb1BB, sse=pdb1BB2, margin.segments=ch, helix.col="black", sheet.col="blue") # DCCM SS

# ABS

cij1_BB_abs=abs(cij1_BB)
cij2_BB_abs=abs(cij2_BB)
diff=cij2_BB_abs-cij1_BB_abs
plot.dccm(diff, main="Ugandan - Brazilian",colorkey=TRUE, segment.min=-10,col.regions=bwr.colors(200), resno=pdb1BB, sse=pdb1BB2, margin.segments=ch, helix.col="black", sheet.col="blue") # DCCM


dev.off()
