#!/usr/bin/env bash

source ../config

## package specific variables
name=root
package_name=${name}-${HEPSW_ROOT_VERSION}

InstallDir=${HEPSW_HOME}/${name}-${HEPSW_ROOT_VERSION}

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
cd ${BASE_DIR}
printf "source ${InstallDir}/bin/thisroot.sh\n" > ${InstallDir}/${name}env.sh
