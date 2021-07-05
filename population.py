#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import numpy as np
from scipy import constants as sciconst
from scipy.integrate import solve_ivp
import matplotlib.pyplot as plt
import re

filename = "fort.8"
temp_v = 4500 # K

def read_levelfile(level_filename):
    with open(level_filename, "r") as f:
        data_str = f.readlines()
    
    dim = int(np.sqrt(len(data_str)-11))+1
    E21 = np.empty((dim,dim))
    E21.fill(np.nan)
    TDM = np.empty((dim,dim))
    TDM.fill(np.nan)
    
    p = re.compile(r'------')
    for i, line in enumerate(data_str):
        if p.search(line) == None:
            continue
        else:
            start_line = i+1
            break
    
    for line in data_str[start_line:]:
        l = line.split()
        v_prime = int(l[2])
        v_doubleprime = int(l[4])
        E21_value = float(l[6])
        TDM_value = float(l[9].replace('D', 'E'))
        if E21_value < 0:
            E21[v_prime, v_doubleprime] = E21_value
            TDM[v_prime, v_doubleprime] = TDM_value
        elif E21_value > 0:
            E21[v_doubleprime, v_prime] = E21_value
            TDM[v_doubleprime, v_prime] = TDM_value
        else:
            continue
    
    return E21, TDM

def cal_A_coef(TDM, E21):
    # Bernath PF. Spectra of atoms and molecules, 3rd ed. New York: Oxford University Press; 2016. p.19 eq 1.53
    cal_CGS_SI = 16 * sciconst.pi**3 * (1e2*sciconst.c)**3 * (1e-21/sciconst.c)**2 /(3 * sciconst.epsilon_0 * sciconst.h * sciconst.c**3)
    
    A_coef = cal_CGS_SI * E21**3 * TDM**2
    
    A_coef_XtoA = (-2) * A_coef * (E21<0) # A states have fine structure
    A_coef_AtoX = A_coef * (E21>=0)
    return A_coef_XtoA, A_coef_AtoX

def cal_J_level(J0, B, num):
    return J0 + B * np.arange(num, dtype=np.float64) * (np.arange(num, dtype=np.float64) + 1) # cm-1

def Boltzmann_plot_J(J_level, T_init):
    num = J_level.shape[0]
    Boltzmann_plot_unnormalize = (2 * np.arange(num, dtype=np.float64) + 1) * np.exp(-(J_level - J_level[0]) * (10**2) * sciconst.c * sciconst.h / (sciconst.k * T_init))
    return Boltzmann_plot_unnormalize/Boltzmann_plot_unnormalize.sum()

def cal_v_level(v0, we, wexe, num):
    n_array = np.linspace(0,num,num+1)
    level = v0+we*(n_array+1/2)-wexe*(n_array+1/2)**2
    return level

def Boltzmann_plot_v(v_level, T_init):
    Boltzmann_plot_unnormalize = np.exp(-v_level * (10**2) * sciconst.c * sciconst.h / (sciconst.k * T_init))
    return Boltzmann_plot_unnormalize

def population_ode(t, N, A_coef_arr):
    dNdt = A_coef_arr @ N
    return dNdt

def coef_arrange(N_X, N_A, A_coef_XtoA, A_coef_AtoX):
    N_arrange = np.append(N_X, N_A)
    
    N_X_num = N_X.shape[0]
    N_A_num = N_A.shape[0]
    dim = N_X_num + N_A_num
    A_coef_arrange = np.zeros((dim,dim))
    
    np.set_printoptions(linewidth=190, precision=1)
    
    for i_X in range(N_X_num):
        for i_A in range(N_A_num):
            A_coef_arrange[N_X_num + i_A, i_X] = A_coef_XtoA[i_X,i_A]
            A_coef_arrange[i_X, N_X_num + i_A] = A_coef_AtoX[i_X,i_A]
    
    for i_X in range(N_X_num):
        A_coef_arrange[i_X,i_X] = - A_coef_XtoA[i_X, :N_A_num].sum()
    for i_A in range(N_A_num):
        A_coef_arrange[N_X_num+i_A, N_X_num+i_A] = - A_coef_AtoX[:N_X_num, i_A].sum()
    
    return N_arrange, A_coef_arrange

def run(t_max=1.5):
    # Rehfuss, B. D., Liu, D., Dinelli, B. M., Jagod, M., Ho, W. C., Crofton, M. W., & Oka, T. (1988). Infrared spectroscopy of carbo‐ions. IV. TheA 2Πu–X 2Σ+gelectronic transition of C−2. The Journal of Chemical Physics, 89(1), 129–137. https://doi.org/10.1063/1.455731 
    level_num = 10
    v_level_X = cal_v_level(0, 1781.189, 11.6717, level_num)
    v_level_A = cal_v_level(3985.83, 1666.4, 10.80, level_num)
    Boltzmann_X = Boltzmann_plot_v(v_level_X, temp_v)
    Boltzmann_A = Boltzmann_plot_v(v_level_A, temp_v)
    Boltzmann_X = Boltzmann_X / (Boltzmann_X.sum() + Boltzmann_A.sum())
    Boltzmann_A = Boltzmann_A / (Boltzmann_X.sum() + Boltzmann_A.sum())
    
    # E21["X", "A"], TDM["X", "A"], A_coef_XtoA_C2["X", "A"], A_coef_AtoX_C2["X", "A"]
    E21, TDM = read_levelfile(filename)
    A_coef_XtoA_C2, A_coef_AtoX_C2 = cal_A_coef(TDM, E21)
    
    N_arrange_C2, A_coef_arrange_C2 = coef_arrange(Boltzmann_X, Boltzmann_A, A_coef_XtoA_C2, A_coef_AtoX_C2)
    np.set_printoptions(linewidth=190, precision=1)
    
    #sol = solve_ivp(fun=lambda t,x:population_ode(t,x,A_coef_arrange_C2), t_span=[0,t_max], y0=N_arrange_C2, t_eval=np.logspace(-3,np.log10(t_max),10**4), method="LSODA")
    sol = solve_ivp(fun=lambda t,x:population_ode(t,x,A_coef_arrange_C2), t_span=[0,t_max], y0=N_arrange_C2, t_eval=np.linspace(0,t_max,10**4), method="LSODA")
    print(sol.message)
    
    return sol.t, sol.y.T

def draw_population(t,y,t_max=1.5):
    max_level=11
    #plt.xscale("log")
    plt.xlabel("storage time [s]")
    plt.ylabel("population")
    plt.ylim(0,0.7)
    plt.xlim(0,t_max)
    for i in range(max_level):
        plt.plot(t[:],y[:,i], label="v={}".format(i))
    plt.legend()
    #plt.plot(t,y.sum(axis=1))
    #plt.show()
    plt.savefig("output1.png", transparent=True)

t_max_plot = 2
t, y = run(t_max=t_max_plot)
#print(t[10000-1000:10000-1])
#print(y[10000-1000:10000-1,:].sum(axis=1))
draw_population(t,y,t_max=t_max_plot)
