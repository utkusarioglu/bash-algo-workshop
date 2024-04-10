parent() {
  local -i index="$1"
  echo $(( ($index - 1) / 2 ))
}

left_child() {
  local -i index="$1"
  echo $(( $index * 2 + 1 ))
}

right_child() {
  local -i index="$1"
  echo $(( $index * 2 + 2 ))
}

swap() {
  local -n r3_heap=$1 > /dev/null
  local -i index1="$2"
  local -i index2="$3"
  
  local -i temp=${r3_heap[$index1]}
  r3_heap[$index1]=${r3_heap[$index2]}
  r3_heap[$index2]=${temp}
}

insert() {
  local -n r2_heap=$1 > /dev/null
  local -i value="$2"

  r2_heap+=($value)

  local -i c="$(( ${#r2_heap[@]} - 1 ))"
  while [ $c -gt 0 ]; do
    local -i cv=${r2_heap[$c]}
    local -i p=$(parent $c)
    local -i pv=${r2_heap[$p]}
    if [ $pv -lt $cv ]; then
      swap r2_heap $c $p
      c=$p
    else 
      break
    fi
  done
}

max_heap() {
  local -a unsorted=("$@")
  local -a sorted=()
  local -n r1_heap=sorted
  
  for value in ${unsorted[@]}; do
    insert r1_heap $value
  done

  echo ${r1_heap[0]}
}

function main {
  max_heap "$@"
}
