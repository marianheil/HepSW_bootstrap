#!/usr/bin/env bash
source ../config

## package specific variables
name=${HEPSW_FORM_NAME}
package_name=form-${HEPSW_FORM_VERSION}
dependencies=${HEPSW_FORM_DEPENDENCIES[@]}
package_version=${HEPSW_FORM_VERSION}

InstallDir=${HEPSW_FORM_DIR}

# general setup & environment
source ../init.sh

## download
cd ${WORKING_DIR}
wget -O- https://github.com/vermaseren/form/archive/v${package_version}.tar.gz | \
  tar zx
cd ${package_name}

## install
autoreconf -i
./configure --prefix=${InstallDir} --enable-parform
make -j${NUM_CORES}
make check
make install
rm -rf ${WORKING_DIR}/${package_name}

## environment
cp ${BASE_DIR}/TEMPLATEenv.sh ${InstallDir}/${name}env.sh
# form only has an executable
sed -i -e "s/export.TEMPLATE_INCLUDEDIR/# export/g" ${InstallDir}/${name}env.sh
sed -i -e "s/export.TEMPLATE_LIBRARYDIR/# export/g" ${InstallDir}/${name}env.sh
sed -i -e "s/export.LD_LIBRARY_PATH/# export/g" ${InstallDir}/${name}env.sh
sed -i -e "s TEMPLATE_PREFIX ${InstallDir} g" ${InstallDir}/${name}env.sh
sed -i -e "s/TEMPLATE/${name}/g" ${InstallDir}/${name}env.sh
sed -i -e "s/#.export.PATH/export PATH/g" ${InstallDir}/${name}env.sh
sed -i -e "s/#.export.*//g" ${InstallDir}/${name}env.sh
