#!/usr/bin/env bash

source ../config

## package specific variables
name=${HEPSW_SHERPA_NAME}
package_name=${name}-${HEPSW_SHERPA_VERSION}
dependencies=${HEPSW_SHERPA_DEPENDENCIES[@]}

InstallDir=${HEPSW_SHERPA_DIR}
git_branch=rel-$(echo ${HEPSW_SHERPA_VERSION} | sed -e "s/\./-/g")

# general setup & environment
source ../init.sh

# overwrite compiler for MPI
export CC=${MPICXX}   # C compiler
export CXX=${MPICXX} # C++ compiler

## download
cd ${WORKING_DIR}
git clone -b ${git_branch} https://gitlab.com/sherpa-team/sherpa.git ${package_name}
cd ${package_name}

## install
include_root="no"
if [[ " ${dependencies[@]} " =~ " ROOT " ]]; then
  echo "Including Root I/O"
  include_root=${HEPSW_ROOT_DIR}
fi
if [[ " ${HEPSW_HEPMC3_DEPENDENCIES[@]} " =~ " ROOT " ]]; then
  echo "Including HepMC3 Root I/O"
  include_root=${include_root}" --enable-hepmc3root"
fi
autoreconf -if
./configure --prefix ${InstallDir} --enable-fastjet=${HEPSW_FASTJET_DIR} \
  --enable-hepmc2=${HEPSW_HEPMC2_DIR} --enable-lhapdf=${HEPSW_LHAPDF_DIR} \
  --enable-openloops=${HEPSW_OPENLOOPS_DIR} --enable-root=${include_root} \
  --enable-rivet=${HEPSW_RIVET_DIR} --enable-recola=${HEPSW_RECOLA_DIR} \
  --enable-hepmc3=${HEPSW_HEPMC3_DIR} --enable-pythia \
  --enable-mpi --enable-gzip CXXFLAGS="-std=c++11" --enable-ufo \
  --enable-lhole --enable-analysis
# TODO add python
make -j${NUM_CORES}
make check
make install

rm -rf ${WORKING_DIR}/${package_name}

## environment
cp ${BASE_DIR}/TEMPLATEenv.sh ${InstallDir}/${name}env.sh
sed -i -e "s TEMPLATE_PREFIX ${InstallDir} g" ${InstallDir}/${name}env.sh
sed -i -e "s/TEMPLATE/${name}/g" ${InstallDir}/${name}env.sh
sed -i -e "s/#.export.PATH/export PATH/g" ${InstallDir}/${name}env.sh
sed -i -e "s/#.export.*//g" ${InstallDir}/${name}env.sh
