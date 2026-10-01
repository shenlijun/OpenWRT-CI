#!/bin/bash

##kernel from the master branch
wget https://github.com/immortalwrt/immortalwrt/archive/refs/heads/master.tar.gz
rm -rf target
tar -xzf master.tar.gz -C ./ --strip=1 "immortalwrt-master/target"
rm master.tar.gz
##End of kernel from the master branch

#Add ssrp
#git clone --depth=1 https://github.com/fw876/helloworld.git package/helloworld

#Add x550
#git clone https://github.com/shenlijun/openwrt-x550-nbase-t package/openwrt-x550-nbase-t  

