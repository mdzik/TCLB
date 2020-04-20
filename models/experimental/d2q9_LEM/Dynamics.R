x = c(0,1,-1);
P = expand.grid(x=0:2,y=0:2)
U = expand.grid(x,x)

f_sel = rep(TRUE,nrow(U))

P=P[f_sel,]
U=U[f_sel,]

for (fname0 in c('h', 'i', 'r') ) { 
    fname = paste(fname0,P$x,P$y,sep="")

    AddDensity(
        name = fname,
        dx   = U[,1],
        dy   = U[,2],
        comment=paste("density: ",fname),
        group=fname0
    )
}
# 	Outputs:
AddQuantity(name="Infected")
AddQuantity(name="Healthy")
AddQuantity(name="Recovered")

AddQuantity(name="Random")

#	Inputs: Flow Properties
AddSetting(name="h_to_i")
AddSetting(name="i_to_r")
AddSetting(name="Population", zonal=TRUE)
AddSetting(name="InfectedProb", zonal=TRUE)
#	Boundary things:
#AddNodeType(name="Dirichlet", group="BOUNDARY")
