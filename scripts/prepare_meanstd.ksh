#!/bin/ksh
#

. ./param.ksh
. ./util.ksh

cd $wdir

gloensdir="GLOENS${ens_size}"

# Compute ensemble mean and standard deviation
rm -f list.cfg
echo $ens_size > list.cfg
let member=1
while [ $member -le ${ens_size} ] ; do
  membertag4=`echo $member | awk '{printf("%04d", $1)}'`
  ifile="${gloensdir}.nc.bas/vct#${membertag4}.nc"
  echo $ifile >> list.cfg
  let member=$member+1
done

rm -f glopriormean.cpak glopriorstd.cpak
sesam -mode oper -incfg list.cfg -outvar glopriorstd.cpak -typeoper std -config sesamlist_glo
sesam -mode oper -incfg list.cfg -outvar glopriormean.cpak -typeoper mean -config sesamlist_glo
rm -f list.cfg

