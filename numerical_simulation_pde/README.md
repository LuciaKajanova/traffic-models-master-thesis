## Numerical Simulations – Kerner–Konhäuser Model

This folder contains MATLAB implementations of the Kerner–Konhäuser (KK) traffic flow model and related numerical experiments.

### Files

- **`Kerner_Konhauser_FD.m`**  
  Kerner Konhäuser fundamental diagrams:
  - $V(\rho)$
  - $Q(\rho)$

- **`Simulation.m`**  
  Main simulation script:
  - runs the numerical scheme  
  - evolves density and velocity in time  
  - produces outputs for further analysis (3D + heatmaps)

- **`Initial_condition.m`**  
  Defines initial conditions for the simulation:
  - initial density profile  
  - initial velocity profile  

- **`EE_KK.m`**  
  Auxiliary numerical script for finite difference method with explicit Euler scheme for KK model

- **`travelling_wave_speed.m`**  
  Post-processing script:
  - estimates travelling wave speed  
  - uses selected time intervals  
  - applies linear regression

---

### Requirements

- MATLAB (tested with R2021a) or newer

---

### Running the simulation

1. Open MATLAB  
2. Set the working directory to the folder `numerical_simulation_pde/`  

3. Run the main script:

```matlab
Simulation
```
---

### Notes

- Some files depend on outputs from previous simulations.
- Parameters and discretization settings can be modified directly in the scripts.