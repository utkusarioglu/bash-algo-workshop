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
  local -n r3_heap=$1 
  local -i index1="$2"
  local -i index2="$3"
  
  local -i temp=${r3_heap[$index1]}
  r3_heap[$index1]=${r3_heap[$index2]}
  r3_heap[$index2]=${temp}
}

insert() {
  local -n r2_heap=$1 
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

peek() {
  local -n r2_heap=$1
  local -i value="${r2_heap[0]}"
  echo $value
}

remove() {
  local -n r2_heap=$1
  local -i s_old=${#r2_heap[@]}
  local -i s_new=$(( $s_old - 1 ))
  local -i i_old=$s_new

  swap r2_heap 0 $i_old
  unset "r2_heap[$i_old]"

  local -i c=0
  while [ $c -lt $s_new ]; do
    local -i l=$(left_child $c)
    local -i r=$(right_child $c)
    local -i n=$c

    if [ $l -lt $s_new ] && [ ${r2_heap[$l]} -gt ${r2_heap[$n]} ]; then
      n=$l
    fi

    if [ $r -lt $s_new ] && [ ${r2_heap[$r]} -gt ${r2_heap[$n]} ]; then
      n=$r
    fi

    if [ $n -eq $c ]; then
      break;
    fi

    swap r2_heap $c $n
    c=$n
  done
}
