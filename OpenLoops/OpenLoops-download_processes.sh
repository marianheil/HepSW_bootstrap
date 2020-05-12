#!/usr/bin/env bash

source ../config
source ../init.sh

## package specific variables
InstallDir=${HEPSW_OPENLOOPS_DIR}
# list of process to be installed
processes=( \
  bbhj \
  heftpphj \
  heftpphjj \
  heftpphjjj \
  heftppllj \
  heftpplljj \
  heftpplljjj \
  ppaj2 \
  ppajj \
  ppajj2 \
  ppajj_ew \
  ppajjj \
  pphbb \
  pphbbj \
  pphj2 \
  pphjj2 \
  pphjj_vbf \
  pphjj_vbf_ew \
  pphjjj2 \
  ppjj \
  ppjj_ew \
  ppjjj \
  ppjjj_ew \
  ppjjjj \
  ppll2 \
  ppllj \
  ppllj2 \
  ppllj_ew \
  ppllj_nf5 \
  pplljj \
  pplljj_ew \
  pplljjj \
  ppllll \
  ppllll2 \
  ppllll_ew \
  ppllllj \
  ppllllj2 \
  pplnj_ckm \
  pplnjj \
  pplnjj_ckm \
  pplnjj_ew \
  pplnjjj \
  )

## install all processes
cd ${InstallDir}
for process in ${processes[@]}
do
  echo "Installing" ${process}
  ./openloops libinstall ${process}
done
rm -r process_src/* process_obj/*
