#!/usr/bin/env bash

source ../config
../init.sh

## package specific variables
name=${HEPSW_HEPMC3_NAME}
package_name=${name}-${HEPSW_HEPMC3_VERSION}
# package_name=hepmc${HEPSW_HEPMC3_VERSION} # old style < 3.1
dependencies=${HEPSW_HEPMC3_DEPENDENCIES[@]}

InstallDir=${HEPSW_HEPMC3_DIR}

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
# wget -O- http://hepmc.web.cern.ch/hepmc/releases/${package_name}.tgz | \ # old style < 3.1
wget -O- http://hepmc.web.cern.ch/hepmc/releases/${package_name}.tar.gz | \
  tar xz || exit 2
cd ${package_name}
mkdir build
cd build

## install
include_root="OFF"
if [[ " ${dependencies[@]} " =~ " ROOT " ]]; then
  echo "Including Root I/O"
  include_root="ON"
fi
cmake3 .. -DCMAKE_INSTALL_PREFIX=${InstallDir} \
  -DHEPMC3_ENABLE_ROOTIO=${include_root} || exit 3
make -j${NUM_CORES} || exit 3
make install || exit 4
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
