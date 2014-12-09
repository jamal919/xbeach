#!/bin/bash
. /etc/profile
export MODULEPATH=$MODULEPATH:/opt/modules

module load gcc/4.9.2
module load hdf5/1.8.14_gcc_4.9.2
module load netcdf/v4.3.2_v4.4.0_gcc_4.9.2
module load openmpi/1.8.1_gcc_4.9.2

./autogen.sh

mkdir -p /opt/teamcity/work/XBeach_unix/install

FCFLAGS="-mtune=corei7-avx -funroll-loops --param max-unroll-times=4 -O3 -ffast-math" ./configure  --with-netcdf --with-mpi --prefix="/opt/teamcity/work/XBeach_unix/install"

make
make install