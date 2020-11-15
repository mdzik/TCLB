library(polyAlgebra);
setwd("/home/mdzik/projekty/TCLB");
source("./CLB/auto_scmpTau1_d2q9/Dynamics.c.code.R")

# D2Q9
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
        cat("XXXXXXXXXXXXXXXXXXXXXX")
        R = PV(c(paste("R[",1:9-1,"]",sep="")))
        C(R , PV(paste("Phi[", collapse( t(-t(U)-U[i,])+2 , "][" ) ,"]",sep="")) );
        C(R , PV(paste("Phi[",-U[i,1]-U[,1]+2,"][",-U[i,2]-U[,2]+2,"]",sep="")) );

}
    R = PV(c(paste("R[",1:9-1,"]",sep="")))
    C(R , PV(paste("getPsi(rho(",-U[i,1]-U[,1],",",-U[i,2]-U[,2],"))")));

  
    Force = PV(c(paste("F[",i,"].x",sep=""),paste("F[",i,"].y",sep="")));
    
    gs = c(0,1,1,1,1,1/4,1/4,1/4,1/4);
    A = -0.152
    C(R[-1] , (R * R * A + R * R[1] * (A*(-2)+1))[-1],float=F)
    C(Force , Force -(0.666666666666666666)*(R*gs) %*% U)

for (i in seq(1,9)){

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

#############################################################################################
## D3Q19
#D=3
#Q=19

# D2Q9
D=2
Q=9

#Force = Force[1:D]
tmp = PV(paste("tmp[",1:Q-1,"]",sep=""))


rho = PV('rho')
J = PV(c('Jx','Jy','Jz'))
J = J[1:D]
x = c(0,1,-1);
xx = list(x)[rep(1,D)]
U = as.matrix(do.call(expand.grid, xx))

lengths = apply(U^2,1,sum)

if (Q == 19){
    qsel = lengths < 3
} else if (Q == 27) {
    qsel = lengths < 4
}
U = U[qsel,]

u = PV(paste("u[",1:D-1,"]",sep=""))

feq = PV(paste("tmp[",1:Q-1,"]",sep=""))

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

Gravitation = PV(c("GravitationX","GravitationY","GravitationZ"))


kk = as.matrix(do.call(expand.grid, list(seq(-2,2))[rep(1,D)] ))



collapse <- function(what, sep,dim){
    return(apply( what, 1, paste , collapse = sep))
}

C(PV(paste("Phi[",collapse(kk+2, ']['),"]",sep="")) , PV(paste("phi(",collapse(kk, ','),")")));

for (i in seq(1,Q))
{
    

    R = PV(c(paste("R[",1:Q-1,"]",sep="")))
    #C(R , PV(paste("getPsi(rho(",apply( -U-U[i,] , 1, paste , collapse = "," ),"))")));

    R = PV(c(paste("R[",1:Q-1,"]",sep="")))
    
    C(R , PV(paste("Phi[", collapse( -U-U[i,]+2 , "][" ) ,"]",sep="")) );

    Force = PV(c(paste("F[",i,"].x",sep=""),paste("F[",i,"].y",sep=""),paste("F[",i,"].y",sep="")));
    
    #gs = c(0,1,1,1,1,1/4,1/4,1/4,1/4);

    gs = U[,1]
    sel = apply(U^2,1,sum)
    
    gs[] = 1
    if (Q == 9){
        gs[sel > 1] = 1/4
        alpha = -2/3.
    } else if (Q == 19){
        gs[sel > 1] = 1/2
        alpha = -1/3.
    }
    
    gs[sel == 0] = 0
        
    
    A = PV("Kupershtokh_A")
    C(R[-1] , (R * R * A + R * R[1] * (A*(-2)+1))[-1],float=F)
    C(Force , alpha*(R*gs) %*% U)


    rho_i = PV(paste("rho(",paste(-U[i,],collapse=','),")"))

    #rho_i = PV(paste("rho(",-U[i,1],",",-U[i,2],")"))
    JinR = PV(c( paste("Jx(",paste(-U[i,],collapse=','),")"),
                 paste("Jy(",paste(-U[i,],collapse=','),")"),
                 paste("Jz(",paste(-U[i,],collapse=','),")")))

    JinR = JinR + Force + Gravitation
    xyz = c('x','y','z')
    
    JinC = PV(paste("J_",xyz,"_i[",i-1,"]", sep=""))
    J_i = JinC[1:D]

    C(J_i, JinR[1:D] )
    
    rho_i = PV(paste("rho_i[",i-1,"]"))
    
    C(rho_i, PV(paste("rho(",paste(-U[i,],collapse=','),")")))

    
    EQi = MRT_eq(U, rho_i, J_i, order=3, ortogonal=FALSE);

    feq[i] = EQi$feq[i]
}

mpost = feq%*%EQi$mat

C(PV('rho'), mpost[1])
C(J[1:D], mpost[2:(D+1)])
C(PV('phi'), PV("getPsi(rho)"))



