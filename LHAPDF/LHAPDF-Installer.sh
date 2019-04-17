#!/usr/bin/env bash

source ../config

## package specific variables
name=LHAPDF
package_name=${name}-${HEPSW_LHAPDF_VERSION}

InstallDir=${HEPSW_HOME}/${name}-${HEPSW_LHAPDF_VERSION}

## download
cd ${WORKING_DIR}
wget -O- https://lhapdf.hepforge.org/downloads/?f=${package_name}.tar.gz | \
  tar xz || exit 1
cd ${package_name}

## install
./configure --prefix=${InstallDir} || exit 2
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
sed -i -e "s/#.export.PKG_CONFIG_PATH/export PKG_CONFIG_PATH/g" ${InstallDir}/${name}env.sh
printf 'export PYTHONPATH='$InstallDir'/lib64/python2.7/site-packages:$PYTHONPATH\n' >> ${InstallDir}/${name}env.sh
