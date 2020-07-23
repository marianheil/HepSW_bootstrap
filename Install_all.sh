#!/usr/bin/env bash
set -eo pipefail # exit when any command fails

function install() {
  echo "--------------------------------"
  echo "  Start building ${1}"
  echo "--------------------------------"
  cd ${1}
  ./${1}-Installer.sh
  cd ..
}

ALL_PACKAGES=(
  "boost"
  "CLHEP"
  "eigen"
  "FastJet"
  "FORM"
  "HepMC2"
  "LHAPDF"
  "OpenLoops"
  "QCDloop"
  "recola"
  "root"
  "swig"
  "yaml_cpp"
  "YODA"
  "HepMC3"
  "rivet"
  "HEJ"
  "Professor"
  "Pythia"
  "Sherpa"
  "EvtGen"
)

PYTHON2_PACKAGES=(
  "FastJet"
  "LHAPDF"
  "YODA"
  "rivet"
  "Professor"
  "Pythia"
  "Sherpa"
)

for package in ${ALL_PACKAGES[@]}; do
  install ${package}
done

export PYTHON=python2

for package in ${PYTHON2_PACKAGES[@]}; do
  install ${package}
done
