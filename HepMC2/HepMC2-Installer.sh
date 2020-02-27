#!/usr/bin/env bash

source ../config

## package specific variables
name=${HEPSW_HEPMC2_NAME}
package_name=hepmc${HEPSW_HEPMC2_VERSION}

InstallDir=${HEPSW_HEPMC2_DIR}

# general setup & environment
source ../init.sh

## download
cd ${WORKING_DIR}
wget -O- http://hepmc.web.cern.ch/hepmc/releases/${package_name}.tgz | \
  tar zx || exit 1
mkdir ${name}-build
cd ${name}-build

## install
cmake3 -DCMAKE_INSTALL_PREFIX=${InstallDir} -Dmomentum:STRING=GEV \
      -Dlength:STRING=MM ../${package_name} || exit 2
make -j${NUM_CORES} || exit 2
make install || exit 3
rm -rf ${WORKING_DIR}/${package_name}
rm -rf ${WORKING_DIR}/${name}-build

## environment
cp ${BASE_DIR}/TEMPLATEenv.sh ${InstallDir}/${name}env.sh
sed -i -e "s TEMPLATE_PREFIX ${InstallDir} g" ${InstallDir}/${name}env.sh
sed -i -e "s/TEMPLATE/${name}/g" ${InstallDir}/${name}env.sh
sed -i -e "s/#.export.*//g" ${InstallDir}/${name}env.sh
