#! /usr/bin/bats

setup() {
  source dijkstra.sh
}

# Happy cases
@test "Linear 2 nodes & 1 spaced" {
  run main '0=1:1 1=' 0 1

  [ "$output" -eq 1 ]
  [ "$status" -eq 0 ]
}

@test "Linear 5 nodes & 1 spaced" {
  run main '0=1:1 1=2:1 2=3:1 3=4:1 4=' 0 4

  [ "$output" -eq 4 ]
  [ "$status" -eq 0 ]
}


@test "Linear 5 nodes & 2 spaced" {
  run main '0=1:2 1=2:2 2=3:2 3=4:2 4=' 0 4

  [ "$output" -eq 8 ]
  [ "$status" -eq 0 ]
}

@test "Partially Cyclic 5 Nodes & 2 spaced" {
  run main '0=1:2,2:1 1=2:1,4:3 2=3:7 3=1:3 4=' 0 4
  
  [ "$output" -eq 5 ]
  [ "$status" -eq 0 ]
}

# Error
@test "Error: Start beyond bounds" {
  run main '0=1:1 1:' 5 6

  [ "$status" -eq 1 ]
}

@test "Error: End beyond bounds" {
  run main '0=1:1 1:' 0 6

  [ "$status" -eq 1 ]
}
