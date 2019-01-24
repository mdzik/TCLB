source("lib/lattice.R")

# Density - table of variables of LB Node to stream
#  name - variable name to stream
#  dx,dy,dz - direction of streaming
#  comment - additional comment

# AddDensity( name="f[0]", dx= 0, dy= 0, group="f")
# AddDensity( name="f[1]", dx= 1, dy= 0, group="f")
# AddDensity( name="f[2]", dx= 0, dy= 1, group="f")
# AddDensity( name="f[3]", dx=-1, dy= 0, group="f")
# AddDensity( name="f[4]", dx= 0, dy=-1, group="f")
# AddDensity( name="f[5]", dx= 1, dy= 1, group="f")
# AddDensity( name="f[6]", dx=-1, dy= 1, group="f")
# AddDensity( name="f[7]", dx=-1, dy=-1, group="f")
# AddDensity( name="f[8]", dx= 1, dy=-1, group="f")


# AddDensity( name="h[0]", dx= 0, dy= 0, group="h")
# AddDensity( name="h[1]", dx= 1, dy= 0, group="h")
# AddDensity( name="h[2]", dx= 0, dy= 1, group="h")
# AddDensity( name="h[3]", dx=-1, dy= 0, group="h")
# AddDensity( name="h[4]", dx= 0, dy=-1, group="h")
# AddDensity( name="h[5]", dx= 1, dy= 1, group="h")
# AddDensity( name="h[6]", dx=-1, dy= 1, group="h")
# AddDensity( name="h[7]", dx=-1, dy=-1, group="h")
# AddDensity( name="h[8]", dx= 1, dy=-1, group="h")


# recznie: AddDensity( name="f[0]", dx= 0, dy= 0, group="f")
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

AddQuantity( name="Rho" )
AddQuantity( name="T" )
AddQuantity( name="RawU", vector=T )

#	Inputs: Flow Properties
AddSetting(name="VelocityX", default=0.0, comment='inlet/outlet/init x-velocity component', zonal=TRUE)
AddSetting(name="GravitationY", default=0.0, comment='applied (rho)*GravitationY')
AddSetting(name="omega_nu", comment='inverse of viscous relaxation time', default=1.0)
AddSetting(name="nu", omega_nu='1.0/(3*nu+0.5)',  default=0.16666666,  comment='kinematic viscosity')
AddSetting(name="omega_bulk", comment='inverse of bulk relaxation time', default=1.0)
AddSetting(name="bulk_visc", omega_bulk='1.0/(3*bulk_visc+0.5)',  comment='bulk viscosity')

# 	Inputs: Thermal Properties
AddSetting(name="omega_k", default=1.0 , comment='inverse of thermal relaxation time')
AddSetting(name="k", omega_k='1.0/(3*k+0.5)', default=0.16666666, comment='thermal conductivity (W/(m·K))')
AddSetting(name="InitTemperature", default=0, comment='Initial/Inflow temperature distribution', zonal=T)
AddSetting(name="BoussinesqCoeff", default=0.0, comment='Boussinesq force: coefficient of thermal expansion --> Fb_Y = -gravitation*coeff*dT')


#	Boundary things
AddNodeType("Heater","ADDITIONALS")
