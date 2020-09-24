import matplotlib.pyplot as plt
import numpy as np
from numpy.linalg import norm

from two_phase_poiseuille.TwoPhasePoiseuilleAnal import TwoPhasePoiseuilleAnal, calc_gx
from two_phase_poiseuille.TwoPhasePoiseuilleFD import TwoPhasePoiseuilleFD, get_tanh_profile

# magic_ratio = 1
# rho_h = magic_ratio * 54.6
# rho_l = 1
# kin_visc_h = 1
# kin_visc_l = magic_ratio

# rho_h = 1000
# rho_l = 1.22
# kin_visc_h = 1.0E-06
# kin_visc_l = 1.5E-05

rho_h = 1
rho_l = 1
kin_visc_h = 100
kin_visc_l = 1

mu_h = rho_h * kin_visc_h
mu_l = rho_l * kin_visc_l
mu_ratio = mu_l / mu_h

h = 500
y_ = np.linspace(-h, h, 1000)

uc = 0.01


# gx = 1
gx = calc_gx(uc, mu_l, mu_h, rho_l, rho_h, h)
pa = TwoPhasePoiseuilleAnal(gx=gx, mu_l=mu_l, mu_h=mu_h, rho_h=rho_h, rho_l=rho_l, h=h)
u_a = np.array([pa.get_u_profile(y_[i]) for i in range(len(y_))])

p_fd = TwoPhasePoiseuilleFD(gx=gx, mu_l=mu_l, mu_h=mu_h, rho_h=rho_h, rho_l=rho_l, h=h)
u_fd = p_fd.get_u_profile(y_, W=5)

gx_air_water = calc_gx(uc, mu_l=1.22*1.5E-05, mu_h=1000 * 1.0E-06, rho_h=1000, rho_l=1.22, h=h)
pa_air_water = TwoPhasePoiseuilleAnal(gx=gx_air_water, mu_l=1.22*1.5E-05, mu_h=1000 * 1.0E-06, rho_h=1000, rho_l=1.22, h=h)
u_air_water = np.array([pa_air_water.get_u_profile(y_[i]) for i in range(len(y_))])

# make plot
plt.rcParams.update({'font.size': 24})
plt.figure(figsize=(12, 8))

plt.plot(u_a, y_, color="green", linestyle="--", label=r'$analytical \, solution$')
plt.plot(u_fd, y_,  color="red", linestyle="-.", label=r'$FD \, solution$')
# plt.plot(u_air_water, y_,  color="blue", linestyle="-", label=r'$air- water \: analytical \, solution$')
# profil = get_tanh_profile(y_, h, mu_h, mu_l, W=1E0)
# plt.plot(profil, y_,  color="blue", linestyle="-.", label=r'$profile$')

plt.ylabel(r'$y$')
plt.xlabel(r'$u_x$')

plt.title('two phase Poiseuille flow')
plt.grid(True)
plt.legend()

fig = plt.gcf()  # get current figure
fig.savefig('two_phase_Poiseuille_anal_vs_fd_rho%s_v%s.png' % (str(rho_h/rho_l), str(kin_visc_h/kin_visc_l)))
plt.show()
