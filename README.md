# KSmodel_fMRIdynamics

This data and code package should allow users to independently reproduce findings reported in Pope et al (2021).

'KS_model_main' runs a single instance of the KS model with model parameters set to the values employed for 
most analyses in the main text (k = 280; vel = 12). The model should run, on a fast machine, within 
about 25 minutes.  Model output includes simulated FC and BOLD time courses (Ybold_reg). The script 
also calculated the edge time series and RSS amplitudes, and it detects RSS peaks using the 'circshift'
approach detailed in the paper.  Plots showing the 'ets' and RSS time series with events are produced as well.
Finally, for the single simulated run, the script draws figures matching Fig 4B and Fig 4D.

Users can adapt the code to create new simulations with different parameters. Note that model output will vary 
slightly with published figures and statistics as each simulation uses different initial conditions and 
random seeds.

-'figure_SCFC' re-creates part of Fig 2 from the exact model data used in the paper
-'figure_SCFC2' re-creates a different part of Fig 2 from the exact model data used in the paper, and computes
some summary statistics for SC-FC relationships
-'figure_eventclusters' re-creates part of Fig 5 from the exact model data used in the paper

These scripts read in various data files that contain time series, the SC consensus modules, and empirical SC
and FC matrices.  See text of paper for description.
