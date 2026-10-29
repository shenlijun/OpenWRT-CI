#!/bin/bash

#Use kernel 6.1
#sed -i 's/KERNEL_PATCHVER:=5.15/KERNEL_PATCHVER:=6.1/' target/linux/x86/Makefile

#Use kernel 5.10
#sed -i 's/KERNEL_PATCHVER:=5.4/KERNEL_PATCHVER:=5.10/' target/linux/ramips/Makefile

# Modify default theme
sed -i 's/bootstrap/argon/' feeds/luci/modules/luci-base/root/etc/config/luci
sed -i 's/bootstrap/argon/' feeds/luci/collections/luci/Makefile
sed -i 's/bootstrap/argon/' feeds/luci/collections/luci-light/Makefile


##Openwrt-Passwall
rm -rf feeds/packages/net/{xray-core,v2ray-geodata,sing-box,chinadns-ng,dns2socks,hysteria,ipt2socks,microsocks,naiveproxy,shadowsocks-libev,shadowsocks-rust,shadowsocksr-libev,simple-obfs,tcping,trojan-plus,tuic-client,v2ray-plugin,xray-plugin,geoview,shadow-tls}
git clone https://github.com/Openwrt-Passwall/openwrt-passwall-packages package/passwall-packages

rm -rf feeds/luci/applications/luci-app-passwall
git clone https://github.com/Openwrt-Passwall/openwrt-passwall package/passwall-luci
##End of Openwrt-Passwall

##golang
rm -rf feeds/packages/lang/golang
git clone https://github.com/kenzok8/golang -b 1.27 feeds/packages/lang/golang
## End of golang

##dae
rm -rf feeds/luci/applications/luci-app-dae
rm -rf feeds/packages/net/dae
rm -rf feeds/packages/net/daed
git clone https://github.com/daeuniverse/openwrt-packages package/dae-packages
git clone --recurse-submodules https://github.com/daeuniverse/dae package/dae-packages/dae/src
##End of dae

##packages from the master branch
wget https://github.com/immortalwrt/packages/archive/refs/heads/master.tar.gz

#Rust
#tar -xzf master.tar.gz -C feeds/packages/lang/ --strip=2 "packages-master/lang/rust"
#sed -i 's/ci-llvm=true/ci-llvm=false/g' feeds/packages/lang/rust/Makefile

#Xray
#tar -xzf master.tar.gz -C feeds/packages/net/ --strip=2 "packages-master/net/xray-core"
#rm -rf ./feeds/packages/lang/golang
#tar -xzf master.tar.gz -C feeds/packages/lang/ --strip=2 "packages-master/lang/golang"
#sed -i 's/^PKG_VERSION.*/PKG_VERSION:=26.3.27/' feeds/packages/net/xray-core/Makefile
#sed -i 's/^PKG_HASH.*/PKG_HASH:=992a4997e6bb846d11469435d687f99ef812fcde1e0a009bb8e95189ea20331d/' feeds/packages/net/xray-core/Makefile

#OpenVPN
#rm -rf ./feeds/packages/net/openvpn
#tar -xzf master.tar.gz -C feeds/packages/net/ --strip=2 "packages-master/net/openvpn"

rm master.tar.gz
##End of packages from the master branch

##kernel from the master branch
#wget https://github.com/immortalwrt/immortalwrt/archive/refs/heads/master.tar.gz
#rm -rf target
#tar -xzf master.tar.gz -C ./ --strip=1 "immortalwrt-master/target"
#rm master.tar.gz
##End of kernel from the master branch

#mkdir -p staging_dir/host/bin
#ln -sf /usr/bin/go staging_dir/host/bin/go
#ln -sf /usr/bin/gofmt staging_dir/host/bin/gofmt
