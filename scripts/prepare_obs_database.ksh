#!/bin/ksh

. ./param.ksh
. ./util.ksh

cd $wdir

varlist="sla${slatype},mdt"

if [ ! -d Obs_dbs ] ; then
  mkdir Obs_dbs
fi

# Loop on satellite missions
for sat in $satlist ; do

if [ $sat = "h2a" ] ; then
  satnam="h2ag"
else
  satnam="$sat"
fi

sat_tag="_${sat}_"
tarfile="$datadir/${satnam}.tar"
obsfile="Obs_dbs/obs${slatype}${sat_tag}${jday_ini}.ncdbs"

let jday0=$jday_ini-1

# Loop on days
let day=1
while [ $day -le ${jday_window} ] ; do
  day2=`echo $day | awk '{printf("%02d", $1)}'`
  let jday=$jday0+$day

  # Get Julian day from date
  #jday2date $jday
  #date=$ts_date
  echo $jday > jday.cfg
  date=`sesam -mode oper -incfg jday.cfg -outvar dummy.cpak -typeoper jday2date|grep DATE|cut -c6-`
  rm -f jday.cfg

  echo "Date: $date"
  ifile="./${satnam}/dt_global${sat_tag}phy_l3_${date}_20210603.nc"
  ofile="tmpdbs${day2}.nc"

  # Get data file from archive
  tar -xvf $tarfile $ifile

  # Extract observations from datafile
  if [ -f $ifile ] ; then
    rm -f tmpdbs.nc
    ncks --mk_rec_dmn time \
         -v latitude,longitude,time,${varlist} ${ifile} tmpdbs.nc
    rm -f $ofile
    ncap2 -O -s "adt=sla${slatype}+mdt;latitude=latitude*1.;longitude=longitude*1.-360." tmpdbs.nc ${ofile}
    rm -f tmpdbs.nc
  fi

  rm -f $ifile

  let day=$day+1
done

# Concatenate days in one single file
rm -f ${obsfile}
ncrcat tmpdbs??.nc ${obsfile} 2> /dev/null
rm -f tmpdbs??.nc

rmdir ${satnam}

done
