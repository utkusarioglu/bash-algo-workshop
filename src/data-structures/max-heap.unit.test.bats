setup() {
  source max-heap.sh
}

declare -a PARAMS=(
  "1;1"
  "4 3 2;4"
  "5 2 1;5"
)

parametric_test() {
  local -a input=("$1")
  local -i expected=$2

  run main $input

  [ "$output" -eq $expected ]
  [ "$status" -eq 0 ]
}

main() {
  for param_str in "${PARAMS[@]}"; do
    local -a param
    IFS=";" read -ra param <<< $param_str
    local -a input=("${param[0]}")
    local -i expected=${param[1]}
    
    bats_test_function --description "${input[@]} => ${expected}" -- \
      parametric_test "${input[@]}" "${expected}"
  done
}

main
