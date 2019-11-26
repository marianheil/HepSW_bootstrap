#!/usr/bin/env bash

source ../config
../init.sh

## package specific variables
InstallDir=${HEPSW_OPENLOOPS_DIR}
# list of process to be installed
processes=(ppjj ppjj_ew ppjjj ppjjj_ew ppjjjj \
  heftpphj heftpphjj heftpphjjj pph2 pphbb bbhj pphbbj pphj2 pphjj2 pphjjj2 \
  pphjj_vbf pphjj_vbf_ew \
  ppaj2 ppajj ppajj2 ppajj_ew ppajjj \
  ppll2 ppllj ppllj2 ppllj_ew ppllj_nf5 pplljj pplljj_ew pplljjj \
  pplnj_ckm pplnjj pplnjj_ckm pplnjj_ew pplnjjj)

## install all processes
cd ${InstallDir}
for process in ${processes[@]}
do
  echo "Installing" ${process}
  ./openloops libinstall ${process} || exit 1
done
rm -r process_src/* process_obj/* || exit 2
