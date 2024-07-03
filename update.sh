#!/usr/bin/env fish
for i in ./*
  if ! test -d $i
    echo $i file
  else
    echo $i
    cd $i
    nix flake update
    cd -
  end
end
