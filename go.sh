#!/bin/sh
make V=99
ls bin/ramips/ -l
cp bin/ramips/openwrt-ramips-mt7620a-mt7620a_mt7610e-initramfs-uImage.bin /ftp/

