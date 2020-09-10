#!/usr/bin/env bash

source ../config

## package specific variables
name=${HEPSW_YAML_NAME}
package_name=yaml-cpp-${HEPSW_YAML_VERSION}
dependencies=${HEPSW_YAML_DEPENDENCIES[@]}

InstallDir=${HEPSW_YAML_DIR}

# general setup & environment
source ../init.sh

## download
cd ${WORKING_DIR}
wget -O- https://github.com/jbeder/yaml-cpp/archive/${package_name}.tar.gz | \
  tar xz
cd yaml-cpp-${package_name}
mkdir build
cd build

## install
${CMAKE} .. -DYAML_BUILD_SHARED_LIBS=ON -DCMAKE_INSTALL_PREFIX=${InstallDir}
make -j${NUM_CORES}
ctest -j${NUM_CORES}
make install

rm -rf ${WORKING_DIR}/yaml-cpp-${package_name}

## environment
cp ${BASE_DIR}/TEMPLATEenv.sh ${InstallDir}/${name}env.sh
sed -i -e "s TEMPLATE_PREFIX ${InstallDir} g" ${InstallDir}/${name}env.sh
sed -i -e "s/TEMPLATE/${name}/g" ${InstallDir}/${name}env.sh
sed -i -e "s/#.export.PKG_CONFIG_PATH/export PKG_CONFIG_PATH/g" ${InstallDir}/${name}env.sh
sed -i -e "s/#.export.*//g" ${InstallDir}/${name}env.sh
printf 'export CMAKE_PREFIX_PATH=${'${name}'_ROOT_DIR}${CMAKE_PREFIX_PATH:+:${CMAKE_PREFIX_PATH}}\n' \
  >> ${InstallDir}/${name}env.sh
