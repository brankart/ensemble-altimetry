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

# Ensemble to verify
diagensdir="${expt}SMPENS${upd_size}"

# Observations used as verification data
obsname="Obs_${scenario_verif}/obs${slatype}"

rm -fr PERT${diagensdir}.cobs.bas ; mkdir PERT${diagensdir}.cobs.bas

# Perturb input ensemble with observation error
let member=1
while [ $member -le ${upd_size} ] ; do
  membertag4=`echo $member | awk '{printf("%04d", $1)}'`

  echo "Add perturbation to member: $membertag4"

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

# Compute rank histogram
rm -f tmprank*.cobs
sesam  -mode rank -inobs ${obsname}#.cobs -configobs ${obsname}#.cobs \
       -inobasref PERT${diagensdir}.cobs.bas -outobs tmprank#.cobs > ${diagensdir}_rank_histogram.txt
rm -f tmprank*.cobs

# Compute crps score
sesam -mode scor -inobas PERT${diagensdir}.cobs.bas -inobs ${obsname}#.cobs \
      -configobs ${obsname}#.cobs -typeoper crps -inpartvar rmspart#.nc > ${diagensdir}_crps.txt

# Compute rcrv score
sesam -mode scor -inobas PERT${diagensdir}.cobs.bas -inobs ${obsname}#.cobs \
      -configobs ${obsname}#.cobs -typeoper rcrv -inpartvar rmspart#.nc > ${diagensdir}_rcrv.txt

rm -fr PERT${diagensdir}.cobs.bas
