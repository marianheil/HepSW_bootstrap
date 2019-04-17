#!/usr/bin/env bash

source ../config

InstallDir="${HEPSW_HOME}/CLHEP-${HEPSW_LHAPDF_VERSION}"
package_name=LHAPDF-${HEPSW_LHAPDF_VERSION}
cd ${WORKING_DIR}

wget -O- https://lhapdf.hepforge.org/downloads/?f=${package_name}.tar.gz | \
  tar xz || exit 1
cd ${package_name}

./configure --prefix=${InstallDir} || exit 2
make -j${NUM_CORES} || exit 2
make check || exit 3
make install || exit 3
rm -rf ${WORKING_DIR}/${package_name}

cd ${BASE_DIR}
cp ../TEMPLATEenv.sh ${InstallDir}/LHAPDFenv.sh
sed -i -e "s TEMPLATE_PREFIX ${InstallDir} g" ${InstallDir}/LHAPDFenv.sh
sed -i -e "s/TEMPLATE/LHAPDF/g" ${InstallDir}/LHAPDFenv.sh
sed -i -e "s/#.export.PATH/export PATH/g" ${InstallDir}/LHAPDFenv.sh
sed -i -e "s/#.export.PKG_CONFIG_PATH/export PKG_CONFIG_PATH/g" ${InstallDir}/LHAPDFenv.sh
printf 'export PYTHONPATH='$InstallDir'/lib/python2.7/site-packages:$PYTHONPATH\n' >> ${InstallDir}/LHAPDFenv.sh
