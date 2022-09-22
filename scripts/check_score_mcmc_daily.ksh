#!/bin/bash
#SBATCH --job-name=checkmcmc
#SBATCH -e checkmcmc.e%j
#SBATCH -o checkmcmc.o%j
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=02:00:00            # Temps d’exécution maximum demande (HH:MM:SS)
#SBATCH --exclusive
#SBATCH -A egi@cpu
#SBATCH --hint=nomultithread
#SBATCH --qos=qos_cpu-dev

. ./param.ksh
. ./util.ksh

cd $wdir

# Ensemble to verify
diagensdir="${expt}SMPENS${upd_size}"
rm -f ${diagensdir}_crps_daily.txt

let jday0=$jday_ini-1

# Loop on day
let day=1
while [ $day -lt ${jday_window} ] ; do
  day2=`echo $day | awk '{printf("%02d", $1)}'`
  let jday=$jday0+$day

  # Observations used as verification data
  obsname_daily="Obs_daily/obs${slatype}_${jday}"
  obsname="indepobs${slatype}"

  # Use independent observations only
  for sat in c2 alg ; do
    cp -f ${obsname_daily}_${sat}_.cobs ${obsname}_${sat}_.cobs
  done

  rm -fr PERT${diagensdir}.cobs.bas ; mkdir PERT${diagensdir}.cobs.bas

  # Perturb input ensemble with observation error
  let member=1
  while [ $member -le ${upd_size} ] ; do
    membertag4=`echo $member | awk '{printf("%04d", $1)}'`

    echo "Add perturbation to member: $membertag4"

    # Generate observation error std file
    rm -f ${obsname}_oestd*.cobs
    sesam -mode oper -inobs ${obsname}#.cobs -outobs ${obsname}_oestd#.cobs \
                     -configobs ${obsname}#.cobs -typeoper cst_$oestd
    # Generate zero mean Gaussian noise 
    rm -fr tmpgnoise*.cobs
    sesam -mode oper -inobs ${obsname}_oestd#.cobs -configobs ${obsname}#.cobs \
	             -outobs tmpgnoise#.cobs -typeoper gnoise_$oestd
    # Add noise to ensemble member
    sesam -mode oper -inobs tmpgnoise#.cobs -configobs ${obsname}#.cobs -typeoper + \
	             -inobsref ${diagensdir}.nc.bas/vct#${membertag4}.nc \
	             -outobs PERT${diagensdir}.cobs.bas/vct#${membertag4}.cobs
    rm -fr tmpgnoise*.cobs
        
    let member=$member+1
  done

  # Compute crps score
  sesam -mode scor -inobas PERT${diagensdir}.cobs.bas -inobs ${obsname}#.cobs \
        -configobs ${obsname}#.cobs -typeoper crps -inpartvar rmspart#.nc > tmp_crps_daily.txt
  valcrps=̀`cat tmp_crps_daily.txt | head -4 | tail -1`
  echo "$day2 $valcrps" >> ${diagensdir}_crps_daily.txt
  rm tmp_crps_daily.txt

  rm -fr PERT${diagensdir}.cobs.bas

  let day=$day+1
done
