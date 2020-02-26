#!/usr/bin/env bash

source ../config
../init.sh
# overwrite compiler for MPI
export CC=${MPICXX}   # C compiler
export CXX=${MPICXX} # C++ compiler

## package specific variables
name=${HEPSW_SHERPA_NAME}
package_name=${name}-${HEPSW_SHERPA_VERSION}
dependencies=${HEPSW_SHERPA_DEPENDENCIES[@]}

InstallDir=${HEPSW_SHERPA_DIR}
git_branch=rel-$(echo ${HEPSW_SHERPA_VERSION} | sed -e "s/\./-/g")

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
git clone -b ${git_branch} https://gitlab.com/sherpa-team/sherpa.git ${package_name}
cd ${package_name}

## install
include_root="no"
if [[ " ${dependencies[@]} " =~ " ROOT " ]]; then
  echo "Including Root I/O"
  include_root=${HEPSW_ROOT_DIR}
fi
autoreconf -if
./configure --prefix ${InstallDir} --enable-fastjet=${HEPSW_FASTJET_DIR} \
  --enable-hepmc2=${HEPSW_HEPMC2_DIR} --enable-lhapdf=${HEPSW_LHAPDF_DIR} \
  --enable-openloops=${HEPSW_OPENLOOPS_DIR} --enable-root=${include_root} \
  --enable-rivet=${HEPSW_RIVET_DIR} --enable-recola=${HEPSW_RECOLA_DIR} \
  --enable-hepmc3=${HEPSW_HEPMC3_DIR} --enable-hepmc3root --enable-pythia \
  --enable-mpi --enable-gzip CXXFLAGS="-std=c++11" --enable-ufo || exit 2
make -j${NUM_CORES} || exit 2
make check || exit 3
make install || exit 3

rm -rf ${WORKING_DIR}/${package_name}

## environment
cp ${BASE_DIR}/TEMPLATEenv.sh ${InstallDir}/${name}env.sh
sed -i -e "s TEMPLATE_PREFIX ${InstallDir} g" ${InstallDir}/${name}env.sh
sed -i -e "s/TEMPLATE/${name}/g" ${InstallDir}/${name}env.sh
sed -i -e "s/#.export.PATH/export PATH/g" ${InstallDir}/${name}env.sh
sed -i -e "s/#.export.*//g" ${InstallDir}/${name}env.sh
