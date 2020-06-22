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

feq = PV(paste("tmp[",1:9-1,"]",sep=""))

# a2 = 3.852462271644162
# b2 = 0.1304438860971524 * 4.0 
# c2 = 2.785855170470555
# t=PV("Temperature")

# pow <- function(s,c) {
#   temp_C = s
#   for (ii in 1:(c-1)){ temp_C = temp_C * s}
#   return(temp_C)
# }

# getP <- function(rho_i){
#     return(PV("Magic") *((rho_i*(-pow(b2,3)*pow(rho_i,3)/64.+b2*b2*rho_i*rho_i/16.+b2*rho_i/4.+1)*t*c2))#/pow(1-b2*rho_i/4.,3)-a2*rho_i*rho_i))
# }
# getP(PV(1))

GravitationX = PV("GravitationX")
GravitationY = PV("GravitationY")

for (i in seq(1,9))
{
    

    R = PV(c(paste("R[",1:9-1,"]",sep="")))
    C(R , PV(paste("getPsi(rho(",-U[i,1]-U[,1],",",-U[i,2]-U[,2],"))")));

  
    Force = PV(c(paste("F[",i,"].x",sep=""),paste("F[",i,"].y",sep="")));
    
    gs = c(0,1,1,1,1,1/4,1/4,1/4,1/4);
    A = -0.152
    C(R[-1] , (R * R * A + R * R[1] * (A*(-2)+1))[-1],float=F)
    C(Force , Force -(0.666666666666666666)*(R*gs) %*% U)


    rho_i = PV(paste("rho(",-U[i,1],",",-U[i,2],")"))
    Jx = (PV(paste("Jx(",-U[i,1],",",-U[i,2],")")) + Force[1])*rho_i^-1
    Jy = (PV(paste("Jy(",-U[i,1],",",-U[i,2],")")) + Force[1])*rho_i^-1
    J_i = c(Jx + GravitationX,Jy)
    EQi = MRT_eq(U, rho_i, J_i, order=2, ortogonal=FALSE);

    feq[i] = EQi$feq[i]
}

mpost = feq%*%EQi$mat

C(PV('rho'), mpost[1])
C(PV('Jx'), mpost[2])
C(PV('Jy'), mpost[3])


