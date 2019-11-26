#!/usr/bin/env bash

source ../config
../init.sh

## package specific variables
name=${HEPSW_RIVET_NAME}
package_name=${name^}-${HEPSW_RIVET_VERSION}
dependencies=${HEPSW_RIVET_DEPENDENCIES[@]}

InstallDir=${HEPSW_RIVET_DIR}

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
wget -O- https://rivet.hepforge.org/downloads/?f=${package_name}.tar.gz | tar xz
cd ${package_name}

./configure --prefix=${InstallDir} \
  --with-yoda=${HEPSW_YODA_DIR} \
  --with-fastjet=${HEPSW_FASTJET_DIR} \
  --with-hepmc3=${HEPSW_HEPMC3_DIR} || exit 2

## install
make -j${NUM_CORES} || exit 3
make install || exit 3

rm -rf ${WORKING_DIR}/${package_name}
