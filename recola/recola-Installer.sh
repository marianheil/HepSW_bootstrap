#!/usr/bin/env bash

source ../config

## package specific variables
name=${HEPSW_RECOLA_NAME}
package_name=${name}-collier-${HEPSW_RECOLA_VERSION}
dependencies=${HEPSW_RECOLA_DEPENDENCIES[@]}

InstallDir=${HEPSW_RECOLA_DIR}

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
wget -O- https://recola.hepforge.org/downloads/?f=${package_name}.tar.gz | \
  tar xz || exit 2
cd ${package_name}
mkdir build
cd build

## install
cmake3 -DCMAKE_INSTALL_PREFIX=${InstallDir} .. || exit 3
## in recola2 add:
# -Dmodel=SM
make || exit 3 # -j${NUM_CORES} doesn't work for some unknown reason (tested 1.4.0)
make install || exit 4
rm -rf ${WORKING_DIR}/${package_name}

## environment
cp ${BASE_DIR}/TEMPLATEenv.sh ${InstallDir}/${name}env.sh
sed -i -e "s TEMPLATE_PREFIX ${InstallDir} g" ${InstallDir}/${name}env.sh
sed -i -e "s/TEMPLATE/${name}/g" ${InstallDir}/${name}env.sh
sed -i -e "s/#.export.*//g" ${InstallDir}/${name}env.sh
