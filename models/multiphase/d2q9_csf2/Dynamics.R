# Density - table of variables of LB Node to stream
#  name - variable name to stream
#  dx,dy,dz - direction of streaming
#  comment - additional comment

AddDensity( name="f[0]", dx= 0, dy= 0, group="f")
AddDensity( name="f[1]", dx= 1, dy= 0, group="f")
AddDensity( name="f[2]", dx= 0, dy= 1, group="f")
AddDensity( name="f[3]", dx=-1, dy= 0, group="f")
AddDensity( name="f[4]", dx= 0, dy=-1, group="f")
AddDensity( name="f[5]", dx= 1, dy= 1, group="f")
AddDensity( name="f[6]", dx=-1, dy= 1, group="f")
AddDensity( name="f[7]", dx=-1, dy=-1, group="f")
AddDensity( name="f[8]", dx= 1, dy=-1, group="f")



##########################################################
### Phase field related
AddDensity( name="h[0]", dx= 0, dy= 0, group="h")
AddDensity( name="h[1]", dx= 1, dy= 0, group="h")
AddDensity( name="h[2]", dx= 0, dy= 1, group="h")
AddDensity( name="h[3]", dx=-1, dy= 0, group="h")
AddDensity( name="h[4]", dx= 0, dy=-1, group="h")
AddDensity( name="h[5]", dx= 1, dy= 1, group="h")
AddDensity( name="h[6]", dx=-1, dy= 1, group="h")
AddDensity( name="h[7]", dx=-1, dy=-1, group="h")
AddDensity( name="h[8]", dx= 1, dy=-1, group="h")


if (Options$ExternalU != FALSE) {
    # If OverwriteVelocityField==1, this will be used to overwrite velocity
    AddDensity( name="ExternalU[0]", group="ExternalU", parameter=TRUE)
    AddDensity( name="ExternalU[1]", group="ExternalU", parameter=TRUE)
}

AddField("phi"      ,stencil2d=1 );

AddStage("BaseIteration", "Run", 
            load=DensityAll$group == "h" | DensityAll$group == "f" | DensityAll$group == "BC",
            save=Fields$group=="h" | Fields$group=="f"  
        ) 
AddStage("CalcPhi", 
            save=Fields$name=="phi" ,  
            load=DensityAll$group == "h"
        )
AddStage("BaseInit", "Init",  
    load=DensityAll$group == "BC",
    save=Fields$group=="h" | Fields$group == "f" 

)
AddAction("Iteration", c("BaseIteration","CalcPhi"))
AddAction("Init", c("BaseInit","CalcPhi"))


# Quantities - table of fields that can be exported from the LB lattice (like density, velocity etc)
#  name - name of the field
#  type - C type of the field, "real_t" - for single/double float, and "vector_t" for 3D vector single/double float
# Every field must correspond to a function in "Dynamics.c".
# If one have filed [something] with type [type], one have to define a function: 
# [type] get[something]() { return ...; }

AddQuantity(name="Rho",unit="kg/m3")
AddQuantity(name="U",unit="m/s",vector=T)

AddQuantity(name="DEBUG",vector=T)

AddQuantity(name="Normal",unit="1/m",vector=T)
AddQuantity(name="PhaseField",unit="1")

AddSetting(name="IntWidth", default=0.33333, comment='Interface width')
AddSetting(name="Mobility", default=0.001, comment='Mobility')
AddSetting(name="PhaseField", 
           default=0.5, 
           comment='Phase Field marker scalar', 
           zonal=T
           )



AddSetting(name="OverwriteVelocityField", default="0")
AddSetting(name="PF_Advection_Switch", default=1., comment='Parameter to turn on/off advection of phase field - usefull for initialisation')

#########################################################


if (Options$ViscositySmooth) {
    AddSetting(name="omega_plus", nu_plus="(1./omega_plus - 0.5) / 3." , comment='relaxation factor', default=1)
    AddSetting(name="omega_minus", nu_minus="(1./omega_minus - 0.5) / 3." , comment='relaxation factor', default=1)

    AddSetting(name="nu_plus", comment='viscosity', default=1/6)
    AddSetting(name="nu_minus", comment='viscosity', default=1/6)
} else {
    AddSetting(name="omega_plus", comment='relaxation factor', default=1)
    AddSetting(name="omega_minus", comment='relaxation factor', default=1)

    AddSetting(name="nu_plus", omega_plus='1.0/(3*nu_plus + 0.5)', comment='viscosity')
    AddSetting(name="nu_minus", omega_minus='1.0/(3*nu_minus + 0.5)', comment='viscosity')
}


AddSetting(name="VelocityX", default="0m/s", comment='inlet/BC normal velocity', zonal=TRUE)
AddSetting(name="VelocityY", default="0m/s", comment='inlet/BC normal velocity', zonal=TRUE)
AddSetting(name="Pressure", default="0Pa", comment='inlet/BC pressure', zonal=TRUE)


AddSetting(name="GravitationX_plus", default=0)
AddSetting(name="GravitationY_plus", default=0)


AddSetting(name="GravitationX_minus", default=0)
AddSetting(name="GravitationY_minus", default=0)

AddSetting(name="Magic", default=3/16, comment='Magic parameter')



#Node types for boundaries
AddNodeType(name="EPressure", group="BOUNDARY")
AddNodeType(name="WPressure", group="BOUNDARY")
AddNodeType(name="NPressure", group="BOUNDARY")
AddNodeType(name="SPressure", group="BOUNDARY")


AddNodeType(name="WVelocity", group="BOUNDARY")
AddNodeType(name="EVelocity", group="BOUNDARY")

AddNodeType(name="NSymmetry", group="BOUNDARY")
AddNodeType(name="SSymmetry", group="BOUNDARY")

AddNodeType(name="Inlet", group="OBJECTIVE")
AddNodeType(name="Outlet", group="OBJECTIVE")
AddNodeType(name="Solid", group="BOUNDARY")
AddNodeType(name="Wall", group="BOUNDARY")
AddNodeType(name="MRT", group="COLLISION")
