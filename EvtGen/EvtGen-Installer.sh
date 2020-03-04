#!/usr/bin/env bash

source ../config

## package specific variables
name=${HEPSW_EVTGEN_NAME}
package_name=${name}-${HEPSW_EVTGEN_VERSION}
dependencies=${HEPSW_EVTGEN_DEPENDENCIES[@]}

InstallDir=${HEPSW_EVTGEN_DIR}
unpacked_dir=${name}/R$(echo ${HEPSW_EVTGEN_VERSION} | sed -e "s/\./-/g")

# general setup & environment
source ../init.sh

## download
cd ${WORKING_DIR}
wget  -O- https://evtgen.hepforge.org/downloads?f=${package_name}.tar.gz| \
  tar xz
cd ${unpacked_dir}

## install
./configure --prefix=${InstallDir} --pythiadir=${HEPSW_PYTHIA_DIR} \
  --hepmcdir=${HEPSW_HEPMC2_DIR}
## EvtGen doesn't like running with multiple cores at once, but running make
## again seems to fix it ...
make -j${NUM_CORES}
make
make install
rm -rf ${WORKING_DIR}/${package_name}

## environment
cp ${BASE_DIR}/TEMPLATEenv.sh ${InstallDir}/${name}env.sh
sed -i -e "s TEMPLATE_PREFIX ${InstallDir} g" ${InstallDir}/${name}env.sh
sed -i -e "s/TEMPLATE/${name}/g" ${InstallDir}/${name}env.sh
sed -i -e "s/#.export.*//g" ${InstallDir}/${name}env.sh
