#!/usr/bin/env bash

source ../config

## package specific variables
name=${HEPSW_SWIG_NAME}
package_name=${name}-${HEPSW_SWIG_VERSION}
dependencies=${HEPSW_SWIG_DEPENDENCIES[@]}

InstallDir=${HEPSW_SWIG_DIR}

# general setup & environment
source ../init.sh

## download
cd ${WORKING_DIR}
wget -O- http://prdownloads.sourceforge.net/swig/${package_name}.tar.gz | \
  tar xz
cd ${package_name}

## install
./autogen.sh
./configure --prefix ${InstallDir} --without-java --without-octave --without-r
make -j${NUM_CORES}

check_flags="-j${NUM_CORES}"
## python 3 is not correctly picked up for tests
## see https://github.com/swig/swig/issues/1805#issuecomment-636987898
if [[ "${PYTHON}" =~ "python3" ]]; then
  check_flags+=" PY3=y"
fi
make check ${check_flags}
make install

rm -rf ${WORKING_DIR}/${package_name}

## environment
cp ${BASE_DIR}/TEMPLATEenv.sh ${InstallDir}/${name}env.sh
sed -i -e "s/.*TEMPLATE_INCLUDEDIR.*//g" ${InstallDir}/${name}env.sh
sed -i -e "s/.*TEMPLATE_LIBRARYDIR.*//g" ${InstallDir}/${name}env.sh
sed -i -e "s TEMPLATE_PREFIX ${InstallDir} g" ${InstallDir}/${name}env.sh
sed -i -e "s/TEMPLATE/${name}/g" ${InstallDir}/${name}env.sh
sed -i -e "s/#.export.PATH/export PATH/g" ${InstallDir}/${name}env.sh
sed -i -e "s/#.export.*//g" ${InstallDir}/${name}env.sh
