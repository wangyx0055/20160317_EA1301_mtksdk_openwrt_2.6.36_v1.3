#
# Copyright (C) 2011 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

define Profile/MT7621_MT7602e_MT7612e_ePA
	NAME:=MT7621+MT7602e(ePA)+MT7612e(ePA)
	PACKAGES:=\
		-swconfig \
		ated hwnat reg gpio btnd switch ethstt uci2dat mii_mgr watchdog \
		wireless-tools wpad-mini wpa-supplicant \
		kmod-usb-core kmod-xhci kmod-usb-storage \
		kmod-ledtrig-usbdev block-mount \
		kmod-mt76x2e-epa \
		kmod-hw_nat kmod-mtk-watchdog \
		kmod-fs-vfat kmod-fs-ntfs kmod-nls-base kmod-nls-utf8 kmod-nls-cp936 kmod-nls-cp950
endef

define Profile/MT7621_MT7602e_MT7612e_ePA/Description
	MT7621 SOC board, with MT7602e-ePA and MT7612e-ePA
endef
$(eval $(call Profile,MT7621_MT7602e_MT7612e_ePA))

define Profile/MT7621_MT7602e_MT7612e_iPA
	NAME:=MT7621+MT7602e(iPA)+MT7612e(iPA)
	PACKAGES:=\
		-swconfig \
		ated hwnat reg gpio btnd switch ethstt uci2dat mii_mgr watchdog \
		wireless-tools wpad-mini wpa-supplicant \
		kmod-usb-core kmod-xhci kmod-usb-storage \
		kmod-ledtrig-usbdev block-mount \
		kmod-mt76x2e-ipa \
		kmod-hw_nat kmod-mtk-watchdog \
		kmod-fs-vfat kmod-fs-ntfs kmod-nls-base kmod-nls-utf8 kmod-nls-cp936 kmod-nls-cp950
endef

define Profile/MT7621_MT7602e_MT7612e_iPA/Description
	MT7621 SOC board, with MT7602e-iPA and MT7612e-iPA
endef
$(eval $(call Profile,MT7621_MT7602e_MT7612e_iPA))

