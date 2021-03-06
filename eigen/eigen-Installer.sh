#!/usr/bin/env bash

source ../config

## package specific variables
name=${HEPSW_EIGEN_NAME}
package_name=${HEPSW_EIGEN_VERSION}
dependencies=${HEPSW_EIGEN_DEPENDENCIES[@]}

InstallDir=${HEPSW_EIGEN_DIR}

# general setup & environment
source ../init.sh

## download
cd ${WORKING_DIR}
wget -O- http://bitbucket.org/eigen/eigen/get/${package_name}.tar.gz | \
 tar xz
cd ${name}-${name}-* # eigen has a hash at the end ...
mkdir build
cd build

## install
${CMAKE} -DCMAKE_INSTALL_PREFIX=${InstallDir} ..
make -j${NUM_CORES} install
rm -rf ${WORKING_DIR}/${package_name}

## environment
cp ${BASE_DIR}/TEMPLATEenv.sh ${InstallDir}/${name}env.sh
sed -i -e "s/.*TEMPLATE_LIBRARYDIR=.*//g" ${InstallDir}/${name}env.sh
sed -i -e "s/.*LD_LIBRARY_PATH.*//g" ${InstallDir}/${name}env.sh
sed -i -e 's ${TEMPLATE_LIBRARYDIR} ${TEMPLATE_ROOT_DIR}/share g' ${InstallDir}/${name}env.sh
sed -i -e "s TEMPLATE_PREFIX ${InstallDir} g" ${InstallDir}/${name}env.sh
sed -i -e "s/TEMPLATE/${name}/g" ${InstallDir}/${name}env.sh
sed -i -e "s/#.export.PKG_CONFIG_PATH/export PKG_CONFIG_PATH/g" ${InstallDir}/${name}env.sh
printf 'export CMAKE_PREFIX_PATH='$InstallDir'/share:${CMAKE_PREFIX_PATH:+:${CMAKE_PREFIX_PATH}}\n' >> ${InstallDir}/${name}env.sh
sed -i -e "s/#.export.*//g" ${InstallDir}/${name}env.sh
