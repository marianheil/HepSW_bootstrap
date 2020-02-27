#!/usr/bin/env bash

source ../config

## package specific variables
name=${HEPSW_FASTJET_NAME}
package_name=fastjet-${HEPSW_FASTJET_VERSION}
dependencies=${HEPSW_FASTJET_DEPENDENCIES[@]}

InstallDir=${HEPSW_FASTJET_DIR}

# general setup & environment
source ../init.sh

## download
cd ${WORKING_DIR}
wget -O- http://fastjet.fr/repo/${package_name}.tar.gz | \
  tar zx || exit 1
cd ${package_name}/

## install
PYTHON_CONFIG=python-config \
  ./configure --prefix=${InstallDir} --enable-pyext --enable-allplugins || exit 2
# Without Fortran:  --enable-cxxallplugins
make -j${NUM_CORES} || exit 2
make check || exit 3
make install || exit 3
rm -rf ${WORKING_DIR}/${package_name}

## environment
cp ${BASE_DIR}/TEMPLATEenv.sh ${InstallDir}/${name}env.sh
sed -i -e "s TEMPLATE_PREFIX ${InstallDir} g" ${InstallDir}/${name}env.sh
sed -i -e "s/TEMPLATE/${name}/g" ${InstallDir}/${name}env.sh
sed -i -e "s/#.export.PATH/export PATH/g" ${InstallDir}/${name}env.sh
sed -i -e "s/#.export.*//g" ${InstallDir}/${name}env.sh
printf 'export PYTHONPATH='$InstallDir'/lib/python2.7/site-packages:'$InstallDir'/lib64/python2.7/site-packages:${PYTHONPATH}\n' >> ${InstallDir}/${name}env.sh

## install FastJet Contrib
source ${InstallDir}/${name}env.sh
cd ${WORKING_DIR}
wget -O- http://fastjet.hepforge.org/contrib/downloads/fjcontrib-${HEPSW_FASTJET_CONTRIB_VERSION}.tar.gz \
  | tar zx || exit 4
cd fjcontrib-${HEPSW_FASTJET_CONTRIB_VERSION}
./configure CXXFLAGS="-fPIC -std=c++11" CXX=${CXX} || exit 5
make -j${NUM_CORES} fragile-shared-install || exit 5
make check || exit 5
make install || exit 5
rm -rf ${WORKING_DIR}/fjcontrib
