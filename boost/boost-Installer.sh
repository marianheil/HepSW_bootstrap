#!/usr/bin/env bash

source ../config

## package specific variables
name=${HEPSW_BOOST_NAME}
package_name=${name}_$(echo ${HEPSW_BOOST_VERSION} | sed -e "s/\./_/g")

InstallDir=${HEPSW_BOOST_DIR}

## download
cd ${WORKING_DIR}
mkdir ${package_name}
wget -O- \
  https://dl.bintray.com/boostorg/release/${HEPSW_BOOST_VERSION}/source/${package_name}.tar.gz | \
  tar zx || exit 1
cd ${package_name}
./bootstrap.sh --prefix=${InstallDir} --with-python=$(which python) \
  --with-libraries=all || exit 2

## install
./b2 -j${NUM_CORES} install || exit 3
rm -rf ${WORKING_DIR}/${package_name}

## environment
cp ${BASE_DIR}/TEMPLATEenv.sh ${InstallDir}/${name}env.sh
sed -i -e "s TEMPLATE_PREFIX ${InstallDir} g" ${InstallDir}/${name}env.sh
sed -i -e "s/TEMPLATE/${name}/g" ${InstallDir}/${name}env.sh
sed -i -e "s/#.export.*//g" ${InstallDir}/${name}env.sh
