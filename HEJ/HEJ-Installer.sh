#!/usr/bin/env bash

source ../config

## package specific variables
name=${HEPSW_HEJ_NAME}
package_name=${name}-${HEPSW_HEJ_VERSION}
dependencies=${HEPSW_HEJ_DEPENDENCIES[@]}

InstallDir=${HEPSW_HEJ_DIR}
git_branch=v$(echo ${HEPSW_HEJ_VERSION} | cut -f1,2 -d ".")

# general setup & environment
source ../init.sh

## download
cd ${WORKING_DIR}
git clone -b ${git_branch} https://phab.hepforge.org/source/hej.git ${package_name} || exit 1
cd ${package_name}
git reset --hard ${HEPSW_HEJ_VERSION}

## install HEJ
mkdir build
cd build
cmake3 -DCMAKE_INSTALL_PREFIX=${InstallDir} -DBOOST_ROOT=${HEPSW_BOOST_DIR} \
  -DHepMC_ROOT_DIR=${HEPSW_HEPMC2_DIR} .. || exit 2
make -j${NUM_CORES} || exit 2
make test || exit 3
make install || exit 3

## environment
cp ${BASE_DIR}/TEMPLATEenv.sh ${InstallDir}/${name}env.sh
sed -i -e "s TEMPLATE_PREFIX ${InstallDir} g" ${InstallDir}/${name}env.sh
sed -i -e "s/TEMPLATE/${name}/g" ${InstallDir}/${name}env.sh
sed -i -e "s/#.export.PATH/export PATH/g" ${InstallDir}/${name}env.sh
sed -i -e "s/#.export.*//g" ${InstallDir}/${name}env.sh

## install HEJFOG
source ${InstallDir}/${name}env.sh
cd ${WORKING_DIR}/${package_name}/FixedOrderGen
mkdir build
cd build
cmake3 -DCMAKE_INSTALL_PREFIX=${InstallDir} -DBOOST_ROOT=${HEPSW_BOOST_DIR} \
  .. || exit 4
make -j${NUM_CORES} || exit 5
make test || exit 6
make install || exit 6

## Cleanup
rm -rf ${WORKING_DIR}/${package_name}
