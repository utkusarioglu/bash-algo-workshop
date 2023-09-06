#!/bin/bash

function insertion_sort {
  declare -n unsorted_ref=$1
  declare -i array_size=${#unsorted_ref[@]}
  
  for (( i=1; i<$array_size; i++ )); do
    for (( j=i; j > 0; j-- )); do
      if [ ${unsorted[$j - 1]} -lt ${unsorted[$j]} ]; then
        continue
      fi
      declare -i temp=${unsorted[$j]}
      unsorted[$j]=${unsorted[$j-1]}
      unsorted[$j-1]=$temp
    done
  done
  echo ${unsorted[@]}
}

function main {
  declare -a unsorted=($@)
  insertion_sort unsorted
}

main $@
