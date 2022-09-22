#!/bin/bash
#SBATCH --job-name=prepareobs
#SBATCH -e prepareobs.e%j
#SBATCH -o prepareobs.o%j
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=01:00:00            # Temps d’exécution maximum demande (HH:MM:SS)
#SBATCH --exclusive
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

if [ ! -d Obs_daily ] ; then
  mkdir Obs_daily
fi

obsname="Obs_daily/obs${slatype}"

# Loop on satellite mission
for sat in $satlist ; do

  sat_tag="_${sat}_"

  dbsfile="Obs_dbs/obs${slatype}${sat_tag}${jday_ini}.ncdbs"

  let jday0=$jday_ini-1

  # Loop on day
  let day=1
  while [ $day -le ${jday_window} ] ; do
    day2=`echo $day | awk '{printf("%02d", $1)}'`
    let jday=$jday0+$day
    let jday1=$jday+1

    # Prepare sesamlist with daily bounds for extracting partial observations
    cp sesamlist sesamlist_dailyobs
    let iobs=1
    while [ $iobs -le ${nobs} ] ; do
      echo "OBS_TIM_MIN-1:${iobs}=$jday" >> sesamlist_dailyobs
      echo "OBS_TIM_MAX-1:${iobs}=$jday1" >> sesamlist_dailyobs
      let iobs=$iobs+1
    done

    # Generate daily observation file
    rm -f ${obsname}_${jday}${sat_tag}.cobs
    sesam -mode obsv -indbs ${dbsfile} -outobs ${obsname}_${jday}#.cobs -affectobs $sat_tag -config sesamlist_dailyobs

    let day=$day+1
  done

done

rm -f sesamlist_dailyobs
