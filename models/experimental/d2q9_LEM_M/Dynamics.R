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

#   Inputs: Flow Properties
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
AddSetting(name="diffusivity",              default=0.16666666, comment='spacial diffusivity for the fraction of suspected/infected/recovered',	zonal=T)
AddSetting(name="stability_enhancement",    default=1.0,        comment='magic stability enhancement')
AddSetting(name="omega_turb_multiplicator", default=0.0,        comment="extra diffusivity in locations with high population density")

AddSetting(name="Init_PopulationDensity",    zonal=TRUE)
AddSetting(name="Init_S_Fraction",      zonal=TRUE)
AddSetting(name="Init_I_Fraction",      zonal=TRUE)
AddSetting(name="Init_R_Fraction",      zonal=TRUE)

#	CFD enhancements ;)
AddField(name="populationDensity", stencil2d=1)
AddNodeType(name="Smoothing", group="ADDITIONALS")  #  To smooth population density during initialization.
AddSetting(name="population_smoothing")  #  To smooth population density during initialization.

#	Boundary things:
AddNodeType(name="DirichletEQ", group="BOUNDARY")
AddNodeType(name="ImageReader", group="IMAGE") 
