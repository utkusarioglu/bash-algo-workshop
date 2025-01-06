function bubble_sort {
  local -a unsorted=($@)
  local -i has_changed=1
  
  while [ $has_changed -eq 1 ]; do
    has_changed=0
    for (( l=1; l < ${#unsorted[@]}; l++ )); do
      s=$(( l - 1 ))
      v_large=${unsorted[$l]}
      v_small=${unsorted[$s]}
      
      if [ $v_small -gt $v_large ]; then
        unsorted[$l]=$v_small
        unsorted[$s]=$v_large
        has_changed=1
      fi
    done
  done

  echo "${unsorted[*]}"
}

function main {
  bubble_sort "$@"
}
