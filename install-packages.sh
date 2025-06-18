#!/bin/bash

sudo pacman -S - < pacman-pkg-list.txt
yay -S - < yay-pkg-list.txt
