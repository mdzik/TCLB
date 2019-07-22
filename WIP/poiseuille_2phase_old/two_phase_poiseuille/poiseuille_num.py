import matplotlib.pyplot as plt
import numpy as np
import os
from utilites import read_data

from two_phase_poiseuille.TwoPhasePoiseuilleAnal import TwoPhasePoiseuilleAnal


h = 49
uc = 1E-4

rho_l = 1
rho_g = 1
kin_visc_l = 100
kin_visc_g = 1

dyn_visc_l = rho_l * kin_visc_l
dyn_visc_g = rho_g * kin_visc_g
mu_ratio = dyn_visc_l / dyn_visc_g

y_ = np.linspace(-h, h, 101)
pa = TwoPhasePoiseuilleAnal(u_c=uc, mu_l=dyn_visc_l, mu_h=dyn_visc_g, rho_h=rho_g, rho_l=rho_l, h=h)
print("Body force Gx = %10.2e" % pa.gx)

u = np.array([pa.get_u_profile(y_[i]) for i in range(len(y_))])

# u = np.array([i for i in range(len(y_))])
# time = 1.0
# u *= np.exp(-time)


x_exp_cm, u_exp_cm = read_data(os.path.join("../data_for_plots", "Poiseuille", "cm_uPoiseuille_v100rho1.csv"))
x_exp_mrt, u_exp_mrt = read_data(os.path.join("../data_for_plots", "Poiseuille", "mrt_uPoiseuille_v100rho1.csv"))


# make plot
plt.rcParams.update({'font.size': 24})
plt.figure(figsize=(12, 8))

plt.plot(y_, u, color="green", linestyle="--", label=r'$analytical \, solution$')
plt.plot(x_exp_cm - len(x_exp_cm)/2, u_exp_cm, color="red", marker=">", linestyle="-", label=r'$cm$')
plt.plot(x_exp_mrt - len(x_exp_mrt)/2, u_exp_mrt, color="blue", marker="<", linestyle="-.", label=r'$mrt$')


plt.xlabel(r'$y$')
plt.ylabel(r'$u_x$')

plt.title('two phase Poiseuille flow')
plt.grid(True)
plt.legend()


plt.text(0.0, 5E-6, r'$\mu^* = %s$' % str(mu_ratio))
fig = plt.gcf()  # get current figure
fig.savefig('two_phase_Poiseuille_benchmark_mu%s.png' % str(mu_ratio))
plt.show()

