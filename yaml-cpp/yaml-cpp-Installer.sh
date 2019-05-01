#!/usr/bin/env bash

source ../config

## package specific variables
name=${HEPSW_YAML_NAME}
package_name=yaml-cpp-${HEPSW_YAML_VERSION}

InstallDir=${HEPSW_YAML_DIR}

## download
cd ${WORKING_DIR}
wget -O- https://github.com/jbeder/yaml-cpp/archive/${package_name}.tar.gz | \
  tar xz || exit 1
cd yaml-cpp-${package_name}
mkdir build
cd build

## install
cmake3 .. -DBUILD_SHARED_LIBS=ON -DCMAKE_INSTALL_PREFIX=${InstallDir} || exit 2
make -j${NUM_CORES} || exit 2
make test || exit 3
make install || exit 3

cd ${BASE_DIR}
rm -rf ${WORKING_DIR}/yaml-cpp-${package_name}

## environment
cp ../TEMPLATEenv.sh ${InstallDir}/${name}env.sh
sed -i -e "s TEMPLATE_PREFIX ${InstallDir} g" ${InstallDir}/${name}env.sh
sed -i -e "s/TEMPLATE/${name}/g" ${InstallDir}/${name}env.sh
sed -i -e "s/#.export.PKG_CONFIG_PATH/export PKG_CONFIG_PATH/g" ${InstallDir}/${name}env.sh
sed -i -e "s/#.export.*//g" ${InstallDir}/${name}env.sh
printf 'export CMAKE_PREFIX_PATH=${'${name}'_ROOT_DIR}${CMAKE_PREFIX_PATH:+:${CMAKE_PREFIX_PATH}}\n' \
  >> ${InstallDir}/${name}env.sh
