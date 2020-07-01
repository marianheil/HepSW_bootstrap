#!/usr/bin/env bash

source ../config

## package specific variables
name=${HEPSW_PYTHIA_NAME}
package_name=pythia$(echo ${HEPSW_PYTHIA_VERSION} | sed -e "s/\.//g")
dependencies=${HEPSW_PYTHIA_DEPENDENCIES[@]}

InstallDir=${HEPSW_PYTHIA_DIR}

# general setup & environment
source ../init.sh

## download
cd ${WORKING_DIR}
wget -O- http://home.thep.lu.se/~torbjorn/pythia8/${package_name}.tgz | \
  tar xz
cd ${package_name}

## install
include_root=""
if [[ " ${dependencies[@]} " =~ " ROOT " ]]; then
  echo "Including Root I/O"
  include_root=-"-with-root=${HEPSW_ROOT_DIR}"
fi
if [[ "${PYTHON}" == "python3" ]]; then
  # TODO make this neater
  PYTHON_INCLUDE="/usr/include/python3.6m"
else
  PYTHON_INCLUDE="/usr/include/python2.7"
fi
if [[ ! -e configure ]]; then
  autoreconf -i # configure script might be pre-generated for some versions
fi
./configure --prefix=${InstallDir} --with-fastjet3=${HEPSW_FASTJET_DIR} \
  --with-hepmc2=${HEPSW_HEPMC2_DIR} --with-lhapdf6=${HEPSW_LHAPDF_DIR} \
  --with-python --with-python-lib=/usr/lib64 --with-python-include=${PYTHON_INCLUDE} \
  ${include_root} --with-gzip \
  --enable-shared --cxx-common="-g -O2 -pedantic -W -Wall -Wshadow -fPIC"
make -j${NUM_CORES}
make install

rm -rf ${WORKING_DIR}/${package_name}

## environment
cp ${BASE_DIR}/TEMPLATEenv.sh ${InstallDir}/${name}env.sh
sed -i -e "s TEMPLATE_PREFIX ${InstallDir} g" ${InstallDir}/${name}env.sh
sed -i -e "s/TEMPLATE/${name}/g" ${InstallDir}/${name}env.sh
sed -i -e "s/#.export.PATH/export PATH/g" ${InstallDir}/${name}env.sh
sed -i -e "s/#.export.*//g" ${InstallDir}/${name}env.sh
printf 'export PYTHONPATH='$InstallDir'/lib:${PYTHONPATH}\n' >> ${InstallDir}/${name}env.sh
