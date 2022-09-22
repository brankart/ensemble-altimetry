#!/bin/bash
#SBATCH --job-name=spectrum
#SBATCH -e spectrum.e%j
#SBATCH -o spectrum.o%j
#SBATCH --ntasks=40
#SBATCH --ntasks-per-node=40
#SBATCH --time=00:10:00            # Temps d’exécution maximum demande (HH:MM:SS)
#SBATCH -A egi@cpu
#SBATCH --hint=nomultithread
#SBATCH --qos=qos_cpu-dev

. ./param.ksh

cd $wdir

srun sesam -mode spct -invar spcmean.cdf -outvar priormean.cpak -typeoper -_${loc_lmax} -config sesamlist
srun sesam -mode spct -invar spcstd.cdf -outvar priorstd.cpak -typeoper -_${prior_lmax} -config sesamlist


