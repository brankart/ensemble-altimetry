#!/bin/ksh

# Directory settings

sdir="$HOME/ensemble-altimetry/scripts"  # Script directory
wdir="$WORK/ensemble-altimetry/work"     # Working directory

datadir="$STORE/../commun/Aviso"              # Observation data directory
datadir_map="$STORE/../commun/Aviso/mapped"   # Mapped DUACS data directory

# Mask and grid configuration

nlon="200"  # Grid size (longitude)
nlat="150"  # Grid size (latitude)
ntim="60"   # Grid size (time)

dlon="0.1"  # Grid resolution (longitude in degrees)
dlat="0.1"  # Grid resolution (latitude in degrees)
dtim="1"    # Grid resolution (time in days)

lon0="-57.95" # Grid initial point (longitude)
lat0="30.05"  # Grid initial point (latitude)
tim0="25202"  # Grid initial point (time, in Julian days since 1950/01/01)

# SESAM configuration (as in the sesamlist files)

ftype="_aviso_"  # Filetype tag included in filenames
nobs="6"         # Number of observations in configuration

# Observation database extraction parameters
# (satellite missions must be declared in SESAM condiguration files)

slatype="_unfiltered" # _filtered or _unfiltered
jday_ini="25202"      # Initial time to extract from database (Julian day)
jday_window="60"      # Length of time window (in days)
satlist="j3 alg s3a s3b c2 h2a" # List of satellite missions to extract (! h2a is for h2ag !)

# Observation parameters

scenario="analysis04"  # Name of the scenario to be prepared
#scenario="verif04"    # Name of the scenario to be prepared (verification scenario)
satlistobs="j3 s3a s3b h2a"  # List of satellite missions included
#satlistobs="alg c2"  # List of satellite missions included (in verification scenario)
jday_last="25261"     # Last time of observation to use
jday_last="25232"     # Last time of observation to use
oestd="0.04"          # Observation error standard deviation

# Prior ensemble parameters

ens_size="0050"         # Prior ensemble size (in 4 digits)

prior_lmax="450"        # Maximum degree of spherical harmonics in prior ensemble
prior_time_scale="4."   # Time scale (in days)
prior_radius="0.25"     # Spatial scale (in degree)
prior_dir_tag="450-04-0250"  # Tag in directory name

loc_lmax="200"          # Maximum degree of spherical harmonics in localizing ensemble
loc_time_scale="8."     # Localization time scale (in days) ! multiplied by sqrt(mult=6)
loc_radius="1.3"        # Localization radius (in degree)   ! multiplied by sqrt(mult=6)
loc_dir_tag="200-08-1300"    # Tag in directory name

# Prior ensemble parameters (if extracted from DUACS)
# Min and max grid indices should be well outside the area of interest
# to compute spectra without distortions resulting from the boundaries

imin="448"    # min grid index (longitude)
imax="607"    # max grid index (longitude)
jmin="450"    # min grid index (latitude)
jmax="569"    # max grid index (latitude)

jday_ini="15706"  # initial day to extract the first member of the historical ensemble
jday_lag="183"    # number of days between ensemble members

var_duacs="adt"   # name of the variable to extract from DUACS mapped files
std_duacs="err_sla"  # name of the error std to extract from DUACS mapped files

# MCMC sampler parameters

expt="ana01"               # Name of the experiment
scenario_used="analysis04" # Name of the observation scenario to use
upd_size="0020"            # Updated ensemble size
niter="100000"             # Number of iterations

scal_mult_1="1"            # Multiplicity of 1st scale (in Schur products)
scal_mult_2="6"            # Multiplicity of 2nd scale (in Schur products)

dyn_constraint=".FALSE."   # Apply dynamical constraint
dyn_constraint_std="1.0"   # Dynamical constraint error std
timestep="86400."          # Timestep in seconds

oestd_inflation="1."      # Observation error inflation factor

# Diagnostic parameters
scenario_verif="verif04"  # Name of the observation scenario to use as verification data

diagimin=25
diagimax=175
diagjmin=25
diagjmax=125

