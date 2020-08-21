setwd("~/projekty/TCLB")
source("CLB/d2q9_csf2_WMRT/Dynamics.c.code.R", encoding = "UTF-8")



tmp = PV(paste("tmp[",1:9-1,"]",sep=""))


pf = PV("pf")
W = PV("IntWidth")	
n = c(PV('n.x'),PV('n.y'))  
mob = PV("Mobility")

EQ_H = MRT_eq(U, pf, u*pf, ortogonal=FALSE);
pvzero = PV('a') - PV('a')
pvone = 1 + pvzero 
wi = MRT_eq(U, pvone, c(pvzero, pvzero), ortogonal=FALSE)$feq;

#wi = as.vector(wi)
#CounterDiffusiveSourceTerm
CDST = 3*mob * (1.-4.*pf*pf)* W  * wi * n %*% t(U)
C(tmp,CDST %*% EQ_H$mat)

C(tmp,EQ_H$Req)



EQ_F = MRT_eq(U, rho, J, ortogonal=FALSE, mat=M);



C(tmp, EQ_H$Req)

