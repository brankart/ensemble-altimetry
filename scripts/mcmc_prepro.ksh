#!/bin/ksh
#

. ./param.ksh

cd $wdir

obsname="Obs_${scenario_used}/obs${slatype}"

# Compute observation equivalent of multiscale input ensemble

idir1="RED1ENS${ens_size}.cpak.bas"
idir2="RED2ENS${ens_size}.cpak.bas"
idir1obs="RED1ENS${ens_size}.cobs.bas"
idir2obs="RED2ENS${ens_size}.cobs.bas"

rm -fr $idir1obs ; mkdir $idir1obs
sesam -mode intf -inobas $idir1 -outobas $idir1obs -configobs ${obsname}#.cobs
rm -fr $idir2obs ; mkdir $idir2obs
sesam -mode intf -inobas $idir2 -outobas $idir2obs -configobs ${obsname}#.cobs

# Center-reduce observation
rm -f tmpred*.cobs
sesam -mode oper -inobs ${obsname}#.cobs -configobs ${obsname}#.cobs -inobsref priormean#.nc -outobs tmpred#.cobs -typeoper -
rm -f redobs*.cobs
sesam -mode oper -inobs tmpred#.cobs -configobs ${obsname}#.cobs -inobsref priorstd#.nc -outobs redobs#.cobs -typeoper /
rm -f tmpred*.cobs

# Reduce observation error
rm -f redobs_oestd*.cobs
sesam -mode oper -inobs ${obsname}_oestd#.cobs -configobs ${obsname}#.cobs -inobsref priorstd#.nc -outobs redobs_oestd#.cobs -typeoper /
