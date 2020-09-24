import matplotlib.pyplot as plt
import numpy as np
import os
from utilites import read_data
from numpy.linalg import norm

from two_phase_poiseuille.TwoPhasePoiseuilleAnal import TwoPhasePoiseuilleAnal, calc_gx

folder_path = os.path.join("../data_for_plots", "Poiseuille", "sharp_vs_diff_interface")

x_sharp, u_sharp = read_data(os.path.join(folder_path, "u_rho20_v5_sharp.csv"))
x_diff, u_diff = read_data(os.path.join(folder_path, "u_rho20_v5_diff.csv"))


h = 49
uc = 0.057 # --> max(u) = 0.1

rho_h = 1
rho_l = 20

kin_visc_h = 1
kin_visc_l = 5


mu_l = rho_l * kin_visc_l
mu_g = rho_h * kin_visc_h
mu_ratio = mu_l / mu_g

y_ = np.linspace(-h, h, 101)

gx = calc_gx(uc, mu_l, mu_g, rho_l, rho_h, h)
pa = TwoPhasePoiseuilleAnal(gx=gx, mu_l=mu_l, mu_h=mu_g, rho_h=rho_h, rho_l=rho_l, h=h)

print("Body force Gx = %10.2e" % pa.gx)

u = np.array([pa.get_u_profile(y_[i]) for i in range(len(y_))])


pa2 = TwoPhasePoiseuilleAnal(gx=gx, mu_l=100, mu_h=1, rho_l=100, rho_h=1, h=h)
u2 = np.array([pa2.get_u_profile(y_[i]) for i in range(len(y_))])

# make plot
plt.rcParams.update({'font.size': 24})
plt.figure(figsize=(12, 8))

plt.plot(y_, u, color="green", linestyle="--", label=r'$analytical \, solution$')
# plt.plot(y_, u2, color="blue", linestyle="-.", label=r'$analytical \, solution2$')
# plt.plot(x_exp_cm_Guo - len(x_exp_cm_Guo)/2 + 0.5, u_exp_cm_Guo, color="red", marker=">", linestyle="-", label=r'$cm \, Guo$')  # channel d = 49, thus add 0.5
plt.plot(x_sharp - len(x_sharp)/2 + 0.5, u_sharp, color="blue", marker="<", linestyle="-.", label='sharp interface')
plt.plot(x_diff - len(x_diff)/2 + 0.5, u_diff, color="red", marker="<", linestyle="-.", label='diffusive interface')
# plt.plot(x_exp_cm - len(x_exp_cm)/2 + 0.5, u_exp_cm, color="red", marker=">", linestyle="-", label=r'$cm$')

plt.xlabel(r'$y$')
plt.ylabel(r'$u_x$')

plt.title('two phase Poiseuille flow')
plt.grid(True)
plt.legend()


# plt.text(0.0, 5E-6, r'$\mu^* = %s$' % str(mu_ratio))
# plt.text(0.0, 5E-6, r'$\rho^* = %s$' % str(rho_l/rho_g))
fig = plt.gcf()  # get current figure
fig.savefig('two_phase_Poiseuille_benchmark_rho%s_v%s.png' % (str(rho_h/rho_l), str(kin_visc_h/kin_visc_l)))
plt.show()

# norm(u_exp_cm_Guo - u)/norm(u)
# norm(u_exp_cm_He - u)/norm(u)
# norm(u_exp_mrt - u)/norm(u)
