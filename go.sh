#!/bin/sh
cp kernel/.config /ftp/kernel.config
cp .config /ftp/config.config
make V=99
cp bin/ramips/openwrt-ramips-mt7620a-mt7620a_mt7610e-initramfs-uImage.bin /ftp/
ls /ftp/ -l

