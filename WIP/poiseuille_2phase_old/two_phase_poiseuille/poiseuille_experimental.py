import matplotlib.pyplot as plt
import csv
import numpy as np
import os
from utilites import remove_duplicates_y, read_data
from numpy.linalg import norm

from two_phase_poiseuille.TwoPhasePoiseuilleAnal import TwoPhasePoiseuilleAnal, calc_gx
from two_phase_poiseuille.TwoPhasePoiseuilleFD import TwoPhasePoiseuilleFD

h = 49
uc = 0.0076

rho_h = 1
rho_l = 1

kin_visc_h = 100
kin_visc_l = 1

mu_h = rho_h * kin_visc_h
mu_l = rho_l * kin_visc_l
mu_ratio = mu_l / mu_h

y_ = np.linspace(-h, h, 101)

gx = calc_gx(uc, mu_l, mu_h, rho_l, rho_h, h)
pa = TwoPhasePoiseuilleAnal(gx=gx, mu_l=mu_l, mu_h=mu_h, rho_h=rho_h, rho_l=rho_l, h=h)



print("Body force Gx = %10.2e" % pa.gx)

u = np.array([pa.get_u_profile(y_[i]) for i in range(len(y_))])

pa2 = TwoPhasePoiseuilleAnal(gx=gx, mu_l=mu_l, mu_h=mu_h, rho_h=rho_h, rho_l=rho_l, h=h)
u2 = np.array([pa2.get_u_profile(y_[i]) for i in range(len(y_))])

# make plot
plt.rcParams.update({'font.size': 24})
plt.figure(figsize=(12, 8))

plt.plot(y_, u, color="green", linestyle="--", label=r'$analytical \, solution$')
plt.plot(y_, u2, color="blue", linestyle="-.", label=r'$analytical \, solution2$')


plt.xlabel(r'$y$')
plt.ylabel(r'$u_x$')

plt.title('two phase Poiseuille flow')
plt.grid(True)
plt.legend()

fig = plt.gcf()  # get current figure
fig.savefig('two_phase_Poiseuille_benchmark_mu%s.png' % str(mu_ratio))
plt.show()

