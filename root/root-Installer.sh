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

source ${InstallDir}/${name}dependencies.sh

## download
cd ${WORKING_DIR}
wget -O- https://root.cern/download/root_v${HEPSW_ROOT_VERSION}.source.tar.gz | \
  tar zx
cd ${package_name}
## root actually includes a folder names "build"
BUILD_DIR=$(mktemp -p ${PWD} -d build-XXXXX)
cd ${BUILD_DIR}

## install
${CMAKE} .. -DCMAKE_INSTALL_PREFIX=${InstallDir}
# TODO check python
make -j${NUM_CORES}
make install
rm -rf ${WORKING_DIR}/${package_name}

## environment
printf "source ${InstallDir}/bin/thisroot.sh\n" > ${InstallDir}/${name}env.sh
