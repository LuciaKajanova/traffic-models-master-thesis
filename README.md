# Advanced Traffic Models – Master's Thesis
### Author: Lucia Kajanová
### University: Masaryk University, Faculty of Science, Department of Mathematics and Statistics (2025/2026)
### Supervisor: prof. RNDr. Zdeněk Pospíšil, Dr.
### Consultant: RNDr. Veronika Eclerová, Ph.D.

This repository contains code and materials for my master's thesis focused on advanced traffic flow models, with an emphasis on partial differential equations, bifurcation and numerical analysis.

## Overview

The goal of this work is to study nonlinear traffic flow models, analyze their qualitative behavior, and investigate their numerical solutions.

Main topics:
- traffic flow modeling (e.g., Kerner-Konhäuser model)
- partial differential equations
- bifurcation analysis
- phase portraits
- numerical simulations
- stability 

---

## 📁 Repository Structure

### `/bifurcation_analysis`
Contains MATLAB code for bifurcation analysis using MatCont.

```text
bifurcation_analysis/
│
├── matlab/
│   ├── KKTrafficFlowNew.m
│   └── KKTrafficFlowNew.mat
│
├── diagrams/
│
├── two_parametric_diagram/
├── two_parametric_diagram_BT/
│
├── slices/
│   ├── c_5/
│   ├── c_20/
│   ├── c_26/
│   └── c_40/
│
├── homoclinic/
│   └── approx_3D/
│
└── heteroclinic/
    └── approx_cycle/
```

---

### `/bifurcation_analysis_matlab_edit`

Contains MATLAB scripts and tools for post-processing and editing of outputs:
- adjustment of trajectories
- refinement of diagrams and figures
- preparation of visualizations for analysis and presentation

### `/numerical_simulation_pde`
Contains MATLAB code for numerical simulation (PDE).
```text
numerical_simulations/
│
├── Kerner_Konhauser_FD.m
├── Simulation.m
├── Initial_condition.m
├── EE_KK.m
└── travelling_wave_speed.m
```

## Technologies

- MATLAB
- Matcont
- Quarto / LaTeX

---

##  Notes

- The repository is work in progress.
- Some scripts are experimental and may change.
- Results are part of an ongoing master's thesis.

