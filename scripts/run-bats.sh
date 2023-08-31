#!/bin/bash

function main {
  code_folder_path=$1
  test_filename=$2

  if [ -z "$code_folder_path" ]; then
    echo "Error: code folder path param is required"
    exit 1
  fi

  docker run -it -v "${PWD}/${code_folder_path}:/code" bats/bats:latest $test_filename
}

main $@
