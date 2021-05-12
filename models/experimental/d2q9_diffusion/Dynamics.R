
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
AddQuantity(name="PhaseField", unit="1.")
AddQuantity(name="GradPhaseField",unit="1.",vector=T)

# Inputs: Flow Properties
AddSetting(name="diffusivity_phi",	default=0.02, comment='Mobility')
AddSetting(name="Init_PhaseField",	zonal=TRUE)

AddSetting(name="PhaseField_h", default=1, comment='PhaseField max') # TODO: remove
AddSetting(name="PhaseField_l", default=0, comment='PhaseField min') # TODO: remove
AddSetting(name="W", default=4,    comment='Anti-diffusivity coeff (phase interfacial thickness) ') # TODO: remove

# Fields are variables (for instance flow-variables, displacements, etc) that are stored in all mesh nodes. 
# Model Dynamics can access these fields with an offset (e.g. field_name(-1,0)).
AddField('PhaseF', stencil2d=1, group="PF") #	Phase-field stencil for finite differences

if (Options$fields){
	AddDensity(name="Init_PhaseField_R", group="init", comment="initial phi", parameter=TRUE)
	AddStage(name="InitFromFieldsStage", main="InitFromFields", load.densities=TRUE, save.fields=TRUE)
	AddAction(name="InitFromFields", "InitFromFieldsStage")
} 

# DEBUG	Outputs:
AddQuantity(name="PhaseF", unit="1.")  # TODO: remove

#	Boundary things:
AddNodeType(name="SRT_diffusion",	       		group="COLLISION")
AddNodeType(name="MRT_no_diffusion_grad_FD",		group="COLLISION")
AddNodeType(name="MRT_no_diffusion_lp_FD",		group="COLLISION")
AddNodeType(name="MRT_no_diffusion_grad_moments",	group="COLLISION")
