#!/bin/bash
#SBATCH --job-name=spectrum
#SBATCH -e spectrum.e%j
#SBATCH -o spectrum.o%j
#SBATCH --ntasks=40
#SBATCH --ntasks-per-node=40
#SBATCH --time=04:00:00            # Temps d’exécution maximum demande (HH:MM:SS)
#SBATCH -A egi@cpu
#SBATCH --hint=nomultithread
###SBATCH --qos=qos_cpu-dev
#SBATCH --qos=qos_cpu-t3

cd $wdir

ensdir="GLOENS${ens_size}"
spcdir="SPCENS${ens_size}"

if [ ! -d ${spcdir}.cdf.bas ] ; then
  mkdir ${spcdir}.cdf.bas
fi

let member=1
while [ $member -le ${ens_size} ] ; do
  membertag4=`echo $member | awk '{printf("%04d", $1)}'`
  ifile="${ensdir}.nc.bas/vct#${membertag4}.nc"
  ofile="${spcdir}.cdf.bas/vct${membertag4}.cdf"

  rm -f $ofile
  srun sesam -mode spct -invar $ifile -outvar $ofile -typeoper +_${prior_lmax} -config sesamlist_glo

  let member=$member+1
done

