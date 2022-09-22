#!/bin/ksh
#

. ./param.ksh
. ./util.ksh

cd $wdir

smpensdir="${expt}SMPENS${upd_size}"

# Inverse center-reduced sample
rm -fr $smpensdir.nc.bas ; mkdir $smpensdir.nc.bas

let member=1
while [ $member -le ${upd_size} ] ; do
  membertag4=`echo $member | awk '{printf("%04d", $1)}'`
  ifile="RED${smpensdir}.cpak.bas/vct${membertag4}.cpak"
  ofile="${smpensdir}.nc.bas/vct#${membertag4}.nc"

  rm -f tmpred1.cpak tmpred2.cpak
  sesam -mode oper -invar $ifile -invarref priorstd.cpak -outvar tmpred1.cpak -typeoper x
  sesam -mode oper -invar tmpred1.cpak -invarref priormean.cpak -outvar tmpred2.cpak -typeoper +
  extend_statevector tmpred2.cpak $ofile | grep Timestep > ${smpensdir}_rmsmod_${membertag4}.txt
  rm -f tmpred1.cpak tmpred2.cpak

  let member=$member+1
done

# Compute sample mean and standard deviation
rm -f list.cfg
echo $upd_size > list.cfg
let member=1
while [ $member -le ${upd_size} ] ; do
  membertag4=`echo $member | awk '{printf("%04d", $1)}'`
  ifile="${smpensdir}.nc.bas/vct#${membertag4}.nc"
  echo $ifile >> list.cfg
  let member=$member+1
done

rm -f ${smpensdir}std*.nc
rm -f ${smpensdir}mean*.nc
sesam -mode oper -incfg list.cfg -outvar ${smpensdir}std#.nc -typeoper std -config sesamlist_ext
sesam -mode oper -incfg list.cfg -outvar ${smpensdir}mean#.nc -typeoper mean -config sesamlist_ext
rm -f list.cfg

