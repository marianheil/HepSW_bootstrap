#!/usr/bin/env bash

source ../config

## package specific variables
name=${HEPSW_HEPMC3_NAME}
package_name=${name}-${HEPSW_HEPMC3_VERSION}
# package_name=hepmc${HEPSW_HEPMC3_VERSION} # old style < 3.1

InstallDir=${HEPSW_HEPMC3_DIR}

## download
cd ${WORKING_DIR}
# wget -O- http://hepmc.web.cern.ch/hepmc/releases/${package_name}.tgz | \ # old style < 3.1
wget -O- http://hepmc.web.cern.ch/hepmc/releases/${package_name}.tar.gz | \
  tar xz || exit 1
cd ${package_name}
mkdir build
cd build

## install
cmake3 -DCMAKE_INSTALL_PREFIX=${InstallDir} .. || exit 2
make -j${NUM_CORES} || exit 2
make install || exit 3
rm -rf ${WORKING_DIR}/${package_name}

## environment
cd ${BASE_DIR}
cp ../TEMPLATEenv.sh ${InstallDir}/${name}env.sh
sed -i -e "s TEMPLATE_PREFIX ${InstallDir} g" ${InstallDir}/${name}env.sh
sed -i -e "s/TEMPLATE/${name}/g" ${InstallDir}/${name}env.sh
sed -i -e "s /lib /lib64 g" ${InstallDir}/${name}env.sh
sed -i -e "s/#.export.PATH/export PATH/g" ${InstallDir}/${name}env.sh
sed -i -e "s/#.export.*//g" ${InstallDir}/${name}env.sh
