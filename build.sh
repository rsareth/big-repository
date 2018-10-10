#!/bin/bash

set -e

__build_everything() {
  echo "Building everything ..."
  for i in $(find . -maxdepth 2 -name "package.json")
  do
    CURRENT_DIRECTORY_NAME=$(dirname $i | sed -re "s@\.\/@@g")
    cd "${CURRENT_DIRECTORY_NAME}"
    echo "---> ${CURRENT_DIRECTORY_NAME}"
    cd - > /dev/null
  done
}

__build_updated_directories() {
  echo "Building the updated directories ..."
  LIST=$(git diff --name-status master..HEAD | \
          sed -re 's/^[A-Z]//g' -e 's/^[[:space:]]*//' | \
          cut -d/ -f1)

  for i in $LIST
  do
    if [ -d $i -a -f $i/package.json ]
    then
      cd $i
      echo "---> $i"
      cd - > /dev/null
    fi
  done
}

CURRENT_BRANCH_NAME=$(git branch | cut -d" " -f2)
if [ "${CURRENT_BRANCH_NAME}" = "master" ]
then
  __build_everything
else
  __build_updated_directories
fi
