source("lib/lattice.R")

#  Density - table of variables of LB Node to stream
#  name - variable name to stream
#  dx,dy,dz - direction of streaming
#  comment - additional comment

# by hand: AddDensity( name="f[0]", dx= 0, dy= 0, group="f")
AddDensity(
	name = paste("f[",1:9-1,"]",sep=""),
	dx   = d2q9[,1],
	dy   = d2q9[,2],
	comment=paste("flow LB density F",1:9-1),
	group="f"
)

AddDensity(
	# name = paste("h",1:9-1,sep=""),  # without brackets
	name = paste("h[",1:9-1,"]",sep=""),
	dx   = d2q9[,1],
	dy   = d2q9[,2],
	comment=paste("heat LB density H",1:9-1),
	group="h"
)

# 	Outputs:
AddQuantity( name="Rho" )
AddQuantity( name="T" )
AddQuantity( name="RawU", vector=T )
AddQuantity( name="U", vector=T )

#	Inputs: Flow Properties
AddSetting(name="VelocityX", default=0.0, comment='inlet/outlet/init x-velocity component', zonal=TRUE)
AddSetting(name="GravitationY", default=0.0, comment='applied rho*GravitationY')
AddSetting(name="GravitationX", default=0.0, comment='applied rho*GravitationX')
AddSetting(name="omega_nu", comment='inverse of viscous relaxation time', default=1.0)
AddSetting(name="nu", omega_nu='1.0/(3*nu+0.5)',  default=0.16666666,  comment='kinematic viscosity')
AddSetting(name="omega_bulk", comment='inverse of bulk relaxation time', default=1.0)
AddSetting(name="bulk_visc", omega_bulk='1.0/(3*bulk_visc+0.5)',  comment='bulk viscosity')


# 	Inputs: General Thermal Properties
AddSetting(name="InitTemperature", default=0, comment='Initial/Inflow temperature distribution', zonal=T)

# 	Inputs: Fluid Thermal Properties
AddSetting(name="omega_k", default=1.0 , comment='inverse of thermal relaxation time')
AddSetting(name="k", omega_k='1.0/(3*k+0.5)', default=0.16666666, comment='thermal conductivity of fluid (W/(m·K))')
AddSetting(name="cp", , default=1.0, comment='specific heat capacity at constant pressure of fluid (J/(kg·K))')
AddSetting(name="BoussinesqCoeff", default=0.0, comment='BoussinesqCoeff=rho_0*thermal_exp_coeff')

# 	Inputs: Solid Thermal Properties
AddSetting(name="omega_k_s", default=1.0 , comment='inverse of thermal relaxation time')
AddSetting(name="k_s", omega_k='1.0/(3*k_s+0.5)', default=0.16666666, comment='thermal conductivity of solid (W/(m·K))')
AddSetting(name="cp_s",default=1.0, comment='specific heat capacity at constant pressure of solid (J/(kg·K))')
AddSetting(name="rho_s",default=1.0, comment='solid density (kg/m3')


#	Boundary things
AddNodeType(name="Solid", group="ADDITIONALS")
AddNodeType(name="Smoothing", group="ADDITIONALS")
AddNodeType(name="HeaterDirichletTemperature", group="ADDITIONALS")
AddNodeType(name="HeaterNeumannHeatFlux", group="ADDITIONALS")
