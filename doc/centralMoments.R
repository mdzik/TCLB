library(polyAlgebra);
setwd("TCLB");
source("./CLB/d2q9_scmp_LycettLuo_ViscositySmooth_WMRT/Dynamics.c-debug.R")


EQ_STD = MRT_eq(U, rho, J, ortogonal=FALSE, order=4, mat=M);
EQ_CM = MRT_eq(U, rho, J, ortogonal=FALSE, order=4, mat=M);

