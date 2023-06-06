#!/bin/bash

#Add ssrp
git clone --depth=1 https://github.com/fw876/helloworld.git package/helloworld

#Add x550
git clone https://github.com/shenlijun/openwrt-x550-nbase-t package/openwrt-x550-nbase-t

#Change naive version
sed -i 's/113.0.5672.62-2/114.0.5735.91-3/' package/helloworld/naiveproxy/Makefile
sed -i 's/75db685789d550094343a76fdcbb6ea2bfcb708c3330af621ca532842251fb26/0b65a64362a2e218f5a6cb96b38adcf421cc222e8f2704e700b06842fca2df87/' package/helloworld/naiveproxy/Makefile

