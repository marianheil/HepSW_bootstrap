#!/usr/bin/env bash

source ../config

## package specific variables
name=${HEPSW_HEPMC3_NAME}
package_name=${name}-${HEPSW_HEPMC3_VERSION}
# package_name=hepmc${HEPSW_HEPMC3_VERSION} # old style < 3.1

InstallDir=${HEPSW_HEPMC3_DIR}

## dependences
mkdir -p ${InstallDir}
# root
printf "## ${HEPSW_ROOT_NAME} ${HEPSW_ROOT_VERSION}\n" \
  >> ${InstallDir}/${name}dependences.sh
printf "source ${HEPSW_ROOT_DIR}/${HEPSW_ROOT_NAME}env.sh\n" \
  >> ${InstallDir}/${name}dependences.sh

source ${InstallDir}/${name}dependences.sh || exit 1

## download
cd ${WORKING_DIR}
# wget -O- http://hepmc.web.cern.ch/hepmc/releases/${package_name}.tgz | \ # old style < 3.1
wget -O- http://hepmc.web.cern.ch/hepmc/releases/${package_name}.tar.gz | \
  tar xz || exit 2
cd ${package_name}
mkdir build
cd build

## install
cmake3 -DCMAKE_INSTALL_PREFIX=${InstallDir} .. || exit 3
make -j${NUM_CORES} || exit 3
make install || exit 4
rm -rf ${WORKING_DIR}/${package_name}

## environment
cd ${BASE_DIR}
cp ../TEMPLATEenv.sh ${InstallDir}/${name}env.sh
sed -i -e "s TEMPLATE_PREFIX ${InstallDir} g" ${InstallDir}/${name}env.sh
sed -i -e "s/TEMPLATE/${name}/g" ${InstallDir}/${name}env.sh
sed -i -e "s /lib /lib64 g" ${InstallDir}/${name}env.sh
sed -i -e "s/#.export.PATH/export PATH/g" ${InstallDir}/${name}env.sh
sed -i -e "s/#.export.*//g" ${InstallDir}/${name}env.sh
