#!/usr/bin/env bash

source ../config
../init.sh

## package specific variables
name=${HEPSW_YAML_NAME}
package_name=yaml-cpp-${HEPSW_YAML_VERSION}
dependencies=${HEPSW_YAML_DEPENDENCIES[@]}

InstallDir=${HEPSW_YAML_DIR}

## dependencies
mkdir -p ${InstallDir}
printf "" > ${InstallDir}/${name}dependencies.sh
for dep in ${dependencies[@]}; do
  dep_name="HEPSW_${dep}_NAME"
  dep_version="HEPSW_${dep}_VERSION"
  dep_dir="HEPSW_${dep}_DIR"
  printf "## ${!dep_name} ${!dep_version}\n" \
    >> ${InstallDir}/${name}dependencies.sh
  printf "source ${!dep_dir}/${!dep_name}env.sh\n" \
    >> ${InstallDir}/${name}dependencies.sh
done

source ${InstallDir}/${name}dependencies.sh || exit 1

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

rm -rf ${WORKING_DIR}/yaml-cpp-${package_name}

## environment
cp ${BASE_DIR}/TEMPLATEenv.sh ${InstallDir}/${name}env.sh
sed -i -e "s TEMPLATE_PREFIX ${InstallDir} g" ${InstallDir}/${name}env.sh
sed -i -e "s/TEMPLATE/${name}/g" ${InstallDir}/${name}env.sh
sed -i -e "s/#.export.PKG_CONFIG_PATH/export PKG_CONFIG_PATH/g" ${InstallDir}/${name}env.sh
sed -i -e "s/#.export.*//g" ${InstallDir}/${name}env.sh
printf 'export CMAKE_PREFIX_PATH=${'${name}'_ROOT_DIR}${CMAKE_PREFIX_PATH:+:${CMAKE_PREFIX_PATH}}\n' \
  >> ${InstallDir}/${name}env.sh