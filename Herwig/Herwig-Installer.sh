#!/usr/bin/env bash

source ../config

## package specific variables
name=${HEPSW_HERWIG_NAME}
package_name=${name}-${HEPSW_HERWIG_VERSION}

InstallDir=${HEPSW_HERWIG_DIR}

## download
cd ${WORKING_DIR}
mkdir ${package_name}
cd ${package_name}
wget -O herwig-bootstrap \
  https://herwig.hepforge.org/downloads/herwig-bootstrap || exit 1
chmod +x herwig-bootstrap
## install

  # --with-evtgen=PATH
  # --with-form=PATH
  # --with-gosam=PATH
  # --with-gsl=PATH                ### mandatory
  # --with-madgraph=PATH           # Reccomended
  # --with-njet=PATH
  # --with-pythia=PATH            ## Version 8.1
  # --with-qgraph=PATH
  # --with-thepeg=PATH              ### mandatory
  # --with-vbfnlo=PATH
  # --with-hjets=PATH
  # gosam-contrib (somehow)

  #TODO install ThePEG separately

  #
  # ./configure --prefix=${InstallDir} \

  # --with-boost${HEPSW_BOOST_DIR} \
  # --with-evtgen=TODO \
  # --with-fastjet=${HEPSW_FASTJET_DIR} \
  # --with-gosam=TODO  \
  # --with-gsl=TODO \
  # --with-hepmc=${HEPSW_HEPMC2_DIR} \
  # --with-lhapdf=${HEPSW_LHAPDF_DIR} \
  # --with-madgraph=TODO  \
  # --with-njet=TODO \
  # --with-openloops=${HEPSW_OPENLOOPS_DIR} \
  # --with-pythia=${HEPSW_PYTHIA_DIR} \
  # --with-rivet=${HEPSW_RIVET_DIR} \
  # --with-thepeg=TODO \
  # --with-vbfnlo=TODO \
  # --with-yoda=${HEPSW_RIVET_DIR} \


./herwig-bootstrap -j${NUM_CORES} \
  --with-fastjet=${HEPSW_FASTJET_DIR} --with-hepmc=${HEPSW_HEPMC2_DIR} \
  --with-lhapdf=${HEPSW_LHAPDF_DIR}   --with-yoda=${HEPSW_RIVET_DIR} \
  --with-rivet=${HEPSW_RIVET_DIR}     --with-openloops=${HEPSW_OPENLOOPS_DIR} \
  --with-boost=${HEPSW_BOOST_DIR}     --with-pythia=${HEPSW_PYTHIA_DIR} \
  --src-dir=${WORKING_DIR}/${package_name} ${InstallDir} || exit 2
rm -rf ${WORKING_DIR}/${package_name}
exit 0

## environment TODO
cd ${BASE_DIR}
cp ../TEMPLATEenv.sh ${InstallDir}/${name}env.sh
sed -i -e "s TEMPLATE_PREFIX ${InstallDir} g" ${InstallDir}/${name}env.sh
sed -i -e "s/TEMPLATE/${name}/g" ${InstallDir}/${name}env.sh
sed -i -e "s/#.export.PATH/export PATH/g" ${InstallDir}/${name}env.sh
sed -i -e "s/#.export.*//g" ${InstallDir}/${name}env.sh

## save dependences TODO
cd ${BASE_DIR}
# FastJet
printf "## ${HEPSW_FASTJET_NAME} ${HEPSW_FASTJET_VERSION}\n" \
  > ${InstallDir}/${name}dependences.sh
printf "source ${HEPSW_FASTJET_DIR}/${HEPSW_FASTJET_NAME}env.sh\n" \
  >> ${InstallDir}/${name}dependences.sh
# HepMC2
printf "## ${HEPSW_HEPMC2_NAME} ${HEPSW_HEPMC2_VERSION}\n" \
  >> ${InstallDir}/${name}dependences.sh
printf "source ${HEPSW_HEPMC2_DIR}/${HEPSW_HEPMC2_NAME}env.sh\n" \
  >> ${InstallDir}/${name}dependences.sh
