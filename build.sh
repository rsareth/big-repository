#!/bin/bash

set -e

__build_updated_directories() {
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
  echo "Build everything"
else
  echo "Building the updated directories"
  __build_updated_directories
fi
