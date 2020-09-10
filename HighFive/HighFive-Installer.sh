#!/usr/bin/env bash

source ../config

## package specific variables
name=${HEPSW_HIGHFIVE_NAME}
package_name=v${HEPSW_HIGHFIVE_VERSION}
dependencies=${HEPSW_HIGHFIVE_DEPENDENCIES[@]}

InstallDir=${HEPSW_HIGHFIVE_DIR}

# general setup & environment
source ../init.sh

## download
cd ${WORKING_DIR}
wget -O- https://github.com/BlueBrain/HighFive/archive/${package_name}.tar.gz | \
  tar xz
cd ${name}-${HEPSW_HIGHFIVE_VERSION}
mkdir build
cd build

## install
${CMAKE} -DCMAKE_INSTALL_PREFIX=${InstallDir} -DBOOST_ROOT=${HEPSW_BOOST_DIR} ..
make -j${NUM_CORES}
ctest -j ${NUM_CORES}
make install
rm -rf ${WORKING_DIR}/${name}-${HEPSW_HIGHFIVE_VERSION}

## environment
cp ${BASE_DIR}/TEMPLATEenv.sh ${InstallDir}/${name}env.sh
sed -i -e "s/.*LIBRARYDIR.*//g" ${InstallDir}/${name}env.sh
sed -i -e "s/#.*//g" ${InstallDir}/${name}env.sh
sed -i -e "s TEMPLATE_PREFIX ${InstallDir} g" ${InstallDir}/${name}env.sh
sed -i -e "s/TEMPLATE/${name}/g" ${InstallDir}/${name}env.sh
printf 'export CMAKE_PREFIX_PATH=${'${name}'_ROOT_DIR}${CMAKE_PREFIX_PATH:+:${CMAKE_PREFIX_PATH}}\n' \
  >> ${InstallDir}/${name}env.sh
