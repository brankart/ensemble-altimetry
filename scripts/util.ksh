#!/bin/ksh

. ./param.ksh

# Extend state vector
# -------------------
#
function extend_statevector {

  es_ifile=$1
  es_ofile=$2

  es_var="adt"
  es_listvarext="u v omega xi"

  rm -f tmp1ext${ftype}.nc
  sesam -mode intf -invar ${es_ifile} -outvar tmp1ext#.nc  -config sesamlist

  for varext in $es_listvarext ; do
    ncap2 -O -s "$varext=${es_var}*0." tmp1ext${ftype}.nc tmp2ext${ftype}.nc
    rm -f tmp1ext${ftype}.nc
    mv tmp2ext${ftype}.nc tmp1ext${ftype}.nc
  done

  sesam -mode intf -invar tmp1ext#.nc -outvar ${es_ofile} -config sesamlist_ext

  rm -f tmp1ext${ftype}.nc

}

# Compute persistence
# -------------------
#
function compute_persistence {

  cp_ifile=$1
  cp_ofile=$2

  #cp_listvar="adt"
  cp_listvar="adt u v omega xi"

  cp $1 tmp1ext${ftype}.nc
  for var in $cp_listvar ; do

    iday=31
    while [ $iday -le 59 ] ; do

      rm -f tmp2ext${ftype}.nc
      ncap2 -O -s "$var($iday,:,:)=$var(30,:,:)" tmp1ext${ftype}.nc tmp2ext${ftype}.nc
      rm -f tmp1ext${ftype}.nc
      mv tmp2ext${ftype}.nc tmp1ext${ftype}.nc

      let iday=$iday+1
    done

  done

  mv tmp1ext${ftype}.nc $2

}

# Get number of days in a year
# ----------------------------
#
function get_daysinyear {

   gdy_year=$1

   leap_year=$( echo "scale=0;${gdy_year}%4" | bc -l )

   if [ ${leap_year} -eq 0 ] ; then
      daysinyear='366'
   else
      daysinyear='365'
   fi

}

# Get number of days in a month
# -----------------------------
#
function get_daysinmonth {

   gdm_month=$1
   gdm_year=$2

   leap_year=$( echo "scale=0;${gdm_year}%4" | bc -l )

   case ${gdm_month} in
    1 ) daysinmonth=31 ;;
    2 ) daysinmonth=28 ;;
    3 ) daysinmonth=31 ;;
    4 ) daysinmonth=30 ;;
    5 ) daysinmonth=31 ;;
    6 ) daysinmonth=30 ;;
    7 ) daysinmonth=31 ;;
    8 ) daysinmonth=31 ;;
    9 ) daysinmonth=30 ;;
    10 ) daysinmonth=31 ;;
    11 ) daysinmonth=30 ;;
    12 ) daysinmonth=31 ;;
   esac

   if [ ${gdm_month} = '2' ] ; then
      if [ ${leap_year} -eq 0 ] ; then
         daysinmonth=29
      fi
   fi

}

# Convert Julian day to date
# --------------------------
#
function jday2date {

   ts_jday=$1

   let ts_year=1950
   let ts_month=1
   let ts_day=1
   let ts_jday0=-1

   while [ $ts_jday0 -lt $ts_jday ]
   do
     get_daysinyear $ts_year
     let ts_year=$ts_year+1
     let ts_jday0=$ts_jday0+$daysinyear
   done
   let ts_year=$ts_year-1
   let ts_jday0=$ts_jday0-$daysinyear

   ts_dayinyear=$( echo "$ts_jday - $ts_jday0" | bc -l )

   while [ $ts_jday0 -lt $ts_jday ]
   do
     get_daysinmonth $ts_month $ts_year
     let ts_month=$ts_month+1
     let ts_jday0=$ts_jday0+$daysinmonth
   done
   let ts_month=$ts_month-1
   let ts_jday0=$ts_jday0-$daysinmonth

   ts_day=$( echo "$ts_jday - $ts_jday0" | bc -l )

   ts_day=`echo $ts_day | awk '{printf("%02d", $1)}'`
   ts_month=`echo $ts_month | awk '{printf("%02d", $1)}'`
   ts_year=`echo $ts_year | awk '{printf("%04d", $1)}'`

   ts_date="${ts_year}${ts_month}${ts_day}"

}

