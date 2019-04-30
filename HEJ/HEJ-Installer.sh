#!/usr/bin/env bash

source ../config

## package specific variables
name=${HEPSW_HEJ_NAME}
package_name=${name}-${HEPSW_HEJ_VERSION}

InstallDir=${HEPSW_HEJ_DIR}
git_branch=v$(echo ${HEPSW_HEJ_VERSION} | cut -f1,2 -d ".")

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
make install || exit 3

## environment
cd ${BASE_DIR}
cp ../TEMPLATEenv.sh ${InstallDir}/${name}env.sh
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
  .. || exit 2
echo 0
make -j${NUM_CORES} || exit 2
make install || exit 3

rm -rf ${WORKING_DIR}/${package_name}

## save dependeces
cd ${BASE_DIR}
# boost
printf "## ${HEPSW_BOOST_NAME} ${HEPSW_BOOST_VERSION}\n" \
  > ${InstallDir}/${name}dependeces.sh
printf "source ${HEPSW_BOOST_DIR}/${HEPSW_BOOST_NAME}env.sh\n" \
  >> ${InstallDir}/${name}dependeces.sh
# CLHEP
printf "## ${HEPSW_CLHEP_NAME} ${HEPSW_CLHEP_VERSION}\n" \
  >> ${InstallDir}/${name}dependeces.sh
printf "source ${HEPSW_CLHEP_DIR}/${HEPSW_CLHEP_NAME}env.sh\n" \
  >> ${InstallDir}/${name}dependeces.sh
# FastJet
printf "## ${HEPSW_FASTJET_NAME} ${HEPSW_FASTJET_VERSION}\n" \
  >> ${InstallDir}/${name}dependeces.sh
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
# QCDloop
printf "## ${HEPSW_QCDLOOP_NAME} ${HEPSW_QCDLOOP_VERSION}\n" \
  >> ${InstallDir}/${name}dependeces.sh
printf "source ${HEPSW_QCDLOOP_DIR}/${HEPSW_QCDLOOP_NAME}env.sh\n" \
  >> ${InstallDir}/${name}dependeces.sh
# rivet
printf "## ${HEPSW_RIVET_NAME} ${HEPSW_RIVET_VERSION}\n" \
  >> ${InstallDir}/${name}dependeces.sh
printf "source ${HEPSW_RIVET_DIR}/${HEPSW_RIVET_NAME}env.sh\n" \
  >> ${InstallDir}/${name}dependeces.sh
