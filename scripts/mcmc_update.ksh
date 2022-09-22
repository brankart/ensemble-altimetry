#!/bin/bash
#SBATCH --job-name=mcmcsampler
#SBATCH -e mcmcsampler.e%j
#SBATCH -o mcmcsampler.o%j
#SBATCH --ntasks=480
#SBATCH --ntasks-per-node=40
#SBATCH --time=15:00:00            # Temps d’exécution maximum demande (HH:MM:SS)
#SBATCH -A egi@cpu
#SBATCH --hint=nomultithread
###SBATCH --qos=qos_cpu-dev
#SBATCH --qos=qos_cpu-t3

module purge
module load intel-all/19.0.4
module load hdf5/1.8.21-mpi
module load netcdf/4.7.2-mpi
module load netcdf-fortran/4.5.2-mpi
module load netcdf-cxx4/4.3.1-mpi

. ./param.ksh

cd $wdir

# Update sesamlist with MCMC parameters
cp sesamlist sesamlist_mcmc
echo "MCMC_SCALE_MULTIPLICITY-1=${scal_mult_1}" >> sesamlist_mcmc
echo "MCMC_SCALE_MULTIPLICITY-2=${scal_mult_2}" >> sesamlist_mcmc
echo "MCMC_CONTROL_PRINT=1000" >> sesamlist_mcmc
echo "MCMC_CONVERGENCE_CHECK=1000" >> sesamlist_mcmc
echo "DYN_CONSTRAINT=${dyn_constraint}" >> sesamlist_mcmc
echo "DYN_CONSTRAINT_DT=${timestep}" >> sesamlist_mcmc
echo "DYN_CONSTRAINT_STD=${dyn_constraint_std}" >> sesamlist_mcmc
echo "OESTD_INFLATION=${oestd_inflation}" >> sesamlist_mcmc

ens_mean="priormean.cpak"
ens_std="priorstd.cpak"

odir="RED${expt}SMPENS${upd_size}.cpak.bas"
odirobs="RED${expt}SMPENS${upd_size}.cobs.bas"

rm -fr ${odir} ; mkdir ${odir}
rm -fr ${odirobs} ; mkdir ${odirobs}

cp $sdir/param.ksh $odir

srun sesam -mode mcmc -inxbas RED@ENS${ens_size}.cpak.bas -outxbas ${odir} -iterate $niter \
           -inobs redobs#.cobs -configobs redobs#.cobs -oestd redobs_oestd#.cobs \
           -inobas RED@ENS${ens_size}.cobs.bas -outobas ${odirobs} \
	   -bias ${ens_mean} -reducevar ${ens_std} -config sesamlist_mcmc

rm -f sesamlist_mcmc
