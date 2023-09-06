#!/bin/bash

function min_elem {
  declare -n arr_ref="$1"
  declare -i current=$((2**31-1))

  for key in ${!arr_ref[@]}; do
    elem=${arr_ref[$key]}
    if [[ $current -gt $elem ]]; then
      current=$elem
    fi
  done

  echo $current
}

function max_elem {
  declare -n arr_ref=$1
  declare -i current=0

  for key in ${!arr_ref[@]}; do  
    elem=${arr_ref[$key]}
    if [[ $current -lt $elem ]]; then
      current=$elem
    fi
  done

  echo $current
}

function counting_sort {
  declare -n unsorted_ref="$1"
  declare -a counts
  declare -a sorted
  
  min_value=$(min_elem unsorted)
  max_value=$(max_elem unsorted)

  for key in ${!unsorted_ref[@]}; do
    index=$((${unsorted_ref[$key]}-min_value))
    counts[$index]=$((counts[$index]+1))
  done

  for index in ${!counts[@]}; do
    count=${counts[$index]}
    value=$((index+min_value))
    if [ $count -gt 0 ]; then
      counter=0
      while [[ counter -lt $count ]]; do
        sorted+=($value)
        ((counter+=1))
      done
    fi
  done

  echo "${sorted[@]}"
}

function main {
  declare -a unsorted=($@)

  counting_sort unsorted 
}
