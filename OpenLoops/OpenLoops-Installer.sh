#!/usr/bin/env bash

source ../config

## package specific variables
name=${HEPSW_OPENLOOPS_NAME}
package_name=${name}-${HEPSW_OPENLOOPS_VERSION}

InstallDir=${HEPSW_OPENLOOPS_DIR}

## download
mkdir ${InstallDir}
cd ${InstallDir}
git clone https://gitlab.com/openloops/OpenLoops.git . || exit 1

## install
./scons

## no environment needed
