source("lib/lattice.R")

x = c(0,1,-1);
P = expand.grid(x=0:2,y=0:2,z=0:2)
U = expand.grid(x,x,x)

fname = paste("f",P$x,P$y,P$z,sep="")
AddDensity(
	name = fname,
	dx   = U[,1],
	dy   = U[,2],
	dz   = U[,3],
	comment=paste("flow LB density F",1:27-1),
	group="f"
)

for (f in fname) AddField(f,dx=0,dy=0,dz=0) # Make f accessible also in present node (not only streamed)

# Manually: AddDensity( name="h[0]", dx= 0, dy= 0, group="h")
# name = paste("h",1:19-1,sep=""),  # without brackets
hname = paste("h[",1:27-1,"]",sep="")
AddDensity(
	name = hname,
	dx   = d3q27[,1],
	dy   = d3q27[,2],
	dz   = d3q27[,3],
	comment=paste("heat LB density H",1:27-1),
	group="h"
)

if (Options$OutFlow || Options$OutFlowNew)
{
	for (h in hname) AddField(h,dx=0,dy=0,dz=0) # Make h accessible also in present node (not only streamed)
}
# # initialisation
# AddStage("BaseInit"  , "Init_distributions" , save=Fields$group %in% c("f","h","Vel"))

# # iteration
# AddStage("HydroIter" , "calcHydroIter"      , save=Fields$group %in% c("g","h","Vel","nw") , load=DensityAll$group %in% c("g","h","Vel","nw"))
# AddStage("HeatIter"  , "calcHeatIter"		, save=Fields$group %in% c("PF")			   , load=DensityAll$group %in% c("g","h","Vel","nw"))


# AddAction("Init"     , c("BaseInit"))
# AddAction("Iteration", c("HydroIter", "HeatIter"))

#	Inputs: Flow Properties
AddSetting(name="VelocityX", default="0m/s", comment='inlet/outlet/init x-velocity component', zonal=TRUE)
AddSetting(name="VelocityY", default="0m/s", comment='inlet/outlet/init y-velocity component', zonal=TRUE)
AddSetting(name="VelocityZ", default="0m/s", comment='inlet/outlet/init z-velocity component', zonal=TRUE)
AddSetting(name="Pressure" , default="0Pa", comment='inlet/outlet/init pressure', zonal=TRUE)
AddSetting(name="GravitationX", default=0.0, comment='applied rho*GravitationX')
AddSetting(name="GravitationY", default=0.0, comment='applied rho*GravitationY')
AddSetting(name="GravitationZ", default=0.0, comment='applied rho*GravitationZ')
AddSetting(name="omega_nu", comment='inverse of viscous relaxation time', default=1.0)
AddSetting(name="nu", omega_nu='1.0/(3*nu+0.5)',  default=0.16666666,  comment='kinematic viscosity')

# Inputs: CFD Enhancements ;-)
AddSetting(name="GalileanCorrection",default=1.,comment='Galilean correction term')
AddSetting(name="nu_buffer",default=0.01, comment='kinematic viscosity in the buffer layer')
AddSetting(name="conductivity_buffer",default=0.01, comment='thermal conductivity in the buffer layer')
AddSetting(name="Omegafor3rdCumulants", default=1, comment='relaxation rate for 3rd order cumulants')
AddSetting(name="h_stability_enhancement", default=1.0, comment='magic stability enhancement')

# 	Inputs: General Thermal Properties
AddSetting(name="InitTemperature", default=0, comment='Initial/Inflow temperature distribution', zonal=T)
AddSetting(name="InitHeatFlux", default=0, comment='Initial/Inflow heat flux through boundary', zonal=T)


# 	Inputs: Fluid Thermal Properties
AddSetting(name="conductivity", default=0.16666666, comment='thermal conductivity of fluid (W/(m·K))', zonal=T)
AddSetting(name="material_density", default=1.0, comment='density of material [kg/m3]', zonal=T)
AddSetting(name="cp", default=1.0, comment='specific heat capacity at constant pressure of fluid (J/(kg·K))', zonal=T)
AddSetting(name="BoussinesqCoeff", default=1.0, comment='BoussinesqCoeff=rho_0*thermal_exp_coeff')

#	Globals - table of global integrals that can be monitored and optimized
AddGlobal(name="FDrag",    comment='Force exerted on body in X-direction', unit="N")
AddGlobal(name="FLateral", comment='Force exerted on body in Y-direction', unit="N")
AddGlobal(name="FLift",    comment='Force exerted on body in Z-direction', unit="N")

AddGlobal(name="XHydroFLux",    comment='XHydroFLux', unit="kg/s")
AddGlobal(name="YHydroFLux",    comment='YHydroFLux', unit="kg/s")
AddGlobal(name="ZHydroFLux",    comment='ZHydroFLux', unit="kg/s")

