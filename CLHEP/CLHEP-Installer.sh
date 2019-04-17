#!/usr/bin/env bash

source ../config

## package specific variables
name=${HEPSW_CLHEP_NAME}
package_name=clhep-${HEPSW_CLHEP_VERSION}

InstallDir=${HEPSW_CLHEP_DIR}

## download
cd ${WORKING_DIR}
wget -O- http://proj-clhep.web.cern.ch/proj-clhep/DISTRIBUTION/tarFiles/${package_name}.tgz | \
  tar xz || exit 1
cd ${HEPSW_CLHEP_VERSION}
mkdir build
cd build

## install
cmake3 -DCMAKE_INSTALL_PREFIX=${InstallDir} ../CLHEP || exit 2
make -j${NUM_CORES} || exit 2
make test || exit 3
make install || exit 3
rm -rf ${WORKING_DIR}/${HEPSW_CLHEP_VERSION}

## environment
cd ${BASE_DIR}
cp ../TEMPLATEenv.sh ${InstallDir}/${name}env.sh
sed -i -e "s TEMPLATE_PREFIX ${InstallDir} g" ${InstallDir}/${name}env.sh
sed -i -e "s/TEMPLATE/${name}/g" ${InstallDir}/${name}env.sh
sed -i -e "s/#.export.PATH/export PATH/g" ${InstallDir}/${name}env.sh
sed -i -e "s/#.export.PKG_CONFIG_PATH/export PKG_CONFIG_PATH/g" ${InstallDir}/${name}env.sh
