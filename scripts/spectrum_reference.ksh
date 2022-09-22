#!/bin/bash
#SBATCH --job-name=spectrum
#SBATCH -e spectrum.e%j
#SBATCH -o spectrum.o%j
#SBATCH --ntasks=40
#SBATCH --ntasks-per-node=40
#SBATCH --time=00:05:00            # Temps d’exécution maximum demande (HH:MM:SS)
#SBATCH -A egi@cpu
#SBATCH --hint=nomultithread
#SBATCH --qos=qos_cpu-dev

cd $wdir

rm -f spcref.cdf
srun sesam -mode spct -invar gloref#.nc -outvar spcref.cdf -typeoper +_${prior_lmax} -config sesamlist_glo


