#!/bin/bash

#Use kernel 6.1
#sed -i 's/KERNEL_PATCHVER:=5.15/KERNEL_PATCHVER:=6.1/' target/linux/x86/Makefile

#Use kernel 5.10
#sed -i 's/KERNEL_PATCHVER:=5.4/KERNEL_PATCHVER:=5.10/' target/linux/ramips/Makefile

# Modify default theme
sed -i 's/bootstrap/argon/' feeds/luci/modules/luci-base/root/etc/config/luci
sed -i 's/bootstrap/argon/' feeds/luci/collections/luci/Makefile
sed -i 's/bootstrap/argon/' feeds/luci/collections/luci-light/Makefile


##Contents from the master branch
wget https://github.com/immortalwrt/packages/archive/refs/heads/master.tar.gz

#Rust
#tar -xzf master.tar.gz -C feeds/packages/lang/ --strip=2 "packages-master/lang/rust"

#Xray
tar -xzf master.tar.gz -C feeds/packages/net/ --strip=2 "packages-master/net/xray-core"
tar -xzf master.tar.gz -C feeds/packages/lang/ --strip=2 "packages-master/lang/golang"

sed -i 's/^PKG_VERSION.*/PKG_VERSION:=26.2.6/' feeds/packages/net/xray-core/Makefile
sed -i 's/^PKG_HASH.*/PKG_HASH:=a41f170a03fa25d9d39f23f344540b02336a5c893d97b1b837b9477f4b35bc7f/' feeds/packages/net/xray-core/Makefile

rm master.tar.gz
##End of contents from the master branch
