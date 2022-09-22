#!/bin/ksh

. ./param.ksh
. ./util.ksh

cd $wdir

# Define structure of mask file
cat > mask.cdl <<EOF
netcdf mask {  // mask netCDF specification in CDL

  dimensions:
       longitude = ${nlon}, latitude = ${nlat}, time = ${ntim} ;

  variables:
       float   latitude(latitude), longitude(longitude), time(time);
       double  adt(time,latitude,longitude);

       // variable attributes
       latitude:long_name = "Latitude";
       latitude:units = "degrees_north";
       longitude:long_name = "Longitude";
       longitude:units = "degrees_east";
       time:long_name = "Time";
       time:units = "days since 1950-01-01 00:00:00";
       adt:long_name = "Absolute dynamic topography";
       adt:units = "m";
       adt:_FillValue = -9999.;

  data:
       latitude   = 0, 0;
       longitude  = 0, 0;
       time       = 0, 0;
}
EOF

# Create mask file
ncgen -o mask.nc mask.cdl

# Fill dimension variables
ncap2 -A -s "longitude=array($lon0,$dlon,\$longitude)" mask.nc
ncap2 -A -s "latitude=array($lat0,$dlat,\$latitude)" mask.nc
ncap2 -A -s "time=array($tim0,$dtim,\$time)" mask.nc

# Get sesamlist files
cp -p ${sdir}/sesamlist* .

# Zero file
rm -f zero.cpak
cp mask.nc void${ftype}.nc
sesam -mode oper -invar void#.nc -outvar zero.cpak -typeoper cst_0.0
rm -f void${ftype}.nc

# Generate extended mask with additional variables

cp mask.nc mask_ext.nc
ncap2 -A -s "u=adt*1." mask_ext.nc
ncap2 -A -s "v=adt*1." mask_ext.nc
ncap2 -A -s "omega=adt*1." mask_ext.nc
ncap2 -A -s "xi=adt*1." mask_ext.nc
