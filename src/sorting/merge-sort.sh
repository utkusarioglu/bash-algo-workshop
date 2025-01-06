function merge_sort_recursive {
  local -a unsorted=($1)
  local -i size=${#unsorted[@]}
  local -i VERY_BIG=100000

  if [ $size -eq 1 ]; then
    echo ${unsorted[0]}
    return 0
  fi

  local -i mid=$(( $size / 2 ))
  local -a left_unsorted="${unsorted[@]:0:$mid}"
  local -a right_unsorted="${unsorted[@]:$mid}"
  
  local -a left_sorted=($(merge_sort_recursive "${left_unsorted[@]}"))
  local -a right_sorted=($(merge_sort_recursive "${right_unsorted[@]}"))

  local -i left_size=${#left_sorted[@]}
  local -i right_size=${#right_sorted[@]}

  local -i li=0
  local -i ri=0
  local -a sorted=()
  local -i circuit_breaker=0

  while [ $li -lt $left_size ] || [ $ri -lt $right_size ]; do
    if [ $li -eq $left_size ]; then
      sorted+=("${right_sorted[$ri]}")
      (( ri++ ))
      continue
    elif [ $ri -eq $right_size ]; then
      sorted+=("${left_sorted[$li]}")
      (( li++ ))
      continue
    fi

    if [ "${left_sorted[$li]}" -lt "${right_sorted[$ri]}" ]; then
      sorted+=("${left_sorted[$li]}")
      (( li++ ))
    else
      sorted+=("${right_sorted[$ri]}")
      (( ri++ ))
    fi
  done

  echo "${sorted[@]}"
}

function merge_sort_iterative {
  local input="$1"
  local unsorted_s="${input//' '/';'}"

  echo "${unsorted_s}"
  echo $unsorted_s
}
