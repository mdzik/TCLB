import matplotlib.pyplot as plt
import numpy as np
import os
from utilites import read_data
from numpy.linalg import norm

from two_phase_poiseuille.TwoPhasePoiseuilleAnal import TwoPhasePoiseuilleAnal, calc_gx
from two_phase_poiseuille.TwoPhasePoiseuilleFD import TwoPhasePoiseuilleFD

folder_path = os.path.join("/media/grzegorz/Container/DATA_FOR_PLOTS", "Poiseuille", "sharp_vs_diff_interface")

x_sharp, u_sharp = read_data(os.path.join(folder_path, "u_rho1_v100_sharp.csv"))
x_diff, u_diff = read_data(os.path.join(folder_path, "u_rho1_v100_diff.csv"))  # powinien widziec pliki Oo

# x_sharp, u_sharp = read_data("u_rho1_v100_sharp.csv")
# x_diff, u_diff = read_data("u_rho1_v100_diff.csv")

h = 49
uc = 0.0076  # --> max(u) = 0.1

rho_h = 1
rho_l = 1

kin_visc_h = 1
kin_visc_l = 100


mu_l = rho_l * kin_visc_l
mu_h = rho_h * kin_visc_h
mu_ratio = mu_l / mu_h

y_ = np.linspace(-h, h, 101)

gx = calc_gx(uc, mu_l, mu_h, rho_l, rho_h, h)

p_anal = TwoPhasePoiseuilleAnal(gx=gx, mu_l=mu_l, mu_h=mu_h, rho_h=rho_h, rho_l=rho_l, h=h)
u_anal = np.array([p_anal.get_u_profile(y_[i]) for i in range(len(y_))])

y_fd = np.linspace(-h, h, 10000)
p_fd = TwoPhasePoiseuilleFD(gx=gx, mu_l=mu_l, mu_h=mu_h, rho_h=rho_h, rho_l=rho_l, h=h)
u_fd = p_fd.get_u_profile(y_fd, W=5)


y_ = np.linspace(-h, h, 101)

# make plot
plt.rcParams.update({'font.size': 18})
plt.figure(figsize=(14, 9))

# channel d = 49, thus add 0.5

plt.plot(u_anal, y_, color="black", linestyle=":",  linewidth=3, label='analytical solution - step interface')
plt.plot(u_sharp, (x_sharp - len(x_sharp)/2 + 0.5), color="black", marker=">", markersize=9, linestyle="", label='current model - step interface')

plt.plot(u_fd, y_fd, color="black", linestyle="-",  linewidth=2, label='FD - diffuse interface')
plt.plot(u_diff, (x_diff - len(x_diff)/2 + 0.5), color="black", marker="o", markersize=9, linestyle="", label='current model - diffuse interface')

axes = plt.gca()
axes.set_yticks(np.arange(-50, 51, 25))
axes.set_ylim([-50, 50])

plt.xlim(0, 0.12)
axes.set_xticks(np.arange(0., 0.12, 0.02))
#     plt.ylim(y1.min(), y1.max())
#     plt.ylim(1.25*min(y1.min(), y2.min()), 1.25*max(y1.max(), y2.max()))


plt.ylabel(r'$y$')
plt.xlabel(r'$u_x$')

# plt.title('two phase Poiseuille flow')
plt.grid(True)
plt.legend()


# plt.text(0.0, 5E-6, r'$\mu^* = %s$' % str(mu_ratio))
# plt.text(0.0, 5E-6, r'$\rho^* = %s$' % str(rho_l/rho_g))
fig = plt.gcf()  # get current figure
fig.savefig(f'bw_two_phase_Poiseuille_benchmark_rho{rho_h/rho_l}_v{kin_visc_h/kin_visc_l}.pdf', bbox_inches='tight')
plt.show()

# norm(u_exp_cm_Guo - u)/norm(u)
# norm(u_exp_cm_He - u)/norm(u)
# norm(u_exp_mrt - u)/norm(u)
