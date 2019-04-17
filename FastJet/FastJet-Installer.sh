#!/usr/bin/env bash

source ../config

InstallDir="${HEPSW_HOME}/FastJet-${HEPSW_FASTJET_VERSION}"
package_name=fastjet-${HEPSW_FASTJET_VERSION}
cd ${WORKING_DIR}

wget -O- http://fastjet.fr/repo/${package_name}.tar.gz | \
  tar zx || exit 1
cd ${package_name}/

./configure --prefix=${InstallDir} --enable-allplugins || exit 2
make -j${NUM_CORES} || exit 2
make check || exit 3
make install || exit 3
rm -rf ${WORKING_DIR}/${package_name}

cd ${BASE_DIR}
cp ../TEMPLATEenv.sh ${InstallDir}/FastJetenv.sh
sed -i -e "s TEMPLATE_PREFIX ${InstallDir} g" ${InstallDir}/FastJetenv.sh
sed -i -e "s/TEMPLATE/FastJet/g" ${InstallDir}/FastJetenv.sh
sed -i -e "s/#.export.PATH/export PATH/g" ${InstallDir}/FastJetenv.sh
sed -i -e "s/#.export.*//g" ${InstallDir}/FastJetenv.sh
