#!/bin/bash
#SBATCH --job-name=spectrum
#SBATCH -e spectrum.e%j
#SBATCH -o spectrum.o%j
#SBATCH --ntasks=160
#SBATCH --ntasks-per-node=40
#SBATCH --time=02:00:00            # Temps d’exécution maximum demande (HH:MM:SS)
#SBATCH -A egi@cpu
#SBATCH --hint=nomultithread
#SBATCH --qos=qos_cpu-dev

. ./param.ksh

cd $wdir

spcdir="SPCENS${ens_size}"
ensdir="ENS${ens_size}"

if [ ! -d ${ensdir}.nc.bas ] ; then
  mkdir ${ensdir}.nc.bas
fi

let member=1
while [ $member -le ${ens_size} ] ; do
  membertag4=`echo $member | awk '{printf("%04d", $1)}'`
  ifile="${spcdir}.cdf.bas/vct${membertag4}.cdf"
  ofile="${ensdir}.nc.bas/vct#${membertag4}.nc"

  rm -f $ofile
  srun sesam -mode spct -invar $ifile -outvar $ofile -typeoper -_${prior_lmax} -config sesamlist

  let member=$member+1
done

