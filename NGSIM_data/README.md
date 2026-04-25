# Simulation and Data Processing

This folder contains all scripts and data used for the numerical simulation of the Kerner–Konhäuser (KK) traffic flow model based on real NGSIM data.

## Structure

### R_code/
This directory contains R scripts used for preprocessing the NGSIM dataset and extracting model inputs:

- scatter_fit.R  
  Construction of fundamental diagrams (flow–density, speed–density, speed–flow) and nonlinear fitting of the KK-type fundamental diagram.

- heatmaps.R  
  Generation of time-space heatmaps of speed and density from NGSIM data.

- initial_condition.R  
  Estimation of initial conditions for density and speed from data (including smoothing).

- boundary_condition.R  
  Extraction and smoothing of right boundary conditions from data.

---

### Simulation/
This directory contains MATLAB scripts for solving the PDE system:

- EE_KK_sim.m  
  Implementation of the explicit finite difference scheme for the KK model.

- Simulation_data.m  
  Main simulation script using real initial and boundary conditions.

- Simulation_heatmap.m  
  Visualization of simulation results (3D plots and heatmaps).

---

### Data files

- us101_clean.csv  
  Reduced version of the NGSIM dataset (lane 2 only) to ensure reproducibility and manageable file size.

- initial_condition_lane2.csv  
  Processed initial condition for density and speed (exported from R).

- right_boundary_lane2.csv  
  Processed right boundary condition (exported from R).

---

## Workflow

1. Data preprocessing (R)  
   - Load and cleaned NGSIM data (lane 2)
   - Compute macroscopic quantities (speed, density, flow)  
   - Generate initial and boundary conditions  
   - Export data to .csv files  

2. Numerical simulation (MATLAB)  
   - Load processed data  
   - Solve the KK PDE system using an explicit scheme  
   - Store simulation results  

3. Visualization  
   - Generate 3D plots and heatmaps of density and speed  
   - Compare simulation results with real data  

---

## Notes

- The simulation is performed for lane 2 on a spatial interval  
  x ∈ [100, 600] m  
  and time interval  
  t ∈ [08:00, 08:30].

- Data smoothing (moving average) is applied to reduce noise and improve numerical stability.

- Parameter values used in simulations are documented in the thesis.

---

## Data source

The original NGSIM dataset is publicly available at:

https://data.transportation.gov/Automobiles/Next-Generation-Simulation-NGSIM-Vehicle-Trajector/8ect-6jqj/data_preview

Due to its large size, the full dataset is not included in this repository.  

---

## Purpose

The goal of this folder is to provide a complete pipeline from real traffic data to numerical simulation and comparison with macroscopic traffic flow models.