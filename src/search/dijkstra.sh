ERROR_END_BEYOND_BOUNDS='Error: End index beyond entry bounds'
ERROR_START_BEYOND_BOUNDS='Error: Start index beyond entry bounds'

function deserialize_input {
  local -n p_entries=$1
  local raw="$2"

  for entry in ${raw[@]}; do
    local parts
    local -i key

    IFS="=" read -ra parts <<< $entry
    key=${parts[0]}
    p_entries[$key]=${parts[1]}
  done
}

function deserialize_edges {
  local -n p_edges=$1
  local raw="$2"

  local -a edges
  IFS="," read -ra edges <<< "${raw}"

  p_edges=("${edges[@]}")
}

function queue_dequeue {
  local -n r_queue=$1
  local -a new_array

  for (( i=1; i < ${#r_queue[@]}; i++ )); do
    local -i new_index=$(( i - 1))
    new_array[$new_index]=${r_queue[$i]}
  done

  r_queue=("${new_array[@]}")
}

function queue_insert {
  local -n r_queue=$1
  local -i key="$2"
  r_queue+=($key)
}

function dijkstra {
  local raw="$1"
  local start="$2"
  local end="$3"

  local -a entries

  deserialize_input entries "${raw}"

  if [ $start -ge ${#entries[@]} ]; then
    echo "${ERROR_START_BEYOND_BOUNDS}"
    exit 1
  fi
  if [ $end -ge ${#entries[@]} ]; then
    echo "${ERROR_END_BEYOND_BOUNDS}"
    exit 1
  fi

  local -a distances
  local -a queue
  local -a visited
  queue+=($start)

  for node in ${!entries[@]}; do 
    distances[$node]=$(getconf INT_MAX)
    visited[$node]=0
  done
  distances[$start]=0

  while [ ${#queue[@]} -gt 0 ]; do 
    local -a edges
    local -i current=${queue[0]}
    visited[$current]=1

    IFS="," read -ra edges <<< "${entries[$current]}"
    queue_dequeue queue 

    for edge in ${edges[@]}; do
      local -a pair
      IFS=":" read -ra pair <<< "$edge"
      local -i key=${pair[0]}
      local -i added_distance=${pair[1]}

      if [ ${visited[$key]} -eq 0 ]; then
        new_distance=$(( ${distances[$current]} + added_distance ))
        current_distance=${distances[$key]}

        if [ ${new_distance} -lt ${current_distance} ]; then
          distances[$key]=$new_distance
        fi

        queue_insert queue "${key}"
      fi
    done
  done

  echo ${distances[$end]}
}

function main {
  dijkstra "$@"
}
