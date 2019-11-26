#!/usr/bin/env bash

## create basic folders
mkdir -p ${HEPSW_HOME}
cp ../UserInfo/README.txt ${HEPSW_HOME}/README.txt
sed  -i -e "s HEPSW_HOME ${HEPSW_HOME} g" ${HEPSW_HOME}/README.txt

mkdir -p ${WORKING_DIR}
