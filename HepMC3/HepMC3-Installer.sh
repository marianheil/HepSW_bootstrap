#!/usr/bin/env bash

source ../config

## package specific variables
name=${HEPSW_HEPMC3_NAME}
package_name=${name}-${HEPSW_HEPMC3_VERSION}
# package_name=hepmc${HEPSW_HEPMC3_VERSION} # old style < 3.1
dependencies=${HEPSW_HEPMC3_DEPENDENCIES[@]}

InstallDir=${HEPSW_HEPMC3_DIR}

# general setup & environment
source ../init.sh

## download
cd ${WORKING_DIR}
# wget -O- http://hepmc.web.cern.ch/hepmc/releases/${package_name}.tgz | \ # old style < 3.1
wget -O- http://hepmc.web.cern.ch/hepmc/releases/${package_name}.tar.gz | \
  tar xz
cd ${package_name}
mkdir -p build
cd build

## install
include_root="OFF"
if [[ " ${dependencies[@]} " =~ " ROOT " ]]; then
  echo "Including Root I/O"
  include_root="ON"
fi
# HEPMC3_Python_SITEARCH since 3.2
cmake3 .. -DCMAKE_INSTALL_PREFIX=${InstallDir} \
  -DHEPMC3_ENABLE_ROOTIO=${include_root} \
  -DHEPMC3_Python_SITEARCH27=${InstallDir}/lib64/python2.7/site-packages \
  -DHEPMC3_Python_SITEARCH36=${InstallDir}/lib64/python3.6/site-packages
make -j${NUM_CORES}
make install
rm -rf ${WORKING_DIR}/${package_name}

## environment
cp ${BASE_DIR}/TEMPLATEenv.sh ${InstallDir}/${name}env.sh
sed -i -e "s TEMPLATE_PREFIX ${InstallDir} g" ${InstallDir}/${name}env.sh
sed -i -e "s/TEMPLATE/${name}/g" ${InstallDir}/${name}env.sh
if [[ -d ${InstallDir}"/lib64" ]]; then
  sed -i -e "s /lib /lib64 g" ${InstallDir}/${name}env.sh
fi
sed -i -e "s/#.export.PATH/export PATH/g" ${InstallDir}/${name}env.sh
sed -i -e "s/#.export.*//g" ${InstallDir}/${name}env.sh
printf 'export PYTHONPATH='$InstallDir'/lib64/python2.7/site-packages:${PYTHONPATH}\n' >> ${InstallDir}/${name}env.sh
printf 'export PYTHONPATH='$InstallDir'/lib64/python3.6/site-packages:${PYTHONPATH}\n' >> ${InstallDir}/${name}env.sh
