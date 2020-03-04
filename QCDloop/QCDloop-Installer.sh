#!/usr/bin/env bash

source ../config

## package specific variables
name=${HEPSW_QCDLOOP_NAME}
package_name=qcdloop
dependencies=${HEPSW_QCDLOOP_DEPENDENCIES[@]}

InstallDir=${HEPSW_QCDLOOP_DIR}

# general setup & environment
source ../init.sh

## download
cd ${WORKING_DIR}
git clone https://github.com/scarrazza/${package_name}.git
cd ${package_name}
mkdir build
cd build

## install
cmake3 -DCMAKE_INSTALL_PREFIX=${InstallDir} ..
make -j${NUM_CORES}
make install
rm -rf ${WORKING_DIR}/${package_name}

## environment
cp ${BASE_DIR}/TEMPLATEenv.sh ${InstallDir}/${name}env.sh
sed -i -e "s TEMPLATE_PREFIX ${InstallDir} g" ${InstallDir}/${name}env.sh
sed -i -e "s/TEMPLATE/${name}/g" ${InstallDir}/${name}env.sh
sed -i -e "s/#.export.PATH/export PATH/g" ${InstallDir}/${name}env.sh
sed -i -e "s/#.export.PKG_CONFIG_PATH/export PKG_CONFIG_PATH/g" ${InstallDir}/${name}env.sh
