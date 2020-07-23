#!/usr/bin/env bash

source ../config

## package specific variables
name=${HEPSW_CLHEP_NAME}
package_name=clhep-${HEPSW_CLHEP_VERSION}
dependencies=${HEPSW_CLHEP_DEPENDENCIES[@]}

InstallDir=${HEPSW_CLHEP_DIR}

# general setup & environment
source ../init.sh

## download
cd ${WORKING_DIR}
wget -O- http://proj-clhep.web.cern.ch/proj-clhep/dist1/${package_name}.tgz | \
  tar xz
cd ${HEPSW_CLHEP_VERSION}
mkdir build
cd build

## install
cmake3 -DCMAKE_INSTALL_PREFIX=${InstallDir} ../CLHEP
make -j${NUM_CORES}
ctest -j ${NUM_CORES}
make install
rm -rf ${WORKING_DIR}/${HEPSW_CLHEP_VERSION}

## environment
cp ${BASE_DIR}/TEMPLATEenv.sh ${InstallDir}/${name}env.sh
sed -i -e "s TEMPLATE_PREFIX ${InstallDir} g" ${InstallDir}/${name}env.sh
sed -i -e "s/TEMPLATE/${name}/g" ${InstallDir}/${name}env.sh
sed -i -e "s/#.export.PATH/export PATH/g" ${InstallDir}/${name}env.sh
sed -i -e "s/#.export.PKG_CONFIG_PATH/export PKG_CONFIG_PATH/g" ${InstallDir}/${name}env.sh
