#!/bin/ksh

. ./util.ksh

cd $wdir

ensnam="GLOENS" # ENS or GLOENS

odir="${ensnam}${ens_size}.nc.bas"

var=${var_duacs}

if [ ! -d ${odir} ] ; then
  mkdir ${odir}
fi

# Loop on members
let member=1
while [ $member -le ${ens_size} ] ; do
  membertag4=`echo $member | awk '{printf("%04d", $1)}'`
  let jday0=$jday_ini-1+($member-1)*$jday_lag

  echo "Member: $membertag4, Jday0: $jday0"

  # Loop on days
  let day=1
  while [ $day -le ${jday_window} ] ; do
    day2=`echo $day | awk '{printf("%02d", $1)}'`
    let jday=$jday0+$day
    jday2date $jday
    date=$ts_date

    echo "Date: $date"
    ifile="${datadir_map}/dt_global_allsat_phy_l4_${date}_20210726.nc"
    ofile="m${membertag4}d${day2}.nc"

    # Extract data from daily file
    rm -f tmp.nc
    ncks --mk_rec_dmn time -d longitude,${imin},${imax} -d latitude,${jmin},${jmax} \
         -v latitude,longitude,time,${var} ${ifile} tmp.nc
    rm -f $ofile
    ncap2 -O -s "$var=$var*1." tmp.nc ${ofile}

    let day=$day+1
  done

  # Concatenate daily files in time
  rm -f vct_aviso_${membertag4}.nc
  ncrcat m${membertag4}d??.nc vct_aviso_${membertag4}.nc
  rm -f m${membertag4}d??.nc

  mv vct_aviso_${membertag4}.nc ${odir}

  let member=$member+1
done

# 

# Prepare mask file for SESAM configuration (sesamlist_glo, with native DUACS file)
cp -pf ${odir}/vct_aviso_0001.nc mask_glo.nc

