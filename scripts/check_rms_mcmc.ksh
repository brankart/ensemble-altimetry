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

diagensdir="${expt}SMPENS${upd_size}"

allmembers="FALSE"

# RMS difference between sample members and observations
rm -f ${diagensdir}_rmsobs${slatype}_mean.txt
rm -f ${diagensdir}_rmsobs${slatype}_pmean.txt
rm -f ${diagensdir}_rmsobs${slatype}_????.txt

echo "Computing persistence for ensemble mean"
compute_persistence ${diagensdir}mean${ftype}.nc ${diagensdir}pmean${ftype}.nc

  let jday0=$jday_ini-1

  echo "Computing RMS misift for satellite: $sat"

  # Loop on day
  let day=1
  while [ $day -le ${jday_window} ] ; do
    day2=`echo $day | awk '{printf("%02d", $1)}'`
    let jday=$jday0+$day

    echo "Computing RMS misift for Julian day: $jday"

    obsname="Obs_daily/obs${slatype}_${jday}"

    # Comute RMS misfit to each ensemble member
    if [ $allmembers = "TRUE" ] ; then

      let member=1
      while [ $member -le ${upd_size} ] ; do
        membertag4=`echo $member | awk '{printf("%04d", $1)}'`
  
        echo "Computing RMS misift for member: $membertag4"
  
        sesam -mode diff -inobs ${obsname}#.cobs \
                         -configobs ${obsname}#.cobs \
                         -diffobsref ${diagensdir}.nc.bas/vct#${membertag4}.nc \
		         -inpartvar rmspart#.nc -incfg algodiff.cfg \
              >> ${diagensdir}_rmsobs${slatype}_${membertag4}.txt
      
        let member=$member+1
      done

    fi

    # Compute RMS misfit to ensemble mean
    echo "Computing RMS misift for ensemble mean"

    sesam -mode diff -inobs ${obsname}#.cobs \
                     -configobs ${obsname}#.cobs \
                     -diffobsref ${diagensdir}mean#.nc \
		     -inpartvar rmspart#.nc -incfg algodiff.cfg \
          >> ${diagensdir}_rmsobs${slatype}_mean.txt

    # Compute RMS misfit to persistence of ensemble mean
    echo "Computing RMS misift for persistence of ensemble mean"

    sesam -mode diff -inobs ${obsname}#.cobs \
                     -configobs ${obsname}#.cobs \
                     -diffobsref ${diagensdir}pmean#.nc \
		     -inpartvar rmspart#.nc -incfg algodiff.cfg \
          >> ${diagensdir}_rmsobs${slatype}_pmean.txt

    let day=$day+1
  done

