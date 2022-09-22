#!/bin/bash
#SBATCH --job-name=drawsample
#SBATCH -e drawsample.e%j
#SBATCH -o drawsample.o%j
#SBATCH --ntasks=240
#SBATCH --ntasks-per-node=40
#SBATCH --time=02:00:00            # Temps d’exécution maximum demande (HH:MM:SS)
#SBATCH -A egi@cpu
#SBATCH --hint=nomultithread
#SBATCH --qos=qos_cpu-dev

module purge
module load intel-all/19.0.4
module load hdf5/1.8.21-mpi
module load netcdf/4.7.2-mpi
module load netcdf-fortran/4.5.2-mpi
module load netcdf-cxx4/4.3.1-mpi

. ./param.ksh

cd $wdir

odirbas="RED1ENS${ens_size}.cpak.bas"
odirbastag="RED1ENS${ens_size}-${prior_dir_tag}.cpak.bas"

# Prepare sesamlist with sampling scales
cp sesamlist sesamlist_prior
echo "LOC_TIME_SCALE=$prior_time_scale" >> sesamlist_prior
echo "LOC_RADIUS_IN_DEG=$prior_radius"  >> sesamlist_prior

#srun sesam -mode spct -invar zero.cpak -outvar zran#.nc -typeoper R_${prior_lmax} -config sesamlist_prior

# Sample random fields with required spectrum
rm -fr ${odirbas} ; mkdir ${odirbas}
srun sesam -mode spct -inxbas ${odirbas} -outxbas ${odirbas} -typeoper R_${prior_lmax} -config sesamlist_prior

rm -fr ${odirbastag}
mv ${odirbas} ${odirbastag}
ln -sf ${odirbastag} ${odirbas}

rm -f sesamlist_prior
