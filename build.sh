#!/bin/bash

set -e

__build_service() {
  SERVICE=$1

  if ! [ -d "${SERVICE}" ]
  then
    echo "The service \"${SERVICE}\" doesn't exist."
    return 1
  fi

  cd "${SERVICE}"
  echo "Building the service ${SERVICE} ..."
}

__build_everything() {
  echo "Building everything ..."
  for i in $(find . -depth 2 -name "package.json")
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

if [ -z $* ]
then
  CURRENT_BRANCH_NAME=$(git branch | cut -d" " -f2)
  if [ "${CURRENT_BRANCH_NAME}" = "master" ]
  then
    __build_everything
  else
    __build_updated_directories
  fi
else
  __build_service $1
fi
