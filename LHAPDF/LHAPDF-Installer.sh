#!/usr/bin/env bash

source ../config

## package specific variables
name=${HEPSW_LHAPDF_NAME}
package_name=${name}-${HEPSW_LHAPDF_VERSION}
dependencies=${HEPSW_LHAPDF_DEPENDENCIES[@]}

InstallDir=${HEPSW_LHAPDF_DIR}

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
wget -O- https://lhapdf.hepforge.org/downloads/?f=${package_name}.tar.gz | \
  tar xz || exit 1
cd ${package_name}

## install
./configure --prefix=${InstallDir} || exit 2
make -j${NUM_CORES} || exit 2
make check || exit 3
make install || exit 3
rm -rf ${WORKING_DIR}/${package_name}

## environment
cp ${BASE_DIR}/TEMPLATEenv.sh ${InstallDir}/${name}env.sh
sed -i -e "s TEMPLATE_PREFIX ${InstallDir} g" ${InstallDir}/${name}env.sh
sed -i -e "s/TEMPLATE/${name}/g" ${InstallDir}/${name}env.sh
sed -i -e "s/#.export.PATH/export PATH/g" ${InstallDir}/${name}env.sh
sed -i -e "s/#.export.PKG_CONFIG_PATH/export PKG_CONFIG_PATH/g" ${InstallDir}/${name}env.sh
printf 'export PYTHONPATH='$InstallDir'/lib64/python2.7/site-packages:${PYTHONPATH}\n' >> ${InstallDir}/${name}env.sh
