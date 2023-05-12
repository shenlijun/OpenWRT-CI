#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
#echo 'src-git helloworld https://github.com/fw876/helloworld' >>feeds.conf.default
#echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall' >>feeds.conf.default
#sed -i "/helloworld/d" "feeds.conf.default"
#echo "src-git helloworld https://github.com/fw876/helloworld.git" >> "feeds.conf.default"

#Add vssr
#git clone https://github.com/jerrykuku/lua-maxminddb.git package/lean/lua-maxminddb
#git clone https://github.com/jerrykuku/luci-app-vssr.git package/lean/luci-app-vssr

#Add ssrp
git clone --depth=1 https://github.com/fw876/helloworld.git package/helloworld

#Add PassWall
#git clone -b packages https://github.com/xiaorouji/openwrt-passwall package/openwrt-passwall/packages
#git clone -b luci https://github.com/xiaorouji/openwrt-passwall package/openwrt-passwall/luci

#Add x550
git clone https://github.com/shenlijun/openwrt-x550-nbase-t package/openwrt-x550-nbase-t

#Use kernel 6.1
sed -i 's/KERNEL_PATCHVER:=5.15/KERNEL_PATCHVER:=6.1/' target/linux/x86/Makefile