AddGlobal(name="HeatFluxX",    comment='Heat flux from body in X-direction', unit="W")
AddGlobal(name="HeatFluxY",    comment='Heat flux from body in Y-direction', unit="W")
AddGlobal(name="HeatFluxZ",    comment='Heat flux from body in Z-direction', unit="W")
AddGlobal(name="HeatSource",    comment='Total Heat flux from body', unit="W")
# AddGlobal(name="PressureLoss", comment='pressure loss', unit="1mPa")
# AddGlobal(name="OutletFlux", comment='pressure loss', unit="1m2/s")
# AddGlobal(name="InletFlux", comment='pressure loss', unit="1m2/s")
# AddGlobal(name="TotalTemperature", comment='Energy conservation check', unit="J")

# 	Outputs:
AddQuantity( name="Rho", unit="kg/m3")
AddQuantity( name="T", unit="K")
AddQuantity( name="U", unit="m/s",vector=T )
# 	Debug-Outputs:
if(Options$DEBUG){
	AddQuantity( name="m00_F" )
	AddQuantity( name="H", unit="J" )
	AddQuantity( name="material_density", unit="kg/m3" )
	AddQuantity( name="cp", unit="J/kg/K")
	AddQuantity( name="conductivity", unit="W/m/K" )
	AddQuantity( name="RawU", unit="m/s", vector=T )
}

# Boundary things
AddNodeType("FluxMeasurment", "OBJECTIVEHYDRO")
AddNodeType("MeasurmentArea", "OBJECTIVE")
AddNodeType(name="DarcySolid", group="ADDITIONALS")
AddNodeType(name="Smoothing", group="ADDITIONALS")
AddNodeType(name="HeaterDirichletTemperatureEQ", group="ADDITIONALS_HEAT")
AddNodeType(name="HeaterDirichletTemperatureABB", group="ADDITIONALS_HEAT")
AddNodeType(name="HeaterSource", group="ADDITIONALS_HEAT")
AddNodeType(name="HeaterNeumannHeatFluxCylinder", group="ADDITIONALS_HEAT")
AddNodeType(name="HeaterNeumannHeatFluxEast", group="ADDITIONALS_HEAT")
AddNodeType("CM","COLLISION")

# Benchmark things
AddNodeType("CM_SRT","COLLISION")
AddNodeType("CM_HIGHER","COLLISION")
AddNodeType("HCM","COLLISION")
AddSetting(name="CylinderCenterX", default="0", comment='X coord of cylinder with imposed heat flux')
AddSetting(name="CylinderCenterY", default="0", comment='Y coord of cylinder with imposed heat flux')

AddSetting(name="CylinderCenterX_GH", default="0", comment='X coord of Gaussian Hill')
AddSetting(name="CylinderCenterY_GH", default="0", comment='Y coord of Gaussian Hill')
AddSetting(name="Sigma_GH", default="1", comment='Initial width of the Gaussian Hill', zonal=T)

##########OPTIONAL VALUES##########

#Interpolated BounceBack Node
if(Options$IBB){
	AddNodeType("IBB", group="BOUNDARY") 
	AddQuantity( name="MaxQ" )  
	AddQuantity( name="MinQ" )  
}

#Smagorinsky coefficient
if(Options$SMAG)
{
	AddSetting(name="Smag", default=0, comment='Smagorinsky coefficient for SGS modeling')
}

AddDensity(name="U", dx=0, dy=0, dz=0, group="Vel")  
# AddDensity(name="V", dx=0, dy=0, dz=0, group="Vel")
# AddDensity(name="W", dx=0, dy=0, dz=0, group="Vel")
if (Options$OutFlow)
{
	AddDensity(name=paste("fold",0:26,sep=""), dx=0,dy=0,dz=0,group="fold")
	AddDensity(name=paste("hold",0:26,sep=""), dx=0,dy=0,dz=0,group="hold")

	for (d in rows(DensityAll)) {
		AddField( name=d$name, dx=-d$dx-1, dy=-d$dy, dz=-d$dz )
	}

	AddField(name="U",dx=c(-1,0,0)) # TODO: do I need this?

	AddNodeType(name="ENeumann", group="BOUNDARY")
	AddNodeType(name="EConvect", group="BOUNDARY")
}

if (Options$OutFlowNew)
{
	for (d in rows(DensityAll)) {
		AddField( name=d$name, dx=-d$dx-1, dy=-d$dy, dz=-d$dz )
	}

	AddField(name="U",dx=c(-1,0,0)) 

	AddNodeType(name="ENeumann", group="BOUNDARY")
	AddNodeType(name="EConvect", group="BOUNDARY")
}
