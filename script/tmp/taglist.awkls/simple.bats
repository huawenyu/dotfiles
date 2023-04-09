#!/usr/bin/env bats

@test "echo" {
  runtest -v --debug --all --srcdir `pwd`/wad.test
}
