#!/usr/bin/env bash

source ../config
../init.sh

## package specific variables
name=${HEPSW_EVTGEN_NAME}
package_name=${name}-${HEPSW_EVTGEN_VERSION}
dependencies=${HEPSW_EVTGEN_DEPENDENCIES[@]}

InstallDir=${HEPSW_EVTGEN_DIR}
unpacked_dir=${name}/R$(echo ${HEPSW_EVTGEN_VERSION} | sed -e "s/\./-/g")

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
wget  -O- https://evtgen.hepforge.org/downloads?f=${package_name}.tar.gz| \
  tar xz || exit 1
cd ${unpacked_dir}

## install
./configure --prefix=${InstallDir} --pythiadir=${HEPSW_PYTHIA_DIR} \
  --hepmcdir=${HEPSW_HEPMC2_DIR} || exit 2
## EvtGen doesn't like running with multiple cores at once, but running make
## again seems to fix it ...
make -j${NUM_CORES}
make || exit 2
make install || exit 3
rm -rf ${WORKING_DIR}/${package_name}

## environment
cp ${BASE_DIR}/TEMPLATEenv.sh ${InstallDir}/${name}env.sh
sed -i -e "s TEMPLATE_PREFIX ${InstallDir} g" ${InstallDir}/${name}env.sh
sed -i -e "s/TEMPLATE/${name}/g" ${InstallDir}/${name}env.sh
sed -i -e "s/#.export.*//g" ${InstallDir}/${name}env.sh
