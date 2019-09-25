#!/usr/bin/env bash

source ../config

## package specific variables
name=${HEPSW_EVTGEN_NAME}
package_name=${name}-${HEPSW_EVTGEN_VERSION}

InstallDir=${HEPSW_EVTGEN_DIR}
unpacked_dir=${name}/R$(echo ${HEPSW_EVTGEN_VERSION} | sed -e "s/\./-/g")

## dependencies
mkdir -p ${InstallDir}
# HepMC2
printf "## ${HEPSW_HEPMC2_NAME} ${HEPSW_HEPMC2_VERSION}\n" \
  >> ${InstallDir}/${name}dependences.sh
printf "source ${HEPSW_HEPMC2_DIR}/${HEPSW_HEPMC2_NAME}env.sh\n" \
  >> ${InstallDir}/${name}dependences.sh
# pythia
printf "## ${HEPSW_PYTHIA_NAME} ${HEPSW_PYTHIA_VERSION}\n" \
  >> ${InstallDir}/${name}dependences.sh
printf "source ${HEPSW_PYTHIA_DIR}/${HEPSW_PYTHIA_NAME}env.sh\n" \
  >> ${InstallDir}/${name}dependences.sh

source ${InstallDir}/${name}dependences.sh || exit 1

## download
cd ${WORKING_DIR}
wget  -O- https://evtgen.hepforge.org/downloads?f=${package_name}.tar.gz| \
  tar xz || exit 1
cd ${unpacked_dir}

## install
./configure --prefix=${InstallDir} --pythiadir=${HEPSW_PYTHIA_DIR} \
  --hepmcdir=${HEPSW_HEPMC2_DIR} || exit 2
## EvtGen doesn't like running with multiple cores at once, but running make
## again seems to fix it ...
make -j${NUM_CORES}
make || exit 2
make install || exit 3

cd ${BASE_DIR}
rm -rf ${WORKING_DIR}/${package_name}

## environment
cp ../TEMPLATEenv.sh ${InstallDir}/${name}env.sh
sed -i -e "s TEMPLATE_PREFIX ${InstallDir} g" ${InstallDir}/${name}env.sh
sed -i -e "s/TEMPLATE/${name}/g" ${InstallDir}/${name}env.sh
sed -i -e "s/#.export.*//g" ${InstallDir}/${name}env.sh
