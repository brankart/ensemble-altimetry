#!/bin/ksh
#
. ./param.ksh

cd $wdir

if [ ! -d Obs_${scenario} ] ; then
  mkdir Obs_${scenario}
fi

obsname="Obs_${scenario}/obs${slatype}"

# Prepare sesamlist with time bounds for extracting partial observations
cp sesamlist sesamlist_obs
let iobs=1
while [ $iobs -le ${nobs} ] ; do
   echo "OBS_TIM_MAX-1:${iobs}=$jday_last" >> sesamlist_obs
   let iobs=$iobs+1
done

# Loop on satellite missions
for sat in $satlistobs ; do

  sat_tag="_${sat}_"

  dbsfile="Obs_dbs/obs${slatype}${sat_tag}${jday_ini}.ncdbs"

  # Generate observation file
  rm -f ${obsname}${sat_tag}.cobs
  sesam -mode obsv -indbs ${dbsfile} -outobs ${obsname}#.cobs -affectobs $sat_tag -config sesamlist_obs

done

rm -f sesamlist_obs

# Generate observation error std file
rm -f ${obsname}_oestd*.cobs
sesam -mode oper -inobs ${obsname}#.cobs -outobs ${obsname}_oestd#.cobs \
                 -configobs ${obsname}#.cobs -typeoper cst_$oestd

