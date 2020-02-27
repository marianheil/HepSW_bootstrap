#!/usr/bin/env bash

source ../config

## package specific variables
name=${HEPSW_RECOLA_NAME}
package_name=${name}-collier-${HEPSW_RECOLA_VERSION}
dependencies=${HEPSW_RECOLA_DEPENDENCIES[@]}

InstallDir=${HEPSW_RECOLA_DIR}

# general setup & environment
source ../init.sh

## download
cd ${WORKING_DIR}
wget -O- https://recola.hepforge.org/downloads/?f=${package_name}.tar.gz | \
  tar xz || exit 2
cd ${package_name}
mkdir build
cd build

## install
cmake3 -DCMAKE_INSTALL_PREFIX=${InstallDir} .. || exit 3
## in recola2 add:
# -Dmodel=SM
make || exit 3 # -j${NUM_CORES} doesn't work for some unknown reason (tested 1.4.0)
make install || exit 4
rm -rf ${WORKING_DIR}/${package_name}

## environment
cp ${BASE_DIR}/TEMPLATEenv.sh ${InstallDir}/${name}env.sh
sed -i -e "s TEMPLATE_PREFIX ${InstallDir} g" ${InstallDir}/${name}env.sh
sed -i -e "s/TEMPLATE/${name}/g" ${InstallDir}/${name}env.sh
sed -i -e "s/#.export.*//g" ${InstallDir}/${name}env.sh
