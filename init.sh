#!/usr/bin/env bash
rm -f ~/Makefile
curl -sSL https://raw.githubusercontent.com/jwaldrip/dotfiles/master/Makefile > ~/Makefile
make -C ~ init
