setup() {
  source merge-sort.sh
}

merge_sort_recursive_tester() {
  local -a input=($1)
  local -a expected=($2)

  local input_str="${input[@]}"
  local -a response=( $(merge_sort_recursive "${input_str}" ))
  
  for (( i=0; i < ${#expected[@]}; i++ )); do
    [ "${expected[$i]}" -eq "${response[$i]}" ]
  done
}

sort_parametric() {
  local -a PARAMS=(
    '1:1'
    '3 2 1:1 2 3'
    '1 2 3 5:1 2 3 5'
  )

  for params_str in "${PARAMS[@]}"; do
    local -a pair
    IFS=':' read -ra pair <<< $params_str
    local -a input="${pair[0]}"
    local -a expected="${pair[1]}"

    local description="${input[@]} => ${expected[@]}"
    bats_test_function --description "${description}" -- \
      merge_sort_recursive_tester "${input[@]}" "${expected[@]}"
  done
}

sort_parametric

# @test "aa" {
#   local -a response=($(merge_sort '3 2 1'))
#   local -a expected=(1 2 3)

#   for (( i=0; i < ${#expected[@]}; i++ )); do
#     echo "e: ${expected[$i]}"
#     echo "r: ${response[$i]}"
#     [ "${expected[$i]}" -eq "${response[$i]}" ]
#   done
# }
