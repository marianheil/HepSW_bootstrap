#!/usr/bin/env bash

source ../config
../init.sh

## package specific variables
name=${HEPSW_ROOT_NAME}
package_name=${name}-${HEPSW_ROOT_VERSION}
dependencies=${HEPSW_ROOT_DEPENDENCIES[@]}

InstallDir=${HEPSW_ROOT_DIR}

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
wget -O- https://root.cern/download/root_v${HEPSW_ROOT_VERSION}.source.tar.gz | \
  tar zx || exit 1
cd ${package_name}
mkdir build
cd build

## install
cmake3 .. -DCMAKE_INSTALL_PREFIX=${InstallDir}
make -j${NUM_CORES} || exit 2
make install || exit 3
rm -rf ${WORKING_DIR}/${package_name}

## environment
printf "source ${InstallDir}/bin/thisroot.sh\n" > ${InstallDir}/${name}env.sh
