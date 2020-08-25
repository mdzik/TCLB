
#	declaration of lattice (velocity) directions
x = c(0,1,-1);
P = expand.grid(x=0:2,y=0:2, z=0)
U = expand.grid(x,x,0)

#	declaration of densities
fname = paste("f",P$x,P$y,P$z,sep="")
AddDensity(
	name = fname,
	dx   = U[,1],
	dy   = U[,2],
	comment=paste("LB density fields",1:9-1),
	group="f"
)

# 	Outputs:
AddQuantity(name="PhaseField", unit="1.")

#	Globals - table of global integrals that can be monitored and optimized
AddGlobal(name="PhaseFieldIntegral", comment='Total amount of phasefield', unit="1.")

#	Boundary things:
AddNodeType(name="DirichletEQ",     group="BOUNDARY")
AddNodeType(name="ImageReader",     group="IMAGE") 
AddNodeType(name="MRT_FOI",	        group="COLLISION")
AddNodeType(name="MRT_SOI",	        group="COLLISION")

# 	Inputs: Flow Properties
AddSetting(name="diffusivity_phi",      default=0.02, comment='Mobility')
AddSetting(name="lambda", default=1.0, comment="to control intensity of the source term")

AddSetting(name="Init_PhaseField",   zonal=TRUE)

#	CFD enhancements ;)
AddField(name="phaseField",                 stencil2d=1)
AddNodeType(name="Smoothing",               group="ADDITIONALS")  #  To smooth population density during initialization.
AddSetting(name="phase_field_smoothing_coeff")     #  To smooth population density during initialization.
