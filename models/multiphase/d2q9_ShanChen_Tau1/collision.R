library(polyAlgebra);
setwd("TCLB");
source("./CLB/d2q9_ShanChen_Tau1/Dynamics.c-debug.R")
Force = PV(c("F.x","F.y"));


tmp = PV(paste("tmp[",1:9-1,"]",sep=""))
rho = PV('rho')
J = PV(c('Jx','Jy'))

x = c(0,1,-1);
U = as.matrix(expand.grid(x,x))


u = PV(paste("u[",1:2-1,"]",sep=""))

EQ = MRT_eq(U, rho, J, order=12, ortogonal=FALSE);

feq = EQ$feq
for (i in seq(1,9))
{
    
    rho_i = PV(paste("rho(",-U[i,1],",",-U[i,2],")"))
    Jx = PV(paste("Jx(",-U[i,1],",",-U[i,2],")"))
    Jy = PV(paste("Jy(",-U[i,1],",",-U[i,2],")"))
    J_i = c(Jx,Jy)
    EQi = MRT_eq(U, rho_i, J_i, order=12, ortogonal=FALSE);

    feq[i] = EQi$feq[i]
}

mpost = feq%*%EQi$mat

C(PV('rho'), mpost[1])
C(PV('Jx'), mpost[2])
C(PV('Jy'), mpost[3])