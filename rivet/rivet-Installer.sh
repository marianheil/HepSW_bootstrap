#!/usr/bin/env bash

source ../config

## package specific variables
name=${HEPSW_RIVET_NAME}
package_name=${name^}-${HEPSW_RIVET_VERSION}
dependencies=${HEPSW_RIVET_DEPENDENCIES[@]}

InstallDir=${HEPSW_RIVET_DIR}

# general setup & environment
source ../init.sh

## download
cd ${WORKING_DIR}
wget -O- https://rivet.hepforge.org/downloads/?f=${package_name}.tar.gz | tar xz
cd ${package_name}


## install
if [[ " ${dependencies[@]} " =~ " HEPMC2 " ]]; then
  echo "Using HepMC2"
  hepmc_flag="--with-hepmc=${HEPSW_HEPMC2_DIR}"
else
  echo "Using HepMC3"
  hepmc_flag="--with-hepmc3=${HEPSW_HEPMC3_DIR}"
fi

./configure --prefix=${InstallDir} \
  --with-yoda=${HEPSW_YODA_DIR} \
  --with-fastjet=${HEPSW_FASTJET_DIR} \
  ${hepmc_flag} || exit 2

make -j${NUM_CORES} || exit 3
make install || exit 3
cp rivetenv.sh ${InstallDir} || exit 4 # not added automaticaly in Rivet 3

rm -rf ${WORKING_DIR}/${package_name}
