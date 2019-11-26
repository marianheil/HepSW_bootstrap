#!/usr/bin/env bash

source ../config
../init.sh

## package specific variables
name=${HEPSW_CLHEP_NAME}
package_name=clhep-${HEPSW_CLHEP_VERSION}
dependencies=${HEPSW_CLHEP_DEPENDENCIES[@]}

InstallDir=${HEPSW_CLHEP_DIR}

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
wget -O- http://proj-clhep.web.cern.ch/proj-clhep/DISTRIBUTION/tarFiles/${package_name}.tgz | \
  tar xz || exit 1
cd ${HEPSW_CLHEP_VERSION}
mkdir build
cd build

## install
cmake3 -DCMAKE_INSTALL_PREFIX=${InstallDir} ../CLHEP || exit 2
make -j${NUM_CORES} || exit 2
make test || exit 3
make install || exit 3
rm -rf ${WORKING_DIR}/${HEPSW_CLHEP_VERSION}

## environment
cp ${BASE_DIR}/TEMPLATEenv.sh ${InstallDir}/${name}env.sh
sed -i -e "s TEMPLATE_PREFIX ${InstallDir} g" ${InstallDir}/${name}env.sh
sed -i -e "s/TEMPLATE/${name}/g" ${InstallDir}/${name}env.sh
sed -i -e "s/#.export.PATH/export PATH/g" ${InstallDir}/${name}env.sh
sed -i -e "s/#.export.PKG_CONFIG_PATH/export PKG_CONFIG_PATH/g" ${InstallDir}/${name}env.sh
