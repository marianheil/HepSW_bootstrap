#!/usr/bin/env bash

source ../config

## package specific variables
name=${HEPSW_SHERPA_NAME}
package_name=${name}-${HEPSW_SHERPA_VERSION}

InstallDir=${HEPSW_SHERPA_DIR}
git_branch=rel-$(echo ${HEPSW_SHERPA_VERSION} | sed -e "s/\./-/g")

## download
cd ${WORKING_DIR}
git clone -b ${git_branch} https://gitlab.com/sherpa-team/sherpa.git ${package_name}
cd ${package_name}

## install
autoreconf -i
./configure --prefix ${InstallDir} --enable-fastjet=${HEPSW_FASTJET_DIR} \
  --enable-hepmc2=${HEPSW_HEPMC2_DIR} --enable-lhapdf=${HEPSW_LHAPDF_DIR} \
  --enable-openloops=${HEPSW_OPENLOOPS_DIR} --enable-root=${HEPSW_ROOT_DIR} \
  --enable-rivet=${HEPSW_RIVET_DIR} --enable-gzip \
  CXXFLAGS="-std=c++11" --enable-mpi --enable-ufo || exit 2
make -j${NUM_CORES} || exit 2
make check || exit 3
make install || exit 3
rm -rf ${WORKING_DIR}/${package_name}

## environment
cd ${BASE_DIR}
cp ../TEMPLATEenv.sh ${InstallDir}/${name}env.sh
sed -i -e "s TEMPLATE_PREFIX ${InstallDir} g" ${InstallDir}/${name}env.sh
sed -i -e "s/TEMPLATE/${name}/g" ${InstallDir}/${name}env.sh
sed -i -e "s/#.export.PATH/export PATH/g" ${InstallDir}/${name}env.sh
sed -i -e "s/#.export.*//g" ${InstallDir}/${name}env.sh

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
# OpenLoops
printf "## ${HEPSW_OPENLOOPS_NAME} ${HEPSW_OPENLOOPS_VERSION}\n" \
  >> ${InstallDir}/${name}dependeces.sh
printf "export ${HEPSW_OPENLOOPS_NAME}_ROOT_DIR=${HEPSW_OPENLOOPS_DIR}\n" \
  >> ${InstallDir}/${name}dependeces.sh
# root
printf "## ${HEPSW_ROOT_NAME} ${HEPSW_ROOT_VERSION}\n" \
  >> ${InstallDir}/${name}dependeces.sh
printf "source ${HEPSW_ROOT_DIR}/${HEPSW_ROOT_NAME}env.sh\n" \
  >> ${InstallDir}/${name}dependeces.sh
# rivet
printf "## ${HEPSW_RIVET_NAME} ${HEPSW_RIVET_VERSION}\n" \
  >> ${InstallDir}/${name}dependeces.sh
printf "source ${HEPSW_RIVET_DIR}/${HEPSW_RIVET_NAME}env.sh\n" \
  >> ${InstallDir}/${name}dependeces.sh