#!/usr/bin/env bash

## create basic folders
mkdir -p ${HEPSW_HOME}
mkdir -p ${WORKING_DIR}

# copy README
cp ../UserInfo/README.txt ${HEPSW_HOME}/README.txt
sed  -i -e "s HEPSW_HOME ${HEPSW_HOME} g" ${HEPSW_HOME}/README.txt

## init dependencies
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
  if [[ -e ${!dep_dir}/${!dep_name}dependencies.sh ]]; then
    source ${!dep_dir}/${!dep_name}dependencies.sh
  fi
done

source ${InstallDir}/${name}dependencies.sh
