#!/usr/bin/env bash

source ../config

## package specific variables
name=${HEPSW_PROFESSOR_NAME}
package_name=${name}-${HEPSW_PROFESSOR_VERSION}

InstallDir=${HEPSW_PROFESSOR_DIR}

## dependencies
mkdir -p ${InstallDir}
# eigen
printf "## ${HEPSW_EIGEN_NAME} ${HEPSW_EIGEN_VERSION}\n" \
  > ${InstallDir}/${name}dependencies.sh
printf "source ${HEPSW_EIGEN_DIR}/${HEPSW_EIGEN_NAME}env.sh\n" \
  >> ${InstallDir}/${name}dependencies.sh
# root
printf "## ${HEPSW_ROOT_NAME} ${HEPSW_ROOT_VERSION}\n" \
  >> ${InstallDir}/${name}dependencies.sh
printf "source ${HEPSW_ROOT_DIR}/${HEPSW_ROOT_NAME}env.sh\n" \
  >> ${InstallDir}/${name}dependencies.sh


source ${InstallDir}/${name}dependencies.sh || exit 1

## download
cd ${WORKING_DIR}
wget -O- "https://professor.hepforge.org/downloads/?f=${package_name}.tar.gz" | \
  tar xz || exit 2
cd ${package_name}

## install
CXXFLAGS="-I${HEPSW_EIGEN_DIR}/include/${HEPSW_EIGEN_NAME}3 -O3" \
  ROOTCONFIG=${HEPSW_ROOT_DIR}/bin/root-config \
  PREFIX=${InstallDir} \
  make all -j${NUM_CORES} || exit 3
CXXFLAGS="-I${HEPSW_EIGEN_DIR}/include/${HEPSW_EIGEN_NAME}3 -O3" \
  ROOTCONFIG=${HEPSW_ROOT_DIR}/bin/root-config \
  PREFIX=${InstallDir} \
  make install || exit 4

rm -rf ${WORKING_DIR}/${package_name}

## environment
cp ${BASE_DIR}/TEMPLATEenv.sh ${InstallDir}/${name}env.sh
sed -i -e "s TEMPLATE_PREFIX ${InstallDir} g" ${InstallDir}/${name}env.sh
sed -i -e "s/TEMPLATE/${name}/g" ${InstallDir}/${name}env.sh
sed -i -e "s/#.export.PATH/export PATH/g" ${InstallDir}/${name}env.sh
sed -i -e "s/#.export.*//g" ${InstallDir}/${name}env.sh
printf 'export PYTHONPATH='$InstallDir'/lib/python2.7/site-packages:'$InstallDir'/lib64/python2.7/site-packages:${PYTHONPATH}\n' >> ${InstallDir}/${name}env.sh
