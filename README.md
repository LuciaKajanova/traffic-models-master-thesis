# Advanced models of a trafic flow – Master's Thesis

### Author: Lucia Kajanová  
### University: Masaryk University, Faculty of Science, Department of Mathematics and Statistics (2025/2026)  
### Supervisor: prof. RNDr. Zdeněk Pospíšil, Dr.  
### Consultant: RNDr. Veronika Eclerová, Ph.D.

---

## Overview

This repository contains code and materials for a master's thesis focused on advanced traffic flow models, with emphasis on:

- partial differential equations  
- bifurcation analysis  
- numerical simulations  
- Kerner–Konhäuser traffic flow model 
- NGSIM data reproduction

The repository is structured to support reproducibility of both bifurcation analysis (MatCont) and numerical simulations (PDE).

---

## 📁 Repository Structure

### /bifurcation_analysis

Contains files for bifurcation analysis using MatCont.

- system definition (KKTrafficFlowNew.m)
- default parameters (KKTrafficFlowNew.mat)
- saved continuation results and diagrams

```text
bifurcation_analysis/
│
├── KKTrafficFlowNew.m
├── KKTrafficFlowNew.mat
│
└── KKTrafficFlowNew/
    ├── diagram/
    ├── het_aprox_cycle/
    ├── hom_aprox_3D/
    ├── slice_c_5/
    ├── slice_c_20/
    ├── slice_c_26/
    ├── slice_c_40/
    ├── two_parametric_diagram/
    ├── two_parametric_diagram_BT/
    └── session.mat
```

---

### /numerical_simulation_pde

Contains MATLAB scripts for numerical simulation of the Kerner–Konhäuser PDE model.

```text
numerical_simulations/
│
├── Kerner_Konhauser_FD.m
├── Simulation.m
├── Initial_condition.m
├── EE_KK.m
└── travelling_wave_speed.m
```

- implementation of finite difference scheme  
- simulation of density and velocity  
- travelling wave analysis  

---

### /NGSIM_data

Contains preprocessing pipeline based on real traffic data (NGSIM).

- R scripts for:
  - fundamental diagrams
  - heatmaps
  - initial/boundary conditions
- MATLAB simulations based on real data

---

## Thesis Document

The final version of the master's thesis is included in this repository as a PDF file.

- `thesis.pdf` contains the complete written work, including theoretical background, methodology, and results.
- The code in this repository corresponds to the computational and numerical parts described in the thesis.

The PDF provides additional context, detailed explanations, and interpretation of the results.

Language used: Slovak

---

## Requirements

- MATLAB (tested with R2021a) or newer 
- MatCont (version 7p4 or newer)  
- R (tested with version 4.4.3)  

---

## Reproducibility

- Bifurcation analysis can be reproduced using MatCont (see /bifurcation_analysis)
- Numerical simulations can be reproduced using MATLAB scripts
- Data-based simulations use processed NGSIM data

---

## Notes

- Additional figure editing scripts are intentionally not included, as they are not required for reproducing results.
- This repository is intended for reproducibility and research purposes.

