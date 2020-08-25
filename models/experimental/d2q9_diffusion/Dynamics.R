
# declaration of lattice (velocity) directions
x = c(0,1,-1);
P = expand.grid(x=0:2,y=0:2, z=0)
U = expand.grid(x,x,0)

# declaration of densities
fname = paste("f",P$x,P$y,P$z,sep="")
AddDensity(
	name = fname,
	dx   = U[,1],
	dy   = U[,2],
	comment=paste("LB density fields",fname),
	group="f"
)

# 	Outputs:
AddQuantity(name="PhaseField", unit="")

#	Boundary things:
AddNodeType(name="SRT",	        group="COLLISION")

# Inputs: Flow Properties
AddSetting(name="diffusivity_phi",      default=0.02, comment='Mobility')
AddSetting(name="Init_PhaseField",   zonal=TRUE)
