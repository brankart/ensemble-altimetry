#!/bin/ksh

. ./util.ksh

cd $wdir

refnam="gloref" # ref or gloref

ref_file="${refnam}_aviso_.nc"
refstd_file="${refnam}std_aviso_.nc"

var=${var_duacs}
varstd=${std_duacs}

let jday0=$jday_ini-1

# Loop on time to extract daily maps from database
let day=1
while [ $day -le ${jday_window} ] ; do
    day2=`echo $day | awk '{printf("%02d", $1)}'`
    let jday=$jday0+$day

    # Compute date from Julian day
    echo $jday > jday.cfg
    date=`sesam -mode oper -incfg jday.cfg -outvar dummy.cpak -typeoper jday2date|grep DATE|cut -c6-`
    rm -f jday.cfg

    # Name of daily input and output files
    echo "Date: $date"
    ifile="${datadir_map}/dt_global_allsat_phy_l4_${date}_20210726.nc"
    ofile="ref_aviso_d${day2}.nc"
    ofilestd="refstd_aviso_d${day2}.nc"

    # Extract subdomain from global files
    rm -f tmpref.nc tmprefstd.nc
    ncks --mk_rec_dmn time -d longitude,${imin},${imax} -d latitude,${jmin},${jmax} \
         -v latitude,longitude,time,${var} ${ifile} tmpref.nc
    ncks --mk_rec_dmn time -d longitude,${imin},${imax} -d latitude,${jmin},${jmax} \
         -v latitude,longitude,time,${varstd} ${ifile} tmprefstd.nc
    ncrename -v ${varstd},${var} tmprefstd.nc

    # Transform to real values (using scale in file)
    rm -f $ofile ${ofilestd}
    ncap2 -O -s "$var=$var*1." tmpref.nc ${ofile}
    ncap2 -O -s "$var=$var*1." tmprefstd.nc ${ofilestd}
    rm -f tmpref.nc tmprefstd.nc

    let day=$day+1
done

# Concatenate daily files into a single file
rm -f ${ref_file} ${refstd_file}
ncrcat ref_aviso_d??.nc ${ref_file}
ncrcat refstd_aviso_d??.nc ${refstd_file}
rm -f ref_aviso_d??.nc refstd_aviso_d??.nc

