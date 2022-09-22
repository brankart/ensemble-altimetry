# Ensemble analysis of altimetric observations

This repository provide a collection of shell scripts to produce a ensemble analysis (2D+time) of altimetric observations.

### Software required

These scripts make use of the SESAM toolbox (https://github.com/brankart/sesam),
which requires the EnsDAM (https://github.com/brankart/ensdam)
and FlowSampler (https://github.com/brankart/flowsampler) libraries.
The installation of these software also requires
a FORTRAN-90 compiler and the NetCDF library (with f90 support).

The scripts also make use of the NCO NetCDF operators.

### Scripts

The scripts can be used to perform the following operations
(see the README file in the script directory for more details):
 * prepare configuration (grid, mask, ...);
 * prepare prior ensemble (unconstrained by observations);
 * prepare altimetric observations;
 * sample the posterior ensemble (conditioned to observations, using an MCMC sampler);
 * diagnose the posterior ensemble (RMS misfit, probabilistic scores, ...).

### Input data

The scripts use the following datasets:

* along-track altimetric data (L3 product). This corresponds to the tag SEALEVEL\_GLO\_PHY\_L3\_MY\_008\_062 in the CMEMS catalog (https://marine.copernicus.eu/). These data are used as observations to constrain the prior ensemble.

The scripts assume that these data are provided as archives (.tar) of daily files. For instance, the Jason-3 mission should be in a file 'j3.tar' with files like './j3/dt\_global\_j3\_phy\_l3\_20201231\_20210603.nc'.

* mapped altimetric data (L4 product). This corresponds to the tag SEALEVEL\_GLO\_PHY\_L4\_MY\_008\_047 in the CMEMS catalog (https://marine.copernicus.eu/). These data are used as historical data to produce a climatological prior ensemble (not covering the period of interest). 

The scripts assume that these data are provided as daily files like 'dt\_global\_allsat\_phy\_l4\_20201231\_20210726.nc'. Instead of these data, the scripts can also generate the prior ensemble by sampling random fields with a specified spectrum in the basis of the spherical harmonics.

### Parameters

The paremeters are specified in the script 'param.ksh', which is sourced in all other scripts so that they all see the same parameters. The parameters include:
 * directory settings;
 * grid and mask configuration;
 * observation parameters (mission, time window, observation error,...);
 * multiscale prior ensemble parameters (size, localization scale,...);
 * MCMC sampler parameters (sample size, number of iterations, localization,...);
 * diagnostic parameters.

### Output data

The output is an ensemble of possible solutions (in 2D+time), including the following variables: dynamic topography, geostrophic velocity, relative vorticity, and material derivative of potential vorticity.
