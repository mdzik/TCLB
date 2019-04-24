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
AddSetting(name="VelocityX", default=0.0, comment='inlet/outlet/init x-velocity component', zonal=TRUE)
AddSetting(name="VelocityY", default=0.0, comment='inlet/outlet/init velocity', zonal=T)
AddSetting(name="VelocityZ", default=0.0, comment='inlet/outlet/init velocity', zonal=T)
AddSetting(name="Pressure" , default=0.0, comment='inlet/outlet/init density', zonal=T)
AddSetting(name="GravitationX", default=0.0, comment='applied rho*GravitationX')
AddSetting(name="GravitationY", default=0.0, comment='applied rho*GravitationY')
AddSetting(name="GravitationZ", default=0.0, comment='applied rho*GravitationZ')
AddSetting(name="omega_nu", comment='inverse of viscous relaxation time', default=1.0)
AddSetting(name="nu", omega_nu='1.0/(3*nu+0.5)',  default=0.16666666,  comment='kinematic viscosity')

# Inputs: CFD Enhancements ;-)
AddSetting(name="GalileanCorrection",default=1.,comment='Galilean correction term')
AddSetting(name="nubuffer",default=0.01, comment='kinematic viscosity in the buffer layer')
AddSetting(name="Omegafor3rdCumulants", default=1, comment='relaxation rate for 3rd order cumulants')
AddSetting(name="h_stability_enhancement", default=1.0, comment='magic stability enhancement')

# 	Inputs: General Thermal Properties
AddSetting(name="InitTemperature", default=0, comment='Initial/Inflow temperature distribution', zonal=T)

# 	Inputs: Fluid Thermal Properties
AddSetting(name="conductivity", default=0.16666666, comment='thermal conductivity of fluid (W/(m·K))', zonal=T)
AddSetting(name="material_density", default=1.0, comment='density of material [kg]', zonal=T)
AddSetting(name="cp", default=1.0, comment='specific heat capacity at constant pressure of fluid (J/(kg·K))', zonal=T)
AddSetting(name="BoussinesqCoeff", default=0.0, comment='BoussinesqCoeff=rho_0*thermal_exp_coeff')

#	Globals - table of global integrals that can be monitored and optimized
# AddGlobal(name="PressureLoss", comment='pressure loss', unit="1mPa")
# AddGlobal(name="OutletFlux", comment='pressure loss', unit="1m2/s")
# AddGlobal(name="InletFlux", comment='pressure loss', unit="1m2/s")
# AddGlobal(name="TotalTemperature", comment='Energy conservation check', unit="J")

# AddGlobal(name="FDrag", comment='Force exerted on body in X-direction', unit="N")
# AddGlobal(name="FLift", comment='Force exerted on body in Y-direction', unit="N")
# AddGlobal(name="FTotal", comment='Force exerted on body in X+Y -direction', unit="N")

#	Boundary things
# AddNodeType(name="MovingWall_N", group="BOUNDARY")
# AddNodeType(name="MovingWall_S", group="BOUNDARY")
# AddNodeType(name="NVelocity", group="BOUNDARY")
# AddNodeType(name="WVelocity", group="BOUNDARY")

# 	Outputs:
AddQuantity( name="Rho", unit="kg/m3")
AddQuantity( name="T", unit="K")
AddQuantity( name="U", unit="m/s",vector=T )
# 	Debug-Outputs:
if(Options$DEBUG){
	AddQuantity( name="m00_F" )
	AddQuantity( name="H" )
	AddQuantity( name="material_density" )
	AddQuantity( name="cp" )
	AddQuantity( name="conductivity" )
	AddQuantity( name="RawU", vector=T )
}


# Boundary things
AddNodeType(name="DarcySolid", group="ADDITIONALS")
AddNodeType(name="Smoothing", group="ADDITIONALS")
AddNodeType(name="HeaterDirichletTemperature", group="ADDITIONALS_HEAT")
AddNodeType(name="HeaterNeumannHeatFlux", group="ADDITIONALS_HEAT")
AddNodeType("CM","COLLISION")

##########OPTIONAL VALUES##########

#Smagorinsky coefficient
if(Options$SMAG)
{
	AddSetting(name="Smag", default=0, comment='Smagorinsky coefficient for SGS modeling')
}

if (Options$OutFlow)
{
	AddNodeType(name="ENeumann", group="BOUNDARY")
	AddNodeType(name="EConvect", group="BOUNDARY")
}