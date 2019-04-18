#!/usr/bin/env bash

source ../config

## package specific variables
name=${HEPSW_RIVET_NAME}
package_name=${HEPSW_RIVET_VERSION}

InstallDir=${HEPSW_RIVET_DIR}

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