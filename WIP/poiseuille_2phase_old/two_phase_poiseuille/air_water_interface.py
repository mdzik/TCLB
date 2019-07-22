import matplotlib.pyplot as plt
import numpy as np
from numpy.linalg import norm

from two_phase_poiseuille.TwoPhasePoiseuilleAnal import TwoPhasePoiseuilleAnal, calc_gx


h = 50

rho_h = 1000
rho_l = 1.22
kin_visc_h = 1.0E-06
kin_visc_l = 1.5E-05
mu_h = rho_h * kin_visc_h
mu_l = rho_l * kin_visc_l

mu_ratio = mu_h/mu_l

uc = 1  # 0.000245--> max(u) = 0.1
gx = calc_gx(uc, mu_l, mu_h, rho_l, rho_h, h)

# gx = 5.45E-6

y_ = np.linspace(-h, h, 101)
pa_real = TwoPhasePoiseuilleAnal(gx=gx,
                                 mu_l=mu_l, mu_h=mu_h,
                                 rho_l=rho_l, rho_h=rho_h,
                                 h=h)
u_real = np.array([pa_real.get_u_profile(y_[i]) for i in range(len(y_))])


rho_h_simplified = 1 * 1000
rho_l_simplified = 0.01831 * 1000
kin_visc_h_simplified = 0.5 *2 #1.0E-06
kin_visc_l_simplified = 0.5 *2 #1.5E-05

# rho_h_simplified = 1000
# rho_l_simplified = 1
# kin_visc_h_simplified = 1 #1.5E-05
# kin_visc_l_simplified = 10 #1.0E-06
mu_h_simplified = rho_h_simplified * kin_visc_h_simplified
mu_l_simplified = rho_l_simplified * kin_visc_l_simplified

mu_ratio_simplified = mu_l_simplified / mu_h_simplified

gx_simplified = calc_gx(uc, mu_l_simplified, mu_h_simplified, rho_l_simplified, rho_h_simplified, h)

pa_simplified = TwoPhasePoiseuilleAnal(gx=gx_simplified,
                                       mu_l=mu_l_simplified, mu_h=mu_h_simplified,
                                       rho_l=rho_l_simplified, rho_h=rho_h_simplified,
                                       h=h)  # gx=8.125E-11
u_simplified = np.array([pa_simplified.get_u_profile(y_[i]) for i in range(len(y_))])


# ==========================================

gx_C = 2 * uc * (1 + 54.6) / ((54.6 + 54.6) * h * h)
pa_C = TwoPhasePoiseuilleAnal(gx=gx_C, mu_l=1, mu_h=54.6, rho_l=54.6, rho_h=54.6, h=h)
u_C = np.array([pa_C.get_u_profile(y_[i]) for i in range(len(y_))])

gx_D = 2 * uc * (1 + 54.6) / ((1 + 54.6) * h * h)
pa_D = TwoPhasePoiseuilleAnal(gx=gx_D, mu_l=1, mu_h=54.6, rho_l=54.6, rho_h=1, h=h)
u_D = np.array([pa_D.get_u_profile(y_[i]) for i in range(len(y_))])

# make plot
plt.rcParams.update({'font.size': 24})
plt.figure(figsize=(12, 8))

plt.plot(u_real/max(u_real), y_/max(y_), color="green", linestyle="--", label=r'$case \, A $')  # air - water
plt.plot(u_simplified/max(u_simplified), y_/max(y_), color="red", linestyle="-", label=r'$case \, B$')  # air - water: \, simplified

plt.plot(u_C/max(u_C), y_/max(y_), color="blue", linestyle="-.", label=r'$ case \, C$')
# plt.plot(u_D, y_, color="red", linestyle=".", label=r'$ case \, D$')

plt.ylabel(r'$y/D$')
plt.xlabel(r'$u_x/U_{max}$')

plt.title(r'$two \,phase \,Poiseuille \,flow: \, \mu^*= %s $' % str(round(mu_ratio, 1)))
plt.grid(True)
plt.legend()


# plt.text(0.0, 5E-6, r'$\mu^* = %s$' % str(mu_ratio))
# plt.text(0.0, 5E-6, r'$\rho^* = %s$' % str(rho_l/rho_g))
fig = plt.gcf()  # get current figure
fig.savefig('two_phase_anal_Poiseuille_benchmark_mu%s.png' % str(round(mu_ratio, 1)))
plt.show()
