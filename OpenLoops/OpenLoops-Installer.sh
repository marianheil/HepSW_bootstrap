#!/usr/bin/env bash

source ../config
../init.sh

## package specific variables
name=${HEPSW_OPENLOOPS_NAME}
package_name=${name}-${HEPSW_OPENLOOPS_VERSION}
dependencies=${HEPSW_OPENLOOPS_DEPENDENCIES[@]}

InstallDir=${HEPSW_OPENLOOPS_DIR}

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
mkdir ${InstallDir}
cd ${InstallDir}
git clone https://gitlab.com/openloops/OpenLoops.git . || exit 1

## install
./scons

## create dummy environment
touch ${InstallDir}/${name}env.sh
printf "## OpenLoops 2\nexport OpenLoops_ROOT_DIR=${InstallDir}\n" > ${InstallDir}/${name}env.sh
