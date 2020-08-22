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
CDST0 = 3*Mobility * (1.-4.*pf*pf)* W  * wi * n %*% t(U)

CDST_HO = MRT_eq(U, pvone, n, order=3, ortogonal=FALSE)  
CDST_HO_Zero = MRT_eq(U, pvone, c(pvzero, pvzero), order=3, ortogonal=FALSE)  

CDST_HO$Req = CDST_HO$Req - CDST_HO_Zero$Req
CDST_HO$feq = CDST_HO$Req %*% solve(CDST_HO$mat)
C(tmp,CDST_HO$Req)

EQ_H_int = MRT_eq(U, pf, u*pf + , ortogonal=FALSE);


#EDM: C(m, (m - meq)*(1-Omega) + meg + meq_du - meq )

EQ_H_dU = MRT_eq(U, pf, dU, ortogonal=FALSE);

C(tmp, EQ_H$Req - EQ_H_dU$Req)


EQ_H$feq = EQ_H$feq + CDST 
EQ_H$Req =  EQ_H$feq * EQ_H$mat

C(tmp,CDST %*% U)

C(tmp,EQ_H$Req)



EQ_F = MRT_eq(U, rho, J, ortogonal=FALSE, mat=M);



C(tmp, EQ_H$Req)

