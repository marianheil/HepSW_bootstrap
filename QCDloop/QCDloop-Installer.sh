#!/usr/bin/env bash

source ../config

## package specific variables
name=${HEPSW_QCDLOOP_NAME}
package_name=qcdloop

InstallDir=${HEPSW_QCDLOOP_DIR}

## download
cd ${WORKING_DIR}
git clone https://github.com/scarrazza/${package_name}.git || exit 1
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
sed -i -e "s/#.export.PATH/export PATH/g" ${InstallDir}/${name}env.sh
sed -i -e "s/#.export.PKG_CONFIG_PATH/export PKG_CONFIG_PATH/g" ${InstallDir}/${name}env.sh
