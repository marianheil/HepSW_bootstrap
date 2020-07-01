#!/usr/bin/env bash

source ../config

## package specific variables
name=${HEPSW_SWIG_NAME}
package_name=${name}-${HEPSW_SWIG_VERSION}
dependencies=${HEPSW_SWIG_DEPENDENCIES[@]}

InstallDir=${HEPSW_SWIG_DIR}
git_branch=rel-${HEPSW_SWIG_VERSION}

# general setup & environment
source ../init.sh

## download
cd ${WORKING_DIR}
git clone -b ${git_branch} https://github.com/swig/swig.git ${package_name}
cd ${package_name}

## install
./autogen.sh
./configure --prefix ${InstallDir} --without-java --without-octave --without-r
make -j${NUM_CORES}
make check -j${NUM_CORES}
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
