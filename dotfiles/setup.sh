#!/usr/bin/env sh

for dir in */; do
    stow -t $HOME $dir
done
