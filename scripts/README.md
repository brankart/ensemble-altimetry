# Description of the shell scripts

The scripts use SESAM and NCO tools to perform operations on the data. Files and directories containing intermediate data have standardized names defined in the scripts, which depend on the name of the experiment defined in the parameters. Parallelization and batch directives in the scripts may need to be adjusted to the system.

Each script performs one task on the data. They must be run successively to perform the ensemble analysis. They come in 5 categories:

### Prepare configuration (grid, mask, ...)

 * <i>param.ksh</i>: Define all parameters of the experiment.

 * <i>prepare_config.ksh</i>: Prepare SESAM configuration: mask and parameter files.

### Prepare multiscale prior ensemble (unconstrained by observations)

 * <i>draw_prior_sample.ksh</i>: Draw prior ensemble with specified spectrum in the basis of the spherical harmonics.

 * <i>draw_loc_sample.ksh</i>: Draw localizing ensemble with specified spectrum in the basis of the spherical harmonics.

 The prior ensemble can also be constructed using historical mapped data from DUACS:

 * <i>prepare_prior_ensemble.ksh</i>: Extract historical mapped data from DUACS (in native grid and format).

 * <i>spectrum_prior_ensemble.ksh</i>: Compute spectrum of the prior ensemble in the basis of the spherical harmonics.

 * <i>reconstruct_prior_ensemble.ksh</i>: Reconstruct prior ensemble on the computation grid from the spectrum.

 * <i>prepare_meanstd.ksh</i>: Compute mean and std of the prior ensemble (in native grid and format).

 * <i>spectrum_meanstd.ksh</i>: Compute spectrum of the prior ensemble mean and std in the basis of the spherical harmonics.

 * <i>reconstruct_meanstd.ksh</i>: Compute mean and standard deviation of the prior ensemble (if generated from DUACS products).

 * <i>prepro_reduce.ksh</i>: Center-reduce the prior ensemble (if generated from DUACS products).

### Prepare altimetric observations

 * <i>prepare_obs_database.ksh</i>: Prepare observation database (in native format).

 * <i>prepare_obs.ksh</i>: Prepare observations to use in the experiment.

### Sample the posterior ensemble

 * <i>mcmc_prepro.ksh</i>: Center-reduce observations using prior mean and std and compute obs equivalent to ensembles.

 * <i>mcmc_update.ksh</i>: Apply MCMC sampler to sample the posterior probability distribution (conditioned to observations).

 * <i>mcmc_postpro.ksh</i>: Un-center and un-reduce the MCMC sample, compute sample mean and std.

### Diagnose the posterior ensemble

 * <i>prepare_obs_daily.ksh</i>: Prepare daily observation files to compute daily diagnostics.

 * <i>prepare_rms_diag.ksh</i>: Prepare mask file to compute RMS misfits.

 * <i>prepare_reference.ksh</i>: Extract reference map from DUACS (in native grid and format).

 * <i>spectrum_reference.ksh</i>: Compute spectrum of the reference in the basis of the spherical harmonics.

 * <i>reconstruct_reference.ksh</i>: Reconstruct the reference DUACS product on the computation grid from the spectrum.

 * <i>check_reference.ksh</i>: Compute RMS misfit between observations and reference.

 * <i>check_rms_mcmc.ksh</i>: Compute RMS misfit between observations and MCMC sample.

 * <i>check_score_mcmc_global.ksh</i>: Compute global probabilistic scores (rank histogram, CRPS, RCRV).

 * <i>check_score_mcmc_daily.ksh</i>: Compute daily CRPS scores.
