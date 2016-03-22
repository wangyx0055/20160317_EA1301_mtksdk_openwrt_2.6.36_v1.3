#!/bin/sh
make V=99
cp bin/ramips/openwrt-ramips-mt7620a-mt7620a_mt7610e-initramfs-uImage.bin /ftp/
ls /ftp/ -l

