#!/usr/bin/env bash

source ../config
../init.sh

## package specific variables
name=${HEPSW_PROFESSOR_NAME}
package_name=${name}-${HEPSW_PROFESSOR_VERSION}
dependencies=${HEPSW_PROFESSOR_DEPENDENCIES[@]}

InstallDir=${HEPSW_PROFESSOR_DIR}

## dependencies
mkdir -p ${InstallDir}
printf "" > ${InstallDir}/${name}dependencies.sh
for dep in ${dependencies[@]}; do
  dep_name="HEPSW_${dep}_NAME"
  dep_version="HEPSW_${dep}_VERSION"
  dep_dir="HEPSW_${dep}_DIR"
  printf "## ${!dep_name} ${!dep_version}\n" \
    >> ${InstallDir}/${name}dependencies.sh
  printf "source ${!dep_dir}/${!dep_name}env.sh\n" \
    >> ${InstallDir}/${name}dependencies.sh
done

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
