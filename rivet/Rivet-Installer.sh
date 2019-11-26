#!/usr/bin/env bash

source ../config
../init.sh

## package specific variables
name=${HEPSW_RIVET_NAME}
package_name=${HEPSW_RIVET_VERSION}
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
mkdir ${package_name}
cd ${package_name}
wget -O rivet-bootstrap \
  https://phab.hepforge.org/source/rivetbootstraphg/browse/${package_name}/rivet-bootstrap?view=raw
chmod +x rivet-bootstrap

## install
INSTALL_FASTJET=0 FASTJETPATH=${HEPSW_FASTJET_DIR} \
  INSTALL_HEPMC=0 HEPMCPATH=${HEPSW_HEPMC2_DIR} \
  INSTALL_PREFIX=${InstallDir} MAKE="make -j ${NUM_CORES}" \
  ./rivet-bootstrap

rm -rf ${WORKING_DIR}/${package_name}
