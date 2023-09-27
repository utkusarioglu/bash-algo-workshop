#!/bin/bash

LOG_PADDING=30
STYLE_TEXT_RED='\e[31m'
STYLE_TEXT_BOLD='\e[1m'
STYLE_BLINK='\e[5m'
STYLE_UNDERLINE='\e[4m'
STYLE_NONE='\e[0m'

UNIT_TEST_POSTFIX='unit.test.bats'

function log_error_cannot_find_file {
  filename=$1
  
  if [ -z "$filename" ]; then
    echo "Error: filename is required"
    exit 1
  fi

  styled_error="${STYLE_TEXT_RED}${STYLE_TEXT_BOLD}Error:${STYLE_NONE}"
  styled_filename="${STYLE_UNDERLINE}${filename}${STYLE_NONE}"

  echo -e "${styled_error} Cannot find the file ${styled_filename}"
}

function main {
  abspath_file_active=$1

  ifs_initial=$IFS
  separator_path='/'
  separator_extension='.'

  IFS=$separator_path
  abspath_file_active_arr=(${abspath_file_active[@]:1})
  base_file_active=${abspath_file_active_arr[-1]}
  abspath_file_active_arr_len=${#abspath_file_active_arr[@]}
  abspath_path_active_arr_len=$(( ${abspath_file_active_arr_len} - 1 ))
  abspath_path_active_arr=${abspath_file_active_arr[@]:0:${abspath_path_active_arr_len}}

  IFS=$separator_extension
  abspath_path_active="/${abspath_path_active_arr[@]// /$separator_path}"
  base_file_active_arr=(${base_file_active[@]})
  name_file_active=${base_file_active_arr[0]}
  extension_file_active=${base_file_active_arr[-1]}
  domain_file_active_length=$((${#base_file_active_arr[@]} - 2))
  domain_file_active_arr=$(
    [ ${domain_file_active_length} -gt 0 ] && \
      echo "${base_file_active_arr[@]:1:$domain_file_active_length}"
  )

  IFS=$ifs_initial
  domain_file_active=${domain_file_active_arr[@]// /$separator_extension}
  class_file_active="${domain_file_active:+"${domain_file_active}${separator_extension}"}${extension_file_active}"
  working_directory="$(pwd)"
  relpath_path_active="${abspath_path_active#$working_directory/}"

  base_test_file=$name_file_active.$UNIT_TEST_POSTFIX
  name_source_file="$name_file_active.sh"
  relpath_test_file="${relpath_path_active}/${base_test_file}"
  relpath_source_file="${relpath_path_active}/${name_source_file}"

  if [ -z "$relpath_test_file" ]; then
    log_error_cannot_find_file $relpath_test_file
    exit 1
  fi 

  if [ -z "$relpath_source_file" ]; then
    log_error_cannot_find_file $relpath_source_file
    exit 1
  fi

  docker run \
    -it \
    -v "${PWD}/${relpath_path_active}:/code" \
    bats/bats:latest \
    $base_test_file
}

main $@
