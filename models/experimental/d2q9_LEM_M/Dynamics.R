x = c(0,1,-1);
P = expand.grid(x=0:2,y=0:2,z=0)
U = expand.grid(x,x,0)

for (fname0 in c('s', 'i', 'r') ) { 
    fname = paste(fname0,P$x,P$y,P$z,sep="")

    AddDensity(
        name = fname,
        dx   = U[,1],
        dy   = U[,2],
        comment=paste("density: ",fname),
        group=fname0
    )
}

# 	Outputs:
AddQuantity(name="NoOfSuspected")
AddQuantity(name="NoOfInfected")
AddQuantity(name="NoOfRecovered")

AddQuantity(name="FractionSuspected")
AddQuantity(name="FractionInfected")
AddQuantity(name="FractionRecovered")

AddQuantity(name="PopulationDensity")

# 	Outputs - debug:
AddQuantity(name="OmegaTurb")
AddQuantity(name="FractionSum")
AddQuantity(name="TotalNoOfIndividuals")

#	Globals - table of global integrals that can be monitored and optimized
AddGlobal(name="NoOfSuspected",       comment='Number of Suspected individuals', unit="1.")
AddGlobal(name="NoOfInfected",        comment='Number of Infected individuals',  unit="1.")
AddGlobal(name="NoOfRecovered",       comment='Number of Recovered individuals', unit="1.")

#	Boundary things:
AddNodeType(name="DirichletEQ",     group="BOUNDARY")
AddNodeType(name="ImageReader",     group="IMAGE") 
AddNodeType(name="CROSSMRT",	    group="COLLISION")
AddNodeType(name="CROSSMRT_FOI",	group="COLLISION")



# Inputs: Flow Properties
# https://en.wikipedia.org/wiki/Compartmental_models_in_epidemiology#The_SIR_model
# Between S and I, the transition rate is βI/N, where β is the average number of contacts per person per time, 
# multiplied by the probability of disease transmission in a contact between a susceptible and an infectious subject,
# and I/N is the fraction of contact occurrences that involve an infectious individual.

# Between I and R, the transition rate is γ (simply the rate of recovery or mortality, that is, 
# number of recovered or dead during one day divided by the total number of infected on that same day, 
# supposing "day" is the time unit[clarification needed]). 
# If the duration of the infection is denoted D, then γ = 1/D, since an individual experiences one recovery in D units of time.

AddSetting(name="sir_beta",                 default=0.0,        comment="s2i constant -> infection rate")
AddSetting(name="sir_gamma",                default=0.0,        comment="i2r constant -> 1/gamma is the mean infective period")
AddSetting(name="diffusivity_s",            default=0.16666666, comment='spacial diffusivity for the fraction of suspected', zonal=T)
AddSetting(name="diffusivity_i",            default=0.16666666, comment='spacial diffusivity for the fraction of infected',	zonal=T)
AddSetting(name="diffusivity_r",            default=0.16666666, comment='spacial diffusivity for the fraction of recovered', zonal=T)
AddSetting(name="sigma2_tweaker",           default=1.0,        comment='to modify the variance')
AddSetting(name="omega_turb_multiplicator", default=0.0,        comment="extra diffusivity in locations with high population density")

AddSetting(name="infectious_radius",        default=1.,         comment="used in cross-MRT model")
AddSetting(name="cross_omega_limiter_low",  default=1.,        comment="used in cross-MRT model")
AddSetting(name="cross_omega_limiter_high", default=2.,        comment="used in cross-MRT model")


AddSetting(name="Init_PopulationDensity",   zonal=TRUE)
AddSetting(name="Init_S_Fraction",          zonal=TRUE)
AddSetting(name="Init_I_Fraction",          zonal=TRUE)
AddSetting(name="Init_R_Fraction",          zonal=TRUE)

#	CFD enhancements ;)
AddField(name="populationDensity",          stencil2d=1)
AddNodeType(name="Smoothing",               group="ADDITIONALS")  #  To smooth population density during initialization.
AddSetting(name="population_smoothing")  #  To smooth population density during initialization.

