#!/usr/bin/env bash

source ../config

## package specific variables
name=${HEPSW_FASTJET_NAME}
package_name=fastjet-${HEPSW_FASTJET_VERSION}

InstallDir=${HEPSW_FASTJET_DIR}

## download
cd ${WORKING_DIR}
wget -O- http://fastjet.fr/repo/${package_name}.tar.gz | \
  tar zx || exit 1
cd ${package_name}/

## install
./configure --prefix=${InstallDir} --enable-allplugins || exit 2
make -j${NUM_CORES} || exit 2
make check || exit 3
make install || exit 3
rm -rf ${WORKING_DIR}/${package_name}

## environment
cd ${BASE_DIR}
cp ../TEMPLATEenv.sh ${InstallDir}/${name}env.sh
sed -i -e "s TEMPLATE_PREFIX ${InstallDir} g" ${InstallDir}/${name}env.sh
sed -i -e "s/TEMPLATE/${name}/g" ${InstallDir}/${name}env.sh
sed -i -e "s/#.export.PATH/export PATH/g" ${InstallDir}/${name}env.sh
sed -i -e "s/#.export.*//g" ${InstallDir}/${name}env.sh
