setup() {
  source max-heap.sh
}

root_test() {
  local -a input=($1)
  local -i expected=$2
  local -a heap=()
  local -n r1_heap=heap

  for value in ${input[@]}; do
    insert r1_heap $value
  done

  run peek r1_heap

  [ "$output" -eq $expected ]
  [ "$status" -eq 0 ]
}

root_test_fixture() {
  local -a PARAMS=(
    # Happy
    "1;1"
    "4 3 2;4"
    "5 2 1;5"
  )

  for param_str in "${PARAMS[@]}"; do
    local -a param
    IFS=";" read -ra param <<< $param_str
    local -a input=("${param[0]}")
    local -i expected=${param[1]}
    local description="root: ${input[@]} => ${expected}"
    
    bats_test_function --description "${description}" -- \
      root_test "${input[@]}" "${expected}"
  done
}

sort_test() {
  local -a input=($1)
  local -a expected=($2)
  local -i length=${#input[@]}
  local -a heap=()
  local -n r1_heap=heap
  local -a sorted=()

  for (( i=0; i < ${#input[@]}; i++ )); do
    insert r1_heap ${input[i]}
  done
  for (( e=0; e < ${#expected[@]}; e++ )); do
    [ $(peek r1_heap) -eq ${expected[$e]} ] || return 1
    remove r1_heap
  done
}

sort_test_fixture() {
  local -a PARAMS=(
    # Happy
    '1:1'
    '3:3'
    '1 2 3:3 2 1'
    '1 2 3 5:5 3 2 1'
  )
  for param_str in "${PARAMS[@]}"; do
    local -a param
    IFS=":" read -ra param <<< $param_str
    local -a input=("${param[0]}")
    local -a expected=("${param[1]}")
    local description="sort: ${input[@]} => ${expected[@]}"

    bats_test_function --description "${description}" -- \
      sort_test "${input[@]}" "${expected[@]}"
  done
}

main() {
  root_test_fixture
  sort_test_fixture
}

main
