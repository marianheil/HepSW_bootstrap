#!/usr/bin/env bash

source ../config

## package specific variables
name=${HEPSW_PYTHIA_NAME}
package_name=pythia$(echo ${HEPSW_PYTHIA_VERSION} | sed -e "s/\.//g")

InstallDir=${HEPSW_PYTHIA_DIR}

## download
cd ${WORKING_DIR}
wget  -O- http://home.thep.lu.se/~torbjorn/pythia8/${package_name}.tgz| \
  tar xz || exit 1
cd ${package_name}

## install
autoreconf -i
./configure --prefix=${InstallDir} --with-fastjet3=${HEPSW_FASTJET_DIR} \
  --with-hepmc2=${HEPSW_HEPMC2_DIR} --with-lhapdf6=${HEPSW_LHAPDF_DIR} \
  --with-root=${HEPSW_ROOT_DIR} --with-python-include=/usr/include/python2.7 \
  --with-gzip --enable-shared --cxx-common="-g -O2 -pedantic -W -Wall -Wshadow -fPIC" || exit 2
make -j${NUM_CORES} || exit 2
make install || exit 3
rm -rf ${WORKING_DIR}/${package_name}

## environment
cd ${BASE_DIR}
cp ../TEMPLATEenv.sh ${InstallDir}/${name}env.sh
sed -i -e "s TEMPLATE_PREFIX ${InstallDir} g" ${InstallDir}/${name}env.sh
sed -i -e "s/TEMPLATE/${name}/g" ${InstallDir}/${name}env.sh
sed -i -e "s/#.export.PATH/export PATH/g" ${InstallDir}/${name}env.sh
sed -i -e "s/#.export.*//g" ${InstallDir}/${name}env.sh
printf 'export PYTHONPATH='$InstallDir'/lib:$PYTHONPATH\n' >> ${InstallDir}/${name}env.sh

## save dependeces
cd ${BASE_DIR}
# FastJet
printf "## ${HEPSW_FASTJET_NAME} ${HEPSW_FASTJET_VERSION}\n" \
  > ${InstallDir}/${name}dependeces.sh
printf "source ${HEPSW_FASTJET_DIR}/${HEPSW_FASTJET_NAME}env.sh\n" \
  >> ${InstallDir}/${name}dependeces.sh
# HepMC2
printf "## ${HEPSW_HEPMC2_NAME} ${HEPSW_HEPMC2_VERSION}\n" \
  >> ${InstallDir}/${name}dependeces.sh
printf "source ${HEPSW_HEPMC2_DIR}/${HEPSW_HEPMC2_NAME}env.sh\n" \
  >> ${InstallDir}/${name}dependeces.sh
# LHAPDF
printf "## ${HEPSW_LHAPDF_NAME} ${HEPSW_LHAPDF_VERSION}\n" \
  >> ${InstallDir}/${name}dependeces.sh
printf "source ${HEPSW_LHAPDF_DIR}/${HEPSW_LHAPDF_NAME}env.sh\n" \
  >> ${InstallDir}/${name}dependeces.sh
# root
printf "## ${HEPSW_ROOT_NAME} ${HEPSW_ROOT_VERSION}\n" \
  >> ${InstallDir}/${name}dependeces.sh
printf "source ${HEPSW_ROOT_DIR}/${HEPSW_ROOT_NAME}env.sh\n" \
  >> ${InstallDir}/${name}dependeces.sh
