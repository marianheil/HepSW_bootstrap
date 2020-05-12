#!/usr/bin/env bash

source ../config

## package specific variables
name=${HEPSW_OPENLOOPS_NAME}
package_name=${name}-${HEPSW_OPENLOOPS_VERSION}
dependencies=${HEPSW_OPENLOOPS_DEPENDENCIES[@]}

InstallDir=${HEPSW_OPENLOOPS_DIR}

# general setup & environment
source ../init.sh

## download
rm -rf ${InstallDir} # clean directory for git
mkdir -p ${InstallDir}
cd ${InstallDir}
git clone https://gitlab.com/openloops/OpenLoops.git .

## install
./scons

## create dummy environment
touch ${InstallDir}/${name}dependencies.sh
touch ${InstallDir}/${name}env.sh
printf "## OpenLoops 2\nexport OpenLoops_ROOT_DIR=${InstallDir}\n" > ${InstallDir}/${name}env.sh
