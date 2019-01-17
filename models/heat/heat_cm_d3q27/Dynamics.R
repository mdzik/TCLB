source("lib/lattice.R")

# AddDensity(
# 	name = paste("f",1:19-1,sep=""),
# 	dx   = d3q19[,1],
# 	dy   = d3q19[,2],
# 	dz   = d3q19[,3],
# 	comment=paste("flow LB density F",1:19-1),
# 	group="f"
# )

x = c(0,1,-1);
P = expand.grid(x=0:2,y=0:2,z=0:2)
U = expand.grid(x,x,x)

fname = paste("f",P$x,P$y,P$z,sep="")
AddDensity(
	name = fname,
	dx   = U[,1],
	dy   = U[,2],
	dz   = U[,3],
	comment=paste("density F",1:27-1),
	group="f"
)

for (f in fname) AddField(f,dx=0,dy=0,dz=0) # Make f accessible also in present node (not only streamed)

# recznie: AddDensity( name="h[0]", dx= 0, dy= 0, group="h")
AddDensity(
	# name = paste("h",1:19-1,sep=""),  # without brackets
	name = paste("h[",1:19-1,"]",sep=""),
	dx   = d3q19[,1],
	dy   = d3q19[,2],
	dz   = d3q19[,3],
	comment=paste("heat LB density H",1:19-1),
	group="h"
)

#	Velocity Fields
# AddDensity(name="velo_x", dx=0, dy=0, group="Vel")
# AddDensity(name="velo_y", dx=0, dy=0, group="Vel")
# AddDensity(name="velo_z", dx=0, dy=0, group="Vel")

#	Inputs: Flow Properties
AddSetting(name="VelocityX", default=0.0, comment='inlet/outlet/init x-velocity component', zonal=T)

AddSetting(name="GravitationY", default=0.0, comment='applied (rho)*GravitationY')
AddSetting(name="omega_nu", comment='inverse of viscous relaxation time', default=1.0)
AddSetting(name="nu", omega_nu='1.0/(3*nu+0.5)',  default=0.16666666,  comment='kinematic viscosity')

# Inputs: Flow Enhancements ;-)
AddSetting(name="GalileanCorrection",default=1.,comment='Galilean correction term')
AddSetting(name="nubuffer",default=0.01, comment='kinematic viscosity in the buffer layer')
AddSetting(name="Omegafor3rdCumulants", default=1, comment='relaxation rate for 3rd order cumulants')

# 	Inputs: Thermal Properties
AddSetting(name="omega_k", default=1.0 , comment='inverse of thermal relaxation time')
AddSetting(name="k", omega_k='1.0/(3*k+0.5)', default=0.16666666, comment='thermal conductivity (W/(m·K))')
AddSetting(name="cp", default=1.0, comment='specific heat capacity (J/(kg·K))')
AddSetting(name="InitTemperature", default=0, comment='Initial/Inflow temperature distribution', zonal=T)
AddSetting(name="BoussinesqCoeff", default=0.0, comment='Boussinesq force: coefficient of thermal expansion --> Fb_Y = -gravitation*coeff*dT')

#	Globals - table of global integrals that can be monitored and optimized
# AddGlobal(name="PressureLoss", comment='pressure loss', unit="1mPa")
# AddGlobal(name="OutletFlux", comment='pressure loss', unit="1m2/s")
# AddGlobal(name="InletFlux", comment='pressure loss', unit="1m2/s")
# AddGlobal(name="TotalTemperature", comment='Energy conservation check', unit="J")

#	Boundary things

# AddNodeType(name="MovingWall_N", group="BOUNDARY")
# AddNodeType(name="MovingWall_S", group="BOUNDARY")
# AddNodeType(name="NVelocity", group="BOUNDARY")
# AddNodeType(name="WVelocity", group="BOUNDARY")

AddNodeType(name="Smoothing", group="ADDITIONALS")
AddNodeType("Body", "BODY")


#	Globals - table of global integrals that can be monitored and optimized
# AddGlobal(name="FDrag", comment='Force exerted on body in X-direction', unit="N")
# AddGlobal(name="FLift", comment='Force exerted on body in Y-direction', unit="N")
# AddGlobal(name="FTotal", comment='Force exerted on body in X+Y -direction', unit="N")

# 	Outputs:
AddQuantity( name="Rho" )
AddQuantity( name="T" )
AddQuantity( name="U", vector=T )