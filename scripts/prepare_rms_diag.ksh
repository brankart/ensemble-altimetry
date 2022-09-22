#!/bin/ksh
#

. ./param.ksh

cd $wdir

# File to generate the diagnostic partition
cat > mkpart.cfg <<EOF
ADT   'mkpart.cnt' 11
EOF

# File defining the diagnostic partition
cat > mkpart.cnt <<EOF
1 5 1
# Inside
5
$diagimin $diagjmin
$diagimax $diagjmin
$diagimax $diagjmax
$diagimin $diagjmax
$diagimin $diagjmin
1
1 0 1
EOF

cat > algodiff.cfg <<EOF
# Configuration file for the computation of RMS differences
1 1
RMS_domain
1
1
EOF

# Generate partition for the computation of RMS differences

rm -f rmspart${ftype}.nc
sesam -mode zone -incfg mkpart.cfg -outpartvar rmspart#.nc
