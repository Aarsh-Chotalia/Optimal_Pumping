# MATLAB Simulations

## Overview

This project contains MATLAB code and `.mat` data files (generated) for simulations involving optimal energy pumping in an entrained neural (JR) system by frequency shuffling.

## File Structure

### MATLAB Scripts

- **Code.m**  
  Main script to run the simulations and generate.

- **odejr.m**  
  Contains the ODE definitions of Jansen-Rit model with a stimulus.

- **fig3_with_error.m**  
  Script to generate Figure 3 with error bars.



### Data Files (`.mat`)

These files contain simulation results for various values of shuffling times `st` (=1/shuffling_frequency).

| Filename     | Description                      |
|--------------|----------------------------------|
| st0.001.mat  | Simulation result for st = 0.001 |
| st0.005.mat  | Simulation result for st = 0.005 |
| st0.01.mat   | Simulation result for st = 0.01  |
| st0.05.mat   | Simulation result for st = 0.05  |
| st0.1.mat    | Simulation result for st = 0.1   |
| st0.5.mat    | Simulation result for st = 0.5   |
| st1.mat      | Simulation result for st = 1     |
| st2.mat      | Simulation result for st = 2     |
| st5.mat      | Simulation result for st = 5     |
| st10.mat     | Simulation result for st = 10    |

These files can be loaded using `load('filename.mat')` in MATLAB.

## How to Run

1. Open `Code.m` in MATLAB.
2. Ensure `odejr.m' is in the same directory.
3. Run `Code.m' --> will take \approx 50 hours to run the model (Depends on the processor) and generate the data.
4. Alternatively, use the `.mat' data provided in this repository and proceed to the next step.
5. Use `fig3_with_error.m` to reproduce the final plot (Figure3) with error visualization.
6. 

## Requirements

- MATLAB R2020 or newer (recommended)
- Signal Processing Toolbox
- Access to all `.mat` files either provided in this repository or genrerated after running `Code.m'.



