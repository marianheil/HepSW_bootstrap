#!/usr/bin/env bash

source ../config
../init.sh

## package specific variables
InstallDir=${HEPSW_LHAPDF_DIR}

## download all PDF sets
all_pdfs=($(${InstallDir}/bin/lhapdf ls))
installed_pdfs=($(${InstallDir}/bin/lhapdf ls --installed))
failed_downloads=()
for PDF in ${all_pdfs[@]}
do
  if (echo "${installed_pdfs[@]}"  | fgrep -wq "${PDF}")
  then
    echo "${PDF} already installed"
  else
    wget --no-check-certificate ${HEPSW_LHAPDF_PDF_SOURCE}/${PDF}.tar.gz -O- \
      | tar xz -C ${InstallDir}/share/LHAPDF || failed_downloads+=(${PDF})
  fi
done

if [ ${#failed_downloads[@]} -eq 0 ];
then
  echo "All PDF sets successfully downloaded."
else
  echo "Download failed for ${#failed_downloads[@]}/${#all_pdfs[@]} PDFs:"
  echo ${failed_downloads[@]}
fi
