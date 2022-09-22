#!/bin/bash
#SBATCH --job-name=checkmcmc
#SBATCH -e checkmcmc.e%j
#SBATCH -o checkmcmc.o%j
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=00:45:00            # Temps d’exécution maximum demande (HH:MM:SS)
#SBATCH --exclusive
#SBATCH -A egi@cpu
#SBATCH --hint=nomultithread
#SBATCH --qos=qos_cpu-dev

. ./param.ksh
. ./util.ksh

cd $wdir

reffile="ref"
preffile="pref"

echo "Computing persistence for reference"
compute_persistence ${reffile}${ftype}.nc ${preffile}${ftype}.nc

# RMS difference between sample members and observations
rm -f ${reffile}_rmsobs${slatype}.txt
rm -f ${preffile}_rmsobs${slatype}.txt

  let jday0=$jday_ini-1

  echo "Computing RMS misift for satellite: $sat"

  # Loop on day
  let day=1
  while [ $day -le ${jday_window} ] ; do
    day2=`echo $day | awk '{printf("%02d", $1)}'`
    let jday=$jday0+$day

    echo "Computing RMS misift for Julian day: $jday"

    obsname="Obs_daily/obs${slatype}_${jday}"

    sesam -mode diff -inobs ${obsname}#.cobs \
                     -configobs ${obsname}#.cobs \
                     -diffobsref ${reffile}#.nc \
                     -inpartvar rmspart#.nc -incfg algodiff.cfg \
            >> ${reffile}_rmsobs${slatype}.txt
      
    sesam -mode diff -inobs ${obsname}#.cobs \
                     -configobs ${obsname}#.cobs \
                     -diffobsref ${preffile}#.nc \
                     -inpartvar rmspart#.nc -incfg algodiff.cfg \
            >> ${preffile}_rmsobs${slatype}.txt
      
    let day=$day+1
  done

