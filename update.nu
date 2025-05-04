#!/usr/bin/env nu
for i in (ls ./* | where type == dir) {
  print $i.name
  cd $i.name
  nix flake update
  cd -
}

