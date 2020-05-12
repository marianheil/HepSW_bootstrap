#!/usr/bin/env bash

source ../config

## package specific variables
name=${HEPSW_LHAPDF_NAME}
package_name=${name}-${HEPSW_LHAPDF_VERSION}
dependencies=${HEPSW_LHAPDF_DEPENDENCIES[@]}

InstallDir=${HEPSW_LHAPDF_DIR}

# general setup & environment
source ../init.sh

## download
cd ${WORKING_DIR}
wget -O- https://lhapdf.hepforge.org/downloads/?f=${package_name}.tar.gz | \
  tar xz
cd ${package_name}

## install
./configure --prefix=${InstallDir}
make -j${NUM_CORES}
make check
make install
rm -rf ${WORKING_DIR}/${package_name}

## environment
cp ${BASE_DIR}/TEMPLATEenv.sh ${InstallDir}/${name}env.sh
sed -i -e "s TEMPLATE_PREFIX ${InstallDir} g" ${InstallDir}/${name}env.sh
sed -i -e "s/TEMPLATE/${name}/g" ${InstallDir}/${name}env.sh
sed -i -e "s/#.export.PATH/export PATH/g" ${InstallDir}/${name}env.sh
sed -i -e "s/#.export.PKG_CONFIG_PATH/export PKG_CONFIG_PATH/g" ${InstallDir}/${name}env.sh
if [[ "${PYTHON}" =~ "python3" ]]; then
  # TODO make this neater
  printf 'export PYTHONPATH='$InstallDir'/lib64/python3.6/site-packages:${PYTHONPATH}\n' >> ${InstallDir}/${name}env.sh
else
  printf 'export PYTHONPATH='$InstallDir'/lib64/python2.7/site-packages:${PYTHONPATH}\n' >> ${InstallDir}/${name}env.sh
fi
