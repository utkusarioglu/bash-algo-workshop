setup() {
  source bubble-sort.sh
}



declare -a PARAMS=(
  '1,0;0,1'
  '2,1,0;0,1,2'
  '1,2,3,4,5,6,7;1,2,3,4,5,6,7'
  '7,6,5,4,3,2,1;1,2,3,4,5,6,7'
)

function parametric_test() {
    local -a input=("$1")
    local -a expected=("$2")

    run main ${input[@]}

    [ "$output" = "${expected[@]}" ]
    [ "$status" -eq 0 ]
}

function main {
  for param_str in "${PARAMS[@]}"; do
      declare -a params
      IFS=";" read -ra params <<< $param_str

      input="${params[0]//,/' '}"
      expected="${params[1]//,/' '}"

      bats_test_function --description "${input} => ${expected}" -- \
        parametric_test "${input}" "${expected}"
  done
}

main
