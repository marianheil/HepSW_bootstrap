#!/usr/bin/env bash

source ../config
../init.sh

## package specific variables
name=${HEPSW_BOOST_NAME}
package_name=${name}_$(echo ${HEPSW_BOOST_VERSION} | sed -e "s/\./_/g")
dependencies=${HEPSW_BOOST_DEPENDENCIES[@]}

InstallDir=${HEPSW_BOOST_DIR}

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
wget -O- \
  https://dl.bintray.com/boostorg/release/${HEPSW_BOOST_VERSION}/source/${package_name}.tar.gz | \
  tar zx || exit 1
cd ${package_name}
./bootstrap.sh --prefix=${InstallDir} --with-python=$(which python) \
  --with-libraries=all --with-toolset=${CC##*/} || exit 2

  # Minimal for HEJ: --with-libraries=iostreams,ublas,headers

## install
./b2 -j${NUM_CORES} install || exit 3
rm -rf ${WORKING_DIR}/${package_name}

## environment
cp ${BASE_DIR}/TEMPLATEenv.sh ${InstallDir}/${name}env.sh
sed -i -e "s TEMPLATE_PREFIX ${InstallDir} g" ${InstallDir}/${name}env.sh
sed -i -e "s/TEMPLATE/${name}/g" ${InstallDir}/${name}env.sh
sed -i -e "s/#.export.*//g" ${InstallDir}/${name}env.sh
