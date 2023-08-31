setup() {
  source counting-sort.sh
}

@test "Works with (3 2)" {
  run main "3 2 1"
  [ "$output" = "1 2 3" ]
  [ "$status" -eq 0 ]
}

@test "Works with (3 2 1 6)" {
  run main "3 2 1 6"
  [ "$output" = "1 2 3 6" ]
  [ "$status" -eq 0 ]
}

@test "Works with (3 2 1 6 6)" {
  run main "3 2 1 6 6"
  [ "$output" = "1 2 3 6 6" ]
  [ "$status" -eq 0 ]
}

@test "Works with (3 2 1 6 6 1 4 11 6 -5)" {
  run main "3 2 1 6 6 1 4 11 6 -5"
  [ "$output" = "-5 1 1 2 3 4 6 6 6 11" ]
  [ "$status" -eq 0 ]
}
