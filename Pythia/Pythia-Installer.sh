#!/usr/bin/env bash

source ../config
../init.sh

## package specific variables
name=${HEPSW_PYTHIA_NAME}
package_name=pythia$(echo ${HEPSW_PYTHIA_VERSION} | sed -e "s/\.//g")
dependencies=${HEPSW_PYTHIA_DEPENDENCIES[@]}

InstallDir=${HEPSW_PYTHIA_DIR}

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
wget  -O- http://home.thep.lu.se/~torbjorn/pythia8/${package_name}.tgz| \
  tar xz || exit 1
cd ${package_name}

## install
include_root=""
if [[ " ${dependencies[@]} " =~ " ROOT " ]]; then
  echo "Including Root I/O"
  include_root=-"-with-root=${HEPSW_ROOT_DIR}"
fi
autoreconf -i
./configure --prefix=${InstallDir} --with-fastjet3=${HEPSW_FASTJET_DIR} \
  --with-hepmc2=${HEPSW_HEPMC2_DIR} --with-lhapdf6=${HEPSW_LHAPDF_DIR} \
  ${include_root} --with-python-include=/usr/include/python2.7 \
  --with-gzip --enable-shared --cxx-common="-g -O2 -pedantic -W -Wall -Wshadow -fPIC" || exit 2
make -j${NUM_CORES} || exit 2
make install || exit 3

rm -rf ${WORKING_DIR}/${package_name}

## environment
cp ${BASE_DIR}/TEMPLATEenv.sh ${InstallDir}/${name}env.sh
sed -i -e "s TEMPLATE_PREFIX ${InstallDir} g" ${InstallDir}/${name}env.sh
sed -i -e "s/TEMPLATE/${name}/g" ${InstallDir}/${name}env.sh
sed -i -e "s/#.export.PATH/export PATH/g" ${InstallDir}/${name}env.sh
sed -i -e "s/#.export.*//g" ${InstallDir}/${name}env.sh
printf 'export PYTHONPATH='$InstallDir'/lib:${PYTHONPATH}\n' >> ${InstallDir}/${name}env.sh
