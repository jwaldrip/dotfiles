#!/usr/bin/env bash
curl -sSL https://raw.githubusercontent.com/jwaldrip/dotfiles/master/Makefile > ~/Makefile
make -C ~ init
