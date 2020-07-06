#!/usr/bin/env bash

source ../config
source ../init.sh

## package specific variables
source ${HEPSW_LHAPDF_DIR}/${HEPSW_LHAPDF_NAME}env.sh

## download all PDF sets
all_pdfs=($(lhapdf ls))
lhapdf update
lhapdf get
lhapdf upgrade
