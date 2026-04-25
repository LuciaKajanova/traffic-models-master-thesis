# Bifurcation Analysis (MatCont)

This folder contains files and results for bifurcation analysis of the Kerner--Konhäuser traffic flow model using **MatCont**.

The analysis was originally performed in **MatCont 7p4**, but the files should also be compatible with newer versions, such as **MatCont 7p6**.

---

## Requirements

To reproduce or inspect the results, you need:

- MATLAB
- MatCont 7p4 or newer, for example MatCont 7p6

MatCont can be downloaded from SourceForge:

<https://sourceforge.net/projects/matcont/>

---

## Installation and Setup

### 1. Install MatCont

Download and extract MatCont. The local MatCont folder can be named for example:

```text
MatCont7p4/
```

or, for a newer version:

```text
MatCont7p6/
```

In the instructions below, `MatCont7pX` denotes the installed MatCont folder.

---

### 2. Add the system files

Copy the following system files into the `Systems` folder of MatCont:

```text
MatCont7pX/Systems/
```

Required files:

- `KKTrafficFlowNew.m` -- system definition
- `KKTrafficFlowNew.mat` -- default system settings and parameters

---

### 3. Add the computed MatCont results

Copy the folder containing the saved MatCont diagrams and continuation results into:

```text
MatCont7pX/Systems/
```

The resulting local structure should look like this:

```text
MatCont7pX/
│
├── matcont/                  # MatCont GUI launcher
│
├── Systems/
│   ├── KKTrafficFlowNew.m    # system definition
│   ├── KKTrafficFlowNew.mat  # default settings and parameters
│   │
│   └── KKTrafficFlowNew/     # saved MatCont diagrams and results
│       ├── diagram/
│       ├── two_parametric_diagram/
│       ├── two_parametric_diagram_BT/
│       ├── slice_c_5/
│       ├── slice_c_20/
│       ├── slice_c_26/
│       ├── slice_c_40/
│       ├── hom_aprox_3D/
│       ├── het_aprox_cycle/
│       └── session.mat
```

---

## Running MatCont

1. Open MATLAB.
2. Navigate to the local MatCont folder, for example:

```matlab
cd 'C:\path\to\MatCont7pX'
```

3. Start MatCont by running:

```matlab
matcont
```

This opens the MatCont graphical user interface.

---

## Loading the System in MatCont

In the MatCont GUI:

1. Open the system selection menu.
2. Select the system named `KKTrafficFlowNew`.
3. Load the corresponding saved diagrams or continuation results from the `KKTrafficFlowNew` folder.

The saved diagrams are organized by the type of analysis, for example two-parameter diagrams.

---


## Notes

- The file `session.mat` stores a saved MATLAB session and is not required for reproducing the main results.
- The main bifurcation results are stored in the corresponding MatCont diagram folders.
- Additional post-processing and figure-editing files are not required for reproducing the computations.
- The folder names in the repository may be slightly reorganized for clarity compared to the original local MatCont folder structure.
